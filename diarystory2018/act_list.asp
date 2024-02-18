<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (M)다이어리스토리2017 아이템 리스트 ajax
' History : 2017-09-26 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2018/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2018/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%

	Dim ArrDesign , tmp , iTmp , ctmp, ktmp, arrcontents ,arrkeyword , userid, limited, rdsearch
	dim cate , PageSize , ttpgsz , CurrPage, vGubun, vMDPick, vParaMeter, vParaMeterCG
	dim SortMet	,page, cDiary
	Dim ListDiv, arrColorCode, GiftSu, PrdBrandList, i
	dim vWishArr

	ListDiv	= requestcheckvar(request("ListDiv"),4)
	If ListDiv = "" Then ListDiv = "list"

	PageSize = 30

	userid		= getLoginUserID
	rdsearch = request("rdsearch")
	ArrDesign = request("arrds")
	arrcontents = request("arrcont")
	arrkeyword = request("arrkey")
	arrColorCode = request("iccd")
	limited = request("limited")
	page 		= requestcheckvar(request("page"),2)
	SortMet 	= requestCheckVar(request("srm"),9)
	CurrPage 	= requestCheckVar(request("cpg"),9)

	IF SortMet = "" Then SortMet = "newitem"
	IF CurrPage = "" then CurrPage = 1
	if page = "" then page = 1
	If limited = "" then limited = "x"

	ArrDesign = split(ArrDesign,",")
	arrcontents = split(arrcontents,",")
	arrkeyword = split(arrkeyword,",")
	arrColorCode = Split(arrColorCode,",")

	For iTmp =0 to Ubound(ArrDesign)-1
		IF ArrDesign(iTmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrDesign(iTmp),2) &","
		End IF
	Next
	ArrDesign = tmp

	tmp = ""
	For cTmp =0 to Ubound(arrcontents)-1
		IF arrcontents(cTmp)<>"" Then
			tmp  = tmp & "" & requestcheckvar(arrcontents(cTmp),10) & "" &","
		End IF
	Next
	arrcontents = tmp

	tmp = ""
	For ktmp =0 to Ubound(arrkeyword)-1
		IF arrkeyword(ktmp)<>"" Then
			tmp  = tmp & requestcheckvar(arrkeyword(ktmp),2) &","
		End IF
	Next
	arrkeyword = tmp

	tmp = ""
	For ktmp =0 to Ubound(arrColorCode)-1
		IF arrColorCode(ktmp)<>"" Then
			tmp  = tmp & requestcheckvar(arrColorCode(ktmp),2) &","
		End IF
	Next
	arrColorCode = tmp

	Dim sArrDesign,sarrcontents,sarrkeyword,sarrColorCode
	sArrDesign =""
	sarrcontents =""
	sarrkeyword =""
	sarrColorCode =""
	IF ArrDesign <> "" THEN sArrDesign =  left(ArrDesign,(len(ArrDesign)-1))
	IF arrcontents <> "" THEN sarrcontents =  left(arrcontents,(len(arrcontents)-1))
	IF arrkeyword <> "" THEN
		If arrColorCode = "" then
		sarrkeyword =  left(arrkeyword,(len(arrkeyword)-1))
		else
		sarrkeyword =  arrkeyword & left(arrColorCode,(len(arrColorCode)-1))
		End If
	else
		If arrColorCode <> "" then
		sarrkeyword =  left(arrColorCode,(len(arrColorCode)-1))
		End If
	End If

	vParaMeter = "&arrds="&ArrDesign&"&arrcont="&arrcontents&"&arrkey="&arrkeyword&"&iccd="&arrColorCode&"&ListDiv="&ListDiv&"&limited="&limited&""
	vParaMeterCG = "&arrcont="&arrcontents&"&arrkey="&arrkeyword&"&iccd="&arrColorCode&"&ListDiv="&ListDiv&"&limited="&limited&""

	'1+1
	Set cDiary = new cdiary_list
		cDiary.getOneplusOneDaily '1+1
		cDiary.getDiaryCateCnt '상태바 count
'		GiftSu = cDiary.getGiftDiaryExists(cDiary.FOneItem.Fitemid) '사은품 수

	Set PrdBrandList = new cdiary_list
		'아이템 리스트
		PrdBrandList.FPageSize = PageSize
		PrdBrandList.FCurrPage = CurrPage
		PrdBrandList.frectdesign = sArrDesign
		PrdBrandList.frectcontents = arrcontents
		PrdBrandList.frectkeyword = sarrkeyword
		PrdBrandList.fmdpick = vMDPick
		PrdBrandList.frectlimited = limited
		PrdBrandList.ftectSortMet = SortMet
		''PrdBrandList.fuserid = userid		'위시용인데 분리 > 안씀
		PrdBrandList.getDiaryItemLIst

	'// 검색결과 내위시 표시정보 접수
	dim iLp
	dim rstArrItemid: rstArrItemid=""
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		IF PrdBrandList.FResultCount >0 then
			For iLp=0 To PrdBrandList.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & PrdBrandList.FItemList(iLp).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if
	
	If PrdBrandList.FResultCount > 0 Then
		For i = 0 To PrdBrandList.FResultCount - 1

			Dim tempimg

			If ListDiv = "list" Then
				tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg
			End If
			If ListDiv = "item" Then
				tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg2
			End If
			
			IF application("Svr_Info") = "Dev" THEN
				PrdBrandList.FItemList(i).FDiaryBasicImg = left(PrdBrandList.FItemList(i).FDiaryBasicImg,7)&mid(PrdBrandList.FItemList(i).FDiaryBasicImg,12)
				PrdBrandList.FItemList(i).FDiaryBasicImg2 = left(PrdBrandList.FItemList(i).FDiaryBasicImg2,7)&mid(PrdBrandList.FItemList(i).FDiaryBasicImg2,12)
				'response.write PrdBrandList.FItemList(i).FDiaryBasicImg
			end if
	%>
			<li>
				<a href="" onclick="TnGotoProduct('<%=PrdBrandList.FItemList(i).FItemID %>'); return false;" >
					<div class="thumbnail"><img src="<%=PrdBrandList.FItemList(i).FDiaryBasicImg%>" alt="" /><% IF PrdBrandList.FItemList(i).isSoldOut Then%><b class="soldout">일시 품절</b><% end if %></div>
					<div class="desc">
						<span class="brand"><%=PrdBrandList.FItemList(i).FBrandName%></span>
						<p class="name"><%=PrdBrandList.FItemList(i).FItemName%></p>
						<div class="price">
						<%
							If PrdBrandList.FItemList(i).IsSaleItem AND PrdBrandList.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
								Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
								Response.Write "&nbsp;<b class=""discount color-red"">" & PrdBrandList.FItemList(i).getSalePro & "</b>"
								If PrdBrandList.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
									If InStr(PrdBrandList.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
										Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
									Else
										Response.Write "&nbsp;<b class=""discount color-green"">" & PrdBrandList.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
									End If
								End If
								Response.Write "</div>" &  vbCrLf
							ElseIf PrdBrandList.FItemList(i).IsSaleItem AND (Not PrdBrandList.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
								Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
								Response.Write "&nbsp;<b class=""discount color-red"">" & PrdBrandList.FItemList(i).getSalePro & "</b>"
								Response.Write "</div>" &  vbCrLf
							ElseIf PrdBrandList.FItemList(i).isCouponItem AND (NOT PrdBrandList.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
								Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
								If PrdBrandList.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
									If InStr(PrdBrandList.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
										Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
									Else
										Response.Write "&nbsp;<b class=""discount color-green"">" & PrdBrandList.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
									End If
								End If
								Response.Write "</div>" &  vbCrLf
							Else
								Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(PrdBrandList.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
							End If
						%>
						</div>
					</div>
				</a>
				<div class="etc">
					<% if PrdBrandList.FItemList(i).FEvalCnt > 0 then %>
						<div class="tag review">
							<span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(PrdBrandList.FItemList(i).FPoints,"search")%>%;"><%=fnEvalTotalPointAVG(PrdBrandList.FItemList(i).FPoints,"search")%>점</i></span>
							<span class="counting"><%=chkiif(PrdBrandList.FItemList(i).FEvalCnt>999,"999+",PrdBrandList.FItemList(i).FEvalCnt)%></span>
						</div>
					<% end if %>

					<button class="tag wish btn-wish" onclick="goWishPop('<%= PrdBrandList.FItemList(i).FItemID %>');">
						<%
						If PrdBrandList.FItemList(i).FfavCount > 0 Then
							If fnIsMyFavItem(vWishArr,PrdBrandList.FItemList(i).FItemID) Then
								Response.Write "<span class=""icon icon-wish on"" id=""wish"&PrdBrandList.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&PrdBrandList.FItemList(i).FItemID&""">"
								Response.Write CHKIIF(PrdBrandList.FItemList(i).FfavCount>999,"999+",formatNumber(PrdBrandList.FItemList(i).FfavCount,0)) & "</span>"
							Else
								Response.Write "<span class=""icon icon-wish"" id=""wish"&PrdBrandList.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&PrdBrandList.FItemList(i).FItemID&""">"
								Response.Write CHKIIF(PrdBrandList.FItemList(i).FfavCount>999,"999+",formatNumber(PrdBrandList.FItemList(i).FfavCount,0)) & "</span>"
							End If
						Else
							Response.Write "<span class=""icon icon-wish"" id=""wish"&PrdBrandList.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&PrdBrandList.FItemList(i).FItemID&"""></span>"
						End If
						%>
					</button>

					<% IF PrdBrandList.FItemList(i).IsCouponItem AND PrdBrandList.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
						<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
					<% End If %>
				</div>
			</li>
<%
		 next
	end if

	Set PrdBrandList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
