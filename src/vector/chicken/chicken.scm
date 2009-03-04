
(use vector-lib)

(define srfi-43-vector-map vector-map)

(define vector-map
  (lambda (f . vectors)
    (apply srfi-43-vector-map (lambda (i . elts) (apply f elts)) vectors)))

(define srfi-43-vector-for-each vector-for-each)

(define vector-for-each
  (lambda (f . vectors)
    (apply srfi-43-vector-for-each (lambda (i . elts) (apply f elts)) vectors)))
