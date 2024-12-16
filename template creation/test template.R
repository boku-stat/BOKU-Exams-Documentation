# create an automatic .Rmd template for R/exams -> later integration into website with adjustable parameters?

# basic template  generation
basic_template <- function(n, meta_name, meta_title, meta_version, types = NULL, ex_type){
  header <- "\`\`\`{r data generation, echo = FALSE, results = \"hide\"}\n"
  lists <- "answers <- list()\nsolutions <- list()\ntypes <- list()\nexplanations <- list() \ntolerances <- list()\n\n"
  lists_assignment <- NULL
  if(!is.null(n)){ 
    for(i in 1:n){
      lists_assignment <- paste0(lists_assignment, "answers[[", i, "]] <- \nsolutions[[", i, "]] <- \ntypes[[", i,"]] <- \"", types[i], "\"", "\nexplanations[[", i, "]] <- \ntolerances[[", i, "]] <- \n\n")
      end <- "\n\n\`\`\`\n\n"
    }
  }else{
    end <- "\n### fill in lists here\n\n\`\`\`\n\n"
  }
  
  content <- paste0(header, lists, lists_assignment, end)
  
  question <- "Question\n========\n\n*Write the question text here*\n\n"
  questionlist_code_1 <- "`\`\`{r questionlist, echo = FALSE, results = \"asis\"}\nfor (x in 1:length(types)) {\n\tif (types[x] %in% c(\"num\", \"string\")) {\n"
  questionlist_code_2 <- "\t\tanswers[x] <- \"\"\n\t}\n}\nanswerlist(unlist(answers), markup = \"markdown\")\n\`\`\`\n\n"
  
  content <- paste0(content, question, questionlist_code_1, questionlist_code_2)
  
  solution <- "Solution\n========\n\n*Write the feedback here*\n\n"
  solution_list <- "\`\`\`{r solutionlist, echo = FALSE, results = \"asis\"}  \nfor (x in 1:length(solutions)) {  \n  if (types[x] == \"schoice\") {\n    explanations[x] <- solutions[x] |> lapply(function(x) ifelse(x, \"True\", \"False\"))  \n  } else {  \n    explanations[x] <- solutions[x]  \n  }  \n}  \nanswerlist(unlist(explanations), markup = \"markdown\")  \n\`\`\`\n\n"
  meta_list <- "\`\`\`{r meta, echo = FALSE, results = 'hide'}\nfor (x in 1:length(solutions)) {\n  if (types[x] == \"schoice\") {\n    solutions[x] <- solutions[x] |>\n      unlist() |>\n      mchoice2string()\n  }\n}\n\`\`\`\n\n"
  
  content <- paste0(content, solution, solution_list, meta_list)
  
  metainfo <- paste0("Meta-information\n========\n\nexname: ", meta_name, " \nextitle: ", meta_title, " \nextype: ", ex_type, "\nexsolution: \`r paste(solutions, collapse = \"|\")\` \nexclozetype: \`r paste(types, collapse = \"|\")\` \nextol: \`r paste(tolerances, collapse = \"|\")\` \nexshuffle: TRUE \nexversion: ", meta_version) 
  
  content <- paste0(content, metainfo) 
  return(content)
}








