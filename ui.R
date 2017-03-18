library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("De Bilt (NL) weather data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
   
    # make variable selection available for the user
    sidebarPanel(
      selectInput("columns","Select measurement", 
                  choices = c('TG','TN','TX','UG')),
      hr(),
      helpText("TG: Average Temperature",
        "TN: Minimum Temperature", 
        "TX: Maximum Temperature", 
        "UG: Average Humidity"),
       
    # make year selection available for the user
       selectInput("year", "Year:",
                   choices=c('2014','2015','2016','2017')),
       hr(),
       helpText("Select which year to display.")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput('weatherPlot')
    )
  )
))