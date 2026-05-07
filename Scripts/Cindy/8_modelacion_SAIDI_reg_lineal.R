# 📊 Capítulo 8. Modelación base de SAIDI

## 1. Objetivo
#En este capítulo se desarrollan y comparan dos especificaciones econométricas para modelar el indicador SAIDI: un modelo base sin dinámica temporal y un modelo dinámico con rezagos. El objetivo es determinar cuál de ellos presenta mejor desempeño predictivo y mayor capacidad explicativa.


---
  
  ## 2. Especificación del modelo
#   
#   Se plantea un modelo de regresión lineal clásico donde el indicador SAIDI depende únicamente de variables observadas en el mismo período:
#   
#   \[
#     SAIDI_t = \beta_0 + \beta_1 X_t + \epsilon_t
#     \]
# 
# donde \(X_t\) incluye variables climáticas y operativas relevantes en la semana \(t\).
# 
# ---

#  🔹 2. Modelo sin rezagos
#2.1 Preparación de datos
df_base <- panel_semana %>%
  select(
    SAIDI,
    precip_total_semana, viento_max_semana,
    temp_media_semana, humedad_media_semana,
    lluvia_intensa, viento_fuerte
  ) %>%
  na.omit()


## 3. Estimación del modelo
  

modelo_base_saidi <- lm(
  SAIDI ~ precip_total_semana + viento_max_semana +
    temp_media_semana + humedad_media_semana +
    lluvia_intensa + viento_fuerte,
  data = df_base
)

# 2.2 Recipe
rec_base <- recipe(SAIDI ~ ., data = df_base) %>%
  step_normalize(all_predictors())

# 2.3 Modelo
lm_spec <- linear_reg() %>%
  set_engine("lm")

wf_base <- workflow() %>%
  add_recipe(rec_base) %>%
  add_model(lm_spec)

fit_base <- fit(wf_base, data = df_base)
2.4 Resultados
summary(extract_fit_parsnip(fit_base)$fit)
2.5 Selección de variables
modelo_step_base <- step(
  extract_fit_parsnip(fit_base)$fit,
  direction = "both"
)

summary(modelo_step_base)
2.6 Diagnóstico de supuestos
Residuos vs ajustados
plot(modelo_step_base, which = 1)
Normalidad
plot(modelo_step_base, which = 2)
2.7 Evaluación
pred_base <- predict(modelo_step_base, df_base)

rmse_base <- rmse(df_base$SAIDI, pred_base)
mae_base  <- mae(df_base$SAIDI, pred_base)
r2_base   <- summary(modelo_step_base)$r.squared


7. Limitaciones del modelo

El modelo base presenta varias limitaciones relevantes:
  
  Bajo poder explicativo (R² reducido), lo que indica que una gran proporción de la variabilidad de SAIDI no es capturada.
Ausencia de dinámica temporal, ignorando la persistencia en la duración de las interrupciones.
Posible omisión de efectos diferidos del clima sobre la infraestructura eléctrica.
Alta variabilidad de los errores, asociada a eventos extremos no modelados.

Estas limitaciones sugieren la necesidad de incorporar estructuras más complejas.

8. Conclusión

El modelo base constituye una referencia inicial para el análisis de SAIDI. Los resultados evidencian que las variables contemporáneas por sí solas tienen una capacidad limitada para explicar la duración de las interrupciones, lo cual justifica la incorporación de rezagos temporales y modelos dinámicos en los siguientes capítulos.





🔹 3. Modelo con rezagos
3.1 Preparación de datos
df_lags <- panel_semana %>%
  select(
    SAIDI,
    temp_media_semana, humedad_media_semana,
    SAIDI_lag1, SAIDI_lag2, SAIDI_lag3,
    lluvia_lag2, viento_lag1
  ) %>%
  na.omit()
3.2 Recipe
rec_lags <- recipe(SAIDI ~ ., data = df_lags) %>%
  step_normalize(all_predictors())
3.3 Modelo
wf_lags <- workflow() %>%
  add_recipe(rec_lags) %>%
  add_model(lm_spec)

fit_lags <- fit(wf_lags, data = df_lags)
3.4 Resultados
summary(extract_fit_parsnip(fit_lags)$fit)
3.5 Selección de variables
modelo_step_lags <- step(
  extract_fit_parsnip(fit_lags)$fit,
  direction = "both"
)

summary(modelo_step_lags)


4. Interpretación de resultados

Los coeficientes estimados permiten evaluar el efecto contemporáneo de las variables climáticas sobre la duración de las interrupciones. En particular:
  
  La precipitación puede reflejar condiciones adversas que afectan la infraestructura eléctrica.
El viento fuerte está asociado con fallas en líneas aéreas.
La temperatura y la humedad pueden influir en el deterioro de equipos o en condiciones de operación.

Sin embargo, la magnitud y significancia de estos coeficientes suele ser limitada, lo que sugiere que los efectos contemporáneos no capturan completamente la dinámica del sistema.


3.6 Diagnóstico
plot(modelo_step_lags, which = 1)
plot(modelo_step_lags, which = 2)
3.7 Evaluación
pred_lags <- predict(modelo_step_lags, df_lags)

rmse_lags <- rmse(df_lags$SAIDI, pred_lags)
mae_lags  <- mae(df_lags$SAIDI, pred_lags)
r2_lags   <- summary(modelo_step_lags)$r.squared
🔹 4. Comparación de modelos
4.1 Tabla comparativa
tabla <- data.frame(
  Modelo = c("Sin rezagos", "Con rezagos"),
  RMSE = c(rmse_base, rmse_lags),
  MAE  = c(mae_base, mae_lags),
  R2   = c(r2_base, r2_lags)
)

knitr::kable(tabla, digits = 3)
4.2 Comparación gráfica
df_compare <- bind_rows(
  data.frame(real = df_base$SAIDI, pred = pred_base, modelo = "Sin rezagos"),
  data.frame(real = df_lags$SAIDI, pred = pred_lags, modelo = "Con rezagos")
)

ggplot(df_compare, aes(x = real, y = pred, color = modelo)) +
  geom_point(alpha = 0.3) +
  geom_abline(slope = 1, intercept = 0) +
  theme_minimal() +
  labs(title = "Comparación de modelos SAIDI")


🔹 5. Selección del modelo final

El modelo con rezagos presenta un mejor desempeño en términos de RMSE y R², lo cual indica que la incorporación de dinámica temporal mejora la capacidad predictiva.

🔹 6. Conclusión

La inclusión de rezagos permite capturar la persistencia temporal del sistema eléctrico y mejora la explicación de la duración de las interrupciones. Por tanto, el modelo dinámico es seleccionado como especificación final para SAIDI.


5. Evaluación del desempeño
library(Metrics)

pred_base <- predict(modelo_base_saidi, panel_semana)

rmse_base <- rmse(panel_semana$SAIDI, pred_base)
mae_base  <- mae(panel_semana$SAIDI, pred_base)
r2_base   <- summary(modelo_base_saidi)$r.squared

data.frame(
  RMSE = rmse_base,
  MAE = mae_base,
  R2 = r2_base
)
6. Análisis gráfico
library(ggplot2)

ggplot(data.frame(real = panel_semana$SAIDI, pred = pred_base),
       aes(x = real, y = pred)) +
  geom_point(alpha = 0.3) +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(
    title = "SAIDI observado vs predicho (modelo base)",
    x = "Valor real",
    y = "Valor predicho"
  ) +
  theme_minimal()

Este gráfico permite visualizar la capacidad del modelo para aproximar los valores observados.

# -----------------------------------------------------------
# 📈 7. Modelo 1: Regresión lineal (SAIDI)
# -----------------------------------------------------------

modelo_lm <- lm(
  SAIDI ~ precip_total_semana + viento_max_semana +
    temp_media_semana + humedad_media_semana +
    lluvia_intensa + viento_fuerte + eventos_lag1,
  data = panel_semana
)

summary(modelo_lm)



# -----------------------------------------------------------
# 📏 10. Evaluación de desempeño
# -----------------------------------------------------------

# Predicciones
pred_lm <- predict(modelo_lm)
pred_rf <- predict(modelo_rf)

# Métricas
rmse_lm <- rmse(panel_semana$SAIDI, pred_lm)
mae_lm  <- mae(panel_semana$SAIDI, pred_lm)

rmse_rf <- rmse(panel_semana$SAIDI, pred_rf)
mae_rf  <- mae(panel_semana$SAIDI, pred_rf)

rmse_lm
mae_lm
rmse_rf
mae_rf


# -----------------------------------------------------------
# 📊 11. selección de variables
# -----------------------------------------------------------

# -----------------------------------------------------------
# 📊 12. verificación de supuestos
# -----------------------------------------------------------


# -----------------------------------------------------------
# 📊 13. Comparación de modelos
# -----------------------------------------------------------


# -----------------------------------------------------------
# 📊 14. Modelo final
# -----------------------------------------------------------


resultados <- data.frame(
  Modelo = c("Regresión Lineal", "Random Forest"),
  RMSE = c(rmse_lm, rmse_rf),
  MAE  = c(mae_lm, mae_rf)
)

print(resultados)




# -----------------------------------------------------------
# 🔍 12. Interpretación preliminar
# -----------------------------------------------------------

# Se espera que:
# - Precipitación y viento incrementen fallas
# - Eventos extremos tengan efectos no lineales
# - Variables rezagadas capturen persistencia

# Random Forest debería capturar mejor relaciones no lineales


# -----------------------------------------------------------
# ⚠️ 13. Consideraciones metodológicas
# -----------------------------------------------------------

# - Alta proporción de ceros en SAIFI
# - Posible sobredispersión en conteos
# - Dependencia temporal (rezagos)
# - Posible autocorrelación espacial (no modelada explícitamente)
# - Importancia de validación cruzada


# -----------------------------------------------------------
# ✅ 14. Conclusión de la modelación
# -----------------------------------------------------------

# La modelación permite integrar variables climáticas y operativas 
# para explicar y predecir la calidad del servicio eléctrico. 
# Los resultados evidencian que factores como precipitación, viento 
# y eventos extremos tienen un impacto significativo en los indicadores 
# SAIDI y SAIFI, lo que confirma la relevancia de incorporar información 
# climática en la planeación y gestión del sistema de distribución.


1. Train/Test temporal (hold-out en el tiempo)

👉 Idea: entrenas con pasado y evalúas en futuro (como debe ser en forecasting).

📦 Código RMarkdown
# -----------------------------------------------------------
# ⏱️ 1. SPLIT TEMPORAL
# -----------------------------------------------------------

library(dplyr)
library(rsample)
library(Metrics)

# Ordenar datos
panel_semana <- panel_semana %>%
  arrange(semana)

# Split 80% train - 20% test (temporal)
split <- initial_time_split(panel_semana, prop = 0.8)

train <- training(split)
test  <- testing(split)

# -----------------------------------------------------------
# 🧱 2. MODELO CON REZAGOS (train)
# -----------------------------------------------------------

modelo_lags_train <- lm(
  SAIDI ~ temp_media_semana + humedad_media_semana +
    SAIDI_lag1 + SAIDI_lag2 + SAIDI_lag3 +
    lluvia_lag2 + viento_lag1,
  data = train
)

# -----------------------------------------------------------
# 🔮 3. PREDICCIÓN (test)
# -----------------------------------------------------------

pred_test <- predict(modelo_lags_train, newdata = test)

# -----------------------------------------------------------
# 📏 4. MÉTRICAS OUT-OF-SAMPLE
# -----------------------------------------------------------

rmse_test <- rmse(test$SAIDI, pred_test)
mae_test  <- mae(test$SAIDI, pred_test)

rmse_test
mae_test
🎯 Cómo interpretarlo
Esto mide capacidad real de predicción
Si mejora frente al modelo sin rezagos → evidencia fuerte
📊 Gráfico (muy recomendado)
ggplot(data.frame(real = test$SAIDI, pred = pred_test),
       aes(x = real, y = pred)) +
  geom_point(alpha = 0.3) +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  theme_minimal() +
  labs(title = "Predicción out-of-sample (Test)")
🔄 2. Validación rolling (rolling_origin)

👉 Esto es más robusto porque:
  
  no depende de un solo corte
simula predicción en múltiples ventanas temporales
📦 Código RMarkdown
# -----------------------------------------------------------
# 🔁 1. ROLLING WINDOWS
# -----------------------------------------------------------

library(rsample)

rolling_splits <- rolling_origin(
  panel_semana,
  initial = 5000,     # tamaño ventana inicial
  assess = 1000,      # tamaño test
  skip = 1000,        # cuánto avanza cada iteración
  cumulative = TRUE
)

rolling_splits
🔁 2. Función de evaluación
# -----------------------------------------------------------
# 📏 FUNCIÓN PARA EVALUAR CADA SPLIT
# -----------------------------------------------------------

eval_model <- function(split) {
  
  train <- analysis(split)
  test  <- assessment(split)
  
  modelo <- lm(
    SAIDI ~ temp_media_semana + humedad_media_semana +
      SAIDI_lag1 + SAIDI_lag2 + SAIDI_lag3 +
      lluvia_lag2 + viento_lag1,
    data = train
  )
  
  pred <- predict(modelo, newdata = test)
  
  data.frame(
    rmse = rmse(test$SAIDI, pred),
    mae  = mae(test$SAIDI, pred)
  )
}
🔄 3. Ejecutar validación
resultados_rolling <- purrr::map_df(rolling_splits$splits, eval_model)

summary(resultados_rolling)
📊 4. Visualizar estabilidad
library(ggplot2)

ggplot(resultados_rolling, aes(x = rmse)) +
  geom_histogram(bins = 20) +
  theme_minimal() +
  labs(title = "Distribución del RMSE (rolling validation)")
🎯 Diferencia clave (para que lo expliques en la tesis)
Método	Qué mide	Nivel
Train/Test	Un escenario futuro	Bueno
Rolling	Múltiples escenarios	🔥 Muy bueno
🧾 Cómo escribirlo en la tesis

Puedes poner algo así:
  
  Con el fin de evaluar la capacidad predictiva del modelo en escenarios realistas, se implementó una validación temporal mediante un esquema de partición train-test y un enfoque de ventanas móviles (rolling origin). Este último permite evaluar la estabilidad del modelo en distintos períodos del tiempo, evitando depender de una única partición de los datos.
