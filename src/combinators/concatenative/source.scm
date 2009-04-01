
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define bi
  
  (case-lambda

   ((x f g c)
    (c (f x)
       (g x)))

   ((f g c)
    (lambda (x)
      (bi x f g c)))

   ((f g)
    (lambda (c)
      (bi f g c)))

   ((c)
    (lambda (f g)
      (bi f g c)))

   (()
    (lambda (c)
      (bi c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define bi@

  (case-lambda

   ((x y f c)
    (c (f x)
       (f y)))

   ((f c)
    (lambda (x y)
      (bi@ x y f c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define bi2

  (case-lambda

   ((x y f g c)
    (c (f x y)
       (g x y)))

   ((f g c)
    (lambda (x y)
      (bi2 x y f g c)))

   ((f g)
    (lambda (c)
      (bi2 f g c)))

   ((c)
    (lambda (f g)
      (bi2 f g c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define dip

  (case-lambda

   ((x y f c)
    (c (f x)
       y))

   ((f c)
    (lambda (x y)
      (dip x y f c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define uni

  (case-lambda

   ((x f c)
    (c (f x)))

   ((f c)
    (lambda (x)
      (uni x f c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define uni2

  (case-lambda

   ((x y f c)
    (c (f x y)))

   ((f c)
    (lambda (x y)
      (uni2 x y f c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define dup

  (case-lambda

   ((x c)
    (c x x))

   ((c)
    (lambda (x)
      (dup x c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define swap

  (case-lambda

   ((x y c)
    (c y x))

   ((c)
    (lambda (x y)
      (swap x y c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define dupd

  (case-lambda

   ((x y c)
    (c x x y))

   ((c)
    (lambda (x y)
      (dupd x y c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define drop

  (case-lambda
   ((x c)
    (c))

   ((c)
    (lambda (x)
      (drop x c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define drop/2

  (case-lambda

   ((x y c)
    (c x))

   ((c)
    (lambda (x y)
      (drop/2 x y c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  