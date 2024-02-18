<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2019 검색 ajax page
' History : 2018-09-03 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2019/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2019/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
    '// data
    dim ArrDesign , ArrContents , ArrKeyword , ArrColorCode
    dim SortMet 
    dim tmp , iTmp , ctmp, ktmp , ptmp
    dim ListDiv , limited
    dim PageSize : PageSize = 12
    dim CurrPage :  CurrPage = RequestCheckVar(request("cpg"),10)

    If ListDiv = "" Then ListDiv = "item"
    if limited = "" then limited = "X"
    IF SortMet = "" Then SortMet = "newitem"
    IF CurrPage = "" then CurrPage = 1
	IF SortMet = "" Then SortMet = "newitem"

    ArrDesign = requestcheckvar(request("arrds"),100)
	ArrContents = requestcheckvar(request("arrcont"),100)
	ArrKeyword = requestcheckvar(request("arrkey"),100)
	ArrColorCode = requestcheckvar(request("iccd"),100)

    ' response.write ArrDesign &"</br>"
    ' response.write ArrContents &"</br>"
    ' response.write ArrKeyword &"</br>"
    ' response.write ArrColorCode &"</br>"
    ' response.end

    ArrDesign = Split(ArrDesign,",")
	ArrContents = Split(ArrContents,",")
	ArrKeyword = Split(ArrKeyword,",")
	ArrColorCode = Split(ArrColorCode,",")

	For iTmp =0 to Ubound(ArrDesign)-1
		IF ArrDesign(iTmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrDesign(iTmp),2) &","
		End IF
	Next
	ArrDesign = tmp

	tmp = ""
	For cTmp =0 to Ubound(ArrContents)-1
		IF ArrContents(cTmp)<>"" Then
			tmp  = tmp & "'" & requestcheckvar(ArrContents(cTmp),10) & "'" &","
		End IF
	Next
	ArrContents = tmp

	tmp = ""
	For ktmp =0 to Ubound(ArrKeyword)-1
		IF ArrKeyword(ktmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrKeyword(ktmp),2) &","
		End IF
	Next
	ArrKeyword = tmp

	tmp = ""
	For ptmp =0 to Ubound(ArrColorCode)-1
		IF ArrColorCode(ptmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrColorCode(ptmp),2) &","
		End IF
	Next
	ArrColorCode = tmp

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

	Dim PrdBrandList, i

	set PrdBrandList = new cdiary_list
		PrdBrandList.FPageSize = PageSize
		PrdBrandList.FCurrPage = CurrPage
		PrdBrandList.frectdesign = sArrDesign
		PrdBrandList.frectcontents = sarrcontents
		PrdBrandList.frectkeyword = sarrkeyword
		PrdBrandList.fmdpick = ""
		PrdBrandList.frectlimited = limited
		PrdBrandList.ftectSortMet = SortMet
		PrdBrandList.getDiaryItemLIst
%>
<%' 검색결과 %>
<% If PrdBrandList.FResultCount > 0 Then %>
<%
    Dim tempimg, tempimg2 , diaryItemBedge
    For i = 0 To PrdBrandList.FResultCount - 1

        If ListDiv = "item" Then
            tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg
            tempimg2 = PrdBrandList.FItemList(i).FDiaryBasicImg2
        End If
        If ListDiv = "list" Then
            tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg2
        End If

        IF application("Svr_Info") = "Dev" THEN
            tempimg = left(tempimg,7)&mid(tempimg,12)
            tempimg2 = left(PrdBrandList.FItemList(i).FDiaryBasicImg2,7)&mid(PrdBrandList.FItemList(i).FDiaryBasicImg2,12)''마우스오버 활용컷
        end if

        diaryItemBedge = ""

        if PrdBrandList.FItemList(i).FNewYN = "1" then 
            diaryItemBedge = "<span class=""label new""></span>"
        end if 

        if PrdBrandList.FItemList(i).FmdpickYN = "o" then 
            diaryItemBedge = "<span class=""label best""></span>"
        end if 
        
%>
    <li <%'=chkiif(PrdBrandList.FItemList(i).IsSoldOut,"class='soldOut'","") %>> 
        <a href="" onclick="<%=chkiif(isapp,"fnAPPpopupProduct('"& PrdBrandList.FItemList(i).FItemid &"');","TnGotoProduct('"& PrdBrandList.FItemList(i).FItemid &"');")%>return false;">
            <div class="thumbnail">
                <% if PrdBrandList.FItemList(i).IsSoldOut then %>
                    <span class="soldOutMask"></span>
                <% end if %>
                <img src="<%=tempimg %>" alt="<%= PrdBrandList.FItemList(i).FItemName %>" />
                <%=diaryItemBedge%>
            </div>
            <div class="desc">
                <p class="brand"><%= PrdBrandList.FItemList(i).Fsocname %></p>
                <p class="name">
                    <% If PrdBrandList.FItemList(i).isSaleItem Or PrdBrandList.FItemList(i).isLimitItem Then %>
                        <%= chrbyte(PrdBrandList.FItemList(i).FItemName,30,"Y") %>
                    <% Else %>
                        <%= PrdBrandList.FItemList(i).FItemName %>
                    <% End If %>
                </p>
                <% if PrdBrandList.FItemList(i).IsSaleItem or PrdBrandList.FItemList(i).isCouponItem Then %>
                    <% IF PrdBrandList.FItemList(i).IsSaleItem then %>
                        <div class="price">
                            <div class="unit">
                                <b class="sum"><%=FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0)%><span class="won">원</span></b>
                                <b class="discount color-red"><%=PrdBrandList.FItemList(i).getSalePro%></b>
                            </div>
                        </div>
                    <% End If %>
                    <% IF PrdBrandList.FItemList(i).IsCouponItem Then %>
                        <div class="price">
                            <div class="unit">
                                <b class="sum"><%=FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0)%><span class="won">원</span></b>
                                <b class="discount color-green"><%=PrdBrandList.FItemList(i).GetCouponDiscountStr%></b>
                            </div>
                        </div>
                    <% end if %>
                <% else %>
                    <span class="price">
                        <div class="unit">
                            <b class="sum"><%=FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0) & chkIIF(PrdBrandList.FItemList(i).IsMileShopitem,"Point","<span class='won'>원</span>")%></b>
                        </div>
                    </span>
                <% end if %>
            </div>
        </a>
    </li>
<%
    Next
%>
<% END IF %>
<%
	Set PrdBrandList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->