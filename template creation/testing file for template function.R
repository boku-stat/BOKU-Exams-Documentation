#Testing file for template function 

source("test template.R", local = TRUE) 

n <- 2 
meta_name <- "TEST"
meta_title <- "ABC"
meta_version <- "v2" 
types <- c("num", "string")
ex_type <- "cloze"

basic_template(n = n, meta_name, meta_title, meta_version, types, ex_type)
