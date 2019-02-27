#lang racket

; Passes Kazakh surface forms through kaz-morph mode, and then through the
; rest of kaz-tat, kaz-rus and kaz-eng modes (starting with apertium-pretransfer).
;
; Ambiguity at each stage is preserved, so that we can be sure to have covered
; all of the cases.
;
; EXAMPLE:
;
; selimcan@patroclus:~/1Working/1Apertium++/apertium-all/apertium-languages/apertium-kaz/tests/vocabulary$ cat /tmp/input
; баласың
; бала
; ма
; ма не
;
; selimcan@patroclus:~/1Working/1Apertium++/apertium-all/apertium-languages/apertium-kaz/tests/vocabulary$ cat /tmp/input  | racket expander.rkt;
; (test
;  '("баласың"
;    (("^бала<n><nom>+е<cop><aor><p2><sg>$" ("баласың") ("ты   мальчик" "ты   ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))))
;    (("^бала<v><iv><coop><imp><p2><frm><sg>$" ("@бала") ("приравнивай") ("\\@бала"))))
; (test
;  '("бала"
;    (("^бала<n><nom>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))))
;    (("^бала<n><attr>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))))
;    (("^бала<v><iv><imp><p2><sg>$" ("@бала") ("приравнивай") ("\\@бала"))))
;    (("^бала<n><nom>+е<cop><aor><p3><pl>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))))
;    (("^бала<n><nom>+е<cop><aor><p3><sg>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))))
; (test
;  '("ма"
;    (("^ма<qst>$" ("мы") ("") (""))))
; (test
;  '("ма не"
;    (("^ма не<qst>$" ("мыни") ("\\@ма не") ("\\@ма не"))))
;
; If run in DrRacket, you can type in Kazak surface forms and get translations
; into Tatar, Russian and English interactively.

(require rackunit
         rash)

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

(define/contract (explode lu)
  (string? . -> . (listof string?))
  ;; turn a possibly ambiguous lexical unit into multiple unambiguous lexical units
  ;; ASSUME: no escaped / symbol (\/) in the given lexical unit
  (map (lambda (s) (string-append "^" s "$")) 
       (regexp-split
        #rx"/"
        (regexp-replace #rx"\\$$" (regexp-replace #rx"^\\^" lu "") ""))))

(check-equal? (explode "^ма<qst>$")
              '("^ма<qst>$"))
(check-equal? (explode "^ма/ма<qst>$")
              '("^ма$" "^ма<qst>$"))
(check-equal? (explode "^бала/бала<n<nom>/бала<n><attr>$")
              '("^бала$" "^бала<n<nom>$" "^бала<n><attr>$"))
(check-equal? (explode "^бала<n><nom>/мальчик<n><m><aa><nom>/ребёнок<n><m><aa><nom>$")
              '("^бала<n><nom>$" "^мальчик<n><m><aa><nom>$" "^ребёнок<n><m><aa><nom>$"))


(define (explode-bi-lus s)
  ;  (string? . -> . (listof (listof string?)))
  ;; turn a possibly ambiguous *bilingual* lexical unit into multiple
  ;; unambiguous bilingual lexical units

  (define (implode l)
    (let ([left (regexp-replace #rx"\\$$" (first l) "")]
          [rights (map (λ (s) (substring s 1)) (rest l))])
      (map list (map (λ (s) (string-append left "/" s)) rights))))

  (check-equal? (implode '("^бала<n><nom>$" "^child<n>$" "^kid<n>$" "^infant<n>$"))
                '(("^бала<n><nom>/child<n>$") ("^бала<n><nom>/kid<n>$") ("^бала<n><nom>/infant<n>$")))

  (define (^$ s)
    (cond
      [(and (regexp-match? #rx"^\\^" s) (regexp-match? #rx"\\$$" s)) s]
      [(and (regexp-match? #rx"^\\^" s) (not (regexp-match? #rx"\\$$" s)))
       (string-append s "$")]
      [(and (not (regexp-match? #rx"^\\^" s)) (regexp-match? #rx"\\$$" s))
       (string-append "^" s)]
      [else (string-append "^" s "$")]))

  (check-equal? (^$ "foo<n>") "^foo<n>$")
  (check-equal? (^$ "^foo<n>") "^foo<n>$")
  (check-equal? (^$ "foo<n>$") "^foo<n>$")
  (check-equal? (^$ "^foo<n>$") "^foo<n>$")
  
  (define lus (map ^$ (regexp-split #rx"\\$ +\\^" s)))
  (define almost (map implode (map explode lus)))
  (match (length almost)
    [1 (first almost)]
    [2 (for*/list ([i (first almost)]
                   [j (second almost)])
         (append i j))]
    [3 (for*/list ([i (first almost)]
                   [j (second almost)]
                   [k (third almost)])
         (append i j k))]))
                                                   
(check-equal? (explode-bi-lus "^ма<qst>/мы<qst>$")
              '(("^ма<qst>/мы<qst>$")))
(check-equal? (explode-bi-lus "^бала<n><nom>/child<n>/kid<n>$")
              '(("^бала<n><nom>/child<n>$") ("^бала<n><nom>/kid<n>$")))
(check-equal? (explode-bi-lus "^бала<n><nom>/child<n>/kid<n>/infant<n>$")
              '(("^бала<n><nom>/child<n>$") ("^бала<n><nom>/kid<n>$") ("^бала<n><nom>/infant<n>$")))
(check-equal? (explode-bi-lus "^бала<n><nom>/child<n>/kid<n>$ ^е<cop><aor><p3><sg>/be<vbser><pres><p3>/$")
              '(("^бала<n><nom>/child<n>$" "^е<cop><aor><p3><sg>/be<vbser><pres><p3>$")
                ("^бала<n><nom>/child<n>$" "^е<cop><aor><p3><sg>/$")
                ("^бала<n><nom>/kid<n>$" "^е<cop><aor><p3><sg>/be<vbser><pres><p3>$")
                ("^бала<n><nom>/kid<n>$" "^е<cop><aor><p3><sg>/$")))


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

      (printf "   ((~v ~s ~s ~s)))" reading tat rus eng) 
      (newline))))