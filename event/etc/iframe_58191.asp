<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	vUserID = GetLoginUserID
	'vUserID = "10x10yellow"
	IF application("Svr_Info") = "Dev" THEN
		
	Else
		eCode = "58191"
	End If
	
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>[app쿠폰] 만원의 행복</title>
<style type="text/css">
.mEvt58191 p {margin:0;}
.mEvt58191 img {vertical-align:top; display:inline;}
.mEvt58191 .noti58191 {position:relative; text-align:left;}
.mEvt58191 .noti58191 ul {position:absolute; left:0; top:0; margin:4% 0 5%; padding:0 4.79166%;}
.mEvt58191 .noti58191 ul li {margin-top:5px; padding-left:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54056/blt_dot_grey.png); background-repeat:no-repeat; background-position:0 4px; background-size:4px auto; color:#333; font-size:11px; line-height:13px;}
.mEvt58191 .noti58191 ul li:first-child {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54056/blt_dot_red.png);}
@media all and (min-width:480px){
	.mEvt58191 .noti58191 ul li {margin-top:7px; padding-left:15px; background-position:0 6px; background-size:6px auto; font-size:14px; line-height:16px;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>

<script type="text/javascript">
<%
	Dim vQuery, vCheck
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '680' and userid = '" & vUserID & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()
%>
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
		<% If vCheck = "2" then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "coupon";
		   frmGubun2.action = "/event/etc/doEventSubscript58191.asp";
		   frmGubun2.submit();
	   <% End If %>
	<% End If %>

}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt58191">
		<div class="section section1">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_tit.png" alt="2014년 마지막! 만원의 행복!" /></p>
			<p>
				<% If vUserID = "" Then %>
					<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_cp.png" alt="3만원 이상 구매시 12/30(화) 하루 APP에서만 사용가능한 쿠폰 다운받기" /></a>
				<% End If %>
			
				<% If vUserID <> "" Then %>
					<% If vCheck = "2" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_cp_ok.png" alt="다운로드가 완료되었습니다. 12.30일 자정까지 APP에서 사용하세요!">
					<% Else %>
						<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_cp.png" alt="3만원 이상 구매시 12/30(화) 하루 APP에서만 사용가능한 쿠폰 다운받기" /></a>
				   <% End If %>
				<% End If %>
			</p>
			<% if isApp=1 then %>
			<% Else %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_txt1.png" alt="텐바이텐 APP을 설치하세요!" /></p>
			<p><a href="http://bit.ly/1m1OOyE" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_btn1.png" alt="텐바이텐 APP 다운받기" /></a></p>
			<% End If %>
			
			<% If vUserID = "" Then %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_txt2.png" alt="텐바이텐에 처음 오셨나요?" /></p>
			<% if isApp=1 then %>
			<p><a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_btn2.png" alt="회원가입하고 구매하러가기" /></a></p>
			<% Else %>
			<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_btn2.png" alt="회원가입하고 구매하러가기" /></a></p>
			<% End If %>
			<% End If %>
		</div>
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_txt3.png" alt="사용전 꼭꼭 읽어보세요!" /></h3>
		<div class="noti58191">
			<ul>
				<li class="cRd1">텐바이텐 APP에서만 사용 가능합니다.</li>
				<li>한 ID당 1회 발급, 1회 사용할 수 있습니다.</li>
				<li>쿠폰은 금일 12/30(화) 23시59분 종료됩니다.</li>
				<li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58191/58191_img.png" alt="결제시 할인정보 입력에서 모바일 쿠폰 항목에서 사용할 쿠폰을 선택하세요" /></p>
		</div>
	</div>

	<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript58191.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->