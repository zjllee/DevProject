library(shiny)

#Stokes Law
SL <- function(d,p,pp,mu,g) g*(pp-p)*(d^2)/(18*mu)
#Reynolds NUmber
RN <- function(p,igv,d,mu) p*igv*d/mu
#Drag Coefficient
DC <- function(irn) (24/irn)+(3/(irn^0.5)+0.34)
#Terminal Velocity
TV <- function(idc,g,pp,p,d) (((4/3)*(g*(pp-p)*d)/(idc*p))^0.5)
#Delta
Delta <- function(fcvprev,fcv) fcvprev-fcv
#Final Reynolds NUmber 
FinalRN <- function(d,p,pp,mu,g,igv,fcv,fcvprev)
{
  diff <- Delta(igv,fcv)
  while(diff != 0) {
    frn <- RN(p,fcv,d,mu)
    fdc <- DC(frn)
    fcv <- TV(fdc,g,pp,p,d)
    diff <- Delta(fcvprev,fcv)
    fcvprev <- fcv
  }
  return(frn)
}
#Final Drag Coefficient
FinalDC <- function(d,p,pp,mu,g,igv,fcv,fcvprev)
{
  diff <- Delta(igv,fcv)
  while(diff != 0) {
    frn <- RN(p,fcv,d,mu)
    fdc <- DC(frn)
    fcv <- TV(fdc,g,pp,p,d)
    diff <- Delta(fcvprev,fcv)
    fcvprev <- fcv
  }
  return(fdc)
}
#Final Terminal Velocity
FinalTV <- function(d,p,pp,mu,g,igv,fcv,fcvprev)
{
  diff <- Delta(igv,fcv)
 while(diff != 0) {
   frn <- RN(p,fcv,d,mu)
   fdc <- DC(frn)
   fcv <- TV(fdc,g,pp,p,d)
   diff <- Delta(fcvprev,fcv)
   fcvprev <- fcv
 }
  return(fcv)
}
#Line Graph Output
LineGraph <- function(d,p,pp,mu,g,igv,fcv,fcvprev)
{
  diff <- Delta(igv,fcv)
  i=1
  while(diff[i] != 0) {
    frn <- RN(p,fcv,d,mu)
    fdc <- DC(frn)
    fcv <- TV(fdc,g,pp,p,d)
    diff[i+1] <- Delta(fcvprev,fcv)
    fcvprev <- fcv
    i <- i+1
  }
  return(log10(diff[1:(i-2)]))
}


shinyServer(
  function(input, output) {
    
    #calculate the initial values
    output$igv <- renderPrint({SL(input$d,input$p,input$pp,input$mu,input$g)})
    igv <- reactive({SL(input$d,input$p,input$pp,input$mu,input$g)})
    output$irn <- renderPrint({RN(input$p,igv(),input$d,input$mu)})
    irn <- reactive({RN(input$p,igv(),input$d,input$mu)})
    output$idc <- renderPrint({DC(irn())})
    idc <- reactive({DC(irn())})
    output$icv <- renderPrint({TV(idc(),input$g,input$pp,input$p,input$d)})
    icv <- reactive({TV(idc(),input$g,input$pp,input$p,input$d)})
    fcv <- reactive({icv()})
    fcvprev <-reactive({fcv()})
    output$frn <- renderPrint({FinalDC(input$d,input$p,input$pp,input$mu,input$g,igv(),fcv(),fcvprev())})
    output$fdc <- renderPrint({FinalRN(input$d,input$p,input$pp,input$mu,input$g,igv(),fcv(),fcvprev())})
    output$fcv <- renderPrint({FinalTV(input$d,input$p,input$pp,input$mu,input$g,igv(),fcv(),fcvprev())})
    output$line_graph <- renderPlot({plot(LineGraph(input$d,input$p,input$pp,input$mu,input$g,igv(),fcv(),fcvprev()), main=expression(paste("Log ",delta," vs Iteration (Last point represents the iteration before ",delta," =0)")),xlab="Iterations",ylab=expression(paste(delta)),col="blue")})
  }
)
