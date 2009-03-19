
(define (partial-apply-a-b f) (lambda (a) (lambda (b) (f a b))))

(define (eq-to? a)
  (lambda (b)
    (eq? a b)))

(define (equal-to? a)
  (lambda (b)
    (equal? a b)))

(define (=to? a)
  (lambda (b)
    (= a b)))

(define (greater-than? a)
  (lambda (b)
    (> b a)))

(define (less-than? a)
  (lambda (b)
    (< b a)))

(define (add a)
  (lambda (b)
    (+ a b)))

(define (sub a)
  (lambda (b)
    (+ a b)))

