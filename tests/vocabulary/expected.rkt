#lang rash

(require rackunit
         racket/string
         racket/match)

(require apertiumpp)
;; install racket (racket-lang.org)
;; git clone https://github.com/taruen/apertiumpp.git
;; cd apertiumpp/apertiumpp
;; raco pkg install


;;;;;;;;;;;;
;; Constants


(define A-KAZ '../../)


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
                 (define lu #{echo (values surface) | apertium -f none -d (values A-KAZ) kaz-morph})
                 (for ([lexical lexicals])
                      (if (string-suffix? lexical "!")
                          (check-false
                           (lu-contains? lu (substring
                                             lexical
                                             0 (- (string-length lexical) 1))))
                          (check-equal? (lu-contains? lu lexical) lexical))))]))

;(define (test tc)
;        (define surface (car tc))
;        (define lexicals (car (cdr tc)))
;        (define lu
;                #{echo (values surface) | apertium -f none -d (values A-KAZ) kaz-morph})
;        (for ([lexical lexicals])
;             (if (string-suffix? lexical "!")
;                 (check-false
;                  (lu-contains? lu (substring
;                                    lexical
;                                    0 (- (string-length lexical) 1))))
;                 (check-equal? (lu-contains? lu lexical) lexical))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main part: tests themselves


(test
 '(("ма" "ба" "па" "ме" "бе" "пе")
   ("ма<qst>")))

(test
 '("қой"
   ("ғой<mod_ass>"
    "қой<n><nom>"
    "қой<n><attr>"
    "қой<vaux><imp><p2><sg>"
    "қой<v><tv><imp><p2><sg>"
    "қой<v><iv><imp><p2><sg>!"  ;; ! at the end means that this analysis
    ;; should NOT be in the output of kaz-morph
    ;; for "қой" (as it is as of 20.02.2019)
    "қой<n><nom>+е<cop><aor><p3><sg>"
    "қой<n><nom>+е<cop><aor><p3><pl>")))


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
