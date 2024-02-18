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
' Description : ##비정상쿠폰 APP 쿠폰
' History : 2015-05-18 원승현 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim couponidx
	Dim totalbonuscouponcount

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "62770"
		couponidx = "400"
	Else
		eCode = "62528"
		couponidx = "736"
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
.mEvt62528 img {vertical-align:top;}
.mEvt62528 .couponDownload {position:relative;}
.mEvt62528 .couponDownload a {display:block; position:absolute; left:23%; bottom:11%; width:54%; height:16%; color:transparent; background:transparent; z-index:40;}
.mEvt62528 .couponDownload .soldout {position:absolute; left:0; top:0; width:100%; z-index:50;}
.mEvt62528 .goBtn {padding:0 3.75%;}
.mEvt62528 .goBtn p {padding-top:24px;}
.mEvt62528 .goBtn p:last-child {padding-bottom:34px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/62528/bg_dash.gif) 0 100% repeat-x; background-size:20px auto;}
.mEvt62528 .evtNoti {padding-top:20px; text-align:left;}
.mEvt62528 .evtNoti h3 {text-align:center;}
.mEvt62528 .evtNoti h3 span {display:inline-block; font-size:14px; padding-bottom:1px; font-weight:bold; color:#dc0610; border-bottom:3px solid #dc0610;}
.mEvt62528 .evtNoti ul {padding:15px 3.75% 0;}
.mEvt62528 .evtNoti li {position:relative; font-size:11px; line-height:1.2; padding:0 0 4px 10px; color:#444; }
.mEvt62528 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:4px; height:4px; background:#aaa; border-radius:50%;}
.mEvt62528 .evtNoti li.cRd1:after {background:#dc0610;}
@media all and (min-width:480px){
	.mEvt62528 .goBtn p {padding-top:36px;}
	.mEvt62528 .goBtn p:last-child {padding-bottom:51px; background-size:30px auto;}
	.mEvt62528 .evtNoti {padding-top:30px;}
	.mEvt62528 .evtNoti h3 span {font-size:21px; padding-bottom:2px;}
	.mEvt62528 .evtNoti ul {padding:23px 3.75% 0;}
	.mEvt62528 .evtNoti li {font-size:17px; padding:0 0 6px 15px;}
	.mEvt62528 .evtNoti li:after {top:4px; width:6px; height:6px;}
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
				url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript62528.asp",
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
					else if (result.resultcode=="44")
					{
						alert('로그인이 필요한 서비스 입니다.');
						return;
					}
					else if (result.resultcode=="00")
					{
						alert('죄송합니다. 쿠폰이 모두 소진되었습니다.');
						return;
					}
					else if (result.resultcode=="99")
					{
						alert('쿠폰이 발급되었습니다.\n금일 자정까지 사용해주세요.');
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
	<!-- 비정상쿠폰 -->
	<div class="mEvt62528">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62528/tit_coupon.gif" alt="비정상쿠폰" /></h2>
		<div class="couponDownload">
			<% If totalbonuscouponcount >= 25000 Then %>
				<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62528/txt_soldout.png" alt="앗! 쿠폰이 모두 소진되었어요!" /></p>
			<% End If %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62528/btn_coupon_download03.gif" alt="APP전용쿠폰 - 5만원 이상 구매 시 1만원 할인" /></p>
			<a href="" onclick="checkform();return false;">쿠폰 다운받기</a>
		</div>
		<div class="goBtn">
			<% If isApp="1" Then %>

			<% Else %>
				<p><a href="" onclick="gotoDownload();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62528/btn_app_download.gif" alt="텐바이텐 APP 다운받기" /></a></p>
			<% End If %>

			<% If Trim(vUserID)="" Then %>
				<%' 비회원에게만 노출 %>
				<% If isApp="1" Then %>
					<p><a href="" onclick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62528/btn_join.gif" alt="회원가입하고 구매하러 가기" /></a></p>
				<% Else %>
					<p><a href="/member/join.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62528/btn_join.gif" alt="회원가입하고 구매하러 가기" /></a></p>
				<% End If %>
			<% End If %>
		</div>
		<div class="evtNoti">
			<h3><span>사용전 꼭꼭 읽어보세요!</span></h3>
			<ul>
				<li class="cRd1">지급된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
				<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
				<li>쿠폰은 금일 5/20(수) 23시59분 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다. </li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62528/img_use_ex.gif" alt="결제시 할인정보 입력에서 모바일 쿠폰 항목에서 사용할 쿠폰을 선택하세요" /></p>
		</div>
	</div>
	<!-- // 비정상쿠폰 -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->