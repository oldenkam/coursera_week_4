library(data.table)
library(dplyr)


### SET YOUR WORKING DIRECTORTY ###
setwd('/Users/adamoldenkamp/Developer/R/coursera week 4/')

test <-
  list.files(
    "UCI HAR Dataset/test",
    pattern = ".txt$",
    recursive = TRUE,
    full.names = TRUE
  )
train <-
  list.files(
    "UCI HAR Dataset/train",
    pattern = ".txt$",
    recursive = TRUE,
    full.names = TRUE
  )


comb_files <- function(x) {
  i <- 1
  df_files <- matrix(nrow = nrow(fread(x[i]))) %>% tbl_df
  while (i <= length(x)) {
    file <- fread(x[i]) %>% tbl_df
    if (ncol(file) > 1) {
      df_files <-
        cbind(df_files, apply(file, 1, sd), apply(file, 1, mean))
      colnames(df_files)[ncol(df_files) - 1] <-
        paste0(x[i], " Standard Deviation")
      colnames(df_files)[ncol(df_files)] <- paste0(x[i], " Mean")
    } else{
      df_files <- cbind(df_files, file)
      colnames(df_files)[ncol(df_files)] <- x[i]
    }
    i <- i + 1
  }
  df_files[, 1] <- NULL
  return(df_files)
}

combined_test <- comb_files(test)
colnames(combined_test) <-
  sub(
    "UCI HAR Dataset/test/",
    "",
    colnames(combined_test)
  )
colnames(combined_test) <-
  sub("^Inertial Signals/", "", colnames(combined_test))
colnames(combined_test) <-
  sub("test", "", colnames(combined_test))

combined_train <- comb_files(train)
colnames(combined_train) <-
  sub(
    "UCI HAR Dataset/train/",
    "",
    colnames(combined_train)
  )
colnames(combined_train) <-
  sub("^Inertial Signals/", "", colnames(combined_train))
colnames(combined_train) <-
  sub("train", "", colnames(combined_train))

df_combined <- rbind(combined_test, combined_train)
colnames(df_combined) <- sub("*.txt", "", colnames(df_combined))
colnames(df_combined) <- gsub("_", " ", colnames(df_combined))
colnames(df_combined) <- gsub("  ", " ", colnames(df_combined))

colnames(df_combined) <- gsub("body", "Body", colnames(df_combined))
colnames(df_combined) <-
  gsub("acc", "Acceleration", colnames(df_combined))
colnames(df_combined) <-
  gsub("gyro", "Gyroscopic", colnames(df_combined))
colnames(df_combined) <-
  gsub(" x ", " X-axis ", colnames(df_combined))
colnames(df_combined) <-
  gsub(" y ", " Y-axis ", colnames(df_combined))
colnames(df_combined) <-
  gsub(" z ", " Z-axis ", colnames(df_combined))
colnames(df_combined) <-
  gsub("total", "Total", colnames(df_combined))
colnames(df_combined) <-
  gsub("subject ", "Subject ID", colnames(df_combined))
colnames(df_combined) <-
  gsub("^y ", "Activity Label", colnames(df_combined))

df_combined %>% tbl_df

df_combined <- group_by(df_combined, `Activity Label`, `Subject ID`)
df_combined <- summarise_all(df_combined, funs(mean))

write.table(df_combined, file="output_table.txt",row.name=FALSE)
