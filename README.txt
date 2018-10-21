I've created a single .R file that loads the data and performs the cleaning and summarization. 

The first few lines set a working directory and create a list of files from the data provided.

The function comb_files iterates over the list of detected files, loads them into memory cleans
creates a new DF with the row-wise Mean and Standard Deviation of the loaded file. This new DF
Only has simple just simple variable naming. It does that next.

After the train and DF files are loaded and reshaped/summarized I go into the variables names
And make them more intelligible by just changing abbreviations and aliasing according to the 
Data readme. After it renames the variables it groups the data on Subject ID and Activity. It
Then summarizes all the variables to this aggregation and writes the table.

Woof, I keep feeling like the homework have super vague instructions.

