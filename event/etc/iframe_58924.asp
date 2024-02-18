<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [연속구매] 고마운 건 꼭 선물로 표현할게! var.1
' History : 2015-01-26 이종화
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21450"
	Else
		eCode = "58923"
	End If

	If vUserID = "" Then
		response.write "<script language='javascript'>top.location.href = '/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D58924';</script>"
		dbget.close()
	    response.end
	End If

Dim vQuery, vCount
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close

	'//12월 구매 내역 체킹 (1차 응모 대상자 인지 아닌지)
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
.mEvt58924 img {vertical-align:top;}
.mEvt58924 .evtNoti {padding:25px 15px 30px; font-size:12px; background:#fff;}
.mEvt58924 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt58924 .evtNoti li {position:relative; color:#000; font-size:11px; line-height:1.3; padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/blt_arrow.gif) left 4px no-repeat; background-size:3px auto;}
.buyHistory .welcome {position:relative;}
.buyHistory .welcome dd {position:absolute; left:13%; top:30%; width:74%; height:56%; }
.buyHistory .welcome ul {position:absolute; right:0; top:0; width:62%; height:50%;  padding-top:3%; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.buyHistory .welcome li {overflow:hidden; padding-top:4%;}
.buyHistory .welcome li span {vertical-align:top;}
.buyHistory .welcome li img {vertical-align:top;}
.buyHistory .welcome li strong {display:inline-block; min-width:10px; height:10px; text-align:right; font-size:12px; line-height:13px; vertical-align:top; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/ico_star.gif) right top no-repeat; background-size:150px auto;}
.buyHistory .welcome li strong em {color:#e33840; padding-left:10px; background:#fff;}
.buyHistory .welcome li .ftLt img {width:46px;}
.buyHistory .welcome li .ftRt img {width:9px; margin-left:5px;}
.buyHistory .welcome .confirm {display:block; position:absolute; left:0; bottom:0; width:100%;}
.giftBox {position:relative;}
.giftBox li {position:absolute; top:0; height:70%;}
.giftBox li:nth-child(1) {left:0; width:61%;}
.giftBox li:nth-child(2) {right:0; width:39%;}
.giftBox li span {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.pic a {display:none;}
.apply {padding:25px 15px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/bg_shadow.gif) left top no-repeat #c4ebe1; background-size:100% auto; text-align:center;}
.apply input {width:100%;}

@media all and (min-width:480px){
	.mEvt58924 .evtNoti {padding:38px 23px 45px; font-size:18px;}
	.mEvt58924 .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt58924 .evtNoti li {font-size:17px; padding-left:17px;}
	.buyHistory .welcome li {padding-top:6%;}
	.buyHistory .welcome li strong {min-width:15px; height:15px; font-size:18px; line-height:20px; background-size:230px auto;}
	.buyHistory .welcome li strong em {padding-left:15px;}
	.buyHistory .welcome li .ftLt img {width:69px;}
	.buyHistory .welcome li .ftRt img {width:14px; margin-left:7px;}
	.apply {padding:38px 23px;}
}
</style>
<script>
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsSubmitComment(){
	var frm = document.frmGubun2;

	<% If vUserID = "" Then %>
	jsChklogin('<%=IsUserLoginOK%>');
	return;
	<% End If %>

	<% If Now() > #01/31/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #01/26/2015 00:00:00# Then %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% else %>
		<% If vUserID <> "" Then %>
			<% if vTotalCount > 0 and vTotalSum > 0 then %>
				<% if vCount = 0 then %>
				var totcnt , totsum
				totcnt = $("#totcnt").text();
				totsum = $("#totsum").text();

				if (totcnt == "0" && totcnt == "0" ){
					alert('먼저 구매 내역 확인버튼을 눌러주세요');
					return;
				}else{
					frm.action = "doEventSubscript58924.asp";
					frm.submit();
				}
				<% else %>
				alert("이미 응모 하셨습니다.");
				return;
				<% End If %>
			<% else %>
				alert("응모 대상자가 아닙니다.");
				return;
			<% End If %>
		<% End If %>
	<% End if %>
}

function chkmyorder(){
	var rstStr = $.ajax({
		type: "POST",
		url: "/event/etc/doEventSubscript58924.asp",
		data: "mode=myorder",
		dataType: "text",
		async: false
	}).responseText;
		$("#tempdiv").empty().append(rstStr);
		$("#totcnt").css("display","block");
		$("#totsum").css("display","block");
		$("#totcnt").text($("div#tcnt").text());
		$("#totsum").text($("div#tsum").text());
}
</script>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont">
	<!-- 고마운건 선물로 표현할게(M/A) -->
	<div class="mEvt58924">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/tit_thanks_gift.gif" alt ="고마운건 선물로 표현할게!" /></h2>
		<!-- 구매내역 확인 -->
		<div class="buyHistory">
			<dl class="welcome">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_history.gif" alt ="1월 고객님의 구매내역을 확인하세요!" /></dt>
				<dd>
					<ul>
						<li>
							<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_count.gif" alt ="구매횟수" /></span>
							<span class="ftRt"><strong><em id="totcnt" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_num.gif" alt ="회" /></span>
						</li>
						<li>
							<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_price.gif" alt ="구매금액" /></span>
							<span class="ftRt"><strong><em id="totsum" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_won.gif" alt ="원" /></span>
						</li>
					</ul>
					<p><input type="image" class="confirm" src="http://webimage.10x10.co.kr/eventIMG/2015/58924/btn_confirm.gif" alt="확인하기" onclick="chkmyorder();return false;"/></p>
				</dd>
			</dl>
			<div class="present"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_present.gif" alt ="1월의 PRESENT 확인하고 응모하세요!" /></div>
		</div>
		<!--// 구매내역 확인 -->
		<div class="giftBox">
			<ul>
				<li><span>1월의 선물</span></li>
				<li><span>2월의 선물 COMING SOON</span></li>
			</ul>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/tab_present.gif" alt ="" /></div>
		</div>

		<div class="pic">
			<a href="/category/category_itemPrd.asp?itemid=763507" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/img_coaster.jpg" alt="이거 하나로 캘리포니아 빈티지펍 느낌 좀 내보려고해" /></a>
			<a href="#" onclick="fnAPPpopupProduct('763507'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/img_coaster.jpg" alt="이거 하나로 캘리포니아 빈티지펍 느낌 좀 내보려고해" /></a>
		</div>
		<!-- 응모하기 -->
		<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
		<input type="hidden" name="mode" value="add" />
		<p class="apply"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/58924/btn_apply.gif" alt="응모하기" onClick="jsSubmitComment(); return false;"/></p>
		</form>
		<!--// 응모하기 -->
		<dl class="evtNoti">
			<dt>이벤트 유의사항</dt>
			<dd>
				<ul>
					<li>이벤트는 이메일또는 SMS로 이벤트 안내를 받으신 회원님만을 위한 헤택입니다.</li>
					<li>응모하기는 이벤트 기간 중 1회만 가능합니다. </li>
					<li>1월 구매내역이 있어야 응모하기가 가능합니다.</li>
					<li>2월 이벤트까지 응모가 완료되면, 3월 11일 당첨자가 발표되며, 사은품도 3월에 함께 배송됩니다.</li>
					<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
					<li>이벤트는 조기 종료 될 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<!--// 고마운건 선물로 표현할게(M/A) -->
	<div id="tempdiv"></div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
<!--// 이벤트 배너 등록 영역 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->