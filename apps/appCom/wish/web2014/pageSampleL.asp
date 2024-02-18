<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	'// 페이지 타이틀
	strPageTitle = "10X10: Sample Page"
	
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
<% if (flgDevice="I") then %>
<% if InStr(uAgent,"tenapp i1.6")>0 then %>
<%
dim wsapp_loaded, wsapp_loaded_next, wsapp_loaded_pre
dim wsapp_Ccd 
dim wsapp_Ncd 
dim wsapp_Nurl 
dim wsapp_Pcd 
dim wsapp_Purl

	wsapp_loaded = session("wloaded")

	wsapp_Ccd = "today"
	wsapp_Ncd = "best"  : wsapp_Nurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/pageSample.asp"
	wsapp_Pcd = ""      : wsapp_Purl = ""
	
	if InStr(wsapp_loaded,wsapp_Ccd)<1 then
	    wsapp_loaded = wsapp_loaded & ","&wsapp_Ccd
	    session("wloaded") = wsapp_loaded
	end if
	
	if (wsapp_Ncd="") then
	    wsapp_loaded_next = true
	else
	    wsapp_loaded_next = InStr(wsapp_loaded,wsapp_Ncd)>0 
    end if
    
    if (wsapp_Pcd="") then
	    wsapp_loaded_pre  = true
	else
	    wsapp_loaded_pre = InStr(wsapp_loaded,wsapp_Pcd)>0 
    end if
	
%>

var _Rchk =false;
var _Lchk =false;

function _goRight(){
    <% if (NOT wsapp_loaded_next) then %>
    if (!_Rchk){
        fnAPPselectGNBMenu('<%=wsapp_Ncd%>','<%=wsapp_Nurl%>');
        _Rchk = true;
    }
    <% end if %>
}

function _goleft(){
    <% if (NOT wsapp_loaded_pre) then %>
    if (!_Lchk){
        fnAPPselectGNBMenu('<%=wsapp_Pcd%>','<%=wsapp_Purl%>');
        _Lchk = true;
    }
    <% end if %>
}

<% if (Not wsapp_loaded_next) or (Not wsapp_loaded_pre) then %>
document.addEventListener('touchstart', handleTouchStart, false);        
document.addEventListener('touchmove', handleTouchMove, false);
<% end if %>

var xDown = null;                                                        
var yDown = null;                                                        


function handleTouchStart(evt) {                                         
    xDown = evt.touches[0].clientX;                                      
    yDown = evt.touches[0].clientY;                                      
};                                                

function handleTouchMove(evt) {
    if ( ! xDown || ! yDown ) {
        return;
    }

    var xUp = evt.touches[0].clientX;                                    
    var yUp = evt.touches[0].clientY;

    var xDiff = xDown - xUp;
    var yDiff = yDown - yUp;

    if ( Math.abs( xDiff ) > Math.abs( yDiff ) ) {/*most significant*/
        if ( xDiff > 2 ) {
            /* left swipe */ 
            _goRight(); 
        } else  if ( xDiff < - 2 ) {
            /* right swipe */
             _goleft();
        }                       
    } else {
        if ( yDiff > 0 ) {
            /* up swipe */ 
        } else { 
            /* down swipe */
        }                                                                 
    }
    /* reset values */
    xDown = null;
    yDown = null;                                             
};
<% end if %>
<% end if %>
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<p style="padding:1em; font-size:0.75em; height:100px; background-color:#eee;"><a href="javascript:document.location.reload();">*** content area ***</a></p>
			<p>LL-<%=flgDevice%></p>
			<p><%=wsapp_loaded%></p>
			<p>
				<form name="f1"><input type="text" name="a" /></form>
				<form name="f2"><input type="text" name="a" /></form>
				<input type="button" onclick="fnTest('f1')" value="첫번째">
				<input type="button" onclick="fnTest('f2')" value="두번째">
				<script>
				function fnTest(fnm) {
					//var frm = $("form[name='"+fnm+"']");
					//$(frm).find("input[name='a']").val(fnm);
					var frm = eval("document." + fnm);
					frm.a.value = fnm;
				}
				</script>
			</p>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->