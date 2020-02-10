#lang racket

(require rackunit
         apertium-kaz)

(check-equal?
 (kaz-tagger-deterministic "Еуровидение 2010 ән конкурсы Еуровидениенің 55-ші конкурсы болады.")
 "^Еуровидение/Еуровидение<np><al><nom>$ ^2010/2010<num><ord>$ ^ән/ән<n><nom>$ ^конкурсы/конкурс<n><px3sp><nom>$ ^Еуровидениенің/Еуровидение<np><al><gen>$ ^55-ші/55<num><ord>$ ^конкурсы/конкурс<n><px3sp><nom>$ ^болады/бол<v><iv><aor><p3><sg>$^./.<sent>$")
