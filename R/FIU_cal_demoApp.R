#TSCal App
#' FIU analytical sphere demo
#'
#' @import shiny
#' @import shinyjs
#' @import ggplot2
#' @import DT
#' @return Runs a web application
#' @examples
#' FIUSphereDemo() #run the web applications
#' @export

source('./R/TSCal.R')

source('./R/helper_functions.R')

FIUCalDemo <- function(){
  check.pkg.FIU()
  shiny::shinyApp(
    # Define UI for miles per gallon app ----
    ui <- shiny::fluidPage(

      # App title ----
      shiny::titlePanel("Calibration Sphere TS"),
      shiny::sidebarLayout(
        shiny::sidebarPanel("Cal TS",
                            sliderInput('d', 'Radius a [mm]',
                                        min=0, max=100, value=38.1,
                                        step=.1, round=0),
                            sliderInput("frange", label = h3("Frequency Range"), min = 1,
                                        max = 1000, value = c(18, 200)),
                            sliderInput("crange", label = h3("Soundspeed Range"), min = 300,
                                        max = 2000, value = c(1403, 1520)),
                            numericInput("cstep", "SOund speed interval:", 10, min = 1, max = 1000),
                            selectInput("mat", "Material:",
                                        c("Tungsten Carbide (6% CObalt Binder)" = "TC",
                                          "Copper" = "Cu")),
                            selectInput("water", "Water Density:",
                                        c("Saltwater" = "sw",
                                          "Fresh Water" = "fw")),
                            br()),
        # Main panel for displaying outputs ----
        shiny::mainPanel(
          shiny::tabsetPanel(
            shiny::tabPanel("Target Sphere",
                            shiny::br(),
                            shiny::plotOutput("scat_and"),
                            DT::dataTableOutput("TStable")
            )
          )
        )
      )),

    server <- function(input, output,session) {

      # current TS plot
      output$scat_and <- shiny::renderPlot({
        fs = seq(input$frange[1],input$frange[2])

        TS = user_data()
        ggplot2::ggplot(data=TS,ggplot2::aes(x=F,y=TS,group=factor(c),color=factor(c)))+
          scale_color_viridis_d(name='sound speed')+
          geom_line(size=1.2)+theme_classic()+
          theme(text=element_text(size=20))
      })


      ###########################################
      #get TS
      user_data <- reactive({
        fs = seq(input$frange[1],input$frange[2],1)
        cs = seq(input$crange[1],input$crange[2],input$cstep)

        ts.cal(freq=fs,
               c=cs,
               d=input$d,
               mat=input$mat,
               water=input$water,
               plot="no")

      })

      ###########################################################


      # Current TS table
      output$TStable <- DT::renderDataTable({
        DT::datatable(user_data(), options = list(lengthMenu = c(5, 30, 50),pageLength = 5))
      })

    }
  )
}

