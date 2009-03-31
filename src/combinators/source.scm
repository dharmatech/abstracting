
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (curry/ab procedure)
  (lambda (a)
    (lambda (b)
      (procedure a b))))

(define (curry/ba procedure)
  (lambda (b)
    (lambda (a)
      (procedure a b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (curry/a:bc procedure)
  (lambda (a)
    (lambda (b c)
      (procedure a b c))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (curry/b:ac procedure)
  (lambda (b)
    (lambda (a c)
      (procedure a b c))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (curry/an procedure)
  (lambda (a)
    (lambda args
      (apply procedure a args))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (partial-apply/ab procedure a)
  (lambda (b)
    (procedure a b)))

(define (partial-apply/ba procedure b)
  (lambda (a)
    (procedure a b)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (apply/ab f)
  (lambda (a b)
    (f a b)))

(define (apply/ba f)
  (lambda (a b)
    (f b a)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define (bi x f g c)
;;   (c (f x)
;;      (g x)))

;; (define (bi@ x y f c)
;;   (c (f x)
;;      (f y)))

;; (define (bi* x y f g c)
;;   (c (f x)
;;      (g y)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define (2bi x y f g c)
;;   (c (f x y)
;;      (g x y)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

