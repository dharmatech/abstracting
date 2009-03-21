
(use srfi-13)

(define (lib-base-name name)
  (cond ((string-index-right name #\/) =>
         (lambda (i)
           (string-drop name (+ i 1))))
        (else name)))

(define (relative-source-file name)
  (string-append name "/" (lib-base-name name) ".scm"))

(define-macro (inc name)
  `(include ,(relative-source-file name)))