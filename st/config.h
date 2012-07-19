#define TAB 4
//#define TNAME "st-256color"
#define TNAME "xterm-256color"
//#define FONT "-*-*-medium-r-*-*-*-120-75-75-*-60-*-*"
#define BOLDFONT "-*-*-bold-r-*-*-*-120-75-75-*-60-*-*"
#define FONT "-*-proggycleanszbp-*-*-*-*-*-*-*-*-*-*-*-*"
#define BORDER 2
#define SHELL "/bin/bash"

/* Terminal colors */
static const char *colorname[] = {
	"#050505",    /* 0 */
	"red3",
	"green3",
	"#ffaf00",
	"blue2",
	"magenta3", /* 5 */
	"cyan3",
	"gray90",
	
	"gray50",
	"red",
	"green",    /* 10 */
	"yellow",
	"#5c5cff",
	"magenta",
	"cyan",
	"white"     /* 15 */
};

/* Default colors (colorname index) */
/* foreground, background, cursor, unfocused cursor   */
#define DefaultFG 7
#define DefaultBG 0
#define DefaultCS 11
#define DefaultUCS 3

/* Special keys (change & recompile st.info accordingly) */
/*    key,        mask,  output */
static Key key[] = {
	{ XK_BackSpace, 0, "\177" },
	{ XK_Insert,    0, "\033[2~" },
	{ XK_Delete,    0, "\033[3~" },
	{ XK_Home,      0, "\033[1~" },
	{ XK_End,       0, "\033[4~" },
	{ XK_Prior,     0, "\033[5~" },
	{ XK_Next,      0, "\033[6~" },
	{ XK_F1,        0, "\033OP"   },
	{ XK_F2,        0, "\033OQ"   },
	{ XK_F3,        0, "\033OR"   },
	{ XK_F4,        0, "\033OS"   },
	{ XK_F5,        0, "\033[15~" },
	{ XK_F6,        0, "\033[17~" },
	{ XK_F7,        0, "\033[18~" },
	{ XK_F8,        0, "\033[19~" },
	{ XK_F9,        0, "\033[20~" },
	{ XK_F10,       0, "\033[21~" },
	{ XK_F11,       0, "\033[23~" },
	{ XK_F12,       0, "\033[24~" },
};

/* Line drawing characters (sometime specific to each font...) */
static char gfx[] = {
	['f'] = 'o',
	['g'] = '+',
	['i'] = '#',
	[255] = 0,
};

/* double-click timeout (in milliseconds) between clicks for selection */
#define DOUBLECLICK_TIMEOUT 300
#define TRIPLECLICK_TIMEOUT (2*DOUBLECLICK_TIMEOUT)
