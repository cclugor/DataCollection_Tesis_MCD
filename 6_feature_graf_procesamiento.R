# 📊 Capítulo 6. Feature engineering para SAIDI y SAIFI

# -----------------------------------------------------------
# 1. Objetivo del análisis
# -----------------------------------------------------------

# El objetivo de esta sección es desarrollar modelos estadísticos y de 
# Machine Learning para predecir los indicadores de calidad del servicio 
# eléctrico (SAIDI y SAIFI), a partir de información climática, operativa 
# y espacial consolidada en el panel semanal.

# Específicamente, se busca:

# - Identificar variables climáticas relevantes en la ocurrencia de fallas
# - Modelar la frecuencia de interrupciones (SAIFI)
# - Modelar la duración de interrupciones (SAIDI)
# - Comparar diferentes enfoques de modelación
# - Evaluar el desempeño predictivo de los modelos
# - Analizar la importancia de variables explicativas

# Unidad de análisis:
# Cuadrante × semana


# 
# 🧱 2. Preparación del entorno -----------------------------------------------------------
# -----------------------------------------------------------

library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(MASS)
library(randomForest)
library(Metrics)


# -----------------------------------------------------------
# 📥 3. Carga de datos
# -----------------------------------------------------------

panel_semana <- readRDS("C:/Users/User/Downloads/panel_semana.rds")

## quitar cuando estemos haciendo el ejercicio completo
panel_semana<-panel_semana %>% 
  slice_sample(by=semana,n=50)


str(panel_semana)


# -----------------------------------------------------------
# 🔧 4. Construcción de variables objetivo
# -----------------------------------------------------------

# En ausencia de número de usuarios por cuadrante:
# - SAIFI ≈ número de eventos
# - SAIDI ≈ duración total

#
panel_semana <- panel_semana %>%
  mutate(
    SAIFI = n_eventos,
    SAIDI = duracion_total
  )


# -----------------------------------------------------------
# 📊 5. Análisis exploratorio inicial
# -----------------------------------------------------------

# Distribución de eventos
ggplot(panel_semana, aes(x = SAIFI)) +
  geom_histogram(bins = 30) +
  ggtitle("Distribución de SAIFI (eventos)")

# Distribución de duración
ggplot(panel_semana, aes(x = SAIDI)) +
  geom_histogram(bins = 30) +
  ggtitle("Distribución de SAIDI (duración total)")

# -----------------------------------------------------------
# 📊 Matriz de correlación: SAIFI vs variables climáticas
# -----------------------------------------------------------

library(corrplot)

# Selección de variables climáticas + SAIFI
vars_clima <- panel_semana %>%
  dplyr::select(
    SAIFI,
    temp_media_semana,
    temp_max_semana,
    temp_min_semana,
    precip_total_semana,
    humedad_media_semana,
    viento_medio_semana,
    viento_max_semana,
    lluvia_intensa,
    calor_extremo,
    viento_fuerte
  )

# Calcular matriz de correlación
cor_matrix <- cor(vars_clima, use = "complete.obs")

# Ver matriz numérica
round(cor_matrix, 3)

# -----------------------------------------------------------
# 🔥 Visualización
# -----------------------------------------------------------

corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  tl.col = "black",
  tl.cex = 0.8,
  number.cex = 0.7,
  # 🔥 Escala
  #col = colorRampPalette(c("darkred", "gold", "darkgreen"))(200)
  col = colorRampPalette(c("#B22222", "#FFD700", "#009900"))(200)
  )

library(GGally)
library(dplyr)

# Selección de variables
vars_plot <- panel_semana%>%
  slice_sample(n=500) %>%
  dplyr::select(
    SAIFI,
    precip_total_semana,
    viento_max_semana,
    temp_media_semana,
    humedad_media_semana
  )


library(GGally)
library(ggplot2)
library(dplyr)

# Submuestra para mejorar visualización
vars_saifi <- panel_semana %>%
  slice_sample(n = 500) %>%
  dplyr::select(
    SAIFI,
    precip_total_semana,
    viento_max_semana,
    temp_media_semana,
    humedad_media_semana
  ) %>%
  rename(
    SAIFI = SAIFI,
    Lluvia = precip_total_semana,
    Viento = viento_max_semana,
    Temp = temp_media_semana,
    Humedad = humedad_media_semana
  )

# función personalizada
combo_diag <- function(data, mapping, ...) {
  ggplot(data = data, mapping = mapping) +
    geom_histogram(aes(y = ..density..),
                   bins = 15,
                   fill = "#fdae61",
                   alpha = 0.6,
                   color = "white") +
    geom_density(color = "#d7305f", size = 0.6)
}


library(GGally)
# pairsplot
ggpairs(
  vars_saifi,
  # 🔽 Dispersión (abajo)
  lower = list(
    continuous = wrap("smooth", 
                      alpha = 0.3, 
                      color = "#2c7fb8", 
                      se = FALSE)
  ),
  # 🔲 Diagonal (kernels e histogramas)
  diag = list(
    continuous = combo_diag
  ),
  # 🔼 Correlaciones (arriba)
  upper = list(
    continuous = wrap("cor", size = 4)
  )
) +
  theme_minimal(base_size = 12)


# -----------------------------------------------------------
# 📊 Matriz de correlación: SAIDI vs variables climáticas
# -----------------------------------------------------------

library(corrplot)

# Selección de variables
vars_clima_saidi <- panel_semana %>%
  dplyr::select(
    SAIDI,
    temp_media_semana,
    temp_max_semana,
    temp_min_semana,
    precip_total_semana,
    humedad_media_semana,
    viento_medio_semana,
    viento_max_semana,
    lluvia_intensa,
    calor_extremo,
    viento_fuerte
  )

vars_saidi <- panel_semana %>%
  slice_sample(n = 500) %>%
  dplyr::select(
    SAIDI,
    precip_total_semana,
    viento_max_semana,
    temp_media_semana,
    humedad_media_semana
  ) %>%
  rename(
    SAIDI = SAIDI,
    Lluvia = precip_total_semana,
    Viento = viento_max_semana,
    Temp = temp_media_semana,
    Humedad = humedad_media_semana
  )


# Matriz de correlación
cor_matrix_saidi <- cor(vars_clima_saidi, use = "complete.obs")

ggpairs(
  vars_saidi,
  
  lower = list(
    continuous = wrap("smooth", 
                      alpha = 0.3, 
                      color = "#1b7837",  # cambio de color para diferenciar
                      se = FALSE)
  ),
  
  diag = list(
    continuous = combo_diag
  ),
  
  upper = list(
    continuous = wrap("cor", size = 4)
  )
) +
  theme_minimal(base_size = 12)

# -----------------------------------------------------------
# 🎨 Visualización con escala distinta
# -----------------------------------------------------------

corrplot(
  cor_matrix_saidi,
  method = "color",
  type = "upper",
  
  # 🔥 Escala (azul - blanco - rojo intenso)
  col = colorRampPalette(c("darkblue", "gray90", "darkred"))(200),
  
  tl.col = "black",
  tl.cex = 0.8,
  number.cex = 0.7
)


# -----------------------------------------------------------
# ⏱️ 6. Incorporación de rezagos temporales
# -----------------------------------------------------------

panel_semana <- panel_semana %>%
  arrange(id_cuadrante, semana) %>%
  group_by(id_cuadrante) %>%
  mutate(
    lluvia_lag1 = lag(precip_total_semana, 1),
    viento_lag1 = lag(viento_max_semana, 1),
    eventos_lag1 = lag(SAIFI, 1)
  ) %>%
  ungroup()

