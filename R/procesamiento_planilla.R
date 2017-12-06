library(XLConnect)
library(minpack.lm)
library(sp)
library(raster)
library(gstat)
library(rasterVis)

archivos <- list.files('~/Desktop/Proyectos/Graficos_canales',pattern = '.xlsx$',recursive = T,full.names = T)

nombres <- list.files('~/Desktop/Proyectos/Graficos_canales',pattern = '.xlsx$',recursive = T,full.names = F)

nombres <- gsub(pattern = '.*/',replacement = '',x = nombres)

nombres <- gsub(pattern = '.xlsx',replacement = '',x = nombres)

setwd('~/Desktop/Proyectos/Graficos_canales/Figuras/')

for(j in 1:length(archivos)){
  
  wb <- loadWorkbook(archivos[j])
  
  hoja <- readWorksheet(wb,sheet = 'Cálculo Aforo',colTypes = XLC$DATA_TYPE.NUMERIC,forceConversion = T)
  
  ix <- hoja[22,2]
  
  datos <- hoja[27:(27 + (ix)*2+2),c(3,4,31:35)]
  datos <- datos[apply(is.na(datos),MARGIN = 1,FUN = sum)<7,]
  
  names(datos) <- c('Vert','Prof','v0.2','v0.6','v0.8','vm','qs')
  
  maxPro <- max(datos[,2],na.rm = T)
  
  db <- data.frame(vertical=NA,altura=NA,velodidad=NA)
  
  for(i in 2:(ix+1)){
    altura_temp <- datos[i,2]
    velocidad_temp <- unlist(datos[i,3:5])
    vertical_temp <- datos[i,1]
    
    xx <- maxPro-c(altura_temp*0.8,altura_temp*0.4,altura_temp*0.2)
    yy <- c(velocidad_temp)
    
    df_temp <- data.frame(vertical=vertical_temp,altura=xx,velodidad=yy)
    
    db <- rbind.data.frame(db,df_temp)
  }
  
  db <- db[complete.cases(db),]
  
  db_respaldo <- db
  
  names(db) <- c('x','y','z')
  
  coordinates(db) <-  ~x+y
  
  r <- raster(xmn=0,ymn=0,ymx=max(datos[,2],na.rm=T),xmx=max(datos[,1],na.rm=T),
              crs=NA,resolution=min(min(datos[datos[,2]>0,2],na.rm=T),min(datos[datos[,1]>0,1],na.rm=T))/5)
  
  xy <- as(r,'SpatialGrid')
  
  poligono <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(datos[1,1],datos[,1],datos[dim(datos)[1],1],datos[1,1]),maxPro-c(0,datos[,2],0,0)))),'p1')))
  
  r2 <- raster(idw(formula = z~1, locations=db,newdata=xy,maxdist = Inf))
  
  r3 <- mask(r2,poligono)
  
  png(filename = paste0('velo_',nombres[j],'.png'),width = 2000,height = 1500,res = 300)
  print(levelplot(r3,margin=F,
            par.settings = rasterTheme(region=brewer.pal(9, 'Blues'))))
  dev.off()
  
  Alturas <- datos$Prof-maxPro
  
  png(filename = paste0('forma_',nombres[j],'.png'),width = 2000,height = 1500,res = 300)
  print({plot(x=c(0,datos$Vert,datos$Vert[length(datos$Vert)]),y=c(0,-datos$Prof,0),type='l',lwd=2,
       ylab='Profundidad (m)',xlab='Ancho (m)',asp=1)
  lines(x=c(0,datos$Vert[length(datos$Vert)]),y=c(0,0),col='blue')
  for(i in 2:(ix+1)){
    lines(x=c(datos[i,1],datos[i,1]),y=c(0,-datos[i,2]),lty=3)
  }})
  dev.off()
  
}


wb <- loadWorkbook('~/Desktop/Proyectos/Graficos_canales/BELLAVISTA BAJO/Bellavista bajo 0,24.xlsx')

hoja <- readWorksheet(wb,sheet = 'Cálculo Aforo',colTypes = XLC$DATA_TYPE.NUMERIC,forceConversion = T)

ix <- hoja[22,2]

datos <- hoja[27:(27 + (ix)*2+2),c(3,4,31:35)]
datos <- datos[apply(is.na(datos),MARGIN = 1,FUN = sum)<7,]

names(datos) <- c('Vert','Prof','v0.2','v0.6','v0.8','vm','qs')

maxPro <- max(datos[,2],na.rm = T)


db <- data.frame(vertical=NA,altura=NA,velodidad=NA)

for(i in 2:(ix+1)){
  altura_temp <- datos[i,2]
  velocidad_temp <- unlist(datos[i,3:5])
  vertical_temp <- datos[i,1]
  
  xx <- maxPro-c(altura_temp*0.8,altura_temp*0.4,altura_temp*0.2)
  yy <- c(velocidad_temp)

  df_temp <- data.frame(vertical=vertical_temp,altura=xx,velodidad=yy)
  
  db <- rbind.data.frame(db,df_temp)
}

db <- db[complete.cases(db),]

db_respaldo <- db

names(db) <- c('x','y','z')

coordinates(db) <-  ~x+y

r <- raster(xmn=0,ymn=0,ymx=max(datos[,2],na.rm=T),xmx=max(datos[,1],na.rm=T),
            crs=NA,resolution=min(min(datos[datos[,2]>0,2],na.rm=T),min(datos[datos[,1]>0,1],na.rm=T))/5)

xy <- as(r,'SpatialGrid')

poligono <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(datos[1,1],datos[,1],datos[dim(datos)[1],1],datos[1,1]),maxPro-c(0,datos[,2],0,0)))),'p1')))

r2 <- raster(idw(formula = z~1, locations=db,newdata=xy,maxdist = Inf))

r3 <- mask(r2,poligono)

levelplot(r3,margin=F,
          par.settings = rasterTheme(region=brewer.pal(9, 'Blues')))

Alturas <- datos$Prof-maxPro

plot(x=c(0,datos$Vert,datos$Vert[length(datos$Vert)]),y=c(0,-datos$Prof,0),type='l',lwd=2,
     ylab='Profundidad (m)',xlab='Ancho (m)',asp=1)
lines(x=c(0,datos$Vert[length(datos$Vert)]),y=c(0,0),col='blue')
for(i in 2:(ix+1)){
  lines(x=c(datos[i,1],datos[i,1]),y=c(0,-datos[i,2]),lty=3)
}


print('Stop!')


### En desuso

db <- data.frame(vertical=c(0,max(datos$Vert)),altura=0,velodidad=0)

for(i in 2:(ix+1)){
  altura_temp <- datos[i,2]
  velocidad_temp <- unlist(datos[i,3:5])
  vertical_temp <- datos[i,1]
  
  xx <- c(altura_temp,altura_temp*0.8,altura_temp*0.4,altura_temp*0.2, altura_temp*0.05)
  yy <- c(velocidad_temp[1]*1.1,velocidad_temp,min(velocidad_temp,na.rm=T)*0.5)
  
  df <- data.frame(x=xx,y=yy)
  
  m <- nlsLM(y ~ c + b*x^2 + a*x, start = list(a = 1, b = 1, c = 1), data = df)
  
  print({plot(y~x,data=df,ylab="velocidad",xlab="altura",xlim=c(0,altura_temp),
              ylim=c(0,max(velocidad_temp,na.rm=T)*1.2))
    lines((0:5000)/100, predict(m,newdata=data.frame(x = (0:5000)/100)))})
  
  x2 <- seq(from=0,to=altura_temp,length.out = 20)
  y2 <- predict(m,newdata=data.frame(x = x2))
  y2[y2<0] <- 0
  df_temp <- data.frame(vertical=vertical_temp,altura=x2,velodidad=y2)
  
  db <- rbind.data.frame(db,df_temp)
}

db <- data.frame(vertical=seq(from=0,to=max(datos[,1]),length.out = 30),altura=0,velodidad=0)

d <- db

g <- gstat(id="var", formula=z~1, data=d)
g
v <- variogram(g)
plot(variogram(z~1, d, alpha=c(110)))

range=sqrt(diff(d@bbox["x",])^2+diff(d@bbox["y",])^2)/4
psill=var(d$z)
{vgm=vgm(nugget=min(v[,3]),model="Bes",psill=psill,range=range)
v.fit <- fit.variogram(v, vgm,fit.sills=c(F,F),fit.ranges=F,fit.method = F,fit.kappa = F)
#plot(v, model=v.fit, as.table=TRUE)

g <- gstat(g, id="var", model=v.fit)

pred=predict(g, model=vgm, newdata=xy)

#rasterizar los valores y mostrtarlos
r3 <- raster(pred)

print(levelplot(r3,at=seq(0, maxValue(r3), length.out=20)))

mean(r3[])*bbox(r)[1,2]*bbox(r)[2,2]}

writeRaster(r3,"test.tif")

rgdal::writeOGR(obj = db,dsn = "/Users/aldotapia/",layer = "puntos", driver="ESRI Shapefile")

vgm()



levelplot(r2,at=seq(0, maxValue(r2), length.out=20),margin=F,
          par.settings = rasterTheme(region=brewer.pal(9, 'Blues')))


test <- idw(formula = z~1, locations=db,newdata=xy,
            maxdist = Inf)
mean(test@data$var1.pred)*bbox(r)[1,2]*bbox(r)[2,2]


