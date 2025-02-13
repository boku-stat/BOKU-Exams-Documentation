library(exams) #load content 

#set path and filename 
path <- "path/to/file-folder"
file <- "name of file.Rmd"

#set working directory 
setwd(path) 

#execute one of these lines, matching the desire output 
exams2pdf(file) #output: pdf
exams2html(file ) #output: html 
exams2moodle(file) #ouput: xml for moodle import 