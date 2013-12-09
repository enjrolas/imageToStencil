this sketch takes an image from the sketch's data directory and
converts it into a gerber file for a PCB stencil.  The sketch goes
through the image, and wherever the image is darker than a threshhold
value, it tries to place a hole.  The holes can be randomly sized
circles (the min and max size are set by variables in the sketch), 
or rectangles inscribed inside randomly-sized circles.  The sketch
will only place a hole if it has a minimum distance from any other
hole, which lets the piece to be cut out as a stencil.  The program
continues placing holes until it reaches a preset number of holes。  If
the number of holes is too high, the program may take a very long time
to complete, or it may never finish.  Play with it for your image.
Once all the holes are placed, the program generates a gerber file for
the stencil and saves it in the sketch directory.  It will also save
two images:  one of the holes superimposed on the original image, and
one of the holes without the original image.  Those are just for
reference.

You can check your stencil with any gerber viewing program.  I like
using the online viewer
[gerber-viewer](http://www.gerber-viewer.com/).  If you're happy with
your stencil, send it to a stencil manufacturer and he'll turn it into
gold for you.  STENCIL GOLD!  I'm in China, and I work with
［KingFulll](http://item.taobao.com/item.htm?spm=a1z10.3.w151700727.18.WKry3m&id=7790526606&)
- they're amazing!  100 RMB/stencil, and they deliver in about 8
hours if you're in Shenzhen.  Wherever you are, Gerber files are a
standard, and any manufacturer should be able to take the file.

Happy hacking!
