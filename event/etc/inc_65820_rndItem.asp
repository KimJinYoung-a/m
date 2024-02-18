<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<%
	Response.Charset="UTF-8"
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : vacance for mobile & app
' History : 2015-07-01 이종화 생성
' History : 2015-08-28 유태욱 생성(한가위만 같아라)
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<%
	'// 지정된 상품들 중 1개 랜덤 출력 (2015.08.07 허진원)
	dim renloop
	dim arrItemid(28), arrItemDsc(28)
	dim itemid, dmINM, dmCp, dmIMg, dmPrc, dmDsc
	dim itmLink

	'// 날짜별 분기
	if date<="2015-09-08" then
		arrItemid(0) = 1211151 	: arrItemDsc(0) = "정여사의 사서고생한 송편"
		arrItemid(1) = 1340210 	: arrItemDsc(1) = "꿀이 아주 건강하고 달콤하군"
		arrItemid(2) = 1339802 	: arrItemDsc(2) = "작은섬 조약도 선물세트"
		arrItemid(3) = 1339801 	: arrItemDsc(3) = "감칠맛의 비법!"
		arrItemid(4) = 1343046 	: arrItemDsc(4) = "흔한 백화점 참지세트 No!"
		arrItemid(5) = 1108557 	: arrItemDsc(5) = "커피 한 잔의 여유"
		arrItemid(6) = 1212220 	: arrItemDsc(6) = "세상 모든 조미향신료 선물세트"
		arrItemid(7) = 1341358 	: arrItemDsc(7) = "바다에서 온 켈프칩 선물세트"
		arrItemid(8) = 1199661 	: arrItemDsc(8) = "3살/5살/8살 숙성 천일염 SET"
		arrItemid(9) = 1340405 	: arrItemDsc(9) = "유기농 만든 Premium Tea"
		arrItemid(10) = 1340410 	: arrItemDsc(10) = "영동명물 호두말이"
		arrItemid(11) = 1343886 	: arrItemDsc(11) = "악마의 참기름&들기름"
		arrItemid(12) = 1348529 	: arrItemDsc(12) = "옛간 장생포옛마을 참기름"
		arrItemid(13) = 1348531 	: arrItemDsc(13) = "옛간 장생포옛마을 생들기름"
		arrItemid(14) = 1343206 	: arrItemDsc(14) = "존쿡 델리미트 BEST 2호"
		arrItemid(15) = 1343205 	: arrItemDsc(15) = "존쿡 델리미트 BEST 1호"
		arrItemid(16) = 1343203 	: arrItemDsc(16) = "몬테사노 마이스터 건조육 세트"
		arrItemid(17) = 1339896 	: arrItemDsc(17) = "착한 먹거리 한과 선물"
		arrItemid(18) = 1339903 	: arrItemDsc(18) = "호두정과 선물세트"
		arrItemid(19) = 1339897 	: arrItemDsc(19) = "고급한과 선물세트(2단)"
		arrItemid(20) = 1340209 	: arrItemDsc(20) = "꿀이 아주 건강하고 달콤하군"
		arrItemid(21) = 996048 	: arrItemDsc(21) = "당산나무 벌꿀 3종"
		arrItemid(22) = 1226840 	: arrItemDsc(22) = "당산나무 집벌꿀"
		arrItemid(23) = 1340409 	: arrItemDsc(23) = "정성으로 직접 말린 감"
		arrItemid(24) = 1340408 	: arrItemDsc(24) = "감말랭이 선물세트"
		arrItemid(25) = 200038 	: arrItemDsc(25) = "해일 반건시 선물세트"
		arrItemid(26) = 1340400 	: arrItemDsc(26) = "마이빈스 더치박스 (Limited edition)"
		arrItemid(27) = 1108557 	: arrItemDsc(27) = "마이빈스 더치 기프트 (보르미올리병)"
	elseif date>="2015-09-09" and date<="2015-09-18" then
		arrItemid(0) = 1211151 	: arrItemDsc(0) = "정여사의 사서고생한 송편"
		arrItemid(1) = 1340210 	: arrItemDsc(1) = "꿀이 아주 건강하고 달콤하군"
		arrItemid(2) = 1339802 	: arrItemDsc(2) = "작은섬 조약도 선물세트"
		arrItemid(3) = 1339801 	: arrItemDsc(3) = "감칠맛의 비법!"
		arrItemid(4) = 1343046 	: arrItemDsc(4) = "흔한 백화점 참지세트 No!"
		arrItemid(5) = 1108557 	: arrItemDsc(5) = "커피 한 잔의 여유"
		arrItemid(6) = 1212220 	: arrItemDsc(6) = "세상 모든 조미향신료 선물세트"
		arrItemid(7) = 1341358 	: arrItemDsc(7) = "바다에서 온 켈프칩 선물세트"
		arrItemid(8) = 1199661 	: arrItemDsc(8) = "3살/5살/8살 숙성 천일염 SET"
		arrItemid(9) = 1340405 	: arrItemDsc(9) = "유기농 만든 Premium Tea"
		arrItemid(10) = 1340410 	: arrItemDsc(10) = "영동명물 호두말이"
		arrItemid(11) = 1343886 	: arrItemDsc(11) = "악마의 참기름&들기름"
		arrItemid(12) = 1348529 	: arrItemDsc(12) = "옛간 장생포옛마을 참기름"
		arrItemid(13) = 1348531 	: arrItemDsc(13) = "옛간 장생포옛마을 생들기름"
		arrItemid(14) = 1343206 	: arrItemDsc(14) = "존쿡 델리미트 BEST 2호"
		arrItemid(15) = 1343205 	: arrItemDsc(15) = "존쿡 델리미트 BEST 1호"
		arrItemid(16) = 1343203 	: arrItemDsc(16) = "몬테사노 마이스터 건조육 세트"
		arrItemid(17) = 1339896 	: arrItemDsc(17) = "착한 먹거리 한과 선물"
		arrItemid(18) = 1339903 	: arrItemDsc(18) = "호두정과 선물세트"
		arrItemid(19) = 1339897 	: arrItemDsc(19) = "고급한과 선물세트(2단)"
		arrItemid(20) = 1340209 	: arrItemDsc(20) = "꿀이 아주 건강하고 달콤하군"
		arrItemid(21) = 996048 	: arrItemDsc(21) = "당산나무 벌꿀 3종"
		arrItemid(22) = 1226840 	: arrItemDsc(22) = "당산나무 집벌꿀"
		arrItemid(23) = 1340409 	: arrItemDsc(23) = "정성으로 직접 말린 감"
		arrItemid(24) = 1340408 	: arrItemDsc(24) = "감말랭이 선물세트"
		arrItemid(25) = 200038 	: arrItemDsc(25) = "해일 반건시 선물세트"
		arrItemid(26) = 1340400 	: arrItemDsc(26) = "마이빈스 더치박스 (Limited edition)"
		arrItemid(27) = 1108557 	: arrItemDsc(27) = "마이빈스 더치 기프트 (보르미올리병)"
	elseif date>="2015-09-19" then
		arrItemid(0) = 1211151 	: arrItemDsc(0) = "정여사의 사서고생한 송편"
		arrItemid(1) = 1340210 	: arrItemDsc(1) = "꿀이 아주 건강하고 달콤하군"
		arrItemid(2) = 1339802 	: arrItemDsc(2) = "작은섬 조약도 선물세트"
		arrItemid(3) = 1339801 	: arrItemDsc(3) = "감칠맛의 비법!"
		arrItemid(4) = 1343046 	: arrItemDsc(4) = "흔한 백화점 참지세트 No!"
		arrItemid(5) = 1108557 	: arrItemDsc(5) = "커피 한 잔의 여유"
		arrItemid(6) = 1212220 	: arrItemDsc(6) = "세상 모든 조미향신료 선물세트"
		arrItemid(7) = 1341358 	: arrItemDsc(7) = "바다에서 온 켈프칩 선물세트"
		arrItemid(8) = 1199661 	: arrItemDsc(8) = "3살/5살/8살 숙성 천일염 SET"
		arrItemid(9) = 1340405 	: arrItemDsc(9) = "유기농 만든 Premium Tea"
		arrItemid(10) = 1340410 	: arrItemDsc(10) = "영동명물 호두말이"
		arrItemid(11) = 1343886 	: arrItemDsc(11) = "악마의 참기름&들기름"
		arrItemid(12) = 1348529 	: arrItemDsc(12) = "옛간 장생포옛마을 참기름"
		arrItemid(13) = 1348531 	: arrItemDsc(13) = "옛간 장생포옛마을 생들기름"
		arrItemid(14) = 1343206 	: arrItemDsc(14) = "존쿡 델리미트 BEST 2호"
		arrItemid(15) = 1343205 	: arrItemDsc(15) = "존쿡 델리미트 BEST 1호"
		arrItemid(16) = 1343203 	: arrItemDsc(16) = "몬테사노 마이스터 건조육 세트"
		arrItemid(17) = 1339896 	: arrItemDsc(17) = "착한 먹거리 한과 선물"
		arrItemid(18) = 1339903 	: arrItemDsc(18) = "호두정과 선물세트"
		arrItemid(19) = 1339897 	: arrItemDsc(19) = "고급한과 선물세트(2단)"
		arrItemid(20) = 1340209 	: arrItemDsc(20) = "꿀이 아주 건강하고 달콤하군"
		arrItemid(21) = 996048 	: arrItemDsc(21) = "당산나무 벌꿀 3종"
		arrItemid(22) = 1226840 	: arrItemDsc(22) = "당산나무 집벌꿀"
		arrItemid(23) = 1340409 	: arrItemDsc(23) = "정성으로 직접 말린 감"
		arrItemid(24) = 1340408 	: arrItemDsc(24) = "감말랭이 선물세트"
		arrItemid(25) = 200038 	: arrItemDsc(25) = "해일 반건시 선물세트"
		arrItemid(26) = 1340400 	: arrItemDsc(26) = "마이빈스 더치박스 (Limited edition)"
		arrItemid(27) = 1108557 	: arrItemDsc(27) = "마이빈스 더치 기프트 (보르미올리병)"
	end if

	randomize
	renloop=int(Rnd*(ubound(arrItemid)))

	itemid = arrItemid(renloop)
	dmCp = arrItemDsc(renloop)

	'// 상품 링크
	if isApp then
		itmLink = "fnAPPpopupProduct('" & itemid & "');"
	else
		itmLink = "parent.location.href='/category/category_itemPrd.asp?itemid=" & itemid & "';"
	End If

	// 상품 정보 접수
	dim oItem
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount>0 then
		dmINM = oItem.Prd.FItemName
		''dmIMg = oItem.Prd.FImageBasic
		dmIMg = getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false")
		dmPrc = oItem.Prd.getRealPrice
		IF oItem.Prd.IsSaleItem Then
			dmDsc = oItem.Prd.getSalePro
		End IF
	end if
	set oItem = Nothing
%>
<a href="" onclick="<%=itmLink%>;return false;">
	<div class="figure"><img src="<%=dmIMg%>" alt="<%=replace(dmINM,"""","")%>" /></div>
	<p class="pName"><%=dmCp%></p>
	<p class="pPrice"><%=formatNumber(dmPrc,0)%>원 <% if dmDsc<>"" then %><span class="cRd1">[<%=dmDsc%>]</span><% end if %></p>
</a>
<!-- #include virtual="/lib/db/dbclose.asp" -->