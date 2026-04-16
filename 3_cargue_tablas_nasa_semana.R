# 📊 Capítulo X. Análisis Exploratorio de Variables Climáticas por Cuadrante
# 1. Objetivo del análisis
# 
# El objetivo de esta sección es caracterizar la variabilidad temporal y espacial de las variables climatológicas agregadas semanalmente, con énfasis en:
#   
# Identificar diferencias entre cuadrantes
# Detectar eventos extremos
# Evaluar correlaciones relevantes
# Generar insumos para la modelación predictiva
# Mi unidad de muestreo son cuadrantes por semana.

# 2. Preparación de datos
library(dplyr)
library(ggplot2)
library(tidyr)
library(lubridate)
library(readr)
library(readxl)

# 🧱 1. Cargar y preparar datos base
# 📍 1.1 Coordenadas de cuadrantes

CUADRANTE_COORD <- read_excel("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/Distribución de Cuadrantes/CUADRANTE_CORD_800.xls") %>%
  rename(
    id_cuadrante = OBJECTID,
    longitud = POINT_X,
    latitud = POINT_Y
  )

# 🌦️ 1.2 Clima diario
nasa_power_consolidado <- read_csv("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/Distribución de Cuadrantes/Output_Raw_API_NASA/nasa_power_consolidado.csv")

# ⚡ 1.3 Tabla de Eventos

tabla_eventos_ajustado <- read_csv("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/tabla_eventos_ajustado.csv")
head(tabla_eventos_ajustado)


tabla_eventos_ajustado_1 <- tabla_eventos_ajustado %>%
  mutate(
    FECHA_DESCONEXION = dmy_hm(FECHA_DESCONEXION),
    FECHA_CONEXION = dmy_hm(FECHA_CONEXION)
  )


tabla_eventos_ajustado_2 <- tabla_eventos_ajustado_1 %>%
  mutate(
    anio = year(FECHA_DESCONEXION),
    mes = floor_date(FECHA_DESCONEXION, "month"),
    semana = floor_date(FECHA_DESCONEXION, "week"),
    day = floor_date(FECHA_DESCONEXION, "day")
  )

# 🌦️ 2. Construcción de clima semanal
clima_semana <- nasa_power_consolidado %>%
  mutate(
    semana = floor_date(fecha_consulta, "week", week_start = 1)
  ) %>%
  group_by(id_cuadrante, semana) %>%
  summarise(
    temp_media_semana = mean(temperatura_media_c, na.rm = TRUE),
    temp_max_semana = max(temperatura_maxima_c, na.rm = TRUE),
    temp_min_semana = min(temperatura_minima_c, na.rm = TRUE),
    
    precip_total_semana = sum(precipitacion_total_mm, na.rm = TRUE),
    
    humedad_media_semana = mean(humedad_relativa_pct, na.rm = TRUE),
    
    viento_medio_semana = mean(velocidad_viento_ms, na.rm = TRUE),
    viento_max_semana = max(velocidad_viento_ms, na.rm = TRUE),
    
    .groups = "drop"
  )
# ⚠️ 3. Variables de extremos 
# 
# 🧠 3.1. Principio técnico (muy importante)
# 

# No todas las variables climáticas se agregan igual:
#   
#   Variable	Agregación correcta	Justificación
# Precipitación	suma	es acumulativa
# Temperatura media	promedio	nivel promedio de exposición
# Temperatura máxima	máximo	eventos extremos
# Temperatura mínima	mínimo	eventos extremos
# Humedad	promedio	estado atmosférico
# Viento	promedio + máximo (ideal)	nivel + ráfagas
# 

clima_semana <- clima_semana %>%
  mutate(
    lluvia_intensa = as.integer(precip_total_semana > quantile(precip_total_semana, 0.9, na.rm = TRUE)),
    calor_extremo = as.integer(temp_max_semana > quantile(temp_max_semana, 0.9, na.rm = TRUE)),
    viento_fuerte = as.integer(viento_max_semana > quantile(viento_max_semana, 0.9, na.rm = TRUE))
  )
# 🌍 4. Incorporar coordenadas (panel espacial completo)
clima_semana_spatial <- clima_semana %>%
  left_join(CUADRANTE_COORD, by = "id_cuadrante")
# 🔍 Validación
sum(is.na(clima_semana_spatial$latitud))

# 4.1. Export NASA semana por cuadrante 800
#saveRDS(clima_semana_spatial,"C:/Users/User/Downloads/clima_semana_spatial.rds")

# 📊 5. EDA ESPACIAL
# 🌎 5.1 Promedios espaciales

clima_mapa <- clima_semana_spatial %>%
  group_by(id_cuadrante, latitud, longitud) %>%
  summarise(
    precip_media = mean(precip_total_semana, na.rm = TRUE),
    temp_media = mean(temp_media_semana, na.rm = TRUE),
    viento_medio = mean(viento_medio_semana, na.rm = TRUE),
    .groups = "drop"
  )

# 🌧️ 5.2 Mapa precipitación
ggplot(clima_mapa, aes(longitud, latitud)) +
  geom_point(aes(color = precip_media), size = 2) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Precipitación promedio semanal")
# 🌡️ 5.3 Mapa temperatura
ggplot(clima_mapa, aes(longitud, latitud)) +
  geom_point(aes(color = temp_media), size = 3) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Temperatura promedio")

# 🌪️ 5.4 Mapa viento
ggplot(clima_mapa, aes(longitud, latitud)) +
  geom_point(aes(color = viento_medio), size = 3) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Velocidad del viento")

# ⏱️ 6. Dinámica temporal
clima_tiempo <- clima_semana %>%
  group_by(semana) %>%
  summarise(
    temp_media = mean(temp_media_semana, na.rm = TRUE),
    temp_max = mean(temp_max_semana, na.rm = TRUE),
    temp_min = mean(temp_min_semana, na.rm = TRUE),
    
    precip = mean(precip_total_semana, na.rm = TRUE),
    
    humedad = mean(humedad_media_semana, na.rm = TRUE),
    
    viento_medio = mean(viento_medio_semana, na.rm = TRUE),
    viento_max = mean(viento_max_semana, na.rm = TRUE),
    
    .groups = "drop"
  )

# Pasar a formato largo
clima_tiempo_long <- clima_tiempo %>%
  pivot_longer(
    cols = -semana,
    names_to = "variable",
    values_to = "valor"
  )%>%
  mutate(
    variable = recode(variable,
                      temp_media = "Temperatura media",
                      temp_max = "Temperatura máxima",
                      temp_min = "Temperatura mínima",
                      precip = "Precipitación",
                      humedad = "Humedad relativa",
                      viento_medio = "Viento medio",
                      viento_max = "Viento máximo"
    )
  )
# ⚠️🌡️ Crear indicadores de extremos a nivel temporal

# Primero debes agregarlos a nivel semanal (promedio o proporción):
  
  extremos_tiempo <- clima_semana %>%
  group_by(semana) %>%
  summarise(
    lluvia_extrema = mean(lluvia_intensa, na.rm = TRUE),
    viento_extremo = mean(viento_fuerte, na.rm = TRUE),
    .groups = "drop"
  )

  # 📊 Esto queda como proporción de cuadrantes afectados cada semana.
  
extremos_tiempo <- clima_semana %>%
  group_by(semana) %>%
  summarise(
    lluvia_extrema = mean(lluvia_intensa, na.rm = TRUE),
    viento_extremo = mean(viento_fuerte, na.rm = TRUE),
    .groups = "drop"
  )


# 🔗 2. Unir con la serie temporal 
clima_tiempo <- clima_tiempo %>%
  left_join(extremos_tiempo, by = "semana")

# Gráfico
ggplot(clima_tiempo_long, aes(x = semana, y = valor, color = variable)) +
  geom_line(size = 1) +
  facet_wrap(~variable, scales = "free_y", ncol = 1) +
  scale_color_manual(values = c(
    "temp_media" = "#e31a1c",
    "temp_max" = "#fb9a99",
    "temp_min" = "#b2df8a",
    
    "precip" = "#1f78b4",
    
    "humedad" = "#ff7f00",
    
    "viento_medio" = "#33a02c",
    "viento_max" = "#6a3d9a"
  )) +
  theme_minimal() +
  theme(
    legend.position = "none",
    strip.text = element_text(face = "bold"),
    plot.title = element_text(face = "bold", size = 14)
  ) +
  labs(
    title = "Dinámica temporal de variables climáticas",
    x = "Semana",
    y = NULL
  )+geom_vline(
    data = extremos_tiempo %>% filter(lluvia_extrema > 0.3),
    aes(xintercept = semana),
    color = "#1f78b4",
    alpha = 0.2
  )

