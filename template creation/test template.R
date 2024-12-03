# create an automatic .Rmd template for R/exams -> later integration into website with adjustable parameters?

# basic tempalte  generation
basic_template <- function(filepath){
  header <- "\`\`\`{r data generation, echo = FALSE, results = \"hide\"}\n"
  lists <- "answers <- list()\nsolutions <- list()\ntypes <- list()\nexplanations <- list() \ntolerances <- list()\n"
  end <- "\n### fill in lists here\n\n\`\`\`\n"
  
  write(paste0(header, lists, end), file = filepath)
  
  question <- "Question\n========\n\n*Write the question text here*\n\n"
  questionlist_code_1 <- "`\`\`{r questionlist, echo = FALSE, results = \"asis\"}\nfor (x in 1:length(types)) {\n\tif (types[x] %in% c(\"num\", \"string\")) {\n"
  questionlist_code_2 <- "\t\tanswers[x] <- \"\"\n\t}\n}\nanswerlist(unlist(answers), markup = \"markdown\")\n\`\`\`\n"
  
  write(paste0(question, questionlist_code_1, questionlist_code_2), file = filepath, append = TRUE)
  
  solution <- "Solution\n========\n\n*Write the feedback here*\n\n"
  solution_list <- "\`\`\`{r solutionlist, echo = FALSE, results = \"asis\"}  \nfor (x in 1:length(solutions)) {  \n  if (types[x] == \"schoice\") {\n    explanations[x] <- solutions[x] |> lapply(function(x) ifelse(x, \"True\", \"False\"))  \n  } else {  \n    explanations[x] <- solutions[x]  \n  }  \n}  \nanswerlist(unlist(explanations), markup = \"markdown\")  \n\`\`\`\n\n"
  meta_list <- "\`\`\`{r meta, echo = FALSE, results = 'hide'}\nfor (x in 1:length(solutions)) {\n  if (types[x] == \"schoice\") {\n    solutions[x] <- solutions[x] |>\n      unlist() |>\n      mchoice2string()\n  }\n}\n\`\`\`\n"
  
  write(paste0(solution, solution_list, meta_list), file = filepath, append = TRUE)
  
  metainfo <- "Meta-information\n========\nexname: *write a name here* \nextitle: *write a title here* \nextype: cloze \nexsolution: \`r paste(solutions, collapse = \"|\")\` \nexclozetype: \`r paste(types, collapse = \"|\")\` \nextol: \`r paste(tolerances, collapse = \"|\")\` \nexshuffle: TRUE \nexversion: v1"
  
  write(metainfo, file = filepath, append = TRUE)
  return(invisible())
}







