<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum, vLinkCode
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID
	
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21366"
		vLinkCode = "21368"
	Else
		eCode = "56809"
		vLinkCode = "56810"
	End If
	
	If vUserID = "" Then
		response.write "<script language='javascript'>top.location.href = '/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D" & vLinkCode & "';</script>"
		dbget.close()
	    response.end
	End If


	
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2014-11-01', '2014-12-01', '10x10', '', 'issue' "
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
.mEvt56810 img {vertical-align:top;}
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
.section3 .tab-nav {overflow:hidden; margin-bottom:5%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/56810/bg_tab.gif) no-repeat 0 0; background-size:100% auto;}
.section3 .tab-nav li {float:left; padding:5% 0 9%; text-align:center; text-indent:-999em;}
.section3 .tab-nav li:nth-child(1) {width:61%;}
.section3 .tab-nav li:nth-child(2) {width:39%; cursor:pointer;}
.btn-enter {display:block; position:relative; width:200px; height:53px; margin:7% auto 0; color:#fff;}
.btn-enter span {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:#ff7353 url(http://webimage.10x10.co.kr/eventIMG/2014/56810/btn_enter.gif) no-repeat 50% 0; background-size:200px 53px;}
.section4 {padding:10% 0 8%; border-bottom:5px solid #858078; background-color:#aca59b;}
.section4 ul {margin-top:20px; padding:0 5%;}
.section4 ul li {margin-top:6px; padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/56810/blt_arrow.gif) no-repeat 0 3px; background-size:3px 4px; color:#fff; font-size:12px; line-height:1.25em;}
@media all and (min-width:480px){
	.section2 ol li.step2 .check strong:first-child {font-size:18px;}
	.section2 ol li.step2 .check span, .section2 ol li.step2 .check em {font-size:18px;}
	.btn-enter {width:300px; height:79px;}
	.btn-enter span {background-size:300px 79px;}
	.section4 ul li {margin-top:9px; padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/56810/blt_arrow.gif) no-repeat 0 5px; background-size:6px 8px; font-size:17px;}
}
.animated {-webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* FadeIn animation */
@-webkit-keyframes fadeIn {
	0% {opacity:0.5;}
	50% {opacity:0.7;}
	100% {opacity:1;}
}
@keyframes fadeIn {
	0% {opacity:0.5;}
	50% {opacity:0.7;}
	100% {opacity:1;}
}
.fadeIn {-webkit-animation-name: fadeIn; animation-name: fadeIn; -webkit-animation-iteration-count:3; animation-iteration-count:3;}
</style>
<script type="text/javascript">
$(function(){

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

	<% If vUserID <> "" Then %>
		<% If vTotalCount > 0 Then %>
		   frm.action = "doEventSubscript56809.asp";
		   frm.submit();
		<% Else %>
			alert("11월 구매내역이 없습니다.\n구매 후, 다시 응모하러 와주세요!");
			return;
		<% End If %>
	<% End If %>

}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt56810">
		<div class="fall-present">
			<div class="section section1">
				<p class="continue animated fadeIn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/txt_to_be_continue.png" alt ="13주년 뒷풀이는 계속된다!" /></p>
				<h1><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/tit_fall_present.gif" alt ="어느 가을날로부터의 선물 Ver.1" /></h1>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/txt_event.gif" alt ="텐바이텐 생일을 함께 해주신 고객님을 다시 찾아왔어요! 11월의 선물을 확인하고, 12월을 기다려주세요. 11월, 12월 모두 응모하신 분들 중 200분을 추첨해 2015년 첫번째 시크릿박스를 보내드립니다! 이벤트 기간은 2014년 11월 26일부터 11월 30일까지입니다." /></p>
			</div>

			<div class="section section2">
				<ol>
					<li class="step1"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/txt_start.gif" alt ="담아보자! START" /></li>
					<li class="step2">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/txt_one_more.gif" alt ="한번 더 텐텐을 찾아주세요" /></p>
						<!-- for dev msg : 11월 구매내역 -->
						<div class="check">
							<strong>11월 구매내역</strong>
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
					<li class="step3"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/txt_november_present.gif" alt ="11월의 present 확인! 선물을 확인하고, 하단의 응모버튼을 누르세요" /></li>
					<li class="step4"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/txt_december_present.gif" alt ="12월의 선물도 곧 찾아옵니다!" /></li>
				</ol>
			</div>

			<div class="section section3">
				<ul class="tab-nav">
					<li class="november">11월의 선물</li>
					<li class="december" onClick="alert('12월의 선물은 곧 찾아옵니다! Coming soon!');">12월의 선물 커밍순</li>
				</ul>
				<p>
					<a href="/category/category_itemPrd.asp?itemid=1154196" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/txt_present_lantern.jpg" alt ="따뜻한 겨울 소품, 틴 머그 캔들 홀더! 귀여운 문양의 랜턴으로 겨울을 따뜻하고 사랑스럽게 보내볼까요! 2가지 색상 중 한 가지 색으로 랜덤 발송 됩니다." /></a>
					<a href="" onclick="fnAPPpopupProduct('1154196'); return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/txt_present_lantern.jpg" alt ="따뜻한 겨울 소품, 틴 머그 캔들 홀더! 귀여운 문양의 랜턴으로 겨울을 따뜻하고 사랑스럽게 보내볼까요! 2가지 색상 중 한 가지 색으로 랜덤 발송 됩니다." /></a>
				</p>
				<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
				<button type="button" class="btn-enter" onClick="jsSubmitComment(); return false;"><span></span>응모하기</button>
				</form>
			</div>

			<div class="section section4">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/56810/tit_noti.gif" alt ="이벤트 유의사항" /></h2>
			<ul>
				<li>이벤트는 이메일또는 SMS로 이벤트 안내를 받으신 회원님만을 위한 헤택입니다.</li>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
				<li>11월 구매내역이 있어야 응모하기가 가능합니다.</li>
				<li>구매내역은 11월1일00시~현재까지의 입금완료 기준입니다.</li>
				<li>12월 이벤트까지 응모가 완료되면 당첨자가 발표 됩니다.</li>
				<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
			</ul>
		</div>

		</div>

	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->