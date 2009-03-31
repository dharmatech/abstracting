
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define vector-nth      (curry/ba   vector-ref))
(define set-vector-nth! (curry/b:ac vector-set!))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (pt a b) (vector 'pt a b))

(define x (vector-nth 1))
(define y (vector-nth 2))

(define x! (set-vector-nth! 1))
(define y! (set-vector-nth! 2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define binary-pt-procedure
  (lambda (op)
    (lambda (a b)
      (pt (op (x a) (x b))
          (op (y a) (y b))))))

(define pt+ (binary-pt-procedure +))
(define pt- (binary-pt-procedure -))
(define pt* (binary-pt-procedure *))
(define pt/ (binary-pt-procedure /))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (pt-n-procedure op)
  (lambda (a n)
    (pt (op (x a) n)
        (op (y a) n))))

(define pt+n (pt-n-procedure +))
(define pt-n (pt-n-procedure -))
(define pt*n (pt-n-procedure *))
(define pt/n (pt-n-procedure /))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (norm p)
  (sqrt (+ (sq (x p))
           (sq (y p)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (normalize p)
  (pt/n p (norm p)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (dot a b)
  (bi (pt* a b) x y +))

