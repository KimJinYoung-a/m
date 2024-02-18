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
' History : 2015.01.19 유태욱 생성
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
<!-- #include virtual="/apps/appCom/wish/web2014/event/etc/event58695Cls.asp" -->

<%
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode, prevEventJoinChk, EventJoinChk, usrSelectItemid, preveCode, sqlStr, EventTotalChk
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	EventTotalChk = 0
	EventJoinChk = 0

	eCode = getevt_code()

	sqlStr = ""
	sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
	sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' and sub_opt1='"&getnowdate&"' "
	rsget.Open sqlStr, dbget, 1
		EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여갯수 하루에 500명
	rsget.Close

	EventTotalChk = 5000-EventTotalChk

	If IsUserLoginOK Then
		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' "
		rsget.Open sqlStr, dbget, 1
			EventJoinChk = rsget(0) '// 현재 이벤트 참여여부 1인 1번응모가능
		rsget.Close
	Else
		'// 회원가입이 안되어 있음 쿠키 굽는다.(추후 가입완료시 이벤트 페이지 이동을 위해)
		response.cookies("etc").domain="10x10.co.kr"
		response.cookies("etc")("evtcode") = 58695
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
.mEvt58695 {position:relative;}
.mEvt58695 img {vertical-align:top;}
.mEvt58695 .evtNoti {padding:27px 14px; background:#fff;}
.mEvt58695 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt58695 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.mEvt58695 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}
.mEvt58695 .avengerCard {position:relative;}
.mEvt58695 .cardList {padding:0 3% 0 7%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/58695/bg_card_area.gif) left top no-repeat #4bcdd2; background-size:100% auto;}
.mEvt58695 .cardList .soldOut {position:absolute; left:0; top:43.2%; z-index:60;}
.mEvt58695 .cardList ul {overflow:hidden;}
.mEvt58695 .cardList li {float:left; width:50%;}
.mEvt58695 .cardLayer {display:none; position:absolute; left:0; top:28%; z-index:50; width:100%;}
.mEvt58695 .cardLayer .hero {padding-top:5%;}
.mEvt58695 .cardLayer .hero p {display:none;}
.mEvt58695 .cardLayer .viewResult {position:relative;}
.mEvt58695 .cardLayer .getMg {display:block; position:absolute; left:23%; bottom:7%; width:54%; height:11%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.mEvt58695 .mask {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5); z-index:40;}

@media all and (min-width:480px){
	.mEvt58695 .evtNoti {padding:40px 21px;}
	.mEvt58695 .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt58695 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt58695 .evtNoti li:after {top:6px; border-width:5px 0 5px 7px;}
}
</style>
<script type="text/javascript">
$(function(){
//	$(".cardList li a").click(function(){
//		var selectHero = $(this).attr('class');
//		$(".cardLayer").show();
//		$('.hero p').hide();
//		$('.hero p.'+selectHero).show();
//		$(".mask").show();
//	});
	$(".mask").click(function(){
		$(".cardLayer").hide();
		$(".mask").hide();
	});
});

function jsSubmitComment(str){
	var frm = document.frmcom;

	<% If vUserID = "" Then %>
		calllogin();
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
			url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript58695.asp",
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
					//var selectHero = $(this).attr('class');
					$(".cardLayer").show();
					$('.hero p').hide();
					$('.hero p.'+str).show();
					$(".mask").show();
				}
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	<% End If %>
}

function jsSubmitmileage(){
	alert('마일리지 지급완료!\n\n현금처럼 사용 가능한 텐텐 마일리지!\n오늘 안에 꼭 사용하세요!');
	parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>';
}
</script>
</head>
<body>
	<div class="evtCont">
		<!-- 어벤져카드 뽑기(APP) -->
		<div class="mEvt58695">
			<div class="avengerCard">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/tit_avenger_card.gif" alt="어벤져카드 뽑기" /></h2>
				<div class="cardList" id="cardList">
					<%' 품절 %>
					<% if EventTotalChk < 1 then %>
						<p class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/txt_soldout.png" alt="히어로 카드가 모두 소진됐습니다!" /></p>
					<% end if %>
					<ul>
						<li><a href="#cardLayer" onclick="jsSubmitComment('h01');return false;" class="h01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/img_card01.gif" alt="헐쿠" /></a></li>
						<li><a href="#cardLayer" onclick="jsSubmitComment('h02');return false;" class="h02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/img_card02.gif" alt="또르르" /></a></li>
						<li><a href="#cardLayer" onclick="jsSubmitComment('h03');return false;" class="h03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/img_card03.gif" alt="나이롱맨" /></a></li>
						<li><a href="#cardLayer" onclick="jsSubmitComment('h04');return false;" class="h04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/img_card04.gif" alt="캡틴" /></a></li>
					</ul>
				</div>
				<%' 레이어팝업(마일리지받기) %>
				<div class="cardLayer" id="cardLayer">
					<div class="layerCont">
						<div class="hero">
							<p class="h01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/img_win01.png" alt="헐쿠" /></p>
							<p class="h02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/img_win02.png" alt="또르르" /></p>
							<p class="h03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/img_win03.png" alt="나이롱맨" /></p>
							<p class="h04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/img_win04.png" alt="캡틴" /></p>
						</div>
						<a href="" onclick="jsSubmitmileage(); return false;" class="getMg">마일리지 받기</a>
					</div>
				</div>
				<div class="mask"></div>
			</div>
			<% if EventJoinChk <> "0" then %>
				<% ' 응모 후 %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/txt_mileage.gif" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다. 일반쿠폰과 차원이 다른 헤택을 경험하세요!" /></p>
			<% else %>
				<% ' 응모 전  %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58695/txt_caution.gif" alt="CAUTION!  본 이벤트는 나가면, 다시 돌아 올 수 없습니다." /></p>
			<% end if %>
			<dl class="evtNoti">
				<dt>이벤트 유의사항</dt>
				<dd>
					<ul>
						<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
						<li>본 이벤트는 신규 앱 설치한 고객을 대상으로 한 시크릿 이벤트입니다.</li>
						<li>ID 당 1회만 참여할 수 있습니다. 당일 자정 기준으로 자동 소멸합니다.</li>
						<li>지급된 마일리지는 3만원 이상 구매 시 현금처럼 사용 가능합니다.</li>
						<li>사용하지 않은 마일리지는 사전 통보 없이 자동 소멸합니다.</li>
					</ul>
				</dd>
			</dl>
		</div>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->