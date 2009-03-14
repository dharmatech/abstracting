
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(: loader 'lib "math")
(: loader 'lib "gl")
(: loader 'lib "glut")
(: loader 'lib "glo")
(: loader 'lib "srfi/27")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(random-source-randomize! default-random-source)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector-ref-random v)
  (vector-ref v (random-integer (vector-length v))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (sin-pi* c) (sin (* pi c)))
(define (cos-pi* c) (cos (* pi c)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (random-product-procedure n)

  (display "(* ")

  (let ((proc-1 (random-procedure (- n 1)))
        (proc-2 (random-procedure (- n 1))))

    (display ")")

    (lambda (a b)

      (* (proc-1 a b)
         (proc-2 a b)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (random-average-procedure n)

  (display "(avg ")

  (let ((proc-1 (random-procedure (- n 1)))
        (proc-2 (random-procedure (- n 1))))

    (display ")")

    (lambda (a b)

      (/ (+ (proc-1 a b)
            (proc-2 a b))
         2.0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (random-sin-pi*-procedure n)

  (display "(sin (* pi ")

  (let ((proc (random-procedure (- n 1))))

    (display "))")
             
    (lambda (a b)

      (sin-pi* (proc a b)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (random-cos-pi*-procedure n)

  (display "(cos (* pi ")

  (let ((proc (random-procedure (- n 1))))

    (display "))")
             
    (lambda (a b)

      (cos-pi* (proc a b)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (random-x-y-procedure n)
  (let ((arg (random-integer 2)))
    (display (if (= arg 0) "x " "y "))
    (lambda (a b)
      (vector-ref (vector a b) arg))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (random-procedure n)

  (cond ((= n 1)
         (random-x-y-procedure #f))

        (else
         (let ((procedure (vector-ref-random (vector random-product-procedure
                                                     random-average-procedure
                                                     random-sin-pi*-procedure
                                                     random-cos-pi*-procedure))))
           (procedure n)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(display "(lambda (x y) ")

(define fun (random-procedure 7))

(display ")\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutInit (vector 0) (vector ""))

(glutInitWindowPosition 100 100)

(glutInitWindowSize 500 500)

(glutCreateWindow "Random Art")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (glutReshapeFunc
;;  (lambda (width height)

;;    (glEnable GL_BLEND)
;;    (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
;;    (glViewport 0 0 width height)

;;    (glMatrixMode GL_PROJECTION)
;;    (glLoadIdentity)
;;    (glOrtho -1.0 1.0 -1.0 1.0 -10.0 10.0)))

(glutReshapeFunc (ortho-2d -1.0 1.0 -1.0 1.0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutDisplayFunc
 
 (lambda ()

   (glMatrixMode GL_MODELVIEW)

   (glLoadIdentity)

   (glClearColor 0.0 0.0 0.0 0.0)

   (glClear GL_COLOR_BUFFER_BIT)

   (glBegin GL_POINTS)

   (do ((y -1.0 (+ y 0.01)))
       ((> y 1.0))
     
     (do ((x -1.0 (+ x 0.01)))
         ((> x 1.0))

       (let ((val (fun x y)))

         (let ((grey (/ (+ val 1.0) 2.0)))

           (glColor4d grey grey grey 1.0)

           (glVertex2d x y)))))

   (glEnd)

   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutKeyboardFunc
 (lambda (key x y)
   (exit)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutMainLoop)