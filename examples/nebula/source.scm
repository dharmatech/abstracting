
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Nebula by Matt Schroeter
;;
;; Original version in Processing:
;;   http://www.openprocessing.org/visuals/?visualID=1412
;;
;; Ported to Abstracting by Ed Cavazos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(glutInit (vector 0) (vector ""))

(glutInitDisplayMode GLUT_DOUBLE)

(glutInitWindowSize 800 600)

(glutCreateWindow "Nebula")

(glLightfv GL_LIGHT0 GL_AMBIENT  (: (f32-vec 0.0 0.0 0.0 1.0) 'ffi))
(glLightfv GL_LIGHT0 GL_DIFFUSE  (: (f32-vec 1.0 1.0 1.0 1.0) 'ffi))
(glLightfv GL_LIGHT0 GL_POSITION (: (f32-vec 0.0 3.0 3.0 0.0) 'ffi))

(glLightModelfv GL_LIGHT_MODEL_AMBIENT      (: (f32-vec 0.2 0.2 0.2 1.0) 'ffi))
(glLightModelfv GL_LIGHT_MODEL_LOCAL_VIEWER (: (f32-vec 0.0)             'ffi))

(glShadeModel GL_FLAT)

(glEnable GL_LIGHTING)

(glEnable GL_LIGHT0)

;; (glEnable GL_AUTO_NORMAL)

(glEnable GL_NORMALIZE)

(glMaterialfv GL_FRONT GL_AMBIENT  (: (f32-vec 0.2 0.0 0.0 1.0) 'ffi))

(glMaterialfv GL_FRONT GL_DIFFUSE  (: (f32-vec 1.0 0.0 0.0 1.0) 'ffi))
(glMaterialfv GL_FRONT GL_SPECULAR (: (f32-vec 1.0 0.0 0.0 1.0) 'ffi))

(glMaterialfv GL_FRONT GL_SHININESS (: (f32-vec 500.0) 'ffi))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (box w h d)
  (glPushMatrix)
  (glScaled w h d)
  (glutSolidCube 1.0)
  (glPopMatrix))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *width*  800)
(define *height* 600)

(glutReshapeFunc
 (lambda (w h)

   (set! *width*  w)
   (set! *height* h)

   (glEnable GL_POINT_SMOOTH)
   (glEnable GL_LINE_SMOOTH)
   (glEnable GL_POLYGON_SMOOTH)

   (glEnable GL_BLEND)
   (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)

   (glViewport 0 0 w h)

   (glMatrixMode GL_PROJECTION)
   (glLoadIdentity)

   (gluPerspective 90.0 (inexact (/ *width* *height*)) 0.0 4000.0)

   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *depth* 400)

(define *frame-count* 0.0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutDisplayFunc

 (lambda ()

   (glClearColor 0.0588 0.0588 0.0588 1.0)

   (glClear GL_COLOR_BUFFER_BIT)

   (glMatrixMode GL_MODELVIEW)

   (glLoadIdentity)

   ;; viewing

   (glTranslated 0.0 0.0 -1000.0)
   
   (glRotated (* *frame-count* 1.0) 0.0 1.0 0.0)

   ;; modeling

   (do-times 10
           
     (lambda (i)

       (glRotated (* *frame-count* 0.1) 1.0 0.0 0.0)

       (do ((y -2.0 (+ y 1))) ((>= y 2))

         (do ((x -2.0 (+ x 1))) ((>= x 2))

           (do ((z -2.0 (+ z 1))) ((>= z 2))

             (glPushMatrix)
             (glTranslated (* 400 x) (* 300 y) (* 300 z))
             (box 5.0 5.0 100.0)
             (glPopMatrix)

             (glPushMatrix)
             (glTranslated (* 400 x) (* 300 y) (* 50 z))
             (box 100.0 5.0 5.0)
             (glPopMatrix)

             (glPushMatrix)
             (glTranslated (* 400 x) (* 10 y) (* 50 z))
             (box 50.0 5.0 5.0)
             (glPopMatrix)

             (glPushMatrix)
             (glRotated (* *frame-count* 0.5) 0.0 1.0 0.0)
             (glTranslated (* 100 x) (* 300 y) (* 300 z))
             (box 60.0 40.0 20.0)
             (glPopMatrix))))))

   (set! *frame-count* (+ *frame-count* 1))

   (glutSwapBuffers)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutIdleFunc
 (lambda ()
   (glutPostRedisplay)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutMainLoop)

