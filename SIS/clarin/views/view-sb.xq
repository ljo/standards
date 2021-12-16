xquery version "3.0";

declare namespace request = "http://exist-db.org/xquery/request";
declare namespace exist = "http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes doctype-system=about:legacy-compat";

import module namespace menu = "http://clarin.ids-mannheim.de/standards/menu" at "../modules/menu.xql";
import module namespace app = "http://clarin.ids-mannheim.de/standards/app" at "../modules/app.xql";
import module namespace sbm = "http://clarin.ids-mannheim.de/standards/sb-module" at "../modules/sb.xql";

(: Define the standard body page 
   @author margaretha
   @date Dec 2013
:)

let $id := request:get-parameter('id', '')
let $sb := sbm:get-sb($id)
let $sb-title := $sb/titleStmt/title/text()
let $specs-by-sb := sbm:get-specs-by-sb($id)

return
    
    <html>
        <head>
            <title>Standard Setting Body: {$sb-title}</title>
            <link rel="stylesheet" type="text/css" href="{app:resource("style.css", "css")}"/>
            <script type="text/javascript" src="{app:resource("d3.v2.js", "js")}"/>
            <script type="text/javascript" src="{app:resource("forcegraph.js", "js")}"/>
        </head>
        
        <body onload="drawGraph('{sbm:get-sb-json($id)}','500','300','-100');">
            <div id="all">
                <div class="logoheader"/>
                {menu:view()}
                {
                    
                    if ($id and $sb) then
                        <div class="content">
                            <div class="navigation">
                                &gt; <a href="{app:link("views/list-sbs.xq")}">Standard Bodies</a>
                                &gt; <a href="{app:link(concat("views/view-sb.xq?id=", $sb/@id))}">{$sb-title}</a>
                            </div>
                            <div class="title">
                                {$sb-title}
                                {sbm:get-sb-abbr($sb, $id, $sb-title)}
                            </div>
                            {sbm:get-sb-respStmt($sb)}
                            {sbm:print-description($sb)}
                            {sbm:print-url($sb)}
                            {
                                if ($specs-by-sb)
                                then
                                    (<div class="heading">Specifications standardized by this body:</div>,
                                    $specs-by-sb)
                                else
                                    ()
                            }
                            <br/>
                            {sbm:create-relation-graph($sb)}
                        </div>
                    else
                        <div class="content">
                            <div class="navigation">
                                &gt; <a href="{app:link("views/list-sbs.xq")}">Standard Bodies</a>
                            </div>
                            <div><span class="heading">The requested standard body information is not found.</span></div>
                        </div>
                }
                <div class="footer">{app:footer()}</div>
            </div>
        </body>
    </html>