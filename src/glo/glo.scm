
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "gl")

((-> loader 'lib) "glut")

((-> loader 'lib) "color/rgba")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (v- a b)
  (vec (- (-> a 'first)
	  (-> b 'first))
       (- (-> a 'second)
	  (-> b 'second))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (gl-ellipse center dim)

  (glPushMatrix)

  (glTranslated (-> center 'first) (-> center 'second) 0.0)

  (glScaled (-> dim 'first) (-> dim 'second) 1.0)

  (glutSolidSphere 0.5 32 16)

  (glPopMatrix))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (pen)

  (let ((pos (vec 0.0 0.0))

	(stroke-width 1.0)

	(stroke-color (rgba 1.0 1.0 1.0 1.0))
	(fill-color   (rgba 0.0 0.0 0.0 1.0)))

    (let ((activate-stroke-color
	   (lambda ()
	     ((-> stroke-color 'call-on-components) glColor4d)))

	  (activate-fill-color
	   (lambda ()
	     ((-> fill-color 'call-on-components) glColor4d))))

      (let ((ellipse

	     (lambda (dim)

	       (glPolygonMode GL_FRONT_AND_BACK GL_FILL)

	       (activate-stroke-color)

	       (gl-ellipse pos dim)
	       
	       (activate-fill-color)

	       (gl-ellipse pos 
			   (v- dim
			       (vec (* 2 stroke-width)
				    (* 2 stroke-width)))))))

	(let ((message-handler

	       (lambda (msg)

		 (case msg

		   ((move-to) (lambda (new) (set! pos new)))

		   ((set-stroke-color) (lambda (color) (set! stroke-color color)))
		   ((set-fill-color)   (lambda (color) (set! fill-color   color)))

		   ((set-stroke-width) (lambda (width) (set! stroke-width width)))

		   ((line)
		    (lambda (a b)
		      (activate-stroke-color)
		      (glBegin GL_LINES)
		      ((-> a 'call-on-components) glVertex2d)
		      ((-> b 'call-on-components) glVertex2d)
		      (glEnd)))

		   ((ellipse) ellipse)

		   ((circle)
		    (lambda (size)
		      (ellipse (vec size size))))

		   ))))

	  (vector 'pen #f message-handler))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (create-window title)

  (let ((id (glutCreateWindow title))

	(last-redisplay 0)

	(period 0))

    (let ((set-current (lambda () (glutSetWindow id))))

      (let ((message-handler

	     (lambda (msg)

	       (case msg

		 ((set-display-function)
		  (lambda (function)
		    (glutDisplayFunc function)))

		 ((set-position)
		  (lambda (pos)
		    (set-current)
		    (glutPositionWindow (-> pos 'first) (-> pos 'second))))

		 ((set-size)
		  (lambda (dim)
		    (set-current)
		    (glutReshapeWindow (-> dim 'first) (-> dim 'second))))

		 ((set-title)
		  (lambda (title)
		    (set-current)
		    (glutSetWindowTitle title)))

		 ((redisplay)
		  (set-current)
		  (glutPostRedisplay))

		 ((show)
		  (set-current)
		  (glutShowWindow))
		 
		 ((hide)
		  (set-current)
		  (glutHideWindow))
		 
		 ((iconify)
		  (set-current)
		  (glutIconifyWindow))

		 ((full-screen)
		  (set-current)
		  (glutFullScreen))

		 ((destroy)
		  (glutDestroyWindow id))

		 ;; callbacks

		 ((display-function)
		  (lambda (fun)
		    (set-current)
		    (glutDisplayFunc fun)))

		 ((reshape-function)
		  (lambda (fun)
		    (set-current)
		    (glutReshapeFunc fun)))

		 ;; special cases

		 ((ortho-2d)
		  (lambda (x-min x-max y-min y-max)
		    (set-current)
		    (glutReshapeFunc
		     (lambda (width height)
		       (glEnable GL_BLEND)
		       (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
		       (glViewport 0 0 width height)
		       (glMatrixMode GL_PROJECTION)
		       (glLoadIdentity)
		       (glOrtho x-min x-max y-min y-max -10.0 10.0)
		       (glMatrixMode GL_MODELVIEW)))))

		 ((ortho-standard)
		  (set-current)
		  (glutReshapeFunc
		   (lambda (width height)
		     (glEnable GL_BLEND)
		     (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
		     (glViewport 0 0 width height)
		     (glMatrixMode GL_PROJECTION)
		     (glLoadIdentity)
		     (glOrtho 0.0 (+ width 0.0)
			      (+ height 0.0) 0.0
			      -10.0 10.0)
		     (glMatrixMode GL_MODELVIEW))))

		 ;; redisplay

		 ((set-frame-rate)
		  (lambda (rate) ;; N frames per second
		    (set! period (* (/ 1.0 rate) 1000 1000))))

		 ((maybe-redisplay)
		  (if (> (- (microseconds) last-redisplay) period)
		      (begin
			(set-current)
			(set! last-redisplay (microseconds))
			(glutPostRedisplay))))

		 ))))

	(vector 'window #f message-handler)))))
