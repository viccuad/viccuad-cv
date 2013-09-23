viccuad-cv
==========


XeLaTeX CV class with flexible layout. Fork me!

![example_scaled.png](https://github.com/viccuad/viccuad-cv/raw/master/example_scaled.png)

Based on the aesthetics of Adrien Friggeri CV found at
[https://github.com/afriggeri/CV](https://github.com/afriggeri/CV)

Although the aesthetics are quite similar, it is done in a very different way:

 - no usage of TikZ package for placing text. That doesn't allow correct 
serialization of the text.

 - usage of Flowfram package to set the layout of the CV. This allows for having a very flexible layout with multiple frames.

The most relevant changes from his work are:

 - CV now is completely serializable.

 - the text flow follows the given frames, and spans to additional pages if 
necessary. 

 - added automatic \pdfcreationdate population. It works in xelatex 
or pdflatex.
 
## Features
 - Flexible layout.
 - Correct serialization of text, thanks to Flowfram.
 - Automatic flow of text, thanks to Flowfram. Text flow follows the given frames, and spans to additional pages if neccesary.
 - XeLaTeX usage.
 - Automatic \pdfcreationdate population in XeLaTeX (there is no way to get current modification date inside XeLaTeX, this fixes it).
 - Correct A4paper layout.
 - Custom \section and \subsection. new \entrylistdated and \entrylist environments.

## Flow
The text flow inside of the CV can be seen in flow.png.

## Examples 
 * Of an empty draft: example-drafton.tex & example-drafton.pdf
 * Of a complete CV: example.tex & example.pdf


## Revisions
Version 1.0

 * Initial version

Version 1.1

 * Code cleanup


## License

Copyright(C) 2013  Víctor Cuadrado Juan 

In addition of the LaTeX Project Public License, this work CANNOT be used for a commercial use. 

This work may be distributed and/or modified under the
conditions of the LaTeX Project Public License, either version 1.3
of this license or (at your option) any later version.
The latest version of this license is in
http://www.latex-project.org/lppl.txt
and version 1.3 or later is part of all distributions of LaTeX
version 2005/12/01 or later.

This work consists of the files viccuad-cv.cls and creationdate.lua 

