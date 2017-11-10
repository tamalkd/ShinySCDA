The Meta-Analysis tab contains functions that help in meta-analysis of single-case experiments, including calculating various effect size measures and probability combining (additive and multiplicative method). The following functions can be found.

* **Calculate effect size**: The specified effect size measure is calculated.

* **Combine p-values**: A general p-value is calculated, by statistically combining the p-values of a number of independent studies, to test the null hypothesis that the result of every included study is insignificant as opposed to the alternate hypothesis that at least one of them contain a significant result.

The following parameters may need to be set for the functions in Meta-Analysis tab.

* **Select the design type**: Only required for function *Calculate effect size*. Type of single-case design. The options are *AB Phase Design*, *ABA Phase Design*, *ABAB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*.

* **Select the effect size measure**: Only required for function *Calculate effect size*. The type of effect size that has to be calculated. The options are *Standardized Mean Difference*, *Pooled Standardized Mean Difference*, *PND (expected increase)* / *PND (expected decrease)* (percentage of nonoverlapping data, depending on the expected direction of the treatment effect), *PEM (expected increase)* / *PEM (expected decrease)* (percentage of data points exceeding the median, depending on the expected direction of the treatment effect), and *NAP (expected increase)* / *NAP (expected decrease)* (nonoverlap of all pairs, depending on the expected direction of the treatment effect).

* **Select the combining method**: Only required for function *Combine p-values*. Indicates which combining function should be used. The options are *Multiplicative* and *Additive*. The combined p-value is calculated as the probability of getting a product (or sum) of p-values as small as the product (or sum) of the actual observed p-values from the studies under consideration.

* **Select text file containing p-values**: Only required for function *Combine p-values*. Text file in which the p-values can be found. This text file should consist of one column with all the obtained p-values. Example input file: [Sample p-values](pvalues.txt).

##### **References**

Bult&eacute;, I., & Onghena, P. (2013). The Single-Case Data Analysis package: Analysing single-case experiments with R software. *Journal of Modern Applied Statistical Methods, 12*, 450-478.
