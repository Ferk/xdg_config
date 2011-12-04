void
togglemax(const Arg *arg) {
	Client *c;
	if(!(c = selmon->sel))
		return;
	Monitor *m = c->mon;
        c->isfloating = !c->isfloating || c->isfixed;
        if(c->isfloating)
                resize(c, m->wx, m->wy, m->ww - 2 * c->bw, m->wh - 2 * c->bw, True);
        arrange(selmon);
}
