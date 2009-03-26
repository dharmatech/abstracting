;;;; glut.scm

(use easyffi)

#>
#ifdef C_MACOSX
#include "GLUT/glut.h"
#else
#include "GL/glut.h"
#endif
<#

(foreign-parse #<<EOF

___declare(export_constants, yes)

typedef int GLint;
typedef float GLfloat;
typedef double GLdouble;
typedef int GLenum;


/* Display mode bit masks. */
#define GLUT_RGB			0
#define GLUT_RGBA			0
#define GLUT_INDEX			1
#define GLUT_SINGLE			0
#define GLUT_DOUBLE			2
#define GLUT_ACCUM			4
#define GLUT_ALPHA			8
#define GLUT_DEPTH			16
#define GLUT_STENCIL			32
#define GLUT_MULTISAMPLE		128
#define GLUT_STEREO			256
#define GLUT_LUMINANCE			512

/* Mouse buttons. */
#define GLUT_LEFT_BUTTON		0
#define GLUT_MIDDLE_BUTTON		1
#define GLUT_RIGHT_BUTTON		2

/* Mouse button  state. */
#define GLUT_DOWN			0
#define GLUT_UP				1

/* function keys */
#define GLUT_KEY_F1			1
#define GLUT_KEY_F2			2
#define GLUT_KEY_F3			3
#define GLUT_KEY_F4			4
#define GLUT_KEY_F5			5
#define GLUT_KEY_F6			6
#define GLUT_KEY_F7			7
#define GLUT_KEY_F8			8
#define GLUT_KEY_F9			9
#define GLUT_KEY_F10			10
#define GLUT_KEY_F11			11
#define GLUT_KEY_F12			12
/* directional keys */
#define GLUT_KEY_LEFT			100
#define GLUT_KEY_UP			101
#define GLUT_KEY_RIGHT			102
#define GLUT_KEY_DOWN			103
#define GLUT_KEY_PAGE_UP		104
#define GLUT_KEY_PAGE_DOWN		105
#define GLUT_KEY_HOME			106
#define GLUT_KEY_END			107
#define GLUT_KEY_INSERT			108

/* Entry/exit  state. */
#define GLUT_LEFT			0
#define GLUT_ENTERED			1

/* Menu usage  state. */
#define GLUT_MENU_NOT_IN_USE		0
#define GLUT_MENU_IN_USE		1

/* Visibility  state. */
#define GLUT_NOT_VISIBLE		0
#define GLUT_VISIBLE			1

/* Window status  state. */
#define GLUT_HIDDEN			0
#define GLUT_FULLY_RETAINED		1
#define GLUT_PARTIALLY_RETAINED		2
#define GLUT_FULLY_COVERED		3

/* Color index component selection values. */
#define GLUT_RED			0
#define GLUT_GREEN			1
#define GLUT_BLUE			2

/* Layers for use. */
#define GLUT_NORMAL			0
#define GLUT_OVERLAY			1

/* glutGet parameters. */
#define GLUT_WINDOW_X			100
#define GLUT_WINDOW_Y			101
#define GLUT_WINDOW_WIDTH		102
#define GLUT_WINDOW_HEIGHT		103
#define GLUT_WINDOW_BUFFER_SIZE		104
#define GLUT_WINDOW_STENCIL_SIZE	105
#define GLUT_WINDOW_DEPTH_SIZE		106
#define GLUT_WINDOW_RED_SIZE		107
#define GLUT_WINDOW_GREEN_SIZE		108
#define GLUT_WINDOW_BLUE_SIZE		109
#define GLUT_WINDOW_ALPHA_SIZE		110
#define GLUT_WINDOW_ACCUM_RED_SIZE	111
#define GLUT_WINDOW_ACCUM_GREEN_SIZE	112
#define GLUT_WINDOW_ACCUM_BLUE_SIZE	113
#define GLUT_WINDOW_ACCUM_ALPHA_SIZE	114
#define GLUT_WINDOW_DOUBLEBUFFER	115
#define GLUT_WINDOW_RGBA		116
#define GLUT_WINDOW_PARENT		117
#define GLUT_WINDOW_NUM_CHILDREN	118
#define GLUT_WINDOW_COLORMAP_SIZE	119
#define GLUT_WINDOW_NUM_SAMPLES		120
#define GLUT_WINDOW_STEREO		121
#define GLUT_WINDOW_CURSOR		122
#define GLUT_SCREEN_WIDTH		200
#define GLUT_SCREEN_HEIGHT		201
#define GLUT_SCREEN_WIDTH_MM		202
#define GLUT_SCREEN_HEIGHT_MM		203
#define GLUT_MENU_NUM_ITEMS		300
#define GLUT_DISPLAY_MODE_POSSIBLE	400
#define GLUT_INIT_WINDOW_X		500
#define GLUT_INIT_WINDOW_Y		501
#define GLUT_INIT_WINDOW_WIDTH		502
#define GLUT_INIT_WINDOW_HEIGHT		503
#define GLUT_INIT_DISPLAY_MODE		504
#define GLUT_ELAPSED_TIME		700
#define GLUT_WINDOW_FORMAT_ID		123

#define GLUT_HAS_KEYBOARD		600
#define GLUT_HAS_MOUSE			601
#define GLUT_HAS_SPACEBALL		602
#define GLUT_HAS_DIAL_AND_BUTTON_BOX	603
#define GLUT_HAS_TABLET			604
#define GLUT_NUM_MOUSE_BUTTONS		605
#define GLUT_NUM_SPACEBALL_BUTTONS	606
#define GLUT_NUM_BUTTON_BOX_BUTTONS	607
#define GLUT_NUM_DIALS			608
#define GLUT_NUM_TABLET_BUTTONS		609
#define GLUT_DEVICE_IGNORE_KEY_REPEAT   610
#define GLUT_DEVICE_KEY_REPEAT          611
#define GLUT_HAS_JOYSTICK		612
#define GLUT_OWNS_JOYSTICK		613
#define GLUT_JOYSTICK_BUTTONS		614
#define GLUT_JOYSTICK_AXES		615
#define GLUT_JOYSTICK_POLL_RATE		616

#define GLUT_OVERLAY_POSSIBLE           800
#define GLUT_LAYER_IN_USE		801
#define GLUT_HAS_OVERLAY		802
#define GLUT_TRANSPARENT_INDEX		803
#define GLUT_NORMAL_DAMAGED		804
#define GLUT_OVERLAY_DAMAGED		805

#define GLUT_VIDEO_RESIZE_POSSIBLE	900
#define GLUT_VIDEO_RESIZE_IN_USE	901
#define GLUT_VIDEO_RESIZE_X_DELTA	902
#define GLUT_VIDEO_RESIZE_Y_DELTA	903
#define GLUT_VIDEO_RESIZE_WIDTH_DELTA	904
#define GLUT_VIDEO_RESIZE_HEIGHT_DELTA	905
#define GLUT_VIDEO_RESIZE_X		906
#define GLUT_VIDEO_RESIZE_Y		907
#define GLUT_VIDEO_RESIZE_WIDTH		908
#define GLUT_VIDEO_RESIZE_HEIGHT	909

/* glutUseLayer parameters. */
#define GLUT_NORMAL			0
#define GLUT_OVERLAY			1

/* glutGetModifiers return mask. */
#define GLUT_ACTIVE_SHIFT               1
#define GLUT_ACTIVE_CTRL                2
#define GLUT_ACTIVE_ALT                 4

/* glutSetCursor parameters. */
/* Basic arrows. */
#define GLUT_CURSOR_RIGHT_ARROW		0
#define GLUT_CURSOR_LEFT_ARROW		1
/* Symbolic cursor shapes. */
#define GLUT_CURSOR_INFO		2
#define GLUT_CURSOR_DESTROY		3
#define GLUT_CURSOR_HELP		4
#define GLUT_CURSOR_CYCLE		5
#define GLUT_CURSOR_SPRAY		6
#define GLUT_CURSOR_WAIT		7
#define GLUT_CURSOR_TEXT		8
#define GLUT_CURSOR_CROSSHAIR		9
/* Directional cursors. */
#define GLUT_CURSOR_UP_DOWN		10
#define GLUT_CURSOR_LEFT_RIGHT		11
/* Sizing cursors. */
#define GLUT_CURSOR_TOP_SIDE		12
#define GLUT_CURSOR_BOTTOM_SIDE		13
#define GLUT_CURSOR_LEFT_SIDE		14
#define GLUT_CURSOR_RIGHT_SIDE		15
#define GLUT_CURSOR_TOP_LEFT_CORNER	16
#define GLUT_CURSOR_TOP_RIGHT_CORNER	17
#define GLUT_CURSOR_BOTTOM_RIGHT_CORNER	18
#define GLUT_CURSOR_BOTTOM_LEFT_CORNER	19
/* Inherit from parent window. */
#define GLUT_CURSOR_INHERIT		100
/* Blank cursor. */
#define GLUT_CURSOR_NONE		101
/* Fullscreen crosshair (if available). */
#define GLUT_CURSOR_FULL_CROSSHAIR	102

/* GLUT initialization sub-API. */
void  glutInitDisplayMode(unsigned int mode);
void  glutInitWindowPosition(int x, int y);
void  glutInitWindowSize(int width, int height);
___safe void  glutMainLoop(void);

/* GLUT window sub-API. */
int  glutCreateWindow(const char *title);
int  glutCreateSubWindow(int win, int x, int y, int width, int height);
void  glutDestroyWindow(int win);
void  glutPostRedisplay(void);
void  glutSwapBuffers(void);
int  glutGetWindow(void);
void  glutSetWindow(int win);
void  glutSetWindowTitle(const char *title);
void  glutSetIconTitle(const char *title);
void  glutPositionWindow(int x, int y);
void  glutReshapeWindow(int width, int height);
void  glutPopWindow(void);
void  glutPushWindow(void);
void  glutIconifyWindow(void);
void  glutShowWindow(void);
void  glutHideWindow(void);
void glutFullScreen(void);
void glutSetCursor(int cursor);

/* GLUT menu sub-API. */
int  glutCreateMenu(void ( *func)(int));
void  glutDestroyMenu(int menu);
int  glutGetMenu(void);
void  glutSetMenu(int menu);
void  glutAddMenuEntry(const char *label, int value);
void  glutAddSubMenu(const char *label, int submenu);
void  glutChangeToMenuEntry(int item, const char *label, int value);
void  glutChangeToSubMenu(int item, const char *label, int submenu);
void  glutRemoveMenuItem(int item);
void  glutAttachMenu(int button);
void  glutDetachMenu(int button);

/* GLUT window callback sub-API. */
void  glutDisplayFunc(void ( *func)(void));
void  glutReshapeFunc(void ( *func)(int width, int height));
void  glutKeyboardFunc(void ( *func)(unsigned char key, int x, int y));
void  glutMouseFunc(void ( *func)(int button, int state, int x, int y));
void  glutMotionFunc(void ( *func)(int x, int y));
void  glutPassiveMotionFunc(void ( *func)(int x, int y));
void  glutEntryFunc(void ( *func)(int state));
void  glutVisibilityFunc(void ( *func)(int state));
void  glutIdleFunc(void ( *func)(void));
void  glutTimerFunc(unsigned int millis, void ( *func)(int value), int value);
void  glutMenuStateFunc(void ( *func)(int state));
void glutSpecialFunc(void ( *func)(int key, int x, int y));
void glutSpaceballMotionFunc(void ( *func)(int x, int y, int z));
void glutSpaceballRotateFunc(void ( *func)(int x, int y, int z));
void glutSpaceballButtonFunc(void ( *func)(int button, int state));
void glutButtonBoxFunc(void ( *func)(int button, int state));
void  glutDialsFunc(void ( *func)(int dial, int value));
void  glutTabletMotionFunc(void ( *func)(int x, int y));
void  glutTabletButtonFunc(void ( *func)(int button, int state, int x, int y));
void  glutMenuStatusFunc(void ( *func)(int status, int x, int y));
void  glutOverlayDisplayFunc(void ( *func)(void));

/* GLUT color index sub-API. */
void  glutSetColor(int, GLfloat red, GLfloat green, GLfloat blue);
GLfloat  glutGetColor(int ndx, int component);
void  glutCopyColormap(int win);

/* GLUT state retrieval sub-API. */
int  glutGet(GLenum type);
int  glutDeviceGet(GLenum type);

int glutExtensionSupported(const char *name);
int  glutGetModifiers(void);
 int  glutLayerGet(GLenum type);

/* GLUT font sub-API */
void  glutBitmapCharacter(void *font, char character);
int  glutBitmapWidth(void *font, char character);
void  glutStrokeCharacter(void *font, char character);
int  glutStrokeWidth(void *font, char character);

/* GLUT pre-built models sub-API */
void  glutWireSphere(GLdouble radius, GLint slices, GLint stacks);
void  glutSolidSphere(GLdouble radius, GLint slices, GLint stacks);
void  glutWireCone(GLdouble base, GLdouble height, GLint slices, GLint stacks);
void  glutSolidCone(GLdouble base, GLdouble height, GLint slices, GLint stacks);
void  glutWireCube(GLdouble size);
void  glutSolidCube(GLdouble size);
void  glutWireTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings);
void  glutSolidTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings);
void  glutWireDodecahedron(void);
void  glutSolidDodecahedron(void);
void  glutWireTeapot(GLdouble size);
void  glutSolidTeapot(GLdouble size);
void  glutWireOctahedron(void);
void  glutSolidOctahedron(void);
void  glutWireTetrahedron(void);
void  glutSolidTetrahedron(void);
void  glutWireIcosahedron(void);
void  glutSolidIcosahedron(void);



/**** Peter Wang contributed these: ****/

/* GLUT initialization sub-API. */
void  glutInitDisplayString(const char *string);

/* GLUT window sub-API. */
void  glutPostWindowRedisplay(int win);
void  glutWarpPointer(int x, int y);

/* GLUT overlay sub-API. */
void  glutPostWindowOverlayRedisplay(int win);

/* GLUT window callback sub-API. */
void  glutWindowStatusFunc(void (*func)(int state));
void  glutKeyboardUpFunc(void (*func)(unsigned char key, int x, int y));
void  glutSpecialUpFunc(void (*func)(int key, int x, int y));
void  glutJoystickFunc(void (*func)(unsigned int buttonMask, int x, int y, int z), int pollInterval);

/* GLUT font sub-API */
int  glutBitmapLength(void *font, char *string);
int  glutStrokeLength(void *font, char *string);

/* GLUT video resize sub-API. */
int  glutVideoResizeGet(GLenum param);
void  glutSetupVideoResizing(void);
void  glutStopVideoResizing(void);
void  glutVideoResize(int x, int y, int width, int height);
void  glutVideoPan(int x, int y, int width, int height);

/* GLUT debugging sub-API. */
void  glutReportErrors(void);

/* GLUT device control sub-API. */
/* glutSetKeyRepeat modes. */
#define GLUT_KEY_REPEAT_OFF		0
#define GLUT_KEY_REPEAT_ON		1
#define GLUT_KEY_REPEAT_DEFAULT		2

/* Joystick button masks. */
#define GLUT_JOYSTICK_BUTTON_A		1
#define GLUT_JOYSTICK_BUTTON_B		2
#define GLUT_JOYSTICK_BUTTON_C		4
#define GLUT_JOYSTICK_BUTTON_D		8

void  glutIgnoreKeyRepeat(___bool ignore);
void  glutSetKeyRepeat(int repeatMode);
void  glutForceJoystickFunc(void);

/* GLUT game mode sub-API. */
/* glutGameModeGet. */
#define GLUT_GAME_MODE_ACTIVE           0
#define GLUT_GAME_MODE_POSSIBLE         1
#define GLUT_GAME_MODE_WIDTH            2
#define GLUT_GAME_MODE_HEIGHT           3
#define GLUT_GAME_MODE_PIXEL_DEPTH      4
#define GLUT_GAME_MODE_REFRESH_RATE     5
#define GLUT_GAME_MODE_DISPLAY_CHANGED  6

void  glutGameModeString(const char *string);
int  glutEnterGameMode(void);
void  glutLeaveGameMode(void);
int  glutGameModeGet(GLenum mode);

EOF
)

(declare
  (hide callbacks set-callback find-callback
	create_menu_cb display_cb reshape_cb keyboard_cb mouse_cb motion_cb passive_motion_cb entry_cb visibility_cb idle_cb timer_cb
	menu_state_cb special_cb spaceball_motion_cb spaceball_rotate_cb spaceball_button_cb button_box_cb dials_cb tablet_motion_cb
	tablet_button_cb menu_status_cb overlay_display_cb window_status_cb keyboard_up_cb special_up_cb joystick_cb
	glutInit) )

(define callbacks '())

(define (set-callback type proc)
  (let* ([w (glutGetWindow)]
	 [a (assq w callbacks)] )
    (if a
	(let ([b (assq type (cdr a))])
	  (if b
	      (set-cdr! b proc)
	      (set-cdr! a (cons (cons type proc) (cdr a))) ) )
	(set! callbacks (cons (cons w (list (cons type proc))) callbacks)) ) ) )

(define (find-callback type k)
  (and-let* ([a (assq (glutGetWindow) callbacks)]
	     [b (assq type (cdr a))] 
	     [c (cdr b)] )
    (k c) ) )

(define-external (create_menu_cb (int i)) void (find-callback 'create-menu (cut <> i)))
(define-external (display_cb) void (find-callback 'display (cut <>)))
(define-external (reshape_cb (int w) (int h)) void (find-callback 'reshape (cut <> w h)))
(define-external (keyboard_cb (char k) (int x) (int y)) void (find-callback 'keyboard (cut <> k x y)))
(define-external (mouse_cb (int button) (int state) (int x) (int y)) void (find-callback 'mouse (cut <> button state x y)))
(define-external (motion_cb (int x) (int y)) void (find-callback 'motion (cut <> x y)))
(define-external (passive_motion_cb (int x) (int y)) void (find-callback 'passive-motion (cut <> x y)))
(define-external (entry_cb (int state)) void (find-callback 'entry (cut <> state)))
(define-external (visibility_cb (int state)) void (find-callback 'visibility (cut <> state)))
(define-external (idle_cb) void (find-callback 'idle (cut <>)))
(define-external (timer_cb (int i)) void (find-callback 'timer (cut <> i)))
(define-external (menu_state_cb (int state)) void (find-callback 'menu-state (cut <> state)))
(define-external (special_cb (int key) (int x) (int y)) void (find-callback 'special (cut <> key x y)))
(define-external (spaceball_motion_cb (int key) (int x) (int y)) void (find-callback 'spaceball-motion (cut <> key x y)))
(define-external (spaceball_rotate_cb (int key) (int x) (int y)) void (find-callback 'spaceball-rotate (cut <> key x y)))
(define-external (spaceball_button_cb (int key) (int x)) void (find-callback 'spaceball-button (cut <> key x)))
(define-external (button_box_cb (int key) (int x)) void (find-callback 'button-box (cut <> key x)))
(define-external (dials_cb (int key) (int x)) void (find-callback 'dials (cut <> key x)))
(define-external (tablet_motion_cb (int key) (int x)) void (find-callback 'tablet-motion (cut <> key x)))
(define-external (tablet_button_cb (int key) (int state) (int x) (int y)) void (find-callback 'tablet-button (cut <> key state x y)))
(define-external (menu_status_cb (int status) (int x) (int y)) void (find-callback 'menu-status (cut <> status x y)))
(define-external (overlay_display_cb) void (find-callback 'overlay-display (cut <>)))
(define-external (window_status_cb (int s)) void (find-callback 'window-status (cut <> s)))
(define-external (keyboard_up_cb (unsigned-char k) (int x) (int y)) void (find-callback 'keyboard-up (cut <> k x y)))
(define-external (special_up_cb (int k) (int x) (int y)) void (find-callback 'special-up (cut <> k x y)))
(define-external (joystick_cb (unsigned-int b) (int x) (int y) (int z)) void (find-callback 'joystick (cut <> b x y z)))

(define glutCreateMenu (let ([old glutCreateMenu]) (lambda (proc) (old (location create_menu_cb)) (set-callback 'create-menu proc))))
(define glutDisplayFunc (let ([old glutDisplayFunc]) (lambda (proc) (old (location display_cb)) (set-callback 'display proc))))
(define glutReshapeFunc (let ([old glutReshapeFunc]) (lambda (proc) (old (location reshape_cb)) (set-callback 'reshape proc))))
(define glutKeyboardFunc (let ([old glutKeyboardFunc]) (lambda (proc) (old (location keyboard_cb)) (set-callback 'keyboard proc))))
(define glutMouseFunc (let ([old glutMouseFunc]) (lambda (proc) (old (location mouse_cb)) (set-callback 'mouse proc))))
(define glutMotionFunc (let ([old glutMotionFunc]) (lambda (proc) (old (location motion_cb)) (set-callback 'motion proc))))
(define glutPassiveMotionFunc (let ([old glutPassiveMotionFunc]) (lambda (proc) (old (location passive_motion_cb)) (set-callback 'passive-motion proc))))
(define glutEntryFunc (let ([old glutEntryFunc]) (lambda (proc) (old (location entry_cb)) (set-callback 'entry proc))))
(define glutVisibilityFunc (let ([old glutVisibilityFunc]) (lambda (proc) (old (location visibility_cb)) (set-callback 'visibility proc))))
(define glutIdleFunc (let ([old glutIdleFunc]) (lambda (proc) (old (location idle_cb)) (set-callback 'idle proc))))
(define glutTimerFunc (let ([old glutTimerFunc]) (lambda (ms proc val) (old ms (location timer_cb) val) (set-callback 'timer proc))))
(define glutMenuStateFunc (let ([old glutMenuStateFunc]) (lambda (proc) (old (location menu_state_cb)) (set-callback 'menu-state proc))))
(define glutSpecialFunc (let ([old glutSpecialFunc]) (lambda (proc) (old (location special_cb)) (set-callback 'special proc))))
(define glutSpaceballMotionFunc 
  (let ([old glutSpaceballMotionFunc]) (lambda (proc) (old (location spaceball_motion_cb)) (set-callback 'spaceball-motion proc))))
(define glutSpaceballRotateFunc 
  (let ([old glutSpaceballRotateFunc]) (lambda (proc) (old (location spaceball_rotate_cb)) (set-callback 'spaceball-rotate proc))))
(define glutSpaceballButtonFunc 
  (let ([old glutSpaceballButtonFunc]) (lambda (proc) (old (location spaceball_button_cb)) (set-callback 'spaceball-button proc))))
(define glutButtonBoxFunc (let ([old glutButtonBoxFunc]) (lambda (proc) (old (location button_box_cb)) (set-callback 'button-box proc))))
(define glutDialsFunc (let ([old glutDialsFunc]) (lambda (proc) (old (location dials_cb)) (set-callback 'dials proc))))
(define glutTabletMotionFunc (let ([old glutTabletMotionFunc]) (lambda (proc) (old (location tablet_motion_cb)) (set-callback 'tablet-motion proc))))
(define glutTabletButtonFunc (let ([old glutTabletButtonFunc]) (lambda (proc) (old (location tablet_button_cb)) (set-callback 'tablet-button proc))))
(define glutMenuStatusFunc (let ([old glutMenuStatusFunc]) (lambda (proc) (old (location menu_status_cb)) (set-callback 'menu-status proc))))
(define glutOverlayDisplayFunc
  (let ([old glutOverlayDisplayFunc]) (lambda (proc) (old (location overlay_display_cb)) (set-callback 'overlay-display proc))))

(define glutWindowStatusFunc (let ([old glutWindowStatusFunc]) (lambda (proc) (old (location window_status_cb)) (set-callback 'window-status proc))))
(define glutKeyboardUpFunc (let ([old glutKeyboardUpFunc]) (lambda (proc) (old (location keyboard_up_cb)) (set-callback 'keyboard-up proc))))
(define glutSpecialUpFunc (let ([old glutSpecialUpFunc]) (lambda (proc) (old (location special_up_cb)) (set-callback 'special-up proc))))
(define glutJoystickFunc (let ([old glutJoystickFunc]) (lambda (proc interval) (old (location joystick_cb) interval) (set-callback 'joystick proc))))

;; (define-foreign-variable GLUT_STROKE_ROMAN c-pointer)
;; (define-foreign-variable GLUT_STROKE_MONO_ROMAN c-pointer)
;; (define-foreign-variable GLUT_BITMAP_9_BY_15 c-pointer)
;; (define-foreign-variable GLUT_BITMAP_8_BY_13 c-pointer)
;; (define-foreign-variable GLUT_BITMAP_TIMES_ROMAN_10 c-pointer)
;; (define-foreign-variable GLUT_BITMAP_TIMES_ROMAN_24 c-pointer)
;; (define-foreign-variable GLUT_BITMAP_HELVETICA_10 c-pointer)
;; (define-foreign-variable GLUT_BITMAP_HELVETICA_12 c-pointer)
;; (define-foreign-variable GLUT_BITMAP_HELVETICA_18 c-pointer)

;; (define GLUT_STROKE_ROMAN GLUT_STROKE_ROMAN)
;; (define GLUT_STROKE_MONO_ROMAN GLUT_STROKE_MONO_ROMAN)
;; (define GLUT_BITMAP_9_BY_15 GLUT_BITMAP_9_BY_15)
;; (define GLUT_BITMAP_8_BY_13 GLUT_BITMAP_8_BY_13)
;; (define GLUT_BITMAP_TIMES_ROMAN_10 GLUT_BITMAP_TIMES_ROMAN_10)
;; (define GLUT_BITMAP_TIMES_ROMAN_24 GLUT_BITMAP_TIMES_ROMAN_24)
;; (define GLUT_BITMAP_HELVETICA_10 GLUT_BITMAP_HELVETICA_10)
;; (define GLUT_BITMAP_HELVETICA_12 GLUT_BITMAP_HELVETICA_12)
;; (define GLUT_BITMAP_HELVETICA_18 GLUT_BITMAP_HELVETICA_18)

 (foreign-code "glutInit(&C_main_argc, C_main_argv);")
