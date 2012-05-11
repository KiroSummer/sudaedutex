% BibTeX standard bibliography style `plain'
	% version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
	% Copyright (C) 1985, all rights reserved.
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
	% This restriction helps ensure that all standard styles are identical.
	% The file btxbst.doc has the documentation for this style.
%乔海泉说明
% 增加域  lang-区分中英文（非空为中文）     translator-- 译者(仅在book中）
% 修改：  去掉最后一个作者前的and, 自动截短为最多三个作者
%         增加book, inproceedings, article的文献类型标识
%         去掉英文作者缩写中的句点， 不输出proceedings
%         修改article, inproceedings的年月卷期格式
%         book中的 出版地：出版者
%	  techreport 中的number
%	  manual,misc,techreport 中的url
%         manual的文献类型默认为[R]，属于报告, 因为[M]有出版者, 可以包含TypeofLit
%         misc包含域TypeofLit

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    lang  %
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    translator  % 仅在book中
    type
    typeoflit
    url % 
    volume
    year
   }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { add.period$ " " * write$ }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$
  newline$  % 为了实现backref
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ %duplicate$ empty$
  %  { pop$ "" }
  %  { "{\em " swap$ * "}" * }
  %if$
  skip$
}

STRINGS {z u v}

INTEGERS { charptr lennames inbrace}

FUNCTION {remove.dot.innamea}
{
 'u :=
  "" 
  #0 'inbrace :=
  #1 'charptr :=
  "1" 't :=   
% 空格是emtpy$  "{"的text.length$是0
   {t text.length$ #0 = "{" t = not "}" t = not and and not} % while (!( length(t)==0 && t != "{" && t != "}" ))
% { charptr lennames < }  不能用：in case : {\'e} and \'{e}  
   { u charptr #1 substring$  't :=
       "." t =
       { %当点后面是~或空格时，去掉点，否则点改成空格u charptr #1 + #1 substring$ 'v := 
         v text.length$ #0 =  
	 'skip$
	 {  "~" v =  " " v = or
	     'skip$ 
	     { " " *} 
	     if$ 
	  } 
	 if$
	}
       {t * }
       if$
     charptr #1 + 'charptr :=
   }
   while$
}
% 下面是chinesebst.bst中的定义，更简洁
FUNCTION {remove.dot.inname}
{ 'z :=
  ""
  { z empty$ not }
  { z #1 #1 substring$ z #2 #1 substring$ 'v :=
     duplicate$ "." =
     {  v empty$  v "~" =  v " " = or or
       'pop$
       {pop$ " " * }%"|||||||||||||||"  z * "||||||||||||||||||||||" * cite$ *  warning$} 
       if$
     }
     {*}
     if$
     z #2 global.max$ substring$ 'z :=
  }
  while$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
   s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 >  nameptr #4 < and }
    {  lang missing$ 
       % {s nameptr "{vv~}{ll}{ ff{~}}{, jj}" format.name$ 't := }
        {s nameptr "{ff~}{vv{~}}{ll{~}}{, jj}" format.name$ remove.dot.inname  't :=}
        {s nameptr "{ff~}{vv{~}}{ll{~}}{, jj}" format.name$ 't := }
	if$
        nameptr #1 >
	{ 
	    ", " * t * 
	   namesleft #1 > nameptr #3 = and
	   {    lang missing$
	        { ", et~al." * }
		{ ", 等" *}
		if$
  	   }
	   'skip$
	   if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
	{ ", editors" * }
	{ ", editor" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ %title empty$
  %  { "" }
  %  { title "t" change.case$ }
  %if$
  title 
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
	 month
	}
      if$
    }
    { month empty$
	'year
	{   lang missing$
  	    { month " " * year * }
	    { year "-" * month * }
	    if$
	}
	if$
     }
  if$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { lang empty$ 
      {":volume" volume tie.or.space.connect
      series empty$
	'skip$
	{ " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
      }
      {
      "：第"  volume * "卷" *  %未处理"期"
      }
      if$
      
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ output.state mid.sentence =
	    { "number" }
	    { "Number" }
	  if$
	  number tie.or.space.connect
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { " in " * series * }
	  if$
	}
      if$
    }
    { "" }
  if$
}

% 只测过book中含有edition的情况
FUNCTION {format.edition}
{ edition empty$
    { "" }
    { 
      lang missing$
        {  
    	     output.state mid.sentence =
	     { edition "l" change.case$ " edition" * }
	     { edition "t" change.case$ " edition" * }
             if$
         }
	 {
	   "第" edition * "版" * 
	 }
	 if$
     }
     if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ "pages" pages n.dashify tie.or.space.connect }
	{ "page" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.year.pages}
{ 
  format.date 
  pages empty$
    'skip$
    { ":" * pages n.dashify * }
   if$
}

FUNCTION {format.year.vol.num.pages}
{ 
  format.date           % "year" output.check
  %volume missing$
  %{"" *}
  %{ 
  duplicate$ empty$ 'skip$ {", " *} if$ 
  %}
  %if$
  volume field.or.null *
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$  year empty$ and
	{ pop$ format.pages }
	{ ":" * pages n.dashify * }
      if$
    }
  if$
}


FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "chapter" }
	{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
	{ "In " booktitle emphasize * }
	{ "In " format.editors * ", " * booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.tr.number}
{% type empty$
 %   { "Technical Report" }
 %   'type
 % if$
  number empty$
  {""} %  { "t" change.case$ }
  {", " number * } %{ number tie.or.space.connect }
  if$
}
FUNCTION {format.url}
{ url missing$
    { "" }
    { 
	new.block 
    	"\url{" url * "}" * 
    }
  if$
}
FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "In {\em " journal * "\/}" * }
      if$
    }
    { "In " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
	    { " et~al." * }
	    { " and " * editor #2 "{vv~}{ll}" format.name$ * }
	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "In "
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { "{\em " * series * "\/}" * }
	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
	    { "In {\em " booktitle * "\/}" * }
	  if$
	}
	{ "In " key * }
      if$
    }
    { "In " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.translator}
{
	translator missing$
	{""}
	{	lang missing$
		{ translator format.names ", translation" * }
		{ translator format.names ", 译" *}
		if$
	}
	if$
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "[J]" * "title" output.check
  new.block
  crossref missing$
    { journal emphasize "journal" output.check
      %format.date "year" output.check
      format.year.vol.num.pages output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {format.book.addr.pub}
{
	address missing$
	{publisher missing$ {""} {publisher} if$ }
	{address ":" * publisher *}
	if$
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.title format.bvolume * "[M]" * "title" output.check
  crossref missing$
    { %format.bvolume output
      format.edition output
      new.block
      format.translator output
      new.block
      format.number.series output
      new.sentence
      format.book.addr.pub "publisher" output.check
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {format.in.title}
{  
   's :=
   title empty$
   {""}
   {
     format.title "[" * s * "]" * 
     editor empty$ 
        'skip$
        { "//" * editor format.names * }
     if$ 
   }
   if$
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  "M" format.title "title" output.check
  new.block
  crossref missing$
    { booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      publisher "publisher" output.check
      address output
      format.edition output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  note output
  fin.entry
}


FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  "C" format.in.title "title" output.check
  new.block
  crossref missing$
    { booktitle format.bvolume * "booktitle" output.check
      %format.bvolume output
      format.number.series output
       address empty$
	{ organization publisher new.sentence.checkb
	  organization output
	  publisher output
	}
	{ address output.nonnull
	  new.sentence
	  organization output
	  publisher output
	}
      if$
      format.year.pages "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }
FUNCTION {format.manual.typeoflit}
{
    typeoflit missing$
    {   url missing$
        {"[R]"}
	{"[R/OL]"}
	if$
    }
    { "[" typeoflit * "]" * }
    if$
}

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.title format.manual.typeoflit * "title" output.check
  author empty$
    { organization empty$
	{ address new.block.checka
	  address output
	}
	'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {format.misc.typeoflit}
{% 无输入文献类型时： 有题目和url时文献类型设为[EB/OL］，否则为空
   title missing$
   {""}
   {   typeoflit missing$
       {  url missing$
          {""}
	  {"[EB/OL]"}
	  if$
	}
	{ "[" typeoflit * "]" * }
	if$
   }
   if$
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title format.misc.typeoflit * output
  howpublished new.block.checka
  howpublished output
  format.date output
  new.block
  format.url output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "[D]" * "title" output.check
  new.block
  %"PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}
FUNCTION {mastersthesis} {phdthesis}

FUNCTION {proceedings}
{ skip$ }

FUNCTION {Aproceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ publisher new.sentence.checka }
	{ organization publisher new.sentence.checkb
	  organization output
	}
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      editor empty$
	'skip$
	{ organization output }
      if$
      publisher output
    }
  if$
  new.block
  note output
  fin.entry
}
FUNCTION {format.tech.typeoflit}
{
   url missing$
   {"[R]"}
   {"[R/OL]"}
   if$
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title format.tr.number * format.tech.typeoflit * "title" output.check
  institution "institution" output.check
  address output
  format.date "year" output.check
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  format.date output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ


INTEGERS { seq.num }

FUNCTION {init.seq}
{ #0 'seq.num :=}

EXECUTE {init.seq}

FUNCTION {int.to.fix}
{ "000000000" swap$ int.to.str$ *
  #-1 #6 substring$
  }

FUNCTION {presort}
{ %calc.label
 % label sortify
 %  "    "
 %   *
   seq.num #1 + 'seq.num :=
   seq.num  int.to.fix
  %   'sort.label :=
  %     sort.label *
 % #1 entry.max$ substring$
 'sort.key$ :=
%"==========" cite$ * "===========	" * "sort key=" * sort.key$ * warning$
}

ITERATE {presort}

SORT

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" %\label{qhq:bib} \addcontentsline{toc}{chapter}{参考文献}" 
  * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
