#!/bin/bash
#This took way long than is should have
Help()
{
   echo "This script will move or copy the specified files into another directory, renaming them according to date created in ascending order."
   echo
   echo "Commands:"
   echo "-h --help         Print this Help."
   echo "-p --prefix       Set a prefix to be put in front of the number of the file moved or copied. If not specified, the filename will just be a number."
   echo "-c --copy         Copy the files instead of moving them. (WARNING-do not do this to the same files to the same directory more than once)"
   echo "-d --dry_run      Print all actions done instead of actually doing anything."
   echo "-o --output_dir   Set the output directory for the files to go to. If not specified, it will make a new directory in the present working directory called 'results.'"
   echo "Example call:"
   echo "bash renamer.sh -o /Users/gf/files -p fortnite -c /Users/gf/desktop/wargamesscreenshots/*.png"
}

# optspec="hpcod-:" #fix this stuff
#https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options
OUTPUT_DIR=./results
pf=
copy=false
dryrun=false
ifcopy1st=false
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--prefix)
      pf="$2"
      shift # past argument
      shift # past value
      ;;
    -o|--output_dir)
      OUTPUT_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -c|--copy)
      copy=true
      shift # past argument
      
      ;;
    -d|--dry_run)
      dryrun=true
      shift # past argument
      
      ;;
    -h|--help)
      Help
      shift
      ;;

    --default)
      DEFAULT=YES
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

shift $((OPTIND-1))
if [ $dryrun == true ] 
then
   echo "Parsed Arguments"
fi

IFS=$'\n'

files="${POSITIONAL_ARGS[@]}"

dates=()
rm dates.txt
touch dates.txt
for i in ${POSITIONAL_ARGS[@]}; do
   n=${#i}
   
   num1=$((n-2))
   
   num2=$((n-1))
   if [ ${i:0:1} == "(" ]; then
      stat -f "%Sm %N" -t "%y%m%d%H%M%S" "${i:1}" >> dates.txt
   elif [ ${i:num2:n} == ")" ]; then
      stat -f "%Sm %N" -t "%y%m%d%H%M%S" "${i:0:num2}" >> dates.txt
   else
      stat -f "%Sm %N" -t "%y%m%d%H%M%S" "$i" >> dates.txt
   fi

   
   
done
if [ $dryrun == true ] 
then
   echo "Sorted files into text file named dates.txt"
fi



rm -f sorted.txt
sort -k1 -n dates.txt -o sorted.txt
rm -f sortfiles.txt
awk '{print $2 " :  " NF;}' sorted.txt > sortfiles.txt
awk '{for(i=2;i<=NF;i++) printf $i" "; print ""}' sorted.txt > sortfiles.txt

if [ $dryrun == true ] 
then
   echo "Created files to iterate through the filenames"
fi


mkdir -p $OUTPUT_DIR
if [ $dryrun == true ] 
then
   echo "Created output directory"
fi
kfilepost=1

if [ $dryrun == false ]
then
   if [ $copy == true ] 
   then
      for file in $(awk '{for(i=2;i<=NF-1;i++) printf $i" "; print $NF}' sorted.txt); do 
         
         cp "$file" $OUTPUT_DIR
         
         
      done
      
      cd $OUTPUT_DIR
      for FILE in *; do 
         mv "$FILE" "$pf"_`printf "%02d" $kfilepost`.png
         kfilepost=$((kfilepost+1))
      done

   else 
   for file in $(awk '{for(i=2;i<=NF-1;i++) printf $i" "; print $NF}' sorted.txt); do 
      # ls -l "$file"
      mv "$file" $OUTPUT_DIR/"$pf"_`printf "%02d" $kfilepost`.png
      
      kfilepost=$((kfilepost+1))
      # echo "$file"
   done
   fi
fi
if [ $dryrun == true ] 
then
   echo "Copied or moved files "
fi
if [ $dryrun == true ] 
then
   echo "Script finished"
fi



#test command/example command
#bash renamer.sh -p fortnite /Users/gf/desktop/wargamesscreenshots/*.png


