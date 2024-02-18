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
' PageName : /apps/appCom/wish/searchItemProc.asp
' Discription : Wish APP 상품 검색 목록 출력 (검색엔진 사용)
' Request : json > type, offset, size, filter, OS, versioncode, versionname, verserion
' Response : response > 결과, requestoffset, requestsize, numofproduct, product(array), firstcategorylist(array), secondcategorylist(array)
' History : 2014.01.14 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sKind, sUId, sOffset, sSize, sFDesc, i, j
Dim sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
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
elseif sType<>"searchlist" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
else
	dim oItemList, oDoc, listDiv, SearchItemDiv

	'검색 유형 설정
	if dispCate<>"" then
		listDiv = "list"
		SearchItemDiv = "n"
	elseif keyword<>"" then
		listDiv = "search"
		SearchItemDiv = "y"
	elseif makerid<>"" then
		listDiv = "brand"
		SearchItemDiv = "y"
	elseif colorCd<>"" then
		listDiv = "colorlist"
		SearchItemDiv = "y"
	else
		listDiv = "list"
		SearchItemDiv = "y"
	end if

	'#검색엔진에서 상품검색
	set oDoc = new SearchItemCls
	oDoc.FListDiv = listDiv
	oDoc.FRectSearchTxt = keyword
	oDoc.FRectSortMethod	= sortMtd
	oDoc.FRectSearchFlag = ""
	oDoc.FRectSearchItemDiv = SearchItemDiv		'기본카테고리 검색 여부
	oDoc.FRectSearchCateDep = "T"		'하위 카테고리 검색 여부
	oDoc.FRectCateCode	= dispCate
	oDoc.FRectMakerid	= makerid
	if priceMin>0 then oDoc.FminPrice	= priceMin
	if priceMax>0 then oDoc.FmaxPrice	= priceMax
	oDoc.StartNum = sOffset			'검색 시작 지점
	oDoc.FPageSize = sSize			'검색 페이지 단위
	oDoc.FLogsAccept = false		'로그 없음
	oDoc.FcolorCode = colorCd

	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("requestoffset") = sOffset			'시작지점
	oJson("requestsize") = sSize				'페이지당 수

	Set oJson("product") = oDoc.getSearchListJson()	'상품목록(array) 반환
	oJson("numofproduct") = cStr(oDoc.FTotalCount)		'전체 검색수

	if sOffset="" or sOffset="0" then
		'첫페이지만 카테고리 목록 출력
		Set oItemList = new CWish
	
		if dispCate<>"" then
			dim sDep
			sDep = cStr(len(dispCate)\3)+1			'하위 뎁스

			'// 키워드검색, 브랜드검색, 3depth은 검색엔진, 그렇지 않으면 모두 DB사용
			if sDep>4 or (keyword="" and makerid="") then
				'1st 카테고리
				oItemList.FRectCateCd = left(dispCate,(sDep-2)*3)
				Set oJson("firstcategorylist") = oItemList.getDispCategoryListJson(sDep-1)

				'2nd 카테고리
				oItemList.FRectCateCd = dispCate
				Set oJson("secondcategorylist") = oItemList.getDispCategoryListJson(sDep)
			else
				'1st 카테고리
				if sDep<2 then sDep=2
				if sDep>2 then
					oDoc.FRectCateCode = left(dispCate,(sDep-2)*3)
				else
					oDoc.FRectCateCode = " "
				end if
				oDoc.FGroupScope = sDep-1
				Set oJson("firstcategorylist") = oDoc.getGroupbyCategoryListJson()

				'2nd 카테고리
				if sDep>3 then
					Set oJson("secondcategorylist") = jsArray()			'4뎁스 이상은 표시안함(2014.02.11;허진원)
				else
					oDoc.FRectCateCode = left(dispCate,(sDep-1)*3)
					oDoc.FGroupScope = sDep
					Set oJson("secondcategorylist") = oDoc.getGroupbyCategoryListJson()
				end if
			end if
		else
			''Set oJson("firstcategorylist") = oItemList.getDispCategoryListJson("1")
			oDoc.FGroupScope = 1
			Set oJson("firstcategorylist") = oDoc.getGroupbyCategoryListJson()
			Set oJson("secondcategorylist") = jsArray()
		end if
	
		Set oItemList = Nothing
	else
		'카테고리 출력 안함
		Set oJson("firstcategorylist") = jsArray()
		Set oJson("secondcategorylist") = jsArray()
	end if

	'// 선택된 FirstCatogory명 출력
	oJson("firstcategory") = CategoryNameUseLeftMenuDB(dispCate)

	set oDoc = Nothing
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->