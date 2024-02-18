<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'####################################################
' Description : 핵쿠폰
' History : 2015-02-09 허진원
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21464"
	Else
		eCode = "59258"
	End If
	
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>[app쿠폰] 핵쿠폰</title>
<style type="text/css">
img {width:100%; vertical-align:top;}
.article {padding-bottom:7%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59258/bg_con.png) no-repeat 50% 0; background-size:100% auto;}
.article .down {position:relative; width:71.875%; margin:0 auto 16%;}
.article .down .soldout {position:absolute; top:0; left:0; width:100%;}
.app, .join {width:93.75%; margin:0 auto;}
.join {margin-top:7%;}
.noti {padding-top:7%; background-color:#f4f7f7;}
.noti h2 {color:#dc0610; font-size:15px; font-weight:bold; line-height:1.438em; text-align:center;}
.noti h2 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #dc0610;}
.noti ul {margin-top:20px; margin-bottom:25px; padding:0 15px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#333; font-size:11px; line-height:1.438em;}
.noti ul li:after {content:' '; display:block; position:absolute; top:4px; left:0; z-index:5; width:4px; height:4px; border-radius:50%; background-color:#aaa;}
.noti ul li:first-child:after {background-color:#dc0610;}
.noti ul li em {color:#dc0610;}
@media all and (min-width:480px) {
	.noti h2 {font-size:23px;}
	.noti ul {margin-top:35px; margin-bottom:37px; padding:0 22px;}
	.noti ul li {margin-top:3px; padding-left:18px; font-size:16px;}
	.noti ul li:after {top:7px; width:6px; height:6px;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>

<script type="text/javascript">
<%
	Dim vQuery, vCheck
	
	if IsUserLoginOK then
		vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '698' and userid = '" & vUserID & "'"
		rsget.Open vQuery,dbget,1
		If rsget(0) > 0 Then
			vCheck = "2"
		End IF
		rsget.close()
	end if
%>
function jsSubmitC(){
<%
	If IsUserLoginOK Then
		If vCheck = "2" then
			Response.Write "alert(""이미 다운받으셨습니다."");"
		else
			Response.Write "frmGubun2.mode.value = ""coupon"";" & vbCrLf
			Response.Write "frmGubun2.action = ""/event/etc/doEventSubscript59258.asp"";" & vbCrLf
			Response.Write "frmGubun2.submit();" & vbCrLf
		End If
	else
		if isApp=1 then
			Response.Write "parent.calllogin();" & vbCrLf
			Response.Write "return false;" & vbCrLf
		else
			Response.Write "parent.jsChklogin_mobile('','" & Server.URLencode("/event/eventmain.asp?eventid="&eCode) & "');" & vbCrLf
			Response.Write "return false;" & vbCrLf
		end if
	End If
%>
}
</script>
</head>
<body>
<!-- // APP 핵쿠폰! -->
<div class="mEvt59258">
	<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/59258/tit_hack_coupon.png" alt="핵쿠폰 쇼핑에 도움이 되는 핵이등정보! 오늘 하루 경력한 앱쿠폰이 돌아왔습니다." /></h1>

	<div class="article">
		<div class="down">
			<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59258/txt_solidout.png" alt="오늘의 쿠폰이 모두 소진되었어요!" /></p>
			<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59258/btn_down_coupon.png" alt="삼만원 이상 구매시 2월 108일 화요일 하루 앱에서만 사용 가능한 앱 전용쿠폰 만원 쿠폰 다운 받기" /></a>
		</div>

		<% if isApp=0 then %>
		<div class="app"><a href="http://bit.ly/1m1OOyE" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59258/btn_down_app.png" alt="텐바이텐 앱을 설치하세요! 텐바이텐 앱 다운받기" /></a></div>
		<% end if %>

		<%
			if Not(IsUserLoginOK) then
				if isApp=1 then
		%>
		<div class="join"><a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59258/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기" /></a></div>
		<%		else %>
		<div class="join"><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59258/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기" /></a></div>
		<%
				end if
			end if
		%>
	</div>

	<div class="noti">
		<h2><span>사용전 꼭꼭 읽어보세요!</span></h2>
		<ul>
			<li><em>텐바이텐 APP에서만 사용 가능합니다.</em></li>
			<li>한 ID당 1일 1회 발급, 1회 사용 할 수 있습니다.</li>
			<li>쿠폰은 금일 2/10(화) 23시59분 종료됩니다.</li>
			<li>주문상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다. </li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59258/txt_ex.png" alt="주문시 모바일 쿠폰에서 해당 쿠폰을 확인 하실 수 있습니다." /></p>
	</div>
</div>
<!-- APP 핵쿠폰! // -->
<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript59258.asp" style="margin:0px;" target="evtFrmProc">
<input type="hidden" name="mode" value="">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->