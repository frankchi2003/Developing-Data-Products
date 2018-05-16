#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# Deploy Shiny Apps to RStudio shinyapps Server from your RStudio console
# 1. Create an account on RStudio Shiny Server (https://www.shinyapps.io/admin/#/login)
# 2. Get a token and secret 
# 3. install.packages("rsconnect") if it is the first to deploy application
# 4. rsconnect::setAccountInfo(name='frankchi2003', token='52493DA63AA90910FDEDE5DBA2CD7A64', secret='k0Q4oXOPz/PQkgc54dyue4FLZOSXw9HeVEhdjRGI')
# 5. rsconnect::deployApp(paste(getwd(), "ddpWk4Shiny", sep="/"))
# 6. url:  https://frankchi2003.shinyapps.io/ddpwk4shiny/

library(shiny); library(ggplot2); require(gridExtra)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    selectView <- reactive({
        input$selectView
    })

    dateRange <- reactive({
        x <- sort(c(input$dateRange, perfm.date), decreasing = FALSE)
        x <- x[2:3]
        dateL <- ifelse(x[1] >= perfm.date[1], x[1], perfm.date[1])
        dateH <- ifelse(x[2] <= perfm.date[2], x[2], perfm.date[2])
        c(dateL, dateH)
    })
    
    output$helpText <- renderUI({
        switch( selectView(),
                "1" = helpText('Display histgram of application procsse time and backend processing time'),
                "2" = helpText('Display backend performance boxplot graph'),
                "3" = helpText('Display total performance boxplot graph'),
                helpText('Display performance statistics')
            )
        
    })
    
    output$plot1 <- renderPlot({
        v <- switch(selectView(),
                  "1" = {1},
                  "2" = {2},
                  "3" = {3},
                  {1}
        )
        
        ds <- perfm.data[perfm.data$Date >= dateRange()[1] & perfm.data$Date <= dateRange()[2], ]
        ds$appTime[!is.na(ds$appTime) & ds$appTime>11]<-11
        ds<-ds[!is.na(ds$cslTime) & ds$appTime*1000 >= ds$cslTime & ds$cslTime > 300,]
        ds$Date <- as.factor(ds$Date)

        if (v == 1) {
            g<-ggplot(data=ds)
            
            plot1<-g + 
                geom_histogram(aes(appTime),col="black",fill="lightblue",binwidth = 0.2) + 
                geom_vline(aes(xintercept=as.numeric(mean(ds$appTime))), linetype=1, colour="midnightblue") +
                geom_vline(aes(xintercept=as.numeric(perfm.appTarget)), linetype=1, colour="red")
            
            
            plot2<-g + 
                geom_histogram(aes(cslTime),col="black",fill="lightblue",binwidth = 200) + 
                geom_vline(aes(xintercept=as.numeric(mean(ds$cslTime))), linetype=1, colour="midnightblue") +
                geom_vline(aes(xintercept=as.numeric(perfm.cslTarget)), linetype=1, colour="red")
            
            p <- grid.arrange(plot1, plot2, ncol=2)
            
        } else {
            if (v == 2) {
                p <- ggplot(ds, aes(x=Date, y=cslTime))
                target <- as.numeric(perfm.cslTarget)
                redline <- c(2400)
                redlineTag <- "2400 ms"
                title <- "CSL Performance"
            } else {
                p <- ggplot(ds, aes(x=Date, y=appTime))
                target <- as.numeric(perfm.appTarget)
                redline <- c(4.0)
                redlineTag <- "4 sec"
                title <- "APP Performance"
            }
            p<- p + geom_boxplot() + stat_summary(fun.y=mean, colour="darkred", geom="point") + 
                theme(axis.text.x = element_text(angle=45)) +
                labs(title=title) + 
                geom_hline(aes(yintercept=as.numeric(target),linetype="target"), colour="blue") +
                geom_hline(aes(yintercept=as.numeric(redline), linetype=redlineTag), colour="red") +
                scale_linetype_manual(name = "Type", values = c(2, 2), 
                                      guide = guide_legend(override.aes = list(color = c("red", "blue"))))
        }
        print(p)
            
    })
    
})
