<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<%
'####################################################
' Description : ## 낮ver. 신데렐라2
' History : 2015-08-10 유태욱 생성
'####################################################
	Dim vUserID, eCode, nowdate
	Dim strSql , totcnt, couponid
	dim totalbonuscouponcount

	vUserID = GetLoginUserID
	nowdate = date()
'	nowdate = "2015-08-12"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64849"
		couponid = 2730
	Else
		eCode = "65433"
		couponid = 762
	End If

	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
	
	totalbonuscouponcount = getbonuscoupontotalcount(couponid, "", "", Date())
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt65433 .topic .hidden {visibility:hidden; width:0; height:0;}
.mEvt65433 .couponArea {position:relative;}
.mEvt65433 .couponArea .btndown {position:absolute; top:39.5%; left:50%; width:59.2%; margin-left:-29.6%;}

.appDown {display:none; position:relative;}
.appDown .btnapp {position:absolute; top:38%; left:50%; width:77.34%; margin-left:-38.67%;}

.noti {padding:5% 3.125%;}
.noti h2 {color:#000; font-size:13px;}
.noti h2 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#7dd0ff;}

@media all and (min-width:480px){
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">

function checkform(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		<% If totcnt > 0 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			var str = $.ajax({
				type: "GET",
				url: "/event/etc/doeventsubscript/doEventSubscript65433.asp",
				data: "mode=add",
				dataType: "text",
				async: false
			}).responseText;
				if (str=="11")
				{
					alert('이미 다운받으셨습니다.');
					return;
				}
				else if (str=="22")
				{
					alert('쿠폰은 1회만 발급받으실 수 있습니다.');
					return;
				}
				else if (str=="33")
				{
					alert('이벤트 기간이 아닙니다.');
					return;
				}
				else if (str=="44")
				{
					alert('로그인 후 쿠폰을 받으실 수 있습니다!');
					return;
				}
				else if (str=="00")
				{
					alert('죄송합니다. 쿠폰이 모두 소진되었습니다.');
					return;
				}
				else if (str=="88")
				{
					alert('잘못된 접속 입니다.');
					return;
				}
				else if (str=="99")
				{
					alert('쿠폰이 발급되었습니다.\n8월 14일 금요일까지\n텐바이텐 app에서 사용하세요!');
					return;
				}
				else{
					alert('오류가 발생했습니다.');
					return false;
				}
		 <% End If %>
	<% End If %>
}

function fnappdowncnt(){
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript65433.asp",
		data: "mode=appdowncnt",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		var userAgent = navigator.userAgent.toLowerCase();
			parent.top.location.href='http://m.10x10.co.kr/apps/link/?7820150715';
			return false;
	
		$(function(){
			var chkapp = navigator.userAgent.match('tenapp');
			if ( chkapp ){
				$("#mo").hide();
			}else{
				$("#mo").show();
			}
		});
	}else{
alert(str);
		alert('오류가 발생했습니다.');
		return false;
	}
}

</script>
	<!-- [Mobile App] 낮ver. 신데렐라2 -->
	<div class="mEvt65433">
		<div class="topic">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65433/txt_cinderella.png" alt="쿠폰 들고 돌아온 호박마차! 낮 버전 이벤트 기간은 8월 12일 수요일부터 8월 14일 금요일까지 진행합니다." /></p>
			<p class="hidden">당신을 위한 호박마차가 등장했어요! 호박마차를 클릭하고 쿠폰을 받으세요!</p>
		</div>

		<div class="couponArea">
			<!-- for dev msg : 쿠폰 다운 버튼 -->
			<div class="btndown"><a href="" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65433/btn_down.png" alt="5만원 이상 구매시 만원 할인 앱전용 쿠폰 다운 받기" /></a></div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65433/txt_coupon.png" alt="토요일이 되면 사용하지 않는 쿠폰은 사라집니다. 쿠폰이 사라지기 전에 꼭 사용해주세요." /></p>
		</div>

		<% if isapp <> "1" then %>
			<!-- for dev msg : 모바일웹에서만 보입니다. -->
			<div class="appDown">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65433/txt_tenten_app.png" alt="텐바이텐 앱을 설치하세요!" /></p>
				<!-- for dev msg : 앱 다운받기 -->
				<div class="btnapp"><a href="" onclick="fnappdowncnt();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65433/btn_app.png" alt="텐바이텐 앱 다운받기" /></a></div>
			</div>
		<% end if %>

		<div class="noti">
			<h2><strong>유 의 사 항</strong></h2>
			<ul>
				<li>텐바이텐 APP푸쉬와 LMS를 받으신 고객님을 대상으로 한 이벤트 입니다.</li>
				<li>ID당 1회만 쿠폰을 발급 받을 수 있습니다.</li>
				<li>쿠폰은 8월14일(금) 23시59분 59초까지 사용 할 수 있습니다.</li>
			</ul>
		</div>
	</div>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".appDown").hide();
	}else{
			$(".appDown").show();
	}
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
