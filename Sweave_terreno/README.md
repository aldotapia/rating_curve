# Información importante

Esta carpeta está organizada con los siguientes archivos:

  - `Ficha_reporte.Rnw`: Archivo Sweave utilizado para generar la ficha de Resumen de aforo.
  - `baposter.cls`: Archivo de clase para compilar el fichero tipo [**baposter**](http://www.brian-amberg.de/uni/poster/baposter/baposter_guide.pdf).
  - Carpeta `figures`: Carpeta donde se almacenan las imágenes `prommra.png` y `uls.png`, utilizadas como logos en la parte superior de la ficha.
 
## Configuración obligatoria

El archivo debe ejecutarse mediante el IDE [RStudio](https://www.rstudio.com/products/rstudio/download/), tener instalado [LaTeX (versión completa)](https://www.latex-project.org/get/) y la siguiente configuración en RStudio:

 - Ir a menú `Tools`
 - Seleccionar la opción `Global options` (o `Project options` si es que se está trabajando dentro de un *R Project*)
 - Ir al menú `Sweave`
 - Tener las siguientes opciones de compilación:
   - Weave Rnw files using: **Sweave**
   - Typeset LaTeX into PDF using: **pdfLaTeX**
   - :ballot_box_with_check: Clean auxiliary output after compile (recomendado)
   - :ballot_box_with_check: Always enable Rnw concordance (requiered for synctex)

## ¿Cómo ejecutar el reporte automático? 

A continuación, se copian las primeras 9 líneas del archivo `Ficha_reporte.Rnw`.

    <<echo=F,results=hide>>=
    #####
    ## HEADER
    # Datos a modificar
    
    channel_name <- 'Canal Churque'
    org <- 'Asociación de Canalistas del Embalse Recoleta'
    # archivo <- "/path/to/data.xlsx"

Son sólo 3 cosas que se deben modificar para ejecutar el reporte de manera correcta. Se debe indicar el nombre del canal asignado al objeto `channel_name` -a modo de ejemplo, Canal Churque-. Luego, asignar la Organización de Usuarios de Agua a la que corresponde el canal al objeto `org` -Asociación de Canalistas del Embalse Recoleta, como ejemplo-. Estos dos valores serán parte de la sección de título de la ficha. Finalmente, asignar la ruta absoluta (o relativa, si se encuentra dentro de la misma carpeta) de la **Planilla PROMMRA Q-CANAL** con los datos de aforo y asginarla al objeto `archivo` (que en este caso se encuentra comentado con un `#`, removerlo para ejecutar el archivo).

Para los nombres o rutas se debe ingresar el valor entre comillas simples o dobles: `'valor'` o `"valor"`.

Una vez realizado el procedimiento descrito, compilar el documento con el botón `Compile PDF` de RStudio.

## A considerar

Los archivos deben estar en cualquier carpeta del sistema con la misma organización. Los archivos `Ficha_reporte.Rnw`, `baposter.cls` y la carpeta `figures` dentro de una misma carpeta raíz. El resultado se alojará en la misma carpeta.

# Instalación previa:

Ya que la apertura de archivos de MS Office en R es difícil, se deben realizar los siguientes pasos previos (dependiendo del sistema operativo de cada ordenador):

## Windows:

 - Instalar [Java JDK versión 9](http://www.oracle.com/technetwork/java/javase/downloads/jdk9-downloads-3848520.html).

 - Añadir la variable de entorno `JAVA_HOME` en Panel de control / Sistema / Configuración avanzada de sistema / Variables de entorno / Varibles de sistema / Nueva:

   - Nombre de la variable: `JAVA_HOME`
   - Valor de la variable: `C:\Program Files\Java\jdk-9.0.1` (para el caso de Java JDK 9.0.1 - 64 Bits)

 - Instalar paquetes `rJava` y `XLConnect`

 - Compilar pdf

## macOS:

 - Instalar [Xcode](https://developer.apple.com/xcode/).

 - Instalar Command Line Tools para Xcode para [macOS 10.12](https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_macOS_10.12_for_Xcode_9.1/Command_Line_Tools_macOS_10.12_for_Xcode_9.1.dmg) o para [macOS 10.13](https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_macOS_10.13_for_Xcode_9.1/Command_Line_Tools_macOS_10.13_for_Xcode_9.1.dmg).

 - Instalar [Java JDK versión 9](http://www.oracle.com/technetwork/java/javase/downloads/jdk9-downloads-3848520.html).

 - Abrir Terminal y ejecutar la siguiente línea: `R CMD javareconf`

 - Instalar paquetes `rJava` y `XLConnect`

 - Compilar pdf

### En el caso que lo anterior no resulte (macOS):

 - Añadir antes de la línea if `(!require("rJava")) install.packages("rJava"); library(rJava)` la siguiente línea:

`dyn.load('/Library/Java/JavaVirtualMachines/jdk-9.0.1.jdk/Contents/Home/lib/server/libjvm.dylib')` (verificar que la ruta y archivo `libjvm.dylib` existan).

**Cualquier duda o consulta, realizarla a la brevedad**
