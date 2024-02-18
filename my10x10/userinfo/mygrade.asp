<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myTenbytenInfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
'// 2018 회원등급 개편

'####################################################
' Description : 마이텐바이텐 - 트로피룸
' History : 2018-01-03 이종화 생성
'####################################################
strHeadTitleName="트로피룸"

dim userid
	userid = getEncLoginUserID
'####### 회원등급 재조정 #######
Call getDBUserLevel2Cookie()
'####### 회원등급 재조정 #######

'########################################################################
'등급 그래프 관련
'########################################################################
dim BuyCount, BuySum , userlevel
'// 다음달 기준
dim oMyInfo
set oMyInfo = new CMyTenByTenInfo
oMyInfo.FRectUserID = userid
oMyInfo.getNextUserBaseInfoData
	userlevel		= oMyInfo.FOneItem.Fuserlevel
	BuyCount		= oMyInfo.FOneItem.FBuyCount
	BuySum			= oMyInfo.FOneItem.FBuySum
set oMyInfo = Nothing

'// 등급별로 클래스
dim tmpCSLeftMenuUserLevel : tmpCSLeftMenuUserLevel = GetUserStrlarge(GetLoginUserLevel)
Dim stroke1
Dim compare1 , compare2
Dim NextuserLevel : NextuserLevel = getUserLevelByQual(BuyCount,BuySum)			'조건으로 회원등급 확인

Dim NextuserLevel2 : NextuserLevel2 = getNextMayLevel(NextuserLevel) '// 다음 회원등급기준

	if cStr(userlevel)="0" and cStr(NextuserLevel)="0" then NextuserLevel="0"	'WHITE
	if cStr(userlevel)="7" then NextuserLevel="7"								'STAFF
	if cStr(userlevel)="9" then NextuserLevel="9"								'BIZ

	'// 등급업까지 남은 횟수 및 금액 비교
	compare1 = getRequireLevelUpBuyCountPercent(userlevel,BuyCount) '// 횟수
	compare2 = getRequireLevelUpBuySumPercent(userlevel,BuySum) '// 원

If GetLoginUserLevel = 7 Then
	stroke1 = 100
ElseIf GetLoginUserLevel = 9 Then
	stroke1 = 100
Else
	stroke1 = chkiif(compare1>=compare2,compare1,compare2)
End If
'########################################################################

Function besturl(v)
	Select Case v
		Case 0 : besturl = "/award/awarditem.asp?userlevel=0" 'WHITE
		Case 1 : besturl = "/award/awarditem.asp?userlevel=1" 'RED
		Case 2 : besturl = "/award/awarditem.asp?userlevel=2" 'VIP
		Case 3 : besturl = "/award/awarditem.asp?userlevel=3" 'VIP GOLD
		Case 4 : besturl = "/award/awarditem.asp?userlevel=4" 'VVIP
		Case 5 : besturl = "/award/awarditem.asp?userlevel=0" 'WHITE
		Case 6 : besturl = "/award/awarditem.asp?userlevel=4" 'VVIP
		Case Else
			besturl = "/award/awarditem.asp" 'STAFF
	End select
End Function

Function gradebenefit(v)
	Select Case v
		Case 0 : gradebenefit = "<div class='white'><p class='grade'>WHITE</p><div class='benefit'><div class='coupon'><ul><li><p>5만원 이상 구매 시</p><div><em>2천원</em> 할인쿠폰</div></li><li><p>2만원 이상 구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em> 쿠폰</div></li></ul></div><div class='more-benefit'><ul><li><p>3만원 이상 구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em></div></li><li><p>상품 주문 금액의</p><div><em>0.5%</em><br>마일리지 적립</div></li><li><p>생일 축하 쿠폰</p><div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div></li></ul></div></div></div>" 'WHITE

		Case 1 : gradebenefit = "<div class='red'><p class='grade'>RED</p><div class='benefit'><div class='coupon'><ul><li><p>최대 1만원 할인</p><div class='many'><em>5%</em> 할인쿠폰<span>2장</span></div></li><li><p>1만원 이상 구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em> 쿠폰</div></li></ul></div><div class='more-benefit'><ul><li><p>3만원 이상 구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em></div></li><li><p>상품 주문 금액의</p><div><em>0.5%</em><br>마일리지 적립</div></li><li><p>생일 축하 쿠폰</p><div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div></li></ul></div></div></div>" 'RED

		Case 2 : gradebenefit = "<div class='vip'><p class='grade'>VIP</p><div class='benefit'><div class='coupon'><ul><li><p>최대 1만원 할인</p><div><em>5%</em> 할인쿠폰</div></li><li><p>최대 1만원 할인</p><div><em>3%</em> 할인쿠폰</div></li><li><p>5만원 이상 구매 시</p><div><em>3천원</em> 할인쿠폰</div></li><li><p>1만원 이상 구매 시</p><div class='many'>텐바이텐 배송상품<br><em>무료배송 쿠폰</em><span>2장</span></div></li></ul></div><div class='more-benefit'><ul><li><p>2만원 이상 구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em></div></li><li><p>상품 주문 금액의</p><div><em>1%</em><br>마일리지 적립</div></li><li><p>생일 축하 쿠폰</p><div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div></li></ul></div></div></div>" 'VIP

		Case 3 : gradebenefit = "<div class='vipgold'><p class='grade'>VIP GOLD</p><div class='benefit'><div class='coupon'><ul><li><p>최대 2만원 할인</p><div><em>10%</em> 할인쿠폰</div></li><li><p>최대 1만원 할인</p><div><em>5%</em> 할인쿠폰</div></li><li><p>7만원 이상 구매 시</p><div><em>5천원</em> 할인쿠폰</div></li><li><p>텐텐배송상품 구매 시</p><div class='many'><em>무료배송</em> 쿠폰<span>2장</span></div></li></ul></div><div class='more-benefit'><ul><li><p>1만원 이상 구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em></div></li><li><p>상품 주문 금액의</p><div><em>1%</em><br>마일리지 적립</div></li><li><p>홀수달, 신청/확인시</p><div><em>히치하이커</em> 제공</div></li><li><p>생일 축하 쿠폰</p><div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div></li></ul></div></div></div>" 'VIP GOLD

		Case 4 : gradebenefit = "<div class='vvip'><p class='grade'>VVIP</p><div class='benefit'><div class='coupon'><ul class='coupon'><li><p>최대 2만원 할인</p><div class='many'><em>10%</em> 할인쿠폰<span>2장</span></div></li><li><p>최대 1만원 할인</p><div class='many'><em>5%</em> 할인쿠폰<span>2장</span></div></li><li><p>20만원 이상 구매 시</p><div><em>3만원</em> 할인쿠폰</div></li><li><p>10만원 이상 구매 시</p><div><em>1만원</em> 할인쿠폰</div></li></ul></div><div class='more-benefit'><ul class='more-benefit'><li><p>구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em></div></li><li><p>상품 주문 금액의</p><div><em>1.3%</em><br>마일리지 적립</div></li><li><p>홀수달, 신청/확인시</p><div><em>히치하이커</em> 제공</div></li><li><p>생일 축하 쿠폰</p><div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div></li></ul></div></div></div>" 'VVIP

		Case 5 : gradebenefit = "<div class='white'><p class='grade'>WHITE</p><div class='benefit'><div class='coupon'><ul><li><p>5만원 이상 구매 시</p><div><em>2천원</em> 할인쿠폰</div></li><li><p>2만원 이상 구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em> 쿠폰</div></li></ul></div><div class='more-benefit'><ul><li><p>3만원 이상 구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em></div></li><li><p>상품 주문 금액의</p><div><em>0.5%</em><br>마일리지 적립</div></li><li><p>생일 축하 쿠폰</p><div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div></li></ul></div></div></div>" 'WHITE

		Case 6 : gradebenefit = "<div class='vvip'><p class='grade'>VVIP</p><div class='benefit'><div class='coupon'><ul class='coupon'><li><p>3만원 이상 구매 시</p><div class='many'><em>10%</em> 할인쿠폰<span>2장</span></div></li><li><p>최대 2만원 할인</p><div class='many'><em>5%</em> 할인쿠폰<span>2장</span></div></li><li><p>20만원 이상 구매 시</p><div><em>3만원</em> 할인쿠폰</div></li><li><p>10만원 이상 구매 시</p><div><em>1만원</em> 할인쿠폰</div></li></ul></div><div class='more-benefit'><ul class='more-benefit'><li><p>구매 시</p><div>텐바이텐 배송상품<br><em>무료배송</em></div></li><li><p>상품 주문 금액의</p><div><em>1.3%</em><br>마일리지 적립</div></li><li><p>홀수달, 신청/확인시</p><div><em>히치하이커</em> 제공</div></li><li><p>생일 축하 쿠폰</p><div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div></li></ul></div></div></div>" 'VVIP

		Case Else
			gradebenefit = "" 'STAFF
	End select
End Function
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function(){

});
</script>
</head>
<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->

	<!-- contents -->
	<div id="content" class="content membershipV18">
		<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
			<ul class="grid2">
				<li><a href="/my10x10/userinfo/mygrade.asp" class="on">나의 등급</a></li>
				<li><a href="/my10x10/userinfo/mybadge.asp">나의 뱃지</a></li>
			</ul>
		</div>
		<div class="my-grade g-<%=GetUserStr(GetLoginUserLevel)%>">
			<div class="icon-grade"></div>
			<div class="info">
				<p class="grade"><%=tmpCSLeftMenuUserLevel%></p>
				<p class="name"><%=getLoginUserName%></p>
			</div>
			<%'!-- for dev msg <em>..</em>의 width 값으로 퍼센트의 컨트롤이 가능합니다.--%>
			<div class="gage-bar"><span><em style="width:<%=stroke1%>%;"><b><%=stroke1%>%</b></em></span></div>
			<% If stroke1 = 100 Then %>
			<div class="next-grade">등급 <%=chkiif(GetLoginUserLevel = 4 Or GetLoginUserLevel = 7,"유지","상승")%>조건 달성!<br><em><%= month(dateadd("m",1,date)) %></em>월의 예상등급은 <em><%= GetUserLevelStr(NextuserLevel)%></em> 입니다.</div>
			<% Else %>
			<div class="next-grade"><% If GetLoginUserLevel <> 4 Or GetLoginUserLevel <> 7 Then %><em><%= getRequireLevelUpBuyCountVer2(NextuserLevel2,BuyCount) %></em>번의 주문 또는 <% End If %><em><%= FormatNumber(getRequireLevelUpBuySumVer2(NextuserLevel2,BuySum),0) %></em>원 이상 결제 시<br><em><%= GetUserLevelStr(NextuserLevel2)%></em>로 등급 <%=chkiif(GetLoginUserLevel = 4 Or GetLoginUserLevel = 7,"유지","상승")%>!</div>
			<% End If %>
			<a href="/my10x10/userinfo/grade_guide.asp" class="btn-guide btn btn-xsmall btn-radius color-black btn-icon">등급별 혜택<span class="icon icon-arrow"></span></a>
		</div>
		<% If GetLoginUserLevel <> 7 then %>
		<div class="benefit-guide benefit">
			<div class="inner">
				<%'!-- 내가 받고 있는 혜택 --%>
				<div class="now-benefit grade-guide">
					<h3>내가 받고 있는 혜택</h3>
					<%=gradebenefit(GetLoginUserLevel)%>
				</div>
			</div>
		</div>
		<% End If %>
	</div>
	<!-- //contents -->

	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->