### Raw Data Processing ####

### Librerías ####


library(tidyverse)
library(readxl)   # Lectura de archivos Excel
library(readr)    # Lectura de archivos en otros formatos
library(dplyr)    # Manipulación de datos
library(tidyr)    # Transformación de datos
library(skimr)    # Resumen de estructuras de datos
library(stringr)  # Manejo de cadenas de texto
library(officer)
library(flextable)
library(magrittr)
library(mice) # imputación MICE

### Índice ####
  
  
# 1. Descripción de la actividad 
# 2. Objetivos
# 3. Datos
# 4. Procesamiento de datos
# 5. Resultados y discusión
# 6. Conclusiones
# 7. Referencias
# 8. Anexos


Elemento_Fallado_OMS <- read_csv("C:/Users/User/Documents/DataCollection_Tesis_MCD/DATA/Elemento_Fallado_OMS.csv", 
                                 col_types = cols(CODIGO_MANIOBRA = col_character(), 
                                                  CODIGO_MANIOBRA_FINAL = col_character()
                                                  )
                                 )
                                                  
View(Elemento_Fallado_OMS)


Eventos_BRAE_part1 <- read_csv("C:/Users/User/Documents/DataCollection_Tesis_MCD/DATA/Eventos_BRAE_part1.csv", 
                                    col_types = cols(ID_EVENTO = col_character(), 
                                                               FECHA_INICIO = col_character(), ELEMENTO_FALLADO = col_character(), 
                                                               ELEMENTO_AFECTADO = col_character(), 
                                                               ID_CAUSA_OR = col_character(), ID_CAUSA_CREG = col_character(), 
                                                               ID_CAUSA_SSPD = col_character(), 
                                                               MES_PERIODO = col_character()))




Eventos_BRAE_part2 <- read_csv("C:/Users/User/Documents/DataCollection_Tesis_MCD/DATA/Eventos_BRAE_part2.csv", 
                               col_types = cols(ID_EVENTO = col_character(), 
                                                FECHA_INICIO = col_character(), ELEMENTO_FALLADO = col_character(), 
                                                ELEMENTO_AFECTADO = col_character(), 
                                                ID_CAUSA_OR = col_character(), ID_CAUSA_CREG = col_character(), 
                                                ID_CAUSA_SSPD = col_character(), 
                                                MES_PERIODO = col_character()))


Eventos_BRAE_part3 <- read_csv("C:/Users/User/Documents/DataCollection_Tesis_MCD/DATA/Eventos_BRAE_part3.csv", 
col_types = cols(ID_EVENTO = col_character(), 
                 FECHA_INICIO = col_character(), ELEMENTO_FALLADO = col_character(), 
                 ELEMENTO_AFECTADO = col_character(), 
                 ID_CAUSA_OR = col_character(), ID_CAUSA_CREG = col_character(), 
                 ID_CAUSA_SSPD = col_character(), 
                 MES_PERIODO = col_character()))


Eventos_BRAE_part4 <- read_csv("C:/Users/User/Documents/DataCollection_Tesis_MCD/DATA/Eventos_BRAE_part4.csv", 
                               col_types = cols(ID_EVENTO = col_character(), 
                                                FECHA_INICIO = col_character(), ELEMENTO_FALLADO = col_character(), 
                                                ELEMENTO_AFECTADO = col_character(), 
                                                ID_CAUSA_OR = col_character(), ID_CAUSA_CREG = col_character(), 
                                                ID_CAUSA_SSPD = col_character(), 
                                                MES_PERIODO = col_character()))


eventos_1_2<-full_join(Eventos_BRAE_part1,Eventos_BRAE_part2)

eventos_1_2_3<-full_join(eventos_1_2,Eventos_BRAE_part3)

eventos_1_2_3_4<-full_join(eventos_1_2_3,Eventos_BRAE_part4)

eventos_1_2_3_4_fecha<-eventos_1_2_3_4 %>% 
  mutate(fecha_inicio=as.POSIXct(FECHA_INICIO, format = "%d/%m/%y %H:%M:%OS", tz = "UTC"),
         fecha_fin=as.POSIXct(FECHA_FIN,format = "%d/%m/%y %H:%M:%OS", tz = "UTC")
  ) %>% 
  select(-FECHA_INICIO,-FECHA_FIN)


eventos_1_2_3_4_fecha

skim(eventos_1_2_3_4_fecha)



df_diario <- eventos_1_2_3_4_fecha %>%
  mutate(fecha = as.Date(fecha_inicio)) %>%   # Convertir a fecha sin hora
  group_by(fecha) %>%
  summarise(eventos = n()) %>%                # Contar eventos diarios
  arrange(fecha)

# Visualización de serie de tiempo
ggplot(df_diario, aes(x = fecha, y = eventos)) +
  geom_line(linewidth = 0.8) + 
  labs(
    title = "Eventos diarios registrados",
    x = "Fecha",
    y = "Número de eventos"
  ) +
  theme_minimal()


df_mensual <- eventos_1_2_3_4_fecha %>%
  mutate(mes = as.Date(floor_date(fecha_inicio, "month"))) %>%  # Convertimos a Date
  group_by(mes) %>%
  summarise(eventos = n()) %>%
  arrange(mes)

ggplot(df_mensual, aes(mes, eventos)) +
  geom_col(fill="steelblue") +
  labs(title="Eventos por mes", x="Mes", y="Eventos") +
  scale_x_date(date_labels="%Y-%m", date_breaks = "3 months") + # evita saturación
  theme_minimal()+
  theme(axis.text.x = element_text (angle = 55))


df_mensual_CREG <- eventos_1_2_3_4_fecha %>%
  mutate(mes = as.Date(floor_date(fecha_inicio, "month"))) %>%  # Convertimos a Date
  group_by(mes,ID_CAUSA_CREG) %>%
  summarise(eventos = n()) %>%
  arrange(mes)


ggplot(df_mensual_CREG, aes(mes, eventos, color=ID_CAUSA_CREG,fill=ID_CAUSA_CREG)) +
  geom_col() +
  labs(title="Eventos por mes", x="Mes", y="Eventos") +
  scale_x_date(date_labels="%Y-%m", date_breaks = "3 months") + # evita saturación
  theme_minimal()+
  theme(axis.text.x = element_text (angle = 55))

skim(Elemento_Fallado_OMS)


