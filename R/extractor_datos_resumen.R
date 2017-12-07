# Indicar ruta doonde se encuentren las planillas (Puede ser raíz, el proceso es recursivo)
files_path <- '/path/to/rating_curve/Data/Sheets'

# Indicar rutra donde se encuentra el archivo Ficha_reporte.Rnw
Rnw_path <- '/path/to/rating_curve/Sweave_terreno/'

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

Table_list <- list()

# Bucle para exportar archivos
for (l in 1:length(archivos)) { # uso de l para iterar... Rnw usa i y j como iterados y cambia variables globales
  archivo <- archivos[l] # Selección de archivo
  
  wb <- loadWorkbook(archivo)
  
  hoja <- readWorksheet(wb,sheet = 'Cálculo Aforo',colTypes = XLC$DATA_TYPE.NUMERIC,forceConversion = T)
  hoja_h <- readWorksheet(wb,sheet = 'Hidráulica',colTypes = XLC$DATA_TYPE.STRING,forceConversion = T)
  
  # Extraer datos
  Caudal <- hoja[21,13]
  Area <- hoja[61,6]
  Velocidad <- hoja[63,6]
  Prof_h <- as.numeric(hoja_h[13,9])
  Froude <- Velocidad/sqrt(9.81*Prof_h) # Cálculo del número de Froude (ya que la planilla sólo informa a 1 decimal)
  
  # crear data.frame por planilla
  Table_list[[l]] <- data.frame(ID = l, Altura = alturas[l], Caudal = Caudal,
                               Area = Area, Velocidad = Velocidad, Froude = Froude)
}

# Juntar los resultados de todas las planillas
Tabla_resumen <- do.call(rbind.data.frame,Table_list)

# Exportar tabla
write.csv(Tabla_resumen, '/path/to/rating_curve/Data/Results/Tabla_resumen.csv')
