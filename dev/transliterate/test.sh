#!/bin/bash

echo "تاقتايشا" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be тақтайша

echo "ايىرماسى" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be айырмасы

echo "زەكي" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be зеки

echo "قيناپ" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be қинап

echo "كوپ" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be көп

echo "سولتۇستىك" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be солтүстік

echo "تەرموس" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be термос

echo "ۇيا" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be ұя

echo "مويناق" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 

echo "كيىم" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
#should be киім
echo "كيۋ" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
#should be кию
echo "كيىنىس" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
#should be киініс

echo "قويۋ" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be қою

echo "توركىن" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# hrrm

echo "سۇرتكى" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be сүрткі

echo "رايون" | hfst-strings2fst  | hfst-compose-intersect -2 ara-kaz.hfst  | hfst-fst2strings 
# should be район
