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
' PageName : /apps/appCom/wish/mainPageMoreProc.asp
' Discription : Wish APP 메인 페이지 더보기 시 추가 상품출력
' Request : json > type, id, filter, offset, size, OS, versioncode, versionname, verserion
' Response : response > 결과, id, requestoffset, requestsize, product(array)
' History : 2014.01.13 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sUId, sOffset, sSize, sFDesc, i, j
Dim sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid
dim userid, itemSort
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sUId = requestCheckVar(oResult.id,32)				'대상 회원ID
	sOffset = getNumeric(requestCheckVar(oResult.offset,8))		'페이지 시작지점
	sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수

	'검색 필터 분해
	call getParseFilter(oResult.filter,sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif sType<>"main_wish_more" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
else
	'// 로그인 사용자
	userid = GetLoginUserID

	dim oItemList

	'정렬방법
	if sortMtd="sale" or sortMtd="highprice" or sortMtd="lowprice" then
		itemSort=sortMtd
	else
		itemSort = "new"
	end if
	
	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("id") = sUid
	oJson("requestoffset") = sOffset			'시작지점
	oJson("requestsize") = sSize				'페이지당 수
		
	'// 회원의 추가 상품 목록 접수
	set oItemList = new CWish
	oItemList.FPageSize = sSize
	oItemList.FstartPos = (sOffset+1)
	oItemList.FRectIsInclude = "A"		'내상품 포함 (A:기본적으로 빼고 없으면 포함, Y:포함, N:제외, X:매칭만)
	oItemList.FRectUserID = sUid
	oItemList.FRectMyUID = userid
	oItemList.FRectSort = itemSort
	oItemList.FRectPrcMin = priceMin
	oItemList.FRectPrcMax = priceMax
	oItemList.FRectColorCd = colorCd
	oItemList.FRectCateCd = dispCate
	''oItemList.FRectKeyword = keyword
	''oItemList.FRectMakerid = makerid
	Set oJson("product") = oItemList.getWishItemListJson()
	set oItemList = Nothing	

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->