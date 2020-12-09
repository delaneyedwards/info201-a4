library("tidyverse")
library("plotly")

dataset <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

us_co2_per_cap <- dataset %>%
  filter(country == "United States", year == max(year)) %>%
  pull(co2_per_capita)

max_scand_co2_per_cap <- dataset %>%
  filter(country == "Norway" | country == "Sweden" | country == "Denmark" |
    country == "Iceland" | country == "Finland") %>%
  filter(year == max(year)) %>%
  filter(co2_per_capita == max(co2_per_capita)) %>%
  pull(co2_per_capita)

country_max_scand_co2 <- dataset %>%
  filter(country == "Norway" | country == "Sweden" | country == "Denmark" |
    country == "Iceland" | country == "Finland") %>%
  filter(year == max(year)) %>%
  filter(co2_per_capita == max(co2_per_capita)) %>%
  pull(country)

difference_co2 <- us_co2_per_cap - max_scand_co2_per_cap

us_co2 <- dataset %>%
  filter(country == "United States", year == max(year)) %>%
  pull(co2)

server <- function(input, output) {
  output$linechart <- renderPlotly({
    choices_cols <- dataset %>%
      select(
        country, year, co2, co2_growth_prct, co2_growth_abs, consumption_co2,
        co2_per_capita,
        share_global_co2, co2_per_gdp, co2_per_unit_energy, cement_co2,
        coal_co2, flaring_co2, gas_co2, oil_co2, total_ghg, methane,
        nitrous_oxide
      )

    colnames(choices_cols) <- c(
      "Country", "year",
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

    final_data <- choices_cols %>%
      filter(Country == "United States" | Country %in% input$country_input) %>%
      filter(!(is.na(input$y_input) | input$y_input == ""))

    plot <- ggplot(data = final_data, aes(x = year,
                                          y = .data[[input$y_input]])) +
      geom_line(mapping = aes(color = Country), size = 1) +
      ylab(input$y_input) +
      labs(title = "Emissions in the US versus Scandanavian Countries")
    ggplotly(plot)
  })
}
