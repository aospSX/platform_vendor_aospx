#!/bin/sh

# an example of how to use script-gen:
# ./vendor/aospx/bot/changelog_gen.sh 6/4/2012
# try 'lunch' if problems occur

sdate=${1}
cdate=`date +"%m_%d_%Y"`
rdir=`pwd`

echo "Constructing Changelog..."

# Check the date start range is set
if [ -z "$sdate" ]; then
    echo "!!!!---- Start date not defined ----!!!!"
    echo "Please define a start date in mm/dd/yyyy format."
    read sdate
fi

# Find the directories to log
find $rdir -name .git | sed 's/\/.git//g' | sed 'N;$!P;$!D;$d' | while read line
do
    cd $line
    # Test to see if the repo needs to have a changelog written.
    log=$(git log --pretty="%an - %s" --no-merges --since=$sdate --date-order)
    project=$(git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//')
    if [ ! -z "$log" ]; then
        # Write the changelog
        mkdir "$ANDROID_PRODUCT_OUT"/system/etc/
        echo "Project name: $project" >> "$ANDROID_PRODUCT_OUT"/system/etc/Changelog_$cdate.txt
        echo "$log" | while read line
        do
             echo "  •$line" >> "$ANDROID_PRODUCT_OUT"/system/etc/Changelog_$cdate.txt
        done
        echo "" >> "$ANDROID_PRODUCT_OUT"/system/etc/Changelog_$cdate.txt
    fi
done
echo "Changelog Generated!"

cd "$ANDROID_PRODUCT_OUT"
zip -r aospX-1.0.0-MR1SG-*.zip system/etc/Changelog_$cdate.txt
echo "  to completed build..."
echo "Complete."

# TODO: I've got to find a better way to find the zip version... Using "PRODUCT_VERSION"s didn't work in any implementation I've tried so far. Just doing it manually for now.

exit 0
