#!/bin/bash
#Copyright 2014 Gabriel Franck. All Right Reserved.


read -p	'Entrez un ficher svg ou un répertoire en contenant :' svgFiles
read -p 'couleur de remplacement :' color

if [ -f $svgFiles ]; then
	sed "s/\(fill\:#[0-9a-fA-F][0-9a-fA-F]*;\)/\(fill\:$color;\)/g" $svgFiles
fi
