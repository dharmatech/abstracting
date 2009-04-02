;;                     Perlin noise calculations GUI
;;                     
;;                        by David St-Hilaire
;;                comp-521: assignement 2, winter 2008
;;
;;
;; This is a opengl/glut gui implementation and demonstration of the
;; implemented perlin noise library. It has several features, notably,
;; animation (double buffering) and 3 display modes (grayscale, cloud and
;; terrain).

;; Ported to Abstracting by Ed Cavazos

;;;;;;;;;;;;;;;;;;;;;;; Global state variables  ;;;;;;;;;;;;;;;;;;;;;;;

(define image-height #f)
(define image-width #f)

(define octaves 1)
(define x-offset 0)
(define y-offset 0)


(define image-modified #f)
(define animation-activated #f)
(define animation-velocity 1)
(define status-message #f)

(define interpolation-fun #f)
(define display-mode #f)

;;;;;;;;;;;;;;;;;;;;;;; State modification functions ;;;;;;;;;;;;;;;;;;;;;;;

(define (move-image! delta-x delta-y)
  (let ((new-x (+ x-offset delta-x))
        (new-y (+ y-offset delta-y)))
    (if (and (>= new-x 0) (>= new-y 0))
        (begin
          (set! x-offset new-x)
          (set! y-offset new-y)
          (set! image-modified #t)))))

(define (set-octave! number)
  (set! octaves number)
  (set! status-message (string-append "Now using "
                                      (number->string number)
                                      " octaves."))
  (set! image-modified #t))

(define (switch-octave!)
  (set-octave! (modulo (+ octaves 1) 10)))

(define (set-display-mode! mode-fun)
  (set! display-mode mode-fun)
  (set! image-modified #t))

(define (switch-animation-mode!)
  (set! animation-activated (not animation-activated))
  (set! status-message (if animation-activated
                           "Animation turned on."
                           "Animation turned off.")))
                           

(define switch-interpolation-fun!
  (let* ((index 2)
         (functions (vector (cons "s-curve" s-curve-interpolation)
                            (cons "linear" linear-interpolation)
                            (cons "cosine" cos-interpolation)))
         (length (vector-length functions)))
    (lambda ()
      (set! index (modulo (+ index 1) length))
      (set! interpolation-fun (cdr (vector-ref functions index)))
      (set! status-message (string-append "Now using "
                                          (car (vector-ref functions index))
                                          " interpolation."))
      (set! image-modified #t))))


;;;;;;;;;;;;;;;;;;;;;;; Menu functionnalities ;;;;;;;;;;;;;;;;;;;;;;;

(define gray-scale-mode 3)
(define cloud-mode 0)
(define terrain-mode 1)
(define animation-mode 2)
(define interpolation-mode 4)
(define octaves-mode 5)

(define (menu value)
  (cond
   ((eqv? value gray-scale-mode)   (set-display-mode! grayscalify))
   ((eqv? value cloud-mode)        (set-display-mode! cloudify))
   ((eqv? value terrain-mode)      (set-display-mode! terrainify))
   ((eqv? value interpolation-mode)(switch-interpolation-fun!))
   ((eqv? value animation-mode)    (switch-animation-mode!))
   ((eqv? value octaves-mode)      (switch-octave!))))

(define (create-menu)
  (glutCreateMenu menu)
  (glutAddMenuEntry "Gray Scale Mode" gray-scale-mode)
  (glutAddMenuEntry "Cloud Mode" cloud-mode)
  (glutAddMenuEntry "Terrain Mode" terrain-mode)
  (glutAddMenuEntry "Toggle Animation" animation-mode)
  (glutAddMenuEntry "Toggle Interpolation" interpolation-mode)
  (glutAddMenuEntry "Toggle Octaves Number" octaves-mode)
  (glutAttachMenu GLUT_RIGHT_BUTTON))

;;;;;;;;;;;;;;;;;;;;;;; Display Modes ;;;;;;;;;;;;;;;;;;;;;;;

(define (grayscalify noise)
  (glColor3f noise noise noise))

(define (cloudify noise)
  (let ((noise (+ .3 (* .7 noise))))
    (glColor3f noise noise 1.)))

(define (terrainify noise)
  (define water-threshold 0.5)
  (define beach-threshold 0.54)
  (define plain-threshold 0.70)
  (define forest-threshold 0.77)
  (define mountain-threshold 0.92)
  (cond
   ;; Water 
   ((< noise water-threshold)
    (let ((noise (+ noise 0.4)))
      (glColor3f .2 .2 noise)))
   ;; Beaches
   ((< noise beach-threshold)
    (glColor3f 1. 1. noise))
   ;; Plains / Green Terrain
   ((< noise plain-threshold)
    (let ((noise (- 1 (/ (- noise beach-threshold)
                         (- forest-threshold beach-threshold)))))
      (glColor3f .3 noise .3)))
   ;; Forests
   ((< noise forest-threshold)
    (let ((noise (- 1 noise)))
      (glColor3f .2 noise .2)))
   ;; Light Mountains
   ((< noise mountain-threshold)
    (let ((noise (/ (- noise 0.4) 0.7)))
      (glColor3f noise (/ noise 3.)  (/ noise 4.))))
   ;; Snow
   (else
    (let ((noise (/ (- noise 0.1) 0.9)))
      (glColor3f noise noise noise)))))

;;;;;;;;;;;;;;;;;;;;;;; Render-Sceneing function ;;;;;;;;;;;;;;;;;;;;;;;

;; (define (display-message x y msg)
;;   (let ((chars (map char->integer (string->list msg)))
;;         (font GLUT_BITMAP_HELVETICA_12))
;;     (glColor3f 1. 1. 1.)
;;     (glRasterPos2i x y)
;;     (for-each (lambda (char) (glutBitmapCharacter font char))
;;               chars)))

(define (display-message x y msg)
  (print msg "\n"))
  
(define (render-scene)
  
  (glClearColor 0. 0. 0. 0.)
  (glClear GL_COLOR_BUFFER_BIT)

  (glColor3f 0.0 1.0 0.0)

  (print "Rendering...")

  (for i 0 (< i image-height)
       (for j 0 (< j image-width)
            (begin
              (let ((noise (cached-perlin-noise (+ j x-offset)
                                                (+ i y-offset)
                                                octaves
                                                image-height image-width
                                                interpolation-fun)))
                (display-mode noise)
                (glBegin GL_POINTS)
                (glVertex2i j i)
                (glEnd)))
            (lambda () 'ok))
       (lambda () 'ok))

  (print "done\n")

  (if status-message
      (display-message 0 0 status-message))

  (glutSwapBuffers))

;;;;;;;;;;;;;;;;;;;;;;; Viewport and projection ;;;;;;;;;;;;;;;;;;;;;;;

(define (reshape w h) 
  (let ((zoom-x (/ w image-width))
        (zoom-y (/ h image-height)))
    (glPointSize (exact->inexact (+ (max zoom-x zoom-y) 1)))
    (glViewport 0 0 w h)
    (glMatrixMode GL_PROJECTION)
    (glLoadIdentity)
    (glOrtho 0.                            ;;left clip
             (exact->inexact (/ w zoom-x)) ;;right clip
             0.                            ;;bottom clip
             (exact->inexact (/ h zoom-y)) ;;top
             -10.0 10.0)
    (glMatrixMode GL_MODELVIEW)
    (glLoadIdentity)))


;;;;;;;;;;;;;;;;;;;;;;; User I/O ;;;;;;;;;;;;;;;;;;;;;;;

(define (keyboard key x y)

  (let ((key (if (integer? key)
                 (integer->char key)
                 key)))
    
    (case key
      ((#\0) (set-octave! 0))
      ((#\1) (set-octave! 1))
      ((#\2) (set-octave! 2))
      ((#\3) (set-octave! 3))
      ((#\4) (set-octave! 4))
      ((#\5) (set-octave! 5))
      ((#\6) (set-octave! 6))
      ((#\7) (set-octave! 7))
      ((#\8) (set-octave! 8))
      ((#\9) (set-octave! 9))

      ;; On Escape, Ctl-q, q -> terminate the program
      ((#\x1b #\x11 #\q) (quit))
      (else (print `(received keyboard input ,key ,x ,y))))))

(define (special-keyboard key x y)

  (let ((key (if (integer? key)
                 (integer->char key)
                 key)))
  
  (case key
    ((#\e) (move-image! 0 animation-velocity))
    ((#\g) (move-image! 0 (- animation-velocity)))
    ((#\f) (move-image! animation-velocity 0))
    ((#\d) (move-image! (- animation-velocity) 0))
    
    (else (print `(received special keyboard input ,key ,x ,y))))))

;;;;;;;;;;;;;;;;;;;;;;; Idle function (animation) ;;;;;;;;;;;;;;;;;;;;;;;

(define (idle-callback)

  ;; (thread-sleep! 0.05)
  
  (if animation-activated
      (move-image! animation-velocity animation-velocity))
  
  (if (or image-modified animation-activated)
      (begin
        (set! image-modified #f)
        (render-scene))))

;;;;;;;;;;;;;;;;;;;;;;; Gui Initialization ;;;;;;;;;;;;;;;;;;;;;;;

(define (glut-init height width)

  (set! image-height height)
  (set! image-width width)
  
  ;; (glutInit (vector) (vector))

  (glutInit (vector 0) (vector ""))
  
  (glutInitDisplayMode (bitwise-ior GLUT_DOUBLE GLUT_RGB))
  (glutInitWindowSize image-width image-height)
  (glutCreateWindow "Question 2: Perlin Noise")
  
  (glPointSize 1.)
  (glDisable GL_POINT_SMOOTH)

  (create-menu)
  (set! octaves 5)
  (set! display-mode grayscalify)
  (switch-interpolation-fun!)
  (set! animation-velocity (inexact->exact
                            (ceiling (/ (max image-width image-height)
                                        100))))
  (glutReshapeFunc reshape)
  (glutKeyboardFunc keyboard)
  (glutSpecialFunc special-keyboard)
  (glutIdleFunc idle-callback)
  (glutDisplayFunc render-scene))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define usage-message
  (string-append "Usage:\n"
                 "question2 [image height (default: 200)] "
                 "[image width (default: 200)]\n\n"))

(define (display-instructions)
  (for-each (lambda (x) (display x))
            (list 
             "\n"
             "      ----- Comp521 - Assignement 2 - Question2: ----\n"
             "               Perlin noise implementation\n"
             "                           by\n"
             "                    David St-Hilaire\n\n"
             usage-message
             "Instructions:\n"
             "  Please use the context menu by pressing the right mouse \n"
             "  button to get all available options. Also some keyboard \n"
             "  shortcuts are available:\n"
             "     0-9 digits: Use N perlin noise octaves summation.\n"
             "     arrows:     Pan into the generated landscape.\n"
             "     q, escape:  Quit.\n\n"
             "Please Note:\n"
             "  -The image can be resized/zoomed by expanding the window.\n"
             "  -Slightly better performances can be achived by running\n"
             "   the program with: ./question2 -:m10000 [heigth] [width].\n\n"
             "Please enjoy! ^_^Y\n")))

(define return #f)
(define (quit) (return 0))

;; (define (main)
;;   (define (start heigth width)
;;       (glut-init heigth width)
;;       (display-instructions)
;;       (call/cc (lambda (k) (set! return k) (glutMainLoop))))

;;   ;; Start a debug/developpement repl in a seperate thread
;;   ;;   (thread-start! (make-thread (lambda () (##repl))))
;;   (cond
;;    ((eqv? (length (command-line)) 1) (start 200 200))
;;    ((eqv? (length (command-line)) 3)
;;     (start (string->number (list-ref (command-line) 1))
;;            (string->number (list-ref (command-line) 2))))
;;    (else
;;     (display usage-message))))

;; (main)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (start heigth width)
  
  (random-source-randomize! default-random-source)
  
  (glut-init heigth width)
  (display-instructions)
  ;; (call/cc (lambda (k) (set! return k) (glutMainLoop)))
  (glutMainLoop)
  )

(switch-animation-mode!)
(start 200 200)