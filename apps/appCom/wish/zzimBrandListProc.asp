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
' PageName : /apps/appCom/wish/zzimBrandListProc.asp
' Discription : Wish APP 나의 찜브랜드 목록 출력
' Request : json > type, offset, size, brandtype, categoryid, OS, versioncode, versionname, verserion
' Response : response > 결과, requestoffset, requestsize, brand(array), category(array), brandtype
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sOffset, sKind, sSort, sSize, sCate, sFDesc, sBrdTp, i
Dim sData : sData = Request("json")
Dim oJson, userid

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sOffset = getNumeric(requestCheckVar(oResult.offset,8))		'페이지 시작지점
	sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수
	sCate = getNumeric(requestCheckVar(oResult.categoryid,16))		'전시 카테고리(1depth)
	sKind = oResult.kind			'브랜드 출력 범위 (simple, full)
	sSort = oResult.sort			'브랜드 정렬순서 (date, name)
	sBrdTp = oResult.brandtype		'찜브랜드 로직(my:나의찜브랜드, recommend:추천 찜브랜드)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"zzimbrand" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

else
	'// 로그인 사용자
	userid = GetLoginUserID

	dim oItemList

	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("requestoffset") = sOffset			'시작지점
	oJson("requestsize") = sSize				'페이지당 수

	Set oItemList = new CWish

	oItemList.FstartPos = sOffset+1
	oItemList.FPageSize = sSize
	oItemList.FRectUserID=userid
	oItemList.FRectSort=sSort					'브랜드 정렬(name:이름순, date:최근찜순)
	oItemList.FRectCateCd=sCate

	'브랜드 목록
	if sKind="simple" then
		Select Case sBrdTp
			Case "my"
				oItemList.FRectIsInclude="A"				'나의 찜브랜드 여부 (A:자동으로 취합, Y:나의 찜브랜드, N:추천 찜브랜드)
			Case "recommend"
				oItemList.FRectIsInclude="N"
			Case Else
				oItemList.FRectIsInclude="A"
		End Select 
		Set oJson("brand") = oItemList.getMyBrandSimpleListJson()
	else
		Select Case sBrdTp
			Case "my"
				oItemList.FRectIsInclude="Y"
			Case "recommend"
				oItemList.FRectIsInclude="N"
			Case Else
				oItemList.FRectIsInclude="Y"
		End Select
		Set oJson("brand") = oItemList.getMyZzimBrandListJson()
	end if

	Set oJson("category") = oItemList.getDispCategoryListJson("1")		'1depth 카테고리

	oJson("brandtype") = chkIIF(oItemList.FRectIsInclude="Y","my","recommend")		'찜브랜드 로직(my:나의찜브랜드, recommend:추천 찜브랜드)

	Set oItemList = Nothing

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->