;;;; glu.scm

(use easyffi)

(cond-expand
 (msvc
  #>
  #define WIN32_LEAN_AND_MEAN 1
  #include <windows.h>
  #include <GL/glu.h>
  <#)
 (else
  #>
  #ifdef C_MACOSX
  #include <OpenGL/glu.h>
  #else
  #include <GL/glu.h>
  #endif
  <#))

(foreign-parse #<<EOF

___declare(export_constants, yes)

/* ___declare(substitute, "^(GLU_|glu);glu:") */

typedef unsigned int	GLenum;
typedef unsigned char	GLboolean;
typedef unsigned int	GLbitfield;
typedef void		GLvoid;
typedef ___byte	GLbyte;		/* 1-byte signed */
typedef short		GLshort;	/* 2-byte signed */
typedef int		GLint;		/* 4-byte signed */
typedef unsigned ___byte	GLubyte;	/* 1-byte unsigned */
typedef unsigned short	GLushort;	/* 2-byte unsigned */
typedef unsigned int	GLuint;		/* 4-byte unsigned */
typedef int		GLsizei;	/* 4-byte signed */
typedef float		GLfloat;	/* single precision float */
typedef float		GLclampf;	/* single precision float in [0,1] */
typedef double		GLdouble;	/* double precision float */
typedef double		GLclampd;	/* double precision float in [0,1] */

/* Boolean */
#define GLU_FALSE                          0
#define GLU_TRUE                           1

/* StringName */
#define GLU_VERSION                        100800
#define GLU_EXTENSIONS                     100801

/* ErrorCode */
#define GLU_INVALID_ENUM                   100900
#define GLU_INVALID_VALUE                  100901
#define GLU_OUT_OF_MEMORY                  100902
#define GLU_INVALID_OPERATION              100904

/* NurbsDisplay */
/*      GLU_FILL */
#define GLU_OUTLINE_POLYGON                100240
#define GLU_OUTLINE_PATCH                  100241

/* NurbsCallback */
#define GLU_NURBS_ERROR                    100103
#define GLU_ERROR                          100103
#define GLU_NURBS_BEGIN                    100164
#define GLU_NURBS_BEGIN_EXT                100164
#define GLU_NURBS_VERTEX                   100165
#define GLU_NURBS_VERTEX_EXT               100165
#define GLU_NURBS_NORMAL                   100166
#define GLU_NURBS_NORMAL_EXT               100166
#define GLU_NURBS_COLOR                    100167
#define GLU_NURBS_COLOR_EXT                100167
#define GLU_NURBS_TEXTURE_COORD            100168
#define GLU_NURBS_TEX_COORD_EXT            100168
#define GLU_NURBS_END                      100169
#define GLU_NURBS_END_EXT                  100169
#define GLU_NURBS_BEGIN_DATA               100170
#define GLU_NURBS_BEGIN_DATA_EXT           100170
#define GLU_NURBS_VERTEX_DATA              100171
#define GLU_NURBS_VERTEX_DATA_EXT          100171
#define GLU_NURBS_NORMAL_DATA              100172
#define GLU_NURBS_NORMAL_DATA_EXT          100172
#define GLU_NURBS_COLOR_DATA               100173
#define GLU_NURBS_COLOR_DATA_EXT           100173
#define GLU_NURBS_TEXTURE_COORD_DATA       100174
#define GLU_NURBS_TEX_COORD_DATA_EXT       100174
#define GLU_NURBS_END_DATA                 100175
#define GLU_NURBS_END_DATA_EXT             100175

/* NurbsError */
#define GLU_NURBS_ERROR1                   100251
#define GLU_NURBS_ERROR2                   100252
#define GLU_NURBS_ERROR3                   100253
#define GLU_NURBS_ERROR4                   100254
#define GLU_NURBS_ERROR5                   100255
#define GLU_NURBS_ERROR6                   100256
#define GLU_NURBS_ERROR7                   100257
#define GLU_NURBS_ERROR8                   100258
#define GLU_NURBS_ERROR9                   100259
#define GLU_NURBS_ERROR10                  100260
#define GLU_NURBS_ERROR11                  100261
#define GLU_NURBS_ERROR12                  100262
#define GLU_NURBS_ERROR13                  100263
#define GLU_NURBS_ERROR14                  100264
#define GLU_NURBS_ERROR15                  100265
#define GLU_NURBS_ERROR16                  100266
#define GLU_NURBS_ERROR17                  100267
#define GLU_NURBS_ERROR18                  100268
#define GLU_NURBS_ERROR19                  100269
#define GLU_NURBS_ERROR20                  100270
#define GLU_NURBS_ERROR21                  100271
#define GLU_NURBS_ERROR22                  100272
#define GLU_NURBS_ERROR23                  100273
#define GLU_NURBS_ERROR24                  100274
#define GLU_NURBS_ERROR25                  100275
#define GLU_NURBS_ERROR26                  100276
#define GLU_NURBS_ERROR27                  100277
#define GLU_NURBS_ERROR28                  100278
#define GLU_NURBS_ERROR29                  100279
#define GLU_NURBS_ERROR30                  100280
#define GLU_NURBS_ERROR31                  100281
#define GLU_NURBS_ERROR32                  100282
#define GLU_NURBS_ERROR33                  100283
#define GLU_NURBS_ERROR34                  100284
#define GLU_NURBS_ERROR35                  100285
#define GLU_NURBS_ERROR36                  100286
#define GLU_NURBS_ERROR37                  100287

/* NurbsProperty */
#define GLU_AUTO_LOAD_MATRIX               100200
#define GLU_CULLING                        100201
#define GLU_SAMPLING_TOLERANCE             100203
#define GLU_DISPLAY_MODE                   100204
#define GLU_PARAMETRIC_TOLERANCE           100202
#define GLU_SAMPLING_METHOD                100205
#define GLU_U_STEP                         100206
#define GLU_V_STEP                         100207
#define GLU_NURBS_MODE                     100160
#define GLU_NURBS_MODE_EXT                 100160
#define GLU_NURBS_TESSELLATOR              100161
#define GLU_NURBS_TESSELLATOR_EXT          100161
#define GLU_NURBS_RENDERER                 100162
#define GLU_NURBS_RENDERER_EXT             100162

/* NurbsSampling */
#define GLU_OBJECT_PARAMETRIC_ERROR        100208
#define GLU_OBJECT_PARAMETRIC_ERROR_EXT    100208
#define GLU_OBJECT_PATH_LENGTH             100209
#define GLU_OBJECT_PATH_LENGTH_EXT         100209
#define GLU_PATH_LENGTH                    100215
#define GLU_PARAMETRIC_ERROR               100216
#define GLU_DOMAIN_DISTANCE                100217

/* NurbsTrim */
#define GLU_MAP1_TRIM_2                    100210
#define GLU_MAP1_TRIM_3                    100211

/* QuadricDrawStyle */
#define GLU_POINT                          100010
#define GLU_LINE                           100011
#define GLU_FILL                           100012
#define GLU_SILHOUETTE                     100013

/* QuadricCallback */
/*      GLU_ERROR */

/* QuadricNormal */
#define GLU_SMOOTH                         100000
#define GLU_FLAT                           100001
#define GLU_NONE                           100002

/* QuadricOrientation */
#define GLU_OUTSIDE                        100020
#define GLU_INSIDE                         100021

/* TessCallback */
#define GLU_TESS_BEGIN                     100100
#define GLU_BEGIN                          100100
#define GLU_TESS_VERTEX                    100101
#define GLU_VERTEX                         100101
#define GLU_TESS_END                       100102
#define GLU_END                            100102
#define GLU_TESS_ERROR                     100103
#define GLU_TESS_EDGE_FLAG                 100104
#define GLU_EDGE_FLAG                      100104
#define GLU_TESS_COMBINE                   100105
#define GLU_TESS_BEGIN_DATA                100106
#define GLU_TESS_VERTEX_DATA               100107
#define GLU_TESS_END_DATA                  100108
#define GLU_TESS_ERROR_DATA                100109
#define GLU_TESS_EDGE_FLAG_DATA            100110
#define GLU_TESS_COMBINE_DATA              100111

/* TessContour */
#define GLU_CW                             100120
#define GLU_CCW                            100121
#define GLU_INTERIOR                       100122
#define GLU_EXTERIOR                       100123
#define GLU_UNKNOWN                        100124

/* TessProperty */
#define GLU_TESS_WINDING_RULE              100140
#define GLU_TESS_BOUNDARY_ONLY             100141
#define GLU_TESS_TOLERANCE                 100142

/* TessError */
#define GLU_TESS_ERROR1                    100151
#define GLU_TESS_ERROR2                    100152
#define GLU_TESS_ERROR3                    100153
#define GLU_TESS_ERROR4                    100154
#define GLU_TESS_ERROR5                    100155
#define GLU_TESS_ERROR6                    100156
#define GLU_TESS_ERROR7                    100157
#define GLU_TESS_ERROR8                    100158
#define GLU_TESS_MISSING_BEGIN_POLYGON     100151
#define GLU_TESS_MISSING_BEGIN_CONTOUR     100152
#define GLU_TESS_MISSING_END_POLYGON       100153
#define GLU_TESS_MISSING_END_CONTOUR       100154
#define GLU_TESS_COORD_TOO_LARGE           100155
#define GLU_TESS_NEED_COMBINE_CALLBACK     100156

/* TessWinding */
#define GLU_TESS_WINDING_ODD               100130
#define GLU_TESS_WINDING_NONZERO           100131
#define GLU_TESS_WINDING_POSITIVE          100132
#define GLU_TESS_WINDING_NEGATIVE          100133
#define GLU_TESS_WINDING_ABS_GEQ_TWO       100134

/*************************************************************/


typedef struct GLUnurbs GLUnurbs;
typedef struct GLUquadric GLUquadric;
typedef struct GLUtesselator GLUtesselator;

#define GLU_TESS_MAX_COORD 1.0e+150

/* Internal convenience typedefs */

 void  gluBeginCurve (GLUnurbs* nurb);
 void  gluBeginPolygon (GLUtesselator* tess);
 void  gluBeginSurface (GLUnurbs* nurb);
 void  gluBeginTrim (GLUnurbs* nurb);
 
 GLint  gluBuild1DMipmaps (GLenum target, GLint internalFormat, GLsizei width, GLenum format, GLenum type, const void *data);
 GLint  gluBuild2DMipmaps (GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLenum format, GLenum type, const void *data);

 void  gluCylinder (GLUquadric* quad, GLdouble base, GLdouble top, GLdouble height, GLint slices, GLint stacks);
 void  gluDeleteNurbsRenderer (GLUnurbs* nurb);
 void  gluDeleteQuadric (GLUquadric* quad);
 void  gluDeleteTess (GLUtesselator* tess);
 void  gluDisk (GLUquadric* quad, GLdouble inner, GLdouble outer, GLint slices, GLint loops);
 void  gluEndCurve (GLUnurbs* nurb);
 void  gluEndPolygon (GLUtesselator* tess);
 void  gluEndSurface (GLUnurbs* nurb);
 void  gluEndTrim (GLUnurbs* nurb);
 char *  gluErrorString (GLenum err);
 void  gluGetNurbsProperty (GLUnurbs* nurb, GLenum property, GLfloat* data);
 char *  gluGetString (GLenum name);
 void  gluGetTessProperty (GLUtesselator* tess, GLenum which, GLdouble* data);
 void  gluLoadSamplingMatrices (GLUnurbs* nurb, const GLfloat *model, const GLfloat *perspective, const GLint *view);
 void  gluLookAt (GLdouble eyeX, GLdouble eyeY, GLdouble eyeZ, GLdouble centerX, GLdouble centerY, GLdouble centerZ, GLdouble upX, GLdouble upY, GLdouble upZ);
 GLUnurbs*  gluNewNurbsRenderer (void);
 GLUquadric*  gluNewQuadric (void);
 GLUtesselator*  gluNewTess (void);
 void  gluNextContour (GLUtesselator* tess, GLenum type);

 void  gluNurbsCurve (GLUnurbs* nurb, GLint knotCount, GLfloat *knots, GLint stride, GLfloat *control, GLint order, GLenum type);
 void  gluNurbsProperty (GLUnurbs* nurb, GLenum property, GLfloat value);
 void  gluNurbsSurface (GLUnurbs* nurb, GLint sKnotCount, GLfloat* sKnots, GLint tKnotCount, GLfloat* tKnots, GLint sStride, GLint tStride, GLfloat* control, GLint sOrder, GLint tOrder, GLenum type);
 void  gluOrtho2D (GLdouble left, GLdouble right, GLdouble bottom, GLdouble top);
 void  gluPartialDisk (GLUquadric* quad, GLdouble inner, GLdouble outer, GLint slices, GLint loops, GLdouble start, GLdouble sweep);
 void  gluPerspective (GLdouble fovy, GLdouble aspect, GLdouble zNear, GLdouble zFar);
 void  gluPickMatrix (GLdouble x, GLdouble y, GLdouble delX, GLdouble delY, GLint *viewport);
 GLint  gluProject (GLdouble objX, GLdouble objY, GLdouble objZ, const GLdouble *model, const GLdouble *proj, const GLint *view, GLdouble* winX, GLdouble* winY, GLdouble* winZ);
 void  gluPwlCurve (GLUnurbs* nurb, GLint count, GLfloat* data, GLint stride, GLenum type);
 void  gluQuadricDrawStyle (GLUquadric* quad, GLenum draw);
 void  gluQuadricNormals (GLUquadric* quad, GLenum normal);
 void  gluQuadricOrientation (GLUquadric* quad, GLenum orientation);
 void  gluQuadricTexture (GLUquadric* quad, GLboolean texture);
 GLint  gluScaleImage (GLenum format, GLsizei wIn, GLsizei hIn, GLenum typeIn, const void *dataIn, GLsizei wOut, GLsizei hOut, GLenum typeOut, GLvoid* dataOut);
 void  gluSphere (GLUquadric* quad, GLdouble radius, GLint slices, GLint stacks);
 void  gluTessBeginContour (GLUtesselator* tess);
 void  gluTessBeginPolygon (GLUtesselator* tess, GLvoid* data);
 void  gluTessEndContour (GLUtesselator* tess);
___safe void  gluTessEndPolygon (GLUtesselator* tess);
 void  gluTessNormal (GLUtesselator* tess, GLdouble valueX, GLdouble valueY, GLdouble valueZ);
 void  gluTessProperty (GLUtesselator* tess, GLenum which, GLdouble data);
 void  gluTessVertex (GLUtesselator* tess, GLdouble *location, GLvoid* data);
 GLint  gluUnProject (GLdouble winX, GLdouble winY, GLdouble winZ, const GLdouble *model, const GLdouble *proj, const GLint *view, GLdouble* objX, GLdouble* objY, GLdouble* objZ);

EOF
)

; The GLU that ships with windows is still version 1.2, so I moved all GLU 1.3 functions here.
(cond-expand
 (msvc)
 (cygwin)
 (else
  (foreign-parse #<<EOF
  GLint  gluBuild1DMipmapLevels (GLenum target, GLint internalFormat, GLsizei width, GLenum format, GLenum type, GLint level, GLint base, GLint max, const void *data);
   GLint  gluBuild2DMipmapLevels (GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLint level, GLint base, GLint max, const void *data);
    GLint  gluBuild3DMipmapLevels (GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLint level, GLint base, GLint max, const void *data);
     GLint  gluBuild3DMipmaps (GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const void *data);
 GLboolean  gluCheckExtension (const char *extName, const char *extString);
 void  gluNurbsCallbackData (GLUnurbs* nurb, GLvoid* userData);
 void  gluNurbsCallbackDataEXT (GLUnurbs* nurb, GLvoid* userData);
 GLint  gluUnProject4 (GLdouble winX, GLdouble winY, GLdouble winZ, GLdouble clipW, const GLdouble *model, const GLdouble *proj, const GLint *view, GLdouble nearVal, GLdouble farVal, GLdouble* objX, GLdouble* objY, GLdouble* objZ, GLdouble* objW);
EOF
)))

(declare (hide nurbs-func nurbs_cb quadric-func quadric_cb tess-func tess_cb))

(define nurbs-func #f)
(define quadric-func #f)
(define tess-func #f)

; The callback passed to gluTess/gluQuadric/gluNurbsCallback must be __stdcall in windows.  Defining the
; external functions (nurbs_cb, quadric_cb, tess_cb) as __stdcall is done below; however, I couldn't figure
; out how to get the Easy FFI parser to handle a __stdcall function pointer.  With foreign-safe-lambda,
; I can specify a calling convention with the function type, but the MSVC compiler doesn't like where
; chicken puts the __stdcall in the function pointer casts.  To get around this, I created the wrapper
; functions used below.
(cond-expand
 (msvc
  #>
  void chicken_wrap_gluTessCallback(GLUtesselator* tess, GLenum which) { gluTessCallback(tess, which, tess_cb); }
  void chicken_wrap_gluQuadricCallback(GLUquadric* quad, GLenum which) { gluQuadricCallback(quad, which, quadric_cb); }
  void chicken_wrap_gluNurbsCallback(GLUnurbs* nurb, GLenum which) { gluNurbsCallback(nurb, which, nurbs_cb); }
  <#
  (foreign-parse #<<EOF
  void chicken_wrap_gluNurbsCallback(GLUnurbs* nurb, GLenum which);
  void chicken_wrap_gluQuadricCallback(GLUquadric* quad, GLenum which);
  void chicken_wrap_gluNurbsCallback(GLUnurbs* nurb, GLenum which);
EOF
)
  (define-external "__stdcall" (nurbs_cb) void (nurbs-func))
  (define-external "__stdcall" (quadric_cb) void (quadric-func))
  (define-external "__stdcall" (tess_cb) void (tess-func))
  (define (gluNurbsCallback p i proc) (chicken_wrap_gluNurbsCallback p i) (set! nurbs-func proc))
  (define (gluQuadricCallback p i proc) (chicken_wrap_gluQuadricCallback p i) (set! quadric-func proc))
  (define (gluTessCallback p i proc) (chicken_wrap_gluTessCallback p i) (set! tess-func proc)))
 (else
  (foreign-parse #<<EOF
  void  gluTessCallback (GLUtesselator* tess, GLenum which, void (*CallBackFunc)());
  void  gluQuadricCallback (GLUquadric* quad, GLenum which, void (*CallBackFunc)());
  void  gluNurbsCallback (GLUnurbs* nurb, GLenum which, void (*CallBackFunc)());
EOF
)
  (define-external (nurbs_cb) void (nurbs-func))
  (define-external (quadric_cb) void (quadric-func))
  (define-external (tess_cb) void (tess-func))
  (define gluNurbsCallback (let ([old gluNurbsCallback]) (lambda (p i proc) (old p i (location nurbs_cb)) (set! nurbs-func proc))))
  (define gluQuadricCallback (let ([old gluQuadricCallback]) (lambda (p i proc) (old p i (location quadric_cb)) (set! quadric-func proc))))
  (define gluTessCallback (let ([old gluTessCallback]) (lambda (p i proc) (old p i (location tess_cb)) (set! tess-func proc))))))
