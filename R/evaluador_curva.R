library(ggplot2)
library(grid)
library(gridExtra)
library(minpack.lm)
library(magrittr)
library(dplyr)
# library(tidyr)

# Cargar datos
datosA <- read.csv('~/Desktop/Proyectos/rating_curve/Data/Results/Tabla_resumen.csv')

peralte <- 0

# p1 <- ggplot(datos,aes(x = Altura, y = Caudal)) + geom_point() +
#   ylab(expression(paste('Caudal (',m^3,'/s)'))) +
#   xlab('Altura (m)') + theme_classic() + expand_limits(x = 0, y = 0)
# 
# p2 <- ggplot(datos,aes(x = Area, y = Altura)) + geom_point() +
#   ylab(expression(paste('Altura (m)'))) +
#   xlab(expression(paste('Área (',m^2,')'))) + theme_classic() + expand_limits(x = 0, y = 0)
# 
# p3 <- ggplot(datos,aes(x = Velocidad, y = Froude)) + geom_point() +
#   xlab(expression(paste('Velocidad (',m,'/s)'))) +
#   ylab(expression(paste('Número de Froude'))) + theme_classic()
# 
# p4 <- ggplot(datos,aes(x = Caudal, y = Velocidad)) + geom_point() +
#   xlab(expression(paste('Caudal (',m^3,'/s)'))) +
#   ylab(expression(paste('Velocidad (',m,'/s)'))) + theme_classic() + expand_limits(x = 0, y = 0)
# 
# grid.arrange(p1,p2,p3,p4)

datos2 <- datosA %>% group_by(Altura) %>% summarise(Caudal_mean = mean(Caudal),
                                                   Caudal_sd = sd(Caudal),
                                                   Caudal_cv = Caudal_sd / Caudal_mean)

m1 <- nlsLM(Caudal_mean ~ peralte + a * Altura + b * Altura^2, start = list(a = 1, b = 1), data = datos2)

m2 <- nlsLM(Caudal_mean ~ peralte + a * Altura^b, start = list(a = 1, b = 1), data = datos2)

m1_result <- data.frame(Altura = seq(0,max(datos2$Altura)*1.1, length.out = 100),
                        Caudal_mean = predict(m1,newdata = data.frame(Altura = seq(0,max(datos2$Altura)*1.1, length.out = 100))))

m2_result <- data.frame(Altura = seq(0,max(datos2$Altura)*1.1, length.out = 100),
                        Caudal_mean = predict(m2,newdata = data.frame(Altura = seq(0,max(datos2$Altura)*1.1, length.out = 100))))



R2_m1 <- 1 - (sum((datos2$Caudal_mean - c(m1$m$fitted()) )^2)/sum((datos2$Caudal_mean - mean(c(m1$m$fitted())))^2))

R2_m2 <- 1 - (sum((datos2$Caudal_mean - c(m2$m$fitted()) )^2)/sum((datos2$Caudal_mean - mean(c(m2$m$fitted())))^2))

RMSE_m1 <- sqrt(mean((datos2$Caudal_mean - c(m1$m$fitted()))^2))

RMSE_m2 <- sqrt(mean((datos2$Caudal_mean - c(m2$m$fitted()))^2))

if (R2_m1 > R2_m2) {
  modelo <- m1
  dummy_points <- m1_result
}else{
  modelo <- m2
  dummy_points <- m2_result
}

ggplot(datos2,aes(x = Altura, y = Caudal_mean)) +
  ylab(expression(paste('Caudal (l/s)'))) +
  xlab('Altura referencia (m)') + theme_classic() + expand_limits(x = 0, y = 0) +
  geom_line(aes(x = Altura, y = Caudal_mean), data = dummy_points, col = 'red') +
  geom_point(shape = 1) 


