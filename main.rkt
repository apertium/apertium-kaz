#lang racket

; Racket interface for apertium-kaz
;
; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.

(provide kaz-morph kaz-tagger kaz-tagger-deterministic kaz-disam)

(require pkg/lib
         rackunit
         rash
         apertiumpp/streamparser)

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
     "echo (values s) | apertium -n -d . kaz-morph | cg-proc kaz.rlx.bin -s 3"))) ;; only the first 3 sections so that mapping rules are excluded

(define (kaz-disam s)
  (parameterize ([current-directory (pkg-directory "apertium-kaz")])
    (rash
     "echo (values s) | apertium -n -d . kaz-disam | cg-conv -lcA")))
