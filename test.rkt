#lang racket

(require rackunit
         apertium-kaz)

(check-equal?
 (kaz-morph "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
 "^Еуровидение/Еуровидение<np><al><nom>/Еуровидение<np><al><nom>+е<cop><aor><p3><pl>/Еуровидение<np><al><nom>+е<cop><aor><p3><sg>$ ^2010/2010<num>/2010<num><ord>/2010<num><subst><nom>$ ^ән/ән<n><nom>/ән<n><attr>/ән<n><nom>+е<cop><aor><p3><pl>/ән<n><nom>+е<cop><aor><p3><sg>$ ^конкурсы/конкурс<n><px3sp><nom>/конкурс<n><px3sp><nom>+е<cop><aor><p3><pl>/конкурс<n><px3sp><nom>+е<cop><aor><p3><sg>$ ^Еуровидениенің/Еуровидение<np><al><gen>$ ^55-ші/55<num><ord>/55<num><ord><subst><nom>$ ^конкурсы/конкурс<n><px3sp><nom>/конкурс<n><px3sp><nom>+е<cop><aor><p3><pl>/конкурс<n><px3sp><nom>+е<cop><aor><p3><sg>$ ^болады/бол<vaux><aor><p3><pl>/бол<vaux><aor><p3><sg>/бол<v><iv><aor><p3><pl>/бол<v><iv><aor><p3><sg>$^./.<sent>$")

(check-equal?
 (kaz-tagger-deterministic "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
 "^Еуровидение/Еуровидение<np><al><nom>$ ^2010/2010<num><ord>$ ^ән/ән<n><nom>$ ^конкурсы/конкурс<n><px3sp><nom>$ ^Еуровидениенің/Еуровидение<np><al><gen>$ ^55-ші/55<num><ord>$ ^конкурсы/конкурс<n><px3sp><nom>$ ^болады/бол<v><iv><aor><p3><sg>$^./.<sent>$")
