<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  어느 가을날로부터의 선물 ver.2 
' History : 2014.12.18 유태욱
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
dim eCode, eCode11, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum, vLinkCode
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode11 = "21366"
	Else
		eCode11 = "56809"
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21413"
		vLinkCode = "21368"
	Else
		eCode = "57876"
		vLinkCode = "57877"
	End If

	If vUserID = "" Then
		response.write "<script language='javascript'>top.location.href = '/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D" & vLinkCode & "';</script>"
		dbget.close()
	    response.end
	End If

Dim vQuery, vCount56809
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode11 & "' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vCount56809 = rsget(0)
	End IF
	rsget.close
	
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2014-12-01', '2015-01-01', '10x10', '', 'issue' "
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr,dbget,1
		vTotalCount = rsget("cnt")
		vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
	rsget.Close
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title></title>
<style type="text/css">
img {vertical-align:top;}
.fall-present {}
.section1 {position:relative;}
.section1 .continue {position:absolute; top:9.8%; left:0; width:100%;}
.section2 ol li.step2 {position:relative;}
.section2 ol li.step2 .check {position:absolute; top:10%; left:36%; width:52%;}
.section2 ol li.step2 .check strong:first-child {color:#222; font-size:12px; line-height:1.25em;}
.section2 ol li.step2 .check span, .section2 ol li.step2 .check em {float:left; color:#666; font-size:12px; font-weight:bold; line-height:1.25em;}
.section2 ol li.step2 .check span {width:30%;}
.section2 ol li.step2 .check em {width:70%; text-align:right;}
.section2 ol li.step2 .check em strong {color:#555; font-weight:bold; line-height:1.25em;}
.section2 ol li.step2 .count {overflow:hidden; margin-top:3%; padding-top:3%; border-top:1px solid #ededed;}
.section2 ol li.step2 .price {overflow:hidden; margin-top:2%;}
.section3 {padding-bottom:7%; background-color:#fff;}
.section3 .tab-nav {margin-bottom:5%;}
.section3 .tab-nav:after {display:block; content:' '; clear:both;}
.section3 .tab-bg1 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57877/bg_tab_01.gif) no-repeat 0 0; background-size:100% auto;}
.section3 .tab-bg2 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57877/bg_tab_02.gif) no-repeat 0 0; background-size:100% auto;}
.section3 .tab-nav li {float:left; position:relative; width:50%;}
.section3 .tab-nav li a {display:block; padding:10% 0; text-align:center; text-indent:-999em;}
.section3 .tab-nav li .end {position:absolute; top:6%; left:5%; width:25%;}
.btn-enter {display:block; position:relative; width:200px; height:53px; margin:7% auto 0; color:#fff;}
.btn-enter span {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:#ff7353 url(http://webimage.10x10.co.kr/eventIMG/2014/57877/btn_enter.gif) no-repeat 50% 0; background-size:200px 53px;}
.section4 {padding:10% 0 8%; border-bottom:5px solid #858078; background-color:#aca59b;}
.section4 ul {margin-top:20px; padding:0 5%;}
.section4 ul li {margin-top:6px; padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57877/blt_arrow.gif) no-repeat 0 3px; background-size:3px 4px; color:#fff; font-size:12px; line-height:1.25em;}
@media all and (min-width:480px){
	.section2 ol li.step2 .check strong:first-child {font-size:18px;}
	.section2 ol li.step2 .check span, .section2 ol li.step2 .check em {font-size:18px;}
	.btn-enter {width:300px; height:79px;}
	.btn-enter span {background-size:300px 79px;}
	.section4 ul li {margin-top:9px; padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57877/blt_arrow.gif) no-repeat 0 5px; background-size:6px 8px; font-size:17px;}
}
</style>
<script type="text/javascript">
$(function(){
	/* tab */
	$(".tab-nav").addClass("tab-bg2");
	$(".tab-content").find(".section").hide();
	$(".tab-content").find(".section:last").show();
	
	$(".tab-nav li.november a").click(function(){
		$(".tab-nav").removeClass("tab-bg2");
		$(this).parent().parent().addClass("tab-bg1");
		var thisCont = $(this).attr("href");
		$(".tab-content").find(".section").hide();
		$(".tab-content").find(thisCont).show();
		return false;
	});

	$(".tab-nav li.december a").click(function(){
		$(".tab-nav").removeClass("tab-bg1");
		$(this).parent().parent().addClass("tab-bg2");
		var thisCont = $(this).attr("href");
		$(".tab-content").find(".section").hide();
		$(".tab-content").find(thisCont).show();
		return false;
	});

	/* app link */
	$(".fall-present a.app").hide();
	$(".fall-present a.mo").hide();
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".fall-present a.app").show();
	}else{
		$(".fall-present a.mo").show();
	}
});

function jsSubmitComment(){
	var frm = document.frmGubun2;

	<% If vUserID = "" Then %>
	jsChklogin('<%=IsUserLoginOK%>');
	return;
	<% End If %>

	<% If Now() > #12/31/2014 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #12/22/2014 00:00:00# Then %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% else %>
		<% If vUserID <> "" Then %>
			<% If vTotalCount > 0 Then %>
			   frm.action = "doEventSubscript57876.asp";
			   frm.submit();
			<% Else %>
				alert("12월 구매내역이 없습니다.\n구매 후, 다시 응모하러 와주세요!");
				return;
			<% End If %>
		<% End If %>
	<% End if %>
}
</script>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont">

	<div class="mEvt57877">
		<div class="fall-present">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_fall_present.gif" alt ="13주년 뒷풀이! 어느 가을날로부터의 선물 Ver.2" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_event.gif" alt ="텐바이텐 생일을 함께 해주신 고객님을 다시 찾아왔어요! 12월의 두번째 선물을 확인해주세요! 11월에 이어 이번달에도 응모하신 분들 중 200분을 추첨해 2015년 첫번째 시크릿박스를 보내드립니다! 이벤트 기간은 2014년 12월 22일부터 12월 31일까지입니다." /></p>
			</div>

			<div class="section section2">
				<ol>
					<li class="step1"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_start.gif" alt ="담아보자! START" /></li>
					<li class="step2">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_one_more.gif" alt ="한번 더 텐텐을 찾아주세요" /></p>
						<!-- for dev msg : 12월 구매내역 -->
						<div class="check">
							<strong>12월 구매내역</strong>
							<div class="count">
								<span>구매횟수 :</span>
								<em><strong><%= FormatNumber(vTotalCount,0) %></strong> 회</em>
							</div>
							<div class="price">
								<span>구매금액 :</span>
								<em><strong><%= FormatNumber(vTotalSum,0) %></strong> 원</em>
							</div>
						</div>
					</li>
					<li class="step3"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_december_present.gif" alt ="12월의 present 확인! 선물을 확인하고, 하단의 응모버튼을 누르세요" /></li>
					<li class="step4"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_winner.gif" alt ="당첨자 발표는 01월 08일 입니다!" /></li>
				</ol>
			</div>

			<div class="section section3">
				<ul class="tab-nav">
					<li class="november">
						<a href="#november">11월의 선물</a>
						<!-- for dev msg : 11월에 응모 완료시 보여주세요. -->
						<% if vCount56809 > 0 then %>
						<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/ico_end.png" alt ="응모완료" /></strong>
						<% end if %>
					</li>
					<li class="december"><a href="#december">12월의 선물</a></li>
				</ul>
				<div class="tab-content">
					<div id="november" class="section">
						<p>
							<a href="/category/category_itemPrd.asp?itemid=1154196" class="mo" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_present_lantern.jpg" alt ="따뜻한 겨울 소품, 틴 머그 캔들 홀더! 귀여운 문양의 랜턴으로 겨울을 따뜻하고 사랑스럽게 보내볼까요! 2가지 색상 중 한 가지 색으로 랜덤 발송 됩니다." /></a>
							<a href="" onclick="fnAPPpopupProduct('1154196'); return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_present_lantern.jpg" alt ="따뜻한 겨울 소품, 틴 머그 캔들 홀더! 귀여운 문양의 랜턴으로 겨울을 따뜻하고 사랑스럽게 보내볼까요! 2가지 색상 중 한 가지 색으로 랜덤 발송 됩니다." /></a>
						</p>
					</div>
					<div id="december" class="section">
						<p>
							<a href="/category/category_itemPrd.asp?itemid=1182496" class="mo" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_present_candle.jpg" alt ="꽃과 캔들이 만나다, URBAN THEFAPY 의 천연 소이 왁스 캔들 1세트에 6개가 들어있어요. 플라워 타입과 향은 랜덤으로 발송됩니다." /></a>
							<a href="" onclick="fnAPPpopupProduct('1182496'); return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/txt_present_candle.jpg" alt ="꽃과 캔들이 만나다, URBAN THEFAPY 의 천연 소이 왁스 캔들 1세트에 6개가 들어있어요. 플라워 타입과 향은 랜덤으로 발송됩니다" /></a>
						</p>
						<!-- for dev msg : 응모하기 -->
						<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
						<button type="button" class="btn-enter" onClick="jsSubmitComment(); return false;"><span></span>응모하기</button>
						</form>
					</div>
				</div>
			</div>

			<div class="section section4">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57877/tit_noti.gif" alt ="이벤트 유의사항" /></h2>
			<ul>
				<li>이벤트는 이메일또는 SMS로 이벤트 안내를 받으신 회원님만을 위한 헤택입니다.</li>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
				<li>12월 구매내역이 있어야 응모하기가 가능합니다.</li>
				<li>12월 이벤트까지 응모가 완료되면 당첨자가 발표 됩니다.</li>
				<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
<!--// 이벤트 배너 등록 영역 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->