#!/bin/sh
RC_HOME=`pwd`
cd ..
for TARGET in zshrc screenrc;
do
   if [ -e ".$TARGET" ]; then
      mv ".$TARGET" ".$TARGET.old"
   fi
   ln -s "$RC_HOME/$TARGET" ".$TARGET"
done
if [[ "$SHELL" != "*/zsh" ]]
then
   echo "Please change your shell to /bin/zsh."
   chsh
fi
