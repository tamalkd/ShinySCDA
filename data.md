The Data tab contains a function to upload the observed dataset in the web app once the experiment is completed for analysis. Once a dataset is uploaded, it is used as the default dataset for all analysis till another dataset is uploaded.

* **Set Data**: The observed dataset can be uploaded to the web app for analysis.

The following paramters may need to be set in the Data tab.

* **Select the design type**: Type of single-case design. The options are *AB Phase Design*, *ABA Phase Design*, *ABAB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*.

* **Select data file**: The file containing the observed data should be selected. Text files (*.txt*), Comma Separated Value files (*.csv*), R Dataset files (*.Rdata* or *.Rda*) and Excel files (*.xlx* or *.xlsx*) are supported. The data should consist of two columns for single-case phase and alternation designs; the first with the condition labels and the second with the obtained scores. For *Multiple Baseline Design* it should consist of these two columns for each unit. This way, each row represents one measurement occasion. The recommended file format is a Text file. Adhering to default data read function settings in R, a row containing column headers is expected for Excel files but not for Text or CSV files. In case of Excel files, only the first sheet is read.

* **Unable to determine file type automatically. Please select file type**: Only required when the web app fails to determine the selected file format. The options are *CSV File*, *Excel File*, *Text File* and *R Dataset*.

* **A treatment level label** and **B treatment level label**: Only required for *AB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*. These options can be used to specify the labels for baseline and treatment levels in the dataset.

* **A1 phase label**, **B1 phase label**, **A2 phase label** and **B2 phase label**: Only required for *ABA Phase Design* and *ABAB Phase Design*. These options can be used to specify labels for the first baseline phase, the first treatment phase, the second baseline phase and the second treatment phase respectively in the dataset.
