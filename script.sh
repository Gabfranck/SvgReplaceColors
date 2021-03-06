#!/bin/bash
#Copyright 2014 Gabriel Franck. All Right Reserved.

#init fichier source
for last; do true; done

let "y = $# - 1"

for ((j=0;j<y;j++))
do
	color[j]=${1}
	shift
done

if [ $# = 0 ]
then
		echo "-----------------------------DOC------------------------------"
		echo "\$last : a svg file or a folder with svgs inside"
		echo "\$1 : color in the file you want replace"
		echo "\$2 : replacement color of the previous parameters"
		echo "\$3 & \$4 : another couple for color replacement"
		echo "You can repeat the previous step as many times as you want"

elif [ -f $last ]
then
		#test pour voir si couple (couleur/remplacement)
		let "k = ${#color[@]} % 2"

		if [ ${#color[@]} = 0 ]
		then
				echo "Colors in the file ${last} :"
				cat $last | grep "fill:#......" | sed -e 's/fill:#\(......\).*/\1/' | sort -u

		elif [ $k = 0 ]
		then
				#premiere passe pour création du fichier _new
				sed "s/fill:\#${color[0]}/fill:\#${color[1]}/g" $last > ${last%.*}_new.svg

				#les autres passes où j'édite le fichier créé
				for ((i=2;i<y;i=i+2))
				do
						let "v = $i + 1"
						sed -i.bak "s/fill:\#${color[$i]}/fill:\#${color[$v]}/g" ${last%.*}_new.svg
				done
		else
				#message d'erreur
				echo "Make couple of color in \$1 and \$2"
		fi

		rm *.bak

elif [ -d $last ]
then
		directory="${last}/newSvgs${color[1]}-${color[3]}"
		mkdir "$directory"

		find $last -type f -maxdepth 1 -iname '*.svg' | while read FILE; do
		#echapement espace
		a=`echo ${FILE} | sed -e 's/ //g'`
		mv "${FILE}" "$a"
		done

		find $last -type f -maxdepth 1 -iname '*.svg' | while read FILE; do

				#test pour voir si couple (couleur/remplacement)
				let "k = ${#color[@]} % 2"

				if [ ${#color[@]} = 0 ]
				then

						echo "Colors in the file ${FILE} :"
						cat ${FILE} | grep "fill:#......" | sed -e 's/fill:#\(......\).*/\1/' | sort -u

				elif [ $k = 0 ]
				then
						#premiere passe pour création du fichier _new
						realName=$(basename ${FILE})
						sed "s/fill:\#${color[0]}/fill:\#${color[1]}/g" ${FILE} > $directory/${realName%.*}_new.svg

						#les autres passes où j'édite le fichier créé
						for ((i=0;i<y;i=i+2))
						do
								let "v = $i + 1"
								sed -i.bak "s/fill:\#${color[$i]}/fill:\#${color[$v]}/g" $directory/${realName%.*}_new.svg
						done
				else
						#message d'erreur
						echo "Make couple of color in \$1 and \$2"
				fi
		done

		cd $directory
		rm *.bak

else
		#message d'erreur
		echo "Enter a file or a directory in \$last"
fi
