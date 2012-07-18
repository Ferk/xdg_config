
void
switchmon(const Arg *arg) {
       Client *current, *next;
       unsigned int tag;

       if(!selmon->sel || !mons->next)
               return;

       /* Sending each clients to the arg->i monitor */
       next = selmon->clients;
       while(next) {
               current = next;
               tag = current->tags;

               next = next->next;

               sendmon(current, dirtomon(arg->i));

               /* Sending to the same tag */
               current->tags = tag;
       }
}

