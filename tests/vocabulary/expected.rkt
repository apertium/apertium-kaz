#lang rash

(require rackunit
         racket/string
         racket/match
         racket/set)

(require apertiumpp)
;; install racket (racket-lang.org)
;; git clone https://github.com/taruen/apertiumpp.git
;; cd apertiumpp/apertiumpp
;; raco pkg install


;;;;;;;;;;;;
;; Constants


(define A-KAZ '../../)
(define A-KAZ-TAT '../../../../apertium-trunk/apertium-kaz-tat)
(define WORDLIST (mutable-set))


;;;;;;;;;;;;
;; Functions


(define (test tc)
        (match tc
               [(list surface (list expecteds ...))
                (begin
                 (if (set-member? WORDLIST surface)
                     (error "There is already a test case for this word!")
                     (set-add! WORDLIST surface))
                 (define lu #{echo (values surface) | apertium -f none -d (values A-KAZ) kaz-morph})
                 (for ([expected expecteds])
                      (match expected
                             [(list lexical slsent tlsent)
                              (begin
                               (if (string-suffix? lexical "!")
                                   (check-false
                                    (lu-contains? lu (substring
                                                      lexical
                                                      0 (- (string-length lexical) 1))))
                                   (check-equal? (lu-contains? lu lexical) lexical))
                               (define trans #{echo (values slsent) | apertium -f none -d (values A-KAZ-TAT) kaz-tat})
                               (check-equal? tlsent trans))])))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main part: tests themselves


(test
 '("ма"
   (("ма<qst>" "" ""))))

(test
 '("ба"
   (("ма<qst>" "" ""))))

(test
 '("па"
   (("ма<qst>" "" ""))))

(test
 '("ме"
   (("ма<qst>" "" ""))))

(test
 '("бе"
   (("ма<qst>" "" ""))))

(test
 '("пе"
   (("ма<qst>" "" ""))))

(test
 '("ма не"   ;; "ба не", "па не" etc?
       (("ма не<qst>" "" ""))))

(test
 '("ме не"
       (("ма не<qst>" "" ""))))

(test
 '("ше"
   (("ше<qst>" "Менің күйеуім ше?" "Минем киявем ничек?"))))

(test
 '("ғой"
   (("ғой<mod_ass>" "" ""))))

(test
 '("қой"
   (("ғой<mod_ass>" "" "")
    ("қой<n><nom>" "" "")
    ("қой<n><attr>" "" "")
    ("қой<vaux><imp><p2><sg>" "" "")
    ("қой<v><tv><imp><p2><sg>" "" "")
    ("қой<v><iv><imp><p2><sg>!" "" "")
    ("қой<n><nom>+е<cop><aor><p3><sg>" "" "")
    ("қой<n><nom>+е<cop><aor><p3><pl>" "" ""))))

(test
 '("гөр"
   (("гөр<mod_ass>" "" ""))))

(test
 '("шығар"
   (("шық<vaux><gpr_fut>" "" "")
    ("шық<v><iv><gpr_fut>" "" "")
    ("шығар<mod>" "" "")
    ("шық<vaux><gpr_fut><subst><nom>" "" "")
    ("шық<vaux><fut><p3><pl>" "" "")
    ("шық<vaux><fut><p3><sg>" "" "")
    ("шық<v><iv><gpr_fut><subst><nom>" "" "")
    ("шық<v><iv><fut><p3><pl>" "" "")
    ("шық<v><iv><fut><p3><sg>" "" "")
    ("шығар<v><tv><imp><p2><sg>" "" ""))))

(test
 '("да"
   (("да<cnjcoo>" "" "")
    ("да<postadv>" "" "")
    ("да<adv>!" "" ""))))

(test
 '("де"
   (("да<cnjcoo>" "" "")
    ("да<postadv>" "" "")
    ("де<v><tv><imp><p2><sg>" "" ""))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; alternative/additional test case formats

;(tc2
  ; "қой"
  ; (("ғой" mod_ass)
     ;  ("қой" n nom)
     ;  ("қой" n attr)
     ;  ("қой" vaux imp p2 sg)
     ;  ("қой" v tv imp p2 sg)
     ;  ("қой" n nom
               ;         ("е" cop aor p3 sg))
     ;  ("қой" n nom
               ;         ("е" cop aor p3 pl))))
;

;(tc3
  ;   "қой"
  ;   (("ғой<mod_ass>" "Бұл бір кітап қой")
       ;    ("қой<n><nom>")
       ;    ("қой<n><attr>")
       ;    ("қой<vaux><imp><p2><sg>")
       ;    ("қой<v><tv><imp><p2><sg>")
       ;    ("қой<n><nom>+е<cop><aor><p3><sg>")
       ;    ("қой<n><nom>+е<cop><aor><p3><pl>)))

;(tc4
  ;   "қой"
  ;   (("ғой" MOD_ASS)
       ;    ("қой" N1)
       ;    ("қой" VAUX)
       ;    ("қой" V-TV)))
