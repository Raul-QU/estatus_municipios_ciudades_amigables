library(shiny)
library(leaflet)
library(shinyalert)

ui <- fluidPage(
  useShinyalert(),
  tags$head(
    tags$style(HTML(".filtro-panel {
                     position: absolute;
                     top: 70px;
                     left: 20px;
                     z-index: 500;
                     background-color: rgba(255,255,255,0.9);
                     padding: 10px;
                     border-radius: 8px;
                     box-shadow: 0 2px 6px rgba(0,0,0,0.3);
                   }"))
  ),
  leafletOutput("mapa", height = "100vh"),
  absolutePanel(class = "filtro-panel", fixed = TRUE,
                checkboxInput("mostrar_proceso", "Mostrar solo 'En proceso'", FALSE),
                conditionalPanel(
                  condition = "input.mostrar_proceso == true",
                  checkboxGroupInput("filtros_variables", "Filtros adicionales:",
                                     choices = c(
                                       "Inscripción a Forms" = "Inscripcion_forms",
                                       "Reunión inicial" = "Reunion",
                                       "Capacitación" = "Capacitacion",
                                       "Aprobación Cabildo" = "Aprobacion_cabildo",
                                       "Carta Compromiso" = "carta_compromiso",
                                       "Diagnóstico" = "diagnostico",
                                       "Diagnóstico Validado" = "diagnostico_validado",
                                       "Formulario Adhesión" = "formulario_adhesion",
                                       "Consejo Municipal PAM" = "consejo_municipal_pam"
                                     )
                  )
                )
  )
)
