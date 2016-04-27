#!/bin/bash

dotfiles=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
for dotfile in $(find "$dotfiles" -maxdepth 1 -name ".*" ! -name '.git')
do
    file=$(basename $dotfile)
    if [[ -f $HOME/$file || -d $HOME/$file ]]
    then
	if [ -L $HOME/$file ]
	then
	    echo "link already exists - $HOME/$file > $(readlink $HOME/$file)"
	    continue
	else
	    echo "file already exists - $dotfile"
	    read -p "Do you want to overwrite it? " -n 1 -r overwrite
	    echo
	    if [[ "x$overwrite" =~ x[yY] ]]
	    then
		echo "moving $file to $file.bak"
		mv $HOME/$file $HOME/$file.bak
	    else
		continue
	    fi
	fi
    fi
    echo "linking $HOME/$file to $dotfile"
    ln -s $dotfile $HOME/$file
done
