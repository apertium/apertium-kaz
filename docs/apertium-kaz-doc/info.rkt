#lang info

(define collection "apertium-kaz-doc")
(define deps '("base" "scribble-lib"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("index.scrbl" ())))
(define pkg-desc "Documentation of apertium-kaz: a morphological transducer and disambiguator for Kazakh")
(define pkg-authors '("Ilnar Salimzianov"))
(define version "0.1.0")
