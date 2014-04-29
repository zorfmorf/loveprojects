DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
rm *.love
cd client
zip -r ../solaris.love *
cd ..
zip -r solaris.love core
