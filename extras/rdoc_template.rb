CAMPING_EXTRAS_DIR = File.expand_path(File.dirname(__FILE__))

module Generators
class HTMLGenerator
    def generate_html
      @files_and_classes = {
        'allfiles'     => gen_into_index(@files),
        'allclasses'   => gen_into_index(@classes),
        "initial_page" => main_url,
        'realtitle'    => CGI.escapeHTML(@options.title),
        'charset'      => @options.charset
      }

      # the individual descriptions for files and classes
      gen_into(@files)
      gen_into(@classes)
      gen_main_index
      
      # this method is defined in the template file
      write_extra_pages if defined? write_extra_pages
      RDoc.send :remove_const, :Page # clean up for other templates
    end

    def gen_into(list)
      hsh = @files_and_classes.dup
      list.each do |item|
        if item.document_self
          op_file = item.path
          hsh['root'] = item.path.split("/").map { ".." }[1..-1].join("/")
          item.instance_variable_set("@values", hsh)
          File.makedirs(File.dirname(op_file))
          File.open(op_file, "w") { |file| item.write_on(file) }
        end
      end
    end

    def gen_into_index(list)
      res = []
      list.each do |item|
        hsh = item.value_hash
        hsh['href'] = item.path
        hsh['name'] = item.index_name
        res << hsh
      end
      res
    end

    def gen_main_index
      template = TemplatePage.new(RDoc::Page::INDEX)
      File.open("index.html", "w") do |f|
        values = @files_and_classes.dup
        if @options.inline_source
          values['inline_source'] = true
        end
        template.write_html_on(f, values)
      end
      #['Camping.gif', 'permalink.gif'].each do |img|
      #    ipath = File.join(CAMPING_EXTRAS_DIR, img)
      #    File.copy(ipath, img)
      #end
    end
end
end


module RDoc
module Page
######################################################################
#
# The following is used for the -1 option
#

FONTS = "verdana,arial,'Bitstream Vera Sans',helvetica,sans-serif"

STYLE = %{
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,form,fieldset,input,textarea,p,blockquote,th,td {
  margin:0;
  padding:0;
  text-align: left;
}

a { outline:none; }

table { border-collapse:collapse; border-spacing:0; }

fieldset,img { border:0; }

address,caption,cite,code,dfn,em,strong,th,var { font-style:normal; font-weight:normal; }

ol,ul { list-style:none; }

caption,th { text-align:left; }

h1,h2,h3,h4,h5,h6 { font-size: 100%; font-weight:normal; }

q:before,q:after { content:''; }

abbr,acronym { border:0; }

body {
  font: 13px/18px Arial, sans-serif;
}


    a, a:visited { color: #00f; }
    #container { width: 900px; margin: 18px auto; }
    #left {
      width: 200px;
      float: left;
    }
    #content {
      width: 660px;
      padding: 0 0 0 20px;
      margin-left: 220px;

    }

    tt {
      font: 13px/18px monospace;
    }
    pre {
      border: 1px dotted #ccc;
      padding: 9px;
      background-color: #D7EAF2;
      margin: 9px 0;
    }

    dt {
      width: 100px;

    }

    dd {
      margin: 0 0 9px 20px;

    }


    li {
      margin-left: 18px;
      list-style: disc;
    }
    
    ul, pre, p {
      margin-bottom: 18px;
    }


    h1 {
      font: bold 22px/27px Arial;
      margin-bottom: 9px
    }


    h2 {
      font: bold 18px/27px Arial;
      margin-bottom: 9px
    }

    h3 {
      font: bold 16px/18px Arial;
      margin: 9px 0;
    }

    h3.section-bar {
      font: 15px/18px Arial;
      margin: 27px 0 9px -20px;
      padding: 3px;
      background-color: #dedede;
    }


    #content h1, #content h2, #content h3 {
      margin-left: -20px;
    }

    h1 a, h2 a, h3 a, h4 a, h5 a, h6 a,
    a.method-signature {
      color: #000;

      text-decoration: none;
    }

    .method-detail {
      margin-bottom: 18px;
      padding: 9px 0;
      border-bottom: 1px solid #aaa;
    }

    .method-heading {

      margin-left: -20px;
      margin-bottom: 9px;
    }
    .method-heading a {
      font: bold 14px/18px Arial;



    }

    .meta {
      padding: 0 0 9px;
    }
    
    .meta, .meta a {
      color: #666;
    }

    .method-source-code { display: none; }

    .dyn-source { background-color: #775915; padding: 4px 8px; margin: 0; display: none; }
    .dyn-source pre  { color: #DDDDDD; font-size: 8pt; }
    .source-link     { text-align: right; font-size: 8pt; }
    .ruby-comment    { color: green; font-style: italic }
    .ruby-constant   { color: #CCDDFF; font-weight: bold; }
    .ruby-identifier { color: #CCCCCC;  }
    .ruby-ivar       { color: #BBCCFF; }
    .ruby-keyword    { color: #EEEEFF; font-weight: bold }
    .ruby-node       { color: #FFFFFF; }
    .ruby-operator   { color: #CCCCCC;  }
    .ruby-regexp     { color: #DDFFDD; }
    .ruby-value      { color: #FFAAAA; font-style: italic }
    .kw { color: #DDDDFF; font-weight: bold }
    .cmt { color: #CCFFCC; font-style: italic }
    .str { color: #EECCCC; font-style: italic }
    .re  { color: #EECCCC; }
}

CONTENTS_XML = %{
IF:description
%description%
ENDIF:description

IF:requires
<h4>Requires:</h4>
<ul>
START:requires
IF:aref
<li><a href="%aref%">%name%</a></li>
ENDIF:aref
IFNOT:aref
<li>%name%</li>
ENDIF:aref 
END:requires
</ul>
ENDIF:requires

IF:attributes
<h4>Attributes</h4>
<table>
START:attributes
<tr><td>%name%</td><td>%rw%</td><td>%a_desc%</td></tr>
END:attributes
</table>
ENDIF:attributes

IF:includes
<h4>Includes</h4>
<ul>
START:includes
IF:aref
<li><a href="%aref%">%name%</a></li>
ENDIF:aref
IFNOT:aref
<li>%name%</li>
ENDIF:aref 
END:includes
</ul>
ENDIF:includes

START:sections
IF:method_list
<h3 class="section-bar">Methods</h3>
START:method_list
IF:methods
START:methods
<div class="method-detail">
<div class="method-heading">
<!-- SHOULD BE GROUPED -->
<h4>
IF:callseq
<strong><a name="%aref%">%callseq%</a></strong>
ENDIF:callseq
IFNOT:callseq
<strong><a name="%aref%">%name%%params%</a></strong></h4>
ENDIF:callseq
</div>
IF:m_desc
%m_desc%
ENDIF:m_desc

IF:sourcecode
<div class="sourcecode">
  <p class="source-link">[ <a href="javascript:toggleSource('%aref%_source')" id="l_%aref%_source">show source</a> ]</p>
  <div id="%aref%_source" class="dyn-source">
<pre>
%sourcecode%
</pre>
  </div>
</div>
ENDIF:sourcecode
</div>
END:methods
ENDIF:methods
END:method_list
ENDIF:method_list
END:sections
}

############################################################################


BODY = %{
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>
IF:title
  %realtitle% &raquo; %title%
ENDIF:title
IFNOT:title
  %realtitle%
ENDIF:title
  </title>
  <meta http-equiv="Content-Type" content="text/html; charset=%charset%" />
  <link rel="stylesheet" href="%style_url%" type="text/css" media="screen" />
    <script language="JavaScript" type="text/javascript">
    // <![CDATA[

    function toggleSource( id )
    {
    var elem
    var link

    if( document.getElementById )
    {
    elem = document.getElementById( id )
    link = document.getElementById( "l_" + id )
    }
    else if ( document.all )
    {
    elem = eval( "document.all." + id )
    link = eval( "document.all.l_" + id )
    }
    else
    return false;

    if( elem.style.display == "block" )
    {
    elem.style.display = "none"
    link.innerHTML = "show source"
    }
    else
    {
    elem.style.display = "block"
    link.innerHTML = "hide source"
    }
    }

    function openCode( url )
    {
    window.open( url, "SOURCE_CODE", "width=400,height=400,scrollbars=yes" )
    }
    // ]]>
    </script>
</head>
<body>
<div id="container">
  <div id="header">
    <h1>
  %realtitle%

    </h1>
  </div><!-- /header -->
  <div id="left">
  <h3>Files</h3>
  <ul>
START:allfiles
    <li><a href="%root%/%href%" value="%title%">%name%</a></li>
END:allfiles
  </ul>
IF:allclasses
  <h3>Classes</h3>
  <ul>
START:allclasses
    <li><a href="%root%/%href%" title="%title%">%name%</a></li>
END:allclasses
  </ul>
ENDIF:allclasses
  </div><!-- /left -->
  <div id="content">
    !INCLUDE!
  </div><!-- /content -->
</div><!-- /container -->
</body>
</html>
}

###############################################################################

FILE_PAGE = <<_FILE_PAGE_
<div class="file">
#{CONTENTS_XML}
</div><!-- /page -->
_FILE_PAGE_

###################################################################

CLASS_PAGE = %{
<div class="class" id="%full_name%">
<h1>
IF:parent
%classmod% %full_name% <span class="meta">&lt; HREF:par_url:parent:</span>
ENDIF:parent
IFNOT:parent
%classmod% %full_name%
ENDIF:parent
</h1>
<div class="meta">
IF:infiles
(in files
START:infiles
HREF:full_path_url:full_path:
END:infiles
)
ENDIF:infiles
</div>} + CONTENTS_XML + %{
</div>
}

###################################################################

METHOD_LIST = %{
IF:includes
<div class="tablesubsubtitle">Included modules</div><br>
<div class="name-list">
START:includes
    <span class="method-name">HREF:aref:name:</span>
END:includes
</div>
ENDIF:includes

IF:method_list
START:method_list
IF:methods
<table cellpadding=5 width="100%">
<tr><td class="tablesubtitle">%type% %category% methods</td></tr>
</table>
START:methods
<a name="%aref%">
IF:callseq
<b>%callseq%</b>
ENDIF:callseq
IFNOT:callseq
 <b>%name%</b>%params%
ENDIF:callseq
IF:codeurl
<a href="%codeurl%" target="source" class="srclink">src</a>
ENDIF:codeurl
</a>
IF:m_desc
<div class="description">
%m_desc%
</div>
ENDIF:m_desc
IF:aka
<div class="aka">
This method is also aliased as
START:aka
<a href="%aref%">%name%</a>
END:aka
</div>
ENDIF:aka
IF:sourcecode
<div class="sourcecode">
  <p class="source-link">[ <a href="javascript:toggleSource('%aref%_source')" id="l_%aref%_source">show source</a> ]</p>
  <div id="%aref%_source" class="dyn-source">
<pre>
%sourcecode%
</pre>
  </div>
</div>
ENDIF:sourcecode
END:methods
ENDIF:methods
END:method_list
ENDIF:method_list
}


########################## Index ################################

FR_INDEX_BODY = %{
!INCLUDE!
}

FILE_INDEX = %{
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=%charset%">
<base target="docwin">
</head>
<body>
<div class="banner">%list_title%</div>
START:entries
<a href="%href%">%name%</a><br>
END:entries
</body></html>
}

CLASS_INDEX = FILE_INDEX
METHOD_INDEX = FILE_INDEX

INDEX = %{
<HTML>
<HEAD>
<META HTTP-EQUIV="refresh" content="0;URL=%initial_page%">
<TITLE>%realtitle%</TITLE>
</HEAD>
<BODY>
Click <a href="%initial_page%">here</a> to open the docs.
</BODY>
</HTML>
}

end
end
