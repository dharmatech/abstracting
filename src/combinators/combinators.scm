
(define (partial-apply-a-b f) (lambda (a) (lambda (b) (f a b))))

(define (eq-to? a)
  (lambda (b)
    (eq? a b)))

(define (equal-to? a)
  (lambda (b)
    (equal? a b)))

