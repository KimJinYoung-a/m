<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myTenbytenInfoCls.asp" -->
<%
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID
	vPageSize = 8
	vPage = NullFillwith(requestCheckvar(request("page"),3),1)
	If isNumeric(vPage) = False Then
		response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
		dbget.close()
	    response.end
	End If
	
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21272"
		vLinkECode = "21273"
	Else
		eCode = "54424"
		vLinkECode = "54425"
	End If
	
	If vUserID = "" Then
		response.write "<script language='javascript'>top.location.href = '/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D" & vLinkECode & "';</script>"
		dbget.close()
	    response.end
	End If


	'// 이번달 기준
	dim oMyInfo2, yyyymm, userlevel2, BuyCount2, BuySum2
	set oMyInfo2 = new CMyTenByTenInfo
	oMyInfo2.FRectUserID = vUserID
	oMyInfo2.GetLastMonthUserLevelData
	    yyyymm			= oMyInfo2.FOneItem.Fyyyymm
	    userlevel2		= oMyInfo2.FOneItem.Fuserlevel
	    BuyCount2		= oMyInfo2.FOneItem.FBuyCount
	    BuySum2			= oMyInfo2.FOneItem.FBuySum
	set oMyInfo2 = Nothing
	

	'// 다음달 기준
	dim oMyInfo, userlevel, BuyCount, BuySum, NextuserLevel, vLevelUpNeedBuyCount
	set oMyInfo = new CMyTenByTenInfo
	oMyInfo.FRectUserID = vUserID
	oMyInfo.getNextUserBaseInfoData
	    userlevel		= oMyInfo.FOneItem.Fuserlevel
	    BuyCount		= oMyInfo.FOneItem.FBuyCount
	    BuySum			= oMyInfo.FOneItem.FBuySum
	set oMyInfo = Nothing

	NextuserLevel = getUserLevelByQual(BuyCount,BuySum)			'조건으로 회원등급 확인

	if cStr(userlevel) = "5" and cStr(NextuserLevel) = "0" then NextuserLevel = "5"	'오렌지회원
	if cStr(userlevel) = "7" then NextuserLevel = "7"								'STAFF


%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 9월이 오기전에</title>
<style type="text/css">
.mEvt54425 {}
.mEvt54425 img {vertical-align:top; width:100%;}
.mEvt54425 p {max-width:100%;}
.fall .section,.fall .section h3 {margin:0; padding:0;}
.fall .section1 {position:relative;}
.fall .section1 .up {position:absolute; top:11%; right:5%; width:17.60416%;}
.fall .section2 {background-color:#fcc746;}
.fall .section2 .group1 {text-align:left;}
.fall .section2 .part .area {position:relative; margin:0 15px; padding:5% 5% 2.5% 25%; border-radius:20px; background-color:#fff;}
.fall .section2 .part .area .avatar {position:absolute; top:20%; left:10px; width:20%;}
.fall .section2 .part .grade {padding:2% 2.5% 2%; border:1px solid #eee; background-color:#fafafa;}
.fall .section2 .part .grade img {vertical-align:middle;}
.fall .section2 .part .grade strong {font-size:22px; line-height:1.313em; vertical-align:middle;}
.fall .section2 .part .grade .memBLUE {color:#009ce4;}
.fall .section2 .part .grade .memSILVER {color:#918f91;}
.fall .section2 .part .grade .memGOLD {color:#dbb025;}
.fall .section2 .part .grade .memYELLOW {color:#fbbd00;}
.fall .section2 .part .grade .memORANGE {color:#ff7c14;}
.fall .section2 .part .grade .memGREEN {color:#44a46f;}
.fall .section2 .part ul {margin-bottom:5%; padding:2% 0; border-bottom:1px solid #ededed;}
.fall .section2 .part ul li {overflow:hidden; padding:1% 2% 0 3%;}
.fall .section2 .part ul li img {vertical-align:middle;}
.fall .section2 .part ul li strong, .fall .section2 .part ul li span {float:left; width:50%;}
.fall .section2 .part ul li strong {text-align:right; vertical-align:middle;}
.fall .section2 .part ul li strong em {color:#555; font-size:20px; line-height:1.5em; vertical-align:middle;}
.fall .section2 .part2 {margin-bottom:8%;}
.fall .section2 .group2 {background-color:#8fd7c5;}
.fall .section2 .group2 .btnEnter {padding:5% 7.7% 7%;}
.fall .section3 ul {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
@media all and (max-width:480px){
	.fall .section2 .part .grade strong {font-size:12px; line-height:1.313em;}
	.fall .section2 .part ul li strong em {font-size:13px; line-height:1.5em;}
}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Bounce animation */
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
	40% {-webkit-transform: translateY(-15px);}
	60% {-webkit-transform: translateY(-4px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
	40% {transform: translateY(-15px);}
	60% {transform: translateY(-4px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
<script type="text/javascript">

function jsSubmitC(){
	<% If vUserID = "" Then %>
		alert('로그인을 하셔야 쿠폰을\n다운받을 수가 있습니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=vLinkECode%>"
	<% End If %>

	<% If vUserID <> "" Then %>
		   frmGubun2.action = "doEventSubscript54424.asp";
		   frmGubun2.submit();
	<% End If %>
}

</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt54425">
		<div class="fall">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_fall.gif" alt="9월이 오기전에 텐바이텐 등업기간! 등업하고, 기프트카드 선물 받으세요!" /></p>
				<span class="up animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_up.png" alt="UP" /></span>
				<p class="enjoy"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_enjoy_event.gif" alt="등업 이벤트를 이렇게 즐겨보세요! 먼저 내 회원등급과 구매횟수를 확인한 후 텐바이텐 기프트카드 응모하기를 누르고, 이벤트 기간동안 텐바이텐에서 신나게 쇼핑을" /></p>
			</div>

			<div class="section section2">
				<div class="group group1">
					<!-- 나의 등급 -->
					<div class="part part1">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/tit_my_grade.gif" alt="지금 나의 등급을 확인하세요!" /></h3>
						<div class="area">
							<span class="avatar"><img src="http://fiximage.10x10.co.kr/web2013/my10x10/ico_member_<%=GetLoginUserLevel%>.gif" alt="<%= GetUserLevelStr(myuserLevel) %>" /></span>
							<p class="grade">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_august.gif" alt="8월 고객님의 등급은" style="width:45%;" />
								<strong class="<%=GetUserLevelCSSClass()%>"><%= GetUserLevelStr(myuserLevel) %></strong>
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_is.gif" alt="입니다." style="width:15.5%;" />
							</p>
							<ul>
								<li>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_buy_count.gif" alt="구매횟수" style="width:48%;" /></span>
									<strong><em><%= FormatNumber(BuyCount2,0) %></em> <img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_num.gif" alt="회" style="width:10%;" /></strong>
								</li>
								<li>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_buy_amount.gif" alt="구매금액" style="width:48%;" /></span>
									<strong><em><%= FormatNumber(BuySum2,0) %></em> <img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_won.gif" alt="원" style="width:10%;" /></strong>
								</li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_buy_note.gif" alt="지난 5개월간 1만원 이상구매 내역입니다" style="width:88%;" /></p>
						</div>
					</div>
					<!-- //나의 등급 -->
				<%
					NextuserLevel = getNextMayLevel(NextuserLevel)

					dim levelcolor
					Select case NextuserLevel
						case "1"
							levelcolor="memGREEN"
						case "2"
							levelcolor="memBLUE"
						case "3"
							levelcolor="memSILVER"
						case "4"
							levelcolor="memGOLD"
						Case Else
							levelcolor="memYELLOW"
					End Select
				%>
					<!-- 등급업이 되려면 -->
					<div class="part part2">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/tit_my_grade_up.gif" alt="등급업이 되려면?" /></h3>
						<div class="area">
							<span class="avatar"><img src="http://fiximage.10x10.co.kr/web2013/my10x10/ico_member_<%=NextuserLevel%>.gif" alt="<%= GetUserLevelStr(NextuserLevel) %>" /></span>
							<p class="grade">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_september.gif" alt="9월 고객님의 등급은" style="width:45%;" />
								<strong class="<%=levelcolor%>"><%= GetUserLevelStr(NextuserLevel)%></strong>
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_is.gif" alt="입니다." style="width:15.5%;" />
							</p>
							<ul>
								<li>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_buy_count_need.gif" alt="필요한 구매횟수" style="width:85%;" /></span>
									<strong><em><%= getRequireLevelUpBuyCount(NextuserLevel,BuyCount) %></em> <img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_num.gif" alt="회" style="width:10%;" /></strong>
								</li>
								<li>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_buy_amount_need.gif" alt="필요한 구매금액" style="width:85%;" /></span>
									<strong><em><%= FormatNumber(getRequireLevelUpBuySum(NextuserLevel,BuySum),0) %></em> <img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_won.gif" alt="원" style="width:10%;" /></strong>
								</li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_upgrade_condition.gif" alt="8월 31일까지, 구매횟수 건당 1만원 이상 또는 결제금액 중 한가지만 충족하시면 등급업이 됩니다." style="width:90%;" /></p>
						</div>
					</div>
					<!-- //등급업이 되려면 -->
				</div>

				<div class="group group2">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/tit_gift_card.gif" alt="기프트카드 응모하기!" /></h3>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_gift_card.gif" alt="등업 축하 이벤트에 응모하세요. 추첨을 통해 기프트 카드 만원을 50분께 드려요." /></p>
						<div class="btnEnter"><a href="javascript:jsSubmitC();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/btn_enter.gif" alt="이벤트 응모하기" /></a></div>
				</div>
			</div>

			<div class="section section3">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/tit_noti.gif" alt="이벤트 유의사항" /></h3>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/txt_noti.gif" alt="" />
				<ul>
					<li>등업이벤트 이메일을 받으신 고객님만을 위한 이벤트 입니다.</li>
					<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
					<li>응모하기를 누르고, 8월 31일까지 구매횟수를 채워 9월 등업이 되신 분들 중 50명을 선정하여 사은품을 드립니다.</li>
					<li>8월 31일까지 구매건 중, 환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 회원등급이 UP되지 않을 수도 있습니다.</li>
					<li>변경된 등급은, 9월 1일부터 마이텐바이텐에서 확인 가능합니다.</li>
					<li>텐바이텐 기프트카드 당첨자는 9월 15일 해당 당첨자 ID로 일괄 지급됩니다.</li>
				</ul>
			</div>
	
			<div class="btnGo"><a href="/event/eventmain.asp?eventid=54470"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54425/btn_go_event.gif" alt="담고 싶은 것이 많은 당신을 위한 선물 이벤트 가기" /></a></div>
		</div>
	</div>

	<form name="frmGubun2" method="post" action="doEventSubscript54424.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->