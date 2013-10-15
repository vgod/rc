#!/bin/bash
RC_HOME=`pwd`
cd ..
for TARGET in zshrc screenrc psqlrc tmux.conf;
do
   if [ -e ".$TARGET" ]; then
      mv ".$TARGET" ".$TARGET.old"
      echo
   fi
   ln -s "$RC_HOME/$TARGET" ".$TARGET"
done
if [[ "$SHELL" =~ .*/zsh ]]
then
   echo "Good. You are using $SHELL. No need to chsh." 
else
   echo "Please change your shell to `which zsh`"
   chsh
fi

git submodule update --init
