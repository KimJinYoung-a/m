<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 고마운건 꼭 선물로 표현할게!
' History : 2015-02-23 원승현
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum, eLinkCode, prveCode, prvCount, prvTotalcount
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21477"
		eLinkCode = "21478"
		prveCode = "21450"
	Else
		eCode = "59601"
		eLinkCode = "59602"
		prveCode = "58923"
	End If

	If vUserID = "" Then
		response.write "<script language='javascript'>top.location.href = '/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D59602';</script>"
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

	'//12월 구매 내역 체킹 (해당 이벤트 페이지뷰는 12월 구매내역이 있는자만)
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2014-12-01', '2015-01-01', '10x10', '', 'issue' "
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr,dbget,1
		prvTotalcount = rsget("cnt")
	rsget.Close

	'//2월 구매 내역 체킹 (응모는 2월 구매고객만 가능)
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-02-01', '2015-03-01', '10x10', '', 'issue' "
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr,dbget,1
		vTotalCount = rsget("cnt")
		vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
	rsget.Close

	'// 기존 이벤트에 응모 하였는지 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '"&prveCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		prvCount = rsget(0)
	End IF
	rsget.close


	If prvTotalcount < 1 Then 
		response.write "<script>alert('이벤트 대상자가 아닙니다.');parent.top.location.href='/shoppingtoday/shoppingchance_allevent.asp';</script>"
		response.End
	End If
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title></title>
<style type="text/css">
img {vertical-align:top;}
.buyHistory .welcome {position:relative;}
.buyHistory .welcome dd {position:absolute; left:13%; top:30%; width:74%; height:56%; }
.buyHistory .welcome ul {position:absolute; right:0; top:0; width:62%; height:50%;  padding-top:3%; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.buyHistory .welcome li {padding-top:4%;}
.buyHistory .welcome li:after {content:' '; display:block; clear:both;}
.buyHistory .welcome li span {vertical-align:top;}
.buyHistory .welcome li img {vertical-align:top;}
.buyHistory .welcome li strong {display:inline-block; min-width:10px; height:10px; text-align:right; font-size:12px; line-height:13px; vertical-align:top; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/ico_star.gif) right top no-repeat; background-size:150px auto;}
.buyHistory .welcome li strong em {color:#e33840; padding-left:10px; background:#fff;}
.buyHistory .welcome li .ftLt img {width:46px;}
.buyHistory .welcome li .ftRt img {width:9px; margin-left:5px;}
.buyHistory .welcome .confirm {display:block; position:absolute; left:0; bottom:0; width:100%;}
.giftBox {position:relative;}
.giftBox li {position:absolute; top:0; height:70%;}
.giftBox li:nth-child(1) {left:0; width:39%;}
.giftBox li:nth-child(2) {right:0; width:61%;}
.giftBox li span {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.giftBox li strong {position:absolute; top:0; left:15%; width:35%;}
.apply {padding:7% 0 8%; background:#fdedc9 url(http://webimage.10x10.co.kr/eventIMG/2015/59602/bg_shadow.png) no-repeat 0 0; background-size:100% auto; text-align:center;}
.apply button {width:289px; height:53px; background:#d60000 url(http://webimage.10x10.co.kr/eventIMG/2015/58924/btn_apply.gif) no-repeat 0 0; background-size:100% auto; text-indent:-999em;}
.evtNoti {padding:25px 15px 30px; font-size:12px; background:#fff;}
.evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.evtNoti li {position:relative; color:#000; font-size:11px; line-height:1.3; padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/blt_arrow.gif) 0 4px no-repeat; background-size:3px auto;}

@media all and (min-width:480px){
	.buyHistory .welcome li {padding-top:6%;}
	.buyHistory .welcome li strong {min-width:15px; height:15px; font-size:18px; line-height:20px; background-size:230px auto;}
	.buyHistory .welcome li strong em {padding-left:15px;}
	.buyHistory .welcome li .ftLt img {width:69px;}
	.buyHistory .welcome li .ftRt img {width:14px; margin-left:7px;}
	.apply button {width:434px; height:80px;}
	.evtNoti {padding:38px 23px 45px; font-size:18px;}
	.evtNoti dt {margin-bottom:20px; font-size:21px;}
	.evtNoti li {background-position:0 7px; background-size:6px auto; padding-left:17px; font-size:17px;}
}
</style>
<script>
$(function(){
	$("#mo").hide();
	$("#app").hide();
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('#mo').show();
	}else{
		$('#app').show();
	}
});

function jsSubmitComment(){
	var frm = document.frmGubun2;

	<% If vUserID = "" Then %>
	jsChklogin('<%=IsUserLoginOK%>');
	return;
	<% End If %>

	<% If Now() > #02/28/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #02/24/2015 00:00:00# Then %>
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
					frm.action = "doEventSubscript59602.asp";
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
		url: "/event/etc/doEventSubscript59602.asp",
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
<div class="evtCont">
	<%' 고마운건 선물로 표현할게(M/A) %>
	<div class="mEvt59602">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/59602/tit_thanks_gift.png" alt ="고마운건 선물로 표현할게!" /></h1>
		<%' 구매내역 확인 %>
		<div class="buyHistory">
			<dl class="welcome">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/59602/txt_history.png" alt ="2월 고객님의 구매내역을 확인하세요!" /></dt>
				<dd>
					<ul>
						<li>
							<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_count.gif" alt ="구매횟수" /></span>
							<span class="ftRt"><strong><%' for dev msg : 확인하기 클릭하면 노출%><em id="totcnt" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_num.gif" alt ="회" /></span>
						</li>
						<li>
							<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_price.gif" alt ="구매금액" /></span>
							<span class="ftRt"><strong><%' for dev msg : 확인하기 클릭하면 노출%><em id="totsum" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_won.gif" alt ="원" /></span>
						</li>
					</ul>
					<p><input type="image" class="confirm" src="http://webimage.10x10.co.kr/eventIMG/2015/58924/btn_confirm.gif" alt="확인하기" onclick="chkmyorder();return false;" /></p>
				</dd>
			</dl>
			<div class="present"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59602/txt_present.png" alt ="2월의 PRESENT 확인하고 응모하세요! 구매내역이 있으시면 선물을 확인하고, 하단의 응모하기를 누르세요! 3월 11일 당첨자가 발표됩니다!" /></div>
		</div>
		<%'// 구매내역 확인 %>
		<div class="giftBox">
			<ul>
				<li>
					<span>1월의 선물</span>
					<%' for dev msg :1월에 응모했으면 보여주세요! %>
					<% If prvCount > 0 Then %>
						<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59602/ico_end.png" alt ="응모완료" /></strong>
					<% End If %>
				</li>
				<li><span>2월의 선물</span></li>
			</ul>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59602/tab_present.png" alt ="" /></div>
		</div>

		<div class="pic">
			<a href="/category/category_itemPrd.asp?itemid=1013735" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59602/img_item.jpg" alt="분리하여 사용 가능한 테일윈드 메모지와 북마크 뉴욕, 런던, 파리 중에 랜덤으로 발송됩니다." /></a>
		</div>
		<%' 응모하기 %>
		<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
		<input type="hidden" name="mode" value="add"  />
		<div class="apply">
			<button type="button" onClick="jsSubmitComment(); return false;">응모하기</button>
		</div>
		</form>
		<%'// 응모하기 %>
		<dl class="evtNoti">
			<dt>이벤트 유의사항</dt>
			<dd>
				<ul>
					<li>이벤트는 이메일또는 SMS로 이벤트 안내를 받으신 회원님만을 위한 헤택입니다.</li>
					<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
					<li>2월 구매내역이 있어야 응모하기가 가능합니다.</li>
					<li>3월 11일 당첨자가 발표되며, 발표 이후 사은품이 배송됩니다.</li>
					<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
					<li>이벤트는 조기 종료 될 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<%'// 고마운건 선물로 표현할게(M/A) %>
	<div id="tempdiv"></div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->