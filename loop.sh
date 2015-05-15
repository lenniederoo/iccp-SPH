#!/bin/bash
 
echo "Simulating the fluid"

#./main

echo "Moving all .dat files to Data folder"
#mv ./*.dat ./Data

echo "Rendering all images, please wait"

n=0
m=0

while [ $n -le 1498 ]
do
	((n++))
	((n++))
	((m++))
	
	#rm ./00001.dat
	#mv Data/0000$n.dat ./00001.dat
	filename=0000'$n'.dat
	echo "Filename is: $filename"
	if [ $n -le 9 ]; then
		sed -i 's/00001.dat/0000'$n'.dat/g' ./2foto.pov
	elif [ $n -le 99 ]; then
		sed -i 's/00001.dat/000'$n'.dat/g' ./2foto.pov
	elif [ $n -le 999 ]; then
		sed -i 's/00001.dat/00'$n'.dat/g' ./2foto.pov
	elif [ $n -le 9999 ]; then
		sed -i 's/00001.dat/0'$n'.dat/g' ./2foto.pov
	fi
	
	povray -H480 -W640 2foto.pov 
	echo "Rendering file $n"
	if [ $n -le 9 ]; then
		mv 2foto.png ./Images/foto000$m.png
		sed -i 's/0000'$n'.dat/00001.dat/g' ./2foto.pov
	elif [ $n -le 99 ]; then
		mv 2foto.png ./Images/foto00$m.png
		sed -i 's/000'$n'.dat/00001.dat/g' ./2foto.pov
	elif [ $n -le 999 ]; then
		mv 2foto.png ./Images/foto0$m.png
		sed -i 's/00'$n'.dat/00001.dat/g' ./2foto.pov
	elif [ $n -le 9999 ]; then
		mv 2foto.png ./Images/foto$m.png
		sed -i 's/0'$n'.dat/00001.dat/g' ./2foto.pov
	fi
	
done

echo "Image rendering done"
echo "Video creation"

cd ./Images
ffmpeg -f image2 -i foto%04d.png -vcodec libx264 -b 800k video.avi
#ffmpeg -i foto%03d.png video.mpg
cd ..

echo "Video created"

