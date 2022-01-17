#!/bin/sh

echo "Navigating to script directory"
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

echo "Running from $parent_path"
cd "$parent_path"

ProfileCreationDate=`date '+%Y-%m-%d'`
echo "Setting profile creation date to today, $ProfileCreationDate"

configurationProfileTemplateFile=$parent_path/FontProfileTemplate.mobileconfig
echo "Using $configurationProfileTemplateFile as template"

AllFontsXML=$parent_path/AllFontsXML
echo "Creating AllFontsXML file"

configurationProfileFile=$parent_path/FontProfile-$ProfileCreationDate.mobileconfig
echo "Using $configurationProfileFile as Output Profile"

configurationProfileName=`basename $configurationProfileFile`
echo "Setting Configuration Profile name: $configurationProfileName"

ProfileIdentifier=com.samaritan.$configurationProfileName.fonts
echo "Creating Profile Identifier"

ProfileUUID=`uuidgen`
echo "Creating Profile UUID"

echo "Finding font files in $parent_path ..."
echo `ls $parent_path`

mkdir $parent_path/Base64Fonts || exit 1
echo "Creating a directory to hold fonts converted to Base64"

for i in $parent_path/*.otf

    do
        
        FontName=`basename $i`
        echo "Processing $FontName..."
        
        echo "Getting font name and UUIDs"
        
        fontBase64File=`mktemp -t $FontName`
        fontXMLSnippet=$parent_path/Base64Fonts/$FontName
        fontXMLSnippetTemplate=$parent_path/Base64Template
        fontUUID=`uuidgen`
        
        # cat sample.txt | sed -e "s/$SEARCH/$REPLACE/" >> result.txt
        
        #cp $fontXMLSnippetTemplate $fontXMLSnippet
        base64 -b 52 -i "$i" -o "$fontBase64File" || exit 1
        sed -e '/<data>/ r '"$fontBase64File" "$fontXMLSnippetTemplate" >> "$fontXMLSnippet" || exit 1
        echo "Encoding font as Base64 and creating xml snippet"
        sed -i'' -e "s/fontname/$FontName/" $fontXMLSnippet || exit 1
        sed -i'' -e "s/fontidentifier/${fontUUID}/" $fontXMLSnippet || exit 1
        sed -i'' -e "s/fontpayloaduuid/${fontUUID}-$FontName/" $fontXMLSnippet || exit 1
        cat $fontXMLSnippet >> $AllFontsXML
        echo "$FontName complete and copied to AllFontsXML. Finding next font..." || exit 1
    done
    
echo "Copying AllFontsXML to configuration profile"
sed -e '/<array>/ r '"$AllFontsXML" "$configurationProfileTemplateFile" > "$configurationProfileFile" || exit 1

echo "Setting profile display name"
sed -i'' -e "s/profilename/$configurationProfileName/" $configurationProfileFile || exit 1

echo "Setting profile identifier"
sed -i'' -e "s/profileidentifier/$ProfileIdentifier/" $configurationProfileFile || exit 1

echo "Setting profile UUID"
sed -i'' -e "s/profilepayloaduuid/${ProfileUUID}/" $configurationProfileFile || exit 1

echo "Cleaning up files"
rm $AllFontsXML
rm -R $parent_path/Base64Fonts
rm $parent_path/*.mobileconfig-e
mkdir $parent_path/CompletedFontProfile
mv $configurationProfileFile $parent_path/CompletedFontProfile/


echo "$configurationProfileFile complete" || exit 1