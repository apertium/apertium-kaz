#lang racket

; REQUIRES: apertiumpp package. https://taruen.github.io/apertiumpp/apertiumpp/
; gives info on how to install it.
;
; Passes Kazakh surface forms through kaz-morph mode,
; expands ambiguous lexical units into unambiguos ones,
; passes the latter through kaz-tat, kaz-rus and kaz-eng bilingual transducers,
; expands ambiguous bilingual lexical units into unambiguos ones,
; and passes all of them through the rest of kaz-tat, kaz-rus and kaz-eng modes.
;
; Q: What does this give us?
; A: We get to see all possible translations of Kazakh surface forms into
;    several languages on a single page, with no non-deterministic behaviour
;    involved (like when remaining ambiguity is resolved randomly).
;    The goal of all of this is to use these output to spot mistakes of any kind
;    in transducers or translators. Check it once, and use as regression tests
;    for the future. That is, the output of these script gets corrected by
;    a human, and then used as input for another script to be written to
;    test the behavior of apertium-kaz, rus, end and of kaz-tat, kaz-rus, kaz-eng
;
; Was written as a tool for fixin issue #11 of Apertium-kaz.
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
; If run in DrRacket, you can type in Kazak surface forms and get translations
; into Tatar, Russian and English interactively, type a Kazakh surface form,
; see all possible translations of it into Tatar, Kazakh and Russian.

(require rackunit
         rash
         apertiumpp/streamparser)

(define A-KAZ '../..)
(define A-KAZ-TAT-BIL '../../../../apertium-trunk/apertium-kaz-tat/kaz-tat.autobil.bin)
(define A-KAZ-TAT-T1X '../../../../apertium-trunk/apertium-kaz-tat/apertium-kaz-tat.kaz-tat.t1x)
(define A-KAZ-TAT-T1X-BIN '../../../../apertium-trunk/apertium-kaz-tat/kaz-tat.t1x.bin)
(define A-KAZ-TAT-T2X '../../../../apertium-trunk/apertium-kaz-tat/apertium-kaz-tat.kaz-tat.t2x)
(define A-KAZ-TAT-T2X-BIN '../../../../apertium-trunk/apertium-kaz-tat/kaz-tat.t2x.bin)
(define A-KAZ-TAT-GEN '../../../../apertium-trunk/apertium-kaz-tat/kaz-tat.autogen.bin)
(define A-KAZ-TAT-PGEN '../../../../apertium-trunk/apertium-kaz-tat/kaz-tat.autopgen.bin)

(define A-KAZ-RUS-BIL '../../../../apertium-trunk/apertium-kaz-rus/kaz-rus.autobil.bin)
(define A-KAZ-RUS-T1X '../../../../apertium-trunk/apertium-kaz-rus/apertium-kaz-rus.kaz-rus.t1x)
(define A-KAZ-RUS-T1X-BIN '../../../../apertium-trunk/apertium-kaz-rus/kaz-rus.t1x.bin)
(define A-KAZ-RUS-T2X '../../../../apertium-trunk/apertium-kaz-rus/apertium-kaz-rus.kaz-rus.t2x)
(define A-KAZ-RUS-T2X-BIN '../../../../apertium-trunk/apertium-kaz-rus/kaz-rus.t2x.bin)
(define A-KAZ-RUS-T3X '../../../../apertium-trunk/apertium-kaz-rus/apertium-kaz-rus.kaz-rus.t3x)
(define A-KAZ-RUS-T3X-BIN '../../../../apertium-trunk/apertium-kaz-rus/kaz-rus.t3x.bin)
(define A-KAZ-RUS-T4X '../../../../apertium-trunk/apertium-kaz-rus/apertium-kaz-rus.kaz-rus.t4x)
(define A-KAZ-RUS-T4X-BIN '../../../../apertium-trunk/apertium-kaz-rus/kaz-rus.t4x.bin)
(define A-KAZ-RUS-GEN '../../../../apertium-trunk/apertium-kaz-rus/kaz-rus.autogen.bin)
(define A-KAZ-RUS-PGEN '../../../../apertium-trunk/apertium-kaz-rus/kaz-rus.autopgen.bin)

(define A-KAZ-ENG-BIL '../../../../apertium-trunk/apertium-eng-kaz/kaz-eng.autobil.bin)
(define A-KAZ-ENG-T1X '../../../../apertium-trunk/apertium-eng-kaz/apertium-eng-kaz.kaz-eng.t1x)
(define A-KAZ-ENG-T1X-BIN '../../../../apertium-trunk/apertium-eng-kaz/kaz-eng.t1x.bin)
(define A-KAZ-ENG-T2X '../../../../apertium-trunk/apertium-eng-kaz/apertium-eng-kaz.kaz-eng.t2x)
(define A-KAZ-ENG-T2X-BIN '../../../../apertium-trunk/apertium-eng-kaz/kaz-eng.t2x.bin)
(define A-KAZ-ENG-T3X '../../../../apertium-trunk/apertium-eng-kaz/apertium-eng-kaz.kaz-eng.t3x)
(define A-KAZ-ENG-T3X-BIN '../../../../apertium-trunk/apertium-eng-kaz/kaz-eng.t3x.bin)
(define A-KAZ-ENG-GEN '../../../../apertium-trunk/apertium-eng-kaz/kaz-eng.autogen.bin)


;;;;;;;;;;;;
;; Functions


(let ([inf (current-input-port)])
  (for ([surf (in-lines inf)])
    (printf "(test\n '(~v\n" surf)
    (define lu
      (explode
       (rash "echo (values surf) | apertium -n -d (values A-KAZ) kaz-morph")))
    (define readings (rest lu))

    (for ([reading readings])

      (define tat
        (map
         (λ (tr)
           (rash
            "echo (values tr) | "
            "apertium-transfer -b (values A-KAZ-TAT-T1X) (values A-KAZ-TAT-T1X-BIN) | "
            "apertium-transfer -n (values A-KAZ-TAT-T2X) (values A-KAZ-TAT-T2X-BIN) | "
            "lt-proc -g (values A-KAZ-TAT-GEN) | "
            "lt-proc -p (values A-KAZ-TAT-PGEN)"))
         (map
          string-join                                          
          (explode-bi-lus
           (rash
            "echo (values reading) | apertium-pretransfer | "
            "lt-proc -b (values A-KAZ-TAT-BIL)"
            )))))

      (define rus
        (map
         (λ (tr)
           (rash
            "echo (values tr) | "
            "apertium-transfer -b (values A-KAZ-RUS-T1X) (values A-KAZ-RUS-T1X-BIN) | "
            "apertium-interchunk (values A-KAZ-RUS-T2X) (values A-KAZ-RUS-T2X-BIN) | "
            "apertium-interchunk (values A-KAZ-RUS-T3X) (values A-KAZ-RUS-T3X-BIN) | "
            "apertium-postchunk (values A-KAZ-RUS-T4X) (values A-KAZ-RUS-T4X-BIN) | "            
            "lt-proc -g (values A-KAZ-RUS-GEN) | "
            "lt-proc -p (values A-KAZ-RUS-PGEN)"))
         (map
          string-join                                          
          (explode-bi-lus
           (rash
            "echo (values reading) | apertium-pretransfer | "
            "lt-proc -b (values A-KAZ-RUS-BIL)"
            )))))

      (define eng
        (map
         (λ (tr)
           (rash
            "echo (values tr) | "
            "apertium-transfer -b (values A-KAZ-ENG-T1X) (values A-KAZ-ENG-T1X-BIN) | "
            "apertium-interchunk (values A-KAZ-ENG-T2X) (values A-KAZ-ENG-T2X-BIN) | "
            "apertium-postchunk (values A-KAZ-ENG-T3X) (values A-KAZ-ENG-T3X-BIN) | "
            "lt-proc -g (values A-KAZ-ENG-GEN)"))
         (map
          string-join                                          
          (explode-bi-lus
           (rash
            "echo (values reading) | apertium-pretransfer | "
            "lt-proc -b (values A-KAZ-ENG-BIL)"
            )))))
      (printf "   (~v ~s ~s ~s)\n" reading tat rus eng))
    (printf ")\n\n")))
