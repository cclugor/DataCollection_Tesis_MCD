import pandas as pd

def concatenar_dfs(path_inicial=None):
  columnas_necesarias = ['Maniobra Apertura', 'Tipo Elemento', 'Elemento_Falla']
  dataframes = []

  ruta_actual = path_inicial

  while True:
    if not ruta_actual:
      ruta_actual = input("Ingrese la ruta del archivo CSV (Enter para terminar): ").strip()

    if not ruta_actual:
      break

    try:
      df = pd.read_csv(ruta_actual)
      df.columns = df.columns.str.strip()
      df = df[columnas_necesarias].drop_duplicates()
      dataframes.append(df)
      print(f"Archivo agregado: {ruta_actual} | filas: {len(df)}")
    except Exception as error:
      print(f"Error al leer/procesar '{ruta_actual}': {error}")
      print("Se retorna el acumulado cargado hasta ahora.")
      break

    ruta_actual = None

  if not dataframes:
    return pd.DataFrame(columns=columnas_necesarias)

  return pd.concat(dataframes, ignore_index=True)


def guardar_df_csv(df, ruta_salida):
  try:
    df.to_csv(ruta_salida, index=False, encoding="utf-8-sig")
    print(f"Archivo concatenado guardado en: {ruta_salida}")
  except Exception as error:
    print(f"No fue posible guardar el archivo '{ruta_salida}': {error}")


if __name__ == "__main__":
  df = concatenar_dfs()
  print(df.shape)
  ruta_salida = "DATA/tabla_elemento_fallado_2.csv"
  guardar_df_csv(df, ruta_salida)