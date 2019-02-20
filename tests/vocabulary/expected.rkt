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
(define WORDLIST (mutable-set))


;;;;;;;;;;;;
;; Functions


(define (test tc)
        (match tc
               [(list (list surfaces ...)
                      (list lexicals ...))
                (for ([surface surfaces])
                     (define lu
                             #{echo (values surface) | apertium -f none -d (values A-KAZ) kaz-morph})
                     (for ([lexical lexicals])
                          (if (string-suffix? lexical "!")
                              (check-false
                               (lu-contains? lu (substring
                                                 lexical
                                                 0 (- (string-length lexical) 1))))
                              (check-equal? (lu-contains? lu lexical) lexical))))]
               [(list surface (list lexicals ...))
                (begin
                 (if (set-member? WORDLIST surface)
                     (error "There is already a test case for this word!")
                     (set-add! WORDLIST surface))
                 (define lu #{echo (values surface) | apertium -f none -d (values A-KAZ) kaz-morph})
                 (for ([lexical lexicals])
                      (if (string-suffix? lexical "!")
                          (check-false
                           (lu-contains? lu (substring
                                             lexical
                                             0 (- (string-length lexical) 1))))
                          (check-equal? (lu-contains? lu lexical) lexical))))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main part: tests themselves


(test
 '(("ма" "ба" "па" "ме" "бе" "пе")
   ("ма<qst>")))

(test
 '(("ма не" "ме не")  ;; "ба не", "па не" etc? 
                      ("ма не<qst>")))

(test
 '("ше"
   ("ше<qst>")))

(test
 '("ғой"
   ("ғой<mod_ass>")))

(test
 '("қой"
   ("ғой<mod_ass>"
    "қой<n><nom>"
    "қой<n><attr>"
    "қой<vaux><imp><p2><sg>"
    "қой<v><tv><imp><p2><sg>"
    "қой<v><iv><imp><p2><sg>!"
    ;; ! mark at the end means that this analysis
    ;; should NOT be in the output of kaz-morph
    ;; for "қой" (as it is as of 20.02.2019)
    "қой<n><nom>+е<cop><aor><p3><sg>"
    "қой<n><nom>+е<cop><aor><p3><pl>")))

(test
 '("гөр"
   ("гөр<mod_ass>")))

(test
 '("шығар"
   ("шық<vaux><gpr_fut>"
    "шық<v><iv><gpr_fut>"
    "шығар<mod>"
    "шық<vaux><gpr_fut><subst><nom>"
    "шық<vaux><fut><p3><pl>"
    "шық<vaux><fut><p3><sg>"
    "шық<v><iv><gpr_fut><subst><nom>"
    "шық<v><iv><fut><p3><pl>"
    "шық<v><iv><fut><p3><sg>"
    "шығар<v><tv><imp><p2><sg>")))

(test
 '("да"
   ("да<cnjcoo>"
    "да<postadv>"
    "да<adv>!")))

(test
 '("де"
   ("да<cnjcoo>"
    "да<postadv>"
    "де<v><tv><imp><p2><sg>")))

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
