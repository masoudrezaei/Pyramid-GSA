# Pyramid-GSA
## Pyramid GSA is a hybrid metaheuristic feature selection algorithm based on Gravitational Search Algorithm
##### This repository is the implementation of PGSA:
![Graphical Abstract](https://github.com/masoudrezaei/Pyramid-GSA/blob/master/Graphical%20Abstract.jpg)

###  Abstract
Genetics play a prominent role in the development and progression of malignant neoplasms. Identification of the relevant genes is a high-dimensional data processing problem. Pyramid gravitational search algorithm (PGSA),  a hybrid method in which the number of genes is cyclically reduced is proposed to conquer the curse of dimensionality.  PGSA consists of two steps which iterates through cycles; each cycle contains a filter and a wrapper method inspired by the gravitational search algorithm. The genes selected in each cycle are passed on to the subsequent cycles to further reduce the dimension. PGSA tries to maximize the classification accuracy using the most informative genes while constantly reducing the number of genes. Results are reported on a multi-class microarray gene expression dataset for breast cancer. Several feature selection algorithms have been implemented to have a fair comparison. The pyramid GSA ranked first in terms of accuracy (84.5%) with 73 genes. To check if the selected genes are meaningful in terms of patient’s survival and response to therapy, protein-protein interaction network analysis has been applied on the genes. An interesting pattern was emerged when examining the genetic network. HSP90AA1, PTK2 and SRC genes were amongst the top-rated bottleneck genes, and DNA damage, cell adhesion and migration pathways are highly enriched in the network. 

## Instruction

The Pyramid Gravitational Search Algorithm (PGSA) is a meta-heuristic optimization method for searching high-dimensional search spaces and selecting the most informative features. To run the algorithm, use the following instructions:

• This algorithm was tested using MATLAB 2018 and MATLAB 2021.However, if you have any problems running the code, please do not hesitate to contact us for further instructions.

requirements

• The "fspackage" file must be downloaded and placed in the algorithm code folder.

Installation and running:

•    First, we need to load the "fspackage".

•    The dataset can be defined in the "DataCaseGet" function. The dataset must be organized properly into the predictors and target variables.

• The user can define the fitness function appropriate for the problem in the "evaluateF" function. There is an option to weight the desired statistical parameter. 

• The "main" function is used to modify the default feature selection setting.It is worth mentioning some of the most important primary settings in further detail:

-    Nr: Maximum number of iterations

-    CycleNum: Number of cycles

-    N: number of particles (agent)

-    Classifiers and their hyperparameters: SVM, KNN, ANN

• Selected features and classification metrics will be saved and accessible via the cp file for each running cycle.By default, classification accuracy, sensitivity, specificity, and number of features along with their corresponding index in the dataset will be available for additional analyses.

If you need more information, contact one of the following emails:

e.rashedi@kgut.ac.ir

ce.tahmouresi@gmail.com

 
