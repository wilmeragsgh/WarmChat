# Carga de librerias necesarias 
install = function(pkg){
  #Si ya est? instalado, no lo instala.
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    if (!require(pkg, character.only = TRUE)) stop(paste("load failure:", pkg))
  }
}
install("foreach")
libs = c("tm", "rvest","caret","SnowballC","shiny","stringr")
foreach(i = libs) %do% install(i)
rm(libs,i,install)