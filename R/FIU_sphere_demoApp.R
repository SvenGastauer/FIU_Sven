#' FIU analytical sphere demo
#' @description This is a Shiny web application demonstrating the scattering of an analytical sphere
#'
#' @import shiny
#' @import ggplot2
#' @import reshape2
#' @import ZooScatR
#' @import DT
#' @return Runs a web application
#' @examples
#' FIUSphereDemo() #run the web applications

source('./R/helper_functions.R')

FIUSphereDemo <- function(){
  check.pkg.FIU()
  shiny::shinyApp(
    # Define UI for miles per gallon app ----
    ui <- shiny::fluidPage(

      # App title ----
      shiny::titlePanel("ZooScatR ~ Anderson Fluid Sphere Simulator"),
      shiny::sidebarLayout(
        shiny::sidebarPanel(
      sliderInput('a', 'Radius a [mm]',
                  min=0, max=100, value=10,
                  step=1, round=0),
      sliderInput("frange", label = h3("Frequency Range"), min = 1,
                  max = 1000, value = c(18, 200)),
      numericInput("r", "Range from transducer [m]:", 10, min = 1, max = 1000),
      numericInput("c", "Sound speed in surrounding fluid [m/s]:", 1480, min = 1400, max = 1600),
      numericInput("h", "Sound speed contrast:", 1.035, min = 0.1, max = 1.15),
      numericInput("g", "Range from transducer:", 1.025, min = 0.1, max = 1.15),
      numericInput("rho", "Density of surrounding fluid:", 1026.8, min = 1000, max = 1050),
      br(),
      actionButton("add_btn", "Add Simulation"),
      actionButton("clear_btn", "Clear Simulations"),
      ),
      # Main panel for displaying outputs ----
      shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel("Current",
                          shiny::br(),
                          shiny::plotOutput("scat_and"),
                          DT::dataTableOutput("TStable")
          ),
          shiny::tabPanel("All Simulations",
                          shiny::plotOutput("scat_all"),
                          hr(),
                          h2('Simulation settings'),
                          DT::dataTableOutput("allSetData"),
                          hr(),
                          h2('All Data'),
                          DT::dataTableOutput("allData")
          )
        )
      )
    )),

    server <- function(input, output,session) {

      # current TS plot
      output$scat_and <- shiny::renderPlot({
        fs = seq(input$frange[1],input$frange[2])

        TS = user_data()
        ggplot2::ggplot(data=TS,ggplot2::aes(x=fs,y=TS))+
          geom_line(size=1.2)+theme_classic()+
          xlab('Frequency [kHz]')+
          ylab('TS [dB re 1m2]')+
          theme(text=element_text(size=20))
      })

      #all TS plot
      output$scat_all <- shiny::renderPlot({
        ggplot2::ggplot(data=res$all,ggplot2::aes(x=Frequency,y=TS,group=simN,col=factor(simN)))+
          geom_line(size=1.2,alpha=0.5)+theme_classic()+
          scale_color_viridis_d('Simulation #')+
          theme(text=element_text(size=20))
      })
      ###########################################
      #get TS
      user_data <- reactive({
        fs = seq(input$frange[1],input$frange[2])

        data.frame(cbind(Frequency=fs,
                               r = input$r,
                               a=input$a,
                               c=input$c,
                               h=input$h,
                               g=input$g,
                               rho=input$rho,
                               TS = sapply(fs,
                                           ZooScatR::TS.sphere2,
                                           r=input$r,
                                           a=input$a,
                                           c=input$c,
                                           h=input$h,
                                           g=input$g,
                                           rho=input$rho)))

      })

      ###########################################################


      # Current TS table
      output$TStable <- DT::renderDataTable({
        DT::datatable(user_data(), options = list(lengthMenu = c(5, 30, 50),pageLength = 5))
      })
      ############################################################
      # All TS table
      output$allData <- DT::renderDataTable({
        DT::datatable(res$all, options = list(lengthMenu = c(5, 30, 50),pageLength = 5))
      })

      #All settings table
      output$allSetData <- DT::renderDataTable({
        DT::datatable(res$settings, options = list(lengthMenu = c(5, 30, 50),pageLength = 5))
      })

      #Add TS to datatable
      res <- reactiveValues()
      observeEvent(eventExpr = input$add_btn, {

        if(length(res$all)==0){
          res$simN = 1
          res$all = user_data()
          res$all$simN = res$simN

        }else{
          res$simN = res$simN+1
          tmp <- user_data()
          tmp$simN = res$simN


          res$all<- rbind(res$all,tmp)
          res$settings<-unique(res$all[!names(res$all) %in% c('Frequency','TS')])
        }
      })

      observeEvent(eventExpr = input$clear_btn, {
        res$simN = 0
        res$all <- data.frame()
        res$settings <- data.frame()
      })

      #############################################################

      #All TS plot
    }
  )
}
