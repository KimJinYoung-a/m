<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
'//json 선언
Dim obj ,json
Set obj = jsObject()
Set json = jsArray()
Set	json(null) = obj ''배열 처리 따로 해줘야함
'//json 선언

Function callsearchitemtojson(SearchText,knum)
	dim SearchItemDiv	: SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep	: SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SortMet			: SortMet="be"		'베스트:be, 신상:ne
	dim SearchFlag		: searchFlag= "n"
	dim ListDiv			: ListDiv = "search" '카테고리/검색 구분용
	dim colorCD			: colorCD="0"
	dim CurrPage		: CurrPage=1
	dim PageSize		: PageSize=6	
	dim LogsAccept		: LogsAccept = true
	Dim SellScope		: SellScope = "Y"
	dim ScrollCount		: ScrollCount = 1
	dim lp, i

	Dim kgubun , itemurl , itemname , image

	SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")

	'// 상품검색
	dim oDoc,iLp
	set oDoc = new SearchItemCls
	oDoc.FRectSearchTxt = SearchText
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchFlag = searchFlag
	oDoc.FRectSearchItemDiv = SearchItemDiv
	oDoc.FRectSearchCateDep = SearchCateDep

	oDoc.FCurrPage = CurrPage
	oDoc.FPageSize = PageSize
	oDoc.FScrollCount = ScrollCount
	oDoc.FListDiv = ListDiv
	oDoc.FLogsAccept = LogsAccept
	oDoc.FRectColsSize = 6
	oDoc.FcolorCode = colorCD
	oDoc.FSellScope=SellScope
	oDoc.getSearchList

	'// 키워드 Json 갯수 구분
	Set obj("search"&knum+1) = jsArray()
		obj("keyword"&knum+1) = ""& SearchText &""
		obj("klink"&knum+1) = "/search/search_item.asp?rect="& SearchText &"&gaparam=todaykeyword_"& knum+1 &"_0"
	'//json 생성
	For i=0 To oDoc.FResultCount-1
		
			kgubun		= knum
			itemurl		= "/category/category_itemPrd.asp?itemid="& oDoc.FItemList(i).FItemID & "&gaparam=todaykeyword_"& Server.URLEncode(SearchText) &"_"& kgubun+1 &"_"& i+1
			itemname	= oDoc.FItemList(i).FItemName
			If i = 0 Then 
				image	= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,400,400,"true","false")
			Else
				image	= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,200,200,"true","false")
			End If 
						
			Set obj("search"&knum+1&"")(null) = jsObject()
				obj("search"&knum+1&"")(null)("gubun")			= ""& kgubun+1 &""
				obj("search"&knum+1&"")(null)("itemurl")		= ""& itemurl &""
				obj("search"&knum+1&"")(null)("itemname")		= ""& itemname &""
				obj("search"&knum+1&"")(null)("image")			= ""& image &""
	Next
	set oDoc = Nothing
End Function
%>