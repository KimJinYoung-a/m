<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'##############################################################
'꽃보다 쿠폰 for Mobile & app
'2015-04-06 이종화
'##############################################################
Dim vUserID, eCode, cMil, vMileValue, vMileArr , couponidx
Dim totalbonuscouponcount '//쿠폰
	totalbonuscouponcount = 0

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21538"
		couponidx = "401"
	Else
		eCode = "61001"
		couponidx = "723"
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and convert(varchar(10),regdate,120) = '"& Date() &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
	
	'//쿠폰 확인
	totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())

%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title></title>
<style type="text/css">
img {vertical-align:top;}
.mEvt61001 .down {position:relative; background-color:#a7f5f0;}
.mEvt61001 .before, .mEvt61001 .after {display:block; width:91.8%; margin:0 auto;}
.down .soldout {position:absolute; top:-2.5%; left:50%; width:95%; margin-left:-47.5%;}
.mEvt61001 .enjoy {padding-top:7%; padding-bottom:10%; background-color:#a7f5f0;}
.mEvt61001 .enjoy a:first-child {margin-top:0;}
.mEvt61001 .enjoy a {display:block; width:90.6%; margin:7% auto 0;}

.noti {padding-top:26px; background-color:#ededed;}
.noti h2 {color:#000; font-size:15px; text-align:center;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:25px; padding:0 10px 20px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#333; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:6px; left:0; width:5px; height:5px; border-radius:50%; background-color:#aaa;}
.noti ul li:first-child:after {background-color:#dc0610;}
.noti ul li em {color:#dc0610;}
@media all and (min-width:480px){
	.noti {padding-top:35px;}
	.noti ul {margin-top:35px; padding:0 20px 35px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:2px; font-size:13px;}
}
@media all and (min-width:768px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:45px;}
	.noti ul li {margin-top:4px; font-size:16px;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<script type="text/javascript">
function jsSubmitC(){
	<% If vUserID = "" Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If totcnt > 1 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "coupondown";
			frmGubun2.action = "/event/etc/doEventSubscript61001.asp";
			frmGubun2.submit();
	   <% End If %>
	<% End If %>

}
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
// 모바일 홈페이지 바로가기 링크 생성
if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	}
};

$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$("#mo").hide();
	}else{
		$("#mo").show();
	}
});
</script>
</head>
<body>
<div class="mEvt61001">
	<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/tit_coupon.png" alt="꽃보다 쿠폰 4월에는 꽃보다 아름다운 앱 쿠폰과 함께!" /></h1>
	<div class="down">
		<% If totalbonuscouponcount > 28000  Then %>
			<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다. 다음 기회에 이용해주세요 : )" /></p>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/btn_down.png" alt="앱 전용 만원 쿠폰 3만원 이상 구매시 사용한 쿠폰 다운 받기! 4월 28일 화요일 하루 앱에서만 사용가능합니다." />
		<% Else %>
			<% If totcnt > 0 Then %>
			<span class="after"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/btn_down_done.png" alt="앱 전용 만원 쿠폰 3만원 이상 구매시 사용한 쿠폰이 발급되었습니다. 4월 28일 화요일 하루 앱에서만 사용가능합니다." /></span>
			<% Else %>
			<a href="" onclick="jsSubmitC(); return false;" class="before"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/btn_down.png" alt="앱 전용 만원 쿠폰 3만원 이상 구매시 사용한 쿠폰 다운 받기! 4월 28일 화요일 하루 앱에서만 사용가능합니다." /></a>		
			<% End If %>
		<% End If %>
	</div>
	<div class="enjoy">
		<% if isApp <> 1 then %>
		<a href="" onclick="gotoDownload();return false;" title="새창" id="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/btn_app.png" alt="텐바이텐 APP을 설치하세요! 텐바이텐 APP 다운받기" /></a>
		<% End If %>

		<% If vUserID = "" Then %>
			<% if isApp=1 then %>
			<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a>
			<% Else %>
			<a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a>
			<% End If %>
		<% End If %>
	</div>
	<div class="noti">
		<h2><strong>사용전 꼭꼭 읽어보세요!</strong></h2>
		<ul>
			<li><em>텐바이텐 APP에서만 사용 가능합니다.</em></li>
			<li>한 ID당 1일 1회 발급, 1회 사용 할 수 있습니다.</li>
			<li>쿠폰은 금일 4/28(화) 23시59분 종료됩니다. </li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61001/img_bag.png" alt="" /></p>
	</div>
</div>
<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript61001.asp" style="margin:0px;" target="evtFrmProc">
<input type="hidden" name="mode" value="">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->