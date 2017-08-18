#!/bin/bash
RC_HOME=`pwd`
cd ..
for TARGET in zshrc screenrc psqlrc tmux.conf agignore;
do
   if [ -e ".$TARGET" ] && [ ! -L ".$TARGET" ]; then
      mv ".$TARGET" ".$TARGET.old"
      echo
   fi
   if [ ! -L ".$TARGET" ]; then
      ln -s "$RC_HOME/$TARGET" ".$TARGET"
   fi
done
if [[ "$SHELL" =~ .*/zsh ]]
then
   echo "Good. You are using $SHELL. No need to chsh." 
else
   echo "Please change your shell to `which zsh`"
   chsh
fi

cd $RC_HOME
git submodule update --init
