---
title: "README"
author: "Kathrine Brun, Tuva Norderud Jensen, Eirik Røys"
date: "2024-09-13"
output: html_document
---

## Project Description:

This repository is the final outcome of our exam project in RMED901.The project is based on a study of 236 patients undergoing elective thoracic surgery, requiring the use of a double-lumen endotracheal tube. The study investigates whether gargling with licorice before anesthesia can prevent postoperative sore throat and coughing in these patients.

The repository contains data, scripts, results from analysis and other relevant information. 

All the files and results are also available in the [github repository](git@github.com:tnj9/RMED_exam_group8.git)

## Table of contents

-   Installation
-   Folder contents
-   License

### Installation

You need the following tools and libraries to run the analysis in the project:

-   R: Version 4.4.1.
-   RStudio
-   R libraries:tidyverse, tidyr, here, lubridate, dplyr, skimr, ggplot2, patchwork, ggcorrplot and styler.

How to install the packages
install.packages(c("tidyverse", "tidyr","here", "lubridate", "dplyr","skimr", "ggplot2", "patchwork", "ggcorrplot", "styler"))


### Folder Contents:
#### 1.DATA:
Contains three datasets: 

- exam_dataset.txt
- exam_joindata.txt
- clean_data.csv

Comment:Exam_dataset.txt and exam_joindata.txt are raw datasets from the project.clean_data.csv is the cleaned and processed version (with 24 variables) derived from the raw data after tidying and wrangling. Clean_data.csv includes details on gender, age, BMI, physical status, Mallampati score, smoking status, preoperative pain, surgery size, treatment intervention, and three outcomes (cough, sore throat, and pain when swallowing) at various time points.


#### 2.Scripts: 
Contains two R scripts: 

- Script_tidy.R 
- Script_analyze.R.
  
Comment: Script_tidy.R combines and performs tidying and wrangling of the two raw datasets, generating the cleaned dataset clean_data.csv.Script_analyze.R explores the relationships between several variables in clean_data.csv through plotting and statistical analysis.

#### 3.Results:
Contains a R Markdown file - Reports.Rmd - which summarizes the findings and results from the analyses conducted in the scripts.

#### 4.Figures:
Contains the plots generated during the analysis in Script_analyze.R.

#### 5.Exam:
Contains two markdown files: exam_checklist.md and exam_descr.md, which describe the tasks performed to produce the scripts and results.

#### 6.Documentation and Tools:
Contains the project documentation files such as the MIT license, .Rhistory, and .gitignore files. 


### License
The project is licensed under the MIT license. 


