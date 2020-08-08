The Data tab contains a function to upload the observed dataset in the web app once the experiment is completed for analysis. Once a dataset is uploaded, it is used as the default dataset for all analyses until another dataset is uploaded.

* **Set data**: The observed dataset can be uploaded to the web app for analysis.

The following parameters may need to be set in the Data tab.

* **Select the design type**: Type of single-case design. The options are *AB Phase Design*, *ABA Phase Design*, *ABAB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*.

* **Select data file**: The file containing the observed data should be selected. Text files (*.txt*), Comma Separated Value (CSV) files (*.csv*), R Dataset files (*.Rdata* or *.Rda*) and Excel files (*.xlx* or *.xlsx*) are supported. The data should consist of two columns for all designs with the exception of *Multiple Baseline Design*; the first with the condition labels and the second with the obtained scores. For *Multiple Baseline Design* it should consist of these two columns for each unit. Each row in the data should represent one measurement occasion. The recommended file format is a Text file. Missing data should be indicated as *NA*. Example datasets: [Sample AB Phase Design data](AB.txt), [Sample ABAB Phase Design data](ABAB.csv), [Sample Multiple Baseline Design data](MBD.xlsx).

* **File contains column headers**: Only required for Text files, Comma Separated Value files and Excel files. A checkbox which should indicate whether the input data file contains column headers (column names) or not. By default, a row containing column headers is expected for Excel and CSV files but not for Text files.

* **Sheet index number**: Only required for Excel files. The sheet index number should be entered. The sheet index number represents the numeric sequence of sheets in an Excel workbook, starting with 1 on the left. By default, the first sheet is read. 

* **A treatment level label** and **B treatment level label**: Only required for *AB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*. These options can be used to specify the labels for baseline and treatment levels in the dataset.

* **A1 phase label**, **B1 phase label**, **A2 phase label** and **B2 phase label**: Only required for *ABA Phase Design* and *ABAB Phase Design*. These options can be used to specify labels for the first baseline phase, the first treatment phase, the second baseline phase and the second treatment phase respectively in the dataset.
 