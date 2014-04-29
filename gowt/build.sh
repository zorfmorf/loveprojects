DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
rm *.love
cd Client
zip -r ../Client.love *
cd ..
love Client
