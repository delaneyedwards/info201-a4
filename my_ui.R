library("tidyverse")
library("plotly")
source("my_server.R")

dataset <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")


intro_panel <- tabPanel(
  "Intro",
  titlePanel("Comparing CO2 Emissions in Scandanavia and the US"),
  mainPanel(
    fluidRow(
      column(
        width = 9, tags$p("CO2 emissions are a huge contributer to global
        warming and are mainly caused by burning oil, coal and gas, as well as
        mass deforestation. This is a huge problem that our society has yet to
        fix head on, however, important data has been collected about CO2
        emissions across the globe. I chose to compare the Us to all of the
      Scandanavian countries, which you can see in the map on the right."),
        tags$p(
          "When looking at this data, unsurprisingly the US
                      has an immense output of CO2. In 2018, the United States
                     emitted, ", us_co2, "tonnes of CO2. This translates to",
          us_co2_per_cap, " tonnes of CO2 per capita. In
                      contrast, the scandanavian country with the
                      highest CO2 emissions per capita is ",
          country_max_scand_co2, "with an emissions per
                      capita of", max_scand_co2_per_cap, ". This is a difference
                      of ", difference_co2, "per capita."
        ),
        tags$p("This makes me wonder if the differences you will see on
                      the plot are due to the size of the country, the
                      differences in governing (Scandanavian countries are more
                      socialist) or differences in economic focuses.")
      ),
      column(
        width = 3,
        img(
          src = "https://i.pinimg.com/originals/6e/3c/d9/6e3cd966610c8563b26582db05836b72.jpg",
          width = "150%", align = "left"
        )
      )
    )
  )
)

# creates input drop down to select Y value
y_input <- selectInput(
  inputId = "y_input",
  label = "Choose a Y Value",
  choices = c(
    "Annual Production Based CO2 Emissions
                                (in million tonnes per year)",
    "Annual Percent Change in CO2 Emissions",
    "Annual Change in CO2 Emissions
                                (in million tonnes)",
    "Annual Consumption-Based CO2 Emissions
                                (in million tonnes per year)",
    "Average per capita CO2 Emissions
                                (in tonnes per year)",
    "Percentage of Total Global CO2 Emissions",
    "CO2 Emissions per GDP Unit",
    "CO2 Per Unit of Energy Consumed",
    "CO2 Emissions from Cement Production
                                (in million tonnes)",
    "CO2 Emissions from Coal Production
                                (in million tonnes)",
    "CO2 Emissions from Gas Flaring
                                (in million tonnes)",
    "CO2 Emissions from Gas Production
                                (in million tonnes)",
    "CO2 Emissions from Oil Production
                                (in million tonnes)",
    "Greenhouse Gas Emissions Per Capita
                                (in tonnes of carbon dioxide equivalents)",
    "Annual Methane Emissions
                                (in million tonnes of carbon dioxide
                                equivalents)",
    "Annual Nitrous Oxide Emissions
                                in million tonnes of carbon dioxide
                                equivalents."
  )
)

# creates check boxes of all countries for user to select
country_input <- checkboxGroupInput(
  "country_input", "Select Countries to Look At",
  c(
    "Norway",
    "Iceland",
    "Sweden",
    "Finland",
    "Denmark"
  )
)

plot_sidebar <- sidebarPanel(
  y_input,
  country_input
)
plot_main <- mainPanel(
  plotlyOutput("linechart"),
  tags$p("I chose to include this chart because it clearly displays how much
        more CO2 emissions come from the US in comparison to all of the
        Scandanavian countries. It also shows how much CO2 emissions have
         increased in the last 50 years, mostly in the US, but also in all
         of the countries.")
)
plot_panel <- tabPanel(
  "Plot",
  titlePanel("Comparing CO2 Emissions in Scandanavia and the US"),
  sidebarLayout(
    plot_sidebar,
    plot_main
  )
)


ui <- navbarPage(
  "CO2 Emissions", intro_panel, plot_panel
)
