import requests
import pandas as pd
from io import StringIO
import os
from concurrent.futures import ThreadPoolExecutor, as_completed

# ==========================
# CONFIGURACIÓN
# ==========================
fecha_inicial = "20210101"
fecha_final = "20251231"

## rutas de Cindy 
archivo_entrada = r"C:\Users\User\Downloads\ELEMENTO_FALLA_CUADRANTE.xlsx"

carpeta_salida = r"C:\Users\User\Downloads\nasa_power_cuadrantes"
archivo_consolidado = r"C:\Users\User\Downloads\nasa_power_consolidado.csv"

os.makedirs(carpeta_salida, exist_ok=True)

col_cuadrante = "OBJECTID"
col_lon_cuadrante = "POINT_X"
col_lat_cuadrante = "POINT_Y"

parametros_nasa = ("PRECTOT", "T2M", "T2M_MAX", "T2M_MIN", "RH2M", "WS2M")

# ⚡ sesión reutilizable (más rápido)
session = requests.Session()


# ==========================
# FUNCIONES
# ==========================
def nasa_power_daily_point_csv_text(lat, lon):
    url = "https://power.larc.nasa.gov/api/temporal/daily/point"
    params = {
        "parameters": ",".join(parametros_nasa),
        "community": "AG",
        "longitude": lon,
        "latitude": lat,
        "start": fecha_inicial,
        "end": fecha_final,
        "format": "CSV"
    }

    r = session.get(url, params=params, timeout=60)
    r.raise_for_status()
    return r.text


def extraer_tabla_power(csv_text):
    if csv_text is None:
        return None

    lineas = [l.strip() for l in csv_text.splitlines() if l.strip()]

    # 🔥 Encontrar fin del header
    try:
        idx_header_end = next(i for i, l in enumerate(lineas) if "-END HEADER-" in l)
        data_lines = lineas[idx_header_end + 1:]
    except StopIteration:
        print("⚠️ No se encontró '-END HEADER-'")
        return None

    # 🔥 Convertir a DataFrame de forma robusta
    try:
        df = pd.read_csv(
            StringIO("\n".join(data_lines)),
            engine="python",
            on_bad_lines="skip"
        )
    except Exception as e:
        print("⚠️ Error leyendo CSV:", e)
        return None

    # ==========================
    # LIMPIEZA COLUMNAS
    # ==========================
    df.columns = [c.strip().upper() for c in df.columns]

    # ==========================
    # MANEJO DE FECHAS
    # ==========================
    if {"YEAR", "DOY"}.issubset(df.columns):
        df["fecha_consulta"] = pd.to_datetime(
            df["YEAR"].astype(str) + df["DOY"].astype(str).str.zfill(3),
            format="%Y%j",
            errors="coerce"
        )
        df.drop(columns=["YEAR", "DOY"], inplace=True)

    elif {"YEAR", "MO", "DY"}.issubset(df.columns):
        df["fecha_consulta"] = pd.to_datetime(
            df["YEAR"].astype(str) + "-" +
            df["MO"].astype(str).str.zfill(2) + "-" +
            df["DY"].astype(str).str.zfill(2),
            errors="coerce"
        )
        df.drop(columns=["YEAR", "MO", "DY"], inplace=True)

    elif "DATE" in df.columns:
        df["fecha_consulta"] = pd.to_datetime(
            df["DATE"], format="%Y%m%d", errors="coerce"
        )
        df.drop(columns=["DATE"], inplace=True)

    else:
        print("⚠️ No se pudo construir fecha")
        return None

    # 🔥 Eliminar filas sin fecha (ruido residual)
    df = df[df["fecha_consulta"].notna()]

    return df if not df.empty else None


def leer_excel(ruta):
    df = pd.read_excel(ruta, dtype=str)
    df.columns = [c.strip().upper().replace("\ufeff", "") for c in df.columns]
    return df


def normalizar_numero(valor):
    if not valor:
        return None
    try:
        return float(str(valor).replace(",", "."))
    except:
        return None


# ==========================
# CARGA DATOS
# ==========================
df_origen = leer_excel(archivo_entrada)

# ⚡ agrupar una sola vez (más eficiente)
grupos = df_origen.groupby(col_cuadrante)

cuadrantes = list(grupos.groups.keys())

print("Total cuadrantes:", len(cuadrantes))


# ==========================
# FUNCIÓN PRINCIPAL
# ==========================
def procesar_cuadrante(cuadrante):
    archivo_cuadrante = os.path.join(
        carpeta_salida,
        f"cuadrante_{cuadrante}.csv"
    )

    if os.path.exists(archivo_cuadrante):
        return f"{cuadrante} (omitido)"

    df_filtrado = grupos.get_group(cuadrante)

    df_coords = df_filtrado[[col_lat_cuadrante, col_lon_cuadrante]].drop_duplicates()
    df_coords = df_coords.sample(100)
    lat = normalizar_numero(df_coords.iloc[0][col_lat_cuadrante])
    lon = normalizar_numero(df_coords.iloc[0][col_lon_cuadrante])

    if lat is None or lon is None:
        return f"{cuadrante} (coords inválidas)"

    try:
        respuesta = nasa_power_daily_point_csv_text(lat, lon)
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

        return f"{cuadrante} ✔"

    except Exception as e:
        return f"{cuadrante} ✖ {e}"


# ==========================
# EJECUCIÓN PARALELA
# ==========================
print("\nProcesando en paralelo...")

max_workers = 8  

with ThreadPoolExecutor(max_workers=max_workers) as executor:
    futures = [executor.submit(procesar_cuadrante, c) for c in cuadrantes]

    for future in as_completed(futures):
        print(future.result())


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