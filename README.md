# renamer
renames files in ascending order based on date. 

This script will take files as input and rename them in ascending numerical order based on date of creation.
It is able to handle spaces in filenames, and its intended use is for MacOS made screenshots.



# Running the script

An example call would like like so:\
bash renamer.sh [files]\
The easiest way to use it is to provide a path to a folder with many files of the same type. Then, 
type in the location and use the * to indicate all files of a specific type.\
For example:\
users/gf/desktop/*.png\
This will grab all png files in the desktop folder.\
\
Utilize the -h or --help flag to learn about the different flags. 

