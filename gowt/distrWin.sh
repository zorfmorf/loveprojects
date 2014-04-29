DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR 
rm -rf distr
mkdir distr
cd distr
wget https://bitbucket.org/rude/love/downloads/love-0.8.0-win-x64.zip
wget https://bitbucket.org/rude/love/downloads/love-0.8.0-win-x86.zip
unzip -j "*64.zip" -d x64
unzip -j "*86.zip" -d x86
rm *.zip
cat x64/love.exe ../Client.love > x64/Gowt.exe
cat x86/love.exe ../Client.love > x86/Gowt.exe
