<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/street/BrandStreetCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	dim snsimg
	dim classStr, adultChkFlag, adultPopupLink, linkUrl
	Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	dim oldmakerid : oldmakerid = requestCheckVar(Request("makerid"),32)
	Dim isShowSumamry : isShowSumamry = false  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim SearchFlag : SearchFlag = NullfillWith(requestCheckVar(request("sflag"),2),"n")
	dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
	
	dim ListDiv : ListDiv = "brand" '카테고리/검색 구분용
	dim minPrice : minPrice = getNumeric(requestCheckVar(Replace(request("minPrc"),",",""),8))
	dim maxPrice : maxPrice = getNumeric(requestCheckVar(Replace(request("maxPrc"),",",""),8))
	dim deliType : deliType = requestCheckVar(request("deliType"),2)
	dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim LogsAccept : LogsAccept = true
	dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
	if vDisp <> "" then dispCate = vDisp

	dim makerid : makerid = ReplaceRequestSpecialChar(request("mkr"))
	if oldmakerid <> "" then makerid = oldmakerid

	dim lp, i
	Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
	Dim retUrl : retUrl = requestCheckVar(request("burl"),256)
	If retUrl = "" Then retUrl = wwwUrl End If

	dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then SellScope = "Y"
	dim arrCate : arrCate = ReplaceRequestSpecialChar(request("arrCate"))
	dim styleCD : styleCD = ReplaceRequestSpecialChar(request("styleCd"))
	dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))

	dim CheckResearch : CheckResearch= request("chkr")
	dim CheckExcept : CheckExcept= request("chke")
	dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
	dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
	dim DocSearchText

	Dim tmpPrevSearchKeyword , tmpCurrSearchKeyword
	Dim PrevSearchText : PrevSearchText = requestCheckVar(request("prvtxt"),100) '이전 검색어
	Dim isSaveSearchKeyword : isSaveSearchKeyword = true  ''검색어 DB에 저장 여부 X => procMySearchKeyword(쿠키)
	
	Dim vCateDepth, vWishArr, search_on, vListOption, vRealResearch

	search_on = requestCheckVar(request("search_on"),2)
	vListOption = NullFillwith(requestCheckVar(request("listoption"),10),"all")

	if dispCate<>"" then
		vCateDepth = cStr(len(dispCate)\3)+1			'하위 뎁스
	else
		vCateDepth = "1"
	end if
	if vCateDepth>3 then vCateDepth=3

	If mode = "" Then mode = "S"

	dim ScrollCount : ScrollCount = 4
	if CurrPage="" then CurrPage=1
	If mode = "L" then
		'### 1줄에 1개
		PageSize=15
	'	if PageSize="" then PageSize=15
	Else
		'### 1줄에 2개
		PageSize=30
	'	if PageSize="" then PageSize=30
	End If

	'if colorCD="" then colorCD="0"
	if SortMet="" then SortMet="be"		'베스트:be, 신상:ne


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
		vRealResearch = ReSearchText
		ReSearchText = ReSearchText & " " & SearchText
		DocSearchText = ReSearchText
	Else
		'ReSearchText  =	SearchText
		DocSearchText = SearchText
	End if

	if CheckExcept then
		ReSearchText  =	ReSearchText
		DocSearchText = ReSearchText
		SearchText = ExceptText
	end if
	
	'### 실제 입력한 결과내검색어
	ReSearchText = vRealResearch

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

	dim oGrCat,rowCnt ''//카테고리
	Dim oGrEvt ''//이벤트

	'검색 로그 저장 여부
	IF CStr(SearchText)=CStr(PrevSearchText) Then
		LogsAccept = false
	End if

    '// 검색 조건 재설정 //2015/03/12 추가 (기존에 없었음)
    PrevSearchText = SearchText


	dim oDoc, iLp, objCmd, returnValue, vTotalCount
	If vListOption = "all" or vListOption = "item" Then	'### 전체검색, 상품검색 만

		'// 상품검색
		set oDoc = new SearchItemCls
		oDoc.FRectSearchTxt = DocSearchText
		oDoc.FRectSortMethod	= SortMet
		oDoc.FRectSearchFlag = fnSalePojang(searchFlag,pojangok)
		oDoc.FRectSearchItemDiv = SearchItemDiv
		oDoc.FRectCateCode	= dispCate
		oDoc.FRectSearchCateDep = SearchCateDep
		oDoc.FRectMakerid	= fnCleanSearchValue(makerid)
		oDoc.FminPrice	= minPrice
		oDoc.FmaxPrice	= maxPrice
		oDoc.FdeliType	= deliType
		oDoc.FCurrPage = CurrPage
		oDoc.FPageSize = PageSize
		oDoc.FScrollCount = ScrollCount
		oDoc.FListDiv = ListDiv
		oDoc.FLogsAccept = LogsAccept
		oDoc.FRectColsSize = 6
		oDoc.FcolorCode = fnCleanSearchValue(colorCD)
		oDoc.FSellScope=SellScope
		oDoc.FstyleCd = fnCleanSearchValue(styleCd)
		oDoc.getSearchList
		
		vTotalCount = oDoc.FTotalCount

		'// 숫자만 입력될경우 체크후 상품페이지로 넘기기
		IF oDoc.FTotalCount=1 and isNumeric(SearchText) Then
			on Error Resume Next

			'// 존재하는 상품인지 검사
			Set objCmd = Server.CreateObject("ADODB.Command")

			objCmd.ActiveConnection = dbget
			objCmd.CommandType = adCmdStoredProc
			objCmd.CommandText = "[db_item].[dbo].sp_Ten_PrdExists"

			objCmd.Parameters.Append objCmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			objCmd.Parameters.Append objCmd.CreateParameter("@@vItemID",adVarWChar,adParamInput,10,CLng(DocSearchText))

			objCmd.Execute

			returnValue = objCmd("RETURN_VALUE").value

			Set objCmd = Nothing
			IF returnValue=1 Then
				response.redirect "/category/category_itemprd.asp?itemid=" & CLng(DocSearchText)
				dbget.close()	:	response.End
			End IF

			on Error Goto 0

		End if
	End If

	Dim moreYn

	if isSaveSearchKeyword and (tmpCurrSearchKeyword <> tmpPrevSearchKeyword) then
		'// 내검색어 쿠키 저장
		call procMySearchKeyword(tmpCurrSearchKeyword)
	End If

	'//logparam
	Dim logparam : logparam = "&pRtr="& server.URLEncode(SearchText)
	'//2017 추가 버전 검색에서 넘어 왔는지 유무
	Dim searchback_Param : searchback_Param = requestCheckVar(request("pNtr"),20)
	Dim addparam
	If searchback_Param <> "" Then
		addparam = "&pNtr="& server.URLEncode(searchback_Param)
	End If

	'// 검색결과 내위시 표시정보 접수
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF oDoc.FResultCount >0 then
			For iLp=0 To oDoc.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oDoc.FItemList(iLp).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if

Dim rcParam
For i=0 To oDoc.FResultCount-1
'클릭 위치 Parameter 추가
	rcParam = "&rc=brand_" & fix((i)/2)+1 &"_" & ((i) mod 2)+1

	classStr = ""
	linkUrl = "/category/category_itemPrd.asp?itemid="& oDoc.FItemList(i).FItemID & "&dispCate=" & oDoc.FItemList(i).FCateCode & logparam & addparam & "&pBtr=" & makerid
	adultChkFlag = session("isAdult") <> true and oDoc.FItemList(i).FadultType = 1																	

	If oDoc.FItemList(i).FItemDiv="21" Then
		classStr = addClassStr(classStr,"deal-item")							
	end if
	if adultChkFlag then
		classStr = addClassStr(classStr,"adult-item")								
	end if																				
%>
	<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
		<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&dispCate=<%= oDoc.FItemList(i).FCateCode %><%=logparam%><%=addparam%>&pBtr=<%=makerid%>">
			<% If oDoc.FItemList(i).FItemDiv="21" Then %>
				<span class="deal-badge">텐텐<i>DEAL</i></span>
			<% End If %>
			<%'// 해외직구배송작업추가 %>
			<% If oDoc.FItemList(i).IsDirectPurchase Then %>
				<span class="abroad-badge">해외직구</span>
			<% End If %>
			<%'// 클래스 아이콘 추가 %>
			<% If oDoc.FItemList(i).FDeliverFixDay = "L" Then %>
				<span class="class-badge">텐텐<i>클래스</i></span>
			<% End If %>
			<div class="thumbnail">
				<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="" />
				<% if adultChkFlag then %>									
				<div class="adult-hide">
					<p>19세 이상만 <br />구매 가능한 상품입니다</p>
				</div>
				<% end if %>						
				<% If oDoc.FItemList(i).isSoldOut Then Response.Write "<b class=""soldout"">일시 품절</b>" End If %>
			</div>
			<div class="desc">
				<span class="brand"><% = oDoc.FItemList(i).FBrandName %></span>
				<p class="name"><% = oDoc.FItemList(i).FItemName %></p>
				<div class="price">
				<%
					If oDoc.FItemList(i).IsSaleItem AND oDoc.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
						Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
						Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
						If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
							If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
								Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
							Else
								Response.Write "&nbsp;<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
							End If
						End If
						Response.Write "</div>" &  vbCrLf
					ElseIf oDoc.FItemList(i).IsSaleItem AND (Not oDoc.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
						Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
						Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
						Response.Write "</div>" &  vbCrLf
					ElseIf oDoc.FItemList(i).isCouponItem AND (NOT oDoc.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
						Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
						If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
							If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
								Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
							Else
								Response.Write "&nbsp;<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
							End If
						End If
						Response.Write "</div>" &  vbCrLf
					Else
						Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point"," 원") & "</span></b></div>" &  vbCrLf
					End If
				%>
				</div>
			</div>
		</a>
		<div class="etc">			
			<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>%;"><%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>점</i></span><span class="counting"><%=CHKIIF(oDoc.FItemList(i).FEvalCnt>999,"999+",oDoc.FItemList(i).FEvalCnt)%></span></div>
			<button class="tag wish btn-wish" onclick="goWishPop('<%=oDoc.FItemList(i).FItemid%>');">
				<%
				If oDoc.FItemList(i).FfavCount > 0 Then
					If fnIsMyFavItem(vWishArr,oDoc.FItemList(i).FItemID) Then
						Response.Write "<span class=""icon icon-wish on"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">"
						Response.Write CHKIIF(oDoc.FItemList(i).FfavCount>999,"999+",formatNumber(oDoc.FItemList(i).FfavCount,0)) & "</span>"
					Else
						Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">"
						Response.Write CHKIIF(oDoc.FItemList(i).FfavCount>999,"999+",formatNumber(oDoc.FItemList(i).FfavCount,0)) & "</span>"
					End If
				Else
					'// 무료배송 추가( class=""hidden"" , wish )
					Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">wish</span>"
				End If
				%>
			</button>
			<%'// 무료배송 추가 %>
			<% If oDoc.FItemList(i).FDeliverFixDay <> "L" Then %>
				<% IF oDoc.FItemList(i).FFreeDeliveryYN="Y" Then %>
				<div class="tag free-shipping">무료배송</div>
				<% End If %>
			<% End If %>
		</div>
	</li>
<%
Next
set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
