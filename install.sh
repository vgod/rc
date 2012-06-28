#!/bin/sh
RC_HOME=`pwd`
cd ..
for TARGET in zshrc zsh screenrc;
do
   if [ -e ".$TARGET" ]; then
      mv ".$TARGET" ".$TARGET.old"
   fi
   ln -s "$RC_HOME/$TARGET" ".$TARGET"
done

