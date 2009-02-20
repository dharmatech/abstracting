
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vector
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector+ . args) (apply vector-map + args))
(define (vector- . args) (apply vector-map - args))
(define (vector* . args) (apply vector-map * args))
(define (vector/ . args) (apply vector-map / args))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector*n v n) (vector-map (multiplier n) v))
(define (vector/n v n) (vector-map (divide-by  n) v))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector-sum v)

  (let ((sum 0))

    (let ((add-to-sum
           (lambda (elt)
             (set! sum (+ sum elt)))))

      (vector-for-each add-to-sum v))

    sum))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector. a b) (vector-sum (vector* a b)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vec
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vec+ . args) (vec-obj (apply vector+ (map (lambda (v) (-> v 'raw)) args))))
(define (vec- . args) (vec-obj (apply vector- (map (lambda (v) (-> v 'raw)) args))))
(define (vec* . args) (vec-obj (apply vector* (map (lambda (v) (-> v 'raw)) args))))
(define (vec/ . args) (vec-obj (apply vector/ (map (lambda (v) (-> v 'raw)) args))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vec*n v n) ((-> v 'map) (multiplier n)))
(define (vec/n v n) ((-> v 'map) (divide-by  n)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define (vec-norm v)
;;   (sqrt (-> ((-> v 'map) sq) 'sum)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (v. a b)
  (-> (vec* a b) 'sum))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define v+ vec+)
(define v- vec-)

(define v*n vec*n)
(define v/n vec/n)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (norm v)
  (sqrt
   (vector-sum
    (vector-map sq (vector-ref v 1)))))

(define (normalize v) (v/n v (norm v)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

