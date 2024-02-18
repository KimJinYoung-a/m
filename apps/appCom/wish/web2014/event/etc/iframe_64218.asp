<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : ##원데이 APP 쿠폰
' History : 2015-06-30 원승현 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim couponidx
	Dim totalbonuscouponcount

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "63805"
		couponidx = "400"
	Else
		eCode = "64218"
		couponidx = "750"
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()


	totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())

%>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title></title>
<style type="text/css">
img {vertical-align:top;}

.mEvt64218 {background-color:#2280f0;}
.topic p {visibility:hidden; width:0; height:0;}

.coupon {position:relative;}
.coupon .btndown, .coupon .done {position:absolute; top:61%; left:50%; width:45.2%; margin-left:-22.6%;}

.condition a {display:block; width:84.2%; margin:0 auto 9%;}
.condition a:first-child {margin-bottom:6%;}

.noti {position:relative; padding-top:25px;}
.noti h2 {color:#fff; font-size:14px; text-align:center;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #fff;}
.noti ul {margin:20px 15px;}
.noti ul li {position:relative; margin-top:2px; padding-left:14px; color:#ffec4d; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:5px; left:0; width:4px; height:4px; border-radius:50%; background-color:#ffec4d;}

@media all and (min-width:480px){
	.noti {padding-top:40px;}
	.noti ul {margin:37px 22px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; padding-left:21px; font-size:13px;}
	.noti ul li:after {top:5px; width:5px; height:5px;}
}

@media all and (min-width:600px){
	.noti {padding-top:50px;}
	.noti h2 {font-size:20px;}
	.noti ul {margin:45px 30px;}
	.noti ul li {margin-top:6px; padding-left:30px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">

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


function checkform(){

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
			return false;
		}
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If totcnt > 1 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript64218.asp",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="11")
					{
						alert('이미 다운받으셨습니다.');
						return;
					}
					else if (result.resultcode=="22")
					{
						alert('쿠폰은 1회만 발급받으실 수 있습니다.');
						return;
					}
					else if (result.resultcode=="33")
					{
						alert('이벤트 기간이 아닙니다.');
						return;
					}
					else if (result.resultcode=="44")
					{
						alert('로그인 후 쿠폰을 받으실 수 있습니다!');
						return;
					}
					else if (result.resultcode=="00")
					{
						alert('죄송합니다. 쿠폰이 모두 소진되었습니다.');
						return;
					}
					else if (result.resultcode=="99")
					{
						alert('쿠폰이 발급되었습니다.\n오늘하루 app에서 사용하세요!');
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}
</script>
</head>
<body>
<div class="evtCont">

	<!-- 원데이 쿠폰 -->
	<div class="mEvt64218">
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/tit_one_day_coupon.png" alt="있을 때 잘 해 원데이 쿠폰" /></h1>
			<p>오늘 하루 보람찬 쇼핑을 만들어줄 APP 쿠폰이 찾아왔습니다.</p>
		</div>

		<%' coupon %>
		<div class="coupon">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/img_coupon.png" alt="앱 전용 쿠폰 만원, 3만원 이상 구매시 7월 1일 수요일 하루 앱에서만 사용가능 합니다." /></p>
			<%' for dev msg : 쿠폰 다운 - 쿠폰이 모두 소진 시 숨겨주세요 %>
			<% If totalbonuscouponcount >= 23000 Then %>
				<p class="done"><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/txt_done.png" alt="쿠폰이 모두 소진되었습니다. 다음기회에 이용해주세요" /></em></p>
			<% Else %>
				<a href="" onclick="checkform();return false;" class="btndown"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/btn_down.gif" alt="쿠폰 다운받기" /></a>
			<% End If %>
		</div>

		<div class="condition">
			<%' for dev msg : 모바일웹에서만 노출해주세요 %>
			<% If isApp="1" Then %>
			<% Else %>
				<a href="" onclick="gotoDownload();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/btn_app.png" alt="아직이신가요? 텐바이텐 앱 다운받기" /></a>
			<% End If %>
			<%' for dev msg : 로그인이 되어있거나 로그인후에 숨겨주세요 %>
			<% If Trim(vUserID)="" Then %>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"> <img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a>
				<% Else %>
					<a href="/member/join.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a>
				<% End If %>
			<% End If %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/bg_line.png" alt="" />
		</div>

		<div class="noti">
			<h2><strong>이벤트 유의사항</strong></h2>
			<ul>
				<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐 APP에서만 사용가능합니다.</li>
				<li>쿠폰은 금일 07/01(수) 23시 59분에 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64218/img_guide.png" alt="" /></p>
		</div>
	</div>
	<!-- //원데이 쿠폰 -->

</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->