* Encoding: UTF-8.
* exploreDistributions function
* by Jamie DeCoster

* This python function takes a group of continuous variables and then provides information 
* about their univariate and bivariate distributions. The function provides the following:
* 1. Descriptive statistics for each variable
* 2. Correlations among variables
* 3. Univariate histograms
* 4. Bivariate scatterplots
* 5. Univariate missingness
* 6. Patterns of missing data

**** Usage: exploreDistributions(varList)
**** "varList" is a list of strings indicating the names of the variables to be explored

**** Example: exploreDistributions(varList = ["grade", "age", "conflict"])
**** This would provide descriptive statistics, histograms, and reports of missing values for 
* each of the three variables in the list. It would then provide a correlation matrix and a scatterplot
* matrix examining the bivariate distributions. It would then provide an analysis of missing
* data patterns found among the variables.

BEGIN PROGRAM PYTHON3.
import spss

def exploreDistributions(varList):
# Descriptive statistics    
    submitstring = "DESCRIPTIVES VARIABLES="
    for var in varList:
        submitstring += "\n{0}".format(var)
    submitstring += "\n/STATISTICS=MEAN STDDEV MIN MAX."
    spss.Submit(submitstring)

# Correlation matrix
    submitstring = """CORRELATIONS
  /VARIABLES="""
    for var in varList:
        submitstring += "\n{0}".format(var)
    submitstring += """\n  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE."""
    spss.Submit(submitstring)

# Univariate distributions
    for var in varList:
        submitstring = """GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES={0} MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: {0}=col(source(s), name("{0}"))
  GUIDE: axis(dim(1), label("{0}"))
  GUIDE: axis(dim(2), label("Frequency"))
  GUIDE: text.title(label("{0}"))
  ELEMENT: interval(position(summary.count(bin.rect({0}))), 
    shape.interior(shape.square))
END GPL.""".format(var)
        print(submitstring)
        spss.Submit(submitstring)

# Scatterplot matrix
    submitstring = """GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES="""
    for var in varList:
        submitstring += "\n{0}".format(var)
    submitstring += """\nMISSING=LISTWISE
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))"""
    for var in varList:
        submitstring += '\nDATA: {0}=col(source(s), name("{0}"))'.format(var)
    submitstring += """\nGUIDE: axis(dim(1.1), ticks(null()))
  GUIDE: axis(dim(2.1), ticks(null()))
  GUIDE: axis(dim(1), gap(0px))
  GUIDE: axis(dim(2), gap(0px))
  GUIDE: text.title(label("Scatterplot Matrix"))"""
    for var in varList:
        submitstring += '\nTRANS: {0}_label = eval("{0}")'.format(var)
    for var in varList:
        if (var == varList[0]):
            submitstring += '\nELEMENT: point(position(({0}/{0}_label'.format(var)
        else:
            submitstring += '\n+{0}/{0}_label'.format(var)
    for var in varList:
        if (var == varList[0]):
            submitstring +=')\n*({0}/{0}_label'.format(var)
        else:
            submitstring += '+{0}/{0}_label'.format(var)
    submitstring += """)))
END GPL."""
    print(submitstring)
    spss.Submit(submitstring)
    
# Missing values analysis
    submitstring = "MULTIPLE IMPUTATION"
    for var in varList:
        submitstring += "\n{0}".format(var)
    submitstring += """\n/IMPUTE METHOD=NONE
   /MISSINGSUMMARIES  OVERALL 
   VARIABLES (MAXVARS=25 MINPCTMISSING=10) PATTERNS."""
    spss.Submit(submitstring)
end program python.
