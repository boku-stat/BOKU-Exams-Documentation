#TODO fill out other stories

stories <- list( # stories (which are lists themselves) are stored in a list
    sun_plant = list(
    name = "sun_plant",
    text = "An experiment was conducted to study the effects sun exposure on the height of tomato plants. Each plant was exposed to the sunlight for a certain period of time a day. After 30 days, their height was recorded.", 
    var = c("sun exposure", "height of tomato plants"), 
    unit = c("h", "cm"), 
    mu = 5, #needed for generating data 
    sigma = 1, 
    m = 7,
    c = 5,
    digit = 1
  ),
  
 shoe_size = list(
    name = "shoe_size",
    text = paste("An experiment was conducted to study the relationship between shoe size and height. The shoe size and height of", n, "women was recorded."), 
    var = c("shoe size", "height"), 
    unit = c("", "cm"),
    mu = 39,
    sigma = 2.5, 
    m = 2.2, 
    c = 80, 
    digit = 0
  ), 
  
  run_heart = list(
    name = "run_heart",
    text = paste("An experiment was conducted to study the relationship between a person's running speed and their heartrate.", n, "participants were asked to run 100m and their maximum speed and their maximum heart rate were recorded."), 
    var = c("running speed", "heart rate"), 
    unit = c("km/h", "bpm"), 
    mu = 23, 
    sigma = 2,
    m = 4, 
    c = 60,
    digit = 1
  )
)