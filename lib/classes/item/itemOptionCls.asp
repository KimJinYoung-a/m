<%
''-------------------------------------------------------------------
'' 상품 옵션 종류 ProtoType
Class CItemOptionMultipleItem
    public Fitemid
    public FTypeSeq
    public FKindSeq
    public FoptionTypeName
    public FoptionKindName
    public Foptaddprice
    public Foptaddbuyprice

    public FoptionKindCount
    public FAvailOptCNT

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class


'' 상품 옵션 ProtoType
Class CItemOptionItem
    public Fitemid
    public Fitemoption
    public Fisusing
    public Foptsellyn
    public Foptlimityn
    public Foptlimitno
    public Foptlimitsold
    public FoptionTypeName
    public Foptionname
    public Foptaddprice
    public Foptaddbuyprice
	Public Fitemdiv

    public function IsOptionSoldOut()
        IsOptionSoldOut = (Fisusing="N") or (Foptsellyn="N") or ((IsLimitSell) and (GetOptLimitEa<1))
    end function

    public function IsLimitSell()
        IsLimitSell = (Foptlimityn="Y")
    end function

	public function GetOptLimitEa()
		if FOptLimitNo-FOptLimitSold<0 then
			GetOptLimitEa = 0
		else
			GetOptLimitEa = FOptLimitNo-FOptLimitSold
		end if
	end function

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class


''상품 옵션
Class CItemOption
    public FOneItem
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectItemID
	public FRectIsUsing

	public function GetOptionMultipleTypeList()
        dim sqlStr, i

        sqlStr = "exec [db_item].[dbo].sp_Ten_ItemOptionMultipleTypeList " & FRectItemID

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FTotalCount  = rsget.RecordCount
        FResultCount = FTotalCount

        redim preserve FItemList(FResultCount)
        if  not rsget.EOF  then
            do until rsget.eof
    			set FItemList(i) = new CItemOptionMultipleItem
    			FItemList(i).Fitemid           = rsget("itemid")
                FItemList(i).FTypeSeq          = rsget("TypeSeq")
                FItemList(i).FoptionTypeName   = db2Html(rsget("optionTypeName"))
                FItemList(i).FoptionKindCount  = rsget("cnt")

    			i=i+1
    			rsget.moveNext
    		loop
    	end if
        rsget.Close
    end function

    function IsValidOptionTypeExists(iTypeSeq, iKindseq)
        dim i, opt
        IsValidOptionTypeExists = False
        for i=LBound(FItemList) to UBound(FItemList)-1
            if (Not FItemList(i) is Nothing) then
                opt = FItemList(i).FItemoption
                IF (LEFT(opt,1) = "Z") and (Mid(opt,iTypeSeq+1,1)=CStr(iKindseq)) then
                    IsValidOptionTypeExists = true
                    Exit function
                End if
            end if
        next
    end function

    public function GetOptionMultipleList()
        dim sqlStr, i

        sqlStr = "exec [db_item].[dbo].sp_Ten_ItemOptionMultipleList " & FRectItemID

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FTotalCount  = rsget.RecordCount
        FResultCount = FTotalCount

        redim preserve FItemList(FResultCount)
        if  not rsget.EOF  then
            do until rsget.eof
    			set FItemList(i) = new CItemOptionMultipleItem
    			FItemList(i).Fitemid           = rsget("itemid")
                FItemList(i).FTypeSeq          = rsget("TypeSeq")
                FItemList(i).FKindSeq          = rsget("KindSeq")
                FItemList(i).FoptionTypeName   = db2Html(rsget("optionTypeName"))
                FItemList(i).FoptionKindName   = db2Html(rsget("optionKindName"))
                FItemList(i).Foptaddprice      = rsget("optaddprice")
                FItemList(i).Foptaddbuyprice   = rsget("optaddbuyprice")

                FItemList(i).FAvailOptCNT      = rsget("AvailOptCNT")

    			i=i+1
    			rsget.moveNext
    		loop
    	end if
        rsget.Close
    end function

    public function GetOptionList()
        dim sqlStr, i
        dim dumiKey, PreKey

        sqlStr = "exec [db_item].[dbo].sp_Ten_ItemOptionList " & FRectItemID & ",'" & FRectIsUsing & "'"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FTotalCount  = rsget.RecordCount
        FResultCount = FTotalCount

        redim preserve FItemList(FResultCount)
        if  not rsget.EOF  then
            do until rsget.eof
    			set FItemList(i) = new CItemOptionItem
    			FItemList(i).Fitemid         = rsget("itemid")
                FItemList(i).Fitemoption     = rsget("itemoption")
                FItemList(i).Fisusing        = rsget("isusing")
                FItemList(i).Foptsellyn      = rsget("optsellyn")
                FItemList(i).Foptlimityn     = rsget("optlimityn")
                FItemList(i).Foptlimitno     = rsget("optlimitno")
                FItemList(i).Foptlimitsold   = rsget("optlimitsold")
                FItemList(i).FoptionTypeName = db2Html(rsget("optionTypeName"))
                FItemList(i).Foptionname     = db2Html(rsget("optionname"))
                FItemList(i).Foptaddprice    = rsget("optaddprice")
                FItemList(i).Foptaddbuyprice = rsget("optaddbuyprice")

    			i=i+1
    			rsget.moveNext
    		loop
    	end if
        rsget.Close
    end function

    public function GetOptionList2()
        dim sqlStr, i
        dim dumiKey, PreKey

        sqlStr = "exec [db_item].[dbo].sp_Ten_ItemOptionList_Deal " & FRectItemID & ",'" & FRectIsUsing & "'"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FTotalCount  = rsget.RecordCount
        FResultCount = FTotalCount

        redim preserve FItemList(FResultCount)
        if  not rsget.EOF  then
            do until rsget.eof
    			set FItemList(i) = new CItemOptionItem
    			FItemList(i).Fitemid         = rsget("itemid")
				FItemList(i).Fitemdiv         = rsget("itemdiv")
                FItemList(i).Fitemoption     = rsget("itemoption")
                FItemList(i).Fisusing        = rsget("isusing")
                FItemList(i).Foptsellyn      = rsget("optsellyn")
                FItemList(i).Foptlimityn     = rsget("optlimityn")
                FItemList(i).Foptlimitno     = rsget("optlimitno")
                FItemList(i).Foptlimitsold   = rsget("optlimitsold")
                FItemList(i).FoptionTypeName = db2Html(rsget("optionTypeName"))
                FItemList(i).Foptionname     = db2Html(rsget("optionname"))
                FItemList(i).Foptaddprice    = rsget("optaddprice")
                FItemList(i).Foptaddbuyprice = rsget("optaddbuyprice")

    			i=i+1
    			rsget.moveNext
    		loop
    	end if
        rsget.Close
    end function

    Private Sub Class_Initialize()
        redim  FItemList(0)
		FCurrPage       = 1
		FPageSize       = 100
		FResultCount    = 0
		FScrollCount    = 10
		FTotalCount     = 0

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class

'' 상품 페이지 에서 사용
function GetOptionBoxHTML(byVal iItemID, byVal isItemSoldOut)
    GetOptionBoxHTML = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml, optionBoxValue

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if


		optionHtml = optionHtml + "<p class=""tPad10"">"
		optionHtml = optionHtml + "<select name=""item_option"" title=""" & optionTypeStr & """ style=""width:100%;"" onchange=""jsChgoptlayer(this)"">"
        optionHtml = optionHtml + "<option value="""" selected>" & optionTypeStr & "</option>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""
    	    optionBoxValue		= ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = "<div class=option onClick=""alert('품절된 옵션은 선택하실 수 없습니다.');return false"" >" & optionKindStr & " (품절)</div>"
        		optionBoxStyle = "class='soldout reIn'"
        		optionBoxValue = " soldout='Y'"
        	else
        		optionBoxValue = " soldout='N'"
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
        	        optionBoxValue = optionBoxValue & " addPrice='" & oitemoption.FItemList(i).Foptaddprice & "'"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
        			optionBoxValue = optionBoxValue & " limitEa='" & oItemOption.FItemList(i).GetOptLimitEa & "'"
            	end if
            end if

            optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionBoxStyle + optionBoxValue + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + GetItemResaleNoticeButton(oItemOption.FItemList(i).FitemOption, oItemOption.FItemList(i).IsOptionSoldOut) + "</option>"
    	next

	    optionHtml = optionHtml + "</select>"
		optionHtml = optionHtml + "</p>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name[" + CStr(i) + "] = """ + doubleQuote(oItemOption.FItemList(i).FOptionName) + """;"
            ScriptHtml = ScriptHtml + " Mopt_addprice[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

			optionHtml = optionHtml + "<p class=""tPad10"">"
			optionHtml = optionHtml + "<select name=""item_option"" id=""" + cstr(j) + """ title=""" & optionTypeStr & """ style=""width:100%;"" onchange=""CheckMultiOption(this)"">"
	        optionHtml = optionHtml + "<option value="""" selected>" & optionTypeStr & "</option>"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
    	        end if
    	    Next
    	    optionHtml = optionHtml + "</select>"
			optionHtml = optionHtml + "</p>"
    	Next

    	set oItemOptionMultipleType = Nothing
    END IF

    GetOptionBoxHTML = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

end Function

'' 상품 페이지 에서 사용 2016-05-08 2016 플로팅 버전 - 이종화
function GetOptionBox2016(byVal iItemID, byVal isItemSoldOut)
    GetOptionBox2016 = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml, optionBoxValue

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if


		optionHtml = optionHtml + "<div>"
		optionHtml = optionHtml + "<select name=""item_option"" title=""" & optionTypeStr & """ class=""current"">"
        optionHtml = optionHtml + "<option value="""" selected>" & optionTypeStr & "</option>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""
    	    optionBoxValue		= ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = "<div class=option onClick=""alert('품절된 옵션은 선택하실 수 없습니다.');return false"" >" & optionKindStr & " (품절)</div>"
        		optionBoxStyle = "class='soldout reIn'"
        		optionBoxValue = " soldout='Y'"
        	else
        		optionBoxValue = " soldout='N'"
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
        	        optionBoxValue = optionBoxValue & " addPrice='" & oitemoption.FItemList(i).Foptaddprice & "'"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
        			optionBoxValue = optionBoxValue & " limitEa='" & oItemOption.FItemList(i).GetOptLimitEa & "'"
            	end if
            end if

            optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionBoxStyle + optionBoxValue + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + GetItemResaleNoticeButton(oItemOption.FItemList(i).FitemOption, oItemOption.FItemList(i).IsOptionSoldOut)+"</option>"
    	next

	    optionHtml = optionHtml + "</select>"
		optionHtml = optionHtml + "</div>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name[" + CStr(i) + "] = """ + doubleQuote(oItemOption.FItemList(i).FOptionName) + """;"
            ScriptHtml = ScriptHtml + " Mopt_addprice[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if
			If j=0 then
			optionHtml = optionHtml + "<div>"
			Else
			optionHtml = optionHtml + "<div class=""tMar0-9r"">"
			End If 
			optionHtml = optionHtml + "<select name=""item_option"" id=""" + cstr(j) + """ title=""" & optionTypeStr & """ style=""width:100%;"" onchange=""CheckMultiOption(this)"">"
	        optionHtml = optionHtml + "<option value="""" selected>" & optionTypeStr & "</option>"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
    	        end if
    	    Next
    	    optionHtml = optionHtml + "</select>"
			optionHtml = optionHtml + "</div>"
    	Next

    	set oItemOptionMultipleType = Nothing
    END IF

    GetOptionBox2016 = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

end Function

function GetItemResaleNoticeButton(byVal itemId, byVal isSoldOut)
	dim strItemId
	strItemId = cStr(itemId)
	if isSoldOut then
		if (IsUserLoginOK) then
			if isapp = "1" then
				GetItemResaleNoticeButton = "<button type='button' class='btnV16a btn-line-blue' onclick=""fnAPPpopupBrowserURL('입고알림신청','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/pop_stock.asp?itemid="+strItemId+"');return false;"">입고알림</button>"
			else
				GetItemResaleNoticeButton = "<button type='button' class='btnV16a btn-line-blue' onclick=""fnOpenModal('/category/pop_stock.asp?itemid="+strItemId+"');return false;"">입고알림</button>"
			end if	
		else 
			GetItemResaleNoticeButton = "<button type='button' class='btnV16a btn-line-blue' onclick=""alert('로그인 후 재입고 알림 신청이 가능합니다.');location.href='/login/login.asp?backpath='+escape(document.location.href.substring(document.location.href.indexOf('.kr')+3));"">입고알림</button>"
		end if
	else
		GetItemResaleNoticeButton = ""
	end if
end function

'' 상품 페이지 에서 사용 2017-07-05 2017- 이종화
function GetOptionBox2017(byVal iItemID, byVal isItemSoldOut)
    GetOptionBox2017 = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml, optionBoxValue ,optionsCls , ScriptHtmlAdd

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end If
        
		ScriptHtml = VbCrlf & "<script>" & VbCrlf
        ScriptHtml = ScriptHtml & "$(""#opttag"").html('<a href=""#lyDropdown"" class=""btnDrop layer on"" ref="""& optionTypeStr &""">"& optionTypeStr &"</a><input type=""hidden"" name=""item_option"" ref=""""/>')" & VbCrlf
        ScriptHtml = ScriptHtml & "</script>" & VbCrlf


		optionHtml = optionHtml & "<ul style=""display:none;"">"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""
    	    optionBoxValue		= ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = "<div class=option onClick=""alert('품절된 옵션은 선택하실 수 없습니다.');return false"" >" & optionKindStr & " (품절)</div>"
        		optionBoxStyle = ""
        		optionBoxValue = " soldout='Y'"
				optionsCls	= "class=""soldout reIn"""
        	else
        		optionBoxValue = " soldout='N'"
				optionsCls	= "class="'option'"
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr & " (" & FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  & "원 추가)"
        	        optionBoxValue = optionBoxValue & " addPrice='" & oitemoption.FItemList(i).Foptaddprice & "'"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			optionKindStr = optionKindStr & " (한정 " & CStr(oItemOption.FItemList(i).GetOptLimitEa) & " 개)"
        			optionBoxValue = optionBoxValue & " limitEa='" & oItemOption.FItemList(i).GetOptLimitEa & "'"
            	end if
            end if

            optionHtml = optionHtml & "<li "& optionsCls &" id='"& optionSoldOutFlag &"' "& optionBoxStyle & optionBoxValue & " value2='" & CStr(oItemOption.FItemList(i).FitemOption) & "'>" & optionKindStr & GetItemResaleNoticeButton(iItemID, oItemOption.FItemList(i).IsOptionSoldOut) & "</li>"
    	next
		optionHtml = optionHtml & "</ul>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf & "<script>" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_Code = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_Name = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_addprice = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_S = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_LimitEa = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml & " Mopt_Code[" & CStr(i) & "] = '" & oItemOption.FItemList(i).FItemOption & "';" & VbCrlf
            ScriptHtml = ScriptHtml & " Mopt_Name[" & CStr(i) & "] = """ & doubleQuote(oItemOption.FItemList(i).FOptionName+ GetItemResaleNoticeButton(oItemOption.FItemList(i).FItemOption, oItemOption.FItemList(i).IsOptionSoldOut)) & """;"
            ScriptHtml = ScriptHtml & " Mopt_addprice[" & CStr(i) & "] = '" & CStr(oItemOption.FItemList(i).Foptaddprice) & "';" & VbCrlf
            ScriptHtml = ScriptHtml & " Mopt_S[" & CStr(i) & "] = " & optionSoldOutFlag & ";" & VbCrlf
            ScriptHtml = ScriptHtml & " Mopt_LimitEa[" & CStr(i) & "] = '" & CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") & "';" & VbCrlf
        next
        ScriptHtml = ScriptHtml & "</script>" & VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if
			optionHtml = optionHtml & "<ul style=""display:none;"">"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr & " (" & FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  & "원 추가)"
                	    end if

        	            optionHtml = optionHtml & "<li id='' " & optionBoxStyle & " value2='" & CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) & CStr(oItemOptionMultiple.FItemList(i).FKindSeq) & optionKindStr & "'><div class=""option"">" & optionKindStr & "</div></li>"
    	            ''end if
    	        end if
    	    Next
			optionHtml = optionHtml & "</ul>"
    	Next

		ScriptHtmlAdd = ScriptHtmlAdd & "<script>" & VbCrlf
		ScriptHtmlAdd = ScriptHtmlAdd & "$(""#opttag"").html('"
		For j=0 to MultipleOptionCount - 1
			optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end If
			ScriptHtmlAdd = ScriptHtmlAdd & "<a href=""#lyDropdown"" id="""& CStr(j) &""" class=""btnDrop layer"& chkiif(j=0," on","") &""" ref="""& optionTypeStr &""" "& chkiif(j>0," disabled=""disabled""","") &">"& optionTypeStr &"</a>"
		Next
		For j=0 to MultipleOptionCount - 1
			ScriptHtmlAdd = ScriptHtmlAdd & "<input type=""hidden"" name=""item_option"" ref="""" />"
		Next
		ScriptHtmlAdd = ScriptHtmlAdd & "')" & VbCrlf
		ScriptHtmlAdd = ScriptHtmlAdd & "</script>" & VbCrlf

    	set oItemOptionMultipleType = Nothing
    END IF

    GetOptionBox2017 = ScriptHtml & optionHtml & ScriptHtmlAdd

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

end Function

'' 상품 페이지 에서 사용 + 플로팅바 컨트롤 2014-04-21 이종화 추가 작업중
function GetOptionLayerBoxHTML(byVal iItemID, byVal isItemSoldOut)
    GetOptionLayerBoxHTML = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if


		optionHtml = optionHtml + "<dl class='optForm'>"
		optionHtml = optionHtml + "<dt>" + optionTypeStr + "</dt>"
		optionHtml = optionHtml + "<dd>"
        optionHtml = optionHtml + "<ul value=''><li>선택</li>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag= "S"&i

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = "<div class=option onClick=""alert('품절된 옵션은 선택하실 수 없습니다.');return false"" >" & optionKindStr & " (품절)</div>"
        		optionBoxStyle = "class='soldout reIn'"
        	Else
				optionBoxStyle = "class='option'"
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
            	end if
            end if

            optionHtml = optionHtml + "<li id='" + optionSoldOutFlag + "' " + optionBoxStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + GetItemResaleNoticeButton(oItemOption.FItemList(i).FitemOption, oItemOption.FItemList(i).IsOptionSoldOut) + "</li>"
    	next

	    optionHtml = optionHtml + "</ul>"
		optionHtml = optionHtml + "</dd>"
		optionHtml = optionHtml + "</dl>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code2 = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name2 = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice2 = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S2 = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa2 = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code2[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name2[" + CStr(i) + "] = """ + doubleQuote(oItemOption.FItemList(i).FOptionName) + """;"
            ScriptHtml = ScriptHtml + " Mopt_addprice2[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S2[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa2[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

			optionHtml = optionHtml + "<dl class='optForm'>"
			optionHtml = optionHtml + "<dt>" + optionTypeStr + "</dt>"
			optionHtml = optionHtml + "<dd>"
            optionHtml = optionHtml + "<ul value='" + cstr(j) + "'>"
    	    optionHtml = optionHtml + "<li>선택</li>"
    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<li id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + "' value2='" + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + "' value3='" + optionKindStr + "'>" + optionKindStr + "</li>"
    	            ''end if
    	        end if
    	    Next
    	    optionHtml = optionHtml + "</ul>"
			optionHtml = optionHtml + "</dd>"
			optionHtml = optionHtml + "</dl>"
    	Next

    	set oItemOptionMultipleType = Nothing
    END IF

    GetOptionLayerBoxHTML = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

end Function 

''옵션별 한정 수량 표시 안할경우 사용 -- SM Case ;
function GetOptionBoxDpLimitHTML(byVal iItemID, byVal isItemSoldOut, byVal isLimitView)
    GetOptionBoxDpLimitHTML = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if

		optionHtml = optionHtml + "<p class=""tPad10"">"
		optionHtml = optionHtml + "<select name=""item_option"" title=""" & optionTypeStr & """ style=""width:100%;"">"
        optionHtml = optionHtml + "<option value="""" selected>" & optionTypeStr & "</option>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = "<div class=option onClick=""alert('품절된 옵션은 선택하실 수 없습니다.');return false"" >" & optionKindStr & " (품절)</div>"
        		optionBoxStyle = "class='soldout reIn'"
        	else
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			if (isLimitView) then
	        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
	        		end if
            	end if
            end if

            optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionBoxStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + GetItemResaleNoticeButton(oItemOption.FItemList(i).FitemOption, oItemOption.FItemList(i).IsOptionSoldOut)+"</option>"
    	next

	    optionHtml = optionHtml + "</select>"
		optionHtml = optionHtml + "</p>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script language='javascript'>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name[" + CStr(i) + "] = """ + doubleQuote(oItemOption.FItemList(i).FOptionName) + """;"
            ScriptHtml = ScriptHtml + " Mopt_addprice[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

			optionHtml = optionHtml + "<p class=""tPad10"">"
			optionHtml = optionHtml + "<select name=""item_option"" id=""" + cstr(j) + """ title=""" & optionTypeStr & """ style=""width:100%;"" onChange=""CheckMultiOption(this)"">"
	        optionHtml = optionHtml + "<option value="""" selected>" & optionTypeStr & "</option>"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
    	        end if
    	    Next
    	    optionHtml = optionHtml + "</select>"
			optionHtml = optionHtml + "</p>"
    	Next

    	set oItemOptionMultipleType = Nothing
    END IF

    GetOptionBoxDpLimitHTML = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

end Function

''옵션별 한정 수량 표시 안할경우 사용 -- SM Case ; 2016-05-08 2016 플로팅 버전 - 이종화
function GetOptionBoxDpLimit2016(byVal iItemID, byVal isItemSoldOut, byVal isLimitView)
    GetOptionBoxDpLimit2016 = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml , optionBoxValue

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if

		optionHtml = optionHtml + "<div>"
		optionHtml = optionHtml + "<select name=""item_option"" title=""" & optionTypeStr & """>"
        optionHtml = optionHtml + "<option value="""" selected>" & optionTypeStr & "</option>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""
    	    optionBoxValue		= ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = "<div class=option onClick=""alert('품절된 옵션은 선택하실 수 없습니다.');return false"" >" & optionKindStr & " (품절)</div>"
        		optionBoxStyle = "class='soldout reIn'"
        		optionBoxValue = " soldout='Y'"
        	Else
        	    optionBoxValue = " soldout='N'"
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
					optionBoxValue = optionBoxValue & " addPrice='" & oitemoption.FItemList(i).Foptaddprice & "'"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			if (isLimitView) then
	        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
	        		end If
					optionBoxValue = optionBoxValue & " limitEa='" & oItemOption.FItemList(i).GetOptLimitEa & "'"					
            	end if
            end if

            optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionBoxStyle + optionBoxValue + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</option>"
    	next

	    optionHtml = optionHtml + "</select>"
		optionHtml = optionHtml + "</div>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script language='javascript'>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name[" + CStr(i) + "] = """ + doubleQuote(oItemOption.FItemList(i).FOptionName) + """;"
            ScriptHtml = ScriptHtml + " Mopt_addprice[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

			If j=0 then
			optionHtml = optionHtml + "<div>"
			Else
			optionHtml = optionHtml + "<div class=""tMar0-9r"">"
			End If 
			optionHtml = optionHtml + "<select name=""item_option"" id=""" + cstr(j) + """ title=""" & optionTypeStr & """ style=""width:100%;"" onChange=""CheckMultiOption(this)"">"
	        optionHtml = optionHtml + "<option value="""" selected>" & optionTypeStr & "</option>"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
    	        end if
    	    Next
    	    optionHtml = optionHtml + "</select>"
			optionHtml = optionHtml + "</div>"
    	Next

    	set oItemOptionMultipleType = Nothing
    END IF

    GetOptionBoxDpLimit2016 = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

end Function

''옵션별 한정 수량 표시 안할경우 사용 -- SM Case ; 2017-07-05 2017 - 이종화
function GetOptionBoxDpLimit2017(byVal iItemID, byVal isItemSoldOut, byVal isLimitView)
    GetOptionBoxDpLimit2017 = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml , optionBoxValue , optionsCls , ScriptHtmlAdd

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end If
        
		ScriptHtml = VbCrlf & "<script>" & VbCrlf
        ScriptHtml = ScriptHtml & "$(""#opttag"").html('<a href=""#lyDropdown"" class=""btnDrop layer on"" ref="""& optionTypeStr &""">"& optionTypeStr &"</a><input type=""hidden"" name=""item_option"" ref=""""/>')" & VbCrlf
        ScriptHtml = ScriptHtml & "</script>" & VbCrlf

		optionHtml = optionHtml & "<ul style=""display:none;"">"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""
    	    optionBoxValue		= ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = "<div class=option onClick=""alert('품절된 옵션은 선택하실 수 없습니다.');return false"" >" & optionKindStr & " (품절)</div>"
        		optionBoxStyle = ""
        		optionBoxValue = " soldout='Y'"
				optionsCls	= "class='soldout reIn'"
        	Else
        	    optionBoxValue = " soldout='N'"
				optionsCls	= "class="""""
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr & " (" & FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  & "원 추가)"
					optionBoxValue = optionBoxValue & " addPrice='" & oitemoption.FItemList(i).Foptaddprice & "'"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			if (isLimitView) then
	        			optionKindStr = optionKindStr & " (한정 " & CStr(oItemOption.FItemList(i).GetOptLimitEa) & " 개)"
	        		end If
					optionBoxValue = optionBoxValue & " limitEa='" & oItemOption.FItemList(i).GetOptLimitEa & "'"
            	end if
            end if

            optionHtml = optionHtml & "<li "& optionsCls &" id='" & optionSoldOutFlag & "' " & optionBoxStyle & optionBoxValue & " value2='" & CStr(oItemOption.FItemList(i).FitemOption) & "'><div class=""option"">" & optionKindStr & "</div>"+GetItemResaleNoticeButton(iItemID, oItemOption.FItemList(i).IsOptionSoldOut)+"</li>"
    	next

		optionHtml = optionHtml & "</ul>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script>" + VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_Code = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_Name = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_addprice = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_S = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        ScriptHtml = ScriptHtml & " var Mopt_LimitEa = new Array(" & CStr(oItemOption.FResultCount) &");" & VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml & " Mopt_Code[" & CStr(i) & "] = '" & oItemOption.FItemList(i).FItemOption & "';" & VbCrlf
            ScriptHtml = ScriptHtml & " Mopt_Name[" & CStr(i) & "] = """ & doubleQuote(oItemOption.FItemList(i).FOptionName) & """;"
            ScriptHtml = ScriptHtml & " Mopt_addprice[" & CStr(i) & "] = '" & CStr(oItemOption.FItemList(i).Foptaddprice) & "';" & VbCrlf
            ScriptHtml = ScriptHtml & " Mopt_S[" & CStr(i) & "] = " & optionSoldOutFlag & ";" & VbCrlf
            ScriptHtml = ScriptHtml & " Mopt_LimitEa[" & CStr(i) & "] = '" & CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") & "';" & VbCrlf
        next
        ScriptHtml = ScriptHtml & "</script>" & VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

			optionHtml = optionHtml & "<ul style=""display:none;"">"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr & " (" & FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  & "원 추가)"
                	    end if

        	            optionHtml = optionHtml & "<li id='' " & optionBoxStyle & " value2='" & CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) & CStr(oItemOptionMultiple.FItemList(i).FKindSeq) & optionKindStr & "'><div class=""option"">" & optionKindStr & "</div></li>"
    	            ''end if
    	        end if
    	    Next
			optionHtml = optionHtml & "</ul>"
    	Next

		ScriptHtmlAdd = ScriptHtmlAdd & "<script>" & VbCrlf
		ScriptHtmlAdd = ScriptHtmlAdd & "$(""#opttag"").html('"
		For j=0 to MultipleOptionCount - 1
			optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end If
			ScriptHtmlAdd = ScriptHtmlAdd & "<a href=""#lyDropdown"" id="""& CStr(j) &""" class=""btnDrop layer"& chkiif(j=0," on","") &""" ref="""& optionTypeStr &""" "& chkiif(j>0," disabled=""disabled""","") &">"& optionTypeStr &"</a>"
		Next
		For j=0 to MultipleOptionCount - 1
			ScriptHtmlAdd = ScriptHtmlAdd & "<input type=""hidden"" name=""item_option"" ref="""" />"
		Next
		ScriptHtmlAdd = ScriptHtmlAdd & "')" & VbCrlf
		ScriptHtmlAdd = ScriptHtmlAdd & "</script>" & VbCrlf

    	set oItemOptionMultipleType = Nothing
    END IF

    GetOptionBoxDpLimit2017 = ScriptHtml & optionHtml & ScriptHtmlAdd

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

end function


'' OldType Option Box를 한 콤보로 표시
function getOneTypeOptionBoxHtml(byVal iItemID, byVal isItemSoldOut, byval iOptionBoxStyle)
	dim i, optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionSubStyle
    dim oItemOption

	set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
    if (Trim(optionTypeStr)="") then
        optionTypeStr = "옵션 선택"
    else
        optionTypeStr = optionTypeStr + " 선택"
    end if

	optionHtml = "<select name='item_option' " + iOptionBoxStyle + ">"
    optionHtml = optionHtml + "<option value='' selected>" & optionTypeStr & "</option>"


    for i=0 to oItemOption.FResultCount-1
	    optionKindStr       = oItemOption.FItemList(i).FOptionName
	    optionSoldOutFlag   = ""

		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

		''품절일경우 한정표시 안함
    	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
    		optionKindStr = "<div class=option onClick=""alert('품절된 옵션은 선택하실 수 없습니다.');return false"" >" & optionKindStr & " (품절)</div>"
    		optionSubStyle = "class='soldout reIn'"
    	else
    	    if (oitemoption.FItemList(i).Foptaddprice>0) then
    	    '' 추가 가격
    	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
    	    end if

    	    if (oitemoption.FItemList(i).IsLimitSell) then
    		''옵션별로 한정수량 표시
    			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
        	end if
        	optionSubStyle = ""
        end if

        optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionSubStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + GetItemResaleNoticeButton(oItemOption.FItemList(i).FitemOption, oItemOption.FItemList(i).IsOptionSoldOut)+"</option>"
	next

	optionHtml = optionHtml + "</select>"

	getOneTypeOptionBoxHtml = optionHtml
	set oItemOption = Nothing
end function


'' OldType Option Box를 한 콤보로 표시
''옵션별 한정 수량 표시 안할경우 사용 -- SM Case ;
function getOneTypeOptionBoxDpLimitHtml(byVal iItemID, byVal isItemSoldOut, byval iOptionBoxStyle, byVal isLimitView)
	dim i, optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionSubStyle
    dim oItemOption

	set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
    if (Trim(optionTypeStr)="") then
        optionTypeStr = "옵션 선택"
    else
        optionTypeStr = optionTypeStr + " 선택"
    end if

	optionHtml = "<select name='item_option' " + iOptionBoxStyle + ">"
    optionHtml = optionHtml + "<option value='' selected>" & optionTypeStr & "</option>"


    for i=0 to oItemOption.FResultCount-1
	    optionKindStr       = oItemOption.FItemList(i).FOptionName
	    optionSoldOutFlag   = ""

		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

		''품절일경우 한정표시 안함
    	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
    		optionKindStr = optionKindStr + " (품절)"
    		optionSubStyle = "style='color:#DD8888'"
    	else
    	    if (oitemoption.FItemList(i).Foptaddprice>0) then
    	    '' 추가 가격
    	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
    	    end if

    	    if (oitemoption.FItemList(i).IsLimitSell) then
    		''옵션별로 한정수량 표시
    			if (isLimitView) then
	    			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
	    		end if
        	end if
        	optionSubStyle = ""
        end if

        optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionSubStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</option>"
	next

	optionHtml = optionHtml + "</select>"

	getOneTypeOptionBoxDpLimitHtml = optionHtml
	set oItemOption = Nothing
end function

'-------------------------------- 앱 상품상세 페이지 에서 사용 --------------------------------
''옵션별 한정 수량 표시 안할경우 사용 -- SM Case ;
function GetappOptionBoxDpLimitHTML(byVal iItemID, byVal isItemSoldOut, byVal isLimitView)
    GetappOptionBoxDpLimitHTML = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if

		optionHtml = optionHtml + "<div class='input-block'>"
		optionHtml = optionHtml + "		<label class='input-label' for='option'>" + optionTypeStr + "</label>"
		optionHtml = optionHtml + "		<div class='input-controls'>"
        optionHtml = optionHtml + "			<select name='item_option' class='form full-size'>"
	    optionHtml = optionHtml + "				<option value='' selected>선택</option>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = optionKindStr + " (품절)"
        		optionBoxStyle = "style='color:#DD8888'"
        	else
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			if (isLimitView) then
	        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
	        		end if
            	end if
            end if

            optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionBoxStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</option>"
    	next

	    optionHtml = optionHtml + "			</select>"
		optionHtml = optionHtml + "		</div>"
		optionHtml = optionHtml + "</div>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script language='javascript'>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FOptionName + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_addprice[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

			optionHtml = optionHtml + "<div class='input-block'>"
			optionHtml = optionHtml + "		<label class='input-label' for='option'>" + optionTypeStr + "</label>"
			optionHtml = optionHtml + "		<div class='input-controls'>"
	        optionHtml = optionHtml + "			<select name='item_option' id='" + cstr(j) + "' class='form full-size' onChange='CheckMultiOption(this)'>"
		    optionHtml = optionHtml + "				<option value='' selected>선택</option>"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
    	        end if
    	    Next
    	    
		    optionHtml = optionHtml + "			</select>"
			optionHtml = optionHtml + "		</div>"
			optionHtml = optionHtml + "</div>"
    	Next

    	set oItemOptionMultipleType = Nothing
    END IF

    GetappOptionBoxDpLimitHTML = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing
end function

'' 상품 페이지 에서 사용
function GetappOptionBoxHTML(byVal iItemID, byVal isItemSoldOut)
    GetappOptionBoxHTML = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if

		optionHtml = optionHtml + "<div class='input-block'>"
		optionHtml = optionHtml + "		<label class='input-label' for='option'>" + optionTypeStr + "</label>"
		optionHtml = optionHtml + "		<div class='input-controls'>"
        optionHtml = optionHtml + "			<select name='item_option' class='form full-size'>"
	    optionHtml = optionHtml + "				<option value='' selected>선택</option>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = optionKindStr + " (품절)"
        		optionBoxStyle = "style='color:#DD8888'"
        	else
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
            	end if
            end if

            optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionBoxStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</option>"
    	next

	    optionHtml = optionHtml + "			</select>"
		optionHtml = optionHtml + "		</div>"
		optionHtml = optionHtml + "</div>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script language='javascript'>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FOptionName + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_addprice[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

			optionHtml = optionHtml + "<div class='input-block'>"
			optionHtml = optionHtml + "		<label class='input-label' for='option'>" + optionTypeStr + "</label>"
			optionHtml = optionHtml + "		<div class='input-controls'>"
	        optionHtml = optionHtml + "			<select name='item_option' id='" + cstr(j) + "' class='form full-size' onChange='CheckMultiOption(this)'>"
		    optionHtml = optionHtml + "				<option value='' selected>선택</option>"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
    	        end if
    	    Next
    	    
		    optionHtml = optionHtml + "			</select>"
			optionHtml = optionHtml + "		</div>"
			optionHtml = optionHtml + "</div>"
    	Next

    	set oItemOptionMultipleType = Nothing
    END IF

    GetappOptionBoxHTML = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing
end Function



'' 비트윈 상품 페이지 에서 사용
function GetBetweenLayerBoxHTML(byVal iItemID, byVal isItemSoldOut)
    GetBetweenLayerBoxHTML = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount, t
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
'        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
'        if (Trim(optionTypeStr)="") then
'            optionTypeStr = "옵션 선택"
'        else
'            optionTypeStr = optionTypeStr
'        end if


'		optionHtml = optionHtml + "<dl class='optForm'>"
'		optionHtml = optionHtml + "<dt>" + optionTypeStr + "</dt>"
'		optionHtml = optionHtml + "<dd>"
'        optionHtml = optionHtml + "<ul value=''><li>선택</li>"

'	    for i=0 to oItemOption.FResultCount-1
'    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
'    	    optionSoldOutFlag   = ""
'    	    optionBoxStyle      = ""

'    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag= "S"&i

    		''품절일경우 한정표시 안함
'        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
'        		optionKindStr = optionKindStr + " (품절)"
'        		optionBoxStyle = "style='color:#DD8888'"
'        	else
'        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
'        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
'        	    end if

'        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
'        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
'            	end if
'            end if

'            optionHtml = optionHtml + "<li id='" + optionSoldOutFlag + "' " + optionBoxStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</li>"
'    	next

'	    optionHtml = optionHtml + "</ul>"
'		optionHtml = optionHtml + "</dd>"
'		optionHtml = optionHtml + "</dl>"


        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if

        optionHtml = optionHtml + "			<select name='item_option' class='optSelect'>"
	    optionHtml = optionHtml + "				<option value='' selected>"&optionTypeStr&" 선택</option>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = optionKindStr + " (품절)"
        		optionBoxStyle = "style='color:#DD8888'"
        	else
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
            	end if
            end if

            optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionBoxStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</option>"
    	next

	    optionHtml = optionHtml + "			</select>"

    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name[" + CStr(i) + "] = """ + doubleQuote(oItemOption.FItemList(i).FOptionName) + """;"
            ScriptHtml = ScriptHtml + " Mopt_addprice[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

'			optionHtml = optionHtml + "<dl class='optForm'>"
'			optionHtml = optionHtml + "<dt>" + optionTypeStr + "</dt>"
'			optionHtml = optionHtml + "<dd>"
'            optionHtml = optionHtml + "<ul id='"&cstr(j)&"'' name='item_option' >"
'    	    optionHtml = optionHtml + "<li>선택</li>"
'    	    for i=0 to oItemOptionMultiple.FResultCount-1
'    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

'        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

'                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
'                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
'                	    end if

'        	            optionHtml = optionHtml + "<li id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + "' value2='" + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + "' value3='" + optionKindStr + "'>" + optionKindStr + "</li>"
'        	            optionHtml = optionHtml + "<li value='"&cstr(j)&"' value2='"&CStr(oItemOptionMultiple.FItemList(i).FTypeSeq)&CStr(oItemOptionMultiple.FItemList(i).FKindSeq)&optionKindStr&"'>" + optionKindStr + "</li>"
    	            ''end if
'    	        end if
'    	    Next
'    	    optionHtml = optionHtml + "</ul>"
'			optionHtml = optionHtml + "</dd>"
'			optionHtml = optionHtml + "</dl>"

'			optionHtml = optionHtml + "<dl class='optForm'><dd><ul class='itemoption'>"
'	        optionHtml = optionHtml + "			<select name='item_option' id='" + cstr(j) + "' class='form full-size' onChange='CheckMultiLi(this)'>"
'		    optionHtml = optionHtml + "				<option value='' selected>선택</option>"
'    	    for t=0 to oItemOptionMultiple.FResultCount-1
'    	        if (oItemOptionMultiple.FItemList(t).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(t).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

'        	            optionKindStr     = oItemOptionMultiple.FItemList(t).FOptionKindName

 '               	    if (oItemOptionMultiple.FItemList(t).Foptaddprice>0) then
                	    '' 추가 가격
'                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(t).Foptaddprice,0)  + "원 추가)"
'                	    end if

'        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(t).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(t).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
'    	        end if
'    	    Next
    	    
'		    optionHtml = optionHtml + "			</select></ul></dd></dl>"


 '   	Next

	        optionHtml = optionHtml + "			<select name='item_option' id='" + cstr(j) + "' class='optSelect' onChange='CheckMultiOption(this)'>"
		    optionHtml = optionHtml + "				<option value='' selected>"&optionTypeStr&" 선택</option>"

    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
    	        end if
    	    Next
    	    
		    optionHtml = optionHtml + "			</select>"
    	Next



    	set oItemOptionMultipleType = Nothing
    END IF

    GetBetweenLayerBoxHTML = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

end Function 


'' 플로팅 li selectBox 테스트(2014.04.29 원승현작업중)
function GetBetweenLayerBoxHTML_Test(byVal iItemID, byVal isItemSoldOut)

    GetBetweenLayerBoxHTML_Test = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount, t
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    set oItemOptionMultiple = new CItemOption
    oItemOptionMultiple.FRectItemID = iItemID
    oItemOptionMultiple.GetOptionMultipleList

    ''이중 옵션인지..
    IsMultipleOption = (oItemOptionMultiple.FResultCount>0)

    optionHtml = ""

    IF (Not IsMultipleOption) then
    ''단일 옵션.
        optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
        if (Trim(optionTypeStr)="") then
            optionTypeStr = "옵션 선택"
        else
            optionTypeStr = optionTypeStr
        end if


		optionHtml = optionHtml + "<dl class='optForm'>"
		optionHtml = optionHtml + "<dt>" + optionTypeStr + "</dt>"
		optionHtml = optionHtml + "<dd>"
        optionHtml = optionHtml + "<ul value=''><li>선택</li>"

	    for i=0 to oItemOption.FResultCount-1
    	    optionKindStr       = oItemOption.FItemList(i).FOptionName
    	    optionSoldOutFlag   = ""
    	    optionBoxStyle      = ""

    		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag= "S"&i

    		''품절일경우 한정표시 안함
        	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
        		optionKindStr = optionKindStr + " (품절)"
        		optionBoxStyle = "style='color:#DD8888'"
        	else
        	    if (oitemoption.FItemList(i).Foptaddprice>0) then
        	    '' 추가 가격
        	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
        	    end if

        	    if (oitemoption.FItemList(i).IsLimitSell) then
        		''옵션별로 한정수량 표시
        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
            	end if
            end if

            optionHtml = optionHtml + "<li id='" + optionSoldOutFlag + "' " + optionBoxStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</li>"
    	next

	    optionHtml = optionHtml + "</ul>"
		optionHtml = optionHtml + "</dd>"
		optionHtml = optionHtml + "</dl>"
    ELSE
    ''이중 옵션.
        set oItemOptionMultipleType = new CItemOption
        oItemOptionMultipleType.FRectItemId = iItemID
        oItemOptionMultipleType.GetOptionMultipleTypeList

        MultipleOptionCount = oItemOptionMultipleType.FResultCount

        ScriptHtml = VbCrlf + "<script>" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Code = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_Name = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_addprice = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_S = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        ScriptHtml = ScriptHtml + " var Mopt_LimitEa = new Array(" + CStr(oItemOption.FResultCount) +");" + VbCrlf
        for i=0 to oItemOption.FResultCount-1
            optionSoldOutFlag   = "false"
            optionBoxStyle      = ""

            if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="true"

            ScriptHtml = ScriptHtml + " Mopt_Code[" + CStr(i) + "] = '" + oItemOption.FItemList(i).FItemOption + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_Name[" + CStr(i) + "] = """ + doubleQuote(oItemOption.FItemList(i).FOptionName) + """;"
            ScriptHtml = ScriptHtml + " Mopt_addprice[" + CStr(i) + "] = '" + CStr(oItemOption.FItemList(i).Foptaddprice) + "';" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_S[" + CStr(i) + "] = " + optionSoldOutFlag + ";" + VbCrlf
            ScriptHtml = ScriptHtml + " Mopt_LimitEa[" + CStr(i) + "] = '" + CHKIIF(oItemOption.FItemList(i).IsLimitSell,CStr(oItemOption.FItemList(i).GetOptLimitEa),"") + "';" + VbCrlf
        next
        ScriptHtml = ScriptHtml + "</script>" + VbCrlf

        for j=0 to MultipleOptionCount - 1
            optionTypeStr = oItemOptionMultipleType.FItemList(j).FoptionTypeName
            if (Trim(optionTypeStr)="") then
                optionTypeStr="옵션 선택"
            else
                optionTypeStr = optionTypeStr
            end if

			optionHtml = optionHtml + "<dl class='optForm'>"
			optionHtml = optionHtml + "<dt>" + optionTypeStr + "</dt>"
			optionHtml = optionHtml + "<dd>"
            optionHtml = optionHtml + "<ul id='"&cstr(j)&"'' name='item_option' >"
    	    optionHtml = optionHtml + "<li>선택</li>"
    	    for i=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(i).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(i).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(i).FOptionKindName

                	    if (oItemOptionMultiple.FItemList(i).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(i).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<li id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(i).FTypeSeq) + "' value2='" + CStr(oItemOptionMultiple.FItemList(i).FKindSeq) + "' value3='" + optionKindStr + "'>" + optionKindStr + "</li>"
        	            optionHtml = optionHtml + "<li value='"&cstr(j)&"' value2='"&CStr(oItemOptionMultiple.FItemList(i).FTypeSeq)&CStr(oItemOptionMultiple.FItemList(i).FKindSeq)&optionKindStr&"'>" + optionKindStr + "</li>"
    	            ''end if
    	        end if
    	    Next
    	    optionHtml = optionHtml + "</ul>"
			optionHtml = optionHtml + "</dd>"
			optionHtml = optionHtml + "</dl>"

			optionHtml = optionHtml + "<dl class='optForm'><dd><ul class='itemoption'>"
	        optionHtml = optionHtml + "			<select name='item_option' id='" + cstr(j) + "' class='form full-size' onChange='CheckMultiLi(this)'>"
		    optionHtml = optionHtml + "				<option value='' selected>선택</option>"
    	    for t=0 to oItemOptionMultiple.FResultCount-1
    	        if (oItemOptionMultiple.FItemList(t).FAvailOptCNT>0) and (oItemOptionMultiple.FItemList(t).FTypeSeq=oItemOptionMultipleType.FItemList(j).FTypeSeq) then
    	            ''옵션 타입 전체가 품절인 경우 체크. => 디비에서 체크(FAvailOptCNT)
    	            ''if (oItemOption.IsValidOptionTypeExists(oItemOptionMultiple.FItemList(i).FTypeSeq, oItemOptionMultiple.FItemList(i).FKindSeq)) then

        	            optionKindStr     = oItemOptionMultiple.FItemList(t).FOptionKindName

	               	    if (oItemOptionMultiple.FItemList(t).Foptaddprice>0) then
                	    '' 추가 가격
                	        optionKindStr = optionKindStr + " (" + FormatNumber(oItemOptionMultiple.FItemList(t).Foptaddprice,0)  + "원 추가)"
                	    end if

        	            optionHtml = optionHtml + "<option id='' " + optionBoxStyle + " value='" + CStr(oItemOptionMultiple.FItemList(t).FTypeSeq) + CStr(oItemOptionMultiple.FItemList(t).FKindSeq) + optionKindStr + "'>" + optionKindStr + "</option>"
    	            ''end if
    	        end if
    	    Next
    	    
		    optionHtml = optionHtml + "			</select></ul></dd></dl>"
	   	Next
    	set oItemOptionMultipleType = Nothing
    END IF

    GetBetweenLayerBoxHTML_Test = ScriptHtml + optionHtml

    set oItemOption = Nothing
    set oItemOptionMultiple = Nothing

End Function 


'-------------------------------- 앱 상품상세 페이지 에서 사용 --------------------------------
%>
