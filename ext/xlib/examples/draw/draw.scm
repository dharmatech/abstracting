
(: loader 'lib "xlib")

(let ((dpy (XOpenDisplay #f)))

  (let ((screen (XDefaultScreen dpy)))

    (let ((root (XRootWindow dpy screen))
          (gc   (XDefaultGC  dpy screen)))

      (let ((win (XCreateSimpleWindow dpy root 100 100 300 300 0 0 0))
            (ev (make-XEvent)))

        (XMapWindow dpy win)

        (XSelectInput dpy win (bitwise-ior ExposureMask
                                           ButtonPressMask))

        (XSetForeground dpy gc (XWhitePixel dpy screen))

        (let loop ()

          (XNextEvent dpy ev)

          (let ((type (XAnyEvent-type ev)))

            (cond ((eq? type Expose)
                   (display "Expose event received\n")
                   (XDrawLine dpy win gc 10 10 90 10)
                   (XDrawLine dpy win gc 90 90 90 10)
                   (XDrawLine dpy win gc 10 90 90 90)
                   (XDrawLine dpy win gc 10 10 10 90))

                  ((eq? type ButtonPress)
                   (display "ButtonPress event received\n"))))

          (XFlush dpy)

          (loop))))))

