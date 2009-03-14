
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "record")
((-> loader 'lib) "hvec")
((-> loader 'lib) "hashtable-obj")

(display "Loading xlib...")
((-> loader 'lib) "xlib")
(display "complete\n")

((-> loader 'lib) "xlib/keysym")
((-> loader 'lib) "xlib/record")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (c-false? val) (= val 0))
(define (c-true?  val) (not (c-false? val)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define dpy    #f)
(define screen #f)
(define root   #f)

(define clients (hashtable-obj (make-eq-hashtable)))

(define selected #f)

(define num-lock-mask 0)

(define (clean-mask mask)
  (bitwise-and mask (bitwise-not (bitwise-ior num-lock-mask LockMask))))

(define move-cursor   #f)
(define resize-cursor #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define border-width 5)

(define normal-border-color   "#cccccc")
(define selected-border-color "#0066ff")

(define mod-key Mod4Mask)

(define use-grab #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define key-record-template
  (record-template-obj 'key (vec-from-list '(mod keysym procedure))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define button-record-template
  (record-template-obj 'button (vec-from-list '(click mask button procedure))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define button-mask (bitwise-ior ButtonPressMask ButtonReleaseMask))

(define mouse-mask  (bitwise-ior button-mask PointerMotionMask))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define get-color
  (let ((color (: XColor 'new)))
    (lambda (name)
      (let ((colormap (XDefaultColormap dpy screen)))
        (XAllocNamedColor dpy colormap name (: color 'ptr) (: color 'ptr))
        (get color 'pixel)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (button-press e)

  (display "  inside button-press\n")

  (let ((ev (: XButtonEvent 'make (: e 'ptr)))
        (click #f))

    (set! click 'click-root-window)

    (cond ((: clients 'ref (get ev 'window)) =>
           (lambda (client)
             (focus client)
             (set! click 'click-client-window))))

    ((-> buttons 'each)
     
     (lambda (button)

       (display "step through buttons\n")

       (display button)
       (newline)

       (if (and (eq? click (get button 'click))

                (get button 'procedure)

                (= (get button 'button)
                   (get ev     'button))

                (= (clean-mask (get button 'mask))
                   (clean-mask (get ev 'state))))

           ((get button 'procedure)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (key-press e)
  (let ((ev (: XKeyEvent 'make (: e 'ptr))))
    (let ((keysym (XKeycodeToKeysym dpy (get ev 'keycode) 0)))
      ((-> keys 'each)
       (lambda (key)
         (if (and (= keysym (get key 'keysym))
                  (= (clean-mask (get key 'mod))
                     (clean-mask (get ev  'state)))
                  (get key 'procedure))
             ((get key 'procedure))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define configure-request

  (let ((wc (: XWindowChanges 'new)))

    (lambda (e)

      (let ((ev (: XConfigureRequestEvent 'make (: e 'ptr))))

        (set wc 'x            (get ev 'x))
        (set wc 'y            (get ev 'y))
        (set wc 'width        (get ev 'width))
        (set wc 'height       (get ev 'height))
        (set wc 'border_width (get ev 'border_width))
        (set wc 'sibling      (get ev 'above))
        (set wc 'stack_mode   (get ev 'detail))

        (XConfigureWindow dpy (get ev 'window) (get ev 'value_mask) (: wc 'ptr))

        (XSync dpy False)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (destroy-notify e)
  (let ((ev (: XDestroyWindowEvent 'make (: e 'ptr))))
    (let ((client (: clients 'ref (get ev 'window))))
      (if client
          (: clients 'delete client)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (grab-buttons client focused)

  ;; (display "inside grab-buttons\n")

  ;; (update-numlock-mask)

  (let ((modifiers (vec 0 LockMask num-lock-mask (bitwise-ior num-lock-mask
                                                              LockMask))))

    (XUngrabButton dpy AnyButton AnyModifier client)

    (if focused

        ((-> buttons 'each)
         (lambda (button)
           (if (eq? (get button 'click) 'click-client-window)
               ((-> modifiers 'each)
                (lambda (modifier)
                  (XGrabButton dpy
                               (get button 'button)
                               (bitwise-ior (get button 'mask) modifier)
                               client
                               False button-mask GrabModeAsync GrabModeSync None
                               None))))))
        
        (XGrabButton dpy AnyButton AnyModifier client False button-mask
                     GrabModeAsync GrabModeSync None None))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (grab-keys)
  (let ((modifiers (vec 0 LockMask num-lock-mask (bitwise-ior num-lock-mask
                                                              LockMask))))
    (XUngrabKey dpy AnyKey AnyModifier root)
    ((-> keys 'each)
     (lambda (key)
       (cond ((XKeysymToKeycode dpy (get key 'keysym)) =>
              (lambda (code)
                ;; Kludge for now. Some FFIs return a Scheme char, others a number.
                (let ((code (if (char? code) (char->integer code) code)))
                  ((-> modifiers 'each)
                   (lambda (modifier)
                     (XGrabKey dpy code (bitwise-ior (get key 'mod) modifier)
                               root True GrabModeAsync GrabModeAsync)))))))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (focus-in ev)
  (let ((ev (: XFocusChangeEvent 'make (: ev 'ptr))))
    (if (and selected
             (not (= (get ev 'window)
                     selected)))
        (XSetInputFocus dpy selected RevertToPointerRoot CurrentTime))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (focus client)

  (display "inside focus\n")

  (if (and selected (not (equal? client selected)))
      (begin (display "  branch taken\n")
             (grab-buttons selected #f)
             (display "  grab-buttons returned\n")
             (XSetWindowBorder dpy selected (get-color normal-border-color))
             (display "  XSetWindowBorder returned\n")
             ))

  (cond (client (grab-buttons client #t)
                (XSetWindowBorder dpy client (get-color selected-border-color))
                (XSetInputFocus   dpy client RevertToPointerRoot CurrentTime))

        (else (XSetInputFocus dpy root RevertToPointerRoot CurrentTime)))

  (set! selected client))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (enter-notify ev)

  (display "inside enter-notify\n")

  (let ((ev (: XCrossingEvent 'make (: ev 'ptr))))

    (cond ((and (or (not (= (get ev 'mode)   NotifyNormal))
                         (= (get ev 'detail) NotifyInferior))
                (not (= (get ev 'window) root)))
           #t)

          ((: clients 'ref (get ev 'window)) => focus)

          (else (focus #f)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (manage id)

  ;; (display "inside manage\n")

  (XSetWindowBorderWidth dpy id border-width)

  (XSetWindowBorder dpy id (get-color normal-border-color))

  (XSelectInput dpy id (bitwise-ior EnterWindowMask
                                    FocusChangeMask
                                    PropertyChangeMask
                                    StructureNotifyMask))

  (grab-buttons id #f)

  (: clients 'set id id)

  ;; (display "clients: ")
  ;; (display (: clients 'keys))
  ;; (newline)

  (XMapWindow dpy id)

  (XSync dpy False)

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define map-request
  (let ((wa (: XWindowAttributes 'new)))
    (lambda (ev)

      (display "inside map-request\n")

      (let ((ev (: XMapRequestEvent 'make (: ev 'ptr))))
      
        (cond ((c-false? (XGetWindowAttributes dpy (get ev 'window) (: wa 'ptr)))
               (display "  map-request: result of XGetWindowAttributes is 0\n")
               #t)
              
              ((not (= 0 (get wa 'override_redirect))) #f)
              ((not (: clients 'ref (get ev 'window)))
               (manage (get ev 'window)))

              (else
               (display "  map-request: taking else branch\n"))
               
              )))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (move-mouse)

  (display "  inside move-mouse\n")

  (let ((client #f))

    (set! client selected)

    (cond ((not client) #t)

          ((not (= (XGrabPointer dpy root False mouse-mask
                                 GrabModeAsync GrabModeAsync
                                 None move-cursor CurrentTime)
                   GrabSuccess))
           #t)

          (else

           ;; (let ((not-needed/window       (make-bytevector 4))
           ;;       (not-needed/int          (make-bytevector 4))
           ;;       (not-needed/unsigned-int (make-bytevector 4))
           ;;       (x-return (make-bytevector 4))
           ;;       (y-return (make-bytevector 4)))

           ;;   (XQueryPointer dpy root
           ;;                  not-needed/window
           ;;                  not-needed/window
           ;;                  x-return
           ;;                  y-return
           ;;                  not-needed/int
           ;;                  not-needed/int
           ;;                  not-needed/unsigned-int)

           (let ((not-needed/window       (u32-vec 0))
                 (not-needed/int          (s32-vec 0))
                 (not-needed/unsigned-int (u32-vec 0))
                 (x-return                (s32-vec 0))
                 (y-return                (s32-vec 0)))

             (XQueryPointer dpy root
                            (: not-needed/window 'ffi)
                            (: not-needed/window 'ffi)
                            (: x-return 'ffi)
                            (: y-return 'ffi)
                            (: not-needed/int 'ffi)
                            (: not-needed/int 'ffi)
                            (: not-needed/unsigned-int 'ffi))

             (if use-grab (XGrabServer dpy))

             (let ((ev (: XAnyEvent 'make (make-XEvent))))

               (let loop ()

                 (XMaskEvent dpy
                             (bitwise-ior mouse-mask
                                          ExposureMask
                                          SubstructureRedirectMask)
                             (: ev 'ptr))

                 (cond ((or (= (get ev 'type) ConfigureRequest)
                            (= (get ev 'type) Expose)
                            (= (get ev 'type) MapRequest))

                        ((: handlers 'ref (get ev 'type)) ev))

                       ((= (get ev 'type) MotionNotify)

                        (let ((ev (: XMotionEvent 'make (: ev 'ptr))))

                          (XMoveWindow dpy client (get ev 'x) (get ev 'y))
                          (XSync dpy False))))
                        


                 (if (not (= (get ev 'type) ButtonRelease))
                     (loop)))))

           (if use-grab (XUngrabServer dpy))

           (XUngrabPointer dpy CurrentTime)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (resize-mouse)

  (let ((client #f))

    (set! client selected)

    (cond ((not client) #t)

          ((not (= (XGrabPointer dpy root False mouse-mask
                                 GrabModeAsync GrabModeAsync
                                 None resize-cursor CurrentTime)
                   GrabSuccess))
           #t)

          (else

           ;; (XWarpPointer dpy None id 0 0 0 0 ...)

           (if use-grab (XGrabServer dpy))

           (let ((ev (: XAnyEvent 'make (make-XEvent))))

             (let loop ()

               (XMaskEvent dpy
                           (bitwise-ior mouse-mask
                                        ExposureMask
                                        SubstructureRedirectMask)
                           (: ev 'ptr))

               (cond ((or (= (get ev 'type) ConfigureRequest)
                          (= (get ev 'type) Expose)
                          (= (get ev 'type) MapRequest))

                      ((: handlers 'ref (get ev 'type)) ev))

                     ((= (get ev 'type) MotionNotify)

                      (let ((ev (: XMotionEvent 'make (: ev 'ptr))))

                        (let ((x #f)
                              (y #f))

                          (let ((x-return   (s32-vec 0))
                                (y-return   (s32-vec 0)))
                            
                            (XGetGeometry dpy client
                                          (: (u32-vec 0) 'ffi)
                                          (: x-return 'ffi)
                                          (: y-return 'ffi)
                                          (: (u32-vec 0) 'ffi)
                                          (: (u32-vec 0) 'ffi)
                                          (: (u32-vec 0) 'ffi)
                                          (: (u32-vec 0) 'ffi))
                            
                            ;; (set! x (bytevector-c-int-ref x-return 0))
                            ;; (set! y (bytevector-c-int-ref y-return 0))

                            ;; (set! x (bytevector-s32-native-ref x-return 0))
                            ;; (set! y (bytevector-s32-native-ref y-return 0))

                            (set! x (: x-return 'ref 0))
                            (set! y (: y-return 'ref 0))
                            
                            )

                          (let ((new-width  (- (get ev 'x) x))
                                (new-height (- (get ev 'y) y)))

                            (XResizeWindow dpy client new-width new-height)

                            (XSync dpy False))))))

               (if (not (= (get ev 'type) ButtonRelease))
                   (loop))))

           (if use-grab (XUngrabServer dpy))

           (XUngrabPointer dpy CurrentTime)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define handlers (vec-of-len LASTEvent))

(: handlers 'set ButtonPress button-press)

(: handlers 'set ConfigureRequest configure-request)

(: handlers 'set DestroyNotify destroy-notify)

(: handlers 'set EnterNotify enter-notify)

(: handlers 'set FocusIn focus-in)

(: handlers 'set KeyPress key-press)

(: handlers 'set MapRequest map-request)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define run
  (let ((ev (: XAnyEvent 'make (make-XEvent))))
    (lambda ()
      (XSync dpy False)
      (let loop ()
        (XNextEvent dpy (: ev 'ptr))

        (display "received event type ")
        (display (get ev 'type))
        (newline)
        
        (let ((handler (: handlers 'ref (get ev 'type))))
          (if handler
              (handler ev)
              (begin
                (display "No entry in 'handlers' for event type ")
                (display (get ev 'type))
                (newline))))
        (loop)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Workspaces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(: loader 'lib "gro")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define x-window-is-viewable?
  (let ((wa (: XWindowAttributes 'new)))
    (lambda (dpy win)
      (XGetWindowAttributes dpy win (: wa 'ptr))
      (= (get wa 'map_state) IsViewable))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (mapped-clients)

  (let ((root-children (vec-obj (x-query-tree-children dpy root))))

    (let ((viewable-root-children
           (: root-children 'filter
              (lambda (id)
                (x-window-is-viewable? dpy id)))))
      
      (let ((viewable-clients
             (: viewable-root-children 'filter
                (lambda (id)
                  (: clients 'contains? id)))))

        viewable-clients))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define workspaces (vec-of-len 10))

(define current-workspace 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define switch-to-workspace

  (let ((unmap-client
         (lambda (id)
           (XUnmapWindow dpy id)))

        (map-client
         (lambda (id)
           (XMapWindow dpy id))))

    (lambda (i)

      (: workspaces 'set current-workspace (mapped-clients))

      (: (mapped-clients) 'each unmap-client)

      (if (: workspaces 'ref i)
          (: (: workspaces 'ref i) 'each map-client))

      (set! current-workspace i))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; more config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define MODKEY Mod4Mask)

(define keys
  (let ((key (-> key-record-template 'boa)))
    (vec
     
     (key MODKEY XK_Return (lambda () (system "rxvt &")))
     (key MODKEY XK_e      (lambda () (system "emacsclient -c &")))
     (key MODKEY XK_w      (lambda () (system "seamonkey &")))
     (key MODKEY XK_m      (lambda () (system "seamonkey -mail &")))

     (key mod-key XK_1 (lambda () (switch-to-workspace 1)))
     (key mod-key XK_2 (lambda () (switch-to-workspace 2)))
     (key mod-key XK_3 (lambda () (switch-to-workspace 3)))
     (key mod-key XK_4 (lambda () (switch-to-workspace 4)))
     (key mod-key XK_5 (lambda () (switch-to-workspace 5)))
     (key mod-key XK_6 (lambda () (switch-to-workspace 6)))
     (key mod-key XK_7 (lambda () (switch-to-workspace 7)))
     (key mod-key XK_8 (lambda () (switch-to-workspace 8)))
     (key mod-key XK_9 (lambda () (switch-to-workspace 9)))
     (key mod-key XK_0 (lambda () (switch-to-workspace 0)))

     )))
          

(define buttons

  (let ((button (-> button-record-template 'boa)))

    (vec

     (button 'click-client-window mod-key Button1 move-mouse)
     (button 'click-client-window mod-key Button3 resize-mouse))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set! dpy (XOpenDisplay #f))

(set! screen (XDefaultScreen dpy))

(set! root (XRootWindow dpy screen))

(set! move-cursor   (XCreateFontCursor dpy XC_fleur))
(set! resize-cursor (XCreateFontCursor dpy XC_sizing))

(XSelectInput dpy root (bitwise-ior SubstructureRedirectMask
                                    SubstructureNotifyMask
                                    ButtonPressMask
                                    EnterWindowMask
                                    LeaveWindowMask
                                    StructureNotifyMask
                                    PropertyChangeMask))

(grab-keys)

(XSetErrorHandler (lambda (dpy ee)
                    (display "Error handler called\n")
                    1))

(display "cons-wm is setup\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(run)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
