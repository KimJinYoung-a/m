<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim ListDiv : ListDiv = "search" '카테고리/검색 구분용
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim LogsAccept : LogsAccept = true
	dim lp, i
	dim DocSearchText
	dim CheckResearch : CheckResearch= request("chkr")
	dim CheckExcept : CheckExcept= request("chke")
	dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
	dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
	Dim tmpPrevSearchKeyword , tmpCurrSearchKeyword
	Dim PrevSearchText : PrevSearchText = requestCheckVar(request("prvtxt"),100) '이전 검색어
	Dim isSaveSearchKeyword : isSaveSearchKeyword = true  ''검색어 DB에 저장 여부 X => procMySearchKeyword(쿠키)

	Dim vCateDepth, vWishArr


	dim ScrollCount : ScrollCount = 4
	if CurrPage="" then CurrPage=1
	if PageSize="" then PageSize=16


	if CheckResearch="undefined" then CheckResearch=""
	if len(CheckResearch)>5 then CheckResearch=""
	IF CheckResearch="" then CheckResearch=false
	if CheckExcept="undefined" then CheckExcept=""
	if len(CheckExcept)>5 then CheckExcept=""
	IF CheckExcept="" then CheckExcept=false

	SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")
	ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")

	IF CheckReSearch Then
		''ReSearchText = ReSearchText & " " & SearchText

		ReSearchText = RepWord(ReSearchText,SearchText,"")
		ReSearchText = RepWord(ReSearchText,"[\s]{2,}"," ")
		ReSearchText = RepWord(ReSearchText,"^[+\s]","")
		ReSearchText = ReSearchText & " " & SearchText
		DocSearchText = ReSearchText
	Else
		ReSearchText  =	SearchText
		DocSearchText = SearchText
	End if

	if CheckExcept then
		ReSearchText  =	ReSearchText
		DocSearchText = ReSearchText
		SearchText = ExceptText
	end if

	'특정 단어 삭제
	DocSearchText = Trim(Replace(DocSearchText,"상품",""))

	IF Len(DocSearchText)<>0 and isNumeric(DocSearchText) THEN
		If Left(DocSearchText,1) <> "0" Then
			DocSearchText = Cdbl(DocSearchText)
		End If
	'	DocSearchText = Cdbl(DocSearchText)
	END IF

	'// 검색어 DB저장
	tmpPrevSearchKeyword = PrevSearchText
	tmpCurrSearchKeyword = SearchText

	'검색 로그 저장 여부
	IF CStr(SearchText)=CStr(PrevSearchText) Then
		LogsAccept = false
	End if

    '// 검색 조건 재설정 //2015/03/12 추가 (기존에 없었음)
    PrevSearchText = SearchText


	'// 상품검색
	dim oDoc,iLp
	set oDoc = new SearchPlayingCls
	oDoc.FRectSearchTxt = DocSearchText
	oDoc.FCurrPage = CurrPage
	oDoc.FPageSize = 16
	oDoc.FScrollCount =10
	oDoc.getPlayingList2017

	'//logparam
	Dim logparam : logparam = "&pRtr="& server.URLEncode(SearchText)


	'####### PLAYing, 기획전/이벤트 만들어 넣을 곳
	Dim vEventBody, vPlayingBody, vExhibiBody, vEnm, oDocPl, oGrEvt
	

	Dim rcParam
	For i=0 To oDoc.FResultCount-1
		'클릭 위치 Parameter 추가
		rcParam = "&rc=rpos_" & CurrPage &"_" & (i+1)

		vPlayingBody = "<li class=""playing"">"
		If oDoc.FItemList(i).Fimg28 <> "" Then
			vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDoc.FItemList(i).Fdidx& logparam & rcParam &""" style=""background-image:url(" & oDoc.FItemList(i).Fimg28 & ");"">"
		Else
			If oDoc.FItemList(i).Fmo_bgcolor <> "" Then
				vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDoc.FItemList(i).Fdidx&logparam&rcParam&""" style=""background-color:#" & oDoc.FItemList(i).Fmo_bgcolor & ";"">"
			Else
				vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDoc.FItemList(i).Fdidx&logparam&rcParam&""" style=""background-color:#ffdddb;"">"
			End If
		End IF
		vPlayingBody = vPlayingBody & "<div class=""desc""><p class=""name"">" & db2html(oDoc.FItemList(i).Ftitle) & "</p></div></a></li>"
		
		Response.Write vPlayingBody
							
	Next

set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->