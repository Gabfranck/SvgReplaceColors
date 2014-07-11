#!/bin/bash
#Copyright 2014 Gabriel Franck. All Right Reserved.

#init fichier source
for last; do true; done

if [ $# = 0 ]
then
		echo "-----------------------------DOC------------------------------"
		echo "\$last : the file or folder"
		echo "\$2 : color in the file you want replace"
		echo "\$3 : replacement color of the previous parameters"
		echo "\$4 & \$5 : another couple for color replacement"
		echo "You can repeat the previous step as many times as you want"

elif [ -f $last ]
then
		#test pour voir si couple (couleur/remplacement)
		let "k = $# % 2"

		if [ $# = 1 ]
		then
				echo "Colors in the file : "
				#grep search color (à faire)

		elif [ $k = 1 ]
		then
				#premiere passe pour création du fichier _new
				sed "s/style=\"fill:\#${1};\"/style=\"fill:\#${2};\"/g" $last > ${last%.*}_new.svg
				shift 2

				#pour ignorer le fichier source
				let "x = $# - 1"

				#les autre passe où j'édite le fichier créer
				for ((i=0;i<x;i=i+2))
				do
						sed -i "s/style=\"fill:\#${1};\"/style=\"fill:\#${2};\"/g" ${last%.*}_new.svg
						shift 2
				done
		else
				#message d'erreur
				echo "Make couple of color in \$2 and \$3"
		fi
else
		#message d'erreur
		echo "Enter a file in \$last"
fi
