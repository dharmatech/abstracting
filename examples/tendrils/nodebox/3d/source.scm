
(define triangle

  (case-lambda

   ((x0 y0 z0 x1 y1 z1 x2 y2 z2)

    (let ((vertices
           (lambda ()
             (glVertex3d x0 y0 z0)
             (glVertex3d x1 y1 z1)
             (glVertex3d x2 y2 z2))))

      (: *fill-color* 'apply glColor4d)
      (glBegin GL_POLYGON)
      (vertices)
      (glEnd)

      (: *stroke-color* 'apply glColor4d)
      (glBegin GL_LINE_LOOP)
      (vertices)
      (glEnd)))

   ((a b c)
    (triangle (x a) (y a) (z a) (x b) (y b) (z b) (x c) (y c) (z c)))))