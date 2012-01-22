
void
showurgent(const Arg *arg) {
	Monitor *m;
	Client *c;
	Arg a;

	for(m = mons; m; m = m->next) {
		for(c = m->clients; c; c = c->next) {
			if(c->isurgent) {
				if(m != selmon) {
					unfocus(selmon->sel, True);
					selmon = c->mon;
					focus(NULL);
				}
				a.ui = c->tags;
				view(&a);
				focus(c);
				arrange(selmon);
				return;
			}
		}
	}
}
