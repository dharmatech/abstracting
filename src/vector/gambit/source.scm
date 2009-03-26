
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector-map proc . vectors)

  (let ((n (apply min (map vector-length vectors))))

    (let ((u (make-vector n)))

      (do ((i 0 (+ i 1)))
          ((= i n))

        (vector-set! u i
                     (apply proc
                            (map (lambda (v)
                                   (vector-ref v i))
                                 vectors))))

      u)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector-for-each proc . vectors)

  (let ((n (apply min (map vector-length vectors))))

    (do ((i 0 (+ i 1)))
        ((= i n))

      (apply proc (map (lambda (v) (vector-ref v i)) vectors)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

