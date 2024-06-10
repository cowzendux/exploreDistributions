# exploreDistributions
This is a SPSS Python macro that takes a group of continuous variables and then provides information about their univariate and bivariate distributions. The function provides the following:  
1. Descriptive statistics for each variable  
2. Correlations among variables  
3. Univariate histograms  
4. Bivariate scatterplots  
5. Univariate missingness  
6. Patterns of missing data

This and other SPSS Python Extension functions can be found at http://www.stat-help.com/python.html

## Usage
**exploreDistributions(varList)**
* "varList" is a list of strings indicating the names of the variables to be explored

## Example 
**exploreDistributions(varList = ["grade", "age", "conflict"])**
* This would provide descriptive statistics, histograms, and reports of missing values for each of the three variables in the list. 
* It would then provide a correlation matrix and a scatterplot matrix examining the bivariate distributions. 
* It would then provide an analysis of missing data patterns found among the variables.
