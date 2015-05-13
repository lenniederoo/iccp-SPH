#!/bin/bash
 
echo "Simulating the fluid"

./main

echo "Moving all .dat files to Data folder"
mv ./*.dat ./Data

echo "Rendering all images, please wait"

n=0

while [ $n -le 100 ]
do
	((n++))
	#rm ./00001.dat
	#mv Data/0000$n.dat ./00001.dat
	filename=0000'$n'.dat
	echo "Filename is: $filename"
	if [ $n -le 9 ]; then
		sed -i 's/00001.dat/0000'$n'.dat/g' ./1foto.pov
	elif [ $n -le 99 ]; then
		sed -i 's/00001.dat/000'$n'.dat/g' ./1foto.pov
	elif [ $n -le 999 ]; then
		sed -i 's/00001.dat/00'$n'.dat/g' ./1foto.pov
	fi
	povray 1foto.pov
	echo "Rendering file $n"
	if [ $n -le 9 ]; then
		mv 1foto.png ./Images/foto00$n.png
		sed -i 's/0000'$n'.dat/00001.dat/g' ./1foto.pov
	elif [ $n -le 99 ]; then
		mv 1foto.png ./Images/foto0$n.png
		sed -i 's/000'$n'.dat/00001.dat/g' ./1foto.pov
	elif [ $n -le 999 ]; then
		mv 1foto.png ./Images/foto$n.png
		sed -i 's/00'$n'.dat/00001.dat/g' ./1foto.pov
	fi
	
done

echo "Image rendering done"
echo "Video creation"

cd ./Images
ffmpeg -i foto%03d.png video.mpg
cd ..

echo "Video created"

