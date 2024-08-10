DONE BELOW AS OF 5/18/24

fix multi-window validation wrt --npm session-name inference

eg. these cases don't currently work as expected:

loading -n -w- 123 -w- 44
loading --npm -w- 123 -w- 44
loading -w- -n 123 -w- 44
loading -w- --npm 123 -w- 44
loading -nw- 123 -w- 44

These should be similar to

loading -n 123

which creates a 123-layout pane with session name set to current npm project dir name
The commands above create an additional 44-layout window.

Add additional features:
Active window selection: allow passing --window-active OR -W to start with specific
window in focus.

[DELAY till June 15] Add --command arg per https://github.com/evnp/loading/issues/9#issuecomment-2107600548
