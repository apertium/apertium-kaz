#lang racket

(provide (all-defined-out))


;;; Constants


(define TAGSET (vector-ref (current-command-line-arguments) 0))
(define BEGIN_TAG "%<")
(define END_TAG "%>")


(define EXAMPLE_ENTRY
   '(ма (%~ма QST Dir/RL "" "")
        (ма   QST Dir/LR "" "")))


(define EXAMPLE_LEXICON
   '((ма (%~ма QST Dir/RL "")
         (ма QST Dir/LR ""))
     (ғой (%~ғой QST Dir/RL "")
          (қой QST Dir/LR ""))))


;;; Functions & Macros


(define-syntax-rule (tag id surf)
  ;; (tag R_ZE "N") sets R_ZE to %<N%> and prints that
  ;; (tag R_ZE (nla R_ZE leipzig NN apertium)) sets R_ZE to %<R_ZE%> if the TAGSET
  ;;   constant is set to "nla", to %<NN%> if the TAGSET constant is set to "leipzig"
  ;;   etc and prints that value
  ;; (tag N R_ZE) sets the value of N to the value of R_ZE and prints it
  (begin
    (define id
      (cond
        [(string? (quote surf)) (if (string=? surf "")
                                    ""
                                    (format surf))]
        [(list? (quote surf))
         (format (hash-ref
                  (apply hash (map symbol->string surf))
                  TAGSET))]
        [else surf]))
    id))


(define (format tag)
  (string-append BEGIN_TAG tag END_TAG))


(define (LEXICON l)
   (apply string-append (flatten (for/list ([i (map e->string l)])
                                   (for/list ([j i])
                                     j)))))


(define (e->string e)
   (let ([lemma (car e)]
         [rst (cdr e)])
     (for/list ([right_par_mark_comm rst])
       (let-values ([(r p m c) (apply values right_par_mark_comm)])
         (string-append (symbol->string lemma)
                        ":"
                        (symbol->string r)
                        " "
                        (symbol->string p)
                        " ; "
                        "! "
			(symbol->string m)
			" "
                        c
                        "\n")))))
