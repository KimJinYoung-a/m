<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbAppWishopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/wishCls2nd.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/mainPageProc.asp
' Discription : Wish APP 메인 페이지 상품출력
' Request : json > type, kind, categoryid, filter(array), OS, versioncode, versionname, verserion
' Response : response > 결과, wish > id,numofmate, product(array)
' History : 2013.12.13 허진원 : 신규 생성
'           2014.01.02 허진원 : 상품 추가 정보 추가
'           2014.10.10 허진원 : 구분, 카테고리, 검색필터 추가
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sKind, sOffset, sSize, sCateCd, sFDesc, i, j
Dim sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid
dim userid, itemSort
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sKind = oResult.kind			'용도구분
	sOffset = getNumeric(requestCheckVar(oResult.offset,8))		'페이지 시작지점
	sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수
	sCateCd = getNumeric(requestCheckVar(oResult.categoryid,16))

	'검색 필터 분해
	call getParseFilter(oResult.filter,sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid)
set oResult = Nothing

dim oUserList, oItemList

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif sType<>"mainpage" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
elseif IsUserLoginOK then
	'// 로그인 사용자
	userid = GetLoginUserID

	'// 위시 회원 목록 접수
	set oUserList = new CWish
	oUserList.FPageSize = sSize
	oUserList.FstartPos = (sOffset+1)
	oUserList.FRectUserID = userid
	oUserList.FRectSort = sortMtd

	Select Case sKind
		Case "wishmate"
			'동일한 상품을 가진 다른 불특정 회원 목록
			oUserList.getWisMatchUser()
		Case "mateswish"
			'내가 팔로우한 회원 목록
			oUserList.getFollowUser()
		Case "10x10pick"
			'위시 트랜드
			oUserList.FRectLimitCnt = 30	'최소 표시수
			oUserList.getWishTrendUser()
		Case "wishcategories"
			'카테고리별 상품-위시 회원 목록
			if sCateCd<>"" then
				dispCate = left(sCateCd,3)
			else
				sCateCd = left(dispCate,3)
			end if
			oUserList.FRectCateCd = sCateCd
			oUserList.getCategoyWishUser()
		Case Else
			oUserList.getWisMatchUser()
	end Select

	if sortMtd="sale" or sortMtd="highprice" or sortMtd="lowprice" then
		itemSort=sortMtd
	else
		itemSort = "new"
	end if

	'// 결과 출력
	if oUserList.FResultCount>0 then
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("requestoffset") = sOffset			'시작지점
		oJson("requestsize") = sSize				'페이지당 수
		oJson("kind") = sKind						'용도구분
		oJson("categoryid") = dispCate				'카테고리
		oJson("checkresult") = cStr(oUserList.FchkResult)	'팔로우 여부(sKind: mateswish일 때)
		
	
		Set oJson("wish") = jsArray()

		for i=0 to oUserList.FResultCount-1

			Set oJson("wish")(null) = jsObject()
			oJson("wish")(null)("id") = oUserList.FItemList(i).Fuserid
			oJson("wish")(null)("numofmate") = cStr(oUserList.FItemList(i).FwishMateItemCnt)	'위시 매치 수
	
			'해당 회원의 위시 상품 접수
			set oItemList = new CWish
			oItemList.FPageSize = 5				'최대 상품수 5개
			oItemList.FRectIsInclude = "A"		'내상품 포함 (A:기본적으로 빼고 없으면 포함, Y:포함, N:제외, X:매칭만)
			oItemList.FRectUserID = oUserList.FItemList(i).Fuserid
			oItemList.FRectMyUID = userid
			oItemList.FRectSort = itemSort
			oItemList.FRectPrcMin = priceMin
			oItemList.FRectPrcMax = priceMax
			oItemList.FRectColorCd = colorCd
			oItemList.FRectCateCd = dispCate
			''oItemList.FRectKeyword = keyword
			''oItemList.FRectMakerid = makerid
			Set oJson("wish")(null)("product") = oItemList.getWishItemListJson()
			set oItemList = Nothing

		next
	else
		'oJson("response") = getErrMsg("9999",sFDesc)
		'oJson("faildesc") = "위시 정보가 없습니다."

		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("requestoffset") = sOffset			'시작지점
		oJson("requestsize") = sSize				'페이지당 수
		oJson("kind") = sKind						'용도구분
		oJson("categoryid") = ""					'카테고리
		oJson("checkresult") = "0"
	
		Set oJson("wish") = jsArray()

	end if

	set oUserList = Nothing
else
	'// 위시 회원 목록 접수(비회원)
	set oUserList = new CWish
	oUserList.FPageSize = sSize
	oUserList.FstartPos = (sOffset+1)
	oUserList.FRectSort = sortMtd

	Select Case sKind
		Case "10x10pick"
			'위시 트랜드
			oUserList.FRectLimitCnt = 50	'최소 표시수
			oUserList.getWishTrendUser()
		Case "wishcategories"
			'카테고리별 상품-위시 회원 목록
			if sCateCd<>"" then
				dispCate = left(sCateCd,3)
			else
				sCateCd = left(dispCate,3)
			end if
			oUserList.FRectCateCd = sCateCd
			oUserList.getCategoyWishUser()
		Case Else
			'랜덤(비회원): 최근 위시한 고객 목록
			oUserList.getRecentWishUser()
	end Select

	if sortMtd="sale" or sortMtd="highprice" or sortMtd="lowprice" then
		itemSort=sortMtd
	else
		itemSort = "new"
	end if

	'// 결과 출력
	if oUserList.FResultCount>0 then
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("requestoffset") = sOffset			'시작지점
		oJson("requestsize") = sSize				'페이지당 수
		oJson("kind") = sKind						'용도구분
		oJson("categoryid") = dispCate				'카테고리
		oJson("checkresult") = "0"
		
	
		Set oJson("wish") = jsArray()

		for i=0 to oUserList.FResultCount-1

			Set oJson("wish")(null) = jsObject()
			oJson("wish")(null)("id") = oUserList.FItemList(i).Fuserid
			oJson("wish")(null)("numofmate") = cStr(oUserList.FItemList(i).FwishMateItemCnt)			'위시 매치 수
	
			'해당 회원의 위시 상품 접수
			set oItemList = new CWish
			oItemList.FPageSize = 5				'최대 상품수 5개
			oItemList.FRectIsInclude = "Y"		'내상품 포함 (A:기본적으로 빼고 없으면 포함, Y:포함, N:제외, X:매칭만)
			oItemList.FRectUserID = oUserList.FItemList(i).Fuserid
			oItemList.FRectMyUID = userid
			oItemList.FRectSort = itemSort
			oItemList.FRectPrcMin = priceMin
			oItemList.FRectPrcMax = priceMax
			oItemList.FRectColorCd = colorCd
			oItemList.FRectCateCd = dispCate
			Set oJson("wish")(null)("product") = oItemList.getWishItemListJson()
			set oItemList = Nothing

		next
	else
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("requestoffset") = sOffset			'시작지점
		oJson("requestsize") = sSize				'페이지당 수
		oJson("kind") = sKind						'용도구분
		oJson("categoryid") = ""					'카테고리
		oJson("checkresult") = "0"
	
		Set oJson("wish") = jsArray()
	end if

	set oUserList = Nothing
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbAppWishclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->