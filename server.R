library(shiny)
library(plotly)

# load the weather data
# original source: http://cdn.knmi.nl/knmi/map/page/klimatologie/gegevens/daggegevens/etmgeg_260.zip
weather <- read.csv("etmgeg_260.txt", skip=47)[,c('YYYYMMDD','TG','TN','TX','UG')]

# create a valid date column 
weather$date <- sapply(weather[,1], as.character)
weather$date <- strptime(weather$date, "%Y%m%d")
weather$date <- as.POSIXct(weather$date)

# subset the data starting at 2014
weather <- subset(weather,date>= "2014-01-01")

# correct the data into the correct units:
weather$TG <- weather$TG / 10 
weather$TN <- weather$TN / 10
weather$TX <- weather$TX / 10
# weather$UG <- weather$UG / 10

# set plotly formatting options
x <- list(
  title = "Date"
)

y <- list(
  title = "Selected variable"
)

# make multiple choices available based on columns
# code example from: http://stackoverflow.com/questions/36784906/shiny-allowling-users-to-choose-which-columns-to-display
vchoices <- 2:(ncol(weather)-1)
names(vchoices) <- names(weather)[2:(ncol(weather)-1)]


shinyServer(function(input, output) {
  
   
  dataset <- reactive({
    # prepare the input variables
    startdate <- paste(input$year,"-01-01",sep="")
    col <- as.numeric(input$columns)

    # create dataset from column indexes, including date (column 6)
    df <- data.frame(weather[,c(6, col)])
    names(df) <- names(weather)[c(6,col)]

    # create actual dataset for plotting
    df[df$date >= as.POSIXct(startdate) & df$date <= (as.POSIXct(startdate) + 31622400),]
  }) # end dataset

  
  output$weatherPlot <- renderPlotly({
    # get the dataset
    data <- data.frame(dataset())
    
    plot_ly(data, x = data$date, y = data[,2], type = 'scatter', mode = 'lines') %>% layout(xaxis = x, yaxis = y)
    
  }) # end weatherPlot
  
}) # end shinyServer