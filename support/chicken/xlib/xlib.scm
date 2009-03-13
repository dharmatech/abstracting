;; -*-scheme-*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compile with:
;;
;; csc xlib.scm -dynamic -L/usr/X11R7/lib -lX11 -I/usr/X11R7/include
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (typedef type alias)
  `(define-foreign-type ,alias ,type))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (c-structure name . fields)
  (let ((constructor-name
         (string->symbol
          (string-append "make-"
                         (symbol->string name)))))
    `(define-foreign-record ,name
       (constructor: ,constructor-name)
       ,@fields)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (c-function return-type name parameter-types)
  `(define ,name
     (foreign-lambda ,return-type ,name ,@parameter-types)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; typedefs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(typedef c-pointer void*)
(typedef c-string  char*)

;; (typedef (c-pointer int)           int*)
;; (typedef (c-pointer unsigned-int)  unsigned-int*)
;; (typedef (c-pointer unsigned-long) unsigned-long*)

(typedef s32vector int*)
(typedef u32vector unsigned-int*)
(typedef u32vector unsigned-long*)

(typedef void* char**)
(typedef void* char***)

(typedef void* unsigned-char*)
(typedef void* unsigned-char**)

(typedef char* const-char*)

(typedef void* const-unsigned-char*)

(use lolevel)

(define (make-XEvent) (allocate 96))

(typedef int Bool)
(typedef unsigned-long XID)
(typedef unsigned-long Mask)
(typedef unsigned-long Atom)
(typedef unsigned-long VisualID)
(typedef unsigned-long Time)
(typedef XID Window)
(typedef XID Drawable)
(typedef XID Font)
(typedef XID Pixmap)
(typedef XID Cursor)
(typedef XID Colormap)
(typedef XID GContext)
(typedef XID KeySym)

;; Override so that we get numbers for KeyCode
;; (typedef unsigned-char KeyCode)
(typedef unsigned-int KeyCode)

(typedef void* Display*)
(typedef void* XExtData*)
(typedef void* Visual*)
(typedef void* Depth*)
(typedef void* Screen*)
(typedef void* KeyCode*)
(typedef void* XCharStruct*)
(typedef void* XChar2b*)
(typedef void* GC)
(typedef void* XFontSet)
(typedef void* XIM)
(typedef void* XIC)
(typedef void* XFontStruct*)
(typedef void* XTimeCoord*)
(typedef void* XModifierKeymap*)
(typedef void* XImage*)
(typedef void* Colormap*)
(typedef void* Atom*)
(typedef void* XHostAddress*)
(typedef void* XExtCodes*)
(typedef void* XPixmapFormatValues*)
(typedef void* XFontSetExtents*)
(typedef void* wchar_t*)
(typedef int Status)
(typedef void* Atom**)
(typedef void* Bool*)
(typedef void* const-wchar_t*)
(typedef void* const-XChar2b*)
(typedef void* int**)
(typedef void* KeySym*)
(typedef void* Pixmap*)
(typedef void* Status*)
(typedef unsigned-long* Window*)
(typedef void* Window**)
(typedef void* XArc*)
(typedef void* XColor*)
(typedef void* XColor-const-*)
(typedef void* XEvent*)
(typedef void* _XExtData**)
(typedef void* XExtData**)
(typedef void* XFontStruct**)
(typedef void* XFontStruct***)
(typedef void* XGCValues*)
(typedef void* XKeyboardControl*)
(typedef void* XKeyboardState*)
(typedef void* XKeyEvent*)
(typedef void* XKeyPressedEvent*)
(typedef void* XMappingEvent*)
(typedef void* XmbTextItem*)
(typedef void* XPoint*)
(typedef void* XRectangle*)
(typedef void* _XrmHashBucketRec*)
(typedef void* XSegment*)
(typedef void* XSetWindowAttributes*)
(typedef void* XTextItem*)
(typedef void* XTextItem16*)
(typedef void* XwcTextItem*)
(typedef void* XWindowAttributes*)
(typedef void* XWindowChanges*)
(typedef void* XErrorEvent*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; structs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Commented items are not yet converted. Please do so as needed!

;; /*
;;  * Extensions need a way to hang private data on some structures.
;;  */
;; typedef struct _XExtData {
;;  int number;     /* number returned by XRegisterExtension */
;;  struct _XExtData *next; /* next item on list of data for structure */
;;  int (*free_private)(    /* called to free private storage */
;;  struct _XExtData *extension
;;  );
;;  XPointer private_data;  /* data private to this extension. */
;; } XExtData;

(c-structure XExtCodes
             (int extension)
             (int major_opcode)
             (int first_event)
             (int first_error))

(c-structure XPixmapFormatValues
             (int depth)
             (int bits_per_pixel)
             (int scanline_pad))

(c-structure XGCValues
             (int function)
             (unsigned-long plane_mask)
             (unsigned-long foreground)
             (unsigned-long background)
             (int line_width)
             (int line_style)
             (int cap_style)

             (int join_style)
             (int fill_style)

             (int fill_rule)
             (int arc_mode)
             (Pixmap tile)
             (Pixmap stipple)
             (int ts_x_origin)
             (int ts_y_origin)
             (Font font)
             (int subwindow_mode)
             (Bool graphics_exposures)
             (int clip_x_origin)
             (int clip_y_origin)
             (Pixmap clip_mask)
             (int dash_offset)
             (char dashes))

;; /*
;;  * Graphics context.  The contents of this structure are implementation
;;  * dependent.  A GC should be treated as opaque by application code.
;;  */

;; typedef struct _XGC
;; #ifdef XLIB_ILLEGAL_ACCESS
;; {
;;     XExtData *ext_data;  /* hook for extension to hang data */
;;     GContext gid;    /* protocol ID for graphics context */
;;     /* there is more to this structure, but it is private to Xlib */
;; }
;; #endif
;; *GC;

(c-structure Visual
             (XExtData* ext_data)
             (VisualID visualid)
             (int class)
             (unsigned-long red_mask)
             (unsigned-long green_mask)
             (unsigned-long blue_mask)
             (int bits_per_rgb)
             (int map_entries))

(c-structure Depth
             (int depth)
             (int nvisuals)
             (Visual* visuals))

(c-structure Screen
             (XExtData* ext_data)
             (Display*  display)
             (Window root)
             (int width)
             (int height)
             (int mwidth)
             (int mheight)
             (int ndepths)
             (Depth* depths)
             (int root_depth)
             (Visual* root_visual)
             (GC default_gc)
             (Colormap cmap)
             (unsigned-long white_pixel)
             (unsigned-long black_pixel)
             (int max_maps)
             (int min_maps)
             (int backing_store)
             (Bool save_unders)
             (long root_input_mask))

(c-structure ScreenFormat
             (XExtData* ext_data)
             (int depth)
             (int bits_per_pixel)
             (int scanline_pad))

(c-structure XSetWindowAttributes
             (Pixmap background_pixmap)
             (unsigned-long background_pixel)
             (Pixmap border_pixmap)
             (unsigned-long border_pixel)
             (int bit_gravity)
             (int win_gravity)
             (int backing_store)
             (unsigned-long backing_planes)
             (unsigned-long backing_pixel)
             (Bool save_under)
             (long event_mask)
             (long do_not_propagate_mask)
             (Bool override_redirect)
             (Colormap colormap)
             (Cursor cursor))

(c-structure XWindowAttributes
             (int x)
             (int y)
             (int width)
             (int height)
             (int border_width)
             (int depth)
             (Visual* visual)
             (Window root)
             (int class)
             (int bit_gravity)
             (int win_gravity)
             (int backing_store)
             (unsigned-long backing_planes)
             (unsigned-long backing_pixel)
             (Bool save_under)
             (Colormap colormap)
             (Bool map_installed)
             (int map_state)
             (long all_event_masks)
             (long your_event_mask)
             (long do_not_propagate_mask)
             (Bool override_redirect)
             (Screen* screen))

(c-structure XHostAddress
             (int family)
             (int length)
             (char* address))

(c-structure XServerInterpretedAddress
             (int typelength)
             (int valuelength)
             (char* type)
             (char* value))

;; /*
;;  * Data structure for "image" data, used by image manipulation routines.
;;  */
;; typedef struct _XImage {
;;     int width, height;       /* size of image */
;;     int xoffset;     /* number of pixels offset in X direction */
;;     int format;          /* XYBitmap, XYPixmap, ZPixmap */
;;     char* data;          /* pointer to image data */
;;     int byte_order;      /* data byte order, LSBFirst, MSBFirst */
;;     int bitmap_unit;     /* quant. of scanline 8, 16, 32 */
;;     int bitmap_bit_order;    /* LSBFirst, MSBFirst */
;;     int bitmap_pad;      /* 8, 16, 32 either XY or ZPixmap */
;;     int depth;           /* depth of image */
;;     int bytes_per_line;      /* accelarator to next line */
;;     int bits_per_pixel;      /* bits per pixel (ZPixmap) */
;;     unsigned-long red_mask;  /* bits in z arrangment */
;;     unsigned-long green_mask;
;;     unsigned-long blue_mask;
;;     XPointer obdata;     /* hook for the object routines to hang on */
;;     struct funcs {       /* image manipulation routines */
;;  struct _XImage *(*create_image)(
;;      struct _XDisplay* /* display */,
;;      Visual*     /* visual */,
;;      unsigned int    /* depth */,
;;      int     /* format */,
;;      int     /* offset */,
;;      char*       /* data */,
;;      unsigned int    /* width */,
;;      unsigned int    /* height */,
;;      int     /* bitmap_pad */,
;;      int     /* bytes_per_line */);
;;  int (*destroy_image)        (struct _XImage *);
;;  unsigned-long (*get_pixel)  (struct _XImage *, int, int);
;;  int (*put_pixel)            (struct _XImage *, int, int, unsigned-long);
;;  struct _XImage *(*sub_image)(struct _XImage *, int, int, unsigned int, unsigned int);
;;  int (*add_pixel)            (struct _XImage *, long);
;;  } f;
;; } XImage;

(c-structure XWindowChanges
             (int x)
             (int y)
             (int width)
             (int height)
             (int border_width)
             (Window sibling)
             (int stack_mode))

(c-structure XColor
             (unsigned-long pixel)
             (unsigned-short red)
             (unsigned-short green)
             (unsigned-short blue)
             (char flags)
             (char pad))

(c-structure XSegment
             (short x1)
             (short y1)
             (short x2)
             (short y2))

(c-structure XPoint
             (short x)
             (short y))

(c-structure XRectangle
             (short x)
             (short y)
             (unsigned-short width)
             (unsigned-short height))

(c-structure XArc
             (short x)
             (short y)
             (unsigned-short width)
             (unsigned-short height)
             (short angle1)
             (short angle2))

(c-structure XKeyboardControl
             (int key_click_percent)
             (int bell_percent)
             (int bell_pitch)
             (int bell_duration)
             (int led)
             (int led_mode)
             (int key)
             (int auto_repeat_mode))

;; (c-structure XKeyboardState 
;;              (int key_click_percent)
;;              (int bell_percent)
;;              (unsigned-int bell_pitch)
;;              (unsigned-int bell_duration)
;;              (unsigned-long led_mask)
;;              (int global_auto_repeat)
;;              char auto_repeats[32];
;;              )


(c-structure XTimeCoord
             (Time time)
             (short x)
             (short y))

(c-structure XModifierKeymap
             (int max_keypermod)
             (KeyCode* modifiermap))


;; /*
;;  * Display datatype maintaining display specific data.
;;  * The contents of this structure are implementation dependent.
;;  * A Display should be treated as opaque by application code.
;;  */
;; #ifndef XLIB_ILLEGAL_ACCESS
;; typedef struct _XDisplay Display;
;; #endif

;; struct _XPrivate;        /* Forward declare before use for C++ */
;; struct _XrmHashBucketRec;

;; typedef struct 
;; #ifdef XLIB_ILLEGAL_ACCESS
;; _XDisplay
;; #endif
;; {
;;  XExtData* ext_data; /* hook for extension to hang data */
;;  struct _XPrivate *private1;
;;  int fd;         /* Network socket. */
;;  int private2;
;;  int proto_major_version;/* major version of server's X protocol */
;;  int proto_minor_version;/* minor version of servers X protocol */
;;  char* vendor;       /* vendor of the server hardware */
;;         XID private3;
;;  XID private4;
;;  XID private5;
;;  int private6;
;;  XID (*resource_alloc)(  /* allocator function */
;;      struct _XDisplay*
;;  );
;;  int byte_order;     /* screen byte order, LSBFirst, MSBFirst */
;;  int bitmap_unit;    /* padding and data requirements */
;;  int bitmap_pad;     /* padding requirements on bitmaps */
;;  int bitmap_bit_order;   /* LeastSignificant or MostSignificant */
;;  int nformats;       /* number of pixmap formats in list */
;;  ScreenFormat *pixmap_format;    /* pixmap format list */
;;  int private8;
;;  int release;        /* release of the server */
;;  struct _XPrivate *private9, *private10;
;;  int qlen;       /* Length of input event queue */
;;  unsigned-long last_request_read; /* seq number of last event read */
;;  unsigned-long request;  /* sequence number of last request. */
;;  XPointer private11;
;;  XPointer private12;
;;  XPointer private13;
;;  XPointer private14;
;;  unsigned max_request_size; /* maximum number 32 bit words in request*/
;;  struct _XrmHashBucketRec *db;
;;  int (*private15)(
;;      struct _XDisplay*
;;      );
;;  char* display_name; /* "host:display" string used on this connect*/
;;  int default_screen; /* default screen for operations */
;;  int nscreens;       /* number of screens on this server*/
;;  Screen* screens;    /* pointer to list of screens */
;;  unsigned-long motion_buffer;    /* size of motion buffer */
;;  unsigned-long private16;
;;  int min_keycode;    /* minimum defined keycode */
;;  int max_keycode;    /* maximum defined keycode */
;;  XPointer private17;
;;  XPointer private18;
;;  int private19;
;;  char* xdefaults;    /* contents of defaults from server */
;;  /* there is more to this structure, but it is private to Xlib */
;; }
;; #ifdef XLIB_ILLEGAL_ACCESS
;; Display, 
;; #endif
;; *_XPrivDisplay;


(c-structure XKeyEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (Window root)
             (Window subwindow)
             (Time time)
             (int x)
             (int y)
             (int x_root)
             (int y_root)
             (unsigned-int state)
             (unsigned-int keycode)
             (Bool same_screen))

;; typedef XKeyEvent XKeyPressedEvent;
;; typedef XKeyEvent XKeyReleasedEvent;

(c-structure XButtonEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (Window root)
             (Window subwindow)
             (Time time)
             (int x)
             (int y)
             (int x_root)
             (int y_root)
             (unsigned-int state)
             (unsigned-int button)
             (Bool same_screen))

;; typedef XButtonEvent XButtonPressedEvent;
;; typedef XButtonEvent XButtonReleasedEvent;

(c-structure XMotionEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (Window root)
             (Window subwindow)
             (Time time)
             (int x)
             (int y)
             (int x_root)
             (int y_root)
             (unsigned-int state)
             (char is_hint)
             (Bool same_screen))

;; typedef XMotionEvent XPointerMovedEvent;

(c-structure XCrossingEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (Window root)
             (Window subwindow)
             (Time time)
             (int x)
             (int y)
             (int x_root)
             (int y_root)
             (int mode)
             (int detail)
             (Bool same_screen)
             (Bool focus)
             (unsigned-int state))

;; typedef XCrossingEvent XEnterWindowEvent;
;; typedef XCrossingEvent XLeaveWindowEvent;

(c-structure XFocusChangeEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (int mode)
             (int detail))

;; typedef XFocusChangeEvent XFocusInEvent;
;; typedef XFocusChangeEvent XFocusOutEvent;

;; (c-structure XKeymapEvent 
;;              (int type)
;;              (unsigned-long serial)
;;              (Bool send_event)
;;              (Display* display)
;;              (Window window)
;;              (char key_vector[32]))

(c-structure XExposeEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (int x)
             (int y)
             (int width)
             (int height)
             (int count))

(c-structure XGraphicsExposeEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Drawable drawable)
             (int x)
             (int y)
             (int width)
             (int height)
             (int count)
             (int major_code)
             (int minor_code)
             )



(c-structure XNoExposeEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Drawable drawable)
             (int major_code)
             (int minor_code)
             )



(c-structure XVisibilityEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (int state)
             )



(c-structure XCreateWindowEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window parent)
             (Window window)
             (int x)
             (int y)
             (int width)
             (int height)
             (int border_width)
             (Bool override_redirect)
             )



(c-structure XDestroyWindowEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window event)
             (Window window)
             )



(c-structure XUnmapEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window event)
             (Window window)
             (Bool from_configure)
             )



(c-structure XMapEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window event)
             (Window window)
             (Bool override_redirect)
             )



(c-structure XMapRequestEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window parent)
             (Window window)
             )



(c-structure XReparentEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window event)
             (Window window)
             (Window parent)
             (int x)
             (int y)
             (Bool override_redirect)
             )



(c-structure XConfigureEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window event)
             (Window window)
             (int x)
             (int y)
             (int width)
             (int height)
             (int border_width)
             (Window above)
             (Bool override_redirect)
             )



(c-structure XGravityEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window event)
             (Window window)
             (int x)
             (int y)
             )



(c-structure XResizeRequestEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (int width)
             (int height)
             )



(c-structure XConfigureRequestEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window parent)
             (Window window)
             (int x)
             (int y)
             (int width)
             (int height)
             (int border_width)
             (Window above)
             (int detail)
             (unsigned-long value_mask)
             )



(c-structure XCirculateEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window event)
             (Window window)
             (int place)
             )



(c-structure XCirculateRequestEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window parent)
             (Window window)
             (int place)
             )



(c-structure XPropertyEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (Atom atom)
             (Time time)
             (int state)
             )



(c-structure XSelectionClearEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (Atom selection)
             (Time time)
             )



(c-structure XSelectionRequestEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window owner)
             (Window requestor)
             (Atom selection)
             (Atom target)
             (Atom property)
             (Time time)
             )



(c-structure XSelectionEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window requestor)
             (Atom selection)
             (Atom target)
             (Atom property)
             (Time time)
             )



(c-structure XColormapEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (Colormap colormap)
             (Bool new)
             (int state)
             )



;; (c-structure XClientMessageEvent 
;; (int type)
;; (unsigned-long serial)
;; (Bool send_event)
;; (Display* display)
;; (Window window)
;; (Atom message_type)
;; (int format)
;;  union {
;;      char b[20];
;;      short s[10];
;;      long l[5];
;;      ) data;
;; } 



(c-structure XMappingEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             (int request)
             (int first_keycode)
             (int count)
             )



(c-structure XErrorEvent
             (int type)
             (Display* display)
             (XID resourceid)
             (unsigned-long serial)
             (unsigned-char error_code)
             (unsigned-char request_code)
             (unsigned-char minor_code)
             )



(c-structure XAnyEvent
             (int type)
             (unsigned-long serial)
             (Bool send_event)
             (Display* display)
             (Window window)
             )

;; /*
;;  * this union is defined so Xlib can always use the same sized
;;  * event structure internally, to avoid memory fragmentation.
;;  */
;; typedef union _XEvent {
;;         int type;        /* must not be changed; first element */
;;  XAnyEvent xany;
;;  XKeyEvent xkey;
;;  XButtonEvent xbutton;
;;  XMotionEvent xmotion;
;;  XCrossingEvent xcrossing;
;;  XFocusChangeEvent xfocus;
;;  XExposeEvent xexpose;
;;  XGraphicsExposeEvent xgraphicsexpose;
;;  XNoExposeEvent xnoexpose;
;;  XVisibilityEvent xvisibility;
;;  XCreateWindowEvent xcreatewindow;
;;  XDestroyWindowEvent xdestroywindow;
;;  XUnmapEvent xunmap;
;;  XMapEvent xmap;
;;  XMapRequestEvent xmaprequest;
;;  XReparentEvent xreparent;
;;  XConfigureEvent xconfigure;
;;  XGravityEvent xgravity;
;;  XResizeRequestEvent xresizerequest;
;;  XConfigureRequestEvent xconfigurerequest;
;;  XCirculateEvent xcirculate;
;;  XCirculateRequestEvent xcirculaterequest;
;;  XPropertyEvent xproperty;
;;  XSelectionClearEvent xselectionclear;
;;  XSelectionRequestEvent xselectionrequest;
;;  XSelectionEvent xselection;
;;  XColormapEvent xcolormap;
;;  XClientMessageEvent xclient;
;;  XMappingEvent xmapping;
;;  XErrorEvent xerror;
;;  XKeymapEvent xkeymap;
;;  long pad[24];
;; } XEvent;
;; #endif

(c-structure XCharStruct
             (short lbearing)
             (short rbearing)
             (short width)
             (short ascent)
             (short descent)
             (unsigned-short attributes)
             )

(c-structure XFontProp
             (Atom name)
             (unsigned-long card32)
             )



;; (c-structure XFontStruct 
;;              (XExtData* ext_data)
;;              (Font        fid)
;;              (unsigned   direction)
;;              (unsigned   min_char_or_byte2)
;;              (unsigned   max_char_or_byte2)
;;              (unsigned   min_byte1)
;;              (unsigned   max_byte1)
;;              (Bool   all_chars_exist)
;;              (unsigned   default_char)
;;              (int         n_properties)
;;              (XFontProp* properties)
;;              (XCharStruct    min_bounds)
;;              (XCharStruct    max_bounds)
;;              (XCharStruct*      per_char)
;;              (int        ascent)
;;              (int        descent)
;;              )


(c-structure XTextItem
             (char* chars)
             (int nchars)
             (int delta)
             (Font font)
             )



(c-structure XChar2b
             (unsigned-char byte1)
             (unsigned-char byte2)
             )



(c-structure XTextItem16
             (XChar2b* chars)
             (int nchars)
             (int delta)
             (Font font)
             )


;; typedef union { Display* display;
;;      GC gc;
;;      Visual* visual;
;;      Screen* screen;
;;      ScreenFormat *pixmap_format;
;;      XFontStruct *font; } XEDataObject;



;; (c-structure XFontSetExtents 
;;              (XRectangle      max_ink_extent)
;;              (XRectangle      max_logical_extent)
;;              )


;; typedef struct {
;;     char           *chars;
;;     int             nchars;
;;     int             delta;
;;     XFontSet        font_set;
;; } XmbTextItem;

;; typedef struct {
;;     wchar_t        *chars;
;;     int             nchars;
;;     int             delta;
;;     XFontSet        font_set;
;; } XwcTextItem;

;; #define XNRequiredCharSet "requiredCharSet"
;; #define XNQueryOrientation "queryOrientation"
;; #define XNBaseFontName "baseFontName"
;; #define XNOMAutomatic "omAutomatic"
;; #define XNMissingCharSet "missingCharSet"
;; #define XNDefaultString "defaultString"
;; #define XNOrientation "orientation"
;; #define XNDirectionalDependentDrawing "directionalDependentDrawing"
;; #define XNContextualDrawing "contextualDrawing"
;; #define XNFontInfo "fontInfo"

;; typedef struct {
;;     int charset_count;
;;     char* *charset_list;
;; } XOMCharSetList;

;; typedef enum {
;;     XOMOrientation_LTR_TTB,
;;     XOMOrientation_RTL_TTB,
;;     XOMOrientation_TTB_LTR,
;;     XOMOrientation_TTB_RTL,
;;     XOMOrientation_Context
;; } XOrientation;

;; typedef struct {
;;     int num_orientation;
;;     XOrientation *orientation;   /* Input Text description */
;; } XOMOrientation;

;; typedef struct {
;;     int num_font;
;;     XFontStruct **font_struct_list;
;;     char* *font_name_list;
;; } XOMFontInfo;

;; typedef struct _XIM *XIM;
;; typedef struct _XIC *XIC;

;; typedef void (*XIMProc)(
;;     XIM,
;;     XPointer,
;;     XPointer
;; );

;; typedef Bool (*XICProc)(
;;     XIC,
;;     XPointer,
;;     XPointer
;; );

;; typedef void (*XIDProc)(
;;     Display*,
;;     XPointer,
;;     XPointer
;; );

;; typedef unsigned-long XIMStyle;

;; typedef struct {
;;     unsigned-short count_styles;
;;     XIMStyle *supported_styles;
;; } XIMStyles;


;; typedef void *XVaNestedList;

;; typedef struct {
;;     XPointer client_data;
;;     XIMProc callback;
;; } XIMCallback;

;; typedef struct {
;;     XPointer client_data;
;;     XICProc callback;
;; } XICCallback;

;; typedef unsigned-long XIMFeedback;


;; typedef struct _XIMText {
;;     unsigned-short length;
;;     XIMFeedback *feedback;
;;     Bool encoding_is_wchar; 
;;     union {
;;  char* multi_byte;
;;  wchar_t *wide_char;
;;     } string; 
;; } XIMText;

;; typedef  unsigned-long    XIMPreeditState;

;; #define  XIMPreeditUnKnown   0L
;; #define  XIMPreeditEnable    1L
;; #define  XIMPreeditDisable   (1L<<1)

;; typedef  struct  _XIMPreeditStateNotifyCallbackStruct {
;;     XIMPreeditState state;
;; } XIMPreeditStateNotifyCallbackStruct;

;; typedef  unsigned-long    XIMResetState;

;; #define  XIMInitialState     1L
;; #define  XIMPreserveState    (1L<<1)

;; typedef unsigned-long XIMStringConversionFeedback;


;; typedef struct _XIMStringConversionText {
;;     unsigned-short length;
;;     XIMStringConversionFeedback *feedback;
;;     Bool encoding_is_wchar; 
;;     union {
;;  char* mbs;
;;  wchar_t *wcs;
;;     } string; 
;; } XIMStringConversionText;

;; typedef  unsigned-short  XIMStringConversionPosition;

;; typedef  unsigned-short  XIMStringConversionType;

;; #define  XIMStringConversionBuffer   (0x0001)
;; #define  XIMStringConversionLine     (0x0002)
;; #define  XIMStringConversionWord     (0x0003)
;; #define  XIMStringConversionChar     (0x0004)

;; typedef  unsigned-short  XIMStringConversionOperation;

;; #define  XIMStringConversionSubstitution (0x0001)
;; #define  XIMStringConversionRetrieval    (0x0002)

;; typedef enum {
;;     XIMForwardChar, XIMBackwardChar,
;;     XIMForwardWord, XIMBackwardWord,
;;     XIMCaretUp, XIMCaretDown,
;;     XIMNextLine, XIMPreviousLine,
;;     XIMLineStart, XIMLineEnd, 
;;     XIMAbsolutePosition,
;;     XIMDontChange
;; } XIMCaretDirection;

;; typedef struct _XIMStringConversionCallbackStruct {
;;     XIMStringConversionPosition position;
;;     XIMCaretDirection direction;
;;     XIMStringConversionOperation operation;
;;     unsigned-short factor;
;;     XIMStringConversionText *text;
;; } XIMStringConversionCallbackStruct;

;; typedef struct _XIMPreeditDrawCallbackStruct {
;;     int caret;       /* Cursor offset within pre-edit string */
;;     int chg_first;   /* Starting change position */
;;     int chg_length;  /* Length of the change in character count */
;;     XIMText *text;
;; } XIMPreeditDrawCallbackStruct;

;; typedef enum {
;;     XIMIsInvisible,  /* Disable caret feedback */ 
;;     XIMIsPrimary,    /* UI defined caret feedback */
;;     XIMIsSecondary   /* UI defined caret feedback */
;; } XIMCaretStyle;

;; typedef struct _XIMPreeditCaretCallbackStruct {
;;     int position;         /* Caret offset within pre-edit string */
;;     XIMCaretDirection direction; /* Caret moves direction */
;;     XIMCaretStyle style;  /* Feedback of the caret */
;; } XIMPreeditCaretCallbackStruct;

;; typedef enum {
;;     XIMTextType,
;;     XIMBitmapType
;; } XIMStatusDataType;

;; typedef struct _XIMStatusDrawCallbackStruct {
;;     XIMStatusDataType type;
;;     union {
;;  XIMText *text;
;;  Pixmap  bitmap;
;;     } data;
;; } XIMStatusDrawCallbackStruct;

;; typedef struct _XIMHotKeyTrigger {
;;     KeySym    keysym;
;;     int       modifier;
;;     int       modifier_mask;
;; } XIMHotKeyTrigger;

;; typedef struct _XIMHotKeyTriggers {
;;     int           num_hot_key;
;;     XIMHotKeyTrigger *key;
;; } XIMHotKeyTriggers;

;; typedef  unsigned-long    XIMHotKeyState;

;; #define  XIMHotKeyStateON    (0x0001L)
;; #define  XIMHotKeyStateOFF   (0x0002L)

;; typedef struct {
;;     unsigned-short count_values;
;;     char* *supported_values;
;; } XIMValuesList;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(c-function XFontStruct*          XLoadQueryFont                    (Display* const-char*))
(c-function XFontStruct*          XQueryFont                        (Display* XID))
(c-function XTimeCoord*           XGetMotionEvents                  (Display* Window Time Time int*))
(c-function XModifierKeymap*      XDeleteModifiermapEntry           (XModifierKeymap* KeyCode int))
(c-function XModifierKeymap*      XGetModifierMapping               (Display*))
(c-function XModifierKeymap*      XInsertModifiermapEntry           (XModifierKeymap* KeyCode int))
(c-function XModifierKeymap*      XNewModifiermap                   (int))
(c-function XImage*               XCreateImage                      (Display* Visual* unsigned-int int int char* unsigned-int unsigned-int int int))
(c-function Status                XInitImage                        (XImage*))
(c-function XImage*               XGetImage                         (Display* Drawable int int unsigned-int unsigned-int unsigned-long int))
(c-function XImage*               XGetSubImage                      (Display* Drawable int int unsigned-int unsigned-int unsigned-long int XImage* int int))

(c-function Display*              XOpenDisplay                      (const-char*))

(c-function void                  XrmInitialize                     ())
;; (c-function char*                 XFetchBytes                       (Display* int*))
;; (c-function char*                 XFetchBuffer                      (Display* int* int))
;; (c-function char*                 XGetAtomName                      (Display* Atom))
(c-function Status                XGetAtomNames                     (Display* Atom* int char**))
;; (c-function char*                 XGetDefault                       (Display* const-char* const-char*))
;; (c-function char*                 XDisplayName                      (const-char*))
;; (c-function char*                 XKeysymToString                   (KeySym))
(c-function Atom                  XInternAtom                       (Display* const-char* Bool))
(c-function Status                XInternAtoms                      (Display* char** int Bool Atom*))
(c-function Colormap              XCopyColormapAndFree              (Display* Colormap))
(c-function Colormap              XCreateColormap                   (Display* Window Visual* int))
(c-function Cursor                XCreatePixmapCursor               (Display* Pixmap Pixmap XColor* XColor* unsigned-int unsigned-int))
(c-function Cursor                XCreateGlyphCursor                (Display* Font Font unsigned-int unsigned-int XColor-const-* XColor-const-*))
(c-function Cursor                XCreateFontCursor                 (Display* unsigned-int))
(c-function Font                  XLoadFont                         (Display* const-char*))
(c-function GC                    XCreateGC                         (Display* Drawable unsigned-long XGCValues*))
(c-function GContext              XGContextFromGC                   (GC))
(c-function void                  XFlushGC                          (Display* GC))
(c-function Pixmap                XCreatePixmap                     (Display* Drawable unsigned-int unsigned-int unsigned-int))
(c-function Pixmap                XCreateBitmapFromData             (Display* Drawable const-char* unsigned-int unsigned-int))
(c-function Pixmap                XCreatePixmapFromBitmapData       (Display* Drawable char* unsigned-int unsigned-int unsigned-long unsigned-long unsigned-int))
(c-function Window                XCreateSimpleWindow               (Display* Window int int unsigned-int unsigned-int unsigned-int unsigned-long unsigned-long))
(c-function Window                XGetSelectionOwner                (Display* Atom))
(c-function Window                XCreateWindow                     (Display* Window int int unsigned-int unsigned-int unsigned-int int unsigned-int Visual* unsigned-long XSetWindowAttributes*))
(c-function Colormap*             XListInstalledColormaps           (Display* Window int*))
(c-function char**                XListFonts                        (Display* const-char* int int*))
(c-function char**                XListFontsWithInfo                (Display* const-char* int int* XFontStruct**))
(c-function char**                XGetFontPath                      (Display* int*))
(c-function char**                XListExtensions                   (Display* int*))
(c-function Atom*                 XListProperties                   (Display* Window int*))
(c-function XHostAddress*         XListHosts                        (Display* int* Bool*))
(c-function KeySym                XKeycodeToKeysym                  (Display* KeyCode int))
(c-function KeySym                XLookupKeysym                     (XKeyEvent* int))
(c-function KeySym*               XGetKeyboardMapping               (Display* KeyCode int int*))
(c-function KeySym                XStringToKeysym                   (const-char*))
(c-function long                  XMaxRequestSize                   (Display*))
(c-function long                  XExtendedMaxRequestSize           (Display*))
;; (c-function char*                 XResourceManagerString            (Display*))
;; (c-function char*                 XScreenResourceString             (Screen*))
(c-function unsigned-long         XDisplayMotionBufferSize          (Display*))
(c-function VisualID              XVisualIDFromVisual               (Visual*))
(c-function Status                XInitThreads                      ())
(c-function void                  XLockDisplay                      (Display*))
(c-function void                  XUnlockDisplay                    (Display*))
(c-function XExtCodes*            XInitExtension                    (Display* const-char*))
(c-function XExtCodes*            XAddExtension                     (Display*))
(c-function XExtData*             XFindOnExtensionList              (XExtData** int))
;; (c-function XExtData**            XEHeadOfExtensionList             (XEDataObject))
(c-function Window                XRootWindow                       (Display* int))
(c-function Window                XDefaultRootWindow                (Display*))
(c-function Window                XRootWindowOfScreen               (Screen*))
(c-function Visual*               XDefaultVisual                    (Display* int))
(c-function Visual*               XDefaultVisualOfScreen            (Screen*))
(c-function GC                    XDefaultGC                        (Display* int))
(c-function GC                    XDefaultGCOfScreen                (Screen*))
(c-function unsigned-long         XBlackPixel                       (Display* int))
(c-function unsigned-long         XWhitePixel                       (Display* int))
(c-function unsigned-long         XAllPlanes                        ())
(c-function unsigned-long         XBlackPixelOfScreen               (Screen*))
(c-function unsigned-long         XWhitePixelOfScreen               (Screen*))
(c-function unsigned-long         XNextRequest                      (Display*))
(c-function unsigned-long         XLastKnownRequestProcessed        (Display*))
;; (c-function char*                 XServerVendor                     (Display*))
;; (c-function char*                 XDisplayString                    (Display*))
(c-function Colormap              XDefaultColormap                  (Display* int))
(c-function Colormap              XDefaultColormapOfScreen          (Screen*))
(c-function Display*              XDisplayOfScreen                  (Screen*))
(c-function Screen*               XScreenOfDisplay                  (Display* int))
(c-function Screen*               XDefaultScreenOfDisplay           (Display*))
(c-function long                  XEventMaskOfScreen                (Screen*))
(c-function int                   XScreenNumberOfScreen             (Screen*))

;; (c-function XErrorHandler         XSetErrorHandler                  (XErrorHandler))

;; (c-function void*         XSetErrorHandler                  ((c-callback int (Display* XErrorEvent*))))

;; (c-function void*         XSetErrorHandler                  ((c-callback int (void* void*))))

;; (c-function void*         XSetErrorHandler                  ((function int (void* void*))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define-external (xerrorhandler (void* dpy) (void* ev)) int
;;   (display "Error handler called\n"))

;; (define XSetErrorHandler (foreign-safe-lambda void* XSetErrorHandler (function int (void* void*))))

;; (define (install-xerrorhandler)
;;   (XSetErrorHandler xerrorhandler))

;; (define (install-xerrorhandler-alt)
;;   (XSetErrorHandler (location xerrorhandler)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define-external (xerrorhandler (c-pointer dpy) (c-pointer ev)) int
;;   (display "Error handler called\n"))

;; (define XSetErrorHandler (foreign-safe-lambda c-pointer XSetErrorHandler (function int (c-pointer c-pointer))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(foreign-declare
"

int
simple_error_handler( void * dpy , void * ev ) {
  printf ( \" Error handler called \" ) ;
}

"
)

(define install-simple-error-handler
  (foreign-lambda* void ()
                   " XSetErrorHandler ( simple_error_handler ) ; "))

(define (XSetErrorHandler not-used)
  (install-simple-error-handler)
  #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define-external chicken_xlib_error_handler scheme-object)


;; (foreign-declare
;; "

;; int
;; simple_error_handler( void * dpy , void * ev ) {

;;   C_save ( dpy ) ;

;;   C_save ( ev ) ;

;;   C_callback ( chicken_xlib_error_handler , 2 ) ;

;; }

;; "
;; )


;; (define install-simple-error-handler
;;   (foreign-lambda* void ()
;;                    " XSetErrorHandler ( simple_error_handler ) ; "))


;; (define (XSetErrorHandler error-handler)

;;   (let ((old chicken_xlib_error_handler))

;;     (set! chicken_xlib_error_handler error-handler)

;;     old))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (foreign-declare " extern int simple_error_handler( void* , void* ) ; ")

;; (define-external chicken_xlib_error_handler scheme-object)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define chicken_xlib_error_handler #f)

;; (foreign-declare
;; "

;; // extern C_word chicken_xlib_error_handler ;

;; int
;; simple_error_handler( void * dpy , void * ev ) {

;;   C_word* ptr ;

;;   C_word sym ;

;;   C_word val ;

;;   ptr = C_alloc ( C_SIZEOF_INTERNED_SYMBOL ( 40 ) ) ;

;;   sym = C_intern2 ( &ptr , \"chicken_xlib_error_handler\" ) ;

;;   val = C_symbol_value( sym ) ;

;;   C_save ( C_SCHEME_TRUE ) ;

;;   C_save ( C_SCHEME_TRUE ) ;

;;   C_callback ( val , 2 ) ;

;;   return 0 ;

;; }

;; "
;; )

;; (define install-simple-error-handler
;;   (foreign-lambda* void ()
;;                    " XSetErrorHandler ( simple_error_handler ) ; "))


;; (define (XSetErrorHandler error-handler)

;;   (let ((old chicken_xlib_error_handler))

;;     (set! chicken_xlib_error_handler error-handler)

;;     old))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (c-function XIOErrorHandler       XSetIOErrorHandler                (XIOErrorHandler))
(c-function XPixmapFormatValues*  XListPixmapFormats                (Display* int*))
;; (c-function int*                  XListDepths                       (Display* int int*))
(c-function Status                XReconfigureWMWindow              (Display* Window int unsigned-int XWindowChanges*))
(c-function Status                XGetWMProtocols                   (Display* Window Atom** int*))
(c-function Status                XSetWMProtocols                   (Display* Window Atom* int))
(c-function Status                XIconifyWindow                    (Display* Window int))
(c-function Status                XWithdrawWindow                   (Display* Window int))
(c-function Status                XGetCommand                       (Display* Window char*** int*))
(c-function Status                XGetWMColormapWindows             (Display* Window Window** int*))
(c-function Status                XSetWMColormapWindows             (Display* Window Window* int))
(c-function void                  XFreeStringList                   (char**))
(c-function int                   XSetTransientForHint              (Display* Window Window))
(c-function int                   XActivateScreenSaver              (Display*))
(c-function int                   XAddHost                          (Display* XHostAddress*))
(c-function int                   XAddHosts                         (Display* XHostAddress* int))
;; (c-function int                   XAddToExtensionList               (struct _XExtData** XExtData*))
(c-function int                   XAddToSaveSet                     (Display* Window))
(c-function Status                XAllocColor                       (Display* Colormap XColor*))
(c-function Status                XAllocColorCells                  (Display* Colormap Bool unsigned-long* unsigned-int unsigned-long* unsigned-int))
(c-function Status                XAllocColorPlanes                 (Display* Colormap Bool unsigned-long* int int int int unsigned-long* unsigned-long* unsigned-long*))

(c-function Status                XAllocNamedColor                  (Display* Colormap const-char* XColor* XColor*))

(c-function int                   XAllowEvents                      (Display* int Time))
(c-function int                   XAutoRepeatOff                    (Display*))
(c-function int                   XAutoRepeatOn                     (Display*))
(c-function int                   XBell                             (Display* int))
(c-function int                   XBitmapBitOrder                   (Display*))
(c-function int                   XBitmapPad                        (Display*))
(c-function int                   XBitmapUnit                       (Display*))
(c-function int                   XCellsOfScreen                    (Screen*))
(c-function int                   XChangeActivePointerGrab          (Display* unsigned-int Cursor Time))
(c-function int                   XChangeGC                         (Display* GC unsigned-long XGCValues*))
(c-function int                   XChangeKeyboardControl            (Display* unsigned-long XKeyboardControl*))
(c-function int                   XChangeKeyboardMapping            (Display* int int KeySym* int))
(c-function int                   XChangePointerControl             (Display* Bool Bool int int int))
(c-function int                   XChangeProperty                   (Display* Window Atom Atom int int const-unsigned-char* int))
(c-function int                   XChangeSaveSet                    (Display* Window int))
(c-function int                   XChangeWindowAttributes           (Display* Window unsigned-long XSetWindowAttributes*))
;; (c-function Bool                  XCheckIfEvent                     (Display* XEvent* Bool (*)  (Display* XEvent* XPointer           ) XPointer))
(c-function Bool                  XCheckMaskEvent                   (Display* long XEvent*))
(c-function Bool                  XCheckTypedEvent                  (Display* int XEvent*))
(c-function Bool                  XCheckTypedWindowEvent            (Display* Window int XEvent*))
(c-function Bool                  XCheckWindowEvent                 (Display* Window long XEvent*))
(c-function int                   XCirculateSubwindows              (Display* Window int))
(c-function int                   XCirculateSubwindowsDown          (Display* Window))
(c-function int                   XCirculateSubwindowsUp            (Display* Window))
(c-function int                   XClearArea                        (Display* Window int int unsigned-int unsigned-int Bool))
(c-function int                   XClearWindow                      (Display* Window))
(c-function int                   XCloseDisplay                     (Display*))
(c-function int                   XConfigureWindow                  (Display* Window unsigned-int XWindowChanges*))
(c-function int                   XConnectionNumber                 (Display*))
(c-function int                   XConvertSelection                 (Display* Atom Atom Atom Window Time))
(c-function int                   XCopyArea                         (Display* Drawable Drawable GC int int unsigned-int unsigned-int int int))
(c-function int                   XCopyGC                           (Display* GC unsigned-long GC))
(c-function int                   XCopyPlane                        (Display* Drawable Drawable GC int int unsigned-int unsigned-int int int unsigned-long))
(c-function int                   XDefaultDepth                     (Display* int))
(c-function int                   XDefaultDepthOfScreen             (Screen*))
(c-function int                   XDefaultScreen                    (Display*))
(c-function int                   XDefineCursor                     (Display* Window Cursor))
(c-function int                   XDeleteProperty                   (Display* Window Atom))
(c-function int                   XDestroyWindow                    (Display* Window))
(c-function int                   XDestroySubwindows                (Display* Window))
(c-function int                   XDoesBackingStore                 (Screen*))
(c-function Bool                  XDoesSaveUnders                   (Screen*))
(c-function int                   XDisableAccessControl             (Display*))
(c-function int                   XDisplayCells                     (Display* int))
(c-function int                   XDisplayHeight                    (Display* int))
(c-function int                   XDisplayHeightMM                  (Display* int))
(c-function int                   XDisplayKeycodes                  (Display* int* int*))
(c-function int                   XDisplayPlanes                    (Display* int))
(c-function int                   XDisplayWidth                     (Display* int))
(c-function int                   XDisplayWidthMM                   (Display* int))
(c-function int                   XDrawArc                          (Display* Drawable GC int int unsigned-int unsigned-int int int))
(c-function int                   XDrawArcs                         (Display* Drawable GC XArc* int))
(c-function int                   XDrawImageString                  (Display* Drawable GC int int const-char* int))
(c-function int                   XDrawImageString16                (Display* Drawable GC int int const-XChar2b* int))
(c-function int                   XDrawLine                         (Display* Drawable GC int int int int))
(c-function int                   XDrawLines                        (Display* Drawable GC XPoint* int int))
(c-function int                   XDrawPoint                        (Display* Drawable GC int int))
(c-function int                   XDrawPoints                       (Display* Drawable GC XPoint* int int))
(c-function int                   XDrawRectangle                    (Display* Drawable GC int int unsigned-int unsigned-int))
(c-function int                   XDrawRectangles                   (Display* Drawable GC XRectangle* int))
(c-function int                   XDrawSegments                     (Display* Drawable GC XSegment* int))
(c-function int                   XDrawString                       (Display* Drawable GC int int const-char* int))
(c-function int                   XDrawString16                     (Display* Drawable GC int int const-XChar2b* int))
(c-function int                   XDrawText                         (Display* Drawable GC int int XTextItem* int))
(c-function int                   XDrawText16                       (Display* Drawable GC int int XTextItem16* int))
(c-function int                   XEnableAccessControl              (Display*))
(c-function int                   XEventsQueued                     (Display* int))
(c-function Status                XFetchName                        (Display* Window char**))
(c-function int                   XFillArc                          (Display* Drawable GC int int unsigned-int unsigned-int int int))
(c-function int                   XFillArcs                         (Display* Drawable GC XArc* int))
(c-function int                   XFillPolygon                      (Display* Drawable GC XPoint* int int int))
(c-function int                   XFillRectangle                    (Display* Drawable GC int int unsigned-int unsigned-int))
(c-function int                   XFillRectangles                   (Display* Drawable GC XRectangle* int))
(c-function int                   XFlush                            (Display*))
(c-function int                   XForceScreenSaver                 (Display* int))
(c-function int                   XFree                             (void*))
(c-function int                   XFreeColormap                     (Display* Colormap))
(c-function int                   XFreeColors                       (Display* Colormap unsigned-long* int unsigned-long))
(c-function int                   XFreeCursor                       (Display* Cursor))
(c-function int                   XFreeExtensionList                (char**))
(c-function int                   XFreeFont                         (Display* XFontStruct*))
(c-function int                   XFreeFontInfo                     (char** XFontStruct* int))
(c-function int                   XFreeFontNames                    (char**))
(c-function int                   XFreeFontPath                     (char**))
(c-function int                   XFreeGC                           (Display* GC))
(c-function int                   XFreeModifiermap                  (XModifierKeymap*))
(c-function int                   XFreePixmap                       (Display* Pixmap))
(c-function int                   XGeometry                         (Display* int const-char* const-char* unsigned-int unsigned-int unsigned-int int int int* int* int* int*))
(c-function int                   XGetErrorDatabaseText             (Display* const-char* const-char* const-char* char* int))
(c-function int                   XGetErrorText                     (Display* int char* int))
(c-function Bool                  XGetFontProperty                  (XFontStruct* Atom unsigned-long*))
(c-function Status                XGetGCValues                      (Display* GC unsigned-long XGCValues*))
(c-function Status                XGetGeometry                      (Display* Drawable Window* int* int* unsigned-int* unsigned-int* unsigned-int* unsigned-int*))
(c-function Status                XGetIconName                      (Display* Window char**))
(c-function int                   XGetInputFocus                    (Display* Window* int*))
(c-function int                   XGetKeyboardControl               (Display* XKeyboardState*))
(c-function int                   XGetPointerControl                (Display* int* int* int*))

(c-function int                   XGetPointerMapping                (Display* unsigned-char* int))


(c-function int                   XGetScreenSaver                   (Display* int* int* int* int*))
(c-function Status                XGetTransientForHint              (Display* Window Window*))
(c-function int                   XGetWindowProperty                (Display* Window Atom long long Bool Atom Atom* int* unsigned-long* unsigned-long* unsigned-char**))
(c-function Status                XGetWindowAttributes              (Display* Window XWindowAttributes*))
(c-function int                   XGrabButton                       (Display* unsigned-int unsigned-int Window Bool unsigned-int int int Window Cursor))
(c-function int                   XGrabKey                          (Display* int unsigned-int Window Bool int int))
(c-function int                   XGrabKeyboard                     (Display* Window Bool int int Time))
(c-function int                   XGrabPointer                      (Display* Window Bool unsigned-int int int Window Cursor Time))
(c-function int                   XGrabServer                       (Display*))
(c-function int                   XHeightMMOfScreen                 (Screen*))
(c-function int                   XHeightOfScreen                   (Screen*))
;;(c-function int                   XIfEvent                          (Display* XEvent* Bool (*)  (Display* XEvent* XPointer ) XPointer))
(c-function int                   XImageByteOrder                   (Display*))
(c-function int                   XInstallColormap                  (Display* Colormap))
(c-function KeyCode               XKeysymToKeycode                  (Display* KeySym))
(c-function int                   XKillClient                       (Display* XID))
(c-function Status                XLookupColor                      (Display* Colormap const-char* XColor* XColor*))
(c-function int                   XLowerWindow                      (Display* Window))
(c-function int                   XMapRaised                        (Display* Window))
(c-function int                   XMapSubwindows                    (Display* Window))
(c-function int                   XMapWindow                        (Display* Window))
(c-function int                   XMaskEvent                        (Display* long XEvent*))
(c-function int                   XMaxCmapsOfScreen                 (Screen*))
(c-function int                   XMinCmapsOfScreen                 (Screen*))
(c-function int                   XMoveResizeWindow                 (Display* Window int int unsigned-int unsigned-int))
(c-function int                   XMoveWindow                       (Display* Window int int))

(c-function int                   XNextEvent                        (Display* XEvent*))

(c-function int                   XNoOp                             (Display*))
(c-function Status                XParseColor                       (Display* Colormap const-char* XColor*))
(c-function int                   XParseGeometry                    (const-char* int* int* unsigned-int* unsigned-int*))
(c-function int                   XPeekEvent                        (Display* XEvent*))
;; (c-function int                   XPeekIfEvent                      (Display* XEvent* Bool (*)  (Display* XEvent* XPointer ) XPointer))
(c-function int                   XPending                          (Display*))
(c-function int                   XPlanesOfScreen                   (Screen*))
(c-function int                   XProtocolRevision                 (Display*))
(c-function int                   XProtocolVersion                  (Display*))
(c-function int                   XPutBackEvent                     (Display* XEvent*))
(c-function int                   XPutImage                         (Display* Drawable GC XImage* int int int int unsigned-int unsigned-int))
(c-function int                   XQLength                          (Display*))
(c-function Status                XQueryBestCursor                  (Display* Drawable unsigned-int unsigned-int unsigned-int* unsigned-int*))
(c-function Status                XQueryBestSize                    (Display* int Drawable unsigned-int unsigned-int unsigned-int* unsigned-int*))
(c-function Status                XQueryBestStipple                 (Display* Drawable unsigned-int unsigned-int unsigned-int* unsigned-int*))
(c-function Status                XQueryBestTile                    (Display* Drawable unsigned-int unsigned-int unsigned-int* unsigned-int*))
(c-function int                   XQueryColor                       (Display* Colormap XColor*))
(c-function int                   XQueryColors                      (Display* Colormap XColor* int))
(c-function Bool                  XQueryExtension                   (Display* const-char* int* int* int*))
;; (c-function int                   XQueryKeymap                      (Display* char [32]))
(c-function Bool                  XQueryPointer                     (Display* Window Window* Window* int* int* int* int* unsigned-int*))
(c-function int                   XQueryTextExtents                 (Display* XID const-char* int int* int* int* XCharStruct*))
(c-function int                   XQueryTextExtents16               (Display* XID const-XChar2b* int int* int* int* XCharStruct*))

;; (c-function Status                XQueryTree                        (Display* Window Window* Window* Window** unsigned-int*))

;; (c-function Status                XQueryTree                        (Display* Window u32vector u32vector (c-pointer (c-pointer unsigned-long)) u32vector))

(define sizeof:c-pointer (foreign-value "sizeof(void*)" integer))

(define pointer-pointer-ref
  (foreign-lambda*
   c-pointer

   ((c-pointer ptr))
   
   " C_return ( * ( ( void** ) ptr ) ) ; "))

(c-function Status                XQueryTree                        (Display* Window u32vector u32vector (c-pointer (c-pointer unsigned-long)) u32vector))

(c-function int                   XRaiseWindow                      (Display* Window))
(c-function int                   XReadBitmapFile                   (Display* Drawable const-char* unsigned-int* unsigned-int* Pixmap* int* int*))
(c-function int                   XReadBitmapFileData               (const-char* unsigned-int* unsigned-int* unsigned-char** int* int*))
(c-function int                   XRebindKeysym                     (Display* KeySym KeySym* int const-unsigned-char* int))
(c-function int                   XRecolorCursor                    (Display* Cursor XColor* XColor*))
(c-function int                   XRefreshKeyboardMapping           (XMappingEvent*))
(c-function int                   XRemoveFromSaveSet                (Display* Window))
(c-function int                   XRemoveHost                       (Display* XHostAddress*))
(c-function int                   XRemoveHosts                      (Display* XHostAddress* int))
(c-function int                   XReparentWindow                   (Display* Window Window int int))
(c-function int                   XResetScreenSaver                 (Display*))
(c-function int                   XResizeWindow                     (Display* Window unsigned-int unsigned-int))
(c-function int                   XRestackWindows                   (Display* Window* int))
(c-function int                   XRotateBuffers                    (Display* int))
(c-function int                   XRotateWindowProperties           (Display* Window Atom* int int))
(c-function int                   XScreenCount                      (Display*))
(c-function int                   XSelectInput                      (Display* Window long))
(c-function Status                XSendEvent                        (Display* Window Bool long XEvent*))
(c-function int                   XSetAccessControl                 (Display* int))
(c-function int                   XSetArcMode                       (Display* GC int))
(c-function int                   XSetBackground                    (Display* GC unsigned-long))
(c-function int                   XSetClipMask                      (Display* GC Pixmap))
(c-function int                   XSetClipOrigin                    (Display* GC int int))
(c-function int                   XSetClipRectangles                (Display* GC int int XRectangle* int int))
(c-function int                   XSetCloseDownMode                 (Display* int))
(c-function int                   XSetCommand                       (Display* Window char** int))
(c-function int                   XSetDashes                        (Display* GC int const-char* int))
(c-function int                   XSetFillRule                      (Display* GC int))
(c-function int                   XSetFillStyle                     (Display* GC int))
(c-function int                   XSetFont                          (Display* GC Font))
(c-function int                   XSetFontPath                      (Display* char** int))
(c-function int                   XSetForeground                    (Display* GC unsigned-long))
(c-function int                   XSetFunction                      (Display* GC int))
(c-function int                   XSetGraphicsExposures             (Display* GC Bool))
(c-function int                   XSetIconName                      (Display* Window const-char*))
(c-function int                   XSetInputFocus                    (Display* Window int Time))
(c-function int                   XSetLineAttributes                (Display* GC unsigned-int int int int))
(c-function int                   XSetModifierMapping               (Display* XModifierKeymap*))
(c-function int                   XSetPlaneMask                     (Display* GC unsigned-long))
(c-function int                   XSetPointerMapping                (Display* const-unsigned-char* int))
(c-function int                   XSetScreenSaver                   (Display* int int int int))
(c-function int                   XSetSelectionOwner                (Display* Atom Window Time))
(c-function int                   XSetState                         (Display* GC unsigned-long unsigned-long int unsigned-long))
(c-function int                   XSetStipple                       (Display* GC Pixmap))
(c-function int                   XSetSubwindowMode                 (Display* GC int))
(c-function int                   XSetTSOrigin                      (Display* GC int int))
(c-function int                   XSetTile                          (Display* GC Pixmap))
(c-function int                   XSetWindowBackground              (Display* Window unsigned-long))
(c-function int                   XSetWindowBackgroundPixmap        (Display* Window Pixmap))
(c-function int                   XSetWindowBorder                  (Display* Window unsigned-long))
(c-function int                   XSetWindowBorderPixmap            (Display* Window Pixmap))
(c-function int                   XSetWindowBorderWidth             (Display* Window unsigned-int))
(c-function int                   XSetWindowColormap                (Display* Window Colormap))
(c-function int                   XStoreBuffer                      (Display* const-char* int int))
(c-function int                   XStoreBytes                       (Display* const-char* int))
(c-function int                   XStoreColor                       (Display* Colormap XColor*))
(c-function int                   XStoreColors                      (Display* Colormap XColor* int))
(c-function int                   XStoreName                        (Display* Window const-char*))
(c-function int                   XStoreNamedColor                  (Display* Colormap const-char* unsigned-long int))
(c-function int                   XSync                             (Display* Bool))
(c-function int                   XTextExtents                      (XFontStruct* const-char* int int* int* int* XCharStruct*))
(c-function int                   XTextExtents16                    (XFontStruct* const-XChar2b* int int* int* int* XCharStruct*))
(c-function int                   XTextWidth                        (XFontStruct* const-char* int))
(c-function int                   XTextWidth16                      (XFontStruct* const-XChar2b* int))
(c-function Bool                  XTranslateCoordinates             (Display* Window Window int int int* int* Window*))
(c-function int                   XUndefineCursor                   (Display* Window))
(c-function int                   XUngrabButton                     (Display* unsigned-int unsigned-int Window))
(c-function int                   XUngrabKey                        (Display* int unsigned-int Window))
(c-function int                   XUngrabKeyboard                   (Display* Time))
(c-function int                   XUngrabPointer                    (Display* Time))
(c-function int                   XUngrabServer                     (Display*))
(c-function int                   XUninstallColormap                (Display* Colormap))
(c-function int                   XUnloadFont                       (Display* Font))
(c-function int                   XUnmapSubwindows                  (Display* Window))
(c-function int                   XUnmapWindow                      (Display* Window))
(c-function int                   XVendorRelease                    (Display*))
(c-function int                   XWarpPointer                      (Display* Window Window int int unsigned-int unsigned-int int int))
(c-function int                   XWidthMMOfScreen                  (Screen*))
(c-function int                   XWidthOfScreen                    (Screen*))
(c-function int                   XWindowEvent                      (Display* Window long XEvent*))
(c-function int                   XWriteBitmapFile                  (Display* const-char* Pixmap unsigned-int unsigned-int int int))
(c-function Bool                  XSupportsLocale                   ());
;; (c-function char*                 XSetLocaleModifiers               (const-char*))
;; (c-function XOM                   XOpenOM                           (Display* struct _XrmHashBucketRec* const-char* const-char*))
(c-function XFontSet              XCreateFontSet                    (Display* const-char* char*** int* char**))
(c-function void                  XFreeFontSet                      (Display* XFontSet))
(c-function int                   XFontsOfFontSet                   (XFontSet XFontStruct*** char***))
;; (c-function char*                 XBaseFontNameListOfFontSet        (XFontSet))
;; (c-function char*                 XLocaleOfFontSet                  (XFontSet))
(c-function Bool                  XContextDependentDrawing          (XFontSet))
(c-function Bool                  XDirectionalDependentDrawing      (XFontSet))
(c-function Bool                  XContextualDrawing                (XFontSet))
(c-function XFontSetExtents*      XExtentsOfFontSet                 (XFontSet))
(c-function int                   XmbTextEscapement                 (XFontSet const-char* int))
(c-function int                   XwcTextEscapement                 (XFontSet const-wchar_t* int))
(c-function int                   Xutf8TextEscapement               (XFontSet const-char* int))
(c-function int                   XmbTextExtents                    (XFontSet const-char* int XRectangle* XRectangle*))
(c-function int                   XwcTextExtents                    (XFontSet const-wchar_t* int XRectangle* XRectangle*))
(c-function int                   Xutf8TextExtents                  (XFontSet const-char* int XRectangle* XRectangle*))
(c-function Status                XmbTextPerCharExtents             (XFontSet const-char* int XRectangle* XRectangle* int int* XRectangle* XRectangle*))
(c-function Status                XwcTextPerCharExtents             (XFontSet const-wchar_t* int XRectangle* XRectangle* int int* XRectangle* XRectangle*))
(c-function Status                Xutf8TextPerCharExtents           (XFontSet const-char* int XRectangle* XRectangle* int int* XRectangle* XRectangle*))
(c-function void                  XmbDrawText                       (Display* Drawable GC int int XmbTextItem* int))
(c-function void                  XwcDrawText                       (Display* Drawable GC int int XwcTextItem* int))
(c-function void                  Xutf8DrawText                     (Display* Drawable GC int int XmbTextItem* int))
(c-function void                  XmbDrawString                     (Display* Drawable XFontSet GC int int const-char* int))
(c-function void                  XwcDrawString                     (Display* Drawable XFontSet GC int int const-wchar_t* int))
(c-function void                  Xutf8DrawString                   (Display* Drawable XFontSet GC int int const-char* int))
(c-function void                  XmbDrawImageString                (Display* Drawable XFontSet GC int int const-char* int))
(c-function void                  XwcDrawImageString                (Display* Drawable XFontSet GC int int const-wchar_t* int))
(c-function void                  Xutf8DrawImageString              (Display* Drawable XFontSet GC int int const-char* int))
;; (c-function XIM                   XOpenIM                           (Display* struct _XrmHashBucketRec* char* char*))
(c-function Status                XCloseIM                          (XIM))
(c-function Display*              XDisplayOfIM                      (XIM))
;; (c-function char*                 XLocaleOfIM                       (XIM))
(c-function void                  XDestroyIC                        (XIC))
(c-function void                  XSetICFocus                       (XIC))
(c-function void                  XUnsetICFocus                     (XIC))
(c-function wchar_t*              XwcResetIC                        (XIC))
;; (c-function char*                 XmbResetIC                        (XIC))
;; (c-function char*                 Xutf8ResetIC                      (XIC))
(c-function XIM                   XIMOfIC                           (XIC))
(c-function Bool                  XFilterEvent                      (XEvent* Window))
(c-function int                   XmbLookupString                   (XIC XKeyPressedEvent* char* int KeySym* Status*))
(c-function int                   XwcLookupString                   (XIC XKeyPressedEvent* wchar_t* int KeySym* Status*))
(c-function int                   Xutf8LookupString                 (XIC XKeyPressedEvent* char* int KeySym* Status*))
;; (c-function Bool                  XRegisterIMInstantiateCallback    (Display* struct _XrmHashBucketRec* char* char* XIDProc XPointer))
;; (c-function Bool                  XUnregisterIMInstantiateCallback  (Display* struct _XrmHashBucketRec* char* char* XIDProc XPointer))
(c-function Status                XInternalConnectionNumbers        (Display* int** int*))
(c-function void                  XProcessInternalConnection        (Display* int))
;; (c-function Status                XAddConnectionWatch               (Display* XConnectionWatchProc XPointer))
;; (c-function void                  XRemoveConnectionWatch            (Display* XConnectionWatchProc XPointer))
(c-function void                  XSetAuthorization                 (char*  int char*  int))
;; (c-function int                   _Xmbtowc                          (wchar_t*  char*  int))
;; (c-function int                   _Xwctomb                          (char*  wchar_t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Xlib.h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define XlibSpecificationRelease 6)

(define True 1)
(define False 0)
(define QueuedAlready 0)
(define QueuedAfterReading 1)
(define QueuedAfterFlush 2)

;; #define AllPlanes 		((unsigned long)~0)

(define XNRequiredCharSet "requiredCharSet")
(define XNQueryOrientation "queryOrientation")
(define XNBaseFontName "baseFontName")
(define XNOMAutomatic "omAutomatic")
(define XNMissingCharSet "missingCharSet")
(define XNDefaultString "defaultString")
(define XNOrientation "orientation")
(define XNDirectionalDependentDrawing "directionalDependentDrawing")
(define XNContextualDrawing "contextualDrawing")
(define XNFontInfo "fontInfo")
(define XIMPreeditArea		#x0001)
(define XIMPreeditCallbacks	#x0002)
(define XIMPreeditPosition	#x0004)
(define XIMPreeditNothing	#x0008)
(define XIMPreeditNone		#x0010)
(define XIMStatusArea		#x0100)
(define XIMStatusCallbacks	#x0200)
(define XIMStatusNothing	#x0400)
(define XIMStatusNone		#x0800)
(define XNVaNestedList "XNVaNestedList")
(define XNQueryInputStyle "queryInputStyle")
(define XNClientWindow "clientWindow")
(define XNInputStyle "inputStyle")
(define XNFocusWindow "focusWindow")
(define XNResourceName "resourceName")
(define XNResourceClass "resourceClass")
(define XNGeometryCallback "geometryCallback")
(define XNDestroyCallback "destroyCallback")
(define XNFilterEvents "filterEvents")
(define XNPreeditStartCallback "preeditStartCallback")
(define XNPreeditDoneCallback "preeditDoneCallback")
(define XNPreeditDrawCallback "preeditDrawCallback")
(define XNPreeditCaretCallback "preeditCaretCallback")
(define XNPreeditStateNotifyCallback "preeditStateNotifyCallback")
(define XNPreeditAttributes "preeditAttributes")
(define XNStatusStartCallback "statusStartCallback")
(define XNStatusDoneCallback "statusDoneCallback")
(define XNStatusDrawCallback "statusDrawCallback")
(define XNStatusAttributes "statusAttributes")
(define XNArea "area")
(define XNAreaNeeded "areaNeeded")
(define XNSpotLocation "spotLocation")
(define XNColormap "colorMap")
(define XNStdColormap "stdColorMap")
(define XNForeground "foreground")
(define XNBackground "background")
(define XNBackgroundPixmap "backgroundPixmap")
(define XNFontSet "fontSet")
(define XNLineSpace "lineSpace")
(define XNCursor "cursor")
(define XNQueryIMValuesList "queryIMValuesList")
(define XNQueryICValuesList "queryICValuesList")
(define XNVisiblePosition "visiblePosition")
(define XNR6PreeditCallback "r6PreeditCallback")
(define XNStringConversionCallback "stringConversionCallback")
(define XNStringConversion "stringConversion")
(define XNResetState "resetState")
(define XNHotKey "hotKey")
(define XNHotKeyState "hotKeyState")
(define XNPreeditState "preeditState")
(define XNSeparatorofNestedList "separatorofNestedList")
(define XBufferOverflow		-1)
(define XLookupNone		1)
(define XLookupChars		2)
(define XLookupKeySym		3)
(define XLookupBoth		4)
(define XIMReverse		1)
(define XIMUnderline		(expt 2 1))
(define XIMHighlight		(expt 2 2))
(define XIMPrimary	 	(expt 2 5))
(define XIMSecondary		(expt 2 6))
(define XIMTertiary	 	(expt 2 7))
(define XIMVisibleToForward 	(expt 2 8))
(define XIMVisibleToBackword 	(expt 2 9))
(define XIMVisibleToCenter 	(expt 2 10))
(define XIMPreeditUnKnown	0)
(define XIMPreeditEnable	1)
(define XIMPreeditDisable (expt 2 1))
(define XIMInitialState  1)
(define XIMPreserveState (expt 2 1))

(define XIMStringConversionLeftEdge #x00000001)
(define XIMStringConversionRightEdge #x00000002)
(define XIMStringConversionTopEdge #x00000004)
(define XIMStringConversionBottomEdge #x00000008)
(define XIMStringConversionConcealed #x00000010)
(define XIMStringConversionWrapped #x00000020)
(define XIMStringConversionBuffer #x0001)
(define XIMStringConversionLine  #x0002)
(define XIMStringConversionWord  #x0003)
(define XIMStringConversionChar  #x0004)
(define XIMStringConversionSubstitution #x0001)
(define XIMStringConversionRetrieval #x0002)
(define XIMHotKeyStateON #x0001)
(define XIMHotKeyStateOFF #x0002)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; X.h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define X_PROTOCOL                      11)
(define X_PROTOCOL_REVISION             0)
(define None                            0)
(define ParentRelative                  1)
(define CopyFromParent                  0)
(define PointerWindow                   0)
(define InputFocus                      1)
(define PointerRoot                     1)
(define AnyPropertyType                 0)
(define AnyKey                          0)
(define AnyButton                       0)
(define AllTemporary                    0)
(define CurrentTime                     0)
(define NoSymbol                        0)
(define NoEventMask                     0)
(define KeyPressMask                    (expt 2 0))
(define KeyReleaseMask                  (expt 2 1))
(define ButtonPressMask                 (expt 2 2))
(define ButtonReleaseMask               (expt 2 3))
(define EnterWindowMask                 (expt 2 4))
(define LeaveWindowMask                 (expt 2 5))
(define PointerMotionMask               (expt 2 6))
(define PointerMotionHintMask           (expt 2 7))
(define Button1MotionMask               (expt 2 8))
(define Button2MotionMask               (expt 2 9))
(define Button3MotionMask               (expt 2 10))
(define Button4MotionMask               (expt 2 11))
(define Button5MotionMask               (expt 2 12))
(define ButtonMotionMask                (expt 2 13))
(define KeymapStateMask                 (expt 2 14))
(define ExposureMask                    (expt 2 15))
(define VisibilityChangeMask            (expt 2 16))
(define StructureNotifyMask             (expt 2 17))
(define ResizeRedirectMask              (expt 2 18))
(define SubstructureNotifyMask          (expt 2 19))
(define SubstructureRedirectMask        (expt 2 20))
(define FocusChangeMask                 (expt 2 21))
(define PropertyChangeMask              (expt 2 22))
(define ColormapChangeMask              (expt 2 23))
(define OwnerGrabButtonMask             (expt 2 24))
(define KeyPress                        2)
(define KeyRelease                      3)
(define ButtonPress                     4)
(define ButtonRelease                   5)
(define MotionNotify                    6)
(define EnterNotify                     7)
(define LeaveNotify                     8)
(define FocusIn                         9)
(define FocusOut                        10)
(define KeymapNotify                    11)
(define Expose                          12)
(define GraphicsExpose                  13)
(define NoExpose                        14)
(define VisibilityNotify                15)
(define CreateNotify                    16)
(define DestroyNotify                   17)
(define UnmapNotify                     18)
(define MapNotify                       19)
(define MapRequest                      20)
(define ReparentNotify                  21)
(define ConfigureNotify                 22)
(define ConfigureRequest                23)
(define GravityNotify                   24)
(define ResizeRequest                   25)
(define CirculateNotify                 26)
(define CirculateRequest                27)
(define PropertyNotify                  28)
(define SelectionClear                  29)
(define SelectionRequest                30)
(define SelectionNotify                 31)
(define ColormapNotify                  32)
(define ClientMessage                   33)
(define MappingNotify                   34)
(define LASTEvent                       35)
(define ShiftMask                       (expt 2 0))
(define LockMask                        (expt 2 1))
(define ControlMask                     (expt 2 2))
(define Mod1Mask                        (expt 2 3))
(define Mod2Mask                        (expt 2 4))
(define Mod3Mask                        (expt 2 5))
(define Mod4Mask                        (expt 2 6))
(define Mod5Mask                        (expt 2 7))
(define ShiftMapIndex                   0)
(define LockMapIndex                    1)
(define ControlMapIndex                 2)
(define Mod1MapIndex                    3)
(define Mod2MapIndex                    4)
(define Mod3MapIndex                    5)
(define Mod4MapIndex                    6)
(define Mod5MapIndex                    7)
(define Button1Mask                     (expt 2 8))
(define Button2Mask                     (expt 2 9))
(define Button3Mask                     (expt 2 10))
(define Button4Mask                     (expt 2 11))
(define Button5Mask                     (expt 2 12))
(define AnyModifier                     (expt 2 15))
(define Button1                         1)
(define Button2                         2)
(define Button3                         3)
(define Button4                         4)
(define Button5                         5)
(define NotifyNormal                    0)
(define NotifyGrab                      1)
(define NotifyUngrab                    2)
(define NotifyWhileGrabbed              3)
(define NotifyHint                      1)
(define NotifyAncestor                  0)
(define NotifyVirtual                   1)
(define NotifyInferior                  2)
(define NotifyNonlinear                 3)
(define NotifyNonlinearVirtual          4)
(define NotifyPointer                   5)
(define NotifyPointerRoot               6)
(define NotifyDetailNone                7)
(define VisibilityUnobscured            0)
(define VisibilityPartiallyObscured     1)
(define VisibilityFullyObscured         2)
(define PlaceOnTop                      0)
(define PlaceOnBottom                   1)
(define FamilyInternet                  0)
(define FamilyDECnet                    1)
(define FamilyChaos                     2)
(define FamilyInternet6                 6)
(define FamilyServerInterpreted         5)
(define PropertyNewValue                0)
(define PropertyDelete                  1)
(define ColormapUninstalled             0)
(define ColormapInstalled               1)
(define GrabModeSync                    0)
(define GrabModeAsync                   1)
(define GrabSuccess                     0)
(define AlreadyGrabbed                  1)
(define GrabInvalidTime                 2)
(define GrabNotViewable                 3)
(define GrabFrozen                      4)
(define AsyncPointer                    0)
(define SyncPointer                     1)
(define ReplayPointer                   2)
(define AsyncKeyboard                   3)
(define SyncKeyboard                    4)
(define ReplayKeyboard                  5)
(define AsyncBoth                       6)
(define SyncBoth                        7)
(define RevertToNone                    None)
(define RevertToPointerRoot             PointerRoot)
(define RevertToParent                  2)
(define Success                         0)
(define BadRequest                      1)
(define BadValue                        2)
(define BadWindow                       3)
(define BadPixmap                       4)
(define BadAtom                         5)
(define BadCursor                       6)
(define BadFont                         7)
(define BadMatch                        8)
(define BadDrawable                     9)
(define BadAccess                       10)
(define BadAlloc                        11)
(define BadColor                        12)
(define BadGC                           13)
(define BadIDChoice                     14)
(define BadName                         15)
(define BadLength                       16)
(define BadImplementation               17)
(define FirstExtensionError             128)
(define LastExtensionError              255)
(define InputOutput                     1)
(define InputOnly                       2)
(define CWBackPixmap                    (expt 2 0))
(define CWBackPixel                     (expt 2 1))
(define CWBorderPixmap                  (expt 2 2))
(define CWBorderPixel                   (expt 2 3))
(define CWBitGravity                    (expt 2 4))
(define CWWinGravity                    (expt 2 5))
(define CWBackingStore                  (expt 2 6))
(define CWBackingPlanes                 (expt 2 7))
(define CWBackingPixel                  (expt 2 8))
(define CWOverrideRedirect              (expt 2 9))
(define CWSaveUnder                     (expt 2 10))
(define CWEventMask                     (expt 2 11))
(define CWDontPropagate                 (expt 2 12))
(define CWColormap                      (expt 2 13))
(define CWCursor                        (expt 2 14))
(define CWX                             (expt 2 0))
(define CWY                             (expt 2 1))
(define CWWidth                         (expt 2 2))
(define CWHeight                        (expt 2 3))
(define CWBorderWidth                   (expt 2 4))
(define CWSibling                       (expt 2 5))
(define CWStackMode                     (expt 2 6))
(define ForgetGravity                   0)
(define NorthWestGravity                1)
(define NorthGravity                    2)
(define NorthEastGravity                3)
(define WestGravity                     4)
(define CenterGravity                   5)
(define EastGravity                     6)
(define SouthWestGravity                7)
(define SouthGravity                    8)
(define SouthEastGravity                9)
(define StaticGravity                   10)
(define UnmapGravity                    0)
(define NotUseful                       0)
(define WhenMapped                      1)
(define Always                          2)
(define IsUnmapped                      0)
(define IsUnviewable                    1)
(define IsViewable                      2)
(define SetModeInsert                   0)
(define SetModeDelete                   1)
(define DestroyAll                      0)
(define RetainPermanent                 1)
(define RetainTemporary                 2)
(define Above                           0)
(define Below                           1)
(define TopIf                           2)
(define BottomIf                        3)
(define Opposite                        4)
(define RaiseLowest                     0)
(define LowerHighest                    1)
(define PropModeReplace                 0)
(define PropModePrepend                 1)
(define PropModeAppend                  2)
(define GXclear                         #x0)
(define GXand                           #x1)
(define GXandReverse                    #x2)
(define GXcopy                          #x3)
(define GXandInverted                   #x4)
(define GXnoop                          #x5)
(define GXxor                           #x6)
(define GXor                            #x7)
(define GXnor                           #x8)
(define GXequiv                         #x9)
(define GXinvert                        #xa)
(define GXorReverse                     #xb)
(define GXcopyInverted                  #xc)
(define GXorInverted                    #xd)
(define GXnand                          #xe)
(define GXset                           #xf)
(define LineSolid                       0)
(define LineOnOffDash                   1)
(define LineDoubleDash                  2)
(define CapNotLast                      0)
(define CapButt                         1)
(define CapRound                        2)
(define CapProjecting                   3)
(define JoinMiter                       0)
(define JoinRound                       1)
(define JoinBevel                       2)
(define FillSolid                       0)
(define FillTiled                       1)
(define FillStippled                    2)
(define FillOpaqueStippled              3)
(define EvenOddRule                     0)
(define WindingRule                     1)
(define ClipByChildren                  0)
(define IncludeInferiors                1)
(define Unsorted                        0)
(define YSorted                         1)
(define YXSorted                        2)
(define YXBanded                        3)
(define CoordModeOrigin                 0)
(define CoordModePrevious               1)
(define Complex                         0)
(define Nonconvex                       1)
(define Convex                          2)
(define ArcChord                        0)
(define ArcPieSlice                     1)
(define GCFunction                      (expt 2 0))
(define GCPlaneMask                     (expt 2 1))
(define GCForeground                    (expt 2 2))
(define GCBackground                    (expt 2 3))
(define GCLineWidth                     (expt 2 4))
(define GCLineStyle                     (expt 2 5))
(define GCCapStyle                      (expt 2 6))
(define GCJoinStyle                     (expt 2 7))
(define GCFillStyle                     (expt 2 8))
(define GCFillRule                      (expt 2 9))
(define GCTile                          (expt 2 10))
(define GCStipple                       (expt 2 11))
(define GCTileStipXOrigin               (expt 2 12))
(define GCTileStipYOrigin               (expt 2 13))
(define GCFont                          (expt 2 14))
(define GCSubwindowMode                 (expt 2 15))
(define GCGraphicsExposures             (expt 2 16))
(define GCClipXOrigin                   (expt 2 17))
(define GCClipYOrigin                   (expt 2 18))
(define GCClipMask                      (expt 2 19))
(define GCDashOffset                    (expt 2 20))
(define GCDashList                      (expt 2 21))
(define GCArcMode                       (expt 2 22))
(define GCLastBit                       22)
(define FontLeftToRight                 0)
(define FontRightToLeft                 1)
(define FontChange                      255)
(define XYBitmap                        0)
(define XYPixmap                        1)
(define ZPixmap                         2)
(define AllocNone                       0)
(define AllocAll                        1)
(define DoRed                           (expt 2 0))
(define DoGreen                         (expt 2 1))
(define DoBlue                          (expt 2 2))
(define CursorShape                     0)
(define TileShape                       1)
(define StippleShape                    2)
(define AutoRepeatModeOff               0)
(define AutoRepeatModeOn                1)
(define AutoRepeatModeDefault           2)
(define LedModeOff                      0)
(define LedModeOn                       1)
(define KBKeyClickPercent               (expt 2 0))
(define KBBellPercent                   (expt 2 1))
(define KBBellPitch                     (expt 2 2))
(define KBBellDuration                  (expt 2 3))
(define KBLed                           (expt 2 4))
(define KBLedMode                       (expt 2 5))
(define KBKey                           (expt 2 6))
(define KBAutoRepeatMode                (expt 2 7))
(define MappingSuccess                  0)
(define MappingBusy                     1)
(define MappingFailed                   2)
(define MappingModifier                 0)
(define MappingKeyboard                 1)
(define MappingPointer                  2)
(define DontPreferBlanking              0)
(define PreferBlanking                  1)
(define DefaultBlanking                 2)
(define DisableScreenSaver              0)
(define DisableScreenInterval           0)
(define DontAllowExposures              0)
(define AllowExposures                  1)
(define DefaultExposures                2)
(define ScreenSaverReset                0)
(define ScreenSaverActive               1)
(define HostInsert                      0)
(define HostDelete                      1)
(define EnableAccess                    1)
(define DisableAccess                   0)
(define StaticGray                      0)
(define GrayScale                       1)
(define StaticColor                     2)
(define PseudoColor                     3)
(define TrueColor                       4)
(define DirectColor                     5)
(define LSBFirst                        0)
(define MSBFirst                        1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define XA_PRIMARY                      1)
(define XA_SECONDARY                    2)
(define XA_ARC                          3)
(define XA_ATOM                         4)
(define XA_BITMAP                       5)
(define XA_CARDINAL                     6)
(define XA_COLORMAP                     7)
(define XA_CURSOR                       8)
(define XA_CUT_BUFFER0                  9)
(define XA_CUT_BUFFER1                  10)
(define XA_CUT_BUFFER2                  11)
(define XA_CUT_BUFFER3                  12)
(define XA_CUT_BUFFER4                  13)
(define XA_CUT_BUFFER5                  14)
(define XA_CUT_BUFFER6                  15)
(define XA_CUT_BUFFER7                  16)
(define XA_DRAWABLE                     17)
(define XA_FONT                         18)
(define XA_INTEGER                      19)
(define XA_PIXMAP                       20)
(define XA_POINT                        21)
(define XA_RECTANGLE                    22)
(define XA_RESOURCE_MANAGER             23)
(define XA_RGB_COLOR_MAP                24)
(define XA_RGB_BEST_MAP                 25)
(define XA_RGB_BLUE_MAP                 26)
(define XA_RGB_DEFAULT_MAP              27)
(define XA_RGB_GRAY_MAP                 28)
(define XA_RGB_GREEN_MAP                29)
(define XA_RGB_RED_MAP                  30)
(define XA_STRING                       31)
(define XA_VISUALID                     32)
(define XA_WINDOW                       33)
(define XA_WM_COMMAND                   34)
(define XA_WM_HINTS                     35)
(define XA_WM_CLIENT_MACHINE            36)
(define XA_WM_ICON_NAME                 37)
(define XA_WM_ICON_SIZE                 38)
(define XA_WM_NAME                      39)
(define XA_WM_NORMAL_HINTS              40)
(define XA_WM_SIZE_HINTS                41)
(define XA_WM_ZOOM_HINTS                42)
(define XA_MIN_SPACE                    43)
(define XA_NORM_SPACE                   44)
(define XA_MAX_SPACE                    45)
(define XA_END_SPACE                    46)
(define XA_SUPERSCRIPT_X                47)
(define XA_SUPERSCRIPT_Y                48)
(define XA_SUBSCRIPT_X                  49)
(define XA_SUBSCRIPT_Y                  50)
(define XA_UNDERLINE_POSITION           51)
(define XA_UNDERLINE_THICKNESS          52)
(define XA_STRIKEOUT_ASCENT             53)
(define XA_STRIKEOUT_DESCENT            54)
(define XA_ITALIC_ANGLE                 55)
(define XA_X_HEIGHT                     56)
(define XA_QUAD_WIDTH                   57)
(define XA_WEIGHT                       58)
(define XA_POINT_SIZE                   59)
(define XA_RESOLUTION                   60)
(define XA_COPYRIGHT                    61)
(define XA_NOTICE                       62)
(define XA_FONT_NAME                    63)
(define XA_FAMILY_NAME                  64)
(define XA_FULL_NAME                    65)
(define XA_CAP_HEIGHT                   66)
(define XA_WM_CLASS                     67)
(define XA_WM_TRANSIENT_FOR             68)
(define XA_LAST_PREDEFINED              68)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cursorfont.h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define XC_num_glyphs                   154)
(define XC_X_cursor                     0)
(define XC_arrow                        2)
(define XC_based_arrow_down             4)
(define XC_based_arrow_up               6)
(define XC_boat                         8)
(define XC_bogosity                     10)
(define XC_bottom_left_corner           12)
(define XC_bottom_right_corner          14)
(define XC_bottom_side                  16)
(define XC_bottom_tee                   18)
(define XC_box_spiral                   20)
(define XC_center_ptr                   22)
(define XC_circle                       24)
(define XC_clock                        26)
(define XC_coffee_mug                   28)
(define XC_cross                        30)
(define XC_cross_reverse                32)
(define XC_crosshair                    34)
(define XC_diamond_cross                36)
(define XC_dot                          38)
(define XC_dotbox                       40)
(define XC_double_arrow                 42)
(define XC_draft_large                  44)
(define XC_draft_small                  46)
(define XC_draped_box                   48)
(define XC_exchange                     50)
(define XC_fleur                        52)
(define XC_gobbler                      54)
(define XC_gumby                        56)
(define XC_hand1                        58)
(define XC_hand2                        60)
(define XC_heart                        62)
(define XC_icon                         64)
(define XC_iron_cross                   66)
(define XC_left_ptr                     68)
(define XC_left_side                    70)
(define XC_left_tee                     72)
(define XC_leftbutton                   74)
(define XC_ll_angle                     76)
(define XC_lr_angle                     78)
(define XC_man                          80)
(define XC_middlebutton                 82)
(define XC_mouse                        84)
(define XC_pencil                       86)
(define XC_pirate                       88)
(define XC_plus                         90)
(define XC_question_arrow               92)
(define XC_right_ptr                    94)
(define XC_right_side                   96)
(define XC_right_tee                    98)
(define XC_rightbutton                  100)
(define XC_rtl_logo                     102)
(define XC_sailboat                     104)
(define XC_sb_down_arrow                106)
(define XC_sb_h_double_arrow            108)
(define XC_sb_left_arrow                110)
(define XC_sb_right_arrow               112)
(define XC_sb_up_arrow                  114)
(define XC_sb_v_double_arrow            116)
(define XC_shuttle                      118)
(define XC_sizing                       120)
(define XC_spider                       122)
(define XC_spraycan                     124)
(define XC_star                         126)
(define XC_target                       128)
(define XC_tcross                       130)
(define XC_top_left_arrow               132)
(define XC_top_left_corner              134)
(define XC_top_right_corner             136)
(define XC_top_side                     138)
(define XC_top_tee                      140)
(define XC_trek                         142)
(define XC_ul_angle                     144)
(define XC_umbrella                     146)
(define XC_ur_angle                     148)
(define XC_watch                        150)
(define XC_xterm                        152)

