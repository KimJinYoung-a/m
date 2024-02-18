<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/wishCls.asp"-->
<!-- #include virtual="/apps/appCom/wish/searchItemCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/brandMatchProc.asp
' Discription : Wish APP 브랜드내에 내가 위시한 상품 목록 출력
' Request : json > type, brandid, offset, size, OS, versioncode, versionname, verserion
' Response : response > 결과, requestoffset, requestsize, brandid, product(array)
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sMakerid, sOffset, sSize, sFDesc, i
Dim sData : sData = Request("json")
Dim oJson, userid

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sMakerid = requestCheckVar(oResult.brandid,32)
	sOffset = getNumeric(requestCheckVar(oResult.offset,8))		'페이지 시작지점
	sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"brandmatchlist" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sMakerid="" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터가 없습니다."

elseif IsUserLoginOK then
	'// 로그인 사용자
	userid = GetLoginUserID

	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("brandid") = sMakerid
	oJson("requestoffset") = sOffset			'시작지점
	oJson("requestsize") = sSize				'페이지당 수

	'브랜드 상품
'	dim oDoc
'	set oDoc = new SearchItemCls
'	oDoc.FListDiv = "brand"
'	oDoc.FRectSearchItemDiv = "y"
'	oDoc.FRectSearchCateDep = "T"
'	oDoc.FRectMakerid	= sMakerid
'	oDoc.StartNum = sOffset
'	oDoc.FPageSize = sSize
'	oDoc.FLogsAccept = false		'로그 없음
'	Set oJson("product") = oDoc.getSearchListJson()	'상품목록(array) 반환
'	set oDoc = Nothing

	dim oItemList
	set oItemList = new CWish
	oItemList.FstartPos = (sOffset+1)		'검색 시작지점
	oItemList.FPageSize = sSize				'결과수
	oItemList.FRectIsInclude = "X"			'내상품 포함 (A:기본적으로 빼고 없으면 포함, Y:포함, N:제외, X:매칭만)
	oItemList.FRectUserID = userid
	oItemList.FRectMyUID = userid
	oItemList.FrectIsSell = "Y"				'판매중인 상품만
	oItemList.FRectMakerid = sMakerid		'브랜드 상품
	Set oJson("product") = oItemList.getWishItemListJson()
	set oItemList = Nothing
else
	'// 로그인 필요
	oJson("response") = getErrMsg("9000",sFDesc)
	oJson("faildesc") =	sFDesc
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->