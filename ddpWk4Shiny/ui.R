#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    

  # Application title
  titlePanel("Performance of processing a credit application"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        dateRangeInput("dateRange", label=h4("Please Select Date Range"), 
                       start=perfm.date[1], end=perfm.date[2]),
        selectInput("selectView", h4("Please Select view"), 
                   choices = list("Performance Statistics" = 1, 
                                  "CSL Performance" = 2, 
                                  "Application Performance" = 3), 
                   selected = 1),
        
        uiOutput("helpText"),
        
        hr(),
        helpText("Data From XYZ Company")
#       submitButton("Submit") # New! Delayed Reactivity
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("plot1")
    )
  )
))
