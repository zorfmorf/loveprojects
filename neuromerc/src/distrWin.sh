DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NAME="neuromerc"
cd $DIR 
mkdir distr
cd distr
rm $NAME*
if [ ! -f love-0.9.0-win64.zip ]
then
    wget https://bitbucket.org/rude/love/downloads/love-0.9.0-win64.zip
    wget https://bitbucket.org/rude/love/downloads/love-0.9.0-win32.zip
fi
unzip -j "*win64.zip" -d x64
unzip -j "*win32.zip" -d x32
cat x64/love.exe ../$NAME.love > x64/$NAME.exe
cat x32/love.exe ../$NAME.love > x32/$NAME.exe
rm x64/love.exe
rm x32/love.exe
zip -r $NAME x64/*
zip -r $NAME x32/*
rm -rf x32
rm -rf x64
