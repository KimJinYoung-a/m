<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/wishCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/bestItemProc.asp
' Discription : Wish APP 베스트 Wish, Best Sale 상품 목록 출력 (popular Wish, Best Award)
' Request : json > type, kind, filter, OS, versioncode, versionname, verserion
' Response : response > 결과, kind, product(array)
' History : 2014.01.14 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sKind, sFDesc, i, j
Dim sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid
Dim sData : sData = Request("json")
Dim oJson, userid

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sKind = oResult.kind			'처리 구분

	'검색 필터 분해
	call getParseFilter(oResult.filter,sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif sType<>"best100" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
else
	'// 로그인 사용자
	userid = GetLoginUserID

	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("kind") = sKind			'처리구분

	dim oItemList

	Select Case sKind
		Case "wish"
			'Best Wish
			set oItemList = new CWish
			oItemList.FstartPos = 1				'검색 시작지점 (시작은 1부터)
			oItemList.FPageSize = 100			'결과수
			oItemList.FRectMyUID = userid
			oItemList.FRectSort = sortMtd
			oItemList.FRectPrcMin = priceMin
			oItemList.FRectPrcMax = priceMax
			oItemList.FRectColorCd = colorCd
			oItemList.FRectCateCd = dispCate
			''oItemList.FRectKeyword = keyword
			''oItemList.FRectMakerid = makerid
			''Set oJson("product") = oItemList.getPopularWishListJson()				''Popular Wish 결과
			Set oJson("product") = oItemList.getBestWishListJson()			'Best Award : wish 결과

		Case "sale"
			'Best Award - Seller 결과
			set oItemList = new CWish
			oItemList.FstartPos = 1				'검색 시작지점 (시작은 1부터)
			oItemList.FPageSize = 100			'결과수
			oItemList.FRectMyUID = userid
			oItemList.FRectSort = sortMtd
			oItemList.FRectPrcMin = priceMin
			oItemList.FRectPrcMax = priceMax
			oItemList.FRectColorCd = colorCd
			oItemList.FRectCateCd = dispCate
			''oItemList.FRectKeyword = keyword
			''oItemList.FRectMakerid = makerid
			Set oJson("product") = oItemList.getBestSellerListJson()
	End Select

end if

IF (Err) then
	Set oJson = Nothing
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->