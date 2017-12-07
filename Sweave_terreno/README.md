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
