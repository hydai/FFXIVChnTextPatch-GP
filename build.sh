# Set the envs
source ~/.zshrc
# Build the normal one
gradle clean
gradle build
gradle packageMacApp
# Backup the output
cp -r ./build/FFXIVChnTextPatch-GP_unspecified.dmg ./FFXIVChnTextPatch-GP-AppleSilicon.dmg
