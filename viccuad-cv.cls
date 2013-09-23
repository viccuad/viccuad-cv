% viccuad-cv.cls 
%
% Copyright (C) 2013  Víctor Cuadrado Juan 
%
% In addition of the LaTeX Project Public License, this work CANNOT be used for a commercial use. 
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work consists of the files viccuad-cv.cls and creationdate.lua 
%
%
% Features: 
% - Flexible layout, thanks to Flowfram.
% - Correct serialization of text, thanks to Flowfram.
% - Automatic flow of text, thanks to Flowfram. Text flow follows the given frames,
%   and spans to additional pages if neccesary.
% - XeLaTeX usage.
% - Automatic \pdfcreationdate population in XeLaTeX (there is no way to get 
%   current modification date inside XeLaTeX, this fixes it).
% - Correct A4paper layout.
% - Custom \section and \subsection. new \entrylistdated and \entrylist environments.

 

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{viccuad-cv}[2013/09/20 Multiple frames CV class]
%begin body

\LoadClass{article}
\RequirePackage[a4paper,left=1.5cm,top=2cm,right=1.5cm,bottom=1.5cm,nohead,nofoot]{geometry}
\RequirePackage{graphicx}
\RequirePackage{lipsum}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COLORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{xcolor}
\definecolor{lightgray}{HTML}{000000}
\colorlet{headertext}{black}
\colorlet{sectioncolor}{black}
\colorlet{textcolor}{black}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FONTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% access fonts by file name in case they aren't installed system-wide
% warning: load before flowfram!

\RequirePackage{fontspec}
\RequirePackage[math-style=TeX,vargreek-shape=unicode]{unicode-math}
\setmathfont{xits-math.otf}

\newfontfamily\surnamefont[]{HelveticaNeue}
\newfontfamily\namefont[]{HelveticaNeue-UltraLight}  
\newfontfamily\sectionfont[]{HelveticaNeue-CondensedBold} 

\defaultfontfeatures{Mapping=tex-text} % To support LaTeX quoting 
\setmainfont[Mapping=tex-text, Color=textcolor]{HelveticaNeue-Light}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MISCELANEA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[bookmarks,hidelinks,colorlinks=false, unicode, pdfencoding=auto,
]{hyperref}
\RequirePackage{tabularx}               % sets the width of the table correctly
\RequirePackage{graphicx}               % for importing photos
\RequirePackage{dtklogos}               % for \XeTeX logo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EMULATE PDFCREATIONDATE IN XETEX %%%%%%%%%%%%%
%http://tex.stackexchange.com/questions/41889/what-is-the-xetex-equivalent-of-pdfcreationdate
%
% if using xetex, there is no \pdfcreationdate. This creates a lua script to 
% fill \pdfcreationdate
%                                                                         !!!
%                 NEEDS TO BE COMPILED WITH --shell-escape               !!!!!
%                 NEEDS creationdate.lua with execution permissions      !!!!!
%                                                                        !!!!
%                                                                        !!  
%                                                                        ! 
%

% Silence silly warning of creationdate.lua present, if not first time compiling
\RequirePackage{silence}    
\WarningFilter{latex}{File `creationdate.lua' already exists on the system}

\begin{filecontents*}{creationdate.lua}
os.remove("creationdate.timestamp")
io.output("creationdate.timestamp"):write(os.date("\\edef\\tempa\{\\string D:%Y%m%d%H%M%S\}\n\\def\\tempb\{%z\}"))
\end{filecontents*}

\RequirePackage{datetime}
\newdateformat{mydate}{\monthname[\THEMONTH] \THEYEAR}

\ifdefined\pdfcreationdate\else
\begingroup
  \ifnum\shellescape=1
    \immediate\write18{texlua creationdate.lua}
    \input{creationdate.timestamp}
    \def\tempc#1#2#3#4#5{#1#2#3'#4#5'}
    \edef\tempb{\expandafter\tempc\tempb}
    \edef\x{\endgroup\def\noexpand\pdfcreationdate{\tempa\tempb}}\x
  \fi
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FLOWFRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This class uses Flowfram: by the use of frames, you can create a layout
% that does not conform to the standard, and also has the contents of the 
% document flowing correctly on it. A little extract from flowfram docs:
% 
% TYPES OF FRAMES 
% - Flow frames: the content will flow from one frame to other. -
% Static frames: context neither flows into nor outo of. The contents will 
% remain the same on each page until explicitly changed. 
% - Dynamic frames: similar to
% static frames, but content is re-typeset on each page.
% 
% FRAME ATTRIBUTES 
% x-coordinate, y-coordinate, width, height, border, offset, bordercolor, 
% textcolor, pages, margin, clear, style.
% 
%       ___width___             y
%  	   [           ]            ^
%      [   FRAME   ] height     |
%      [___________]            .---> x	
%
%
% FRAME STACKING ORDER
% 1º static frames, 2º flow frames, 3º dynamic frames.4º boxes if in draft mode.
% 
% PREMATURELY ENDING A FLOW FRAME
% - using standard latex page breaking commands
% - \framebreak: resets \hsize if paragraph spans 2 flow frames of diff widths.
% - \finishthispage to start a new page instead of going to next frame.
% 
% FLOATS (figures & tables) 
% Can only go in flow frames. Flowfram provides
% staticfigure and statictable environments that can be used in static and
%  dynamic frames. They are fixed in place, so they don't take an optional 
% placement specifier.
%
% DEFINING FRAMES
%     \newflowframe[ page list ]{ width }{ height }{ x }{ y }[ label ]
%
% PREMATURELY ENDING A FLOWFRAME
% You can force text to move immediately to the next deﬁned ﬂow frame using one 
% of the commands: \newpage, \pagebreak or \framebreak
% \framebreak is required when a paragraph spans two ﬂow frames of different 
% widths (a latex warning is issued in that case). If you want to start a new 
% page, rather than simply move to the next frame, use the command \clearpage.

\RequirePackage{flowfram}           % no draft option
%\RequirePackage[draft]{flowfram}   % draft option
\showmarginsfalse                   % don't display margin bounding boxes in draft


\newlength\rightX                   % right frame coord
\newlength\rightW                   % right frame width
\setlength{\columnsep}{\leftmargin} % columnsep
 
% header
\newstaticframe[1]{\textwidth}{0.07\textheight}{0pt}{0.95\textheight}[header]

% aside
\newflowframe[1]{0.2\textwidth}{0.72\textheight}{0pt}{0.18\textheight}[aside]

% main1 frame
\setlength{\rightW}{0.8\textwidth}
\addtolength{\rightW}{-\columnsep}  % rightW = main1 width - columnsep
\setlength{\rightX}{0.2\textwidth}
\addtolength{\rightX}{\columnsep}   % rightX = aside width + columnsep
\newflowframe[1]{\rightW}{0.74\textheight}{\rightX}{0.18\textheight}[main1]

% main2 frame
\newflowframe[1]{\textwidth}{0.18\textheight}{0pt}{0pt}[main2]

% footer frame
\newstaticframe[>0]{\textwidth}{0.05\textheight}{0pt}{-0.05\textheight}[footer]

% rest of the text 
\onecolumn[>1]                      % for any text that falls off the last page
\setcounter{secnumdepth}{0}         % the sections get numbered as chapters
\pagestyle{empty}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SECTION/SUBSECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{parskip} % dependency

% section
\renewcommand{\section}[1]{
  \par\vspace{\parskip}
  {%
    \LARGE\sectionfont\color{sectioncolor}%
    \@sectioncolor #1%
  }
  \par\vspace{\parskip}
}

% subsection
\renewcommand{\subsection}[1]{
    \par\vspace{2\parskip}
    {%
        \large\sectionfont\color{sectioncolor}%
        \@sectioncolor #1\\%
    }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FILLER COMMANDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{parskip} % dependency

% header
\newcommand{\header}[3]{%
    \begin{staticcontents*}{header}
        \begin{center}   
            \fontsize{40pt}{72pt}\color{headertext}
            \namefont#1\surnamefont#2
            \fontsize{16pt}{18pt}\color{headertext}%
            \\* %newline
            \namefont#3%
        \end{center}
    \end{staticcontents*}
}

% footer
\newcommand{\footer}[1]{%
    \begin{staticcontents*}{footer}
        \begin{flushright}
            \tiny{#1}
        \end{flushright}
    \end{staticcontents*}
}

% aside 
\newcommand{\aside}[1]{%
\begin{flushright}
    #1
\end{flushright}
\framebreak
}


% entrylistdated
\setlength{\tabcolsep}{0pt}
\newenvironment{entrylistdated}{%
  \begin{tabular*}{\linewidth}{@{\extracolsep{\fill}}ll}
}{%
  \end{tabular*}
}
\renewcommand{\bfseries}{\sectionfont\color{sectioncolor}}
\newcommand{\entrydated}[4]{%
  #1&\parbox[t]{0.85\linewidth}{%
    \textbf{#2}%
    \hfill%
    {\footnotesize\addfontfeature{Color=lightgray} #3}\\%
    #4\vspace{\parsep}%
  }\\}


% entrylist
\setlength{\tabcolsep}{0pt}
\newenvironment{entrylist}{%
  \begin{tabular*}{\linewidth}{@{\extracolsep{\fill}}ll}
}{%
  \end{tabular*}
}
\renewcommand{\bfseries}{\sectionfont\color{sectioncolor}}
\newcommand{\entry}[3]{%
  \parbox[t]{\linewidth}{%
    \textbf{#1}%
    \hfill%
    {\footnotesize\addfontfeature{Color=lightgray} #2}\\%
    #3\vspace{\parsep}%
  }\\}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end body
\endinput
