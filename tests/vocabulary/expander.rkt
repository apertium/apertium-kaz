#lang racket

; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.
;
; Passes Kazakh surface forms through kaz-morph mode,
; expands ambiguous lexical units into unambiguos ones,
; passes the latter through kaz-tat, kaz-rus and kaz-eng bilingual transducers,
; expands ambiguous bilingual lexical units into unambiguos ones,
; and passes all of them through the rest of kaz-tat, kaz-rus and kaz-eng modes.
;
; Here is an example on how the process of using it looks like:
; https://asciinema.org/a/232164
;
; Although the simplest way of starting it is just to type
; 'racket expander.rkt'. No need for Emacs or DrRacket.

; Q: What does this give us?
; A: We get to see all possible translations of Kazakh surface forms into
;    several languages on a single page, with no non-deterministic behaviour
;    involved (like when remaining ambiguity is resolved randomly).
;    The goal of all of this is to use this output to spot mistakes of any kind
;    in transducers or translators. Check the output once, and use it as
;    regression tests for the future. That is, the output of this script gets
;    corrected by a human, and then used as input for another script to be
;    written which tests the behavior of apertium-kaz, rus, eng and of kaz-tat,
;    kaz-rus, kaz-eng.
;
; Was written as a tool to assist selimcan on fixing issue #11 of Apertium-kaz.
; In particular, I mean to pass right-hand sides of kaz.lexc entries to this
; script to see how they are analysed and translated into all three kaz-X
; translators released so far.
;
; EXAMPLE:
;
; apertium-kaz/tests/vocabulary$ cat /tmp/input
; баласың
; бала
; ма
; ма не
;
; apertium-kaz/tests/vocabulary$ cat /tmp/input | racket expander.rkt
; (test
;  '("баласың"
;    ("^бала<n><nom>+е<cop><aor><p2><sg>$" ("баласың") ("ты   мальчик" "ты   ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
;    ("^бала<v><iv><coop><imp><p2><frm><sg>$" ("@бала") ("приравнивай") ("\\@бала"))
; )
; 
; (test
;  '("бала"
;    ("^бала<n><nom>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
;    ("^бала<n><attr>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
;    ("^бала<v><iv><imp><p2><sg>$" ("@бала") ("приравнивай") ("\\@бала"))
;    ("^бала<n><nom>+е<cop><aor><p3><pl>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
;    ("^бала<n><nom>+е<cop><aor><p3><sg>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
; )

; (test
;  '("ма"
;    ("^ма<qst>$" ("мы") ("") (""))
; )
;
; (test
;  '("ма не"
;    ("^ма не<qst>$" ("мыни") ("\\@ма не") ("\\@ма не"))
;)
;
; If run in DrRacket, or in Emacs with racket-mode installed, you can
; type in Kazak surface forms and get translations into Tatar, Russian
; and English interactively -- type a Kazakh surface form, see all
; possible translations of it into Tatar, Kazakh and Russian.
;
; TODO: The pipeline commands in the main loop and the paths to files listed
; below should really be read from the modes.xml files and NOT be hard-coded
; here.

(require rackunit
         rash
         apertiumpp/streamparser
         apertium-kaz
         apertium-kaz-tat
         apertium-kaz-rus
         apertium-eng-kaz)

;(define CORPUS "/home/selimcan/src/mes2017/Antuan_De_Sent-Ekzyuperi__Kishkentay_Khanzada_pdf.firstHalf.txt")
(define KAZCORPUS "/home/selimcan/src/turkiccorpora/kaz.quran.altay.txt")
(define TATCORPUS "/home/selimcan/src/turkiccorpora/tat.quran.nughmani.txt")
(define RUSCORPUS "/home/selimcan/src/turkiccorpora/ru.krachkovsky.txt")
(define ENGCORPUS "/home/selimcan/src/turkiccorpora/en.sahih.txt")

(define NBR-EXAMPLES 1)


;;;;;;;;;;;;
;; Functions


(let ([inf (current-input-port)])
  (for ([surf (in-lines inf)])
    (printf "(test\n ~v\n  '(\n" surf)
    (define lu
      (explode
       (kaz-morph surf)))
    
    (define readings (rest lu))
    
    (for ([reading readings])

      (define tat
        (map
         kaz-tat-from-t1x-to-postgen
         (map
          string-join                                          
          (explode-bi-lus
           (kaz-tat-from-pretransfer-to-biltrans reading)))))

      (define rus
        (map
         kaz-rus-from-t1x-to-postgen
         (map
          string-join                                          
          (explode-bi-lus
           (kaz-rus-from-pretransfer-to-biltrans reading)))))

      (define eng
        (map
         kaz-eng-from-t1x-to-postgen
         (map
          string-join                                          
          (explode-bi-lus
           (kaz-eng-from-pretransfer-to-biltrans reading)))))
      
      (printf "    (~v ~s ~s ~s)\n" reading tat rus eng))
    (printf "#|\n")
    (let ([wanted (regexp-quote (string-append " " surf " "))]
          [kazcorpus (open-input-file KAZCORPUS)]
          [tatcorpus (open-input-file TATCORPUS)]
          [ruscorpus (open-input-file RUSCORPUS)]
          [engcorpus (open-input-file ENGCORPUS)])
      (define counter 0)
      (for ([kazline (in-lines kazcorpus)]
            [tatline (in-lines tatcorpus)]
            [rusline (in-lines ruscorpus)]
            [engline (in-lines engcorpus)])
        #:break (= counter NBR-EXAMPLES)
        (define match (regexp-match wanted kazline))
        (when match
          (begin
            (set! counter (+ counter 1))
            (display (regexp-replace (first match) kazline (string-upcase (first match)))))
          (newline)(newline)
          (display (kaz-tat kazline))
          (newline)(newline)
          (display tatline)
          (newline)(newline)
          (display rusline)
          (newline)(newline)
          (display engline)
          (newline)))
      (close-input-port kazcorpus)
      (close-input-port tatcorpus)
      (close-input-port ruscorpus)
      (close-input-port engcorpus))
    (printf "|#\n))\n\n")))