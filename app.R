
## libraries ----------------------------------------------------------------------------

# Load packages used by the app
library(shiny)
library(bslib)
library(thematic)
library(tidyverse)
library(gitlink)
library(fresh)
library(shinydashboard)

# getwd()
# setwd('/Users/beatkrauer/Documents/Documents/R/projects/Terra/PRF_Monitoring_App/PRF_v1/')

# source("setup.R")


# Set the default theme for ggplot2 plots
ggplot2::theme_set(ggplot2::theme_minimal())

# Apply the CSS used by the Shiny app to the ggplot2 plots
thematic_shiny()
terra_cols <- c('#EDF2E6', '#026A5C','#CEC49C',"#D8DEE9")


# define own themes:
mytheme <- create_theme(
  adminlte_color(
    light_blue = '#EDF2E6'
  ),
  adminlte_sidebar(
    width = "230px",
    dark_bg = '#EDF2E6',
    dark_hover_bg = '#CEC49C',
    dark_color = '#026A5C'
  ),
  adminlte_global(
    content_bg = "#FFF",
    box_bg = "#D8DEE9", 
    info_box_bg = "#D8DEE9"
  )
)

## Credentials ----------------------------------------------------------------------------
library(shinymanager)
library(scrypt)

inactivity <- "function idleTimer() {
var t = setTimeout(logout, 120000);
window.onmousemove = resetTimer; // catches mouse movements
window.onmousedown = resetTimer; // catches mouse movements
window.onclick = resetTimer;     // catches mouse clicks
window.onscroll = resetTimer;    // catches scrolling
window.onkeypress = resetTimer;  //catches keyboard actions

function logout() {
window.close();  //close the window
}

function resetTimer() {
clearTimeout(t);
t = setTimeout(logout, 120000);  // time is in milliseconds (1000 is 1 second)
}
}
idleTimer();"

# run and copy/paste below: password <- hashPassword("ice"); pw_beat <- hashPassword("ichbindebest");pw_nik <- hashPassword("ichbindechef");pw_admin <- hashPassword("ichchanalles")
password <- "c2NyeXB0ABAAAAAIAAAAAVYhtzTyvRJ9e3hYVOOk63KUzmu7rdoycf3MDQ2jKLDQUkpCpweMU3xCvI3C6suJbKss4jrNBxaEdT/fBzxJitY3vGABhpPahksMpNu/Jou5"
pw_beat  <- "c2NyeXB0ABEAAAAIAAAAAW6e6oiPtqn2aZICrNQKo0dYlmsuSHqRDSNJ7iNeDtOjRyBo7qszAzYzNO9Wjlog28dZ39E1dXxtT0BLzxfe2zD2kjbnmi3DcK3KKrLGUjBv"
pw_nik   <- "c2NyeXB0ABEAAAAIAAAAAX+BFG5N0OhBRP+RaCPB633rEgsn3OitgwRDe/TTEP+wY8p5OTEcxU1hTn6mdxK6FO1iuh7Ip9BbrLF1xdHKTU3AAOmnMfIrLNUaeKluWStU"
pw_admin <- "c2NyeXB0ABEAAAAIAAAAAfz+nhCegjZNUFqNTdoPX5BvortcISMBkICMPZtsrOBvETSM/vyq0jqb61s+d9nEuGz3Q5/oX57pYdZ3vtVHOoflYtd/DDIxaWSKmnKCqH1T"

# data.frame with credentials info
credentials <- data.frame(
  user = c("1", "Beat", "Nik", "Admin"),
  password = c(password,pw_beat, pw_nik, pw_admin),
  is_hashed_password = TRUE,
  # comment = c("alsace", "auvergne", "bretagne"), %>% 
  stringsAsFactors = FALSE
)

## UI ----------------------------------------------------------------------------
# Define the Shiny UI layout
ui <- secure_app(
  head_auth = tags$script(inactivity),
  
  dashboardPage(
    header  <- dashboardHeader(title = "PRF App XAXAAA",
                               dropdownMenu(type = "messages", icon=icon("circle-info", class = 'fa-solid', lib = "font-awesome"), badgeStatus = NULL,
                                            headerText='',
                                            messageItem(
                                              from = "User",
                                              message = "You are logged in as Beat Krauer"
                                            ),
                                            messageItem(
                                              from = "Support",
                                              message = "please contact info@terra-ms.com",
                                              icon = icon("question")
                                              # time = "13:45"
                                            )
                               ) ),
    # header$children[[2]]$children <-  tags$PRF_App(href='https://terra-ms.com', tags$img(src='terra_logo_white.png', height="60%", width="auto")) #style="width: 50px"))
    
    
    # # Add github link (removed for connect cloud)
    # # ribbon_css("https://github.com/rstudio/demo-co/tree/main/evals-analysis-app"),
    # 
    # # Set CSS theme
    # theme = bs_theme(bootswatch = "darkly",
    #                  bg         = '#EDF2E6',
    #                  fg         = '#CEC49C',
    #                  success    = '#CEC49C'),
    # 
    # # Add title
    # title = "PRF Monitoring",
    
    # Add sidebar elements
    sidebar = dashboardSidebar(              
      
      menuItem("Portfolio",            tabName ="mi_portfolio",        icon = icon("sliders", class = 'fa-thin', lib = "font-awesome")),
      menuItem("Weather & Results",    tabName ="mi_weather",          icon = icon("bolt-lightning", class = 'fa-solid', lib = "font-awesome")),
      menuItem("Best Strategy",        tabName ="mi_strat",            icon = icon("globe", class = 'fa-light', lib = "font-awesome")),
      menuItem("Strategy Performance", tabName ="mi_stratperformance", icon = icon("database", class = 'fa-solid', lib = "font-awesome")),
      
      # title   = "Select a segment of data to view",
      # class   = "bg-secondary",
      # selectInput("industry", "Select industries", choices = industries, selected = "", multiple  = TRUE),
      # selectInput("propensity", "Select propensities to buy", choices = propensities, selected = "", multiple  = TRUE),
      # selectInput("contract", "Select contract types", choices = contracts, selected = "", multiple  = TRUE),
      # "This app compares the effectiveness of two types of free trials, A (30-days) and B (100-days), at converting users into customers.",
      
      tags$img(src = "terra_logo_color.png", width = "100%", height = "auto")
      
    ),
    
    # Layout non-sidebar elements
    body = dashboardBody(  
      use_theme(mytheme),
      # layout_columns(
      tabItems(
        tabItem("mi_portfolio",
                fluidRow(
                  p("Premium and Liability by State and Interval:", style = "color:#CEC49C; font-size:20px"),
                  # textOutput("no_input_message"),
                  img(src = "images/portfolio_table_bystate.png", height = "auto", width = "600px"),
                  img(src = "images/portfolio_map.png", height = "auto", width = "600px"),
                  p("Gross Premium in interval 6: 18.3m USD", style = "color:#CEC49C; font-size:20px")
                  # plotOutput(outputId = "portfolio_plot1"),
                  # plotOutput(outputId = "portfolio_plot2"),
                  # plotOutput(outputId = "portfolio_plot3")
                )  
        ),
        tabItem("mi_weather",
                fluidRow(
                  textOutput("no_input_message"),
                  img(src = "images/precip_monthly_anomaly_2024_06.png", height = "auto", width = "600px"),
                  img(src = "images/precip_monthly_anomaly_2024_07.png", height = "auto", width = "600px"),
                  img(src = "images/precip_interval_anomaly_2024_06.png", height = "auto", width = "600px"),
                  img(src = "images/results_table_grosslr_interval_2024_06.png", height = "auto", width = "600px"),
                  img(src = "images/results_map_grosslr_interval_2024_06.png", height = "auto", width = "600px"),
                  img(src = "images/results_table_grosslr_interval_2024_06.png", height = "auto", width = "600px"),
                  img(src = "images/precip_table_interval_2024_06.png", height = "auto", width = "600px")
                  # plotOutput(outputId = "weather_plot1"),
                  # plotOutput(outputId = "weather_plot2"),
                  # plotOutput(outputId = "weather_plot3")
                )  
        ),
        tabItem("mi_strat",
                fluidRow(
                  textOutput("no_input_message"),
                  img(src = "images/strategy_table_bystate.png", height = "auto", width = "600px"),
                  img(src = "images/strategy_map.png", height = "auto", width = "600px")
                  # plotOutput(outputId = "strat_plot1"),
                  # plotOutput(outputId = "strat_plot2"),
                  # plotOutput(outputId = "strat_plot3")
                )  
        ),
        tabItem("mi_stratperformance",
                fluidRow(
                  textOutput("no_input_message"),
                  img(src = "images/modelperformance_grosslr_interval_2024_06_allstates.png", height = "auto", width = "600px"),
                  img(src = "images/modelperformance_grosslr_interval_2024_06_TX_CA.png", height = "auto", width = "600px"),
                  img(src = "images/modelperformance_grosslr_interval_2024_06_AR_CO.png", height = "auto", width = "600px"),
                  img(src = "images/modelperformance_grosslr_interval_2024_06_FL_NE.png", height = "auto", width = "600px"),
                  img(src = "images/modelperformance_grosslr_interval_2024_06_NM_OR.png", height = "auto", width = "600px")
                  # plotOutput(outputId = "stratperformance_plot1"),
                  # plotOutput(outputId = "stratperformance_plot2"),
                  # plotOutput(outputId = "stratperformance_plot3")
                )  
        )
        
        # card(card_header("Conversions over time"),
        #                   plotOutput("line")),
        #              card(card_header("Conversion rates"),
        #                   plotOutput("bar")),
        #              value_box(title = "Recommended Trial",
        #                        value = textOutput("recommended_eval"),
        #                        theme_color = "secondary"),
        #              value_box(title = "Customers",
        #                        value = textOutput("number_of_customers"),
        #                        theme_color = "secondary"),
        #              value_box(title = "Avg Spend",
        #                        value = textOutput("average_spend"),
        #                        theme_color = "secondary"),
        #              card(card_header("Conversion rates by subgroup"),
        #                   tableOutput("table")),
        #              col_widths = c(8, 4, 4, 4, 4, 12),
        #              row_heights = c(4, 1.5, 3))
      )
    )
  )
) 

## Server ----------------------------------------------------------------------------
# Define the Shiny server function
server <- function(input, output) {
  
  result_auth <- secure_server(check_credentials = check_credentials(credentials))
  
  output$res_auth <- renderPrint({
    reactiveValuesToList(result_auth)
  })
  
  # # Provide default values for industry, propensity, and contract selections
  # selected_industries <- reactive({
  #   if (is.null(input$industry)) industries else input$industry
  # })
  # 
  # selected_propensities <- reactive({
  #   if (is.null(input$propensity)) propensities else input$propensity
  # })
  # 
  # selected_contracts <- reactive({
  #   if (is.null(input$contract)) contracts else input$contract
  # })
  # 
  # # Filter data against selections
  # filtered_expansions <- reactive({
  #   expansions |>
  #     filter(industry %in% selected_industries(),
  #            propensity %in% selected_propensities(),
  #            contract %in% selected_contracts())
  # })
  # 
  # # Compute conversions by month
  # conversions <- reactive({
  #   filtered_expansions() |>
  #     mutate(date = floor_date(date, unit = "month")) |>
  #     group_by(date, evaluation) |>
  #     summarize(n = sum(outcome == "Won")) |>
  #     ungroup()
  # })
  # 
  # # Retrieve conversion rates for selected groups
  # groups <- reactive({
  #   expansion_groups |>
  #     filter(industry %in% selected_industries(),
  #            propensity %in% selected_propensities(),
  #            contract %in% selected_contracts())
  # })
  # 
  # # Render text for recommended trial
  # output$recommended_eval <- renderText({
  #   recommendation <-
  #     filtered_expansions() |>
  #     group_by(evaluation) |>
  #     summarise(rate = mean(outcome == "Won")) |>
  #     filter(rate == max(rate)) |>
  #     pull(evaluation)
  #   
  #   as.character(recommendation[1])
  # })
  # 
  # # Render text for number of customers
  # output$number_of_customers <- renderText({
  #   sum(filtered_expansions()$outcome == "Won") |>
  #     format(big.mark = ",")
  # })
  # 
  # # Render text for average spend
  # output$average_spend <- renderText({
  #   x <-
  #     filtered_expansions() |>
  #     filter(outcome == "Won") |>
  #     summarise(spend = round(mean(amount))) |>
  #     pull(spend)
  #   
  #   str_glue("${x}")
  # })
  # 
  # # Render line plot for conversions over time
  # output$line <- renderPlot({
  #   ggplot(conversions(), aes(x = date, y = n, color = evaluation)) +
  #     geom_line() +
  #     theme(axis.title = element_blank()) +
  #     labs(color = "Trial Type")
  # })
  # 
  # # Render bar plot for conversion rates by subgroup
  # output$bar <- renderPlot({
  #   groups() |>
  #     group_by(evaluation) |>
  #     summarise(rate = round(sum(n * success_rate) / sum(n), 2)) |>
  #     ggplot(aes(x = evaluation, y = rate, fill = evaluation)) +
  #     geom_col() +
  #     guides(fill = "none") +
  #     theme(axis.title = element_blank()) +
  #     scale_y_continuous(limits = c(0, 100))
  # })
  # 
  # # Render table for conversion rates by subgroup
  # output$table <- renderTable({
  #   groups() |>
  #     select(industry, propensity, contract, evaluation, success_rate) |>
  #     pivot_wider(names_from = evaluation, values_from = success_rate)
  # },
  # digits = 0)
}

## App ----------------------------------------------------------------------------
# Create the Shiny app
shinyApp(ui = ui, server = server)

## END----------------------------------------------------------------------------

