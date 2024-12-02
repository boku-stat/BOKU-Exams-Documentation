#create an automatic .Rmd template for R/exams -> later integration into website with adjustable parameters? 

#data generation 
header <- "\`\`\`{r data generation, echo = FALSE, results = \"hide\"}\n"
lists <- "answers <- list()\nsolutions <- list()\ntypes <- list()\nexplanations <- list() \ntolerances <- list()\n"
end <- "\n### fill in lists here\n\n\`\`\`"
    
paste0(header,lists, end) |> write( file ="created_template.Rmd")

