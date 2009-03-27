
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (black)
  (when (iterate?)
        (call-random-weighted
         (vec
          (vec 60 (lambda ()
                    (block
                     (lambda ()
                       (size 0.6)
                       (circle)))
                    (block
                     (lambda ()
                       (x 0.1)
                       (rotate 5)
                       (size 0.99)
                       (brightness -0.01)
                       (alpha -0.01)
                       (black)))))
          (vec 1 (lambda ()
                   (block
                    (lambda ()
                      (white)
                      (black)))))))))

(define (white)
  (when (iterate?)
        (call-random-weighted
         (vec
          (vec 60 (lambda ()
                    (block
                     (lambda ()
                       (size 0.6)
                       (circle)))
                    (block
                     (lambda ()
                       (x 0.1)
                       (rotate -5)
                       (size 0.99)
                       (brightness 0.01)
                       (alpha -0.01)
                       (white)))))
          (vec 1 (lambda ()
                   (block
                    (lambda ()
                      (black)
                      (white)))))))))

(define (chiaroscuro)
  (when (iterate?)
        (block
         (lambda ()
           (brightness 0.5)
           (black)))))

(set! *background* (lambda () (brightness -0.5)))

(set! *viewport* (vec -3 6 -2 6))

(set! *threshold* 0.03)

(set! *start-shape* (lambda () (chiaroscuro)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(run-model)