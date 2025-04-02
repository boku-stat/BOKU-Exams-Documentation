main <- function() {
  # Setup
  library(exams)
  
  # Use this locale/encoding for correct display of special characters
  Sys.setlocale("LC_ALL", "de_DE.UTF-8")
  
  # Load the parameters from the config file
  source("filepath/to/config.R")
  
  # Load parameters from the environment if present, and merge the configs
  # (if there is an object called `env_config` in the global environment, this script
  # will overwrite the parameters read from the config with the respective values)
  if (exists("env_config")) {
    # Drop all `NULL` elements before merging
    env_config <- env_config[!sapply(env_config, is.null)]
    config <- modifyList(config, env_config)
  }
  
  seed <- config$seed
  copies <- config$copies
  converter <- config$converter
  exercise_dir <- config$exercise_dir
  exercise_file <- config$exercise_file
  data_dir <- config$data_dir
  temp_dir <- config$temp_dir
  out_basename <- config$out_basename
  out_type <- config$out_type
  
  dir.create(temp_dir, showWarnings = FALSE)
  
  # Delete temporary directory on exit
  on.exit({
    unlink(temp_dir, recursive = TRUE)
  })
  
  # Convert the exercise file to the desired format
  if (out_type == "html") {
    set.seed(seed)
    exinfo <- exams2html(
      file = exercise_file,
      name = out_basename,
      n = 1,
      converter = converter,
      tdir = temp_dir,
      edir = exercise_dir
    )
  } else if (out_type == "xml") {
    # Generate distinct temp files
    set.seed(seed)
    f <- c()
    for (i in 1:copies) {
      f[i] <- expar(file = file.path(exercise_dir, exercise_file), sample_index = i)
    }
    
    # Generate XML file
    exinfo <- exams2moodle(
      file = f,
      name = out_basename,
      n = 1,
      converter = converter,
      tdir = temp_dir,
      edir = exercise_dir,
      forcedownload = TRUE,
      iname = FALSE, 
      table = NULL
    )
    print("Finished generating the XML file.")
  } else {
    stop("Output file type must be 'html' or 'xml'")
  }
}

main()