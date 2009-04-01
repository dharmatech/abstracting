;;                     Perlin noise calculations
;;                     
;;                        by David St-Hilaire
;;                comp-521: assignement 2, winter 2008
;;
;;
;; This library possess functions that calculates the perlin noise on
;; a 2d grid. Caching is used to accelerate the library procedures.

;; (declare (inline)
;;          (inline-primitives)
;;          (inlining-limit 350)
;;          (block)
;;          (lambda-lift)
;;          (constant-fold)
;;          (not safe)
;;          (standard-bindings)
;;          (extended-bindings))

;; Sources of inspiration:
;; http://www.cs.cmu.edu/~mzucker/code/perlin-noise-math-faq.html
;; http://freespace.virgin.net/hugo.elias/models/m_perlin.htm

;;;;;;;;;;;;;;;;;;;;; Data Structure Definition ;;;;;;;;;;;;;;;;;;;;;;;

;; (define f32vector vector)

;; (define f32vector-ref vector-ref)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define (create-point2d x y) (f32vector (exact->inexact x)
;;                                         (exact->inexact y)))

(define (create-point2d x y) (vector (exact->inexact x)
                                     (exact->inexact y)))

;; (define (point2d-x p) (f32vector-ref p 0))
;; (define (point2d-y p) (f32vector-ref p 1))

(define (point2d-x p) (vector-ref p 0))
(define (point2d-y p) (vector-ref p 1))

(define (point2d-add p1 p2)
  (create-point2d (fl+ (point2d-x p1) (point2d-x p2))
                  (fl+ (point2d-y p1) (point2d-y p2))))
(define (point2d-sub p1 p2)
  (create-point2d (fl- (point2d-x p1) (point2d-x p2))
                  (fl- (point2d-y p1) (point2d-y p2))))

(define (point2d-dot-prod p1 p2)
  (fl+ (fl* (point2d-x p1) (point2d-x p2))
       (fl* (point2d-y p1) (point2d-y p2))))

;;;;;;;;;;;;;;;;;;;;; Random Gradient Generation ;;;;;;;;;;;;;;;;;;;;;;;

;; the gradient values are all cached in a table and it is ensured
;; that each harmonics have different gradient values.

(define get-random-gradient
  (let ((cache (make-hashtable equal-hash equal?)))
    (lambda (harm x y)
      (let* ((key (list harm x y))
             (cache-val (hashtable-ref cache key #f)))
        (if cache-val
            cache-val
            (let* ((grad-angle (* 2 pi (random-real)))
                   (grad (create-point2d (cos grad-angle) (sin grad-angle))))
              (hashtable-set! cache key grad)
              grad))))))

;;;;;;;;;;;;;;;;;;;;; Interpolation functions ;;;;;;;;;;;;;;;;;;;;;;;

(define (s-curve-interpolation y1 y2 x)
  (fl- (fl* 3. x x) (fl* 2. x x x)))

(define (linear-interpolation y1 y2 x)
  (fl+ y1 (fl* x (fl- y2 y1))))

(define (cos-interpolation y1 y2 x)
  (let ((f (fl* 0.5 (fl- 1. (cos (fl* x pi))))))
    (fl+ (fl* y1 (fl- 1. f)) (fl* y2 f))))

;;;;;;;;;;;;;;;;;;;;; Basic Perlin noise calculation ;;;;;;;;;;;;;;;;;;;

;; Calculates the noise at a given harmonic level on the 2d coordinate
;; (x,y), using the passed interpolation function. The interpolation
;; function must have the following format: (lambda (y1 y2 x) ...)
;; where x will be interpolated somewhere between y1 and y2.
(define (noise2d harm x y interpolation-fun)
  (let* ((p (create-point2d x y))
         
         ;; Caclulate the two extremums in both axis
         (x0 (exact->inexact (floor   (point2d-x p))))
         (x1 (exact->inexact (ceiling (point2d-x p))))
         (y0 (exact->inexact (floor   (point2d-y p))))
         (y1 (exact->inexact (ceiling (point2d-y p))))

         ;; Create the four corners out of the extremums
         (p00 (create-point2d x0 y0))
         (p01 (create-point2d x0 y1))
         (p10 (create-point2d x1 y0))
         (p11 (create-point2d x1 y1))

         ;; Get the gradient value on the corners
         (g00 (get-random-gradient harm (point2d-x p00) (point2d-y p00)))
         (g01 (get-random-gradient harm (point2d-x p01) (point2d-y p01)))
         (g10 (get-random-gradient harm (point2d-x p10) (point2d-y p10)))
         (g11 (get-random-gradient harm (point2d-x p11) (point2d-y p11)))

         ;; Calculate the initial influences scalars
         (s (point2d-dot-prod g00 (point2d-sub p p00)))
         (t (point2d-dot-prod g10 (point2d-sub p p10)))
         (u (point2d-dot-prod g01 (point2d-sub p p01)))
         (v (point2d-dot-prod g11 (point2d-sub p p11)))

         ;; Calculate the X influences of the gradients
         (Sx (interpolation-fun 0. 1. (fl- (point2d-x p) x0)))
         (a (linear-interpolation s t Sx))
         (b (linear-interpolation u v Sx))

         ;; Calculate the Y influence of the gradients
         (Sy (interpolation-fun 0. 1. (fl- (point2d-y p) y0)))

         ;; Obtain finally the final value of the noies.
         ;; Note: the result is multiplied by 3 to try to spread more
         ;; the results.
         (z (fl* 3. (linear-interpolation a b Sy))))
    z))

;;;;;;;;;;;;;;;;;;;;;;; Harmonic Perlin noise calculation ;;;;;;;;;;;;;;;;;;;

;; Will return the Perlin noise calculated on the (x,y) 2d coordinates
;; by summing harm-limit number of harmonics. The individual noises
;; are obtained by the ratio of the position on the grid size (and the
;; harmonic frequencies) using a specific interpolation
;; function.
;; Note, the returned result is expected to lie in [0,1].
(define (perlin-noise x y harm-limit width height interpolation-fun)
  (let loop ((harm 0) (noise 0) (noise-max 0))
    (if (<= harm harm-limit)
        (let ((freq (expt 2 harm))
              (amplitude (expt 1/2 harm)))
          (loop (+ harm 1)
                (+ noise (* amplitude
                            (noise2d harm
                                     (* freq x (/ 1 width))
                                     (* freq y (/ 1 height))
                                     interpolation-fun)))
                (+ noise-max amplitude)))
        (exact->inexact (/ (+ 1 (/ noise noise-max)) 2)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;; Perlin noise grid caching ;;;;;;;;;;;;;;;;;;;;;;;;;

(define perlin-cache-harm-level 0)
(define perlin-cache-interpolation-fun #f)

;; (define perlin-cache (make-table))

(define perlin-cache (make-hashtable equal-hash equal?))

;; Another cache level is used to save the noise values for a static
;; interpolation function and harmonic level pair. This is used to
;; accellerate the animation process, but this will used alot of
;; memory on the long run. When either the interpolation-fun or the
;; harm-limit gets changed, the cache is reset.
(define (cached-perlin-noise x y harm-limit width height interpolation-fun)
    (let* ((key (list x y harm-limit interpolation-fun))
           (cache-val (hashtable-ref perlin-cache key #f)))
      
      (if (and cache-val (eqv? harm-limit perlin-cache-harm-level))
          cache-val
          (begin
            (if (or (not (eqv? harm-limit
                               perlin-cache-harm-level))
                    (not (eq? interpolation-fun
                              perlin-cache-interpolation-fun)))
                (begin (set! perlin-cache-harm-level harm-limit)
                       (set! perlin-cache-interpolation-fun interpolation-fun)
                       (set! perlin-cache (make-hashtable equal-hash equal?))))
            (let ((perlin-noise-val
                   (perlin-noise x y harm-limit
                                 width height interpolation-fun)))
              (hashtable-set! perlin-cache key perlin-noise-val)
              perlin-noise-val)))))


        