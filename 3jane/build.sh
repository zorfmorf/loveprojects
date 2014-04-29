DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
rm *.love
cd src
zip -r ../3jane.love *
cd ..
love 3jane.love
