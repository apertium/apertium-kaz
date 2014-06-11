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
	
	echo -e $U"\t"$K"\t"$X" "$C;
done

cat /tmp/kaz-kaz2 | cut -f2 -d':' | lt-proc ~/source/apertium/languages/apertium-kaz/kaz.automorf.bin  > /tmp/kaz-ana
paste /tmp/uig-kaz /tmp/kaz-kaz2 /tmp/kaz-ana > /tmp/uig-kaz-kaz

cat /tmp/uig-kaz-kaz | grep '<n><nom>' | grep -v '<v>' | sed 's/+е<cop>\(<[a-zA-Z0-9]\+>\)\+//g' | cg-proc /tmp/cg4.bin

cat /tmp/uig-kaz-kaz | grep '<n><nom>' | grep -v '<v>' | sed 's/+е<cop>\(<[a-zA-Z0-9]\+>\)\+//g' | cg-proc /tmp/cg4.bin | grep -v '\-'   | cut -f1,3  | tr '\t' ':' | cut -f1,3 -d':' | awk -F':' '{print $2":"$1}' | sed 's/^/<e><p><l>/g' | sed 's/$/<s n="n"\/><\/r><\/p><\/e>/g' | sed 's/:/<s n="n"\/><\/l><r>/g' | sed s'/^/    /g' > /tmp/uig-kaz.xml

#    <e><p><l>түнек<s n="n"/></l><r>قاراڭغۇلۇق<s n="n"/></r></p></e>
#    <e><p><l>жорамал<s n="n"/></l><r>چامىلىماق<s n="n"/></r></p></e>

for i in `cat /tmp/uig-kaz-kaz | grep '<v>\(<iv>\|<tv>\)\(<pass>\|<caus>\)*<ger><nom>' | sed 's/<ger><nom>//g' | cg-proc /tmp/cg.bin | grep 'م[اە][قك]' | sed 's/:/\t/g' | cut -f1,5 | sed 's/م[اە][قك]\t/\t/g' | sed 's/\//\t/g' | cut -f1,3  | cut -f1 -d'$'  | sed 's/\t/:/g'`; do U=`echo $i | cut -f1 -d':'`; K=`echo $i | cut -f2 -d':'`; for j in `echo $K | sed 's/\//\n/g'`; do echo $U":"$j; done; done > /tmp/OP

cat /tmp/OPO | rev | sort | rev | grep -v '\(<post>\|<pass>\|<caus>\|<coop>\)' | sed 's/</\t</1' | sed 's/:/\t/g' | awk '{print $2"\t"$3"\t"$1"\t"$3}' | sed 's/\t/:/g' | sed 's/:</</g' | sed 's/:/\t/g' | sh ~/scripts/tag-to-sym.sh  | sed 's/^/    <e><p><l>/g' | sed 's/$/<\/r><\/p><\/e>/g' | sed 's/\t/<\/l><r>/g' > /tmp/verbs.xml

cat /tmp/OPO | rev | sort | rev | grep -v '\(<post>\|<pass>\|<caus>\|<coop>\)' | sed 's/</\t</1' | sed 's/:/\t/g' | awk '{print $2"\t"$3"\t"$1"\t"$3}' | sed 's/\t/:/g' | sed 's/:</</g' | sed 's/:/\t/g'  | grep '<vaux>' | cut -f2  | cut -f1 -d'<' | pasten.py 2 | sed 's/\t/:/g' | sed 's/:$/ V-AUX ; ! ""/g'


cat /tmp/OPO | rev | sort | rev | grep -v '\(<post>\|<pass>\|<caus>\|<coop>\)' | sed 's/</\t</1' | sed 's/:/\t/g' | awk '{print $2"\t"$3"\t"$1"\t"$3}' | sed 's/\t/:/g' | sed 's/:</</g' | sed 's/:/\t/g'  | grep '<tv>' | cut -f2  | cut -f1 -d'<' | pasten.py 2 | sed 's/\t/:/g' | sed 's/:$/ V-IV ; ! ""/g'

1for i in `cat /tmp/uig-kaz-kaz | grep '<v>\(<iv>\|<tv>\)\(<pass>\|<caus>\)*<ger><nom>' | sed 's/<ger><nom>//g' | cg-proc /tmp/cg.bin | grep 'م[اە][قك]' | sed 's/:/\t/g' | cut -f1,5 | sed 's/م[اە][قك]\t/\t/g' | sed 's/\//\t/g' | cut -f1,3  | cut -f1 -d'$'  | sed 's/\t/:/g'`; do U=`echo $i | cut -f1 -d':'`; K=`echo $i | cut -f2 -d':'`; for j in `echo $K | sed 's/\//\n/g'`; do echo $U":"$j; done; done > /tmp/OP

cat /tmp/OPO | rev | sort | rev | grep -v '\(<post>\|<pass>\|<caus>\|<coop>\)' | sed 's/</\t</1' | sed 's/:/\t/g' | awk '{print $2"\t"$3"\t"$1"\t"$3}' | sed 's/\t/:/g' | sed 's/:</</g' | sed 's/:/\t/g' | sh ~/scripts/tag-to-sym.sh  | sed 's/^/    <e><p><l>/g' | sed 's/$/<\/r><\/p><\/e>/g' | sed 's/\t/<\/l><r>/g' > /tmp/verbs.xml

cat /tmp/OPO | rev | sort | rev | grep -v '\(<post>\|<pass>\|<caus>\|<coop>\)' | sed 's/</\t</1' | sed 's/:/\t/g' | awk '{print $2"\t"$3"\t"$1"\t"$3}' | sed 's/\t/:/g' | sed 's/:</</g' | sed 's/:/\t/g'  | grep '<vaux>' | cut -f2  | cut -f1 -d'<' | pasten.py 2 | sed 's/\t/:/g' | sed 's/:$/ V-AUX ; ! ""/g'

cat /tmp/OPO | rev | sort | rev | grep -v '\(<post>\|<pass>\|<caus>\|<coop>\)' | sed 's/</\t</1' | sed 's/:/\t/g' | awk '{print $2"\t"$3"\t"$1"\t"$3}' | sed 's/\t/:/g' | sed 's/:</</g' | sed 's/:/\t/g'  | grep '<tv>' | cut -f2  | cut -f1 -d'<' | pasten.py 2 | sed 's/\t/:/g' | sed 's/:$/ V-TV ; ! ""/g'


