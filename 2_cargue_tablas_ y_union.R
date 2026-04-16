library(readr)
library(dplyr)
library(lubridate)

tabla_elemento_fallado_1_ajustado <- read_csv("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/tabla_elemento_fallado_1_ajustado.csv")
head(tabla_elemento_fallado_1_ajustado)


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

head(tabla_eventos_ajustado_2)


eventos_anio <- tabla_eventos_ajustado_2 %>%
  group_by(anio,ELEMENTO_FALLADO) %>%
  mutate(
    duracion_horas = as.numeric(difftime(FECHA_CONEXION, FECHA_DESCONEXION, units = "hours"))
  ) %>% 
  summarise(n_eventos = n(),
            duracion_total = sum(duracion_horas, na.rm = TRUE),
            duracion_promedio = mean(duracion_horas, na.rm = TRUE))%>% 
  arrange(desc(n_eventos))

eventos_mes <- tabla_eventos_ajustado_2 %>%
  group_by(mes,ELEMENTO_FALLADO) %>% 
  
  mutate(
    duracion_horas = as.numeric(difftime(FECHA_CONEXION, FECHA_DESCONEXION, units = "hours"))
  )%>%
  summarise(n_eventos = n(),
            duracion_total = sum(duracion_horas, na.rm = TRUE),
            duracion_promedio = mean(duracion_horas, na.rm = TRUE))%>% 
  arrange(desc(n_eventos))

eventos_semana <- tabla_eventos_ajustado_2 %>%
  group_by(semana,ELEMENTO_FALLADO) %>%
  mutate(
    duracion_horas = as.numeric(difftime(FECHA_CONEXION, FECHA_DESCONEXION, units = "hours"))
  ) %>% 
  summarise(n_eventos = n(),
            duracion_total = sum(duracion_horas, na.rm = TRUE),
            duracion_promedio = mean(duracion_horas, na.rm = TRUE))%>% 
  arrange(desc(n_eventos))


eventos_mes <- tabla_eventos_ajustado_2 %>%
  group_by(mes,ELEMENTO_FALLADO) %>%
  mutate(
    duracion_horas = as.numeric(difftime(FECHA_CONEXION, FECHA_DESCONEXION, units = "hours"))
  ) %>% 
  summarise(
    n_eventos = n(),
    duracion_total = sum(duracion_horas, na.rm = TRUE),
    duracion_promedio = mean(duracion_horas, na.rm = TRUE)
  )


eventos_dia <- tabla_eventos_ajustado_2 %>%
  group_by(day,ELEMENTO_FALLADO) %>%
  mutate(
    duracion_horas = as.numeric(difftime(FECHA_CONEXION, FECHA_DESCONEXION, units = "hours"))
  ) %>% 
  summarise(n_eventos = n(),
            duracion_total = sum(duracion_horas, na.rm = TRUE),
            duracion_promedio = mean(duracion_horas, na.rm = TRUE))%>% 
  arrange(desc(n_eventos))



tipo_elemento <- read_csv("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/tipo_elemento.csv")
head(tipo_elemento)


tipo_elemento %>% 
  group_by(TIPO) %>% 
  count()
  


library(readxl)
ELEMENTO_FALLA_CUADRANTE_800 <- read_excel("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/Distribución de Cuadrantes/ELEMENTO_FALLA_CUADRANTE_800.xls")
head(ELEMENTO_FALLA_CUADRANTE_800)
skim(ELEMENTO_FALLA_CUADRANTE_800)
str(ELEMENTO_FALLA_CUADRANTE_800)

ELEMENTO_FALLA_CUADRANTE_800 %>% 
  group_by(CUADRANTE_1,TIPO) %>% 
  count() %>% 
  arrange(desc(n))



library(readr)
ELEMENTO_FALLA_CUADRANTE_200 <- read_csv("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/Distribución de Cuadrantes/ELEMENTO_FALLA_CUADRANTE_200.csv")
head(ELEMENTO_FALLA_CUADRANTE_200)

skim(ELEMENTO_FALLA_CUADRANTE_200)


ELEMENTO_FALLA_CUADRANTE_200 %>% 
  group_by(ID_CUADRANTE,TIPO) %>% 
  count() %>% 
  arrange(desc(n))



## esta es la adición de falla cuadrante y pivote 200


library(readxl)
ELEMENTO_FALLA_PIVOTE <- read_excel("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/Distribución de Cuadrantes/ELEMENTO_FALLA_PIVOTE.xls")
head(ELEMENTO_FALLA_PIVOTE)

library(skimr)
skim(ELEMENTO_FALLA_PIVOTE)

ELEMENTO_FALLA_PIVOTE %>% distinct(ID_CUADRANTE)



ELEMENTO_FALLA_PIVOTE %>% select(TIPO_ACTIVO_ELECTRICO) %>% distinct()

ELEMENTO_FALLA_PIVOTE %>% 
  filter(ID_ACTIVO_ELECTRICO=="PSW9292")

# tabla de usuario por TIPO_ACTIVO_ELECTRICO

tabla_eventos_ajustado %>% 
  filter(ID_EVENTO==801851)

tabla_elemento_fallado_1_ajustado %>% 
  filter(CODIGO_MANIOBRA==801851)


library(readr)
nasa_power_consolidado <- read_csv("C:/Users/User/OneDrive - PUJ Cali/Archivos de EDWIN SILVA SALAS - Projecto_Grado_Javeriana/Data_Project/Distribución de Cuadrantes/Output_Raw_API_NASA/nasa_power_consolidado.csv")
head(nasa_power_consolidado)
dim(nasa_power_consolidado)
dim(ELEMENTO_FALLA_PIVOTE)
dim(eventos_dia)


clima_mas_todos_los_elementos<-left_join(nasa_power_consolidado,
          ELEMENTO_FALLA_PIVOTE%>% select(seq(1,8)), by=c("id_cuadrante"="ID_CUADRANTE"))


#saveRDS(clima_mas_todos_los_elementos,"C:/Users/User/Downloads/clima_mas_todos_los_elementos.rds")
View(head(clima_mas_todos_los_elementos))

elementos_mas_eventos_dia<-left_join(clima_mas_todos_los_elementos%>% select(seq(1,18)),
            eventos_dia, by=c("ID_ACTIVO_ELECTRICO"="ELEMENTO_FALLADO"))

#saveRDS(elementos_mas_eventos_dia,"C:/Users/User/Downloads/elementos_mas_eventos_dia.rds")


str(nasa_power_consolidado)

# 
# 
# ???? 1. Principio técnico (muy importante)
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


library(dplyr)
library(lubridate)

clima_semana <- nasa_power_consolidado %>%
  mutate(
    semana = floor_date(fecha_consulta, "week", week_start = 1)  # semanas tipo lunes
  )


clima_semana <- clima_semana %>%
  group_by(id_cuadrante, semana) %>%
  summarise(
    # Temperaturas
    temp_media_semana = mean(temperatura_media_c, na.rm = TRUE),
    temp_max_semana = max(temperatura_maxima_c, na.rm = TRUE),
    temp_min_semana = min(temperatura_minima_c, na.rm = TRUE),
    
    # Precipitación (ACUMULADA)
    precip_total_semana = sum(precipitacion_total_mm, na.rm = TRUE),
    
    # Humedad
    humedad_media_semana = mean(humedad_relativa_pct, na.rm = TRUE),
    
    # Viento
    viento_medio_semana = mean(velocidad_viento_ms, na.rm = TRUE),
    viento_max_semana = max(velocidad_viento_ms, na.rm = TRUE),
    
    # Opcional (muy útil para robustez)
    dias_observados = n(),
    
    .groups = "drop"
  )

## 4. Creación de Variables derivadas

clima_semana <- clima_semana %>%
  mutate(
    # Indicadores de eventos extremos
    lluvia_intensa = ifelse(precip_total_semana > quantile(precip_total_semana, 0.9, na.rm = TRUE), 1, 0),
    
    calor_extremo = ifelse(temp_max_semana > quantile(temp_max_semana, 0.9, na.rm = TRUE), 1, 0),
    
    viento_fuerte = ifelse(viento_max_semana > quantile(viento_max_semana, 0.9, na.rm = TRUE), 1, 0)
  )

eventos_semana <- tabla_eventos_ajustado_2 %>%
  mutate(
    semana = floor_date(FECHA_DESCONEXION, "week", week_start = 1),
    duracion_horas = as.numeric(difftime(FECHA_CONEXION, FECHA_DESCONEXION, units = "hours"))
  ) %>%
  group_by(ELEMENTO_FALLADO, semana) %>%
  summarise(
    n_eventos = n(),
    duracion_total = sum(duracion_horas, na.rm = TRUE),
    .groups = "drop"
  )

nasa_power_consolidado %>% distinct(id_cuadrante)

