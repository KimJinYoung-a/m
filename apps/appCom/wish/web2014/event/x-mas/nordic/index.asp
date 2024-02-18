<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->

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

	wsapp_Ccd = "x-mas"
	wsapp_Ncd = "diary"  : wsapp_Nurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2015/index.asp"
	wsapp_Pcd = "today"  : wsapp_Purl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/today/index.asp"
	
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

var _Rchk =<%=LCASE(wsapp_loaded_next)%>;
var _Lchk =<%=LCASE(wsapp_loaded_pre)%>;
var _evtalive =true;

function _delEvtHandle(){
    if (_Rchk&&_Lchk&&_evtalive){
        document.removeEventListener('touchstart', handleTouchStart, false);        
        document.removeEventListener('touchmove', handleTouchMove, false);
        _evtalive = false;
    }
}

function _goRight(){
    <% if (NOT wsapp_loaded_next) then %>
    if (!_Rchk){
        fnAPPselectGNBMenu('<%=wsapp_Ncd%>','<%=wsapp_Nurl%>');
        _Rchk = true;
    }
    <% end if %>
    _delEvtHandle();
}

function _goleft(){
    <% if (NOT wsapp_loaded_pre) then %>
    if (!_Lchk){
        fnAPPselectGNBMenu('<%=wsapp_Pcd%>','<%=wsapp_Purl%>');
        _Lchk = true;
    }
    <% end if %>
    _delEvtHandle();
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
<style type="text/css">
.xmasMain img {vertical-align:top;}
.xmasMain .styling {padding:8% 3% 5%;}
.xmasMain .styling ul li {margin-top:5%;}
.xmasMain .etc {margin:0 3%; padding-top:5%; padding-bottom:3%; background:url(http://fiximage.10x10.co.kr/m/2014/common/double_line.png) repeat-x 0 0; background-size:1px 1px;}
.xmasMain .etc ul {overflow:hidden;}
.xmasMain .etc ul li {float:left; width:50%;}
.xmasMain .etc ul li a {display:block; padding:0 3%}
.xmasMain .etc ul li:nth-child(1) a {padding-left:0.5%;}
.xmasMain .etc ul li:nth-child(2) a {padding-right:0.5%;}

</style>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content evtView" id="contentArea">

			<!-- 이벤트 배너 등록 영역 -->
			<div class="evtCont">
				
				<!-- CHRISTMAS MAIN -->
				<div class="xmasMain">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/txt_nordic_christmas.gif" alt="북유럽 크리스마스 마을에서 특별한 선물을 보내드려요 이벤트 기간은 2014년 12월 1일부터 12월 23일까지입니다." /></p>
					<div class="bnr"><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21384" ELSE response.write "56926" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_special.jpg" alt="IT&apos;S SPECIAL - 크리스마스 스페셜 에디션" /></a></div>
		
					<div class="styling">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/tit_nordic_home_styling.gif" alt="노르딕 홈스타일링 공간에 숨겨진 크리스마스 선물을 찾아보세요!" /></h3>
						<ul>
							<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21380" ELSE response.write "56921" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_life.jpg" alt="북유럽 거실 만들기" /></a></li>
							<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21381" ELSE response.write "56922" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_night.jpg" alt="침대 옆 크리스마스" /></a></li>
							<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21382" ELSE response.write "56923" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_table.jpg" alt="크리스마스 디너 테이블" /></a></li>
							<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21383" ELSE response.write "56925" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_village.jpg" alt="크리스마스 키즈룸" /></a></li>
						</ul>
					</div>
		
					<div class="etc">
						<ul>
							<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21385" ELSE response.write "56927" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_message.gif" alt="크리스마스 카드 보내고 선물받기 참여" /></a></li>
							<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56928" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_benefit.gif" alt="텐바이텐이 준비한 크리스마스 혜택" /></a></li>
						</ul>
					</div>
		
					<!-- EVENT & ISSUE -->
					<div class="inner5">
						<div class="evtnIsu box1">
							<h2><span>EVENT &amp; ISSUE</span></h2>
							<ul class="list01">
								<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=57001'); return false;">크리스마스 데코 쉽고 간단해요!</a></li>
								<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=56874'); return false;">3가지 크리스마스 스타일을 만나보세요</a></li>
								<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=57066'); return false;">1만원으로 끝내는 크리스마스 준비</a></li>
							</ul>
						</div>
					</div>
					<!--// EVENT & ISSUE -->
		
				</div>
				<!--// CHRISTMAS MAIN -->

			</div>
			<!--// 이벤트 배너 등록 영역 -->
			<div class="mask"></div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->