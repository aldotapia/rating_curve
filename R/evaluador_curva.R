library(ggplot2)
library(grid)
library(gridExtra)
library(minpack.lm)
# library(magrittr)
# library(tidyr)

# Cargar datos
datos <- read.csv('~/Desktop/Proyectos/rating_curve/Data/Results/Tabla_resumen.csv')

peralte <- 0

p1 <- ggplot(datos,aes(x = Altura, y = Caudal)) + geom_point() +
  ylab(expression(paste('Caudal (',m^3,'/s)'))) +
  xlab('Altura (m)') + theme_classic() + expand_limits(x = 0, y = 0)

p2 <- ggplot(datos,aes(x = Area, y = Altura)) + geom_point() +
  ylab(expression(paste('Altura (m)'))) +
  xlab(expression(paste('Área (',m^2,')'))) + theme_classic() + expand_limits(x = 0, y = 0)

p3 <- ggplot(datos,aes(x = Velocidad, y = Froude)) + geom_point() +
  xlab(expression(paste('Velocidad (',m,'/s)'))) +
  ylab(expression(paste('Número de Froude'))) + theme_classic()

p4 <- ggplot(datos,aes(x = Caudal, y = Velocidad)) + geom_point() +
  xlab(expression(paste('Caudal (',m^3,'/s)'))) +
  ylab(expression(paste('Velocidad (',m,'/s)'))) + theme_classic() + expand_limits(x = 0, y = 0)

grid.arrange(p1,p2,p3,p4)

m1 <- nlsLM(Caudal ~ peralte + a * Altura + b * Altura^2, start = list(a = 1, b = 1), data = datos)

m2 <- nlsLM(Caudal ~ peralte + a * Altura^b, start = list(a = 1, b = 1), data = datos)

m1_result <- data.frame(Altura = seq(0,max(datos$Altura)*1.1, length.out = 100),
                        Caudal = predict(m1,newdata = data.frame(Altura = seq(0,max(datos$Altura)*1.1, length.out = 100))))

m2_result <- data.frame(Altura = seq(0,max(datos$Altura)*1.1, length.out = 100),
                        Caudal = predict(m2,newdata = data.frame(Altura = seq(0,max(datos$Altura)*1.1, length.out = 100))))

ggplot(datos,aes(x = Altura, y = Caudal)) + geom_point() +
  ylab(expression(paste('Caudal (',m^3,'/s)'))) +
  xlab('Altura (m)') + theme_classic() + expand_limits(x = 0, y = 0) +
  geom_line(aes(x = Altura, y = Caudal), data = m1_result, col = 'red') +
  geom_line(aes(x = Altura, y = Caudal), data = m2_result, col = 'blue')

