##cargamos la tabla de abundancia
abund_table = read.csv("ALSG93AGenus.csv",row.names=1, check.names=FALSE)
abund_table_t<-t(abund_table)

##calculamos la diversidad Shannon 
library(vegan)
#Se usa la funcion diversidad del paquete vegan para calcular el indice Shannon
#Se realiza el dataframe del indice de Shannnon
H<-diversity(abund_table_t, "shannon")
df_H<-data.frame(sample=names(H),value=H,measure=rep("Shannon", length(H)))
#Se obtiene la informacion agrupada para los datps de la muestra
df_H$Group <- with(df_H, ifelse(as.factor(sample)%in% c("A11-28F","A12-28F",
"A13-28F","A14-28F","A15-28F","A16-28F"),c("G93m1"), 
ifelse(as.factor(sample)%in% c("A21-28F","A22-28F","A23-28F","A24-28F",
                               "A25-28F","A26-28F"),c("WTm1"),
       ifelse(as.factor(sample)%in% c("C11-28F","C12-28F","C13-28F"),c("G93m4"),
              ifelse(as.factor(sample)%in% c("C21-28F","C22-28F","C23-28F"),
                     c("WTm4"),ifelse(as.factor(sample)%in% c("B11-28F",
                     "B12-28F","B13-28F","B14-28F","B15-28F","D11-28F",
                     "D12-28F","D13-28F","D14-28F"),c("BUm3to3.5"),
                     c("NOBUm3to3.5")))))))

df_H
#El conjunto de datos incluye datos de muestra de los meses 1, 3, 3,5 y 4. 
#Nos interesa en las comparaciones del tratamiento frente al no tratamiento 
#durante los meses 3 y 3,5. Así que los datos de 3 a 3,5 meses como se indica a
#continuación:
library(dplyr)
df_H_G6 <- select(df_H, Group,value)
df_H_G93BUm3 <- filter(df_H_G6,Group=="BUm3to3.5"|Group=="NOBUm3to3.5")
df_H_G93BUm3
library(ggplot2)
#dividir la trama en múltiples paneles
p<-ggplot(df_H_G93BUm3, aes(x=value))+
  geom_histogram(color="black",fill="black")+
  facet_grid(Group ~ .)
#Calcular la media de cada grupo
#calcular la diversidad promedio de Shannon de cada grupo usando el paquete Plyr
library(plyr)
mu <- ddply(df_H_G93BUm3, "Group", summarise, grp.mean=mean(value))
head(mu)
#agrega las lineas de la media
p+geom_vline(data=mu, aes(xintercept=grp.mean, color="red"),
             linetype="dashed")



##5.2.3 Cálculo de la potencia o el tamaño de la muestra mediante la función R power.t.test
#Dado que se desconoce la desviación estándar de la diferencia de medias,
#es necesario estimarlo

aggregate(value ~ Group, 
          df_H_G93BUm3,
          mean)

#Group value
#1   BUm3to3.5 2.504
#2 NOBUm3to3.5 2.205



aggregate(value ~ Group, df_H_G93BUm3,var)

#Group   value
#1   BUm3to3.5 0.02892
#2 NOBUm3to3.5 0.04349

n1 <- 9
n2 <-7
s1<-sqrt(0.02892)
s1
#[1] 0.1701
s2<-sqrt(0.04349)
s2
#[1] 0.2085
s=sqrt((n1-1)*s1^2+(n2-1)*s2^2)/(n1+n2-2)
s
#[1] 0.05012

power.t.test(n=2:10,delta=2.504-2.205,sd=0.05012)
df_P <-data.frame(n,power)
df_P

n = c(2, 3, 4, 5, 6, 7, 8, 9, 10)  
power = c(0.8324, 0.9994, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000)

power <- sapply(n, function (x) power.t.test(n=x, delta=2.504-2.205,sd=0.05012)$power)
plot(n, power, xlab  = "Sample Size per group", ylab  = "Power to reject null",
     main="Power curve for\n t-test with delta = 0.05",
     lwd=2, col="red", type="l")

abline(h = 0.90, col="blue")


power.t.test(n=2:10,delta=2.504-2.205,sd=0.05012, type = "one.sample" )


#5.3 Power Analysis for Comparing Diversity Across More than Two Groups Using 
#    ANOVA	
df_H_G93WTm1N4 <- filter(df_H_G6,Group%in%c("G93m1","WTm1","G93m4","WTm4"))
df_H_G93WTm1N4 

fit = lm(formula = value~Group,data=df_H_G93WTm1N4)
anova (fit)


library(pwr)
pwr.anova.test(f= 0.23,k=4,n=45:55,sig.level=0.05)
