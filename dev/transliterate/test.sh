#!/bin/bash

echo "تاقتايشا" | hfst-proc ara-kaz.ohfst
# should be тақтайша

echo "ايىرماسى" | hfst-proc ara-kaz.ohfst
# should be айырмасы

echo "زەكي" | hfst-proc ara-kaz.ohfst
# should be зеки

echo "قيناپ" | hfst-proc ara-kaz.ohfst
# should be қинап

echo "كوپ" | hfst-proc ara-kaz.ohfst
# should be көп

echo "سولتۇستىك" | hfst-proc ara-kaz.ohfst
# should be солтүстік

echo "تەرموس" | hfst-proc ara-kaz.ohfst
# should be термос

echo "ۇيا" | hfst-proc ara-kaz.ohfst
# should be ұя

