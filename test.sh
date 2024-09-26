declare -A MYARRAY
read -p "Enter the number of rows:" r
read -p "Enter the number of columns: " c

for((i = 0; i < r; i++))
do
  for((j = 0;j < c; j++))
  do
     MYARRAY[${i},${j}]=$RANDOM
  done
done

function write_to_file()
{
   local file="2d_test.txt"
   if [ ! -f "$file" ]   # check if the $file exists
   then
       "touch $file"   # if file does not exist, create it now empty
   fi

   >$file    # clear the contents of the file

   for((i = 0; i < r; i++))
   do
     for((j = 0; j < c; j++))
     do
        echo -ne "${MYARRAY[${i},${j}]}\t" >> "$file"
     done
   done
   echo "" >> "$file"  # append a newline to the file
}

ARRAY[1,2]=3

[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]
[][][][][][]