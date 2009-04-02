
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (scalar-projection a b)
  (/ (dot a b)
     (norm b)))

;; (define scalar-projection (bi2 dot (nip norm) /))

(define (vector-projection a b)
  (pt*n (normalize b)
        (scalar-projection a b)))

;; (define vector-projection (bi2 (nip normalize) scalar-projection v*n))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *nodes* #f)
(define *springs* #f)

(define *time-slice* #f)

(define *gravity* #t)

;; (define *world-size* #f)

;; (define (world-width)  (vector-ref *world-size* 0))
;; (define (world-height) (vector-ref *world-size* 1))

(define *world-width*  #f)
(define *world-height* #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; node
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-node pos vel mass elas force)
  (vector 'node pos vel mass elas force))

(define pos   (vector-nth 1))
(define vel   (vector-nth 2))
(define mass  (vector-nth 3))
(define elas  (vector-nth 4))
(define force (vector-nth 5))

(define pos! (set-vector-nth! 1))
(define vel! (set-vector-nth! 2))

(define force! (set-vector-nth! 5))

(define pos-x (uni pos x))
(define pos-y (uni pos y))

(define vel-x (uni vel x))
(define vel-y (uni vel y))

(define pos-x! (uni pos x!))
(define pos-y! (uni pos y!))

(define vel-x! (uni vel x!))
(define vel-y! (uni vel y!))

(define (apply-force node v)
  (force! node (pt+ (force node) v)))

(define (reset-force node)
  (force! node (pt 0 0)))

;; (define (node-id id)
;;   (vector-ref *nodes* (- id 1)))

(define (node-id id)
  (list-ref *nodes* (- id 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; spring
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (spring rest-length k damp node-a node-b)
  (vector 'spring rest-length k damp node-a node-b))

(define rest-length (vector-nth 1))
(define k           (vector-nth 2))
(define damp        (vector-nth 3))
(define node-a      (vector-nth 4))
(define node-b      (vector-nth 5))

(define (spring-length spr)
  (norm (pt- (pos (node-b spr))
             (pos (node-a spr)))))

(define (stretch-length spr)
  (- (spring-length spr)
     (rest-length   spr)))

;; (define stretch-length (bi spring-length rest-length -))

(define (dir spr)
  (normalize (pt- (pos (node-b spr))
                  (pos (node-a spr)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hooke
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; F = -kx
;; 
;; k :: spring constant
;; x :: distance stretched beyond rest length
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define hooke-force-mag (bi k stretch-length *)) ;; spring -- mag

(define hooke-force (bi dir hooke-force-mag pt*n)) ;; spring -- force

(define (act-on-nodes-hooke spr)

  (let ((F (hooke-force spr)))

    (apply-force (node-a spr)         F)
    (apply-force (node-b spr) (pt-neg F))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; damping
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; F = -bv
;; 
;; b :: Damping constant
;; v :: Velocity
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define relative-velocity-a (bi (uni node-a vel) (uni node-b vel) pt-))

(define unit-vec-b->a (bi (uni node-a pos) (uni node-b pos) pt-))

(define relative-velocity-along-spring-a ;; spring -- vel
  (bi relative-velocity-a unit-vec-b->a vector-projection))

(define damping-force-a
  (bi relative-velocity-along-spring-a damp (uni2 pt*n pt-neg)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define relative-velocity-b (bi (uni node-b vel) (uni node-a vel) pt-))

(define unit-vec-a->b (bi (uni node-b pos) (uni node-a pos) pt-))

(define relative-velocity-along-spring-b ;; spring -- vel
  (bi relative-velocity-b unit-vec-a->b vector-projection))

(define damping-force-b ;; spring -- vec
  (bi relative-velocity-along-spring-b damp (uni2 pt*n pt-neg)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (act-on-nodes-damping spr)
  (apply-force (node-a spr) (damping-force-a spr))
  (apply-force (node-b spr) (damping-force-b spr)))

;; (define act-on-nodes-damping ;; spring --
;;   (bi (bi node-a damping-force-a apply-force)
;;       (bi node-b damping-force-b apply-force)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (below? node) (< (y (pos node)) 0))

;; (define below? (uni pos (uni y (less-than? 0))))

(define (above? node) (>= (y (pos node)) *world-height*))

(define (beyond-left? node) (< (x (pos node)) 0))

(define (beyond-right? node) (>= (x (pos node)) *world-width*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (bounce-top node)
  (y! (pos node) (- *world-height* 1.0))
  (y! (vel node)
      (- (* (y (vel node))
            (elas node)))))

(define (bounce-bottom node)
  (y! (pos node) 0.0)
  (y! (vel node)
      (- (* (y (vel node))
            (elas node)))))

(define (bounce-left node)
  (x! (pos node) 0.0)
  (x! (vel node)
      (- (* (x (vel node))
            (elas node)))))

(define (bounce-right node)
  (x! (pos node) (- *world-width* 1.0))
  (x! (vel node)
      (- (* (x (vel node))
            (elas node)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (handle-bounce node)

  (cond ((above?        node) (bounce-top    node))
        ((below?        node) (bounce-bottom node))
        ((beyond-left?  node) (bounce-left   node))
        ((beyond-right? node) (bounce-right  node))
        
        (else 'ok)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (act-on-nodes spr)
  (act-on-nodes-hooke   spr)
  (act-on-nodes-damping spr))

(define (loop-over-springs)
  (for-each act-on-nodes *springs*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (apply-gravity node)
  (apply-force node (pt 0 -9.8)))

(define (do-gravity)
  (if *gravity*
      (for-each apply-gravity *nodes*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; F = ma

(define (calc-acceleration node)
  (pt/n (force node)
        (mass node)))

;; (define calc-acceleration (bi force mass v/n))

(define (new-vel node)
  (pt+ (vel node)
       (pt*n (calc-acceleration node)
             *time-slice*)))

(define (new-pos node)
  (pt+ (pos node)
       (pt*n (vel node)
             *time-slice*)))

(define (iterate-node node)
  (pos! node (new-pos node))
  (vel! node (new-vel node))
  (reset-force node)
  (handle-bounce node))

(define (iterate-nodes) (for-each iterate-node *nodes*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (iterate-system)
  (do-gravity)
  (loop-over-springs)
  (iterate-nodes))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (mass* id x y x-vel y-vel mass elas)
  (set! *nodes*
        (append *nodes*
                (list
                 (make-node (pt x y) (pt x-vel y-vel) mass elas (pt 0 0))))))

(define (spng id id-a id-b k damp rest-length)
  (set! *springs*
        (append *springs*
                (list
                 (spring rest-length k damp (node-id id-a) (node-id id-b))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (pt-gl-vertex p) (glVertex2d (x p) (y p)))

(define (draw-node node)

  (let ((pos (pos node)))

    (glBegin GL_LINE_LOOP)

    (pt-gl-vertex (pt+ pos '#(pt -5 -5)))
    (pt-gl-vertex (pt+ pos '#(pt  5 -5)))
    (pt-gl-vertex (pt+ pos '#(pt  5  5)))
    (pt-gl-vertex (pt+ pos '#(pt -5  5)))

    (glEnd)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (draw-spring spring)

  (glBegin GL_LINES)

  (pt-gl-vertex (pos (node-a spring)))
  (pt-gl-vertex (pos (node-b spring)))

  (glEnd))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (draw-nodes) (for-each draw-node *nodes*))

(define (draw-springs) (for-each draw-spring *springs*))

;; (define (set-projection)
;;   (glMatrixMode GL_PROJECTION)
;;   (glLoadIdentity)
;;   (glOrtho 0 (- *world-width* 1) 0 (- *world-height* 1) -1 1)
;;   (glMatrixMode GL_MODELVIEW)
;;   (glLoadIdentity))

(define (display-system)

  (glClearColor 0.0 0.0 0.0 1.0)

  (glClear GL_COLOR_BUFFER_BIT)

  (draw-nodes)

  (draw-springs))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (run-springies)

  (glutInitDisplayMode GLUT_DOUBLE)

  (glutInit (vector 0) (vector ""))

  (glutInitWindowSize 500 500)

  (glutCreateWindow "Springies")

  (glutReshapeFunc
   (lambda (w h)

     (set! *world-width*  w)
     (set! *world-height* h)

     (glEnable GL_BLEND)
     (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
     (glViewport 0 0 w h)

     (glMatrixMode GL_PROJECTION)
     (glLoadIdentity)

     (glOrtho 0.0 (- *world-width* 1.0) 0.0 (- *world-height* 1.0) -1.0 1.0)))

  (glutDisplayFunc

   (lambda ()

     (glMatrixMode GL_MODELVIEW)

     (glLoadIdentity)

     (display-system)

     (glutSwapBuffers)))

  (glutIdleFunc
   (lambda ()
     (iterate-system)
     (glutPostRedisplay)))

  (glutMainLoop))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

