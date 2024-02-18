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
' PageName : /apps/appCom/wish/searchBrandProc.asp
' Discription : Wish APP 초성에 대한 브랜드 목록 출력
' Request : json > type, offset, size, firstletter, condition, tag, OS, versioncode, versionname, verserion
' Response : response > 결과, requestoffset, requestsize, firstletter, condition, tag, brand(array)
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sFLetter, sCond, sTag, sOffset, sSize, sFDesc, i
dim userid
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sFLetter = requestCheckVar(oResult.firstletter,3)
	sCond = requestCheckVar(oResult.condition,10)
	sTag = requestCheckVar(oResult.tag,64)
	sOffset = getNumeric(requestCheckVar(oResult.offset,8))		'페이지 시작지점
	sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"brandsearch" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sFLetter="" and sTag="" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터가 없습니다."

else
	'// 로그인 사용자
	userid = GetLoginUserID

	dim oItemList
	Set oItemList = new CWish
	oItemList.FstartPos = (sOffset+1)
	oItemList.FPageSize = sSize
	oItemList.FRectIsInclude="N"				'나의 찜브랜드 여부 (A:자동으로 취합, Y:나의 찜브랜드, N:추천 찜브랜드)
	oItemList.FRectSort = "kor"					'이름으로 정렬 (kor:가나다, eng:ABC)
	oItemList.FRectKeyType = sFLetter			'초성필터
	oItemList.FRectAttrib = sCond				'속성필터(new, best, only, artist, k-design, none)
	oItemList.FRectUserID = userid
	if sTag<>"none" then oItemList.FRectKeyword= sTag	'Tag필터
	oItemList.FRectSort="best"

	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("requestoffset") = sOffset			'시작지점
	oJson("requestsize") = sSize				'페이지당 수
	oJson("firstletter") = sFLetter
	oJson("condition") = sCond
	oJson("tag") = sTag
	Set oJson("brand") = oItemList.getMyZzimBrandListJson()		'찜브랜드

	Set oItemList = Nothing
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->