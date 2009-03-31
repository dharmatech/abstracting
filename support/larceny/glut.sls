
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Copyright (c) 2004-2008 Yoshikatsu Fujita. All rights reserved.
;; Copyright (c) 2004-2008 LittleWing Company Limited. All rights reserved.

;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:

;; 1. Redistributions of source code must retain the above copyright notice,
;;    this list of conditions and the following disclaimer.
;; 2. Redistributions in binary form must reproduce the above copyright notice,
;;    this list of conditions and the following disclaimer in the documentation
;;    and/or other materials provided with the distribution.
;; 3. Neither the name of the authors nor the names of its contributors may be
;;    used to endorse or promote products derived from this software without
;;    specific prior written permission.

;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;; POSSIBILITY OF SUCH DAMAGE.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This library is derived from 'glut.scm' from Ypsilon Scheme.
;;
;; Ported to Larceny Scheme by Ed Cavazos <wayo.cavazos@gmail.com>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(library

 (glut)
 
 (export GLUT_RGB
         GLUT_RGBA
         GLUT_INDEX
         GLUT_SINGLE
         GLUT_DOUBLE
         GLUT_ACCUM
         GLUT_ALPHA
         GLUT_DEPTH
         GLUT_STENCIL
         GLUT_MULTISAMPLE
         GLUT_STEREO
         GLUT_LUMINANCE
         GLUT_NO_RECOVERY
         GLUT_LEFT_BUTTON
         GLUT_MIDDLE_BUTTON
         GLUT_RIGHT_BUTTON
         GLUT_DOWN
         GLUT_UP
         GLUT_KEY_F1
         GLUT_KEY_F2
         GLUT_KEY_F3
         GLUT_KEY_F4
         GLUT_KEY_F5
         GLUT_KEY_F6
         GLUT_KEY_F7
         GLUT_KEY_F8
         GLUT_KEY_F9
         GLUT_KEY_F10
         GLUT_KEY_F11
         GLUT_KEY_F12
         GLUT_KEY_LEFT
         GLUT_KEY_UP
         GLUT_KEY_RIGHT
         GLUT_KEY_DOWN
         GLUT_KEY_PAGE_UP
         GLUT_KEY_PAGE_DOWN
         GLUT_KEY_HOME
         GLUT_KEY_END
         GLUT_KEY_INSERT
         GLUT_LEFT
         GLUT_ENTERED
         GLUT_MENU_NOT_IN_USE
         GLUT_MENU_IN_USE
         GLUT_NOT_VISIBLE
         GLUT_VISIBLE
         GLUT_HIDDEN
         GLUT_FULLY_RETAINED
         GLUT_PARTIALLY_RETAINED
         GLUT_FULLY_COVERED
         GLUT_RED
         GLUT_GREEN
         GLUT_BLUE
         GLUT_NORMAL
         GLUT_OVERLAY
         glutInit
         glutInitDisplayString
         glutInitDisplayMode
         glutInitWindowPosition
         glutInitWindowSize
         glutMainLoop
         glutCreateWindow
         glutCreateSubWindow
         glutDestroyWindow
         glutPostRedisplay
         glutPostWindowRedisplay
         glutSwapBuffers
         glutGetWindow
         glutSetWindow
         glutSetWindowTitle
         glutSetIconTitle
         glutPositionWindow
         glutReshapeWindow
         glutPopWindow
         glutPushWindow
         glutIconifyWindow
         glutShowWindow
         glutHideWindow
         glutFullScreen
         glutSetCursor
         glutWarpPointer
         glutEstablishOverlay
         glutRemoveOverlay
         glutUseLayer
         glutPostOverlayRedisplay
         glutPostWindowOverlayRedisplay
         glutShowOverlay
         glutHideOverlay
         glutCreateMenu
         glutDestroyMenu
         glutGetMenu
         glutSetMenu
         glutAddMenuEntry
         glutAddSubMenu
         glutChangeToMenuEntry
         glutChangeToSubMenu
         glutRemoveMenuItem
         glutAttachMenu
         glutDetachMenu
         glutDisplayFunc
         glutReshapeFunc
         glutKeyboardFunc
         glutMouseFunc
         glutMotionFunc
         glutPassiveMotionFunc
         glutEntryFunc
         glutVisibilityFunc
         glutIdleFunc
         glutTimerFunc
         glutMenuStateFunc
         glutSpecialFunc
         glutSpaceballMotionFunc
         glutSpaceballRotateFunc
         glutSpaceballButtonFunc
         glutButtonBoxFunc
         glutDialsFunc
         glutTabletMotionFunc
         glutTabletButtonFunc
         glutMenuStatusFunc
         glutOverlayDisplayFunc
         glutWindowStatusFunc
         glutKeyboardUpFunc
         glutSpecialUpFunc
         glutJoystickFunc
         glutSetColor
         glutGetColor
         glutCopyColormap
         glutGet
         glutDeviceGet
         glutExtensionSupported
         glutGetModifiers
         glutLayerGet
         glutGetProcAddress
         glutBitmapCharacter
         glutBitmapWidth
         glutStrokeCharacter
         glutStrokeWidth
         glutBitmapLength
         glutStrokeLength
         glutWireSphere
         glutSolidSphere
         glutWireCone
         glutSolidCone
         glutWireCube
         glutSolidCube
         glutWireTorus
         glutSolidTorus
         glutWireDodecahedron
         glutSolidDodecahedron
         glutWireTeapot
         glutSolidTeapot
         glutWireOctahedron
         glutSolidOctahedron
         glutWireTetrahedron
         glutSolidTetrahedron
         glutWireIcosahedron
         glutSolidIcosahedron
         glutVideoResizeGet
         glutSetupVideoResizing
         glutStopVideoResizing
         glutVideoResize
         glutVideoPan
         glutReportErrors
         glutIgnoreKeyRepeat
         glutSetKeyRepeat
         glutForceJoystickFunc
         glutGameModeString
         glutEnterGameMode
         glutLeaveGameMode
         glutGameModeGet)

 (import (rnrs base)
	 (rnrs lists)
 	 (rnrs io simple)
	 (rnrs files)
 	 (err5rs records syntactic)

	 (primitives system-features
		     foreign-file
		     foreign-procedure))
 
 ;; (define libGLUT (cond (on-darwin  (load-shared-object "GLUT.framework/GLUT"))
 ;;                       (on-windows (load-shared-object "glut32.dll"))
 ;;                       (on-linux   (load-shared-object "libglut.so.3"))
 ;;                       (on-freebsd (load-shared-object "libglut.so"))
 ;;                       (on-openbsd (begin (load-shared-object "libXmu.so.10.0")
 ;;                                          (load-shared-object "libGLU.so.7.0")
 ;;                                          (load-shared-object "libglut.so.3.7")))
 ;;                       (else
 ;;                        (assertion-violation #f "can not locate GLUT library, unknown operating system"))))

 (define libGLUT

   (let ((os (cdr (assq 'os-name (system-features)))))

     (cond ((string=? os "MacOS X")  (foreign-file "GLUT.framework/GLUT"))
	   ((string=? os "Win32")    (foreign-file "glut32.dll"))
	   ((string=? os "Linux")    (foreign-file "libglut.so.3"))
	   (else
	    (assertion-violation #f
				 (string-append "can not locate GLUT library,"
						" unknown operating system"))))))

  ;; Display mode bit masks.
  (define GLUT_RGB                0)
  (define GLUT_RGBA               GLUT_RGB)
  (define GLUT_INDEX              1)
  (define GLUT_SINGLE             0)
  (define GLUT_DOUBLE             2)
  (define GLUT_ACCUM              4)
  (define GLUT_ALPHA              8)
  (define GLUT_DEPTH              16)
  (define GLUT_STENCIL            32)
  (define GLUT_MULTISAMPLE        128)
  (define GLUT_STEREO             256)
  (define GLUT_LUMINANCE          512)
  (define GLUT_NO_RECOVERY        1024)

  ;; Mouse buttons.
  (define GLUT_LEFT_BUTTON        0)
  (define GLUT_MIDDLE_BUTTON      1)
  (define GLUT_RIGHT_BUTTON       2)

  ;; Mouse button  state.
  (define GLUT_DOWN               0)
  (define GLUT_UP                 1)

  ;; function keys
  (define GLUT_KEY_F1             1)
  (define GLUT_KEY_F2             2)
  (define GLUT_KEY_F3             3)
  (define GLUT_KEY_F4             4)
  (define GLUT_KEY_F5             5)
  (define GLUT_KEY_F6             6)
  (define GLUT_KEY_F7             7)
  (define GLUT_KEY_F8             8)
  (define GLUT_KEY_F9             9)
  (define GLUT_KEY_F10            10)
  (define GLUT_KEY_F11            11)
  (define GLUT_KEY_F12            12)

  ;; directional keys
  (define GLUT_KEY_LEFT           100)
  (define GLUT_KEY_UP             101)
  (define GLUT_KEY_RIGHT          102)
  (define GLUT_KEY_DOWN           103)
  (define GLUT_KEY_PAGE_UP        104)
  (define GLUT_KEY_PAGE_DOWN      105)
  (define GLUT_KEY_HOME           106)
  (define GLUT_KEY_END            107)
  (define GLUT_KEY_INSERT         108)

  ;; Entry/exit  state.
  (define GLUT_LEFT               0)
  (define GLUT_ENTERED            1)

  ;; Menu usage  state.
  (define GLUT_MENU_NOT_IN_USE    0)
  (define GLUT_MENU_IN_USE        1)

  ;; Visibility  state.
  (define GLUT_NOT_VISIBLE        0)
  (define GLUT_VISIBLE            1)

  ;; Window status  state.
  (define GLUT_HIDDEN             0)
  (define GLUT_FULLY_RETAINED     1)
  (define GLUT_PARTIALLY_RETAINED 2)
  (define GLUT_FULLY_COVERED      3)

  ;; Color index component selection values.
  (define GLUT_RED                0)
  (define GLUT_GREEN              1)
  (define GLUT_BLUE               2)

  ;; Layers for use.
  (define GLUT_NORMAL             0)
  (define GLUT_OVERLAY            1)

  (define-syntax define-function
    (syntax-rules ()
      ((_ ret name args)
       (define name (foreign-procedure (symbol->string 'name) 'args 'ret)))))

  ;; void glutInit(int *argcp, char **argv)
  ;; (define-function void glutInit ([int] [char*]))
  
  ;; (define glutInit
  ;;   (if on-windows
  ;;       (lambda (a1 a2)
  ;;         (c-argument 'glutInit 1 [int] a1)
  ;;         (c-argument 'glutInit 2 [char*] a2)
  ;;         ((c-function libGLUT "GLUT library" void __stdcall __glutInitWithExit ([int] [char*] [c-callback void (int)]))
  ;;          a1 a2 (lambda (n) (exit n))))
  ;;       (c-function libGLUT "GLUT library" void __stdcall glutInit ([int] [char*]))))

  (define-function void glutInit (boxed boxed))

  ;; void glutInitDisplayString(const char *string)
  (define-function void glutInitDisplayString (string))

  ;; void glutInitDisplayMode(unsigned int mode)
  (define-function void glutInitDisplayMode (int))

  ;; void glutInitWindowPosition(int x, int y)
  (define-function void glutInitWindowPosition (int int))

  ;; void glutInitWindowSize(int width, int height)
  (define-function void glutInitWindowSize (int int))

  ;; void glutMainLoop(void)
  (define-function void glutMainLoop ())

  ;; int glutCreateWindow(const char *title)
  (define-function int glutCreateWindow (string))

  ;; int glutCreateSubWindow(int win, int x, int y, int width, int height)
  (define-function int glutCreateSubWindow (int int int int int))

  ;; void glutDestroyWindow(int win)
  (define-function void glutDestroyWindow (int))

  ;; void glutPostRedisplay(void)
  (define-function void glutPostRedisplay ())

  ;; void glutPostWindowRedisplay(int win)
  (define-function void glutPostWindowRedisplay (int))

  ;; void glutSwapBuffers(void)
  (define-function void glutSwapBuffers ())

  ;; int glutGetWindow(void)
  (define-function int glutGetWindow ())

  ;; void glutSetWindow(int win)
  (define-function void glutSetWindow (int))

  ;; void glutSetWindowTitle(const char *title)
  (define-function void glutSetWindowTitle (string))

  ;; void glutSetIconTitle(const char *title)
  (define-function void glutSetIconTitle (string))

  ;; void glutPositionWindow(int x, int y)
  (define-function void glutPositionWindow (int int))

  ;; void glutReshapeWindow(int width, int height)
  (define-function void glutReshapeWindow (int int))

  ;; void glutPopWindow(void)
  (define-function void glutPopWindow ())

  ;; void glutPushWindow(void)
  (define-function void glutPushWindow ())

  ;; void glutIconifyWindow(void)
  (define-function void glutIconifyWindow ())

  ;; void glutShowWindow(void)
  (define-function void glutShowWindow ())

  ;; void glutHideWindow(void)
  (define-function void glutHideWindow ())

  ;; void glutFullScreen(void)
  (define-function void glutFullScreen ())

  ;; void glutSetCursor(int cursor)
  (define-function void glutSetCursor (int))

  ;; void glutWarpPointer(int x, int y)
  (define-function void glutWarpPointer (int int))

  ;; void glutEstablishOverlay(void)
  (define-function void glutEstablishOverlay ())

  ;; void glutRemoveOverlay(void)
  (define-function void glutRemoveOverlay ())

  ;; void glutUseLayer(GLenum layer)
  (define-function void glutUseLayer (int))

  ;; void glutPostOverlayRedisplay(void)
  (define-function void glutPostOverlayRedisplay ())

  ;; void glutPostWindowOverlayRedisplay(int win)
  (define-function void glutPostWindowOverlayRedisplay (int))

  ;; void glutShowOverlay(void)
  (define-function void glutShowOverlay ())

  ;; void glutHideOverlay(void)
  (define-function void glutHideOverlay ())

  ;; int glutCreateMenu(void (*)(int))
  (define-function void glutCreateMenu ([-> (int) void]))

  ;; void glutDestroyMenu(int menu)
  (define-function void glutDestroyMenu (int))

  ;; int glutGetMenu(void)
  (define-function int glutGetMenu ())

  ;; void glutSetMenu(int menu)
  (define-function void glutSetMenu (int))

  ;; void glutAddMenuEntry(const char *label, int value)
  (define-function void glutAddMenuEntry (string int))

  ;; void glutAddSubMenu(const char *label, int submenu)
  (define-function void glutAddSubMenu (string int))

  ;; void glutChangeToMenuEntry(int item, const char *label, int value)
  (define-function void glutChangeToMenuEntry (int string int))

  ;; void glutChangeToSubMenu(int item, const char *label, int submenu)
  (define-function void glutChangeToSubMenu (int string int))

  ;; void glutRemoveMenuItem(int item)
  (define-function void glutRemoveMenuItem (int))

  ;; void glutAttachMenu(int button)
  (define-function void glutAttachMenu (int))

  ;; void glutDetachMenu(int button)
  (define-function void glutDetachMenu (int))

  ;; void glutDisplayFunc(void (*func)(void))
  (define-function void glutDisplayFunc ([-> () void]))

  ;; void glutReshapeFunc(void (*func)(int width, int height))
  (define-function void glutReshapeFunc ([-> (int int) void]))

  ;; void glutKeyboardFunc(void (*func)(unsigned char key, int x, int y))
  (define-function void glutKeyboardFunc ([-> (int int int) void]))

  ;; void glutMouseFunc(void (*func)(int button, int state, int x, int y))
  (define-function void glutMouseFunc ([-> (int int int int) void]))

  ;; void glutMotionFunc(void (*func)(int x, int y))
  (define-function void glutMotionFunc ([-> (int int) void]))

  ;; void glutPassiveMotionFunc(void (*func)(int x, int y))
  (define-function void glutPassiveMotionFunc ([-> (int int) void]))

  ;; void glutEntryFunc(void (*func)(int state))
  (define-function void glutEntryFunc ([-> (int) void]))

  ;; void glutVisibilityFunc(void (*func)(int state))
  (define-function void glutVisibilityFunc ([-> (int) void]))

  ;; void glutIdleFunc(void (*func)(void))
  (define-function void glutIdleFunc ([-> () void]))

  ;; void glutTimerFunc(unsigned int millis, void (*func)(int value), int value)
  (define-function void glutTimerFunc (int [-> (int) void] int))

  ;; void glutMenuStateFunc(void (*func)(int state))
  (define-function void glutMenuStateFunc ([-> (int) void]))

  ;; void glutSpecialFunc(void (*func)(int key, int x, int y))
  (define-function void glutSpecialFunc ([-> (int int int) void]))

  ;; void glutSpaceballMotionFunc(void (*func)(int x, int y, int z))
  (define-function void glutSpaceballMotionFunc ([-> (int int int) void]))

  ;; void glutSpaceballRotateFunc(void (*func)(int x, int y, int z))
  (define-function void glutSpaceballRotateFunc ([-> (int int int) void]))

  ;; void glutSpaceballButtonFunc(void (*func)(int button, int state))
  (define-function void glutSpaceballButtonFunc ([-> (int int) void]))

  ;; void glutButtonBoxFunc(void (*func)(int button, int state))
  (define-function void glutButtonBoxFunc ([-> (int int) void]))

  ;; void glutDialsFunc(void (*func)(int dial, int value))
  (define-function void glutDialsFunc ([-> (int int) void]))

  ;; void glutTabletMotionFunc(void (*func)(int x, int y))
  (define-function void glutTabletMotionFunc ([-> (int int) void]))

  ;; void glutTabletButtonFunc(void (*func)(int button, int state, int x, int y))
  (define-function void glutTabletButtonFunc ([-> (int int int int) void]))

  ;; void glutMenuStatusFunc(void (*func)(int status, int x, int y))
  (define-function void glutMenuStatusFunc ([-> (int int int) void]))

  ;; void glutOverlayDisplayFunc(void (*func)(void))
  (define-function void glutOverlayDisplayFunc ([-> () void]))

  ;; void glutWindowStatusFunc(void (*func)(int state))
  (define-function void glutWindowStatusFunc ([-> (int) void]))

  ;; void glutKeyboardUpFunc(void (*func)(unsigned char key, int x, int y))
  (define-function void glutKeyboardUpFunc ([-> (int int int) void]))

  ;; void glutSpecialUpFunc(void (*func)(int key, int x, int y))
  (define-function void glutSpecialUpFunc ([-> (int int int) void]))

  ;; void glutJoystickFunc(void (*func)(unsigned int buttonMask, int x, int y, int z), int pollInterval)
  (define-function void glutJoystickFunc ([-> (int int int int) void] int))

  ;; void glutSetColor(int, GLfloat red, GLfloat green, GLfloat blue)
  (define-function void glutSetColor (int float float float))

  ;; GLfloat glutGetColor(int ndx, int component)
  (define-function double glutGetColor (int int))

  ;; void glutCopyColormap(int win)
  (define-function void glutCopyColormap (int))

  ;; int glutGet(GLenum type)
  (define-function int glutGet (int))

  ;; int glutDeviceGet(GLenum type)
  (define-function int glutDeviceGet (int))

  ;; int glutExtensionSupported(const char *name)
  (define-function int glutExtensionSupported (string))

  ;; int glutGetModifiers(void)
  (define-function int glutGetModifiers ())

  ;; int glutLayerGet(GLenum type)
  (define-function int glutLayerGet (int))

  ;; void * glutGetProcAddress(const char *procName)
  (define-function void* glutGetProcAddress (string))

  ;; void glutBitmapCharacter(void *font, int character)
  (define-function void* glutBitmapCharacter (void* int))

  ;; int glutBitmapWidth(void *font, int character)
  (define-function int glutBitmapWidth (void* int))

  ;; void glutStrokeCharacter(void *font, int character)
  (define-function void glutStrokeCharacter (void* int))

  ;; int glutStrokeWidth(void *font, int character)
  (define-function int glutStrokeWidth (void* int))

  ;; int glutBitmapLength(void *font, const unsigned char *string)
  (define-function int glutBitmapLength (void* string))

  ;; int glutStrokeLength(void *font, const unsigned char *string)
  (define-function int glutStrokeLength (void* string))

  ;; void glutWireSphere(GLdouble radius, GLint slices, GLint stacks)
  (define-function int glutWireSphere (double int int))

  ;; void glutSolidSphere(GLdouble radius, GLint slices, GLint stacks)
  (define-function void glutSolidSphere (double int int))

  ;; void glutWireCone(GLdouble base, GLdouble height, GLint slices, GLint stacks)
  (define-function void glutWireCone (double double int int))

  ;; void glutSolidCone(GLdouble base, GLdouble height, GLint slices, GLint stacks)
  (define-function void glutSolidCone (double double int int))

  ;; void glutWireCube(GLdouble size)
  (define-function void glutWireCube (double))

  ;; void glutSolidCube(GLdouble size)
  (define-function void glutSolidCube (double))

  ;; void glutWireTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings)
  (define-function void glutWireTorus (double double int int))

  ;; void glutSolidTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings)
  (define-function void glutSolidTorus (double double int int))

  ;; void glutWireDodecahedron(void)
  (define-function void glutWireDodecahedron ())

  ;; void glutSolidDodecahedron(void)
  (define-function void glutSolidDodecahedron ())

  ;; void glutWireTeapot(GLdouble size)
  (define-function void glutWireTeapot (double))

  ;; void glutSolidTeapot(GLdouble size)
  (define-function void glutSolidTeapot (double))

  ;; void glutWireOctahedron(void)
  (define-function void glutWireOctahedron ())

  ;; void glutSolidOctahedron(void)
  (define-function void glutSolidOctahedron ())

  ;; void glutWireTetrahedron(void)
  (define-function void glutWireTetrahedron ())

  ;; void glutSolidTetrahedron(void)
  (define-function void glutSolidTetrahedron ())

  ;; void glutWireIcosahedron(void)
  (define-function void glutWireIcosahedron ())

  ;; void glutSolidIcosahedron(void)
  (define-function void glutSolidIcosahedron ())

  ;; int glutVideoResizeGet(GLenum param)
  (define-function int glutVideoResizeGet ())

  ;; void glutSetupVideoResizing(void)
  (define-function int glutSetupVideoResizing ())

  ;; void glutStopVideoResizing(void)
  (define-function void glutStopVideoResizing ())

  ;; void glutVideoResize(int x, int y, int width, int height)
  (define-function void glutVideoResize (int int int int))

  ;; void glutVideoPan(int x, int y, int width, int height)
  (define-function void glutVideoPan (int int int int))

  ;; void glutReportErrors(void)
  (define-function void glutReportErrors ())

  ;; void glutIgnoreKeyRepeat(int ignore)
  (define-function void glutIgnoreKeyRepeat (int))

  ;; void glutSetKeyRepeat(int repeatMode)
  (define-function void glutSetKeyRepeat (int))

  ;; void glutForceJoystickFunc(void)
  (define-function void glutForceJoystickFunc ())

  ;; void glutGameModeString(const char *string)
  (define-function void glutGameModeString (string))

  ;; int glutEnterGameMode(void)
  (define-function int glutEnterGameMode ())

  ;; void glutLeaveGameMode(void)
  (define-function void glutLeaveGameMode ())

  ;; int glutGameModeGet(GLenum mode)
  (define-function int glutGameModeGet (int))

  )