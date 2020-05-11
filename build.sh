#!/bin/bash

if [ -z $1 ]; then
    echo "Usage: $0 aspx"
    exit
fi

EXT=$1
OUTPUT="discovery.${EXT}.txt"
SLWEB="../SecLists/Discovery/Web-Content/"

declare -a lists=("quickhits.txt" 
                "RobotsDisallowed-Top1000.txt"
                "swagger.txt"
                "ApacheTomcat.fuzz.txt"
                "tomcat.txt"
                "Logins.fuzz.txt"
                "nginx.txt"
                "ror.txt"
                "jboss.txt"
                "websphere.txt"
                "weblogic.txt"
                "JavaServlets-Common.fuzz.txt"
                "axis.txt"
                "IIS.fuzz.txt"
                "oracle.txt"
                "Oracle9i.fuzz.txt"
                "tests.txt"
                "apache.txt"
                "spring-boot.txt"
                "CommonBackdoors-ASP.fuzz.txt"
                "CommonBackdoors-JSP.fuzz.txt"
                "Jenkins-Hudson.txt"
                "iplanet.txt"
                "SuniPlanet.fuzz.txt"
                "frontpage.txt"
                "Frontpage.fuzz.txt"
                "AdobeCQ-AEM.txt"
                "AdobeXML.fuzz.txt"
                "netware.txt"
                "CGI-Microsoft.fuzz.txt"
                "confluence-administration.txt"
                "domino-dirs-coldfusion39.txt"
                "Common-PHP-Filenames.txt"
                "Randomfiles.fuzz.txt"
                "golang.txt"
                "Web-Services/SOAP-functions.txt"
                "FatwireCMS.fuzz.txt"
                "burp-parameter-names.txt"
                "KitchensinkDirectories.fuzz.txt"
                "common-api-endpoints-mazen160.txt"
                "fnf-fuzz.txt"
                "hpsmh.txt"
                "hyperion.txt"
                "Hyperion.fuzz.txt"
                "JavaServlets-Common.fuzz.txt"
                "JRun.fuzz.txt"
                "common.txt"
                "common-and-dutch.txt"
                "common-and-french.txt"
                "common-and-italian.txt"
                "common-and-portugese.txt"
                "common-and-spanish.txt"
)

echo "" > $OUTPUT
for i in "${lists[@]}"; do
    echo "$i"
    cat "$SLWEB/$i" >> $OUTPUT
done


if [ ! -f dicc.txt ]; then
    wget https://raw.githubusercontent.com/maurosoria/dirsearch/master/db/dicc.txt
fi
echo "dicc.txt"
cat dicc.txt >> $OUTPUT

if [ ! -f common.txt ]; then
    wget https://raw.githubusercontent.com/v0re/dirb/master/wordlists/common.txt
fi
echo "common.txt"
cat common.txt >> $OUTPUT


if [ ! -f small.txt ]; then
    wget https://raw.githubusercontent.com/v0re/dirb/master/wordlists/small.txt
fi
echo "small.txt"
cat small.txt >> $OUTPUT

cat nmap.txt >> $OUTPUT

# Custom
cat ztg.txt >> $OUTPUT

# Cleanup empty lines, comments, and asterisks
sed -i '/^$/d' $OUTPUT
sed -i '/^#/d' $OUTPUT
sed -i 's/^*//g' $OUTPUT
sed -i 's/^\*//' $OUTPUT
sed -i 's/\*$//g' $OUTPUT

# Normalize lines by removing the leading /
sed -i 's/^\///' $OUTPUT

# Replace %EXT% with $EXT
sed -i "s/%EXT%/$EXT/" $OUTPUT

# remove ' -> ' from wordlist
sed -i 's/ -> .*$//g' $OUTPUT

# URL encode spaces
sed -i 's/ /%20/g' $OUTPUT

# Remove entries that are only querystrings
sed -i '/^?.*$/d' $OUTPUT

# Remove tilde entries
sed -i '/^~.*$/d' $OUTPUT

# convert to unix format
dos2unix $OUTPUT

# unique files
wc -l $OUTPUT
#awk '!x[$0]++' $OUTPUT > tmp
sort -u $OUTPUT > tmp
mv tmp $OUTPUT
wc -l $OUTPUT

sed -i '/^\*/d' $OUTPUT # No fucking clue why it works here and not above ¯\_(ツ)_/¯
