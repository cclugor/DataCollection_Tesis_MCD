import requests
import pandas as pd
from io import StringIO
import os

# ==========================
# CONFIGURACIÓN
# ==========================
fecha_inicial = "20210101"
#fecha_inicial = "20210101"
fecha_final = "20251231"

archivo_entrada = r"C:\Users\User\Downloads\ELEMENTO_FALLA_CUADRANTE.xlsx"

carpeta_salida = r"C:\Users\User\Downloads\nasa_power_cuadrantes"
archivo_consolidado = r"C:\Users\User\Downloads\nasa_power_consolidado.csv"

os.makedirs(carpeta_salida, exist_ok=True)

# Columnas 
col_cuadrante = "OBJECTID"
col_lon_cuadrante = "POINT_X"  # longitud
col_lat_cuadrante = "POINT_Y"  # latitud

parametros_nasa = ("PRECTOT", "T2M", "T2M_MAX", "T2M_MIN", "RH2M", "WS2M")

# ==========================
# FUNCIONES
# ==========================
def nasa_power_daily_point_csv_text(lat, lon, start, end, parameters):
    url = "https://power.larc.nasa.gov/api/temporal/daily/point"
    params = {
        "parameters": ",".join(parameters),
        "community": "AG",
        "longitude": lon,
        "latitude": lat,
        "start": start,
        "end": end,
        "format": "CSV"
    }

    r = requests.get(url, params=params, timeout=60)
    r.raise_for_status()
    return r.text

def extraer_tabla_power(csv_text):
    lineas = [l for l in csv_text.splitlines() if l.strip()]

    inicio = None
    for i, linea in enumerate(lineas):
        if linea.upper().startswith(("YEAR,MO,DY", "YEAR,DOY", "DATE,")):
            inicio = i
            break

    if inicio is None:
        raise ValueError("No se encontró tabla en NASA")

    df = pd.read_csv(StringIO("\n".join(lineas[inicio:])), engine="python")

    print("Columnas NASA:", df.columns.tolist())

    # ==========================
    # MANEJO DE FECHAS
    # ==========================
    if {"YEAR", "MO", "DY"}.issubset(df.columns):
        df["fecha_consulta"] = pd.to_datetime(
            df["YEAR"].astype(str) + "-" +
            df["MO"].astype(str).str.zfill(2) + "-" +
            df["DY"].astype(str).str.zfill(2),
            errors="coerce"
        )
        df.drop(columns=["YEAR", "MO", "DY"], inplace=True)

    elif {"YEAR", "DOY"}.issubset(df.columns):
        df["fecha_consulta"] = (
            pd.to_datetime(df["YEAR"].astype(str), format="%Y", errors="coerce")
            + pd.to_timedelta(df["DOY"] - 1, unit="D")
        )
        df.drop(columns=["YEAR", "DOY"], inplace=True)

    elif "DATE" in df.columns:
        # 👈 ESTE ERA EL QUE TE FALTABA
        df["fecha_consulta"] = pd.to_datetime(df["DATE"], format="%Y%m%d", errors="coerce")
        df.drop(columns=["DATE"], inplace=True)

    else:
        raise ValueError("Formato de fecha no reconocido")

    print("Filas extraídas:", len(df))
    print(df.head())

    return df


def leer_excel(ruta):
    df = pd.read_excel(ruta, dtype=str)

    # limpiar columnas
    df.columns = [c.strip().upper().replace("\ufeff", "") for c in df.columns]

    print("Columnas detectadas:", df.columns.tolist())

    return df


def normalizar_numero(valor):
    if not valor:
        return None

    texto = str(valor).strip().replace(",", ".")

    try:
        return float(texto)
    except:
        return None


# ==========================
# PROCESO
# ==========================
df_origen = leer_excel(archivo_entrada)

# Validación clave
print(df_origen.head())

cuadrantes = df_origen[col_cuadrante].astype(str).str.strip().unique()

print("Total cuadrantes:", len(cuadrantes))


# ==========================
# DESCARGA POR CUADRANTE
# ==========================
for i, cuadrante in enumerate(cuadrantes, start=1):

    print(f"\n[{i}/{len(cuadrantes)}] Cuadrante {cuadrante}")

    archivo_cuadrante = os.path.join(
        carpeta_salida,
        f"cuadrante_{cuadrante}.csv"
    )

    if os.path.exists(archivo_cuadrante):
        print("Ya existe, se omite.")
        continue

    df_filtrado = df_origen[
        df_origen[col_cuadrante].astype(str).str.strip() == str(cuadrante)
    ]

    df_coords = df_filtrado[[col_lat_cuadrante, col_lon_cuadrante]].drop_duplicates()

    lat = normalizar_numero(df_coords.iloc[0][col_lat_cuadrante])
    lon = normalizar_numero(df_coords.iloc[0][col_lon_cuadrante])

    if lat is None or lon is None:
        print("Coordenadas inválidas.")
        continue

    try:
        respuesta = nasa_power_daily_point_csv_text(
            lat, lon, fecha_inicial, fecha_final, parametros_nasa
        )

        df_res = extraer_tabla_power(respuesta)

        df_res["id_cuadrante"] = cuadrante
        df_res["latitud_cuadrante"] = lat
        df_res["longitud_cuadrante"] = lon
        df_res["cantidad_elementos_cuadrante"] = len(df_filtrado)

        df_res.rename(columns={
            "PRECTOT": "precipitacion_total_mm",
            "PRECTOTCORR": "precipitacion_total_mm",
            "T2M": "temperatura_media_c",
            "T2M_MAX": "temperatura_maxima_c",
            "T2M_MIN": "temperatura_minima_c",
            "RH2M": "humedad_relativa_pct",
            "WS2M": "velocidad_viento_ms"
        }, inplace=True)

        df_res.to_csv(archivo_cuadrante, index=False, encoding="utf-8-sig")

        print("Guardado ✔")

    except Exception as e:
        print("Error ✖:", e)


print("\nDescarga terminada.")


# ==========================
# CONSOLIDACIÓN
# ==========================
print("\nConsolidando archivos...")

archivos = [
    os.path.join(carpeta_salida, f)
    for f in os.listdir(carpeta_salida)
    if f.endswith(".csv")
]

lista_df = []

for archivo in archivos:
    try:
        df = pd.read_csv(archivo)
        lista_df.append(df)
    except Exception as e:
        print(f"Error leyendo {archivo}: {e}")

if lista_df:
    df_final = pd.concat(lista_df, ignore_index=True)
    df_final.to_csv(archivo_consolidado, index=False, encoding="utf-8-sig")

    print("Consolidado listo ✔")
    print("Archivo final:", archivo_consolidado)
else:
    print("No hay datos para consolidar.")