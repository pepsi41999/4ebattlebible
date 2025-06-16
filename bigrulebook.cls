\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bigrulebook}[20250616 My custom codex format updated for battle bible] 

\LoadClass[openany, letterpaper, 9pt]{memoir}
\RequirePackage[english]{babel}

\RequirePackage{graphicx}%needed for scalebox for extra large text


\RequirePackage{lipsum}

\RequirePackage{tikz}

\RequirePackage{background}%broken with memoir twocolumn for some reason, need to work around.
\backgroundsetup{
	scale=1,
	color=black,
	opacity=0.4,
	angle=0,
	contents={%
	\includegraphics[width=\paperwidth,height=\paperheight]{art/background}
	}%
}

\RequirePackage{fontspec}
    \setmainfont{MinionPro}[
        Path = {./font/MinionPro/},
        Extension = {.otf},
        UprightFont = {*-Regular},
        BoldFont = {*-SemiBold},
    ]

    \newfontfamily\brbchapterfont{CaslonAntique}[
        Path = {./font/CaslonAntique/},
        Extension = {.ttf},
        % UprightFont = {*-Regular},
        % BoldFont = {*-SemiBold},
    ]

    \newfontfamily\brbpagenumberfont{CaslonAntique}[
        Path = {./font/CaslonAntique/},
        Extension = {.ttf},
        % UprightFont = {*-Regular},
        % BoldFont = {*-SemiBold},
    ]


    \newfontfamily\brbsectionfont{Arial}[
        Path = {./font/Arial/},
        Extension = {.ttf},
        UprightFont = {*-Regular},
        BoldFont = {*-Bold},
    ]

    \newfontfamily\brbsubsectionfont{RobotoCondensed}[
        Path = {./font/Roboto_Condensed/},
        Extension = {.ttf},
        UprightFont = {*-Regular},
        % BoldFont = {*-SemiBold},
    ]

\RequirePackage{colortbl}			% table cell colors
	\definecolor{green1}{RGB}{36,65,63}

\RequirePackage{geometry}
\geometry{hmargin={0.75in,0.75in},vmargin={0.75in,0.75in},marginparwidth={0.8in},marginparsep={0in}}

\RequirePackage{multicol}
    \columnsep=5ex
    % \columnseprule=0.4pt
    % \flushcolumns
    \raggedcolumns

\RequirePackage{enumerate}%numberd lists
\RequirePackage{enumitem}%fancy lists

\RequirePackage{tabularray}

\RequirePackage{xparse}%expl3 syntax commands

\RequirePackage[colorlinks=true, linkcolor = black]{hyperref}%Make sure it comes last of your loaded packages (page 5 in manual)
\RequirePackage{bookmark}%allows for colored toc links. Allows for subsections without a section. Has to be loaded after hyperref.



\ExplSyntaxOn
\NewDocumentCommand{\cost}{m}{%special macro for auto formating points!
	\fp_compare:nTF {#1 = 0}{%if equals 0
		\dotfill free
	}{%else
		\fp_compare:nTF {#1 = 1}{%if equals 1
			\dotfill #1~point
		}{%else
			\dotfill #1~points	
		}
	}
}
\ExplSyntaxOff



%nospace center command (this should really just be the default)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{nscenter}
	{\parskip=0.5\baselineskip plus 0.1\baselineskip minus 0.1\baselineskip \par\nopagebreak\centering}
	{\par\noindent\ignorespacesafterend}





% Big Rulebook Style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize to basics (tbh I dont know if this is needed)
\pagestyle{plain}%this puts page numbers at the bottom center (probly other things too)

%by default, for some fucking reason, there is no way to get the current chapter, section, subsection, etc.
%and by some even fucking dumber reason, there is this thing called leftmark and rightmark that do contain the current chapter and section (but not the others) as pre formated strings.
%Why you would ever want to specify a 'leftmark' which then you have to specify goes in the left spot is beyond me, its an extra step for no reason.
%I have renewed the \chaptermark command here to always keep track of just thechaptername (compliementing thechapter which is the number only.)
\def\thechaptername{}
\renewcommand{\chaptermark}[1]{\def\thechaptername{#1}}




% Pagestyles seem to only do headers and footers? Im not really sure what the point is, then. A page style should idealy define everything from margines to chapter look to footers. But the way the \chapter command actually works is it uses a thispagestyle command which is kinda circular then. Almost like its backwards? I want to make a macro that you call can call once at the top of the document and it loads everything. One for bigrulebook, 

%clone the plain i.e. the basic pagestyle as a start
\copypagestyle{bigrulebook}{plain}



%place a hyperlink to the table of contents in the top left of every page
% \makeevenhead{bigrulebook}{\hyperref[toc]{Table of Contents}}{}{\MakeTextUppercase{Chapter \thechapter{}. \ \thechaptername{}}}
% \makeoddhead{bigrulebook}{\hyperref[toc]{Table of Contents}}{}{\MakeTextUppercase{Chapter \thechapter{}. \ \thechaptername{}}}

% Sets the page number to be on the outside edges
% \makeevenfoot{yourstyle}{left}{middle}{right}
\makeevenfoot{bigrulebook}{\Huge\brbpagenumberfont\thepage}{}{}
\makeoddfoot{bigrulebook}{}{}{\Huge\brbpagenumberfont\thepage}
\setlength{\footskip}{35pt}


\chapterstyle{bigrulebook}%dont change the style on chapters

\pagestyle{bigrulebook}


% Chapter Formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The way chapter formatting works is that the \chapter command itself is just a function, which calls a ton of helper functions. 
% To really edit the way a chapter looks, you have to re-define these parts the way you want. See memman page 84.

% \newcommand{\chapterhead}[1]{ % THIS IS A SIMPLIFIED VERSION
%    \clearforchapter        % move to correct page
%    \thispagestyle{chapter} % set the page style
%    \insertchapterspace     % Inserts space into LoF and LoT
%    \chapterheadstart       % \beforechapskip space before heading
%    \printchaptername\chapternamenum\printchapternum
%    \afterchapternum        % \midchapskip space between number and title
%    \printchaptertitle{#1}  % title
%    \afterchaptertitle}     % \afterchapskip space after title

% \newcommand{\@chs@def@ult}{%
%   \def\chapterheadstart{\vspace*{\beforechapskip}}%
%   \def\printchaptername{\chapnamefont \@chapapp}%
%   \def\chapternamenum{\space}%
%   \def\printchapternum{\chapnumfont \thechapter}%
%   \def\afterchapternum{\par\nobreak\vskip \midchapskip}%
%   \def\printchaptertitle##1{\chaptitlefont ##1}%
%   \def\afterchaptertitle{\par\nobreak\vskip \afterchapskip}%

%   \def\chapnamefont{\normalfont\huge\bfseries}%
%   \def\chapnumfont{\normalfont\huge\bfseries}%
%   \def\chaptitlefont{\normalfont\Huge\bfseries}%

%   \setlength{\beforechapskip}{50pt}%
%   \setlength{\midchapskip}{20pt}%
%   \setlength{\afterchapskip}{40pt}}

% \renewcommand{\clearforchapter}{\clearpage}%set chapter clear page to be constant, rather than the default of always start on right page
\renewcommand{\insertchapterspace}{}%dissable extra space in list of figures and tables.

\setlength{\beforechapskip}{0pt}%sets the before chapter skip to 0
%I cannot figure out how to edit \thispagestyle{chapter} so my option is to immediatly undo it.
\renewcommand*{\chapterheadstart}{\thispagestyle{bigrulebook}}%establishes the top bar on chapters, after the beforechapskip
  % \mbox{}\\\mbox{}\rule[0em]{\textwidth}{0.4pt}\par}%sets the top rule

\renewcommand*{\printchaptername}{}%dont print the word "Chapter"
\renewcommand*{\chapternamenum}{}%no space between "Chapter" and "Number"

\renewcommand*{\printchapternum}{}%dont print chapter number
\renewcommand*{\afterchapternum}{}%no verticle space between "Chapter" "Number" and the "Title"

\renewcommand*{\printchaptertitle}[1]{\centering \makebox[\textwidth][c]{
	\begin{tikzpicture}[baseline=0pt]
		\node[inner sep = 0pt] (0,0) {\includegraphics[width = 1.025\textwidth]{art/chapterbar.png}};
		\node[inner sep = 0pt] (0,0) {\scalebox{1.5}{\HUGE \brbchapterfont\color{white}\MakeTextUppercase{#1}}};
		\end{tikzpicture}
	}%endmbox
}%endrenewcomand
\renewcommand*{\afterchaptertitle}{\par\nobreak\vskip \afterchapskip}%
% \renewcommand*{\afterchaptertitle}{\mbox{}\rule[0.7em]{\textwidth}{0.4pt} \par\nobreak\vskip \afterchapskip}%



%BROKEN with two columns dont know why
% \renewcommand{\clearforchapter}{}%set chapter clear page to be constant, rather than the default of always start on right page

% Section Formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% store the section name in case you need it
\def\thesectionname{}
\renewcommand{\sectionmark}[1]{\def\thesectionname{#1}}


%format section headings
\setsecheadstyle{\color{green1}\huge\bfseries\brbsectionfont\MakeTextUppercase}%sets my section style
\setsecnumformat{}%formats no numbers in section headings
\setbeforesecskip{1.125\onelineskip plus 0.1\onelineskip minus 0.05\onelineskip}
\setaftersecskip{0.375\onelineskip plus 0.05\onelineskip minus 0.025\onelineskip}


%format subsection
\setsubsecheadstyle{\Large\brbsubsectionfont\bfseries\raggedright}
\setbeforesubsecskip{-0.667\onelineskip plus -0.25\onelineskip minus -0.25\onelineskip}%
\setaftersubsecskip{0.15\onelineskip plus 0.05\onelineskip}%


%format subsubsection
\setsubsubsecheadstyle{\itshape\bfseries\raggedright}

% Basic Page Formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\nonzeroparskip%Use a non-zero parskip (from memour class)
\setlength{\parindent}{0pt}%dont auto indent paragraphs


% Table of contents formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setcounter{tocdepth}{1}%limit ToC to sections and up
\renewcommand{\numberline}[1]{}% Gobble section and subsection numbers in ToC
%note, that these commands do not actually remove the numbering, like \setsecnumdepth{chapter} %(chapters and up have numbering) would do. It just suppresses them in the toc.

% List Formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setlist{topsep=0pt, itemsep=0pt, parsep=0pt}%tighter lists
\setlist[itemize]{left=0pt}%no list leftmargin
\setlist[itemize,2]{label=-}% sets secondary lists to be - instead of default



\AtBeginDocument{\addtocontents{toc}{\protect\thispagestyle{bigrulebook}}}%
\AtBeginDocument{\addtocontents{toc}{\protect\begin{multicols}{3}}}%
\AtBeginDocument{\addtocontents{toc}{\protect\label{toc}}}%

\AtEndDocument{\addtocontents{toc}{\protect\end{multicols}}}%
\AtEndDocument{\rule{0in}{0in}}%I have NO idea why this is needed, but if I dont have something follow the endmulticols it wont appear in the ToC
