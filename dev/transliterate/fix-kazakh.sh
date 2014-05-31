X=0; 

echo "SECTION

SELECT (x) ;
" > /tmp/cg4

cg-comp /tmp/cg4 /tmp/cg4.bin

for i in `cat /tmp/uig-kaz`; do 
	U=`echo $i | cut -f1 -d':'`; 
	K=`echo $i | cut -f2 -d':'`; 
	X=`expr $X + 1`; 
	C=`echo $i | sh test-compose-intersect.sh`; 
	
	if [[ $C = "" ]]; then 
		echo "" >> /tmp/kaz-kaz2; 
	else 
		echo $C >> /tmp/kaz-kaz2; 
	fi; 
	
	echo -e $U"\t"$K"\t"$X" "$C; done
done

cat /tmp/kaz-kaz2 | cut -f2 -d':' | lt-proc ~/source/apertium/languages/apertium-kaz/kaz.automorf.bin  > /tmp/kaz-ana
paste /tmp/uig-kaz /tmp/kaz-kaz2 /tmp/kaz-ana > /tmp/uig-kaz-kaz

cat /tmp/uig-kaz-kaz | grep '<n><nom>' | grep -v '<v>' | sed 's/+е<cop>\(<[a-zA-Z0-9]\+>\)\+//g' | cg-proc /tmp/cg4.bin
