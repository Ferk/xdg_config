/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]             = "-*-proggytiny-*-*-*-*-*-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#111111";
static const char normbgcolor[]     = "#333333";
static const char normfgcolor[]     = "#aaaaaa";
static const char selbordercolor[]  = "#FF0000";
static const char selbgcolor[]      = "#111111";
static const char selfgcolor[]      = "#22aadd";
static const char* colors[][ColLast] = {
	/* border          foreground   background         use */
	{ normbordercolor, normfgcolor, normbgcolor },  /* normal */
	{ normbordercolor, "#ff0000",   normbgcolor },  /* error */
	{ normbordercolor, "#276CC2",   normbgcolor },  /* delim */

	{ normbordercolor, "#e0b020",   normbgcolor },  /* artist */
	{ normbordercolor, "#e06000",   normbgcolor },  /* title */
	{ normbordercolor, "#b10000",   normbgcolor },  /* hot */
	{ normbordercolor, "#b15c00",   normbgcolor },  /* medium */
	{ normbordercolor, "#6cb100",   normbgcolor },  /* cool */
};
static const unsigned int borderpx   = 1;    /* border pixel of windows */
static const unsigned int snap       = 32;   /* snap pixel */
static const double shade            = 0.9;  /* opacity of unfocussed clients */
static const unsigned int gappx      = 0;    /* gap between clients */
static const Bool showbar            = True; /* False means no bar */
static const Bool topbar             = True; /* False means bottom bar */
static const Bool monobar            = True; /* Draw selected window title not inverse */
static const Bool barline            = False; /* Draw a single line below the statusbar */
static const int nmaster             = 1;    /* default number of clients in the master area */

static const Bool systray_enable     = True; /* Provide a Systray */
static const int systray_spacing     = 1;    /* Pixel between Systray Symbols */

#include "bitmaps.h"

char sstrings[][30] = {
	"^[f276CC2;|^[f;",
	"^[f276CC2;·^[f;",
};


static const Rule rules[] = {
  /* class          instance  title   tags mask  isfloating   monitor  opacity  panel   scratchpad */
  { "Gimp",         NULL,    NULL,     0,        True,        -1,      -1,      False, False },
  
  { "Firefox",      NULL,    NULL,     1<< 1,    False,       -1,      -1,      False, False },
  { "Midori",       NULL,    NULL,     1<< 1,    False,       -1,      -1,      False, False },
  { "Chromium",     NULL,    NULL,     1<< 1,    False,       -1,      -1,      False, False },
  
  { "Pidgin",       NULL,    NULL,     1<< 2,    False,       -1,      -1,      False, False },
  
  { "Transmission", NULL,    NULL,     1<< 7,    False,       -1,      -1,      False, False },
  { "Downloader",   NULL,    NULL,     1<< 7,    False,       -1,      -1,      False, False },

  { NULL,     "xmessage",    NULL,     ~0,       True,        -1,      -1,      False, False },

  // Default rules for each tag
  { "DWM-TAG0",     NULL,    NULL,     1<< 0,    False,       -1,       -1,     False, False },
  { "DWM-TAG1",     NULL,    NULL,     1<< 1,    False,       -1,       -1,     False, False },
  { "DWM-TAG2",     NULL,    NULL,     1<< 2,    False,       -1,       -1,     False, False },
  { "DWM-TAG3",     NULL,    NULL,     1<< 3,    False,       -1,       -1,     False, False },
  { "DWM-TAG4",     NULL,    NULL,     1<< 4,    False,       -1,       -1,     False, False },
  { "DWM-TAG5",     NULL,    NULL,     1<< 5,    False,       -1,       -1,     False, False },
  { "DWM-TAG6",     NULL,    NULL,     1<< 6,    False,       -1,       -1,     False, False },
  { "DWM-TAG7",     NULL,    NULL,     1<< 7,    False,       -1,       -1,     False, False },
  
  { "stalonetray",  NULL,    NULL,     ~0,       True,        -1,      1.6,     True,  False }, /* opacity is static when between 1 and 2 */
  { NULL,           NULL,    "panel",  1<< 7,    True,        -1,      -1,      True,  False },
  { "panel",        NULL,    NULL,     1<< 7,    True,        -1,      -1,      True,  False },
  { NULL,    NULL,  "xfce4-notifyd",      ~0,    True,        -1,      0.7,      True,  False },

  { NULL,   "scratchpad",    NULL,        ~0,    True,        -1,      0.8,     False, True  },
};

/* layout(s) */
static const float mfact             = 0.55;       /* factor of master area size [0.05..0.95] */
static const Bool resizehints        = True;       /* True means respect size hints in tiled resizals */
static const float attachmode        = AttAsFirst; /* Attach Mode */

/* addons: layouts */
#include "layouts/nbstack.c"       /* bottom stack (tiling) */
#include "layouts/bstackhoriz.c"   /* bottom stack (tower like stack)  */
#include "layouts/grid.c"          /* regular grid */
#include "layouts/gaplessgrid.c"   /* best fitting grid */
#include "layouts/fibonacci.c"     /* spiral like arrangement */

static const Layout layouts[] = {
	/* symbol     gap?    arrange */
	{ "[]=",      True,   ntile },       /* Tiled (first entry is default) */
	{ "><>",      False,  NULL },        /* Floating */
	{ "[M]",      False,  monocle },     /* Monocle */
	{ "TTT",      True,   nbstack },     /* Bottom Stack */
	{ "###",      True,   gaplessgrid }, /* Non Regular Grid */
	{ "+++",      True,   grid },        /* Regular Grid */
	{ "===",      True,   bstackhoriz }, /* Bottom Stack with horizontal Stack */
	{ "(@)",      True,   spiral },      /* Spiral (like Tiled, but ordered like in golden ratio */
	{ "[\\]",     True,   dwindle },     /* Dwindle (Like Spiral, but inverted */
};

/* tagging */
static const Tag tags[] = {
	/* name layout         mfact, showbar, topbar, attachmode, nmaster */
	{ "0", &layouts[3],    0.65,  -1,      -1,     -1,         -1 },
	{ "1", &layouts[2],     -1,   -1,      -1,     AttBelow,   -1 },
	{ "2", &layouts[2],     -1,   -1,      -1,     AttAside,   -1 },
	{ "3", &layouts[2],     -1,   -1,      -1,     -1,         -1 },
	{ "4", &layouts[2],     -1,   -1,      -1,     -1,         -1 },
	{ "5", &layouts[2],     -1,   -1,      -1,     -1,         -1 },
	{ "6", &layouts[2],     -1,   -1,      -1,     -1,         -1 },
	{ "7", &layouts[1],     -1,   -1,      -1,     -1,         -1 },
};

/* addons: other */
#include "other/togglemax.c"
#include "other/push.c"
#include "other/shiftview.c"
#include "other/showurgent.c"

/* key definitions */
#define ALTKEY Mod1Mask
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "term", NULL };

static Key keys[] = {
	/* modifier                     key         function        argument */

	/* Used Keys:
	 *       : p b h l j k RET PGUP TAB SPC x , .
	 * SHIFT : RET TAB SPC c t f m b g r h p d h l q z , .
	 * CTRL  : q m 1 a w j k SPC q
	 * ALT   : 
	 */

	/* spawn */
	{ MODKEY,                       XK_p,       spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return,  spawn,          {.v = termcmd } },
	{ ALTKEY,             XK_F2,   spawn,          {.v = dmenucmd } },
	{ ALTKEY,             XK_F1,   spawn,          {.v = termcmd } },
	/* -- p; S-RET */

	/* appereance */
	{ MODKEY|ShiftMask,             XK_b,       togglebar,      {0} },
	{ MODKEY,                       XK_h,       setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,       setmfact,       {.f = +0.05} },
	{ MODKEY|ControlMask,           XK_q,       setattachmode,  {.i = AttAsFirst } },
	{ MODKEY|ControlMask,           XK_m,       setattachmode,  {.i = AttAsLast } },
	{ MODKEY|ControlMask,           XK_1,       setattachmode,  {.i = AttAbove } },
	//{ MODKEY|ControlMask,           XK_a,       setattachmode,  {.i = AttBelow } },
	//{ MODKEY|ControlMask,           XK_w,       setattachmode,  {.i = AttAside } },
	/* -- b,h,l; C-q,m,1,a,w */

	/* stack */
	{ MODKEY,                       XK_j,       focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,       focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_Return,  zoom,           {0} },
	{ MODKEY,                       XK_Page_Up, togglemax,      {0} },
	{ MODKEY|ControlMask,           XK_s,       pushdown,       {0} },
	{ MODKEY|ControlMask,           XK_w,       pushup,         {0} },
	/* -- j,k,RET,PGUP; C-j,k */

	{ MODKEY,			XK_u,	   showurgent,	   {0} },

	/* WASD controls */
	{ MODKEY,                       XK_w,       focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_s,       focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_a,       shiftview,     {.i = -1 } },
	{ MODKEY,                       XK_d,       shiftview,     {.i = +1 } },
	{ MODKEY,                       XK_q,       setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_e,       setmfact,       {.f = +0.05} },

	/* tab */
	{ MODKEY,                       XK_Tab,     view,           {0} },
	{ MODKEY|ShiftMask,             XK_Tab,     focustoggle,    {0} },
	/* -- TAB; S-TAB */

	/* set layout */
	{ MODKEY,                       XK_space,   toggle_scratch,  {.i = 1} }, /* toggles scratch with number i on/off. */
	{ MODKEY|ControlMask,           XK_space,   setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,   togglefloating, {0} },
	{ MODKEY|ShiftMask,             XK_c,       killclient,     {0} },
	{ MODKEY,             XK_t,       setlayout,      {.v = &layouts[0]} }, /* tile */
	{ MODKEY,             XK_f,       setlayout,      {.v = &layouts[1]} }, /* float */
	{ MODKEY,             XK_m,       setlayout,      {.v = &layouts[2]} }, /* monocle */
	{ MODKEY,             XK_b,       setlayout,      {.v = &layouts[3]} }, /* bottomstack */
	{ MODKEY|ShiftMask,             XK_g,       setlayout,      {.v = &layouts[4]} }, /* gaplessgrid */
	{ MODKEY|ShiftMask,             XK_r,       setlayout,      {.v = &layouts[5]} }, /* grid */
	{ MODKEY|ShiftMask,             XK_z,       setlayout,      {.v = &layouts[6]} }, /* bstackhoriz */
	{ MODKEY|ShiftMask,             XK_p,       setlayout,      {.v = &layouts[7]} }, /* spiral */
	{ MODKEY|ShiftMask,             XK_d,       setlayout,      {.v = &layouts[8]} }, /* dwindle */
	/* -- SPC; C-SPC; S-SPC,c,t,f,m,b,g,r,h,p,d */

	/* nmaster */
	{ MODKEY|ShiftMask,             XK_w,      incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_s,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_x,      setnmaster,     {.i = 1 } },
	/* -- x; S-h,l */

	/* tag keys */
	TAGKEYS(                        XK_masculine,              0)
	TAGKEYS(                        XK_1,                      1)
	TAGKEYS(                        XK_2,                      2)
	TAGKEYS(                        XK_3,                      3)
	TAGKEYS(                        XK_4,                      4)
	TAGKEYS(                        XK_5,                      5)
	TAGKEYS(                        XK_6,                      6)
	TAGKEYS(                        XK_7,                      7)
	TAGKEYS(                        XK_8,                      8)
	{ MODKEY,                       XK_9,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	/* -- 0; S-0 */
	/* quit */
	{ MODKEY|ShiftMask,             XK_q,      quit,           {.i = 0} },
	{ MODKEY|ControlMask,           XK_q,      quit,           {.i = 23} },
	/* -- */

	/* monitor */
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	/* -- COM,PER; S-COM,PER*/
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button1,        focusonclick,   {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkWinTitle,          0,              Button4,        focusstack,     {.i = +1} },
	{ ClkWinTitle,          0,              Button5,        focusstack,     {.i = -1} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
