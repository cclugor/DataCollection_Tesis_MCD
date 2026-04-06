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

archivo_entrada = r"C:\Users\User\Downloads\ELEMENTO_FALLA_PIVOTE (1).xlsx"

carpeta_salida = r"C:\Users\User\Downloads\nasa_power_por_mes"
archivo_consolidado = r"C:\Users\User\Downloads\nasa_power_consolidado.csv"

os.makedirs(carpeta_salida, exist_ok=True)

col_id = "ID_ACTIVO_ELECTRICO"
col_lat = "LATITUD"
col_lon = "LONGITUD"

parametros_nasa = ("PRECTOT", "T2M", "T2M_MAX", "T2M_MIN", "RH2M", "WS2M")

session = requests.Session()

# ==========================
# FUNCIONES
# ==========================
import time
def nasa_power_daily_point_csv_text(lat, lon, retries=3):
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

    for intento in range(retries):
        try:
            r = session.get(url, params=params, timeout=60)

            if r.status_code == 200:
                return r.text
            time.sleep(2 * (intento + 1))  # backoff

        except:
            time.sleep(2 * (intento + 1))

    return None


def extraer_tabla_power(csv_text):
    if csv_text is None:
        return None

    lineas = [l for l in csv_text.splitlines() if l.strip()]

    # Buscar encabezado dinámicamente
    inicio = None
    for i, linea in enumerate(lineas):
        if any(x in linea.upper() for x in ["YEAR", "DATE"]):
            inicio = i
            break

    if inicio is None:
        return None

    try:
        df = pd.read_csv(StringIO("\n".join(lineas[inicio:])), engine="python")
    except:
        return None

    # Manejo fechas robusto
    if {"YEAR", "MO", "DY"}.issubset(df.columns):
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
        return None

    return df



def leer_excel(ruta):
    df = pd.read_excel(ruta, dtype=str)
    df.columns = [c.strip().upper().replace("\ufeff", "") for c in df.columns]
    return df


def normalizar_numero(valor):
    try:
        return float(str(valor).replace(",", "."))
    except:
        return None


# ==========================
# CARGA DATOS
# ==========================
df_origen = leer_excel(archivo_entrada)

# 🔥 OPTIMIZACIÓN CLAVE: SOLO COORDENADAS ÚNICAS
df_coords = df_origen[[col_lat, col_lon]].drop_duplicates()

df_coords = df_coords.sample(50)

print("Total coordenadas únicas:", len(df_coords))


# ==========================
# PROCESAMIENTO PARALELO
# ==========================
resultados = []

def procesar_coord(row):
    lat = normalizar_numero(row[col_lat])
    lon = normalizar_numero(row[col_lon])

    if lat is None or lon is None:
        return None

    try:
        respuesta = nasa_power_daily_point_csv_text(lat, lon)

        if respuesta is None:
            return None
        df_res = extraer_tabla_power(respuesta)

        # 🔴 VALIDACIONES CRÍTICAS
        if df_res is None or df_res.empty:
            return None

        if "fecha_consulta" not in df_res.columns:
            return None

        df_res["latitud"] = lat
        df_res["longitud"] = lon

        return df_res

    except:
        return None


lat = 4.6097
lon = -74.0817

respuesta = nasa_power_daily_point_csv_text(lat, lon)

print("¿Respuesta nula?:", respuesta is None)

if respuesta:
    print("\n=== PRIMERAS 20 LÍNEAS DEL CSV ===\n")
    print("\n".join(respuesta.splitlines()[:20]))

    df_test = extraer_tabla_power(respuesta)

    if df_test is None:
        print("\n❌ No se pudo parsear el CSV")
    else:
        print("\n✅ DataFrame generado")
        print(df_test.head())
        print(df_test.columns)
        print("Filas:", len(df_test))