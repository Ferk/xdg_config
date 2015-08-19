
This is actually my [$XDG_CONFIG_HOME](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html#basics) folder (well, the bits I'm willing to share at least).

There are also a few special folders..

+ HOME/
+ DATA/
These are files and directories from my $HOME and $XDG_DATA_HOME (in the HOME/ and DATA/ directory respectively), they are symlinked to their right location by executing the "symlink.sh" script. The purpose of this is to have all my configs under the same directory tree so I can backup and version them easy and safely).

+ ROOT/
These are files intended to be copied to the root of my system, for places where I'm the admin and are willing to share some settings. The "rootsync.sh" script syncs changes back and forth (using the modification dates) and asks confirmation, showing also the diffs, so it's done in a safer way.

--
Fernando Carmona Varo
