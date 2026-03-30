---
title: "Recopilación de Información del Proyecto"
lang: es
header-includes: |
  <style>
    html { background-color: #1e1e1e; color: #c5c8c6; }
    body {
      margin: 0 auto;
      max-width: 52em;
      padding: 50px;
      background-color: #252526;
      color: #c5c8c6;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      hyphens: auto;
      overflow-wrap: break-word;
      text-rendering: optimizeLegibility;
      font-kerning: normal;
      border-radius: 6px;
      box-shadow: 0 2px 16px rgba(0,0,0,0.6);
      line-height: 1.7;
    }
    @media (max-width: 600px) {
      body { font-size: 0.9em; padding: 12px; }
      h1 { font-size: 1.8em; }
    }
    @media print {
      html { background-color: white; }
      body { background-color: transparent; color: black; font-size: 12pt; }
      p, h2, h3 { orphans: 3; widows: 3; }
      h2, h3, h4 { page-break-after: avoid; }
    }
    p { margin: 1em 0; color: #c5c8c6; }
    a { color: #7ec0ed; }
    a:visited { color: #9872a2; }
    img { max-width: 100%; }
    svg { height: auto; max-width: 100%; }
    h1 { color: #7ec0ed; border-bottom: 3px solid #7ec0ed; padding-bottom: 8px; margin-top: 1.4em; }
    h2 { color: #9872a2; margin-top: 1.4em; }
    h3 { color: #7ec48c; margin-top: 1.4em; }
    h4, h5, h6 { color: #c5c8c6; margin-top: 1.4em; }
    h5, h6 { font-size: 1em; font-style: italic; }
    h6 { font-weight: normal; }
    strong { color: #7ec48c; }
    em { color: #b5cea8; }
    ol, ul { padding-left: 1.7em; margin-top: 1em; }
    li > ol, li > ul { margin-top: 0; }
    li { color: #c5c8c6; margin: 4px 0; }
    blockquote {
      margin: 1em 0 1em 1.7em;
      padding-left: 1em;
      border-left: 3px solid #9872a2;
      color: #808080;
    }
    code {
      font-family: Menlo, Monaco, Consolas, 'Lucida Console', monospace;
      font-size: 85%;
      background-color: #1e1e1e;
      color: #7ec48c;
      padding: 1px 4px;
      border-radius: 3px;
      hyphens: manual;
      white-space: pre-wrap;
    }
    pre {
      margin: 1em 0;
      overflow: auto;
      background-color: #1e1e1e;
      padding: 16px;
      border-radius: 5px;
      border-left: 4px solid #7ec0ed;
    }
    pre code { padding: 0; overflow: visible; overflow-wrap: normal; background-color: transparent; color: #c5c8c6; }
    hr { border: none; border-top: 2px solid #3e3e42; margin: 1.5em 0; }
    table { margin: 1em 0; border-collapse: collapse; width: 100%; overflow-x: auto; display: block; font-variant-numeric: lining-nums tabular-nums; }
    table caption { margin-bottom: 0.75em; color: #808080; }
    tbody { margin-top: 0.5em; border-top: 1px solid #3e3e42; border-bottom: 1px solid #3e3e42; }
    th { border-top: 1px solid #3e3e42; padding: 0.25em 0.5em; background-color: #2d2d2d; color: #7ec0ed; }
    td { padding: 0.125em 0.5em 0.25em 0.5em; color: #c5c8c6; border-bottom: 1px solid #3e3e42; }
    header { margin-bottom: 4em; text-align: center; }
    #TOC li { list-style: none; }
    #TOC ul { padding-left: 1.3em; }
    #TOC > ul { padding-left: 0; }
    #TOC a:not(:hover) { text-decoration: none; }
    span.smallcaps { font-variant: small-caps; }
    div.columns { display: flex; gap: min(4vw, 1.5em); }
    div.column { flex: auto; overflow-x: auto; }
    div.hanging-indent { margin-left: 1.5em; text-indent: -1.5em; }
    ul.task-list[class] { list-style: none; }
    ul.task-list li input[type="checkbox"] { font-size: inherit; width: 0.8em; margin: 0 0.8em 0.2em -1.6em; vertical-align: middle; }
    .display.math { display: block; text-align: center; margin: 0.5rem auto; }
    /* Override pandoc syntax highlighting for dark theme (Monokai Dimmed) */
    div.sourceCode { background-color: #1e1e1e; border-radius: 5px; border-left: 4px solid #7ec0ed; padding: 4px 0; margin: 1em 0; }
    pre.sourceCode { background-color: transparent; padding: 12px 16px; margin: 0; }
    code.sourceCode { background-color: transparent; color: #c5c8c6; }
    code span.kw { color: #9872a2; font-weight: bold; }  /* Keyword */
    code span.cf { color: #9872a2; font-weight: bold; }  /* ControlFlow */
    code span.ot { color: #9872a2; }                     /* Other */
    code span.fu { color: #7ec0ed; }                     /* Function */
    code span.dt { color: #7ec0ed; }                     /* DataType */
    code span.st { color: #7ec48c; }                     /* String */
    code span.ch { color: #7ec48c; }                     /* Char */
    code span.ss { color: #7ec48c; }                     /* SpecialString */
    code span.vs { color: #7ec48c; }                     /* VerbatimString */
    code span.im { color: #7ec48c; font-weight: normal; } /* Import */
    code span.dv { color: #b5cea8; }                     /* DecVal */
    code span.bn { color: #b5cea8; }                     /* BaseN */
    code span.fl { color: #b5cea8; }                     /* Float */
    code span.pp { color: #b5cea8; }                     /* Preprocessor */
    code span.co { color: #6a9955; font-style: italic; } /* Comment */
    code span.in { color: #6a9955; font-style: italic; } /* Information */
    code span.an { color: #6a9955; font-style: italic; } /* Annotation */
    code span.wa { color: #dcdcaa; font-style: italic; } /* Warning */
    code span.op { color: #c5c8c6; }                     /* Operator */
    code span.va { color: #9cdcfe; }                     /* Variable */
    code span.at { color: #9cdcfe; }                     /* Attribute */
    code span.sc { color: #7ec48c; }                     /* SpecialChar */
    code span.er { color: #f44747; font-weight: bold; }  /* Error */
    code span.al { color: #f44747; font-weight: bold; }  /* Alert */
    code span.ex { color: #c5c8c6; }                     /* Extension */
  </style>
---

## PROYECTO:

Desarrollo de Metodología Basada en Métodos de Ciencia de Datos para Predecir Indicadores de Calidad del Servicio (SAIDI y SAIFI)

## Objetivo del Proyecto


Desarrollar una metodología predictiva basada en ciencia de datos para anticipar los indicadores de calidad del servicio eléctrico SAIDI (System Average Interruption Duration Index) y SAIFI (System Average Interruption Frequency Index) en redes de distribución eléctrica de una empresa de energía en el Norte de Santander.

# Fuentes de información:


- Base regultoria de Activos - (BRAE)
- Sistema de Gestion de Interrupciones - Outage Management System  (OMS)
- Sistema de información Geografica - Geographic Information System (GIS)
- Sistema de Administración Comercial - (SAC)
- Sistema de Administración de Activos - Enterprise Asset Management(EAM) 
- Fuentes externas climatologicas (Ideam, DHIME)

## Nota sobre el sistema OMS

A partir del año 2023, la Electrificadora de Norte de Santander realizó una migración de su sistema de gestión de interrupciones. Como resultado, la recopilación de información de interrupciones eléctricas se realizó a partir de **dos bases de datos provenientes de sistemas distintos**:

- **OMS Energy** — sistema utilizado hasta antes de la migración, del cual se extrae la información histórica de interrupciones previas a 2023.
- **OMS SP7 de Siemens** — nuevo sistema implementado desde 2023, del cual se obtiene la información de interrupciones a partir de dicha fecha.

Esta dualidad de fuentes implica diferencias estructurales en los esquemas de datos (nombres de campos, codificaciones, granularidad) que fueron consideradas durante el proceso de integración y homologación de la información.

## Consulta_1 SQL — Extracción de eventos de interrupción

A continuación se muestra la información de evento extraida de la base regulatoria e historica del OR, base de datos BRAE:

```sql

SELECT DISTINCT FDD_CODIGOEVENTO AS ID_EVENTO
	  ,FDD_FINICIAL AS FECHA_DESCONEXION
	  ,FDD_FFINAL AS FECHA_CONEXION
	  ,'' AS ELEMENTO_FALLADO
FROM BRAE.QA_TFDDREGISTRO
WHERE TO_CHAR(FDD_FINICIAL,'YYYY') IN ('2021', '2022', '2023', '2024', '2025')  
AND FDD_EXCLUSION = 'NO EXCLUIDA'
AND FDD_CAUSA_SSPD NOT IN (1)
AND FDD_FFINAL IS NOT NULL;

```
>  Esta consulta genera 95.281 registros

**Muestra de resultados (5 registros):**

| ID_EVENTO | FECHA_DESCONEXION | FECHA_CONEXION | ELEMENTO_FALLADO |
|-----------|-------------------|----------------|------------------|
| 801851 | 14/03/21 06:59:00 | 14/03/21 09:30:00 |  |
| 787583 | 04/01/21 08:50:00 | 04/01/21 17:15:00 |  |
| 787496 | 03/01/21 14:18:14 | 03/01/21 14:40:42 |  |
| 787232 | 01/01/21 10:29:33 | 01/01/21 13:30:00 |  |
| 787455 | 03/01/21 10:34:23 | 03/01/21 13:30:00 |  |



Se puede notar que la consulta anterior no contiene asignado el elemento fallado, por lo que se debe realizar una busqueda de esta informacion en otras fuentes, y para ello se realiza el siguiente procedimiento:


## Consulta_2 SQL — Extracción del elemento causante de los eventos y tipo elemento

Se ejecuta el siguiente script, para traer de la base de datos SPARD-OMS los elementos fallados, se realiza esta busqueda dado que en la consulta anterior no se tiene asignado un elemento causante a al evento, esta primera parte substrae la información de la base de datos del sistema anterior que estuvo en operacion hasta abr-2023, sistema anterior OMS-SPARD de energy, por lo que exportaremos en esta consulta hasta la fecha de operación, para su posterior asignación:

```sql

SELECT DISTINCT MINICIAL as CODIGO_MANIOBRA
, TYPEEQUIP AS TIPO_EQUIPO
, BREAKER AS ELEMENTO_FALLADO
FROM OMS.INTERUPC@SPARD
LEFT JOIN OMS.MANIOBRAS@SPARD ON INTERUPC.MINICIAL = MANIOBRAS.CODE
WHERE TO_NUMBER(TO_CHAR(INTERUPC.FINICIAL, 'YYYY')) >= 2019
AND TIPO != 'PRUEBA'
AND CAUSA != 'PRUEBA'
AND INTERUPC.TYPEEQUIP != 'Transformer'

```
> Esta consutla genera 38.921 registros


**Muestra de resultados (8 registros):**


| CODIGO_MANIOBRA | TIPO_ELEMENTO | ELEMENTO_FALLADO | 
|-----------------|---------------|------------------|
| 653818 | MV User | RC123 |
| 652796 | MV User	| TIBG11 |
| 653346	| MV User |	BELC29 |
| 650436	 | Feeder |	TIBO11P |
| 655095	| Feeder |	SARC1 |
| 651957	| Feeder |	CONS65P |
| 655385	| Sourcebus |	ELTARRA34.5P |
| 649466 | Feeder |	PAMC2 |


## Consulta_3 SQL — Extracción del elemento causante de los eventos y tipo elemento

Se ejecuta el siguiente script python, para traer de las archivos .csv existentes de datos SP7-OMS los elementos fallados, se realiza esta busqueda dado que en la consulta anterior no se tiene asignado un elemento causante a al evento, esta segunda parte substrae la información de los archivos del sistema actual que se encuentra en operacion desde abr-2023 hasta la fecha, sistema actual OMS-SP7 de SIEMENS, por lo que recopilaremos la información leyendo las rutas donde se encuentra cada archivo correspondiente a cada mes, para su posterior asignación:

**Rutas de ubicación**

Perfecto. Pega esta versión (rutas protegidas con comillas invertidas para que no se dañen al convertir a HTML):

| RUTA_ARCHIVOS_INSUMO_SP7 |
|---|
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\04. ABR 2024\Validacion 9\Consulta_Eventos_Cens_Apertura_Cierre (7).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\05. MAY 2024\Validation 9\Consulta_Eventos_Cens_Apertura_Cierre.csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\06. JUN 2024\Validation 9\Consulta_Eventos_Cens_Apertura_Cierre.csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\07. JUL 2024\Validation 23\Consulta_Eventos_Cens_Apertura_Cierre (9).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\08. AGO 2024\Validation 28\Consulta_Eventos_Cens_Apertura_Cierre (ago 2024).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\09-SEP 2024\Validacion 19\Consulta_Eventos_Cens_Apertura_Cierre (9).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\10-OCT 2024\Validacion 12\Consulta_Eventos_Cens_Apertura_Cierre (13).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\11-NOV 2024\Validación 8\Consulta_Eventos_Cens_Apertura_Cierre (10).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2024\12-DIC-2024\Validacion 11\Consulta_Eventos_Cens_Apertura_Cierre (13).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\01. Enero\Validación 3\Consulta_Eventos_Cens_Apertura_Cierre (13).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\02. Febrero\Validación 2\Consulta_Eventos_Cens_Apertura_Cierre (10).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\03. Marzo\Validacion 2\Consulta_Eventos_Cens_Apertura_Cierre (10).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\04. Abril\Validacion 2\Consulta_Eventos_Cens_Apertura_Cierre (11).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\05. Mayo\Validacion 4\Consulta_Eventos_Cens_Apertura_Cierre (15).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\06. Junio\Validación 6\Consulta_Eventos_Cens_Apertura_Cierre (16).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\07. Julio\Validación 5\Consulta_Eventos_Cens_Apertura_Cierre (18).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\08. Agosto\VALIDACION 9\Consulta_Eventos_Cens_Apertura_Cierre (18).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\09. Septiembre\Validacion 5\Consulta_Eventos_Cens_Apertura_Cierre (18).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\10. Octubre\validacion 8\Consulta_Eventos_Cens_Apertura_Cierre (18).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\11. Noviembre\Validacion 6\Consulta_Eventos_Cens_Apertura_Cierre (20).csv` |
| `D:\OneDrive - Grupo EPM\1-OPERACION Y CALIDADAD\QEnergia\REPORTES MM\2025\12. Diciembre\Validacion 6\Consulta_Eventos_Cens_Apertura_Cierre (20).csv` |


Se utliza el siguiente codigo python para concatenar los archivos teniendo en cuenta la informacion requeridad y epecifica en el contexto de extraccion del tipo de elemento y id del elemento causante de cada evento, para su posterior asignacion.

```python
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

```
> Se obtienen 81.340 registros


**Muestra de resultados (5 registros):**

| Maniobra Apertura | Tipo Elemento | Elemento_Falla |
|---|---|---|
| 424000000000114424 | Transformador de distribucion | 1T07942 |
| 124000000000269842 | Fusible | F1979 |
| 124000000000269842 | Transformador de distribucion | F1979 |
| 124000000000273378 | Fusible | F2004 |
| 124000000000269851 | Fusible | F2000 |




## Consulta_4 SQL — Extracción del inventario del tipo de elemento

Se ejecuta el siguiente script, para traer de la base de datos GTECH (GIS) el inventario de elementos de interrupción, para su posterior asignación:

```sql

(SELECT nodo_transform_v AS ELEMENTO
, coor_gps_lat AS LATITUD
, coor_gps_lon AS LONGITUD
, coor_z AS ALTITUD
, 'Transformador' AS tipo 
, ubicacion FROM ccomun@gtech  c    
JOIN cconectividad_e@gtech  USING (g3e_fid) 
WHERE c.estado = 'OPERACION' AND c.g3e_fno = 20400)
UNION
(SELECT r.codigo
, coor_gps_lat
, coor_gps_lon
, coor_z
, 'Reconectador' as tipo
, ubicacion FROM ereconec_at@gtech  r    
JOIN ccomun@gtech  c USING (g3e_fid)    
JOIN cconectividad_e@gtech USING (g3e_fid) 
WHERE c.estado = 'OPERACION')
UNION
(SELECT r.codigo
, coor_gps_lat
, coor_gps_lon, coor_z
, 'Interruptor' as tipo
, ubicacion FROM einterru_at@gtech  r    
JOIN ccomun@gtech  c USING (g3e_fid)    
JOIN cconectividad_e@gtech  USING (g3e_fid)
WHERE c.estado = 'OPERACION')
UNION
(SELECT cu.codigo
, coor_gps_lat
, coor_gps_lon, coor_z
, 'Cuchilla' AS tipo
, ubicacion 
FROM ecuchill_at@gtech cu    
JOIN ccomun@gtech c USING (g3e_fid)    
JOIN cconectividad_e@gtech USING (g3e_fid) 
WHERE c.estado = 'OPERACION')
UNION
(SELECT ai.codigo
, coor_gps_lat
, coor_gps_lon
, coor_z
, 'Aisladero' AS tipo
, ubicacion 
FROM eaislade_at@gtech ai    
JOIN ccomun@gtech c USING (g3e_fid)    
JOIN cconectividad_e@gtech USING (g3e_fid)
WHERE c.estado = 'OPERACION')
UNION
(SELECT codigo_operativo
, coor_gps_lat
, coor_gps_lon, coor_z
, 'Aisladero' AS tipo
, ubicacion 
FROM eaislade_at@gtech ai    
JOIN ccomun@gtech c USING (g3e_fid)    
JOIN cconectividad_e@gtech USING (g3e_fid) 
WHERE c.estado = 'OPERACION')
UNION
(SELECT codigo_operativo
, coor_gps_lat
, coor_gps_lon
, coor_z
, 'Cuchilla' AS tipo
, ubicacion FROM ecuchill_at@gtech cu    
JOIN ccomun@gtech c USING (g3e_fid)    
JOIN cconectividad_e@gtech USING (g3e_fid) 
WHERE c.estado = 'OPERACION')
UNION
(SELECT codigo_operativo
, coor_gps_lat
, coor_gps_lon
, coor_z
, 'Interruptor' as tipo
, ubicacion 
FROM einterru_at@gtech r    
JOIN ccomun@gtech c USING (g3e_fid)    
JOIN cconectividad_e@gtech USING (g3e_fid) 
WHERE c.estado = 'OPERACION')
;

```
> Esta consutla genera 47.751 registros


**Muestra de resultados (8 registros):**

| ELEMENTO | LATITUD | LONGITUD | ALTITUD | TIPO | UBICACION |
|---|---:|---:|---:|---|---|
| 1T00001 | 7.917491919 | -72.501995422 | 296 | Transformador | AVE AEROPUERTO CLL 18N |
| 1T00002 | 7.920237054 | -72.499636932 | 289 | Transformador | AV 6  23N-05 PRADOS NORTE |
| 1T00003 | 7.920535966 | -72.498614081 | 287 | Transformador | AV LIBERTADORES 5 Y 6 |
| 1T00004 | 7.92045106 | -72.499581721 | 290 | Transformador | AVE 6 23N-25 B/PRADOS DEL NORTE |
| 1T00005 | 7.918228719 | -72.493703848 | 286 | Transformador | AVE LBTDORES CLL 19N |
| 1T00006 | 7.918835719 | -72.492650809 | 285 | Transformador | CL 20BN 3-108 |
| 1T00007 | 7.918644514 | -72.493708601 | 285 | Transformador | AV 3 19N-22 M GRANAHORRA |
| 1T00008 | 7.918019396 | -72.492614955 | 284 | Transformador | AVE 4  20N-03 TASAJERO |



Para la el cruce de informacion y consolidacion de la data se proponen los siguientes propuestas de muestreo:

> por mes tomar entre 100 o 1000 datos 

> realizar una grafica de distribucion

> realizar de variables meteorologicas por zonas

> Agrupacion de zonas antes de asignar variables meteorologicas

### **Antieguedad de activos**

Para la recolección del atributo **antiguedad de activo** es mejor no tener en cuenta la antiguedad de los activos causantes, dado que posiblemente los activos sean nuevos pero el fallo se puede deber a la antiguedad de la red mas precisamente a y otros facotores que induce a que los elementos generen una desconexion, por lo que se podria buscar variables que apliquen mas a las deconexiones tales como:

- Antiguedad de la red 
- Extension de la red
- Cantidad de transformadores
- Cantidad de usuarios



