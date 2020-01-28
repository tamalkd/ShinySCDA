library(shiny)
library(shinythemes)
library(readxl)
library(graphics)
library(utils)
library(markdown)
library(plotly)

library(SCRT)
library(SCVA)
library(SCMA)

source("helpers.R")

server <- function(input, output) 
{
  # Parameters shared by tabs
  Params <- reactiveValues(
    Design_Type = "AB",
    SCRT_Num_MT = 10,
    SCRT_Extra_Input = NULL,
    Test_Statistic = "A-B",
    Custom_Statistic = "mean(A) - mean(B)",
    Treatment_Labels = NULL
  )
  
  ########################################################
  # Design
  ########################################################
  
  # Number of possible assignments
  output$SCRTD1_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCRTD1_Design_Type", Params$Design_Type)})
  output$SCRTD1_Num_MT_UI <- renderUI({SCRT_Num_MT_func("SCRTD1_Num_MT", input$SCRTD1_Design_Type, Params$SCRT_Num_MT)})
  output$SCRTD1_Extra_Input_UI <- renderUI({SCRT_Extra_Input_func(
    "SCRTD1_Extra_Input", 
    input$SCRTD1_Design_Type, 
    input$SCRTD1_Num_MT,
    Params$Design_Type,
    Params$SCRT_Extra_Input
  )})

  SCRTD1_Result <- eventReactive(input$SCRTD1_Submit, {
    Params$Design_Type <- input$SCRTD1_Design_Type
    Params$SCRT_Num_MT <- input$SCRTD1_Num_MT
    Params$SCRT_Extra_Input <- input$SCRTD1_Extra_Input
    
    quantity(
      design = input$SCRTD1_Design_Type, 
      MT = input$SCRTD1_Num_MT, 
      limit = input$SCRTD1_Extra_Input, 
      starts = input$SCRTD1_Extra_Input$datapath,
      assignments = input$SCRTD1_Extra_Input$datapath
    )
  })
  output$SCRTD1_Result <- renderText({SCRTD1_Result()})
  
  # Display all possible assignments
  output$SCRTD2_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCRTD2_Design_Type", Params$Design_Type)})
  output$SCRTD2_Num_MT_UI <- renderUI({SCRT_Num_MT_func("SCRTD2_Num_MT", input$SCRTD2_Design_Type, Params$SCRT_Num_MT)})
  output$SCRTD2_Extra_Input_UI <- renderUI({SCRT_Extra_Input_func(
    "SCRTD2_Extra_Input", 
    input$SCRTD2_Design_Type, 
    input$SCRTD2_Num_MT,
    Params$Design_Type,
    Params$SCRT_Extra_Input
  )})
  
  SCRTD2_Result <- eventReactive(input$SCRTD2_Submit, {
    Params$Design_Type <- input$SCRTD2_Design_Type
    Params$SCRT_Num_MT <- input$SCRTD2_Num_MT
    Params$SCRT_Extra_Input <- input$SCRTD2_Extra_Input
    
    as.data.frame(assignments(
      design = input$SCRTD2_Design_Type, 
      MT = input$SCRTD2_Num_MT, 
      limit = input$SCRTD2_Extra_Input, 
      starts = input$SCRTD2_Extra_Input$datapath,
      assignments = input$SCRTD2_Extra_Input$datapath
    ))
  })
  
  observeEvent(input$SCRTD2_Submit, {
    output$SCRTD2_Download_UI <- renderUI({downloadButton("SCRTD2_Download", "Download assignments")})
  })
  output$SCRTD2_Download <- downloadHandler(
    filename = "assignments.txt",
    content = function(file) 
    {
      write.table(SCRTD2_Result(), file = file, col.names = FALSE, row.names = FALSE, eol = "\r\n")
    }
  )
  
  output$SCRTD2_Result <- renderTable({
    SCRT_Validate_Size_func(SCRTD2_Result())
    SCRTD2_Result()
  })
  
  # Choose 1 possble assignment
  output$SCRTD3_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCRTD3_Design_Type", Params$Design_Type)})
  output$SCRTD3_Num_MT_UI <- renderUI({SCRT_Num_MT_func("SCRTD3_Num_MT", input$SCRTD3_Design_Type, Params$SCRT_Num_MT)})
  output$SCRTD3_Extra_Input_UI <- renderUI({SCRT_Extra_Input_func(
    "SCRTD3_Extra_Input", 
    input$SCRTD3_Design_Type, 
    input$SCRTD3_Num_MT,
    Params$Design_Type,
    Params$SCRT_Extra_Input
  )})

  SCRTD3_Result <- eventReactive(input$SCRTD3_Submit, {
    Params$Design_Type <- input$SCRTD3_Design_Type
    Params$SCRT_Num_MT <- input$SCRTD3_Num_MT
    Params$SCRT_Extra_Input <- input$SCRTD3_Extra_Input
    
    selectdesign(
      design = input$SCRTD3_Design_Type, 
      MT = input$SCRTD3_Num_MT, 
      limit = input$SCRTD3_Extra_Input, 
      starts = input$SCRTD3_Extra_Input$datapath,
      assignments = input$SCRTD3_Extra_Input$datapath
    )
  })
  output$SCRTD3_Result <- renderTable({SCRTD3_Result()})
  
  ########################################################
  # Data
  ########################################################
  
  # Set data
  Data <- reactiveValues(Orig_Table = NULL, Table = NULL, File_Type = NULL)
  output$Data_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("Data_Design_Type", Params$Design_Type)})
  
  observeEvent(input$Data_Set_File, {
    Data$File_Type <- tolower(tail(unlist(strsplit(input$Data_Set_File$name, ".", fixed = TRUE)), n = 1))
  })
  
  output$Data_Col_Header_UI <- renderUI({
    if(!is.null(input$Data_Set_File))
    {
      if(Data$File_Type %in% c("csv", "txt", "xls", "xlsx"))
        checkboxInput("Data_Col_Header", "File contains column headers", value = Data$File_Type != "txt")
    }
  })
  output$Data_Sheet_Idx_UI <- renderUI({
    if(!is.null(input$Data_Set_File))
    {
      if(Data$File_Type %in% c("xls", "xlsx"))
        numericInput("Data_Sheet_Idx", "Sheet Number", 1)
    }
  })
  output$Data_Treatment_Label_UI <- renderUI({SCDA_Treatment_Labels_func("Data", input$Data_Design_Type)})
  
  Data_Result <- eventReactive(input$Data_Set_Load, {
    SCDA_Validate_File_func(input$Data_Set_File)
    Params$Design_Type <- input$Data_Design_Type
    Params$Treatment_Labels <- SCDA_Get_User_Labels_func("Data", input)
    
    if(!Data$File_Type %in% c("csv", "txt", "xls", "xlsx", "rdata", "rda"))
      stop("Unsupported file type. Only Text, Excel, CSV, and R data files are supported!")
    
    Data$Orig_Table <- switch(Data$File_Type,
      "csv" = read.csv(input$Data_Set_File$datapath, header = input$Data_Col_Header),
      "txt" = read.table(input$Data_Set_File$datapath, header = input$Data_Col_Header),
      "rda" = get(load(input$Data_Set_File$datapath)),
      "rdata" = get(load(input$Data_Set_File$datapath)),
      "xls" = as.data.frame(read_excel(
        input$Data_Set_File$datapath, sheet = input$Data_Sheet_Idx, col_names = input$Data_Col_Header, na = "NA"
      )),
      "xlsx" = as.data.frame(read_excel(
        input$Data_Set_File$datapath, sheet = input$Data_Sheet_Idx, col_names = input$Data_Col_Header, na = "NA"
      ))
    )
    
    Data$Table <- SCDA_Data_Relabel_func(input$Data_Design_Type, Data$Orig_Table, Params$Treatment_Labels)
    Data$Orig_Table
  })
  output$Data_Set_Table <- renderTable({Data_Result()})
  
  ########################################################
  # Visual Analysis
  ########################################################
  
  # Plot data
  output$SCVA1_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCVA1_Design_Type", Params$Design_Type)})
  output$SCVA1_Treatment_Label_UI <- renderUI({SCDA_Treatment_Labels_func(
    "SCVA1", 
    input$SCVA1_Design_Type, 
    Params$Treatment_Labels
  )})
  output$SCVA1_YRange_UI <- renderUI({SCVA_Min_Max_UI_func(
    "SCVA1_YRange", 
    Min_Label = "Y-axis minimum",
    Max_Label = "Y-axis maximum"
  )})
  output$SCVA1_LegendXY_UI <- renderUI({SCVA_LegendXY_func("SCVA1_LegendXY", Data$Table, input$SCVA1_Design_Type)})
  
  SCVA1_Plot <- eventReactive(input$SCVA1_Button, {
    SCDA_Validate_Data_func(Data$Table)
    SCVA_Validate_Range_func(input$SCVA1_YRange_Min, input$SCVA1_YRange_Max)
    Params$Design_Type <- input$SCVA1_Design_Type
    Params$Treatment_Labels <- SCDA_Get_User_Labels_func("SCVA1", input)
    
    graph(
      design = input$SCVA1_Design_Type, 
      xlab = input$SCVA1_Xlabel,
      ylab = input$SCVA1_Ylabel,
      ylim = if(is.na(input$SCVA1_YRange_Min)) NULL else c(input$SCVA1_YRange_Min, input$SCVA1_YRange_Max),
      legendxy = c(input$SCVA1_LegendXY_X, input$SCVA1_LegendXY_Y),
      labels = Params$Treatment_Labels,
      data = Data$Table
    )
  })
  output$SCVA1_Plot <- renderPlot(
    height = eventReactive(input$SCVA1_Button, {SCVA_Plot_Height_func(input$SCVA1_Design_Type, Data$Table)}), 
    {SCVA1_Plot()}
  )
  
  # Plot measure of central tencency
  output$SCVA2_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCVA2_Design_Type", Params$Design_Type)})
  output$SCVA2_Extra_Param_UI <- renderUI({SCVA_Extra_Param_func("SCVA2_Extra_Param", input$SCVA2_Central_Measure)})
  output$SCVA2_Treatment_Label_UI <- renderUI({SCDA_Treatment_Labels_func(
    "SCVA2", 
    input$SCVA2_Design_Type, 
    Params$Treatment_Labels
  )})
  output$SCVA2_YRange_UI <- renderUI({SCVA_Min_Max_UI_func(
    "SCVA2_YRange", 
    Min_Label = "Y-axis minimum",
    Max_Label = "Y-axis maximum"
  )})
  output$SCVA2_LegendXY_UI <- renderUI({SCVA_LegendXY_func("SCVA2_LegendXY", Data$Table, input$SCVA2_Design_Type)})
  
  SCVA2_Plot <- eventReactive(input$SCVA2_Button, {
    SCDA_Validate_Data_func(Data$Table)
    SCVA_Validate_Range_func(input$SCVA2_YRange_Min, input$SCVA2_YRange_Max)
    Params$Design_Type <- input$SCVA2_Design_Type
    Params$Treatment_Labels <- SCDA_Get_User_Labels_func("SCVA2", input)
    
    graph.CL(
      design = input$SCVA2_Design_Type, 
      CL = input$SCVA2_Central_Measure, 
      tr = input$SCVA2_Extra_Param, 
      xlab = input$SCVA2_Xlabel,
      ylab = input$SCVA2_Ylabel,
      ylim = if(is.na(input$SCVA2_YRange_Min)) NULL else c(input$SCVA2_YRange_Min, input$SCVA2_YRange_Max),
      legendxy = c(input$SCVA2_LegendXY_X, input$SCVA2_LegendXY_Y),
      labels = Params$Treatment_Labels,
      data = Data$Table
    )
  })
  output$SCVA2_Plot <- renderPlot(
    height = eventReactive(input$SCVA2_Button, {SCVA_Plot_Height_func(input$SCVA2_Design_Type, Data$Table)}),
    {SCVA2_Plot()}
  )
  
  # Plot estimate of variability
  output$SCVA3_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCVA3_Design_Type", Params$Design_Type)})
  output$SCVA3_Central_Measure_UI <- renderUI({
    if(input$SCVA3_Variability_Measure == "RB")
      SCVA_Central_Measure_func("SCVA3_Central_Measure")
  })
  output$SCVA3_Extra_Param_UI <- renderUI({
    if(input$SCVA3_Variability_Measure == "RB" && !is.null(input$SCVA3_Central_Measure))
      SCVA_Extra_Param_func("SCVA3_Extra_Param", input$SCVA3_Central_Measure)
  })
  
  output$SCVA3_Treatment_Label_UI <- renderUI({SCDA_Treatment_Labels_func(
    "SCVA3", 
    input$SCVA3_Design_Type, 
    Params$Treatment_Labels
  )})
  output$SCVA3_YRange_UI <- renderUI({SCVA_Min_Max_UI_func(
    "SCVA3_YRange", 
    Min_Label = "Y-axis minimum",
    Max_Label = "Y-axis maximum"
  )})
  output$SCVA3_LegendXY_UI <- renderUI({SCVA_LegendXY_func("SCVA3_LegendXY", Data$Table, input$SCVA3_Design_Type)})
  
  SCVA3_Plot <- eventReactive(input$SCVA3_Button, {
    SCDA_Validate_Data_func(Data$Table)
    SCVA_Validate_Range_func(input$SCVA3_YRange_Min, input$SCVA3_YRange_Max)
    Params$Design_Type <- input$SCVA3_Design_Type
    Params$Treatment_Labels <- SCDA_Get_User_Labels_func("SCVA3", input)
    
    graph.VAR(
      design = input$SCVA3_Design_Type, 
      VAR = input$SCVA3_Variability_Measure,
      CL = input$SCVA3_Central_Measure, 
      tr = input$SCVA3_Extra_Param, 
      dataset = input$SCVA3_Trim,
      xlab = input$SCVA3_Xlabel,
      ylab = input$SCVA3_Ylabel,
      ylim = if(is.na(input$SCVA3_YRange_Min)) NULL else c(input$SCVA3_YRange_Min, input$SCVA3_YRange_Max),
      legendxy = c(input$SCVA3_LegendXY_X, input$SCVA3_LegendXY_Y),
      labels = Params$Treatment_Labels,
      data = Data$Table
    )
  })
  output$SCVA3_Plot <- renderPlot(
    height = eventReactive(input$SCVA3_Button, {SCVA_Plot_Height_func(input$SCVA3_Design_Type, Data$Table)}),
    {SCVA3_Plot()}
  )
  
  # Plot estimate of trend
  output$SCVA4_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCVA4_Design_Type", Params$Design_Type)})
  output$SCVA4_Central_Measure_UI <- renderUI({
    if(input$SCVA4_Trend_Measure == "VLP")
      SCVA_Central_Measure_func("SCVA4_Central_Measure")
  })
  output$SCVA4_Extra_Param_UI <- renderUI({
    if(input$SCVA4_Trend_Measure == "VLP" && !is.null(input$SCVA4_Central_Measure))
      SCVA_Extra_Param_func("SCVA4_Extra_Param", input$SCVA4_Central_Measure)
  })
  
  output$SCVA4_Treatment_Label_UI <- renderUI({SCDA_Treatment_Labels_func(
    "SCVA4", 
    input$SCVA4_Design_Type, 
    Params$Treatment_Labels
  )})
  output$SCVA4_YRange_UI <- renderUI({SCVA_Min_Max_UI_func(
    "SCVA4_YRange", 
    Min_Label = "Y-axis minimum",
    Max_Label = "Y-axis maximum"
  )})
  output$SCVA4_LegendXY_UI <- renderUI({SCVA_LegendXY_func("SCVA4_LegendXY", Data$Table, input$SCVA4_Design_Type)})
  
  SCVA4_Plot <- eventReactive(input$SCVA4_Button, {
    SCDA_Validate_Data_func(Data$Table)
    SCVA_Validate_Range_func(input$SCVA4_YRange_Min, input$SCVA4_YRange_Max)
    Params$Design_Type <- input$SCVA4_Design_Type
    Params$Treatment_Labels <- SCDA_Get_User_Labels_func("SCVA4", input)
    
    graph.TREND(
      design = input$SCVA4_Design_Type, 
      TREND = input$SCVA4_Trend_Measure,
      CL = input$SCVA4_Central_Measure, 
      tr = input$SCVA4_Extra_Param, 
      xlab = input$SCVA4_Xlabel,
      ylab = input$SCVA4_Ylabel,
      ylim = if(is.na(input$SCVA4_YRange_Min)) NULL else c(input$SCVA4_YRange_Min, input$SCVA4_YRange_Max),
      legendxy = c(input$SCVA4_LegendXY_X, input$SCVA4_LegendXY_Y),
      labels = Params$Treatment_Labels,
      data = Data$Table
    )
  })
  output$SCVA4_Plot <- renderPlot(
    height = eventReactive(input$SCVA4_Button, {SCVA_Plot_Height_func(input$SCVA4_Design_Type, Data$Table)}),
    {SCVA4_Plot()}
  )
  
  # Plot interactive graph
  output$SCVA5_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCVA5_Design_Type", Params$Design_Type)})
  output$SCVA5_Treatment_Label_UI <- renderUI({SCDA_Treatment_Labels_func(
    "SCVA5", 
    input$SCVA5_Design_Type, 
    Params$Treatment_Labels
  )})
  output$SCVA5_YRange_UI <- renderUI({SCVA_Min_Max_UI_func(
    "SCVA5_YRange", 
    Min_Label = "Y-axis minimum",
    Max_Label = "Y-axis maximum"
  )})
  
  SCVA5_Plot <- eventReactive(input$SCVA5_Button, {
    SCDA_Validate_Data_func(Data$Table)
    SCVA_Validate_Range_func(input$SCVA5_YRange_Min, input$SCVA5_YRange_Max)
    Params$Design_Type <- input$SCVA5_Design_Type
    Params$Treatment_Labels <- SCDA_Get_User_Labels_func("SCVA5", input)
    
    graphly(
      design = input$SCVA5_Design_Type, 
      xlab = input$SCVA5_Xlabel,
      ylab = input$SCVA5_Ylabel,
      ylim = if(is.na(input$SCVA5_YRange_Min)) NULL else c(input$SCVA5_YRange_Min, input$SCVA5_YRange_Max),
      labels = Params$Treatment_Labels,
      data = Data$Table
    )
  })
  
  output$SCVA5_Plot <- renderPlotly({SCVA5_Plot()})
  output$SCVA5_Plot_UI <- renderUI({plotlyOutput(
    "SCVA5_Plot", 
    height = paste(SCVA_Plot_Height_func(input$SCVA5_Design_Type, Data$Table), "px", sep = "")
  )})
  
  ########################################################
  # Randomization Test
  ########################################################
  
  # Observed test statistic
  output$SCRTA1_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCRTA1_Design_Type", Params$Design_Type)})
  output$SCRTA1_Test_Statistic_UI <- renderUI({SCRT_Test_Statistic_func(
    "SCRTA1_Test_Statistic", 
    input$SCRTA1_Design_Type,
    Params$Test_Statistic
  )})
  output$SCRTA1_Custom_Stat_UI <- renderUI({SCRT_Custom_Statistic_func(
    "SCRTA1_Custom_Statistic", 
    input$SCRTA1_Test_Statistic,
    Params$Custom_Statistic
  )})
  
  SCRTA1_Result <- eventReactive(input$SCRTA1_Button, {
    SCDA_Validate_Data_func(Data$Table)
    Params$Design_Type <- input$SCRTA1_Design_Type
    Params$Test_Statistic <- input$SCRTA1_Test_Statistic
    
    statistic <- if(input$SCRTA1_Test_Statistic == "Custom") 
      Params$Custom_Statistic <- input$SCRTA1_Custom_Statistic
    else input$SCRTA1_Test_Statistic
      
    observed(design = input$SCRTA1_Design_Type, statistic = statistic, data = Data$Table)
  })
  output$SCRTA1_Result <- renderText({SCRTA1_Result()})
  
  # Randomization distribution
  output$SCRTA2_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCRTA2_Design_Type", Params$Design_Type)})
  output$SCRTA2_Extra_Input_UI <- renderUI({SCRT_Extra_Input_func(
    "SCRTA2_Extra_Input", 
    input$SCRTA2_Design_Type, 
    nrow(Data$Table),
    Params$Design_Type,
    Params$SCRT_Extra_Input
  )})
  output$SCRTA2_Test_Statistic_UI <- renderUI({SCRT_Test_Statistic_func(
    "SCRTA2_Test_Statistic", 
    input$SCRTA2_Design_Type,
    Params$Test_Statistic
  )})
  output$SCRTA2_Custom_Stat_UI <- renderUI({SCRT_Custom_Statistic_func(
    "SCRTA2_Custom_Statistic", 
    input$SCRTA2_Test_Statistic,
    Params$Custom_Statistic
  )})
  output$SCRTA2_Num_MC_UI <- renderUI({SCRT_Num_MonteCarlo_func("SCRTA2_Num_MC", input$SCRTA2_Random_Dist)})
  
  SCRTA2_Result <- eventReactive(input$SCRTA2_Button, {
    withProgress(
      message = "Calculating...", 
      {
        SCDA_Validate_Data_func(Data$Table)
        Params$Design_Type <- input$SCRTA2_Design_Type
        Params$SCRT_Extra_Input <- input$SCRTA2_Extra_Input
        Params$Test_Statistic <- input$SCRTA2_Test_Statistic
        
        statistic <- if(input$SCRTA2_Test_Statistic == "Custom") 
          Params$Custom_Statistic <- input$SCRTA2_Custom_Statistic
        else input$SCRTA2_Test_Statistic
        
        switch(input$SCRTA2_Random_Dist,
          "systematic" = distribution.systematic(
            design = input$SCRTA2_Design_Type, 
            statistic = statistic, 
            limit = input$SCRTA2_Extra_Input,
            starts = input$SCRTA2_Extra_Input$datapath,
            assignments = input$SCRTA2_Extra_Input$datapath,
            data = Data$Table
          ),
          "random" = distribution.random(
            design = input$SCRTA2_Design_Type, 
            statistic = statistic, 
            limit = input$SCRTA2_Extra_Input,
            starts = input$SCRTA2_Extra_Input$datapath,
            assignments = input$SCRTA2_Extra_Input$datapath,
            number = input$SCRTA2_Num_MC,
            data = Data$Table
          )
        )
      }
    )
  })
  
  SCRTA2_Statistic <- eventReactive(input$SCRTA2_Button, {
    SCDA_Validate_Data_func(Data$Table)
    statistic <- if(input$SCRTA2_Test_Statistic == "Custom") input$SCRTA2_Custom_Statistic
    else input$SCRTA2_Test_Statistic
    observed(design = input$SCRTA2_Design_Type, statistic = statistic, data = Data$Table)
  })
  
  SCRTA2_Statistic_Label <- eventReactive(input$SCRTA2_Button, {
    if(input$SCRTA2_Test_Statistic == "Custom") input$SCRTA2_Custom_Statistic
    else input$SCRTA2_Test_Statistic
  })
  
  output$SCRTA2_Plot <- renderPlot({
    Hist = hist(SCRTA2_Result())
    Hist$density = Hist$counts / sum(Hist$counts)
    plot(
      Hist, 
      freq = FALSE, 
      main = "Histogram of distribution", 
      xlab = SCRTA2_Statistic_Label(), 
      ylab = "Proportion",
      sub = "(Blue line is observed test statistic)"
    )
    abline(v = SCRTA2_Statistic(), col = "blue")
  })
  
  observeEvent(input$SCRTA2_Button, {
    output$SCRTA2_Download_UI <- renderUI({downloadButton("SCRTA2_Download", "Download distribution")})
  })
  output$SCRTA2_Download <- downloadHandler(
    filename = "distribution.txt",
    content = function(file) 
    {
      write.table(SCRTA2_Result(), file = file, col.names = FALSE, row.names = FALSE, eol = "\r\n")
    }
  )
  
  output$SCRTA2_Result <- renderTable({
    SCRT_Validate_Size_func(SCRTA2_Result())
    SCRTA2_Result()
  })
  
  # P-value
  output$SCRTA3_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCRTA3_Design_Type", Params$Design_Type)})
  output$SCRTA3_Extra_Input_UI <- renderUI({SCRT_Extra_Input_func(
    "SCRTA3_Extra_Input", 
    input$SCRTA3_Design_Type, 
    nrow(Data$Table),
    Params$Design_Type,
    Params$SCRT_Extra_Input
  )})
  output$SCRTA3_Test_Statistic_UI <- renderUI({SCRT_Test_Statistic_func(
    "SCRTA3_Test_Statistic", 
    input$SCRTA3_Design_Type,
    Params$Test_Statistic
  )})
  output$SCRTA3_Custom_Stat_UI <- renderUI({SCRT_Custom_Statistic_func(
    "SCRTA3_Custom_Statistic", 
    input$SCRTA3_Test_Statistic,
    Params$Custom_Statistic
  )})
  output$SCRTA3_Num_MC_UI <- renderUI({SCRT_Num_MonteCarlo_func("SCRTA3_Num_MC", input$SCRTA3_Random_Dist)})
  
  SCRTA3_Result <- eventReactive(input$SCRTA3_Button, {
    SCDA_Validate_Data_func(Data$Table)
    Params$Design_Type <- input$SCRTA3_Design_Type
    Params$SCRT_Extra_Input <- input$SCRTA3_Extra_Input
    Params$Test_Statistic <- input$SCRTA3_Test_Statistic
    
    statistic <- if(input$SCRTA3_Test_Statistic == "Custom") 
      Params$Custom_Statistic <- input$SCRTA3_Custom_Statistic
    else input$SCRTA3_Test_Statistic
    
    switch(input$SCRTA3_Random_Dist,
      "systematic" = pvalue.systematic(
        design = input$SCRTA3_Design_Type, 
        statistic = statistic, 
        limit = input$SCRTA3_Extra_Input,
        starts = input$SCRTA3_Extra_Input$datapath,
        assignments = input$SCRTA3_Extra_Input$datapath,
        data = Data$Table
      ),
      "random" = pvalue.random(
        design = input$SCRTA3_Design_Type, 
        statistic = statistic, 
        limit = input$SCRTA3_Extra_Input,
        starts = input$SCRTA3_Extra_Input$datapath,
        assignments = input$SCRTA3_Extra_Input$datapath,
        number = input$SCRTA3_Num_MC,
        data = Data$Table
      )
    )
  })
  output$SCRTA3_Result <- renderText({withProgress(message = "Calculating...", SCRTA3_Result())})
  
  ########################################################
  # Meta-Analysis
  ########################################################
  
  # Calculate effect size
  output$SCMA1_Design_Type_UI <- renderUI({SCDA_Design_Dropdown_func("SCMA1_Design_Type", Params$Design_Type)})
  SCMA1_Result <- eventReactive(input$SCMA1_Button, {
    SCDA_Validate_Data_func(Data$Table)
    Params$Design_Type <- input$SCMA1_Design_Type
    ES(design = input$SCMA1_Design_Type, ES = input$SCMA1_Effect_Measure, data = Data$Table)
  })
  output$SCMA1_Result <- renderText({SCMA1_Result()})
  
  # Combine p-values
  SCMA2_Result <- eventReactive(input$SCMA2_Button, {
    SCDA_Validate_File_func(input$SCMA2_File)
    pvalues = read.table(input$SCMA2_File$datapath)
    validate(need(
      ncol(pvalues) == 1, 
      paste("Input data should have only one column with p-values, found", ncol(pvalues), "columns.")
    ))
    combine(method = input$SCMA2_Combine_Method, pvalues = pvalues)
  })
  output$SCMA2_Result <- renderText({SCMA2_Result()})
  
}

ui <- navbarPage( 
  theme = shinytheme("flatly"),
  "Single Case Data Analysis (v2.5)",
  
  ########################################################
  # Design
  ########################################################
  
  tabPanel(
    "Design", 
    navlistPanel(
      widths = c(2, 10),
      
      # Number of possible assignments
      tabPanel(
        "Number of possible assignments",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCRTD1_Design_Type_UI"),
            uiOutput("SCRTD1_Extra_Input_UI"),
            uiOutput("SCRTD1_Num_MT_UI"),
            actionButton("SCRTD1_Submit", "Submit")
          ),
          
          mainPanel(
            tags$h4("Result"),
            textOutput("SCRTD1_Result")
          )
        )
      ),
      
      # Display all possible assignments
      tabPanel(
        "Display all possible assignments",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCRTD2_Design_Type_UI"),
            uiOutput("SCRTD2_Extra_Input_UI"),
            uiOutput("SCRTD2_Num_MT_UI"),
            actionButton("SCRTD2_Submit", "Submit")
          ),
          mainPanel(
            tags$h4("Result"),
            uiOutput("SCRTD2_Download_UI"),
            tableOutput("SCRTD2_Result")
          )
        )
      ),
      
      # Choose 1 possible assignment
      tabPanel(
        "Choose 1 possible assignment",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCRTD3_Design_Type_UI"),
            uiOutput("SCRTD3_Extra_Input_UI"),
            uiOutput("SCRTD3_Num_MT_UI"),
            actionButton("SCRTD3_Submit", "Submit")
          ),
          mainPanel(
            tags$h4("Result"),
            tableOutput("SCRTD3_Result")
          )
        )
      )
      
    )
  ),
  
  ########################################################
  # Data
  ########################################################
  
  tabPanel(
    "Data",
    navlistPanel(
      widths = c(2, 10),
      
      # Set Data
      tabPanel(
        "Set Data",
        sidebarLayout(
          sidebarPanel(
            uiOutput("Data_Design_Type_UI"),
            fileInput("Data_Set_File", "Select data file"),
            uiOutput("Data_Col_Header_UI"),
            uiOutput("Data_Sheet_Idx_UI"),
            uiOutput("Data_Treatment_Label_UI"),
            actionButton("Data_Set_Load", "Load")
          ),
          mainPanel(
            tags$h4("Active Dataset"),
            tableOutput("Data_Set_Table")
          )
        )
      )
      
    )
  ),
  
  ########################################################
  # Visual Analysis
  ########################################################
  
  tabPanel(
    "Visual Analysis",
    navlistPanel(
      widths = c(2, 10),
      
      # Plot data
      tabPanel(
        "Plot observed data",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCVA1_Design_Type_UI"),
            textInput("SCVA1_Xlabel", "X-axis label", "Measurement Times"),
            textInput("SCVA1_Ylabel", "Y-axis label", "Scores"),
            uiOutput("SCVA1_Treatment_Label_UI"),
            uiOutput("SCVA1_YRange_UI"),
            uiOutput("SCVA1_LegendXY_UI"),
            actionButton("SCVA1_Button", "Plot")
          ),
          mainPanel(
            tags$h4("Plot"),
            plotOutput("SCVA1_Plot")
          )
        )
      ),
      
      # Plot measure of central tendency
      tabPanel(
        "Plot measure of central tendency",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCVA2_Design_Type_UI"),
            SCVA_Central_Measure_func("SCVA2_Central_Measure"),
            uiOutput("SCVA2_Extra_Param_UI"),
            textInput("SCVA2_Xlabel", "X-axis label", "Measurement Times"),
            textInput("SCVA2_Ylabel", "Y-axis label", "Scores"),
            uiOutput("SCVA2_Treatment_Label_UI"),
            uiOutput("SCVA2_YRange_UI"),
            uiOutput("SCVA2_LegendXY_UI"),
            actionButton("SCVA2_Button", "Plot")
          ),
          mainPanel(
            tags$h4("Plot"),
            plotOutput("SCVA2_Plot")
          )
        )
      ),

      # Plot estimate of variability
      tabPanel(
        "Plot estimate of variability",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCVA3_Design_Type_UI"),
            selectInput(
              "SCVA3_Variability_Measure",
              "Select the measure of variability",
              list("Range lines" = "RL", "Range bars" = "RB", "Trended range" = "TR")
            ),
            uiOutput("SCVA3_Central_Measure_UI"),
            uiOutput("SCVA3_Extra_Param_UI"),
            radioButtons(
              "SCVA3_Trim", 
              "Remove extreme values?", 
              list("Yes" = "trimmed", "No" = "regular"), 
              selected = "regular", 
              inline = TRUE
            ),
            textInput("SCVA3_Xlabel", "X-axis label", "Measurement Times"),
            textInput("SCVA3_Ylabel", "Y-axis label", "Scores"),
            uiOutput("SCVA3_Treatment_Label_UI"),
            uiOutput("SCVA3_YRange_UI"),
            uiOutput("SCVA3_LegendXY_UI"),
            actionButton("SCVA3_Button", "Plot")
          ),
          mainPanel(
            tags$h4("Plot"),
            plotOutput("SCVA3_Plot")
          )
        )
      ),

      # Plot estimate of trend
      tabPanel(
        "Plot estimate of trend",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCVA4_Design_Type_UI"),
            selectInput(
              "SCVA4_Trend_Measure",
              "Select the trend visualization",
              list(
                "Vertical line plot" = "VLP",
                "Trend lines (Least Squares regression)" = "LSR",
                "Trend lines (Split-middle)" = "SM",
                "Trend lines (Resistant trend line fitting)" = "RTL",
                "Running medians (batch size 3)" = "RM3",
                "Running medians (batch size 5)" = "RM5",
                "Running medians (batch size 4 averaged by pairs)" = "RM42"
              )
            ),
            uiOutput("SCVA4_Central_Measure_UI"),
            uiOutput("SCVA4_Extra_Param_UI"),
            textInput("SCVA4_Xlabel", "X-axis label", "Measurement Times"),
            textInput("SCVA4_Ylabel", "Y-axis label", "Scores"),
            uiOutput("SCVA4_Treatment_Label_UI"),
            uiOutput("SCVA4_YRange_UI"),
            uiOutput("SCVA4_LegendXY_UI"),
            actionButton("SCVA4_Button", "Plot")
          ),
          mainPanel(
            tags$h4("Plot"),
            plotOutput("SCVA4_Plot")
          )
        )
      ),
      
      # Plot interactive graph
      tabPanel(
        "Plot interactive graph",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCVA5_Design_Type_UI"),
            textInput("SCVA5_Xlabel", "X-axis label", "Measurement Times"),
            textInput("SCVA5_Ylabel", "Y-axis label", "Scores"),
            uiOutput("SCVA5_Treatment_Label_UI"),
            uiOutput("SCVA5_YRange_UI"),
            actionButton("SCVA5_Button", "Plot")
          ),
          mainPanel(
            tags$h4("Plot"),
            uiOutput("SCVA5_Plot_UI")
          )
        )
      )
      
    )
  ),
  
  ########################################################
  # Randomization Test
  ########################################################
  
  tabPanel(
    "Randomization Test",
    
    navlistPanel(
      widths = c(2, 10),
      
      # Observed test statistic
      tabPanel(
        "Observed test statistic",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCRTA1_Design_Type_UI"),
            uiOutput("SCRTA1_Test_Statistic_UI"),
            uiOutput("SCRTA1_Custom_Stat_UI"),
            actionButton("SCRTA1_Button", "Submit")
          ),
          mainPanel(
            tags$h4("Result"),
            textOutput("SCRTA1_Result")
          )
        )
      ),
      
      # Randomization distribution
      tabPanel(
        "Randomization distribution",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCRTA2_Design_Type_UI"),
            uiOutput("SCRTA2_Extra_Input_UI"),
            uiOutput("SCRTA2_Test_Statistic_UI"),
            uiOutput("SCRTA2_Custom_Stat_UI"),
            SCRT_Random_Dist_func("SCRTA2_Random_Dist"),
            uiOutput("SCRTA2_Num_MC_UI"),
            actionButton("SCRTA2_Button", "Submit")
          ),
          mainPanel(
            tags$h4("Plot"),
            plotOutput("SCRTA2_Plot"),
            tags$h4("Table"),
            uiOutput("SCRTA2_Download_UI"),
            tableOutput("SCRTA2_Result")
          )
        )
      ),
      
      # P-value
      tabPanel(
        "P-value",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCRTA3_Design_Type_UI"),
            uiOutput("SCRTA3_Extra_Input_UI"),
            uiOutput("SCRTA3_Test_Statistic_UI"),
            uiOutput("SCRTA3_Custom_Stat_UI"),
            SCRT_Random_Dist_func("SCRTA3_Random_Dist"),
            uiOutput("SCRTA3_Num_MC_UI"),
            actionButton("SCRTA3_Button", "Submit")
          ),
          mainPanel(
            tags$h4("Result"),
            textOutput("SCRTA3_Result")
          )
        )
      )
      
    )
  ),
  
  ########################################################
  # Meta-Analysis
  ########################################################
  
  tabPanel(
    "Meta-Analysis",
    
    navlistPanel(
      widths = c(2, 10),
      
      # Calculate effect size
      tabPanel(
        "Calculate effect size",
        sidebarLayout(
          sidebarPanel(
            uiOutput("SCMA1_Design_Type_UI"),
            selectInput(
              "SCMA1_Effect_Measure",
              "Select the effect size measure",
              list(
                "Standardized Mean Difference" = "SMD",
                "Pooled Standardized Mean Difference" = "SMDpool",
                "PND (expected increase)" = "PND+",
                "PND (expected decrease)" = "PND-",
                "PEM (expected increase)" = "PEM+",
                "PEM (expected decrease)" = "PEM-",
                "NAP (expected increase)" = "NAP+",
                "NAP (expected decrease)" = "NAP-"
              )
            ),
            actionButton("SCMA1_Button", "Submit")
          ),
          mainPanel(
            tags$h4("Result"),
            textOutput("SCMA1_Result")
          )
        )
      ),
      
      # Combine p-values
      tabPanel(
        "Combine p-values",
        sidebarLayout(
          sidebarPanel(
            radioButtons(
              "SCMA2_Combine_Method",
              "Select the combining method",
              list("Multiplicative" = "x", "Additive" = "+")
            ),
            fileInput("SCMA2_File", "Select text file containing p-values"),
            actionButton("SCMA2_Button", "Submit")
          ),
          mainPanel(
            tags$h4("Result"),
            textOutput("SCMA2_Result")
          )
        )
      )
      
    )
  ),
  
  ########################################################
  # Information
  ########################################################
  
  tabPanel(
    "Information",
    
    navlistPanel(
      widths = c(2, 10),
      
      # Help
      tabPanel(
        "Help",
        tabsetPanel(
          tabPanel("Getting started", includeMarkdown("help.md")),
          tabPanel("Design", includeMarkdown("design.md")),
          tabPanel("Data", includeMarkdown("data.md")),
          tabPanel("Visual Analysis", includeMarkdown("visual.md")),
          tabPanel("Randomization Test", includeMarkdown("randomization.md")),
          tabPanel("Meta-Analysis", includeMarkdown("meta.md"))
        )
      ),
      
      # About SCDA and authors
      tabPanel("About", fluidPage(includeMarkdown("about.md")))
      
    )
  )
  
)

shinyApp(ui = ui, server = server)
