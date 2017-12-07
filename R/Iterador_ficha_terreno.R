if (!require("knitr")) install.packages("knitr"); library(knitr)

files_path <- '/Users/aldotapia/Desktop/Proyectos/rating_curve/Data/Sheets'

Rnw_path <- '/Users/aldotapia/Desktop/Proyectos/rating_curve/Sweave_terreno/'

archivos <- list.files(files_path,pattern = '.xlsx$',recursive = T,full.names = T)

nombres <- list.files(files_path,pattern = '.xlsx$',recursive = T,full.names = F)

alturas <- gsub(pattern = '.*Altura_',replacement = '',x = nombres)
alturas <- gsub(pattern = ' m.*',replacement = '',x = alturas)
alturas <- as.numeric(alturas)

nombres <- gsub(pattern = '.*/',replacement = '',x = nombres)

nombres <- gsub(pattern = '.xlsx',replacement = '',x = nombres)

setwd(Rnw_path)

for (l in 1:length(archivos)) { # uso de l para iterar... Rnw usa i y j como iterados y cambia variables globales
  archivo <- archivos[l]
  Sweave('Ficha_reporte.Rnw')
  system(paste0('pdflatex ',Rnw_path,'Ficha_reporte.tex'))
  file.rename('Ficha_reporte.pdf',paste0('Nro_', l,'_alt_',gsub('.','_',alturas[l],fixed = T), '.pdf'))
}
