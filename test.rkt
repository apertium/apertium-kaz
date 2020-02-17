#lang racket

(require rackunit
         apertium-kaz)

(check-equal?
 (kaz-morph "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
 "^Еуровидение/Еуровидение<np><al><nom>/Еуровидение<np><al><nom>+е<cop><aor><p3><pl>/Еуровидение<np><al><nom>+е<cop><aor><p3><sg>$ ^2010/2010<num>/2010<num><ord>/2010<num><subst><nom>$ ^ән/ән<n><nom>/ән<n><attr>/ән<n><nom>+е<cop><aor><p3><pl>/ән<n><nom>+е<cop><aor><p3><sg>$ ^конкурсы/конкурс<n><px3sp><nom>/конкурс<n><px3sp><nom>+е<cop><aor><p3><pl>/конкурс<n><px3sp><nom>+е<cop><aor><p3><sg>$ ^Еуровидениенің/Еуровидение<np><al><gen>$ ^55-ші/55<num><ord>/55<num><ord><subst><nom>$ ^конкурсы/конкурс<n><px3sp><nom>/конкурс<n><px3sp><nom>+е<cop><aor><p3><pl>/конкурс<n><px3sp><nom>+е<cop><aor><p3><sg>$ ^болады/бол<vaux><aor><p3><pl>/бол<vaux><aor><p3><sg>/бол<v><iv><aor><p3><pl>/бол<v><iv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-tagger-deterministic "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
 "^Еуровидение/Еуровидение<np><al><nom>$ ^2010/2010<num><ord>$ ^ән/ән<n><nom>$ ^конкурсы/конкурс<n><px3sp><nom>$ ^Еуровидениенің/Еуровидение<np><al><gen>$ ^55-ші/55<num><ord>$ ^конкурсы/конкурс<n><px3sp><nom>$ ^болады/бол<v><iv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-disam "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
  "^Еуровидение/Еуровидение<np><al><nom><#1->4><@nmod:poss>$^2010/2010<num><ord><#2->4><@amod>$^ән/ән<n><nom><#3->4><@nmod:poss>$^конкурсы/конкурс<n><px3sp><nom><#4->7><@nsubj>$^Еуровидениенің/Еуровидение<np><al><gen><#5->7><@nmod:poss>$^55-ші/55<num><ord><#6->7><@amod>$^конкурсы/конкурс<n><px3sp><nom><#7->0><@root>$^болады/бол<v><iv><aor><p3><sg><#8->7><@cop>$^./.<sent><#9->7><@punct>$")


(check-equal?
 (kaz-morph "Қой, қазақ бұлармен не ғып соғыса алсын?")
 "^Қой/ғой<mod_ass>/қой<n><nom>/қой<n><attr>/қой<vaux><imp><p2><sg>/қой<v><tv><imp><p2><sg>/қой<n><nom>+е<cop><aor><p3><pl>/қой<n><nom>+е<cop><aor><p3><sg>$^,/,<cm>$ ^қазақ/қазақ<n><nom>/қазақ<n><attr>/қазақ<n><nom>+е<cop><aor><p3><pl>/қазақ<n><nom>+е<cop><aor><p3><sg>$ ^бұлармен/бұл<prn><dem><pl><ins>$ ^не/не<cnjcoo>/не<prn><itg><nom>/не<prn><itg><nom>+е<cop><aor><p3><pl>/не<prn><itg><nom>+е<cop><aor><p3><sg>$ ^ғып/қыл<v><tv><gna_perf>/қыл<v><tv><prc_perf>$ ^соғыса/соқ<v><tv><coop><gna_impf>/соқ<v><tv><coop><prc_impf>/соқ<v><iv><coop><gna_impf>/соқ<v><iv><coop><prc_impf>/соғыс<v><iv><gna_impf>/соғыс<v><iv><prc_impf>$ ^алсын/ал<vaux><opt><p3><sg>/ал<vaux><opt><p3><pl>/ал<v><tv><opt><p3><sg>/ал<v><tv><opt><p3><pl>$^?/?<sent>$")

(check-equal?
 (kaz-tagger-deterministic "Қой, қазақ бұлармен не ғып соғыса алсын?")
 "^Қой/қой<v><tv><imp><p2><sg>$^,/,<cm>$ ^қазақ/қазақ<n><nom>$ ^бұлармен/бұл<prn><dem><pl><ins>$ ^не/не<prn><itg><nom>$ ^ғып/қыл<v><tv><gna_perf>$ ^соғыса/соғыс<v><iv><prc_impf>$ ^алсын/ал<vaux><opt><p3><sg>$^?/?<sent>$")

(check-equal?
 (kaz-disam "Қой, қазақ бұлармен не ғып соғыса алсын?")
 "^Қой/қой<v><tv><imp><p2><sg><#1->0><@root>$^,/,<cm><#2->1><@punct>$^қазақ/қазақ<n><nom><#3->7><@nsubj>$^бұлармен/бұл<prn><dem><pl><ins><#4->7><@obl>$^не/не<prn><itg><nom><#5->6><@obj>$^ғып/қыл<v><tv><gna_perf><#6->7><@advcl>$^соғыса/соғыс<v><iv><prc_impf><#7->1><@parataxis>$^алсын/ал<vaux><opt><p3><sg><#8->7><@aux>$^?/?<sent><#9->1><@punct>$")


(check-equal?
 (kaz-morph "Қазақстан осы өңірдегі бейбітшілікті қолдайды.")
 "^Қазақстан/Қазақстан<np><top><nom>/Қазақстан<np><top><attr>/Қазақстан<np><top><nom>+е<cop><aor><p3><pl>/Қазақстан<np><top><nom>+е<cop><aor><p3><sg>$ ^осы/осы<det><dem>/осы<prn><dem><nom>$ ^өңірдегі/өңір<n><loc><attr>/өңір<n><loc><subst><nom>/өңір<n><loc><subst><nom>+е<cop><aor><p3><pl>/өңір<n><loc><subst><nom>+е<cop><aor><p3><sg>$ ^бейбітшілікті/бейбітшілік<n><acc>/бейбітшілік<n>+лы<post>$ ^қолдайды/қол<n><sim><acc>/қол<adj><subst><sim><acc>/қолда<v><tv><aor><p3><pl>/қолда<v><tv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-tagger-deterministic "Қазақстан осы өңірдегі бейбітшілікті қолдайды.")
 "^Қазақстан/Қазақстан<np><top><nom>$ ^осы/осы<det><dem>$ ^өңірдегі/өңір<n><loc><attr>$ ^бейбітшілікті/бейбітшілік<n><acc>$ ^қолдайды/қолда<v><tv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-disam "Қазақстан осы өңірдегі бейбітшілікті қолдайды.")
 "^Қазақстан/Қазақстан<np><top><nom><#1->5><@nsubj>$^осы/осы<det><dem><#2->3><@det>$^өңірдегі/өңір<n><loc><attr><#3->4><@amod>$^бейбітшілікті/бейбітшілік<n><acc><#4->5><@obj>$^қолдайды/қолда<v><tv><aor><p3><sg><#5->0><@root>$^./.<sent><#6->5><@punct>$")
