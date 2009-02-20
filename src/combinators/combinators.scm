
(define (partial-apply-a-b f) (lambda (a) (lambda (b) (f a b))))