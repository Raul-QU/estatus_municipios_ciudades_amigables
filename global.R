# Paquetes necesarios
library(sf)
library(dplyr)
library(readxl)

# Ruta de los archivos
data_path <- "~/IEPAM/Mapa Digital/Pruebas de mapas en R/Shiny/Status municipios/Data"
forma_nl_path <- file.path(data_path, "19ent.shp")
municipios_path <- file.path(data_path, "19mun.shp")
excel_path <- file.path(data_path, "status municipios.xlsx")

# Cargar capas con manejo de errores
try({
  forma_nl <- st_read(forma_nl_path, options = "ENCODING=WINDOWS-1252") %>%
    st_transform(4326) %>%
    st_make_valid() %>%
    filter(st_geometry_type(geometry) %in% c("POLYGON", "MULTIPOLYGON"))
  municipios <- st_read(municipios_path, options = "ENCODING=WINDOWS-1252") %>%
    st_transform(4326) %>%
    st_make_valid() %>%
    filter(st_geometry_type(geometry) %in% c("POLYGON", "MULTIPOLYGON"))
}, silent = FALSE)

# Validar nombres de columnas
print("Columnas en municipios:")
print(names(municipios))

# Leer Excel y hacer merge
status_municipios <- read_excel(excel_path)
municipios <- merge(municipios, status_municipios, by = c("CVE_MUN", "NOMGEO"), all.x = TRUE)

# Convertir variables de estado numérico a texto descriptivo
municipios <- municipios %>%
  mutate(across(
    c("Inscripcion_forms", "Reunion", "Capacitacion", "Aprobacion_cabildo",
      "carta_compromiso", "diagnostico", "diagnostico_validado",
      "formulario_adhesion", "consejo_municipal_pam"),
    ~ case_when(
      . == 1 ~ "Completado",
      . == 0 ~ "En proceso",
      . == -1 ~ "No completado",
      TRUE ~ NA_character_
    )
  ))
