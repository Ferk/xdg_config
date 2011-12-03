;;; org-latex-theme.el --- Custom LaTex configuration theme

;; Copyright (C) 2011 Free Software Foundation, Inc.

;; Author: Fernando Carmona Varo <ferkiwi@gmail.com>
;; Created: 2011-11-28

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; <http://www.gnu.org/licenses/>.

;;;


(deftheme org-latex
  "Custom LaTex configuration options.")

(provide-theme 'org-latex)

(custom-theme-set-variables
 'org-latex

'(org-export-latex-default-packages-alist
  '(("AUTO" "inputenc" t)
    ("T1" "fontenc" t)
    ("" "fixltx2e" nil)
    ("" "graphicx" t)
    ("" "longtable" nil)
    ("" "float" nil)
    ("" "wrapfig" nil)
    ("" "soul" t)
    ("" "textcomp" t)
    ("" "marvosym" t)
    ("" "wasysym" t)
    ("" "latexsym" t)
    ("" "amssymb" t)
    ("" "hyperref" nil)
    "\\tolerance=1000"))

 '(org-export-latex-classes 
   '(
     ;; Reference Card
     ("refcard" 
      "\\documentclass[9pt,a4paper,oneside,twocolumn]{memoir}
[NO-DEFAULT-PACKAGES]
[EXTRA]
\\usepackage[AUTO]{inputenc}
[PACKAGES]

\\chapterstyle{article}
\\usepackage[mathletters]{ucs}
\\settrimmedsize{0pt}{0pt}{0pt}
\\usepackage{color}
\\usepackage[pdftex,colorlinks=true,plainpages=false]{hyperref}
\\usepackage{listings}

\\fontsize{6}{6}\\selectfont

% reducir tamaño del indice
\\usepackage{idxlayout}
\\renewcommand*{\\indexfont}{\\fontsize{4}{4}\\selectfont}

% reducir espacio
\\usepackage[small,compact]{titlesec} 
\\usepackage[small,it]{caption}
\\usepackage{savetrees}

\\titleformat{\\section}
  {\\normalfont\\Large\\bfseries}{\\thesection.}{1em}{}

%%%
% meter un número de página
%\\pagestyle{plain}

\\setlength\\columnsep{1pc}          %    Space between columns
\\setlength\\columnseprule{0pc}     %    Width of rule between columns.
\\hfuzz 2pt               % Allow some variation in column width, otherwise it's
                         % too hard to typeset in narrow columns.

\\usepackage[top=0.5cm, bottom=0.5cm, left=0.5cm, right=0.5cm]{geometry}
%\\setlength{\\headheight}{0cm}
%\\setlength{\\headsep}{0cm}
%\\setlength{\\parindent}{0em}
%\\setlength{\\parskip}{0em}

  \\font\\smallfont=cmr6
  \\font\\smallsy=cmsy6
  \\font\\eightrm=cmr8
  \\font\\eightbf=cmbx8
  \\font\\eightit=cmti8
  \\font\\eighttt=cmtt8
  \\font\\eightsy=cmsy8
  \\font\\eightsl=cmsl8
  \\font\\eighti=cmmi8
  \\font\\eightex=cmex10 at 8pt
  \\textfont0=\\eightrm  
  \\textfont1=\\eighti
  \\textfont2=\\eightsy
  \\textfont3=\\eightex
  \\def\\rm{\\fam0 \\eightrm}
  \\def\\bf{\\eightbf}
  \\def\\it{\\eightit}
  \\def\\tt{\\eighttt}
  \\def\\sl{\\eightsl}
  \\normalbaselineskip=.8\\normalbaselineskip
  \\normallineskip=.8\\normallineskip
  \\normallineskiplimit=.8\\normallineskiplimit
  \\normalbaselines\\rm		%make definitions take effect

\\setcounter{tocdepth}{0}
\\setcounter{secnumdepth}{1}

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Redefine la cabecera para los capítulos
\\makeatletter
\\renewcommand*\\@makechapterhead[1]{%
  {\\nobreak \\parindent \\z@ \\raggedright \\normalfont \\color{brown}
    \\huge\\bfseries
    \\ifnum \\c@secnumdepth >\\m@ne
         \\thechapter . \\space
    \\fi
    #1\\par
    \\vskip 10\\p@
  }}
\\renewcommand\\subsubsection{\\@startsection{subsubsection}{3}{\\z@}%
                                          {-3.25ex \\@plus -1ex \\@minus -.2ex}%
                                          {0.1em \\@plus 0.2em}%
                                          {\\normalfont\\normalsize\\bfseries\\singlespacing}}
\\renewcommand\\paragraph{\\@startsection{paragraph}{4}{\\z@}%
                                      {3.25ex \\@plus 1ex \\@minus .2ex}%
                                      {-1em}%
                                      {\\normalfont\\normalsize\\bfseries\\singlespacing}}
%                                      {\\@acmtitlestyle}}
%%% 
% titulo
%\\renewcommand{\\@maketitle}{
%	\\begin{center}
%		\\huge{\\@title}
%
%        \\small{\\@author, \\@date}
%    \\end{center}
%} 
\\makeatother

"
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))


     ;; Articles
     ("article" 
      "\\documentclass[11pt]{article}" 
      ("\\section{%s}" . "\\section*{%s}") 
      ("\\subsection{%s}" . "\\subsection*{%s}") 
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}") 
      ("\\paragraph{%s}" . "\\paragraph*{%s}") 
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))

     ;; Reports
     ("report"
      "\\documentclass[11pt]{report}" 
      ("\\part{%s}" . "\\part*{%s}") 
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}") 
      ("\\subsection{%s}" . "\\subsection*{%s}") 
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")) 

     ;; Book format
     ("book" 
      "\\documentclass[11pt]{book}" 
      ("\\part{%s}" . "\\part*{%s}") 
      ("\\chapter{%s}" . "\\chapter*{%s}") 
      ("\\section{%s}" . "\\section*{%s}") 
      ("\\subsection{%s}" . "\\subsection*{%s}") 
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")) 

     ;; Beamer presentations
     ("beamer" 
      "\\documentclass{beamer}" 
      org-beamer-sectioning)))
 )
 
