<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	dim eCode , sqlstr
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "20995"
	Else
		eCode 		= "46500"
	End If

	Dim vCount1, vCount2 , vCount3 , vCount4 ,  vCount5 , vCount6 , vCount7 , vCount8 ,  vCount9 , vCount10 , vCount11 ,  vCount12 , vCount13 , vCount14 , vCount15 , vCount16
	If GetLoginUserLevel() = "7" Then
		sqlstr = " select " & _
				"	isnull(count(case when masteridx = 478 then userid end),0) as startcoupon " & _
				"	,isnull(count(case when masteridx = 478 and isusing ='Y' then userid end),0) as startcouponY " & _
				"	,isnull(count(case when masteridx = 479 then userid end),0) as '20131030' " & _
				"	,isnull(count(case when masteridx = 479 and isusing ='Y' then userid end),0) as '20131030_Y' " & _
				"	,isnull(count(case when masteridx = 480 then userid end),0) as '20131031' " & _
				"	,isnull(count(case when masteridx = 480 and isusing ='Y' then userid end),0) as '20131031_Y' " & _
				"	,isnull(count(case when masteridx = 481 then userid end),0) as '20131101' " & _
				"	,isnull(count(case when masteridx = 481 and isusing ='Y' then userid end),0) as '20131101_Y' " & _
				"	,isnull(count(case when masteridx = 482 then userid end),0) as '20131102' " & _
				"	,isnull(count(case when masteridx = 482 and isusing ='Y' then userid end),0) as '20131102_Y' " & _
				"	,isnull(count(case when masteridx = 483 then userid end),0) as '20131103' " & _
				"	,isnull(count(case when masteridx = 483 and isusing ='Y' then userid end),0) as '20131103_Y' " & _
				"	,isnull(count(case when masteridx = 484 then userid end),0) as '20131104' " & _
				"	,isnull(count(case when masteridx = 484 and isusing ='Y' then userid end),0) as '20131104_Y' " & _
				"	,isnull(count(case when masteridx = 485 then userid end),0) as '20131105' " & _
				"	,isnull(count(case when masteridx = 485 and isusing ='Y' then userid end),0) as '20131105_Y' " & _
				" from db_user.dbo.tbl_user_coupon " 
		rsget.Open sqlStr,dbget,1
		vCount1 = rsget(0)
		vCount2 = rsget(1)
		vCount3 = rsget(2)
		vCount4 = rsget(3)
		vCount5 = rsget(4)
		vCount6 = rsget(5)
		vCount7 = rsget(6)
		vCount8 = rsget(7)
		vCount9 = rsget(8)
		vCount10 = rsget(9)
		vCount11 = rsget(10)
		vCount12 = rsget(11)
		vCount13 = rsget(12)
		vCount14 = rsget(13)
		vCount15 = rsget(14)
		vCount16 = rsget(15)
		rsget.Close
		response.write "신규가입쿠폰 총발급수:" & vCount1 & ", 사용수:" & vCount2 &"<br/>"
		response.write "10/30할인쿠폰 총발급수" & vCount3 & ", 사용수:" & vCount4 &"<br/>"
		response.write "10/31할인쿠폰 총발급수" & vCount5 & ", 사용수:" & vCount6 &"<br/>"
		response.write "11/01할인쿠폰 총발급수" & vCount8 & ", 사용수:" & vCount8 &"<br/>"
		response.write "11/02할인쿠폰 총발급수" & vCount9 & ", 사용수:" & vCount10 &"<br/>"
		response.write "11/03할인쿠폰 총발급수" & vCount11 & ", 사용수:" & vCount12 &"<br/>"
		response.write "11/04할인쿠폰 총발급수" & vCount13 & ", 사용수:" & vCount14 &"<br/>"
		response.write "11/05할인쿠폰 총발급수" & vCount15 & ", 사용수:" & vCount16 &"<br/>"
	End If
%>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 지금 잠이 옵니까?</title>
	<style type="text/css">
	.mEvt46500 {}
	.mEvt46500 img {vertical-align:top; display:inline;}
	.mEvt46500 .mCoupon {position:relative;}
	.mEvt46500 .mCoupon .goJoin {position:absolute; left:50%; top:0; width:90%; margin-left:-45%;}
	.mEvt46500 .hotProd {overflow:hidden; padding:0 24px 15px; background:#333;}
	.mEvt46500 .hotProd p {width:48.5%;}
	.mEvt46500 .hotProd p.ftLt {float:left;}
	.mEvt46500 .hotProd p.ftRt {float:right;}
</style>
<!-- //content area -->
<script>
<!--
	function jsDownCoupon(stype,idx){
	<% IF IsUserLoginOK THEN %>
	var frm;
		frm = document.frmC;
		//frm.target = "iframecoupon";
		frm.action = "/shoppingtoday/couponshop_process.asp";
		frm.stype.value = stype;	
		frm.idx.value = idx;	
		frm.submit();
	<%ELSE%>
		if(confirm("로그인하시겠습니까?")) {
			parent.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
		}
	<%END IF%>
	}

//-->
</script>
</head>
<body>
<!-- content area -->
<form name="frmC" method="post">
<input type="hidden" name="stype" value="">            		
<input type="hidden" name="idx" value="">
</form>
<iframe src="about:blank" name="iframecoupon" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
<div class="content" id="contentArea">
	<div class="mEvt46500">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46500/46500_head.png" alt="지금 잠이 옵니까?" style="width:100%;" /></p>
		<div class="mCoupon">
			<img src="http://webimage.10x10.co.kr/eventIMG/2013/46500/46500_bg01.png" alt="" style="width:100%;" />
			<p class="goJoin">
			<% If Now() > #10/30/2013 22:00:00# AND Now() < #10/31/2013 00:00:00# Then %>
			<a href="javascript:jsDownCoupon('event','479');">
			<% ElseIf Now() > #10/31/2013 22:00:00# AND Now() < #11/01/2013 00:00:00# Then %>
			<a href="javascript:jsDownCoupon('event','480');">
			<% ElseIf Now() > #11/01/2013 22:00:00# AND Now() < #11/02/2013 00:00:00# Then %>
			<a href="javascript:jsDownCoupon('event','481');">
			<% ElseIf Now() > #11/02/2013 22:00:00# AND Now() < #11/03/2013 00:00:00# Then %>
			<a href="javascript:jsDownCoupon('event','482');">
			<% ElseIf Now() > #11/03/2013 22:00:00# AND Now() < #11/04/2013 00:00:00# Then %>
			<a href="javascript:jsDownCoupon('event','483');">
			<% ElseIf Now() > #11/04/2013 22:00:00# AND Now() < #11/05/2013 00:00:00# Then %>
			<a href="javascript:jsDownCoupon('event','484');">
			<% ElseIf Now() > #11/05/2013 22:00:00# AND Now() < #11/06/2013 00:00:00# Then %>
			<a href="javascript:jsDownCoupon('event','485');">
			<% Else %>
				<% IF IsUserLoginOK THEN %>
				<a href="javascript:alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');">
				<% Else %>
				<a href="javascript:jsDownCoupon('event','');">
				<% End if%>
			<% End If %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2013/46500/46500_img_coupon.png" alt="3,000원 쿠폰다운받기" style="width:100%;" /></a></p>
		</div>
		<p><a href="/member/join.asp"  target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46500/46500_btn_join.png" alt="회원가입하러가기" style="width:100%;" /></a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46500/46500_tit_issue.png" alt="HOT ISSUE" style="width:100%;" /></p>
		<div class="hotProd">
			<p class="ftLt"><a href="/event/eventmain.asp?eventid=46277"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46500/46500_img_product01.png" alt="빼빼로 FESTIVAL 2013" style="width:100%;" /></a></p>
			<p class="ftRt"><a href="/event/eventmain.asp?eventid=46350"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46500/46500_img_product02.png" alt="2014 다이어리 사고 선물받자!" style="width:100%;" /></a></p>
		</div>
	</div>
</div>
<!-- //content area -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->



