#lang racket

; REQUIRES:
; - apertiumpp package
;   https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
;   it.
; - apertium-kaz-tat package
;   Installation process is similar to installing apertiumpp. In short,
;   clone the apertium-kaz repo,
;   cd to it,
;   run `raco pkg install'
;
; In the `Main part' of this file you see partially corrected output of the
; expander.rkt script, (which is also in apertium-kaz/tests/vocabulary).
;
; Thus each test contains:
; - Kazakh surface form (from the right-hand side of a apertium-kaz.kaz.lexc
;   entries);
; - a list of morphological analyses that I expect for that surface form;
; - along with all possible translations of each analysis into Tatar, Russian
;   and English.
;
; See expander.rkt for details.
;
; For each test in this file, you can expect that selimcan has checked the
; list of expected analyses and Tatar translations. Russian and English
; translations currently might be given as is, that is as apertium kaz-rus
; and kaz-eng translates.
;
; This script, to be exact, the `test' function/macro does the following:
; - passes Kazakh surface form through `kaz-morph' mode;
; - for each analysis (= lexical form) in the test case:
;   - if it doesn't end with a "!": checks that it is among the analyses
;     kaz-morph has returned
;   - if it DOES end with a "!": check that it is NOT among the analyses
;     kaz-morph has returned
;   - checks that Tatar translation, expected for that lexical form, is among
;     the translations kaz-tat returns when passing that lexical form through
;     transfer (preserving any ambiguity at the lexical transfer stage). In
;     other words, the script checks that expected Tatar translation is among
;     possible translations for the lexical form in question.
;
; Thus some of the analyses might end with a bang !, e.g. "^да<adv>$!" here:
; (test
;  '("да"
;    ("^да<cnjcoo>$" ("да") ("тоже") ("and" "either"))
;    ("^да<postadv>$" ("да") ("") (""))
;    ("^да<adv>$!" ("да") ("") (""))
; ))
;
; ! stands for negation. Test is to be interpreted as follows: "да<adv>"
; should NOT be among the analyses that kaz-morph mode returns for the word
; "да", because that analysis is redundant and a mistake.
;
; When I started checking apertium-kaz,it was among the analyses that
; kaz-morph returned for the word "да", and thus racket expander.rkt put it
; into in the test case.
;
; I decided to keep such imo erroneous readings in tests to make it explicit
; that they are considered a mistake, in the hopes that they won't get added
; in the future. Mistakes made ones are more likely to re-occur.
;
; Just testing for the set equality of actual and expected lexical forms
; doesn't seem to be a good idea, since some of the valid analysis might be in
; fact missing, and such a strict set equality test would kind of imply that
; new analyses shouldn't be added. Anyway, this is pretty much bikeshedding,
; while the main work now is go over the list of stems currently found in
; apertium-kaz.kaz.lexc
;
; Implementation details
; ======================
;
; Each call to `test' behind the scenes expands to several calls of various
; assertion functions from rackunit, which is a unit testing framework for
; Racket.
;
; If any of the assertions fail, the line number of the original (test ...)
; is shown in the error trace as source of error. If that is not the case,
; please report it as a bug.
;
; Testing is done thorough the modes only (kaz-morph, kaz-tat etc.). I think
; this is a good practice.

(provide test)

(require rackunit
         racket/string
         racket/match
         racket/set

         rash
         apertiumpp
         apertiumpp/streamparser
         apertium-kaz
         apertium-kaz-tat)


;;;;;;;;;;;;
;; Constants


(define WORDLIST (mutable-set))


;;;;;;;;;;;;
;; Functions


;; String (listof (listof String (listof String) (listof String) (listof String))) -> String + side effects
(define (test surface expectations)
  (begin
    (printf "~v\n" surface)
    (if (set-member? WORDLIST surface)
        (error "There is already a test case for this word!")
        (begin
          (set-add! WORDLIST surface)
          (let ([lu (kaz-morph surface)])
            (for ([e expectations])
              (match e
                [(list lexical (list tat ...) (list rus ...) (list eng ...))
                 (if (string-suffix? lexical "!")
                     (check-false
                      (lu-contains? lu
                                    (strip-^$ (substring lexical
                                                         0
                                                         (- (string-length lexical) 1)))))
                     (begin (check-equal? (lu-contains? lu (strip-^$ lexical)) (strip-^$ lexical))
                            (let ([actual-tat-trans
                                   (map
                                    kaz-tat-from-t1x-to-postgen
                                    (map
                                     string-join
                                     (explode-bi-lus (kaz-tat-from-pretransfer-to-biltrans lexical))))])
                              (check-equal? actual-tat-trans tat))))])))))))

(define (strip-^$ s)
  (substring s 1 (- (string-length s) 1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main part: tests themselves


;(test
; "да"
; '(
;   ("^да<cnjcoo>$" ("да") ("тоже") ("and" "either"))
;   ("^да<postadv>$" ("да") ("") (""))
;   ("^да<adv>$!" ("да") ("") (""))
;))
