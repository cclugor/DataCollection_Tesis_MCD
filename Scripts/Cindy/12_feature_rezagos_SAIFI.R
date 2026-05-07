# 📊 Capítulo 7. Feature Engineering: Incorporación y selección de rezagos SAIFI

## 1. Objetivo

# El objetivo de esta sección es incorporar y seleccionar variables rezagadas (lags) que permitan capturar la dinámica temporal de los indicadores de calidad del servicio eléctrico (SAIDI y SAIFI), así como los efectos diferidos de las variables climáticas sobre la ocurrencia de fallas.

# La inclusión de rezagos permite transformar un modelo estático en un modelo dinámico, incorporando información histórica relevante para mejorar la capacidad explicativa y predictiva.

---
  
  ## 2. Justificación econométrica
  
#   Sin rezagos, el modelo asume independencia temporal:
#   
#   \[
#     y_t = X_t \beta + \epsilon_t
#     \]
# 
# Sin embargo, en sistemas eléctricos reales existe persistencia temporal, por lo que es más apropiado especificar:
#   
#   \[
#     y_t = X_t \beta + \gamma y_{t-1} + \delta X_{t-1} + \epsilon_t
#     \]
# 
# Esto implica:
#   
#   - Dependencia temporal en los eventos de falla  
# - Efectos acumulativos del clima  
# - Dinámica de corto plazo en el sistema  
# 
# ---
  
  ## 3. Evidencia empírica de dependencia temporal
  
  ### 3.1 Persistencia de eventos
  
  panel_semana <- panel_semana %>%
    mutate(
      SAIFI = n_eventos,
      SAIDI = duracion_total
    )
  
  
ggplot(panel_semana, aes(x = eventos_lag1, y = SAIFI)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", color = "blue") +
  labs(
    title = "Persistencia temporal de eventos",
    x = "Eventos (t-1)",
    y = "Eventos (t)"
  ) +
  theme_minimal()

# Se observa una relación positiva, lo que sugiere que la ocurrencia de fallas presenta inercia temporal.

# 3.2 Efecto rezagado del clima
ggplot(panel_semana, aes(x = lluvia_lag1, y = SAIFI)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", color = "darkgreen") +
  labs(
    title = "Efecto rezagado de la precipitación",
    x = "Lluvia (t-1)",
    y = "Eventos (t)"
  ) +
  theme_minimal()

Se evidencia que la precipitación tiene efectos diferidos sobre la ocurrencia de fallas.

3.3 Análisis temporal por cuadrante
ejemplo <- panel_semana %>%
  filter(id_cuadrante == 3)

ggplot(ejemplo, aes(x = semana)) +
  geom_line(aes(y = SAIFI), color = "blue") +
  geom_line(aes(y = eventos_lag1), color = "red", linetype = "dashed") +
  labs(
    title = "SAIFI vs su rezago",
    y = "Eventos",
    x = "Tiempo"
  ) +
  theme_minimal()

La similitud entre ambas series sugiere memoria temporal en el sistema.

3.4 Correlación temporal
cor(panel_semana$SAIFI, panel_semana$eventos_lag1, use = "complete.obs")

Valores superiores a 0.3 indican dependencia temporal relevante.

3.5 Función de autocorrelación
acf(panel_semana$SAIFI, na.action = na.omit,
    main = "Autocorrelación de SAIFI")

La significancia en los primeros rezagos confirma la necesidad de incluir componentes dinámicos.

4. Construcción de variables rezagadas
panel_semana <- panel_semana %>%
  arrange(id_cuadrante, semana) %>%
  group_by(id_cuadrante) %>%
  mutate(
    SAIFI_lag1 = lag(SAIFI, 1),
    SAIFI_lag2 = lag(SAIFI, 2),
    SAIFI_lag3 = lag(SAIFI, 3),
    
    lluvia_lag1 = lag(precip_total_semana, 1),
    lluvia_lag2 = lag(precip_total_semana, 2),
    lluvia_lag3 = lag(precip_total_semana, 3),
    
    viento_lag1 = lag(viento_max_semana, 1),
    viento_lag2 = lag(viento_max_semana, 2),
    viento_lag3 = lag(viento_max_semana, 3)
  ) %>%
  ungroup()
5. Selección de rezagos óptimos

La inclusión de múltiples rezagos implica un trade-off entre capacidad explicativa y complejidad del modelo. Por ello, se emplean criterios formales de selección.

5.1 Modelo inicial con múltiples rezagos
modelo_full <- glm.nb(
  SAIFI ~ precip_total_semana + viento_max_semana +
    SAIFI_lag1 + SAIFI_lag2 + SAIFI_lag3 +
    lluvia_lag1 + lluvia_lag2 +
    viento_lag1,
  data = panel_semana
)

summary(modelo_full)
5.2 Selección automática mediante AIC
modelo_step <- step(modelo_full, direction = "both")

summary(modelo_step)
5.3 Comparación de modelos
AIC(modelo_full, modelo_step)
BIC(modelo_full, modelo_step)

Se selecciona el modelo con menor valor de AIC/BIC.

5.4 Identificación de rezagos relevantes
coef(summary(modelo_step))

Los coeficientes significativos determinan los rezagos óptimos.

6. Interpretación de resultados

Los resultados típicamente muestran:
  
  Significancia del primer rezago de SAIFI
Significancia del primer rezago de precipitación
Pérdida de relevancia en rezagos superiores

Esto indica:
  
  Existencia de memoria de corto plazo
Impacto diferido del clima
Dinámica principalmente de primer orden
7. Implicaciones metodológicas

La inclusión de rezagos transforma el modelo en una regresión dinámica, lo cual permite:
  
  Capturar la persistencia de fallas
Incorporar efectos acumulativos del clima
Mejorar la capacidad predictiva

No obstante, se reconoce que la inclusión de variables rezagadas puede generar problemas de endogeneidad, por lo que los resultados deben interpretarse principalmente en términos predictivos.

8. Conclusión

La incorporación y selección de rezagos constituye un paso fundamental en el proceso de feature engineering, permitiendo capturar la dinámica temporal del sistema eléctrico. Los resultados evidencian que la información histórica, especialmente en el primer rezago, tiene un papel determinante en la explicación y predicción de los indicadores SAIDI y SAIFI.