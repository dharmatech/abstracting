
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "math")

((-> loader 'lib) "glo")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutInit (vector 0) (vector ""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutInitWindowPosition 100 100)
(glutInitWindowSize 500 500)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(let ((win (create-window "Golden Section")))

  ((-> win 'ortho-2d) -400.0 400.0 -400.0 400.0)

  ((-> win 'display-function)

   (let ((pen (pen)))

    ((-> pen 'set-stroke-color) (rgba 0.0 0.0 0.0 1.0))

    (let ((move-to          (-> pen 'move-to))
	  (set-fill-color   (-> pen 'set-fill-color))
	  (circle           (-> pen 'circle))
	  (set-stroke-width (-> pen 'set-stroke-width)))

      (lambda ()

	(glClearColor 1.0 1.0 1.0 1.0)

	(glClear GL_COLOR_BUFFER_BIT)

	(for 720

	     (lambda (i)

	       (let ((i (+ i 0.0)))

		 (let ((x (* 0.5 i (cos (* 2 pi (- phi 1) i))))
		       (y (* 0.5 i (sin (* 2 pi (- phi 1) i))))

		       (radius (* 15 (sin (/ (* i pi) 720)))))

		   (let ((diameter (* radius 2)))

		     (set-fill-color (rgba (/ i 360.0) (/ i 360.0) 0.25 1.0))
		       
		     (move-to (vec x y))

		     (set-stroke-width (* diameter 0.15))

		     (circle diameter)))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutMainLoop)