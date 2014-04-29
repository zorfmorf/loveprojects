REM As you can see this build script depends on 7zip being installed
REM in the default directory
del rm client.love
cd Client
del rm client.love
C:\Programme\7-Zip\7z.exe a -r client.zip *
mv client.zip ../client.love
cd ..
