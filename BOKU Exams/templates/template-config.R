config <- list(
  # Seed to use for generating the same batch of exercises; 
  # individual exercise seeds can be set with `exercise_seed implemented within the exercise`
  seed = 23091995,
  
  # Number of exercises to generate when using the XML format
  copies = 200,
  
  # A seed for the random number generator within the exercise; this ensures 
  # that the same specific exercise is generated each time the code is run. 
  # If `NULL`, the seed will be randomly generated using the `seed` parameter.
  exercise_seed = NULL,
  
  # Converter used by the exams package
  converter = "pandoc",
  
  # Directory containing the exercise Rmarkdown file
  exercise_dir = "dir/to/Rmdfile",
  
  # Name of the exercise Rmarkdown file
  exercise_file = "name of Rmdfile",
  
  # Directory containing the data
  data_dir = "extra/dir/for/data",
  
  # Directory to store temporary files
  # Warning: all contents will be deleted!
  temp_dir = "./temp",
  
  # Output file base name
  out_basename = "name for output", 
  
  # Output file type;
  # "html" for a preview or "xml" for import into Moodle
  out_type = "xml"
)