# Indicar ruta doonde se encuentren las planillas (Puede ser raíz, el proceso es recursivo)
files_path <- '/Users/aldotapia/Desktop/Proyectos/rating_curve/Data/Sheets'

# Indicar rutra donde se encuentra el archivo Ficha_reporte.Rnw
Rnw_path <- '/Users/aldotapia/Desktop/Proyectos/rating_curve/Sweave_terreno/'

# Cargar ruta de archivos
archivos <- list.files(files_path,pattern = '.xlsx$',recursive = T,full.names = T)

# Extraer altura del nombre del archivo
alturas <- gsub(pattern = '.*Altura_',replacement = '',x = archivos)
alturas <- gsub(pattern = ' m.*',replacement = '',x = alturas)
alturas <- as.numeric(alturas)

# Extraer el nombre de la planilla
nombres <- gsub(pattern = '.*/',replacement = '',x = archivos)
nombres <- gsub(pattern = '.xlsx',replacement = '',x = nombres)

# Establecer directorio de trabajo
setwd(Rnw_path)

# Bucle para exportar archivos
for (l in 1:length(archivos)) { # uso de l para iterar... Rnw usa i y j como iterados y cambia variables globales
  archivo <- archivos[l] # Selección de archivo
  Sweave('Ficha_reporte.Rnw') # Creación de archivo LaTeX
  system(paste0('pdflatex ',Rnw_path,'Ficha_reporte.tex')) # Compilación en .pdf
  file.rename('Ficha_reporte.pdf',paste0('Nro_', l,'_alt_',gsub('.','_',alturas[l],fixed = T), '.pdf')) # Cambio de nombre según uno personalizado
  print(paste0(nombres[l],' listo!')) # Imprimir mensaje de que está listo (aunque entre tanto mensaje se confunde)
}
