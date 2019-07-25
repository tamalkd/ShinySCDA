The Design tab contains functions that help in designing a single-case experiment. The following functions can be found.

* **Number of possible assignments**: The number of possible assignments for the specified design parameters is calculated. Every acceptable allocation of treatment levels to measurement occasions is a possible assignment. For example, in an experiment with 6 measurement occasions and 2 treatment levels *A* (baseline) and *B* (treatment), a possible assignment is *A A A B B B*, which means for the first 3 measurement occasions treatment *A* is applied while treatment *B* is applied for the next 3 measurement occasions.

* **Display all possible assignments**: All assignment possibilities for the specified design parameters are enumerated. If the result is too large, it can only be saved to a file and not displayed. For *Multiple Baseline Design*, the possible combinations of start points for each unit are returned. There may be duplicates among these assignments if there are overlaps between the start points for different subjects. This is a result of the subjects also being randomized to the set of start points. For all other designs, the possible sequences of conditions are returned (e.g., *A A A B B B*). 

* **Choose 1 possible assignment**: One assignment is randomly selected for conducting the experiment from all theoretical assignment possibilities. For *Multiple Baseline Design*, a possible combination of start points for each unit is returned. For all other designs, a possible sequence of conditions is returned (e.g., *A A A B B B*). 

The following parameters may need to be set for the functions in Design tab.

* **Select the design type**: Type of single-case design. The options are *AB Phase Design*, *ABA Phase Design*, *ABAB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*.

* **Number of observations**: Measurement times or number of observations in the experiment.

* **Minimum number of observations per phase**: Only required for phase designs (*AB Phase Design*, *ABA Phase Design* and *ABAB Phase Design*). Minimum number of observations needed per phase (baseline or treatment).

* **Maximum number of consecutive administrations of the same condition**: Only required for *Alternating Treatments Design*. The maximum number of consecutive administrations of the same condition (baseline or treatment) allowed.

* **Multiple Baseline Design: Select text file containing possible start points**: Only required for *Multiple Baseline Design*. A text file containing all possible startpoints for treatment is required. In this startpoint file, each row should contain all possibilities for one unit, separated by a tab. The rows and columns should not be labeled.

* **User Specified Design: Select text file containing possible assignments**: Only required for *User Specified Design*. Text file where all the possible assignments can be found. In this file, each row should contain the sequence of conditions in one possible assignment. There should be one row for every possible assignment. The rows and columns should not be labeled.

##### **References**

Bult&eacute;, I., & Onghena, P. (2008). An R package for single-case randomization tests. *Behavior Research Methods, 40*, 467-478. [doi:10.3758/BRM.40.2.467](https://link.springer.com/article/10.3758/BRM.40.2.467).

Bult&eacute;, I., & Onghena, P. (2009). Randomization tests for multiple baseline designs: An extension of the SCRT-R package. *Behavior Research Methods, 41*, 477-485. [doi:10.3758/BRM.41.2.477](https://link.springer.com/article/10.3758/BRM.41.2.477).
