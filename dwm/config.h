/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]             = "-*-proggytiny-*-*-*-*-*-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#111111";
static const char normbgcolor[]     = "#333333";
static const char normfgcolor[]     = "#aaaaaa";
static const char selbordercolor[]  = "#FF0000";
static const char selbgcolor[]      = "#111111";
static const char selfgcolor[]      = "#22aadd";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "0", "1", "2", "3", "4", "5", "6", "7", "8" };

static const Rule rules[] = {
  /* class          instance  title   tags mask  isfloating   monitor */
  { "Gimp",         NULL,    NULL,     0,        True,        -1,},
  
  { "Firefox",      NULL,    NULL,     1<< 1,    True,        -1,},
  { "Midori",       NULL,    NULL,     1<< 1,    True,       -1,},
  { "Chromium",     NULL,    NULL,     1<< 1,    True,       -1,},
  { "Google Chrome",NULL,    NULL,     1<< 1,    True,       -1,},
  
  { "Pidgin",       NULL,    NULL,     1<< 2,    False,       -1,},
 
  { "Steam",       NULL,    NULL,      1<< 2,    True,       -1,},

  { NULL,           NULL,    "cmus",   1<< 6,    False,       -1,},
  { "Transmission", NULL,    NULL,     1<< 7,    False,       -1,},
  { "Downloader",   NULL,    NULL,     1<< 7,    False,       -1,},

  { NULL,     "xmessage",    NULL,     ~0,       True,        -1,},
};

/* include files */
#include "other/shiftview.c"
#include "other/fibonacci.c"
#include "other/gaplessgrid.c"
#include "other/deck.c"

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "###",      gaplessgrid },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "[]]",      deck },
};

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
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "t", NULL };

static Key keys[] = { /* mod, keysym, func(Arg*), arg */
	
	/* WASD controls */
	{ MODKEY,                       XK_w,       focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_s,       focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_a,       shiftview,     {.i = -1 } },
	{ MODKEY,                       XK_d,       shiftview,     {.i = +1 } },
	{ MODKEY,                       XK_q,       setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_e,       setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_q,       incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_e,       incnmaster,     {.i = -1 } },
	/* custom dmenu_run key */
	{ MODKEY,                       XK_r,      spawn,          {.v = dmenucmd } },

	/********/
	/* Leaving default keybindings here, it's always nice to try to remain somewhat standard */

	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	//{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	//{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_g,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

	TAGKEYS(                        XK_grave,                  0)
	TAGKEYS(                        XK_masculine,              0)
	TAGKEYS(                        XK_dead_circumflex,        0)
	TAGKEYS(                        XK_1,                      1)
	TAGKEYS(                        XK_2,                      2)
	TAGKEYS(                        XK_3,                      3)
	TAGKEYS(                        XK_4,                      4)
	TAGKEYS(                        XK_5,                      5)
	TAGKEYS(                        XK_6,                      6)
	TAGKEYS(                        XK_7,                      7)
	TAGKEYS(                        XK_8,                      8)
	{ MODKEY|ControlMask|ShiftMask, XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
