library(shiny)


shinyUI(
  pageWithSidebar(
    headerPanel("Terminal velocity of solid particles settling in a fluid"),
    sidebarPanel(
      p(
        "This Shiny application is used to determine the terminal velocity of solids settling in a fluid.",
        br(),
        br(),
        "For more information about this app, please refer to the How-to tab in the next panel.",
        br(),
        br(),
        "Slides for the app can be found here: http://rpubs.com/zjllee/DevProject"
        ),
      br(),
      numericInput('d', 'Diameter of particle, d (m)', 0.001, step = .001),
      numericInput('mu', 'Viscosity of fluid, mu (Pa.s)', 0.001, step = .001),
      numericInput('p', 'Density of fluid, p (kg/m^3)', 1000.00, step = 1.0),
      numericInput('pp', 'Density of particle, pp (kg/m^3)', 2000.00, step = 1.0),
      numericInput('g', 'Acceleration due to gravity, g (m/s^2)', 9.81, step = 0.01),
      submitButton('Submit')
    ),
    
    mainPanel(
      tabsetPanel(
        
      tabPanel("Results",
      h3('Initial Calculations'),
      h4('Initial Calculated guess for terminal velocity (m/s)'),
      verbatimTextOutput("igv"),
      h4('Initial Guess for Reynolds Number'),
      verbatimTextOutput("irn"),
      h4('Initial Calculated Drag Coefficient'),
      verbatimTextOutput("idc"),
      h4('Initial Calculated Terminal Velocity (m/s)'),
      verbatimTextOutput("icv"),
      
      h3('After Iterative Calculations'),
      h4('Final calculated Reynolds Number'),
      verbatimTextOutput("frn"),
      h4('Final Calculated Drag Coefficient'),
      verbatimTextOutput("fdc"),
      h4('Final Calculated Terminal Velocity (m/s)'),
      verbatimTextOutput("fcv"),
      
      plotOutput('line_graph')
      ),
      
      tabPanel("How-to",
        p(
               "To calculate the terminal velocity of solid particles settling in a fluid, we need to enter the following input parameters on the left-hand side panel:",
               br(),
               "i. Diameter of the particle, d",
               br(),
               "ii. Viscosity of the fluid, mu",
               br(),
               "iii. Density of the fluid, d",
               br(),
               "iv. Density of the particle, dd",
               br(),
               "v. Acceleration due to gravity, g"
        ),
        p(
              "From these input parameters, these initial calculations are made and the results of the calculations is displayed on the top-half of the results tab:",
              br(),
              br(),
              "1. Guess an initial value of terminal velocity using Stoke's Law,",
              br(),
              "v = g(pp-p)(d^2)/18mu",
              br(),
              br(),
              "2. Find an initial value for Reynolds Number,",
              br(),
              "Nr = pvd/mu",
              br(),
              br(),
              "3. Find an initial value for the Drag Coefficient,",
              br(),
              "Cd = (24/Nr)+(3/Nr^0.5)+0.34",
              br(),
              br(),
              "4. Find an initial value of terminal velocity,",
              br(),
              "v = ((4/3)(g(pp-p)d/Cd*p)^0.5"
        ),
        p(
          "The initial value calculated in step 4 is used to iteratively calculate another set of values for Nr, Cd and v (ie. Step 2 to 4) until the difference (or delta) between v(previous) and v(current) is equals to zero. This final value of v(current) and the corresponding values of Nr, Cd is displayed in the bottom-half section of the results tab. The number of iterations needed to reach these values is shown in the plot between log delta and iterations where the last point represents the iteration before delta = 0."
        )
      )         
      
      
      )
    )
  )
)
