# Prepare 4k font
mkdir -p 4k
cd 4k
wget https://github.com/GpointChen/FFXIVChnTextPatch-GP/releases/download/v3.0.1/font-custom-4k-smaller-20230131.rar
unrar x font-custom-4k-smaller-20230131.rar
cd ..
# Set the envs
source ~/.zshrc
# Backup the origin font
cp -r ./resource/font ./font-bk
# Overwrite the font with 4k version
cp ./4k/font/* ./resource/font
rm -rf ./4k
# Build the normal one
gradle clean
gradle build
gradle packageMacApp
# Backup the output
cp -r ./build/FFXIVChnTextPatch-GP_unspecified.dmg ./FFXIVChnTextPatch-GP-4k-AppleSilicon.dmg
# Clean up and restore font
rm -rf ./resource/font
cp -r ./font-bk ./resource/font
rm -rf ./font-bk
