The Visual Analysis tab contains functions that help in plotting the observed data and visually analyzing a single-case experiment, by displaying central location, variability and trend. The following functions can be found.

* **Plot observed data**: The observed single-case data are plotted.

* **Plot measure of central tendency**: A measure of central tendency ((trimmed) mean, (broadened) median, M-estimator) is plotted as a horizontal reference line superimposed on the raw time series data.

* **Plot estimate of variability**: Information about variability in the data is displayed by three methods. For all these methods, the influence of outliers may be lessened by using a trimmed range, in which only a sample of the data set is used.
    - Range bar graphs consist of a vertical line for each phase, created by connecting three points: an estimate of central tendency ((trimmed) mean, (broadened) median, M-estimator), the minimum and the maximum. 
    - Range lines consist of a pair of lines parallel to the X-axis, passing through the lowest and highest values for each phase, and superimposed on the raw data. 
    - Trended ranges display changes in variability within phases.

* **Plot estimate of trend**: Systematic shifts in central location over time are visualized using several methods.
    - A vertical line graph plots the deviations from each data point to a measure of central tendency against time. 
    - Regression lines superimpose a linear function on the raw data by means of least squares regression, the split-middle method or the resistant trend line fitting method.
    - The presence of a nonlinear trend can be displayed with running medians.

The following parameters may need to be set for the functions in Visual Analysis tab.

* **Select the design type**: Type of single-case design. The options are *AB Phase Design*, *ABA Phase Design*, *ABAB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*.

* **X-axis label**: Plot X-axis label. Default is *Measurement Times*.

* **Y-axis label**: Plot Y-axis label. Default is *Scores*.

* **A treatment level label** and **B treatment level label**: Only required for *AB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*. These options can be used to specify the labels for baseline and treatment levels in the plot.

* **A1 phase label**, **B1 phase label**, **A2 phase label** and **B2 phase label**: Only required for *ABA Phase Design* and *ABAB Phase Design*. These options can be used to specify labels for the first baseline phase, the first treatment phase, the second baseline phase and the second treatment phase respectively in the plot.

* **Y-axis minimum** and **Y-axis maximum**: Y-axis range: Y-axis minimum limit and Y-axis maximum limit respectively. If left empty, they will be inferred from the data. The values are co-dependent, hence either both should be left empty, or both should be assigned a value.

* **Legend X-coord** and **Legend X-coord**: Only required for certain plots of *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design* and *User Specified Design*. Legend location within plot: the X-coordinate and Y-coordinate for the top left corner of the legend can be specified.

* **Select the measure of central tendency**: Measure of central tendency. The options are *Mean*, *Median*, *Broadened median*, *Trimmed mean* and *M-estimator*.

* **Trimmed mean: Proportion of observations to be removed**: Only required if *Trimmed mean* is selected as the measure of central tendency. The percentage of observations that has to be removed from the end of the distribution before computing the mean. It can be any value from *0* (regular arithmetic mean) to *0.5*. Usually 20 percent of the observations is trimmed, so default is *0.2*.

* **M-estimator: Value for the constant K**: Only required if *M-estimator* is selected as the measure of central tendency. The desired value for the constant K for M-estimator. Usually a percentile of the standard normal distribution is chosen. Default is *1.28*, which corresponds to the 90th percentile of the standard normal distribution and covers 80 percent of the underlying distribution. For the calculation of the M-estimator, the function `mest(x, bend = 1.28)` from Wilcox (2005) is used.

* **Select the measure of variability**: Only required for function *Plot estimate of variability*. Estimate of variability. The options are *Range lines*, *Range bars* and *Trended range*.

* **Remove extreme values?**: Only required for function *Plot estimate of variability*. Reduce the influence of outliers by removing the 10-20 percent extreme values from each treatment level or use the whole dataset. Default is to use the whole dataset.

* **Select the trend visualization**: Only required for function *Plot estimate of trend*. Trend visualization. The options are *Vertical line plot*; trend lines by means of least squares regression (*Trend lines (Least Squares regression)*), split-middle method (*Trend lines (Split-middle)*), resistant trend line fitting (*Trend lines (Resistant trend line fitting)*); and running medians depending on the desired batch size (*Running medians (batch size 3)*, *Running medians (batch size 5)*, *Running medians (batch size 4 averaged by pairs)*).

##### **References**

Bult&eacute;, I., & Onghena, P. (2012). When the truth hits you between the eyes: A software tool for the visual analysis of single-case experimental data. *Methodology, 8*, 104-114. [doi:10.1027/1614-2241/a000042](https://www.researchgate.net/publication/254735695_When_the_Truth_Hits_You_Between_the_Eyes_A_Software_Tool_for_the_Visual_Analysis_of_Single-Case_Experimental_Data).

Wilcox, R.R. (2005). *Introduction to robust estimation and hypothesis testing (2nd ed.)*. San Diego, CA: Elsevier Academic Press.
