DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR 
mkdir distr
cd distr
rm solaris*
if [ ! -f love-0.9.0-win64.zip ]
then
    wget https://bitbucket.org/rude/love/downloads/love-0.9.0-win64.zip
    wget https://bitbucket.org/rude/love/downloads/love-0.9.0-win32.zip
fi
unzip -j "*win64.zip" -d x64
unzip -j "*win32.zip" -d x32
cat x64/love.exe ../solaris.love > x64/solaris.exe
cat x32/love.exe ../solaris.love > x32/solaris.exe
rm x64/love.exe
rm x32/love.exe
zip -r solaris x64/*
zip -r solaris x32/*
rm -rf x32
rm -rf x64
