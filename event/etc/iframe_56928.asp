<%@ language=vbscript %>
<% option Explicit %>
<%
'####################################################
' Description :  [2014 크리스마스] NORDIC CHRISTMAS [혜택] 
' History : 2014.11.27 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event56928Cls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim subscriptcount, orderdetailcount56913, eCode, userid
	subscriptcount=0
	orderdetailcount56913=0
	eCode=getevt_code
	userid = getloginuserid()


If IsUserLoginOK() Then
	orderdetailcount56913 = get10x10onlineorderdetailcount56913(userid, "2014-12-01", "2014-12-23", "N", "Y")
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

%>
<style type="text/css">
.xmasBenefit li {position:relative;}
.xmasBenefit li a {display:block; position:absolute; left:20%; width:60%; z-index:50;}
.xmasBenefit li.bf01 a {bottom:17%;}
.xmasBenefit li.bf02 a {bottom:18%;}
.xmasBenefit li.bf03 a {bottom:12%;}
</style>
<script type="text/javascript">
function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #12/23/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-12-01" and getnowdate<="2014-12-23" Then %>
				<% if orderdetailcount56913 < 1 then %>
					alert("크리스마스 기획전 상품을 구입하셔야 응모가능합니다.");
					return;
				<% Else %>
					<% if subscriptcount < 1 then %>
						frm.mode.value="ordereg";
						frm.action="/event/etc/doEventSubscript56928.asp";
						frm.target="evtFrmProc";
						frm.submit();
						return;
					<% else %>
						alert("응모는 한번만 가능 합니다.");
						return;
					<% end if %>
				<% End if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin('<%=IsUserLoginOK%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<% if isApp=1 then %>
	<div class="evtCont">
		<div class="xmasBenefit">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/tit_christmas_present.gif" alt="CHRISTMAS PRESENT - 텐바이텐이 준비한 크리스마스 혜택" /></h2>
			<ol>
				<li class="bf01">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_benefit01.gif" alt="01. 4가지 북유럽 공간에 숨겨진 선물상자를 찾아보세요" /></p>
					<a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21380" ELSE response.write "56921" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_benefit01.gif" alt="선물상자 찾으러가기" /></a>
				</li>
				<li class="bf02">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_benefit02.gif" alt="02. 크리스마스 카드 쓰고 부산으로 새해 일출 여행가자!" /></p>
					<a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21385" ELSE response.write "56927" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_benefit02.gif" alt="크리스마스 카드 쓰러 가기" /></a>
				</li>
				<li class="bf03">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_benefit03.gif" alt="03. 여러분의 소중한 크리스마스를 텐바이텐과 함께하셨나요?" /></p>
					<a href="" onclick="jsSubmitComment(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_benefit03.gif" alt="응모하기" /></a>
				</li>
				<li class="bf04"><p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_benefit04.gif" alt="텐바이텐과 함께하는 12월의 카드 혜택" /></p></li>
			</ol>
		</div>
	</div>
<% else %>
	<div class="evtCont">
		<div class="xmasBenefit">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/tit_christmas_present.gif" alt="CHRISTMAS PRESENT - 텐바이텐이 준비한 크리스마스 혜택" /></h2>
			<ol>
				<li class="bf01">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_benefit01.gif" alt="01. 4가지 북유럽 공간에 숨겨진 선물상자를 찾아보세요" /></p>
					<a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21380" ELSE response.write "56921" %>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_benefit01.gif" alt="선물상자 찾으러가기" /></a>
				</li>
				<li class="bf02">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_benefit02.gif" alt="02. 크리스마스 카드 쓰고 부산으로 새해 일출 여행가자!" /></p>
					<a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21385" ELSE response.write "56927" %>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_benefit02.gif" alt="크리스마스 카드 쓰러 가기" /></a>
				</li>
				<li class="bf03">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_benefit03.gif" alt="03. 여러분의 소중한 크리스마스를 텐바이텐과 함께하셨나요?" /></p>
					<a href="" onclick="jsSubmitComment(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_benefit03.gif" alt="응모하기" /></a>
				</li>
				<li class="bf04"><p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_benefit04.gif" alt="텐바이텐과 함께하는 12월의 카드 혜택" /></p></li>
			</ol>
		</div>
	</div>
<% end if %>
<!--// 이벤트 배너 등록 영역 -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<form name="evtFrm1" action="/event/etc/doEventSubscript56928.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->