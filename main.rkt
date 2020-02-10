#lang racket

; Racket interface for apertium-kaz
;
; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.

(provide kaz-morph kaz-tagger kaz-tagger-deterministic)

(require pkg/lib
         rackunit
         rash
         apertiumpp/streamparser)

(define (symbol-append s1 s2)
  (string->symbol (string-append (symbol->string s1) (symbol->string s2))))

(define A-KAZ './)

(define (kaz-morph s)
  (parameterize ([current-directory (pkg-directory "apertium-kaz")])
    (rash
     "echo (values s) | apertium -n -d . kaz-morph")))

(define (kaz-tagger s)
  (parameterize ([current-directory (pkg-directory "apertium-kaz")])
    (rash
     "echo (values s) | apertium -n -d . kaz-tagger")))

(define (kaz-tagger-deterministic s)
  (parameterize ([current-directory (pkg-directory "apertium-kaz")])
    (rash
     "echo (values s) | apertium -n -d . kaz-morph | cg-proc kaz.rlx.bin")))
