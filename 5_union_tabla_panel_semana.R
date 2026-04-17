#📊 Capítulo X. Integración Clima–Eventos y Construcción del Panel Analítico
#1. Objetivo del análisis

#El objetivo de esta sección es construir una base de datos integrada que combine información climatológica y eventos de falla en una unidad espacial y temporal consistente, con el fin de:
  
# - Consolidar la información en una única estructura analítica
# - Garantizar consistencia entre dimensiones espacial y temporal
# - Preparar el insumo base para modelos predictivos
# - Permitir análisis conjuntos clima–fallas
# - Evitar problemas de explosión de datos por joins incorrectos

# Unidad de análisis:
#  Cuadrante × semana

# 🧱 2. Preparación de datos
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(tidyr)
library(readxl)

#📥 3. Carga de bases consolidadas
# Clima semanal con coordenadas
clima_semana_spatial <- readRDS("C:/Users/User/Downloads/clima_semana_spatial.rds")

# Eventos agregados por cuadrante-semana
eventos_cuadrante_semana <- readRDS("C:/Users/User/Downloads/eventos_semana_spatial.rds")

#🔗 4. Construcción del panel final
panel_semana <- clima_semana_spatial %>%
  left_join(
    eventos_cuadrante_semana %>% select(-latitud,-longitud),
    by = c("id_cuadrante", "semana")
  ) %>%
  mutate(
    n_eventos = replace_na(n_eventos, 0),
    duracion_total = replace_na(duracion_total, 0),
    duracion_promedio = replace_na(duracion_promedio, 0),
    falla = as.integer(n_eventos > 0)
  )
#🔍 5. Validación del panel
#5.1 Dimensiones
dim(panel_semana)
#5.2 Valores faltantes
panel_semana %>%
  summarise_all(~sum(is.na(.)))
#5.3 Distribución de la variable objetivo
table(panel_semana$falla)
prop.table(table(panel_semana$falla))

#👉 Esto es clave para entender desbalance de clases.

#📊 6. Análisis Exploratorio Integrado
#⏱️ 6.1 Dinámica temporal de fallas
fallas_tiempo <- panel_semana %>%
  group_by(semana) %>%
  summarise(
    total_eventos = sum(n_eventos, na.rm = TRUE),
    proporcion_fallas = mean(falla, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(fallas_tiempo, aes(x = semana, y = total_eventos)) +
  geom_line(color = "#d73027", size = 1) +
  theme_minimal() +
  labs(
    title = "Evolución temporal de eventos de falla",
    x = "Semana",
    y = "Número de eventos"
  )
#🌍 6.2 Distribución espacial de fallas
fallas_mapa <- panel_semana %>%
  group_by(id_cuadrante, latitud, longitud) %>%
  summarise(
    eventos_promedio = mean(n_eventos, na.rm = TRUE),
    prob_falla = mean(falla, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(fallas_mapa, aes(x = longitud, y = latitud)) +
  geom_point(aes(color = prob_falla), size = 2) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Probabilidad de falla por cuadrante")
#🌧️ 6.3 Relación clima–fallas
ggplot(panel_semana %>% slice_sample(n=1500), aes(x = precip_total_semana, y = n_eventos)) +
  geom_point(alpha = 0.2, color = "#1f78b4") +
  geom_smooth(method = "lm", color = "black") +
  theme_minimal() +
  labs(
    title = "Relación entre precipitación y eventos de falla",
    x = "Precipitación semanal (mm)",
    y = "Número de eventos"
  )
#🌪️ 6.4 Eventos extremos y fallas
panel_semana %>%
  group_by(lluvia_intensa) %>%
  summarise(
    promedio_eventos = mean(n_eventos, na.rm = TRUE),
    prob_falla = mean(falla, na.rm = TRUE)
  )
#🔥 6.5 Interacción espacio–tiempo
ggplot(panel_semana%>% 
         slice_sample(n=500) %>% 
         filter(semana>="2025-10-01"), aes(x = longitud, y = latitud)) +
  geom_point(aes(color = n_eventos), size = 1.5) +
  facet_wrap(~semana) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Distribución espacio-temporal de fallas")


ggplot(
  panel_semana %>%
    slice_sample(n = 2000) %>%
    filter(semana >= as.Date("2025-10-01")),
  aes(x = longitud, y = latitud)
) +
  geom_point(
    aes(
      color = as.numeric(semana),   # tiempo como continuo
      size = n_eventos
    ),
    alpha = 0.7
  ) +
  scale_color_viridis_c(
    option = "plasma",
    name = "Tiempo"
  ) +
  scale_size_continuous(
    range = c(1, 6),
    name = "N° eventos"
  ) +
  theme_minimal() +
  labs(
    title = "Distribución espacio-temporal de fallas",
    x = "Longitud",
    y = "Latitud"
  )


ggplot(
  panel_semana %>%
    slice_sample(n = 2000) %>%
    filter(semana >= as.Date("2025-10-01")) %>%
    mutate(
      mes = floor_date(semana, "month")
    ),
  aes(x = longitud, y = latitud)
) +
  geom_point(
    aes(
      color = mes,
      size = n_eventos
    ),
    alpha = 0.7
  ) +
  scale_color_viridis_d(name = "Mes") +
  scale_size_continuous(range = c(1, 6), name = "N° eventos") +
  theme_minimal() +
  labs(
    title = "Distribución espacial de fallas por mes",
    x = "Longitud",
    y = "Latitud"
  )


ggplot(
  panel_semana %>%
    slice_sample(n = 2000) %>%
    filter(semana >= as.Date("2025-10-01")) %>%
    mutate(
      mes = factor(floor_date(semana, "month"))
    ),
  aes(x = longitud, y = latitud)
) +
  geom_point(
    aes(
      color = mes,
      size = n_eventos
    ),
    alpha = 0.7
  ) +
  scale_color_viridis_d(name = "Mes") +
  scale_size_continuous(range = c(1, 6), name = "N° eventos") +
  theme_minimal() +
  labs(
    title = "Distribución espacial de fallas por mes",
    x = "Longitud",
    y = "Latitud"
  )

ggplot(
  panel_semana %>%
    slice_sample(n = 2000) %>%
    filter(semana >= as.Date("2025-10-01")) %>%
    mutate(
      mes = format(floor_date(semana, "month"), "%Y-%m")
    ),
  aes(x = longitud, y = latitud)
) +
  geom_point(
    aes(
      color = mes,
      size = n_eventos
    ),
    alpha = 0.7
  ) +
  scale_color_viridis_d(name = "Mes") +
  scale_size_continuous(range = c(1, 6), name = "N° eventos") +
  theme_minimal() +
  labs(
    title = "Distribución espacial de fallas por mes",
    x = "Longitud",
    y = "Latitud"
  )



#🎬 1. Instalar (si no lo tienes)
install.packages("gganimate")
install.packages("gifski")
install.packages("transformr")
#📦 2. Librerías
library(ggplot2)
library(dplyr)
library(lubridate)
library(gganimate)
#🎥 3. Animación básica (por semana)
animacion <- ggplot(
  panel_semana %>%
    slice_sample(n = 3000) %>% 
    filter(semana >= as.Date("2025-10-01")),
  aes(x = longitud, y = latitud)
) +
  geom_point(
    aes(
      size = n_eventos,
      color = n_eventos
    ),
    alpha = 0.7
  ) +
  scale_color_viridis_c(name = "Eventos") +
  scale_size(range = c(1, 6)) +
  theme_minimal() +
  labs(
    title = "Semana: {frame_time}",
    x = "Longitud",
    y = "Latitud"
  ) +
  transition_time(semana) +
  ease_aes("linear")
#▶️ 4. Renderizar
animate(animacion, nframes = 80, fps = 8, width = 800, height = 600)
#💾 5. Guardar (IMPORTANTE para tu tesis)
anim_save("C:/Users/User/Downloads/fallas_animacion.gif", animacion)
#🔥 6. Versión MEJORADA (más limpia visualmente)

# Esta es la que te recomiendo para presentación:
  
  animacion_pro <- ggplot(
    panel_semana %>%
      slice_sample(n = 3000) %>%
      filter(semana >= as.Date("2025-10-01")),
    aes(x = longitud, y = latitud)
  ) +
  geom_point(
    aes(
      size = n_eventos,
      color = n_eventos
    ),
    alpha = 0.6
  ) +
  scale_color_viridis_c(option = "plasma") +
  scale_size(range = c(1, 5)) +
  theme_minimal() +
  labs(
    title = "Evolución de fallas | Semana: {frame_time}",
    subtitle = "Tamaño = número de eventos | Color = intensidad",
    x = "Longitud",
    y = "Latitud"
  ) +
  transition_time(semana) +
  shadow_mark(alpha = 0.1) +   # deja “rastro”
  ease_aes("linear")
  
<<<<<<< Updated upstream
# 🧠 Interpretación (esto lo puedes decir en la sustentación)
=======
# 🧠 Interpretación
>>>>>>> Stashed changes
# 
# La animación permite observar:
#   
#   clusters persistentes de fallas
# dinámica temporal asociada a condiciones climáticas
# zonas críticas recurrentes
# posibles patrones de propagación espacial

#🧠 7. Interpretación técnica

# La construcción del panel permite establecer una estructura de datos coherente donde:
#   
# Se alinean variables climáticas y operativas en una misma unidad de análisis
# Se preserva la dimensión espacial mediante cuadrantes
# Se captura la variabilidad temporal a nivel semanal
# 
# Este enfoque evita problemas comunes como:
#   
# Explosión de registros por joins a nivel elemento
# Inconsistencias entre escalas de agregación
# Pérdida de interpretabilidad en modelos
# 
# Adicionalmente, la variable falla define un problema de clasificación binaria, mientras que n_eventos permite un enfoque alternativo de conteo (Poisson o modelos de intensidad).