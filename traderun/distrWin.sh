DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR 
if [ ! -f distr ]
then
    mkdir distr
fi
cd distr
rm traderun_x64.zip
rm traderun_x86.zip
if [ ! -f love-0.8.0-win-x64.zip ]
then
    wget https://bitbucket.org/rude/love/downloads/love-0.8.0-win-x64.zip
    wget https://bitbucket.org/rude/love/downloads/love-0.8.0-win-x86.zip
fi
unzip -j "*64.zip" -d x64
unzip -j "*86.zip" -d x86
cat x64/love.exe ../Client.love > x64/traderun.exe
cat x86/love.exe ../Client.love > x86/traderun.exe
zip -r traderun_x64 x64/*
zip -r traderun_x86 x86/*
rm -rf x86
rm -rf x64
