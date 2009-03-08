
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(case scheme-implementation

  ((ypsilon chicken) ((-> loader 'lib) "xlib/record/ypsilon")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define XExtData                       (xlib-record-template 'XExtData))
(define XExtCodes                      (xlib-record-template 'XExtCodes))
(define XPixmapFormatValues            (xlib-record-template 'XPixmapFormatValues))
(define XGCValues                      (xlib-record-template 'XGCValues))
(define Visual                         (xlib-record-template 'Visual))
(define Depth                          (xlib-record-template 'Depth))
(define Screen                         (xlib-record-template 'Screen))
(define ScreenFormat                   (xlib-record-template 'ScreenFormat))
(define XSetWindowAttributes           (xlib-record-template 'XSetWindowAttributes))
(define XWindowAttributes              (xlib-record-template 'XWindowAttributes))
(define XHostAddress                   (xlib-record-template 'XHostAddress))
(define XImage                         (xlib-record-template 'XImage))
(define XWindowChanges                 (xlib-record-template 'XWindowChanges))
(define XColor                         (xlib-record-template 'XColor))
(define XSegment                       (xlib-record-template 'XSegment))
(define XPoint                         (xlib-record-template 'XPoint))
(define XRectangle                     (xlib-record-template 'XRectangle))
(define XArc                           (xlib-record-template 'XArc))
(define XKeyboardControl               (xlib-record-template 'XKeyboardControl))
(define XKeyboardState                 (xlib-record-template 'XKeyboardState))
(define XTimeCoord                     (xlib-record-template 'XTimeCoord))
(define XModifierKeymap                (xlib-record-template 'XModifierKeymap))
(define XKeyReleasedEvent              (xlib-record-template 'XKeyReleasedEvent))
(define XKeyPressedEvent               (xlib-record-template 'XKeyPressedEvent))
(define XKeyEvent                      (xlib-record-template 'XKeyEvent))
(define XButtonReleasedEvent           (xlib-record-template 'XButtonReleasedEvent))
(define XButtonPressedEvent            (xlib-record-template 'XButtonPressedEvent))
(define XButtonEvent                   (xlib-record-template 'XButtonEvent))
(define XPointerMovedEvent             (xlib-record-template 'XPointerMovedEvent))
(define XMotionEvent                   (xlib-record-template 'XMotionEvent))
(define XLeaveWindowEvent              (xlib-record-template 'XLeaveWindowEvent))
(define XEnterWindowEvent              (xlib-record-template 'XEnterWindowEvent))
(define XCrossingEvent                 (xlib-record-template 'XCrossingEvent))
(define XFocusOutEvent                 (xlib-record-template 'XFocusOutEvent))
(define XFocusInEvent                  (xlib-record-template 'XFocusInEvent))
(define XFocusChangeEvent              (xlib-record-template 'XFocusChangeEvent))
(define XKeymapEvent                   (xlib-record-template 'XKeymapEvent))
(define XExposeEvent                   (xlib-record-template 'XExposeEvent))
(define XGraphicsExposeEvent           (xlib-record-template 'XGraphicsExposeEvent))
(define XNoExposeEvent                 (xlib-record-template 'XNoExposeEvent))
(define XVisibilityEvent               (xlib-record-template 'XVisibilityEvent))
(define XCreateWindowEvent             (xlib-record-template 'XCreateWindowEvent))
(define XDestroyWindowEvent            (xlib-record-template 'XDestroyWindowEvent))
(define XUnmapEvent                    (xlib-record-template 'XUnmapEvent))
(define XMapEvent                      (xlib-record-template 'XMapEvent))
(define XMapRequestEvent               (xlib-record-template 'XMapRequestEvent))
(define XReparentEvent                 (xlib-record-template 'XReparentEvent))
(define XConfigureEvent                (xlib-record-template 'XConfigureEvent))
(define XGravityEvent                  (xlib-record-template 'XGravityEvent))
(define XResizeRequestEvent            (xlib-record-template 'XResizeRequestEvent))
(define XConfigureRequestEvent         (xlib-record-template 'XConfigureRequestEvent))
(define XCirculateEvent                (xlib-record-template 'XCirculateEvent))
(define XCirculateRequestEvent         (xlib-record-template 'XCirculateRequestEvent))
(define XPropertyEvent                 (xlib-record-template 'XPropertyEvent))
(define XSelectionClearEvent           (xlib-record-template 'XSelectionClearEvent))
(define XSelectionRequestEvent         (xlib-record-template 'XSelectionRequestEvent))
(define XSelectionEvent                (xlib-record-template 'XSelectionEvent))
(define XColormapEvent                 (xlib-record-template 'XColormapEvent))
(define XClientMessageEvent            (xlib-record-template 'XClientMessageEvent))
(define XMappingEvent                  (xlib-record-template 'XMappingEvent))
(define XErrorEvent                    (xlib-record-template 'XErrorEvent))
(define XAnyEvent                      (xlib-record-template 'XAnyEvent))
(define XCharStruct                    (xlib-record-template 'XCharStruct))
(define XFontProp                      (xlib-record-template 'XFontProp))
(define XFontStruct                    (xlib-record-template 'XFontStruct))
(define XTextItem                      (xlib-record-template 'XTextItem))
(define XChar2b                        (xlib-record-template 'XChar2b))
(define XTextItem16                    (xlib-record-template 'XTextItem16))
(define XFontSetExtents                (xlib-record-template 'XFontSetExtents))
(define XmbTextItem                    (xlib-record-template 'XmbTextItem))
(define XwcTextItem                    (xlib-record-template 'XwcTextItem))
(define XIMStyles                      (xlib-record-template 'XIMStyles))
(define XIMCallback                    (xlib-record-template 'XIMCallback))
(define XIMText                        (xlib-record-template 'XIMText))
(define XIMPreeditDrawCallbackStruct   (xlib-record-template 'XIMPreeditDrawCallbackStruct))
(define XIMPreeditCaretCallbackStruct  (xlib-record-template 'XIMPreeditCaretCallbackStruct))
(define XIMStatusDrawCallbackStruct    (xlib-record-template 'XIMStatusDrawCallbackStruct))
(define XSizeHints                     (xlib-record-template 'XSizeHints))
(define XWMHints                       (xlib-record-template 'XWMHints))
(define XTextProperty                  (xlib-record-template 'XTextProperty))
(define XIconSize                      (xlib-record-template 'XIconSize))
(define XClassHint                     (xlib-record-template 'XClassHint))
(define XComposeStatus                 (xlib-record-template 'XComposeStatus))
(define XVisualInfo                    (xlib-record-template 'XVisualInfo))
(define XStandardColormap              (xlib-record-template 'XStandardColormap))
(define XEvent                         (xlib-record-template 'XEvent))
(define XEDataObject                   (xlib-record-template 'XEDataObject))
