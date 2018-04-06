#!/bin/bash
# example scriptlet Safari 11.0.3

now=$(date +"%m_%d_%Y")
FILE="/tmp/softwarecheck.log"

app_name="Safari"
app_path="/Applications/$app_name.app"
desired_version="13604.4.7.1.6"

#Get the line, regardless of whether it is correct
version_line=$(plutil -p "${app_path}/Contents/Info.plist" | grep "CFBundleVersion")
echo $version_line
if [[ $? -ne 0 ]]; then
    version_line=$(plutil -p "${app_path}/Contents/Info.plist" | grep "CFBundleShortVersionString")
    if [[ $? -ne 0 ]]; then #if it failed again, the app is not installed at that path
        echo "$app_path not installed at all sdf"
        exit 123456
    fi
fi

#Some text editing to get the real version number
real_version=$(echo $version_line | grep -o '"[[:digit:].]*"' | sed 's/"//g')
if [ "$real_version" == "$desired_version" ]; then
    echo "version match"
    #echo "app_name $real_version" >>
    exit 0
fi
if [[ "$real_version" > "$desired_version" ]]; then
    echo "newer version"
    exit 64
fi
echo "version needs updating"
exit 1