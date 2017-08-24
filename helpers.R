library(shiny)
library(plyr)

SCDA_Design_Dropdown_func <- function(Widget_Name, selected = "AB")
{
  return(selectInput(
    Widget_Name,
    "Select the design type",
    list(
      "AB Phase Design" = "AB", 
      "ABA Phase Design" = "ABA", 
      "ABAB Phase Design" = "ABAB", 
      "Completely Randomized Design" = "CRD", 
      "Randomized Block Design" = "RBD", 
      "Alternating Treatments Design" = "ATD", 
      "Multiple Baseline Design" = "MBD",
      "User Specified Design" = "Custom"
    ),
    selected = selected
  ))
}

SCRT_Num_MT_func <- function(Widget_Name, Design_Type, Current = 10)
{
  if(!is.null(Design_Type))
  {
    if(Design_Type != "MBD" && Design_Type != "Custom")
      return(numericInput(Widget_Name, "Number of observations", Current))
  }
  
  return()
}

SCRT_Extra_Input_func <- function(Widget_Name, Design_Type, Num_MT, Prev_Design_Type, Current)
{
  if(!is.null(Design_Type))
  {
    if(Design_Type == "AB" || Design_Type == "ABA" || Design_Type == "ABAB")
    {
      Default = if(Design_Type == Prev_Design_Type && is.numeric(Current)) Current else 1
      return(numericInput(Widget_Name, "Minimum number of observations per phase", Default))
    } 
    else if(Design_Type == "ATD")
    {
      Default = if(Design_Type == Prev_Design_Type && is.numeric(Current)) Current else ceiling(Num_MT / 2)
      return(numericInput(Widget_Name, "Maximum number of consecutive administrations of the same condition", Default)) 
    }
    else if(Design_Type == "MBD")
      return(fileInput(Widget_Name, "Multiple Baseline Design: Select text file containing possible start points"))
    else if(Design_Type == "Custom")
      return(fileInput(Widget_Name, "User Specified Design: Select text file containing possible assignemnts"))
  }
  
  return()
}

SCDA_Default_Labels_func <- function(Design_Type)
{
  return(
    if(Design_Type == "ABA") c("A1", "B1", "A2")
    else if(Design_Type == "ABAB") c("A1", "B1", "A2", "B2")
    else c("A", "B")
  )
}

SCDA_Treatment_Labels_func <- function(Widget_Prefix, Design_Type, Values = NULL)
{
  if(!is.null(Design_Type))
  {
    if(is.null(Values))
      Values <- SCDA_Default_Labels_func(Design_Type)
    
    return(
      if(Design_Type == "ABA")
        fluidRow(
          column(width = 12,
            textInput(paste(Widget_Prefix, "Treatment_Label_A1", sep = "_"), "A1 phase label", Values[1]),
            textInput(paste(Widget_Prefix, "Treatment_Label_B1", sep = "_"), "B1 phase label", Values[2]),
            textInput(paste(Widget_Prefix, "Treatment_Label_A2", sep = "_"), "A2 phase label", Values[3])
          )
        )
      else if(Design_Type == "ABAB")
        fluidRow(
          column(width = 6,
            textInput(paste(Widget_Prefix, "Treatment_Label_A1", sep = "_"), "A1 phase label", Values[1]),
            textInput(paste(Widget_Prefix, "Treatment_Label_A2", sep = "_"), "A2 phase label", Values[3])
          ),
          column(width = 6,
            textInput(paste(Widget_Prefix, "Treatment_Label_B1", sep = "_"), "B1 phase label", Values[2]),
            textInput(paste(Widget_Prefix, "Treatment_Label_B2", sep = "_"), "B2 phase label", Values[4])
          )
        )
      else
        fluidRow(
          column(width = 6, 
            textInput(paste(Widget_Prefix, "Treatment_Label_A", sep = "_"), "A treatment level label", Values[1])
          ),
          column(width = 6, 
            textInput(paste(Widget_Prefix, "Treatment_Label_B", sep = "_"), "B treatment level label", Values[2])
          )
        )
    )
  }
  
  return()
}

SCDA_Get_User_Labels_func <- function(Widget_Prefix, input)
{
  Design_Type <- input[[paste(Widget_Prefix, "Design_Type", sep = "_")]]
  return(
    if(Design_Type == "ABA")
      c(
        input[[paste(Widget_Prefix, "Treatment_Label_A1", sep = "_")]],
        input[[paste(Widget_Prefix, "Treatment_Label_B1", sep = "_")]],
        input[[paste(Widget_Prefix, "Treatment_Label_A2", sep = "_")]]
      )
    else if(Design_Type == "ABAB")
      c(
        input[[paste(Widget_Prefix, "Treatment_Label_A1", sep = "_")]],
        input[[paste(Widget_Prefix, "Treatment_Label_B1", sep = "_")]],
        input[[paste(Widget_Prefix, "Treatment_Label_A2", sep = "_")]],
        input[[paste(Widget_Prefix, "Treatment_Label_B2", sep = "_")]]
      )
    else 
      c(
        input[[paste(Widget_Prefix, "Treatment_Label_A", sep = "_")]], 
        input[[paste(Widget_Prefix, "Treatment_Label_B", sep = "_")]]
      )
  )
}

SCDA_Data_Relabel_func <- function(Design_Type, Orig_Table, User_Labels)
{
  Default_Labels <- SCDA_Default_Labels_func(Design_Type)
  New_Table <- Orig_Table
  
  if(!identical(Default_Labels, User_Labels))
  {
    for(i in seq(1, ncol(New_Table), 2))
      New_Table[,i] <- mapvalues(as.factor(New_Table[, i]), User_Labels, Default_Labels)
  }
  return(New_Table)
}

SCVA_Central_Measure_func <- function(Widget_Name)
{
  return(selectInput(
    Widget_Name,
    "Select the measure of central tendency",
    list(
      "Mean" = "mean", 
      "Median" = "median", 
      "Broadened median" = "bmed", 
      "Trimmed mean" = "trimmean", 
      "M-estimator" = "mest"
    )
  ))
}

SCVA_Extra_Param_func <- function(Widget_Name, Central_Measure)
{
  return(switch(Central_Measure,
    "trimmean" = numericInput(Widget_Name, "Trimmed mean: Proportion of observations to be removed", 0.2),
    "mest" = numericInput(Widget_Name, "M-estimator: Value for the constant K", 1.28),
    NULL
  ))
}

SCVA_Min_Max_UI_func <- function(
  Widget_Prefix, 
  Min = NULL, 
  Max = NULL, 
  Min_Label = "Min", 
  Max_Label = "Max", 
  Min_Suffix = "Min",
  Max_Suffix = "Max"
)
{
  return(fluidRow(
    column(width = 6, numericInput(paste(Widget_Prefix, Min_Suffix, sep = "_"), Min_Label, Min)),
    column(width = 6, numericInput(paste(Widget_Prefix, Max_Suffix, sep = "_"), Max_Label, Max))
  ))
}

SCVA_LegendXY_func <- function(Widget_Prefix, Data, Design_Type)
{
  if(!is.null(Design_Type))
  {
    if(Design_Type == "CRD" || Design_Type == "RBD" || Design_Type == "ATD" || Design_Type == "Custom")
      return(SCVA_Min_Max_UI_func(
        Widget_Prefix,
        Min = 1,
        Max = if(is.null(Data)) 0 else max(Data[, 2]),
        Min_Label = "Legend X-coord",
        Max_Label = "Legend Y-coord",
        Min_Suffix = "X",
        Max_Suffix = "Y"
      ))
  }
  
  return()
}

SCRT_Test_Statistic_func <- function(Widget_Name, Design_Type, selected = "A-B")
{
  if(!is.null(Design_Type))
  {
    Statistics <- c("A-B", "B-A", "|A-B|")
    if(Design_Type == "ABA" || Design_Type == "ABAB")
      Statistics <- c(Statistics, "PA-PB", "PB-PA", "|PA-PB|", "AA-BB", "BB-AA", "|AA-BB|")
    
    Statistics <- c(Statistics, "Custom")
    return(selectInput(Widget_Name, "Select the test statistic", Statistics, selected = selected))
  }
  return()
}

SCRT_Custom_Statistic_func <- function(Widget_Name, Statistic, Current = NULL)
{
  if(!is.null(Statistic))
  {
    if(Statistic == "Custom")
      return(textInput(Widget_Name, "Define test statistic", Current))
  }
  return()
}

SCRT_Random_Dist_func <- function(Widget_Name)
{
  return(selectInput(
    Widget_Name,
    "Select the randomization distrbution",
    list(
      "Systematic randomization distribution" = "systematic", 
      "Monte Carlo randomization distrubution" = "random"
    )
  ))
}

SCRT_Num_MonteCarlo_func <- function(Widget_Name, Random_Dist)
{
  if(Random_Dist == "random")
    return(numericInput(Widget_Name, "Monte Carlo: Number of randomizations", 1000))
  
  return()
}  

SCRT_YesNo_Buttons_func <- function(Widget_Name, Label = "Save?")
{
  return(radioButtons(
    Widget_Name, 
    Label, 
    list("Yes" = "yes", "No" = "no"), 
    selected = "no", 
    inline = TRUE
  ))
}
  
SCRT_Save_Info_func <- function(Save_Input)
{
  if(Save_Input == "yes")
    return(paste(
      "A file select window will appear after you click on \'Submit\'.",
      "You can create a new text file or select an existing text file in a folder of your choice to save the output.",
      sep = " "
    ))
  
  return("")
}

SCDA_Validate_Data_func <- function(Data_Table)
{
  validate(need(Data_Table, "Please upload observed data in \'Data\' tab before analysis."))
}

SCRT_Validate_Size_func <- function(Output_Table, Threshold = 1000)
{
  validate(need(
    NROW(Output_Table) <= Threshold, 
    "Table too large to be displayed. Please use the option to save table to file."
  ))
}

SCDA_Validate_File_func <- function(File_Input)
{
  validate(need(File_Input, "Please select input file."))
}

SCVA_Validate_Range_func <- function(Minimum, Maximum)
{
  validate(need(
    is.na(Minimum) == is.na(Maximum), 
    "Please ensure either both Minimum and Maximum values for Y-axis range are specified or both are empty."
  ))
}
