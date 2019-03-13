#lang racket

; Racket interface for apertium-kaz
;
; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.

(provide kaz-morph)

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

(define (kaz-disam s)
  (parameterize ([current-directory (pkg-directory "apertium-kaz")])
    (rash
     "echo (values s) | apertium -n -d . kaz-disam | cg-conv -A -l")))
