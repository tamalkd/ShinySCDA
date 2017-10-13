The Design tab contains functions that help in designing a single-case experiment. The following functions can be found.

* **Number of possible assignments**: The number of assignment possibilities for the specified design parameters is calculated.

* **Display all possible assignments**: All assignment possibilities for the specified design parameters are enumerated.

* **Choose 1 possible assignment**: One assignment possibility is randomly selected from all theoretical possibilities.

The following parameters may need to be set for the functions in Design tab.

* **Select the design type**: Type of single-case design. The options are *AB Phase Design*, *ABA Phase Design*, *ABAB Phase Design*, *Completely Randomized Design*, *Randomized Block Design*, *Alternating Treatments Design*, *Multiple Baseline Design* and *User Specified Design*.

* **Number of observations**: Measurement times or number of observations in the experiment.

* **Minimum number of observations per phase**: Only required for phase designs. Minimum number of observations needed per phase (baseline or treatment).

* **Maximum number of consecutive administrations of the same condition**: Only required for *Alternating Treatments Design*. The maximum number of consecutive administrations of the same condition (baseline or treatment) allowed.

* **Multiple Baseline Design: Select text file containing possible start points**: Only required for *Multiple Baseline Design*. A text file containing all possible startpoints for treatment is required. In this startpoint file, each row should contain all possibilities for one unit, separated by a tab. The rows and columns should not be labeled.

* **User Specified Design: Select text file containing possible assignemnts**: Only required for *User Specified Design*. Text file where all the possible assignments can be found. 

* **Save possible assignments?**: Only required for function *Display all possible assignments*. Save the possible assignments to a file or just see them as output in the web app. The default is *No*, which only displays the possible assignments in the web app. If *Yes* is selected, a file select window will appear after clicking on *Submit*, a new text file can be created or an existing text file can be selected in any folder to save the output.

##### **References**

Bult&eacute;, I., & Onghena, P. (2008). An R package for single-case randomization tests. *Behavior Research Methods, 40*, 467-478. doi:10.3758/BRM.40.2.467.

Bult&eacute;, I., & Onghena, P. (2009). Randomization tests for multiple baseline designs: An extension of the SCRT-R package. *Behavior Research Methods, 41*, 477-485. doi:10.3758/BRM.41.2.477.
