library(ggplot2)
library(magrittr)
library(tidyr)

# Cargar datos
datos <- read.csv('~/Desktop/Proyectos/rating_curve/Data/Results/Tabla_resumen.csv')

lab_datos <- c(Area = 'Area (m^2)',
               Caudal = 'Caudal (m^3/s)',
               Velocidad = 'Velocidad (m/s)',
               Froude = 'Froude')

label_bquote(lab_datos)

datos %>% gather(Variable,Valor,-X,-ID,-Fecha,-Altura,-Este,-Norte) %>% 
  ggplot(aes(y = Valor,x = Altura)) + geom_point() +
  facet_wrap(~Variable, scales = 'free_y',strip.position = 'left',
             labeller = labeller(Variable = lab_datos)) + ylab(NULL) + xlab('Altura lámina (m)')

lab_datos <- c(Area = expression(paste('Area (', m^2,')')),
Caudal = expression(paste('Caudal (', m^3,'/s)')),
Velocidad = expression(paste('Velocidad (', m^2,')')),
Froude = expression(paste('Froude')))