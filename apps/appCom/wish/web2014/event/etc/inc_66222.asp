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
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : ## 이건 바로 비밀 쿠폰 [타겟]! 
' History : 2015-09-15 원승현 생성
'####################################################
	Dim vUserID, eCode, nowdate
	Dim strSql , totcnt, couponid
	dim totalbonuscouponcount

	vUserID = GetEncLoginUserID
	nowdate = date()
'	nowdate = "2015-08-14"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64884"
		couponid = 784
	Else
		eCode = "66222"
		couponid = 784
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
.mEvt66221 .topic {position:relative;}
.mEvt66221 .topic .btncoupon {position:absolute; bottom:4.8%; left:50%; z-index:10; width:91.70%; margin-left:-45.85%;}

.noti {padding:5% 5.5%; background-color:#fff;}
.noti h3 {color:#222; font-size:13px;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #111; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:2px; left:0; width:0; height:0; border-top:4px solid transparent; border-bottom:4px solid transparent; border-left:6px solid #5c5c5c;}

@media all and (min-width:480px){
	.noti ul {margin-top:16px;}
	.noti h3 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h3 {font-size:20px;}
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
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript66222.asp",
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
					alert('쿠폰이 발급되었습니다.\n9월 20일 일요일까지\n텐바이텐 app에서 사용하세요!');
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
		url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript66222.asp",
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


<%' [APP] 쿠폰이벤트! %>
<div class="mEvt66221">
	<article>
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66221/tit_time.jpg" alt="너를 사용할 시간" /></h2>
			<div class="btncoupon">
				<a href="" title="오천원 쿠폰 다운받기" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66222/btn_coupon.png" alt="오천원 쿠폰 3만원 이상 구매시 사용 가능하며 9월 16일 수요일부터9월 20일 일요일까지 일간 앱에서만 사용 가능합니다." /></a>
			</div>
		</div>

		<div class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>발급 된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
				<li>한 ID당 1일 1회 발급, 1회 사용 할 수 있습니다.</li>
				<li>쿠폰은 9/20(일) 23시59분 59초 종료됩니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다. </li>
			</ul>
		</div>
	</article>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->
