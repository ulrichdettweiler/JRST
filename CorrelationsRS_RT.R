# Correlations HD Data RT/RS
library(Hmisc)
attach(NoonData)
# Fall

FallData = subset(NoonData, enquiry==1)
CorVarFall = c("RS", "RT")
CorFallData = FallData[CorVarFall]
CorrelationMatrixFall = rcorr(as.matrix(CorFallData), type="pearson")
CorrelationMatrixFall


# Spring 
SpringData = subset(NoonData, enquiry==2)
CorVarSpring = c("RS", "RT")
CorSpringData = SpringData[CorVarSpring]
CorrelationMatrixSpring = rcorr(as.matrix(CorSpringData), type="pearson")
CorrelationMatrixSpring


# Summer
SummerData = subset(NoonData, enquiry==3)
CorVarSummer = c("RS", "RT")
CorSummerData = SummerData[CorVarSummer]
CorrelationMatrixSummer = rcorr(as.matrix(CorSummerData), type="pearson")
CorrelationMatrixSummer
