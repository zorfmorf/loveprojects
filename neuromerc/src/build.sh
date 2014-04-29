DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NAME="neuromerc"
cd $DIR
rm *.love
cd client
zip -r ../$NAME.love *
cd ..
zip -r $NAME.love core
love $NAME.love
