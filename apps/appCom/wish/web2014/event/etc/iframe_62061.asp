<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 어벤져카드뽑기
' History : 2015.05.04 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode, prevEventJoinChk, EventJoinChk, usrSelectItemid, preveCode, sqlStr, EventTotalChk, nowDate
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel

	nowDate = Left(Now(), 10)
'	nowDate = "2015-05-06"


	IF application("Svr_Info") = "Dev" THEN
		eCode = "61774"
	Else
		eCode = "62061"
	End If


	sqlStr = ""
	sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
	sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' and sub_opt1='"&nowDate&"' "
	rsget.Open sqlStr, dbget, 1
		EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여갯수 하루에 7000명
	rsget.Close

	EventTotalChk = 7000-EventTotalChk

	If IsUserLoginOK Then
		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & vUserID & "' "
		rsget.Open sqlStr, dbget, 1
			EventJoinChk = rsget(0) '// 현재 이벤트 참여여부 1인 1번응모가능
		rsget.Close
	Else
		'// 회원가입이 안되어 있음 쿠키 굽는다.(추후 가입완료시 이벤트 페이지 이동을 위해)
		response.cookies("etc").domain="10x10.co.kr"
		response.cookies("etc")("evtcode") = 62061
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
.mEvt62061 {position:relative;}
.mEvt62061 img {vertical-align:top;}
.mEvt62061 .evtNoti {padding:20px 14px; background:#fff;}
.mEvt62061 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt62061 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px; letter-spacing:-0.035em;}
.mEvt62061 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:2px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}
.mEvt62061 .avengerCard {position:relative;}
.mEvt62061 .cardList {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2014/62061/bg_card_area.gif) left top no-repeat #4bcdd2; background-size:100% auto;}
.mEvt62061 .cardList .soldOut {position:absolute; left:0; top:-0.6%; z-index:60;}
.mEvt62061 .cardList ul {overflow:hidden; padding:0 2.5% 5% 6.5%;}
.mEvt62061 .cardList li {float:left; width:50%;}
.mEvt62061 .cardLayer {display:none; position:absolute; left:0; top:28%; z-index:50; width:100%;}
.mEvt62061 .cardLayer .hero {padding-top:5%;}
.mEvt62061 .cardLayer .hero p {display:none;}
.mEvt62061 .cardLayer .viewResult {position:relative;}
.mEvt62061 .cardLayer .getMg {display:block; position:absolute; left:23%; bottom:7%; width:54%; height:11%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.mEvt62061 .mask {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5); z-index:40;}
@media all and (min-width:480px){
	.mEvt62061 .evtNoti {padding:30px 21px;}
	.mEvt62061 .evtNoti dt {font-size:21px; margin-bottom:20px; border-bottom:3px solid #222;}
	.mEvt62061 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt62061 .evtNoti li:after {top:5px; border-width:5px 0 5px 7px;}
}
</style>
<script type="text/javascript">
$(function(){

	<% If EventJoinChk > 0 Then %>

	<% else %>
		$(".cardList li a").click(function(){
			var selectHero = $(this).attr('class');
			$(".cardLayer").show();
			$('.hero p').hide();
			$('.hero p.'+selectHero).show();
			$(".mask").show();
		});
		$(".mask").click(function(){
			$(".cardLayer").hide();
			$(".mask").hide();
		});
	<% end if %>
});

function jsSubmitComment(){
	var frm = document.frmcom;

	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
		}
	<% End If %>

	<% If vUserID <> "" Then %>
		<% if EventJoinChk > 0 then %>
			alert("이미 마일리지를 지급 받으셨습니다.");
			return false;
		<% end if %>

		<% if EventTotalChk < 1 then %>
			alert("오늘의 어벤져카드가 모두 소진되었습니다.");
			return false;
		<% end if %>

		$.ajax({
			url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript62061.asp",
			cache: false,
			success: function(message) {
				if (message=="99")
				{
					alert('잘못된 접속 입니다.');
					return;
				}
				else if (message=="88")
				{
					alert('로그인을 해주세요');
					return;
				}
				else if (message=="77")
				{
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				}
				else if (message=="22")
				{
					alert('주말은 이벤트를 진행하지 않습니다');
					return;
				}
				else if (message=="66")
				{
					alert('오늘의 어벤져카드가 모두 소진되었습니다.');
					return;
				}
				else if (message=="55")
				{
					alert('이벤트 대상자가 아닙니다.');
					return;
				}
				else if (message=="44")
				{
					alert('이미 마일리지를 지급 받으셨습니다.');
					return;
				}
				else if (message=="00")
				{
					alert("마일리지 지급 완료!\n현금처럼 사용 가능한 텐텐 마일리지!\n5월11일까지 꼭 사용하세요!");
					parent.location.reload();
					return;
				}
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	<% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	<% End If %>
}

</script>
</head>
<body>
<div class="evtCont">
	<%' 어벤져카드 뽑기 %>
	<div class="mEvt62061">
		<div class="avengerCard">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/tit_avenger_card_.gif" alt="어벤져카드 뽑기" /></h2>
			<div class="cardList" id="cardList">
				<%'// 품절 시 %>
				<% if EventTotalChk < 1 Or nowDate >= "2015-05-09" then %>
					<% If nowDate >= "2015-05-09" Then %>
						<p class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/txt_soldout02.png" alt="히어로 카드가 모두 소진됐습니다!" /></p> 
					<% Else %>
						<p class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/txt_soldout.png" alt="히어로 카드가 모두 소진됐습니다!" /></p> 
					<% End If %>
				<% End If %>
				<ul>
					<% If EventJoinChk > 0 Then %>
						<li><a href="" onclick="alert('이미 마일리지를 지급 받으셨습니다.');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card01.gif" alt="헐쿠" /></a></li>
						<li><a href="" onclick="alert('이미 마일리지를 지급 받으셨습니다.');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card02.gif" alt="또르르" /></a></li>
						<li><a href="" onclick="alert('이미 마일리지를 지급 받으셨습니다.');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card03.gif" alt="나이롱맨" /></a></li>
						<li><a href="" onclick="alert('이미 마일리지를 지급 받으셨습니다.');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card04.gif" alt="캡틴" /></a></li>
					<% ElseIf not(IsUserLoginOK) Then %>
						<li><a href="" onclick="parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card01.gif" alt="헐쿠" /></a></li>
						<li><a href="" onclick="parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card02.gif" alt="또르르" /></a></li>
						<li><a href="" onclick="parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card03.gif" alt="나이롱맨" /></a></li>
						<li><a href="" onclick="parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card04.gif" alt="캡틴" /></a></li>
					<% Else %>
						<li><a href="#cardLayer" class="h01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card01.gif" alt="헐쿠" /></a></li>
						<li><a href="#cardLayer" class="h02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card02.gif" alt="또르르" /></a></li>
						<li><a href="#cardLayer" class="h03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card03.gif" alt="나이롱맨" /></a></li>
						<li><a href="#cardLayer" class="h04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_card04.gif" alt="캡틴" /></a></li>
					<% End If %>
				</ul>
				<% If isApp="1" Then %>
					<p><a href="" onclick="parent.fnAPPpopupEvent('62117');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/bnr_help_hero.gif" alt="이벤트 배너" /></a></p>
				<% Else %>
					<p><a href="/event/eventmain.asp?eventid=62117" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/bnr_help_hero.gif" alt="이벤트 배너" /></a></p>
				<% End If %>
			</div>
			<%' 레이어팝업(마일리지받기) %>
			<div class="cardLayer" id="cardLayer">
				<div class="layerCont">
					<div class="hero">
						<p class="h01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_win01.png" alt="헐쿠" /></p>
						<p class="h02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_win02.png" alt="또르르" /></p>
						<p class="h03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_win03.png" alt="나이롱맨" /></p>
						<p class="h04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/img_win04.png" alt="캡틴" /></p>
					</div>
					<a href="" onclick="jsSubmitComment();return false;" class="getMg">마일리지 받기</a>
				</div>
			</div>
			<%'// 레이어팝업(마일리지받기) %>
			<div class="mask"></div>
		</div>
		<% If EventJoinChk > 0 Then %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62061/txt_mileage.gif" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다. 일반쿠폰과 차원이 다른 헤택을 경험하세요!" /></p>
		<% End If %>
		<dl class="evtNoti">
			<dt>이벤트 유의사항</dt>
			<dd>
				<ul>
					<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
					<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
					<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
					<li>지급된 마일리지는 3만원 이상 구매 시 현금처럼 사용 가능합니다.</li>
					<li>기간 내에 사용하지 않은 마일리지는 사전 통보 없이 자동 소멸합니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<%'// 어벤져카드 뽑기 %>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->