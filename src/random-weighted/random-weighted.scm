
(import (srfi srfi-27))

(define (probabilities weights)
  ((-> weights '/n)
   (-> weights 'sum)))

(define (layers probabilities)

  (let ((n (+ (-> probabilities 'len) 1)))

    ((-> (-> ((-> (int-to-vec n) 'map)
	      (lambda (num)
		((-> probabilities 'head) num)))
	     'rest)
	 'map)
     (lambda (v) (-> v 'sum)))))
	
(define (random-weighted weights)
  ((-> ((-> (layers (probabilities weights)) 'map)
	(lambda (elt)
	  (* 1000 elt)))
       'index)
   (let ((n (random-integer 1000)))
     (lambda (elt)
       (> elt n)))))
  
(define (call-random-weighted tbl)

  (let ((weights ((-> tbl 'map) (lambda (ent) (-> ent 'first)))))

    (let ((i (random-weighted weights)))

      (let ((procedure (-> ((-> tbl 'ref) i) 'second)))

	(procedure)))))



  