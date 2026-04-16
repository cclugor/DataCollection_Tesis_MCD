# 📊 Capítulo X. Análisis Exploratorio de Eventos de Falla
# 
# 1. Objetivo del análisis
# 
# El objetivo de esta sección es caracterizar la dinámica temporal y operativa de los eventos de falla
# en la red eléctrica, con énfasis en:
# 
# - Identificar patrones temporales (tendencias, estacionalidad)
# - Analizar la duración de las fallas
# - Detectar eventos extremos (fallas críticas)
# - Evaluar concentración por elemento
# - Generar insumos para la modelación predictiva
# 
# Unidad de análisis:
# Elemento eléctrico × semana

#🧱 2. Preparación de datos
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(tidyr)
library(readxl)

#🔹 2.1 Cargar y limpiar datos
tabla_eventos <- read_csv("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/tabla_eventos_ajustado.csv")

tabla_eventos <- tabla_eventos %>%
  mutate(
    FECHA_DESCONEXION = dmy_hm(FECHA_DESCONEXION),
    FECHA_CONEXION = dmy_hm(FECHA_CONEXION)
  )

ELEMENTO_FALLA_CUADRANTE_800 <- read_excel("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/Distribución de Cuadrantes/ELEMENTO_FALLA_CUADRANTE_800.xls")
head(ELEMENTO_FALLA_CUADRANTE_800)

# CONTIENE ID DE CUADRANTE Y LAT LONG DE LOS CENTROIDES
library(readxl)
CUADRANTE_CORD_800 <- read_excel("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/Distribución de Cuadrantes/CUADRANTE_CORD_800.xls")
View(CUADRANTE_CORD_800)

#🔹 2.2 Construcción de variables temporales
tabla_eventos <- tabla_eventos %>%
  mutate(
    anio = year(FECHA_DESCONEXION),
    mes = floor_date(FECHA_DESCONEXION, "month"),
    semana = floor_date(FECHA_DESCONEXION, "week", week_start = 1),
    dia = floor_date(FECHA_DESCONEXION, "day")
  )
#🔹 2.3 Duración de eventos
tabla_eventos <- tabla_eventos %>%
  mutate(
    duracion_horas = as.numeric(
      difftime(FECHA_CONEXION, FECHA_DESCONEXION, units = "hours")
    )
  )
#⏱️ 3. Construcción de eventos semanales
eventos_semana <- tabla_eventos %>%
  group_by(ELEMENTO_FALLADO, semana) %>%
  summarise(
    n_eventos = n(),
    duracion_total = sum(duracion_horas, na.rm = TRUE),
    duracion_promedio = mean(duracion_horas, na.rm = TRUE),
    .groups = "drop"
  )
#📊 4. Dinámica temporal de fallas
#🔹 4.1 Agregación temporal global
eventos_tiempo <- eventos_semana %>%
  group_by(semana) %>%
  summarise(
    total_eventos = sum(n_eventos, na.rm = TRUE),
    duracion_total = sum(duracion_total, na.rm = TRUE),
    duracion_promedio = mean(duracion_promedio, na.rm = TRUE),
    .groups = "drop"
  )
#🔹 4.2 Visualización de número de eventos en el tiempo
ggplot(eventos_tiempo, aes(x = semana, y = total_eventos)) +
  geom_line(color = "#1f78b4", size = 1) +
  theme_minimal() +
  labs(
    title = "Evolución temporal del número de fallas",
    x = "Semana",
    y = "Número de eventos"
  )
#🔹 4.3 Duración de los eventos en horas a través del tiempo
ggplot(eventos_tiempo, aes(x = semana, y = duracion_total)) +
  geom_line(color = "#e31a1c", size = 1) +
  theme_minimal() +
  labs(
    title = "Evolución de duración total de fallas",
    x = "Semana",
    y = "Horas"
  )
#⚠️ 5. Eventos extremos
#🔹 5.1 Definición de extremos
eventos_tiempo <- eventos_tiempo %>%
  mutate(
    evento_extremo = as.integer(
      total_eventos > quantile(total_eventos, 0.9, na.rm = TRUE)
    ),
    
    duracion_extrema = as.integer(
      duracion_total > quantile(duracion_total, 0.9, na.rm = TRUE)
    )
  )
#🔹 5.2 Visualización con extremos
ggplot(eventos_tiempo, aes(x = semana, y = total_eventos)) +
  geom_line(color = "grey30") +
  geom_point(
    data = eventos_tiempo %>% filter(evento_extremo == 1),
    color = "#e31a1c",
    size = 2
  ) +
  theme_minimal() +
  labs(title = "Eventos extremos de fallas")
#🔌 6. Heterogeneidad por elemento
#🔹 6.1 Top elementos críticos
eventos_elemento <- eventos_semana %>%
  group_by(ELEMENTO_FALLADO) %>%
  summarise(
    total_eventos = sum(n_eventos, na.rm = TRUE),
    duracion_total = sum(duracion_total, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(total_eventos))
#🔹 6.2 Visualización top 20
eventos_elemento %>%
  slice_max(total_eventos, n = 20) %>%
  ggplot(aes(x = reorder(ELEMENTO_FALLADO, total_eventos), y = total_eventos)) +
  geom_col(fill = "#1f78b4") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Elementos con mayor número de fallas",
    x = "Elemento",
    y = "Número de eventos"
  )
#⏳ 7. Distribución de duración
ggplot(tabla_eventos, aes(x = duracion_horas)) +
  geom_histogram(bins = 50, fill = "#33a02c") +
  theme_minimal() +
  labs(
    title = "Distribución de duración de fallas",
    x = "Horas",
    y = "Frecuencia"
  )
#🔗 8. Preparación para integración con clima
eventos_panel <- eventos_semana %>%
  mutate(
    falla = as.integer(n_eventos > 0)
  )

#🔌 1. Construir puente elemento–cuadrante (limpio)
# Puente único: cada elemento con su cuadrante
elemento_cuadrante <- ELEMENTO_FALLA_CUADRANTE_800 %>%
  select(ELEMENTO, CUADRANTE_1) %>%
  distinct() %>%
  rename(
    ELEMENTO_FALLADO = ELEMENTO,
    id_cuadrante = CUADRANTE_1
  )
#🔗 2. Integrar cuadrante a eventos (sin explosionar memoria)
eventos_semana_cuadrante <- eventos_semana %>%
  left_join(elemento_cuadrante, by = "ELEMENTO_FALLADO")
#🔍 Validación clave
sum(is.na(eventos_semana_cuadrante$id_cuadrante))

#Si esto no es cercano a 0 → tienes problemas de matching.

#📊 3. Agregar a nivel CUADRANTE–SEMANA (clave del modelo)
eventos_cuadrante_semana <- eventos_semana_cuadrante %>%
  group_by(id_cuadrante, semana) %>%
  summarise(
    n_eventos = sum(n_eventos, na.rm = TRUE),
    duracion_total = sum(duracion_total, na.rm = TRUE),
    duracion_promedio = mean(duracion_promedio, na.rm = TRUE),
    .groups = "drop"
  )

#👉 Este es tu equivalente de clima_semana pero para fallas.

#🌍 4. Incorporar coordenadas (centroide del cuadrante)
eventos_spatial <- eventos_cuadrante_semana %>%
  left_join(CUADRANTE_CORD_800 %>%
              rename(
                id_cuadrante = OBJECTID,
                longitud = POINT_X,
                latitud = POINT_Y
              ), by = "id_cuadrante")

sum(is.na(eventos_spatial$latitud))

eventos_spatial <- eventos_cuadrante_semana %>%
  left_join(
    CUADRANTE_CORD_800 %>%
      rename(
        id_cuadrante = OBJECTID,
        longitud = POINT_X,
        latitud = POINT_Y
      ),
    by = "id_cuadrante"
  ) %>%
  filter(!is.na(latitud))

#saveRDS(eventos_spatial,"C:/Users/User/Downloads/eventos_semana_spatial.rds")


#🔍 1. Diagnóstico: ¿qué cuadrantes no están matcheando?
  ids_eventos <- eventos_cuadrante_semana %>%
  distinct(id_cuadrante)

ids_malla <- CUADRANTE_CORD_800 %>%
  distinct(OBJECTID) %>%
  rename(id_cuadrante = OBJECTID)

ids_no_match <- ids_eventos %>%
  anti_join(ids_malla, by = "id_cuadrante")

ids_no_match
nrow(ids_no_match)


n_total <- nrow(eventos_cuadrante_semana)
n_validos <- nrow(eventos_spatial)

n_perdidos <- n_total - n_validos
n_perdidos / n_total

#📊 5. EDA ESPACIAL DE EVENTOS
#🌎 5.1 Promedios espaciales
eventos_mapa <- eventos_spatial %>%
  group_by(id_cuadrante, latitud, longitud) %>%
  summarise(
    eventos_promedio = mean(n_eventos, na.rm = TRUE),
    duracion_media = mean(duracion_total, na.rm = TRUE),
    .groups = "drop"
  )
#🔥 5.2 Mapa de frecuencia de fallas
ggplot(eventos_mapa, aes(longitud, latitud)) +
  geom_point(aes(color = eventos_promedio), size = 2) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Frecuencia promedio de fallas por cuadrante")
#⏱️ 5.3 Mapa de duración
ggplot(eventos_mapa, aes(longitud, latitud)) +
  geom_point(aes(color = duracion_media), size = 2) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Duración promedio de fallas por cuadrante")
#⏱️ 6. Dinámica temporal (cuadrantes)
eventos_tiempo <- eventos_cuadrante_semana %>%
  group_by(semana) %>%
  summarise(
    total_eventos = sum(n_eventos, na.rm = TRUE),
    duracion_total = sum(duracion_total, na.rm = TRUE),
    .groups = "drop"
  )
ggplot(eventos_tiempo, aes(semana, total_eventos)) +
  geom_line(color = "#1f78b4", size = 1) +
  theme_minimal() +
  labs(title = "Evolución temporal de fallas (nivel sistema)")
#⚠️ 7. Eventos extremos espaciales
eventos_spatial <- eventos_spatial %>%
  mutate(
    evento_extremo = as.integer(
      n_eventos > quantile(n_eventos, 0.9, na.rm = TRUE)
    )
  )
#🌧️ 7.1 Frecuencia de eventos extremos por cuadrante
eventos_extremos <- eventos_spatial %>%
  group_by(id_cuadrante, latitud, longitud) %>%
  summarise(
    freq_extremos = mean(evento_extremo, na.rm = TRUE),
    .groups = "drop"
  )
ggplot(eventos_extremos, aes(longitud, latitud)) +
  geom_point(aes(color = freq_extremos), size = 3) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Frecuencia de eventos extremos de falla")
