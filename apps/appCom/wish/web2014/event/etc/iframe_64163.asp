<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 라스트팡 쿠폰 for App
' History : 2015-06-23 이종화 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim couponidx

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "62770"
		couponidx = "400"
	Else
		eCode = "64163"
		If Date() = "2015-06-23" then
			couponidx = "747"
		ElseIf Date() = "2015-06-24" Then
			couponidx = "748"
		ElseIf Date() = "2015-06-26" Then
			couponidx = "749" '//미생성 어찌 될지 모름	
		End If 
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()

%>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title></title>
<style type="text/css">
.mEvt64163 {background:#cef1eb;}
.mEvt64163 img {vertical-align:top;}
.mEvt64163 .couponDownload {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64163/tit_last_pang_ver01.gif) 0 0 no-repeat; background-size:100% 100% ;}
.mEvt64163.ver2 .couponDownload {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64163/tit_last_pang_ver02.gif);}
.mEvt64163 .couponDownload a {display:block; position:absolute; left:25%; bottom:10.5%; width:50%; height:9%; color:transparent; background:transparent; z-index:40;}
.mEvt64163 .goBtn {padding:0 8%;}
.mEvt64163 .goBtn p {padding-bottom:18px;}
.mEvt64163 .goBtn p:last-child {padding-bottom:34px;}
.mEvt64163 .evtNoti {padding-top:25px; text-align:left; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64163/bg_dash.png) 0 0 no-repeat; background-size:100% auto;}
.mEvt64163 .evtNoti h3 {text-align:center;}
.mEvt64163 .evtNoti h3 span {display:inline-block; font-size:15px; padding-bottom:1px; font-weight:bold; color:#dc0610; border-bottom:3px solid #dc0610;}
.mEvt64163 .evtNoti ul {padding:20px 4.5% 0;}
.mEvt64163 .evtNoti li {position:relative; font-size:12px; line-height:1.2; padding:0 0 4px 10px; color:#444; }
.mEvt64163 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:4px; height:4px; background:#aaa; border-radius:50%;}
.mEvt64163 .evtNoti li.cRd1:after {background:#dc0610;}
.mEvt64163.ver2 {background:#d7f0a3;}
@media all and (min-width:480px){
	.mEvt64163 .goBtn p {padding-bottom:38px;}
	.mEvt64163 .goBtn p:last-child {padding-bottom:48px;}
	.mEvt64163 .evtNoti {padding-top:30px;}
	.mEvt64163 .evtNoti h3 span {font-size:23px; padding-bottom:2px;}
	.mEvt64163 .evtNoti ul {padding:30px 3.75% 0;}
	.mEvt64163 .evtNoti li {font-size:17px; padding:0 0 6px 15px;}
	.mEvt64163 .evtNoti li:after {top:4px; width:6px; height:6px;}
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

	<% If date() >= "2015-06-26" Then %>
		alert("이벤트가 종료 되었습니다.");
		return;
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If totcnt > 1 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript64163.asp",
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
						alert('쿠폰이 발급되었습니다.');
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
	<!-- 라스트 팡!  -->
	<div class="mEvt64163 <% If Date() = "2015-06-24" Then %> ver2<% End If %><% If Date() = "2015-06-26" Then %> ver3<% End If %>">
		<div class="couponDownload">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64163/tit_last_pang.png" alt="라스트 팡! 오늘 하루 6월 마지막 구매를 도와줄 쿠폰을 받으세요!" /></h2>
			<a href="" onclick="checkform();return false;">쿠폰 다운받기</a>
		</div>
		<div class="goBtn">
			<% If isApp="1" Then %>

			<% Else %>
				<p><a href="" onclick="gotoDownload();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64163/btn_app_download.png" alt="텐바이텐 APP 다운받기" /></a></p>
			<% End If %>
			<% If Trim(vUserID)="" Then %>
				<%' 비회원에게만 노출 %>
				<% If isApp="1" Then %>
					<p><a href="" onclick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64163/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></p>
				<% Else %>
					<p><a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64163/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></p>
				<% End If %>
			<% End If %>
		</div>
		<div class="evtNoti">
			<h3><span>사용전 꼭꼭 읽어보세요!</span></h3>
			<ul>
				<li class="cRd1">텐바이텐 APP에서만 사용가능 합니다.</li>
				<li>한 ID 당 1회 발급, 1회 사용할 수 있습니다.</li>
				<li>주문상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다. </li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64163/img_use_ex.png" alt="결제시 할인정보 입력에서 모바일 쿠폰 항목에서 사용할 쿠폰을 선택하세요" /></p>
		</div>
	</div>
	<!-- 라스트 팡!  -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->