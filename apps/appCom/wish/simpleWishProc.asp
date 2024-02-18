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
' PageName : /apps/appCom/wish/simpleWishProc.asp
' Discription : Wish APP Wish Collection 페이지 상품출력
' Request : json > type, productid
' Response : response > 결과, wish > id,numofwish, product(array)
' History : 2013.12.20 허진원 : 신규 생성
'           2014.01.13 허진원 : 상품 추가 정보 추가
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sSize, sItemid, sFDesc, i, j
Dim sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid
dim userid
Dim sData : sData = Request("json")
Dim oJson

sSize = 5	'접수할 회원 수

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sItemid = getNumeric(oResult.productid)		'상품ID

	'검색 필터 분해
	call getParseFilter(oResult.filter,sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif sType<>"simple_wish_collection" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
elseif sItemid="" then
	'// 파라매터 오류
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."
else
	'// 로그인 사용자
	userid = GetLoginUserID

	dim oUserList, oItemList
	
	'// 위시 회원 목록 접수
	set oUserList = new CWish
	oUserList.FPageSize = sSize
	oUserList.FRectUserID = userid		'본인 제외
	oUserList.FRectItemid = sItemid		'검색할 상품번호
	oUserList.getWishUserFromItem()

	'// 결과 출력
	if oUserList.FResultCount>0 then
		oJson("response") = getErrMsg("1000",sFDesc)
		Set oJson("user") = jsArray()

		for i=0 to oUserList.FResultCount-1

			Set oJson("user")(null) = jsObject()
			oJson("user")(null)("id") = oUserList.FItemList(i).Fuserid
			oJson("user")(null)("numofwish") = oUserList.FItemList(i).FfavCount			'사용자의 위시 수
	
			'해당 회원의 위시 상품 접수
			set oItemList = new CWish
			oItemList.FPageSize = 5				'최대 상품수 5개
			oItemList.FRectIsInclude = "Y"		'내상품 포함 (A:기본적으로 빼고 없으면 포함, Y:포함, N:제외, X:매칭만)
			oItemList.FRectItemid = sItemid		'제외 상품
			oItemList.FRectUserID = oUserList.FItemList(i).Fuserid
			oItemList.FRectMyUID = userid
			oItemList.FRectSort = sortMtd
			oItemList.FRectPrcMin = priceMin
			oItemList.FRectPrcMax = priceMax
			oItemList.FRectColorCd = colorCd
			oItemList.FRectCateCd = dispCate
			''oItemList.FRectKeyword = keyword		'검색어 사용안함 > 마이 느림
			oItemList.FRectMakerid = makerid
			Set oJson("user")(null)("product") = oItemList.getWishItemListJson()
			set oItemList = Nothing

		next
	else
		'oJson("response") = getErrMsg("9999",sFDesc)
		'oJson("faildesc") = "위시 정보가 없습니다."

		oJson("response") = getErrMsg("1000",sFDesc)
		Set oJson("user") = jsArray()

	end if

	set oUserList = Nothing
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->