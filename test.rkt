#lang racket

(require rackunit
         apertium-kaz)

#;(check-equal?
 (kaz-morph "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
 "^Еуровидение/Еуровидение<np><al><nom>/Еуровидение<np><al><nom>+е<cop><aor><p3><pl>/Еуровидение<np><al><nom>+е<cop><aor><p3><sg>$ ^2010/2010<num>/2010<num><ord>/2010<num><subst><nom>$ ^ән/ән<n><nom>/ән<n><attr>/ән<n><nom>+е<cop><aor><p3><pl>/ән<n><nom>+е<cop><aor><p3><sg>$ ^конкурсы/конкурс<n><px3sp><nom>/конкурс<n><px3sp><nom>+е<cop><aor><p3><pl>/конкурс<n><px3sp><nom>+е<cop><aor><p3><sg>$ ^Еуровидениенің/Еуровидение<np><al><gen>$ ^55-ші/55<num><ord>/55<num><ord><subst><nom>$ ^конкурсы/конкурс<n><px3sp><nom>/конкурс<n><px3sp><nom>+е<cop><aor><p3><pl>/конкурс<n><px3sp><nom>+е<cop><aor><p3><sg>$ ^болады/бол<vaux><aor><p3><pl>/бол<vaux><aor><p3><sg>/бол<v><iv><aor><p3><pl>/бол<v><iv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-tagger-deterministic "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
 "^Еуровидение/Еуровидение<np><al><nom>$ ^2010/2010<num><ord>$ ^ән/ән<n><nom>$ ^конкурсы/конкурс<n><px3sp><nom>$ ^Еуровидениенің/Еуровидение<np><al><gen>$ ^55-ші/55<num><ord>$ ^конкурсы/конкурс<n><px3sp><nom>$ ^болады/бол<v><iv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-disam "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
  "^Еуровидение/Еуровидение<np><al><nom><#1->4><@nmod:poss>$^2010/2010<num><ord><#2->4><@amod>$^ән/ән<n><nom><#3->4><@nmod:poss>$^конкурсы/конкурс<n><px3sp><nom><#4->7><@nsubj>$^Еуровидениенің/Еуровидение<np><al><gen><#5->7><@nmod:poss>$^55-ші/55<num><ord><#6->7><@amod>$^конкурсы/конкурс<n><px3sp><nom><#7->0><@root>$^болады/бол<v><iv><aor><p3><sg><#8->7><@cop>$^./.<sent><#9->7><@punct>$")


#;(check-equal?
 (kaz-morph "Қой, қазақ бұлармен не ғып соғыса алсын?")
 "^Қой/ғой<mod_ass>/қой<n><nom>/қой<n><attr>/қой<vaux><imp><p2><sg>/қой<v><tv><imp><p2><sg>/қой<n><nom>+е<cop><aor><p3><pl>/қой<n><nom>+е<cop><aor><p3><sg>$^,/,<cm>$ ^қазақ/қазақ<n><nom>/қазақ<n><attr>/қазақ<n><nom>+е<cop><aor><p3><pl>/қазақ<n><nom>+е<cop><aor><p3><sg>$ ^бұлармен/бұл<prn><dem><pl><ins>$ ^не/не<cnjcoo>/не<prn><itg><nom>/не<prn><itg><nom>+е<cop><aor><p3><pl>/не<prn><itg><nom>+е<cop><aor><p3><sg>$ ^ғып/қыл<v><tv><gna_perf>/қыл<v><tv><prc_perf>$ ^соғыса/соқ<v><tv><coop><gna_impf>/соқ<v><tv><coop><prc_impf>/соқ<v><iv><coop><gna_impf>/соқ<v><iv><coop><prc_impf>/соғыс<v><iv><gna_impf>/соғыс<v><iv><prc_impf>$ ^алсын/ал<vaux><opt><p3><sg>/ал<vaux><opt><p3><pl>/ал<v><tv><opt><p3><sg>/ал<v><tv><opt><p3><pl>$^?/?<sent>$")

(check-equal?
 (kaz-tagger-deterministic "Қой, қазақ бұлармен не ғып соғыса алсын?")
 "^Қой/қой<v><tv><imp><p2><sg>$^,/,<cm>$ ^қазақ/қазақ<n><nom>$ ^бұлармен/бұл<prn><dem><pl><ins>$ ^не/не<prn><itg><nom>$ ^ғып/қыл<v><tv><gna_perf>$ ^соғыса/соғыс<v><iv><prc_impf>$ ^алсын/ал<vaux><opt><p3><sg>$^?/?<sent>$")

(check-equal?
 (kaz-disam "Қой, қазақ бұлармен не ғып соғыса алсын?")
 "^Қой/қой<v><tv><imp><p2><sg><#1->0><@root>$^,/,<cm><#2->1><@punct>$^қазақ/қазақ<n><nom><#3->7><@nsubj>$^бұлармен/бұл<prn><dem><pl><ins><#4->7><@obl>$^не/не<prn><itg><nom><#5->6><@obj>$^ғып/қыл<v><tv><gna_perf><#6->7><@advcl>$^соғыса/соғыс<v><iv><prc_impf><#7->1><@parataxis>$^алсын/ал<vaux><opt><p3><sg><#8->7><@aux>$^?/?<sent><#9->1><@punct>$")


#;(check-equal?
 (kaz-morph "Қазақстан осы өңірдегі бейбітшілікті қолдайды.")
 "^Қазақстан/Қазақстан<np><top><nom>/Қазақстан<np><top><attr>/Қазақстан<np><top><nom>+е<cop><aor><p3><pl>/Қазақстан<np><top><nom>+е<cop><aor><p3><sg>$ ^осы/осы<det><dem>/осы<prn><dem><nom>$ ^өңірдегі/өңір<n><loc><attr>/өңір<n><loc><subst><nom>/өңір<n><loc><subst><nom>+е<cop><aor><p3><pl>/өңір<n><loc><subst><nom>+е<cop><aor><p3><sg>$ ^бейбітшілікті/бейбітшілік<n><acc>/бейбітшілік<n>+лы<post>$ ^қолдайды/қол<n><sim><acc>/қол<adj><subst><sim><acc>/қолда<v><tv><aor><p3><pl>/қолда<v><tv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-tagger-deterministic "Қазақстан осы өңірдегі бейбітшілікті қолдайды.")
 "^Қазақстан/Қазақстан<np><top><nom>$ ^осы/осы<det><dem>$ ^өңірдегі/өңір<n><loc><attr>$ ^бейбітшілікті/бейбітшілік<n><acc>$ ^қолдайды/қолда<v><tv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-disam "Қазақстан осы өңірдегі бейбітшілікті қолдайды.")
 "^Қазақстан/Қазақстан<np><top><nom><#1->5><@nsubj>$^осы/осы<det><dem><#2->3><@det>$^өңірдегі/өңір<n><loc><attr><#3->4><@amod>$^бейбітшілікті/бейбітшілік<n><acc><#4->5><@obj>$^қолдайды/қолда<v><tv><aor><p3><sg><#5->0><@root>$^./.<sent><#6->5><@punct>$")

#;(check-equal?
 (kaz-morph "Дмитрий Медведевтің Астанаға сапары 22 мамырға жоспарланып отыр.")
 "^Дмитрий/Дмитрий<np><ant><m><nom>/Дмитрий<np><ant><m><nom>+е<cop><aor><p3><pl>/Дмитрий<np><ant><m><nom>+е<cop><aor><p3><sg>$ ^Медведевтің/Медведев<np><cog><m><gen>$ ^Астанаға/астана<n><dat>/Астана<np><top><dat>$ ^сапары/сапар<n><px3sp><nom>/сапар<n><px3sp><nom>+е<cop><aor><p3><pl>/сапар<n><px3sp><nom>+е<cop><aor><p3><sg>$ ^22/22<num>/22<num><ord>/22<num><subst><nom>$ ^мамырға/мамыр<n><dat>$ ^жоспарланып/жоспарла<v><tv><pass><gna_perf>/жоспарла<v><tv><pass><prc_perf>/жоспарлан<v><iv><gna_perf>/жоспарлан<v><iv><prc_perf>$ ^отыр/отыр<vaux><imp><p2><sg>/отыр<vaux><pres><p3><pl>/отыр<vaux><pres><p3><sg>/отыр<v><iv><imp><p2><sg>$^./.<sent>$") ;; whether to lexicalise жоспарлан is an open question, IFS probably wouldn't have

(check-equal?
 (kaz-tagger-deterministic "Дмитрий Медведевтің Астанаға сапары 22 мамырға жоспарланып отыр.")
 "^Дмитрий/Дмитрий<np><ant><m><nom>$ ^Медведевтің/Медведев<np><cog><m><gen>$ ^Астанаға/Астана<np><top><dat>$ ^сапары/сапар<n><px3sp><nom>$ ^22/22<num><ord>$ ^мамырға/мамыр<n><dat>$ ^жоспарланып/жоспарла<v><tv><pass><prc_perf>$ ^отыр/отыр<vaux><pres><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-disam "Дмитрий Медведевтің Астанаға сапары 22 мамырға жоспарланып отыр.")
 "^Дмитрий/Дмитрий<np><ant><m><nom><#1->4><@nmod:poss>$^Медведевтің/Медведев<np><cog><m><gen><#2->4><@nmod:poss>$^Астанаға/Астана<np><top><dat><#3->8><@obl>$^сапары/сапар<n><px3sp><nom><#4->8><@nsubj>$^22/22<num><ord><#5->8><@amod>$^мамырға/мамыр<n><dat><#6->8><@obl>$^жоспарланып/жоспарла<v><tv><pass><prc_perf><#7->8>$^отыр/отыр<vaux><pres><p3><sg><#8->0><@root>$^./.<sent><#9->8><@punct>$") ;; TODO clarify with FMT and JNW or guidelines: 1. сапары nsubj 2. attachingастанаға to сапары (as nmod?)

#;(check-equal?
 (kaz-morph "Біздің елде сізге ерекше құрметпен қарайды.")
 "^Біздің/біз<prn><pers><p1><pl><gen>$ ^елде/ел<n><loc>/ел<n><loc>+е<cop><aor><p3><pl>/ел<n><loc>+е<cop><aor><p3><sg>$ ^сізге/сіз<prn><pers><p2><sg><frm><dat>$ ^ерекше/ерек<n><equ>/ерекше<adj>/ерекше<adj><advl>/ерекше<adj><subst><nom>/ерек<n><equ>+е<cop><aor><p3><pl>/ерек<n><equ>+е<cop><aor><p3><sg>/ерекше<adj>+е<cop><aor><p3><pl>/ерекше<adj>+е<cop><aor><p3><sg>/ерекше<adj><subst><nom>+е<cop><aor><p3><pl>/ерекше<adj><subst><nom>+е<cop><aor><p3><sg>$ ^құрметпен/құрмет<n><ins>$ ^қарайды/қара<v><tv><aor><p3><pl>/қара<v><tv><aor><p3><sg>/қарай<v><iv><ifi><p3><pl>/қарай<v><iv><ifi><p3><sg>$^./.<sent>$")  ;; ерек<n> is dubious, although there is 'ерекке бер' listed as an example for ерек in the EDOK.

(check-equal?
 (kaz-tagger-deterministic "Біздің елде сізге ерекше құрметпен қарайды.")
 "^Біздің/біз<prn><pers><p1><pl><gen>$ ^елде/ел<n><loc>$ ^сізге/сіз<prn><pers><p2><sg><frm><dat>$ ^ерекше/ерекше<adj>$ ^құрметпен/құрмет<n><ins>$ ^қарайды/қара<v><tv><aor><p3><pl>$^./.<sent>$")

(check-equal?
 (kaz-disam "Біздің елде сізге ерекше құрметпен қарайды.")
 "^Біздің/біз<prn><pers><p1><pl><gen><#1->2><@nmod:poss>$^елде/ел<n><loc><#2->6><@obl>$^сізге/сіз<prn><pers><p2><sg><frm><dat><#3->6><@obl>$^ерекше/ерекше<adj><#4->5><@amod>$^құрметпен/құрмет<n><ins><#5->6><@obl>$^қарайды/қара<v><tv><aor><p3><pl><#6->0><@root>$^./.<sent><#7->6><@punct>$")


#;(check-equal?
 (kaz-morph "- Біздің Үкімет бұл жобаны міндетті түрде қолдайды.")
 "^-/-<guio>$ ^Біздің/біз<prn><pers><p1><pl><gen>$ ^Үкімет/үкімет<n><nom>/үкімет<n><attr>/үкімет<n><nom>+е<cop><aor><p3><pl>/үкімет<n><nom>+е<cop><aor><p3><sg>$ ^бұл/бұл<det><dem>/бұл<prn><dem><nom>/бұл<prn><dem><nom>+е<cop><aor><p3><pl>/бұл<prn><dem><nom>+е<cop><aor><p3><sg>$ ^жобаны/жоба<n><acc>$ ^міндетті/міндет<n><acc>/міндетті<adj>/міндет<n>+лы<post>/міндетті<adj>+е<cop><aor><p3><pl>/міндетті<adj>+е<cop><aor><p3><sg>$ ^түрде/түр<n><loc>/түр<n><loc>+е<cop><aor><p3><pl>/түр<n><loc>+е<cop><aor><p3><sg>$ ^қолдайды/қол<n><sim><acc>/қол<adj><subst><sim><acc>/қолда<v><tv><aor><p3><pl>/қолда<v><tv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-tagger-deterministic "- Біздің Үкімет бұл жобаны міндетті түрде қолдайды.")
 "^-/-<guio>$ ^Біздің/біз<prn><pers><p1><pl><gen>$ ^Үкімет/үкімет<n><nom>$ ^бұл/бұл<det><dem>$ ^жобаны/жоба<n><acc>$ ^міндетті/міндетті<adj>$ ^түрде/түр<n><loc>$ ^қолдайды/қолда<v><tv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-disam "- Біздің Үкімет бұл жобаны міндетті түрде қолдайды.")
 "^-/-<guio><#1->8><@punct>$^Біздің/біз<prn><pers><p1><pl><gen><#2->3><@nmod:poss>$^Үкімет/үкімет<n><nom><#3->8><@nsubj>$^бұл/бұл<det><dem><#4->5><@det>$^жобаны/жоба<n><acc><#5->8><@obj>$^міндетті/міндетті<adj><#6->7><@amod>$^түрде/түр<n><loc><#7->8><@obl>$^қолдайды/қолда<v><tv><aor><p3><sg><#8->0><@root>$^./.<sent><#9->8><@punct>$")


#;(check-equal?
 (kaz-morph "- Көші-қон мәселелерін реттеу Қазақстан үшін маңызды болып саналады.")
 "")
