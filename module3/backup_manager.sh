#!/bin/bash
echo 
echo "BACKUP MANAGER"
echo "name of the script: $0"
echo 

#Command line args

sdir=$1
bdir=$2
file_type=$3
echo "provided info"
echo "source_directory is : $sdir"
echo "backup_directory is : $bdir"
echo "file type is : $file_type"

#to check the backup directory

if [ ! -d "$bdir" ]; then
echo "the backup directory doesnt exist.. so creating a backup directory"
mkdir -p  "$bdir"
if [ $? -ne 0 ]; then
echo "there was a problem in creating the backup directory EXIT!!" 
exit
fi 
fi

#globbing 

shopt -s nullglob
files=("$sdir"/*."$file_type")

#to check the source file has files and  matched the extension

if [ ! -z "$(ls -A "$sdir")" ] && [ ${#files[@]} -eq 0 ] ; then
    echo "Source directory is empty or no matching files EXIT !!" 
    exit 
fi

#storing in array

echo "the files for backup are .."
for i in "${files[@]}";
do
fsize="$(stat -c %s "$i")"
fname="$(basename "$i")"
echo "$fname - $fsize bytes"
done

#export enviroment variable

export BACKUP_COUNT=0

#backup process and updating if new

totalsize=0
for f in "${files[@]}";
do
filenam=$(basename "$f")
destination="$bdir/$filenam"
if [ -f "$destination" ];
then
if [ "$f" -nt "$dest" ];
then
cp "$f" "$destination"
echo "newer file : $filenam "
else 
echo "file is already new"
continue
fi 
else
cp "$f" "$destination"
echo "filename $filenam is copied"
fi
((BACKUP_COUNT++))
fsize="$(stat -c %s "$f")"
totalsize+="$fsize"
done

#creating the report

report="$bdir/backup_report.log"
{
echo "backup report - `date` "
echo
echo "source directory is $sdir "
echo "backup directory is $bdir"
echo "the file extension type is $file_type"
echo "total file processed ${#files[@]}"
echo "total file backedup $BACKUP_COUNT "
echo "total size of the file $totalsize "
} > "$report"
echo "the report is updated in $report  "

