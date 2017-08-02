# Pre-process: check validity of input files.
# Function to check that expected columns exist
# Return boolean
check_input <- function(input_path, expected_colnames, expected_classes){
  summ <- read.csv( input_path, header = TRUE, colClasses = expected_classes )
  
  # Check that the header is as expected 
  vars_count <- length(expected_colnames)
 
  cat("Checking number of variables from: ", input_path, "\n")
  cat("Expected:", vars_count, "encountered:", length(summ),"\n")
  
  if(length(summ) != vars_count){
    cat("Unexpected number of variables!\n")
    return(FALSE)
  }
  
  # Check that names of columns matches expected column names
  col_differences <- setdiff(expected_colnames, colnames(summ))
  if(length(col_differences) == 0){
    cat("Found expected columns.\n")
  } else {
    cat("Unexpected columns!\n")
    print(col_differences)
    return(FALSE)
  }
  
  # return True if the input appears okay.
  return(TRUE)
}

# Check the CLC input if the input file exists
expected_clc_colnames <- c("fy", "quart", "sta6a", "WardSID", "trtsp_1", "name", "WardLocationName", 
                             "X_TYPE_", "X_FREQ_", "goc_7", "goc_14", "goc_30", "goc_pre90", 
                             "goc_pre", "goc_none", "goc_post30", "goc_post")

expected_clc_classes <- c("integer", "integer", "character", "character", "character",  "character", "character",
                            "integer", "integer", "integer", "integer", "integer", "integer",
                            "integer", "integer", "integer", "integer")

clc_filename <- file.path("input","clc.csv")

if(file.exists(clc_filename)){
  clc_result <- check_input(clc_filename, expected_clc_colnames, expected_clc_classes)
}

# Need to use make names as _TYPE and _FREQ_ aren't syntacticly valid
expected_hbc_colnames <- make.names(c("fy","quart","hbpc_sta6a","_TYPE_","_FREQ_","no_hbpc","no_hbpc_ever","no_hbpc30",
                           "hbpc","one_stop","numer1","denom1","numer2","denom2","numer3","denom3","denom90",
                           "numer90","goc_pre","goc_any","goc_3","n1","n2","n3","min1","min2","min3",
                           "mean1","mean2","mean3","max1","max2","maX3","goc_perc1","goc_perc2","goc_perc3","goc_any_perc"))

expected_hbc_classes <- c("integer","integer","factor",rep("character",5),
                           "integer","character","integer","character","integer","character","integer","character","character",
                           "integer","integer",rep("character",18) )

hbc_filename <- file.path("input","hbpc.csv")
if(file.exists(hbc_filename)){
  hbc_result <- check_input(hbc_filename, expected_hbc_colnames, expected_hbc_classes)
}


# Exit with status code 65 in the even hbpc or clc input files aren't good
if(exists('clc_result')){
  if(clc_result == FALSE){
    quit(save='no', status=65)
  }
}
if(exists('hbc_result')){
  if(clc_result == FALSE){
    quit(save='no', status=65)
  }
}

# Handle case where neither input exist
if(!exists('clc_result') && !exists('hbc_result')){
  cat("\n\n!!! NO INPUT FILES FOUND !!!")
  quit(save='no', status=65)
}
