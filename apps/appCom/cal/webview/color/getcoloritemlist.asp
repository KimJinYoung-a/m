<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'Response.AddHeader "Cache-Control","no-cache"
'Response.AddHeader "Expires","0"
'Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 컬러 상세보기
'	History	:  2014.02.18 서동석 생성
'			   2014.02.19 한용민 수정
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/cal/webview/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->

<%
dim i, colorcode, catecode, vFListDiv, page, SortMet, vDepth
	colorcode = getNumeric(requestcheckvar(request("colorcode"),10))
	catecode = requestCheckVar(Request("disp"),3)
	page = getNumeric(requestCheckVar(Request("page"),10))
	SortMet = requestCheckVar(request("srm"),2)
	catecode = getNumeric(requestCheckVar(request("disp"),15))
	
'response.write "<script type='text/javascript'>"
'response.write "	alert('아작스페이지내부테스트:"& page &"');"
'response.write "</script>"

vDepth = "1"
If SortMet="" Then SortMet="ne"		'베스트:be, 신상:ne
if page="" then page=1

if colorcode="" then
	response.write "<script type='text/javascript'>"
	response.write "	alert('컬러코드를 정확히 입력해 주세요.');"
	response.write "</script>"
	dbget.close()	:	response.end
end if

vFListDiv = "bestlist"

'//최대 페이지수 제한. ismaxlimit가 true일경우, limitCurrPage까지만 보여줌
dim ismaxlimit, limitCurrPage
	ismaxlimit = requestCheckVar(request("ismaxlimit"),10)
	limitCurrPage = requestCheckVar(request("limitCurrPage"),10)

if ismaxlimit="" then ismaxlimit = false
if limitCurrPage="" then limitCurrPage = "30"
	
'// 상품검색
dim oDoc,iLp
set oDoc = new SearchItemCls
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchCateDep = "T"
	oDoc.FRectMakerid	= ""
	oDoc.FCurrPage = page
	oDoc.FPageSize = 8
	oDoc.FScrollCount = 5
	oDoc.FListDiv = vFListDiv
	oDoc.FLogsAccept = false
	oDoc.FRectColsSize = 6
	
	if colorcode>0 then
		oDoc.FcolorCode = Num2Str(colorcode,3,"0","R")
	end if
	
	oDoc.FRectcatecode	= catecode
	oDoc.FSellScope="Y"

	if ismaxlimit then
		if CurrPage <= limitCurrPage then
			oDoc.getSearchList
		end if
	else
		oDoc.getSearchList
	end if	
	
%>

<%
if oDoc.FResultCount>0 then

'// 검색결과 내위시 표시정보 접수
if IsUserLoginOK then
	'// 검색결과 상품목록 작성
	dim rstArrItemid: rstArrItemid=""
	for i = 0 to oDoc.FResultCount-1
		rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oDoc.FResultCount-1
	Next

	'// 위시결과 상품목록 작성
	dim rstWishItem: rstWishItem=""
	dim rstWishCnt: rstWishCnt=""
	if rstArrItemid<>"" then
		Call getMyFavItemList(getLoginUserid(),rstArrItemid,rstWishItem, rstWishCnt)
	end if
end if				
%>
<% For i = 0 To oDoc.FResultCount-1 %>
	<li class="item">
		<div>
			<span itemid="<%= oDoc.FItemList(i).fitemid %>" class="markWish <%=chkIIF(chkArrValue(rstWishItem,oDoc.FItemList(i).fitemid),"myWishPdt","")%>">관심상품(위시담기)</span>
			<% 'for dev msg : 나의 위시상품인 경우 myWishPdt 클래스명 추가 %>
			<a href="" onclick="TnGotoProduct('<%= oDoc.FItemList(i).fitemid %>'); return false;">
			<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,400,400,"true","false") %>" alt="<%= oDoc.FItemList(i).fitemname %>" /></a>
		</div>
	</li>
<% next %>
<% end if %>

<%
set oDoc=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->