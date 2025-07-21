library(shiny)
library(leaflet)
library(dplyr)
library(sf)
library(shinyalert)

server <- function(input, output, session) {
  
  municipios_filtrados <- reactive({
    datos <- municipios
    
    if (input$mostrar_proceso) {
      datos <- datos %>% filter(Estatus == "En proceso")
      
      if (!is.null(input$filtros_variables)) {
        for (var in input$filtros_variables) {
          datos <- datos %>% filter(.data[[var]] == "Completado")
        }
      }
    }
    
    datos
  })
  
  output$mapa <- renderLeaflet({
    datos_mapa <- municipios_filtrados()
    
    if (nrow(datos_mapa) == 0 || all(st_is_empty(datos_mapa))) {
      shinyalert("Sin resultados", "No hay municipios que cumplan con los filtros seleccionados.", type = "info")
    }
    
    mapa <- leaflet() %>%
      addProviderTiles("OpenStreetMap") %>%
      addPolygons(data = forma_nl,
                  color = "black", weight = 2,
                  fillColor = "transparent",
                  group = "NL") %>%
      addPolygons(data = municipios,
                  fillColor = "transparent",
                  color = "black", weight = 1.5,
                  fillOpacity = 0,
                  group = "Contorno")
    
    if (nrow(datos_mapa) > 0 && any(!st_is_empty(datos_mapa))) {
      mapa <- mapa %>%
        addPolygons(data = datos_mapa,
                    fillColor = ~ifelse(Estatus == "En proceso", "yellow", "red"),
                    fillOpacity = 0.7,
                    color = "black", weight = 1,
                    label = ~paste0(NOMGEO, " - Estatus: ", Estatus),
                    group = "Municipios")
    }
    
    mapa
  })
}
