<%

function fnGetDiaryGiftsCount(iuserid,ievtcode)
    dim sqlStr
    fnGetDiaryGiftsCount = 0

    sqlStr = "exec db_order.[dbo].[sp_Ten_DiaryOrderCount] '"&iuserid&"',"&ievtcode&""
    rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic

	rsget.Open sqlStr,dbget
	if Not rsget.Eof then
	    fnGetDiaryGiftsCount = rsget("diaryOrdCNT")
	end if
    rsget.Close
end function

Class CopenGiftItem
    public Fgift_code
    public Fgiftkind_code
    public Fgift_type
    public Fgift_range1
    public Fgift_range2
    public Fgift_name
    public Fgiftkind_name
    public Fimage120

    public Fchg_giftStr
    public Fevt_code
    public Fevt_name

    public Fgift_delivery
    public Fgiftkind_limit
    public Fgiftkind_givecnt
    public Fgiftkind_cnt
    public Fgift_scope

    public function IsGiftItemSoldOut()
        IsGiftItemSoldOut = (Fgiftkind_limit>0) and (Fgiftkind_limit-Fgiftkind_givecnt<1)
    end function

    public function getGiftLimitStr()
        Dim limitEa
        getGiftLimitStr = ""
        IF (Fgiftkind_limit>0) THEN
            limitEa = Fgiftkind_limit-Fgiftkind_givecnt
            IF (limitEa<1) then limitEa=0

            IF (limitEa>50) then Exit function

            ''getGiftLimitStr = "남은수량 "& limitEa&" 개"
        END IF
    end function

    public function getGiftOptionHTML(byref igiftSoldout)
        dim sqlStr, optStr : optStr=""
        dim isOptExists : isOptExists = FALSE
        dim isLimitSoldOut
        dim isNotSoldOutExists : isNotSoldOutExists = FALSE
        dim optCount,optNm

        sqlStr = "select gift_kind_option, gift_kind_optionName ,gift_Kind_LimitYN"
        sqlStr = sqlStr & ",gift_Kind_Limit,gift_Kind_LimitSold"
        sqlStr = sqlStr & " from db_event.dbo.tbl_giftkind_option"
        sqlStr = sqlStr & " where gift_kind_code="&Fgiftkind_code
        sqlStr = sqlStr & " and gift_kind_optionUsing='Y'"

        rsget.Open sqlStr,dbget,1
        optCount = rsget.RecordCount
        optNm = ""
        if Not rsget.Eof then
            Do Until rsget.Eof
                if (optCount=1) then
                    optNm="<input type='hidden' name='gOpt_" & Fgiftkind_code & "' id='' value='"&rsget("gift_kind_option")&"'>"
                end if
                isLimitSoldOut = (rsget("gift_Kind_LimitYN")="Y") and (rsget("gift_Kind_Limit")-rsget("gift_Kind_LimitSold")<1)
                if (isLimitSoldOut) then
                    optStr = optStr & "<option value='"&rsget("gift_kind_option")&"' id='S' >"&Db2HTML(rsget("gift_kind_optionName"))&" (품절)</option>"
                else
                    isNotSoldOutExists = True
                    optStr = optStr & "<option value='"&rsget("gift_kind_option")&"'>"&Db2HTML(rsget("gift_kind_optionName"))&"</option>"
                end if
                rsget.MoveNext
            Loop
            isOptExists = TRUE
        end if
        rsget.Close

        Dim RetHtml : RetHtml=""

        IF (isOptExists) Then
            RetHtml=RetHtml&"<select name='gOpt_" & Fgiftkind_code & "' id='' style='width:100%;' disabled onChange='giftOptChange(this)'>"
            RetHtml=RetHtml&"<option value=''>옵션을 선택하세요</option>"
            RetHtml=RetHtml&optStr
            RetHtml=RetHtml&"</select>"
        End IF

        ''전체 품절인경우.. 옵션표시안함(랜덤발송)
        IF (Not isNotSoldOutExists) and (optCount>0) then
            RetHtml=""
            igiftSoldout=true
        else
            igiftSoldout=false
        end if

        if (optCount=1) then
            ''getGiftOptionHTML=Replace(RetHtml,"<option value=''>옵션을선택하세요","")
            getGiftOptionHTML=optNm
        else
            getGiftOptionHTML=RetHtml
        end if
    end function

    public function getRadioName()
        getRadioName = FormatNumber(Fgift_range1,0) & "원 이상 구매시"
    end function

    function money2Str(omny)
        dim oStr : oStr = CStr(omny)
        dim i, buf, RETStr

        for i=0 to Len(oStr)-1
            buf = Mid(oStr,i+1,1)
            RETStr = RETStr + num2KorWon(buf, Len(oStr)-(i))
        next

        if (RETStr="") then RETStr=omny
        money2Str = RETStr
    end function

    function num2KorWon(num, leng)
        dim RET, Dan

        SELECT CASE num
            CASE 1 : RET = "일"
            CASE 2 : RET = "이"
            CASE 3 : RET = "삼"
            CASE 4 : RET = "사"
            CASE 5 : RET = "오"
            CASE 6 : RET = "육"
            CASE 7 : RET = "칠"
            CASE 8 : RET = "팔"
            CASE 9 : RET = "구"
            CASE 0 : RET = "공"
            CASE ELSE
                RET = num
        END SELECT

        SELECT CASE leng
            CASE 1 : Dan = ""
            CASE 2 : Dan = "십"
            CASE 3 : Dan = "백"
            CASE 4 : Dan = "천"
            CASE 5 : Dan = "만"
            CASE 6 : Dan = "십만"
            CASE 7 : Dan = "백만"
            CASE 8 : Dan = "천만"
            CASE 9 : Dan = "억"
            CASE 0 : Dan = "공"
            CASE ELSE
                Dan = leng
        END SELECT

        IF RET="공" then
            IF Dan="공" then
                num2KorWon="0"
            else
                num2KorWon=""
            end if
        else
            num2KorWon = RET&Dan
        end if
    end function


    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

End Class

Class CGiftKindOption
    public Fgift_kind_code
    public Fgift_kind_option
    public Fgift_kind_optionName
    public Fgift_kind_LimitYN
    public Fgift_kind_Limit
    public Fgift_kind_LimitSold
    public Fgift_kind_optionUsing

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class

Class CGiftKindItem
    public Fgiftkind_code
    public Fgiftkind_name
    public Fgiftkind_img
    public Fitemid
    public Fimage120
    public Fregdate

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class

Class CGiftKindItemAddImage
    public Fgiftkind_code
    public Fgift_kind_addimage
    public Faddnum

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class

Class CopenGift
    public FItemList()
    public FOneItem

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	
	public FGiftRange
	public FGiftName

	public FRectEventCode
	public FRectGiftKindCode
	public FRectOrderserial
	public FRectGiftScope
	public FRectOnlyCnt

    public function IsDiaryCouponGiftExists(iSubTotal)
        Dim i, ret : ret=false
        for i=0 to FResultCount-1
            if (FItemList(i).Fgift_delivery="C") and (iSubTotal>=FItemList(i).Fgift_range1) then
                ret = true
                Exit For
            end if
        next
        IsDiaryCouponGiftExists = ret
    end function

    public function IsCouponGiftExists(iSubTotal)
        Dim i, ret : ret=false
        for i=0 to FResultCount-1
            if (FItemList(i).Fgift_delivery="C") and (iSubTotal>=FItemList(i).Fgift_range1) then
                ret = true
                Exit For
            end if
        next
        IsCouponGiftExists = ret
    end function

	public function getOpenGiftInOrder
	    dim sqlStr, i
	    sqlStr = " select O.*,E.evt_code, E.evt_name from db_order.dbo.tbl_order_Gift O"
	    sqlStr = sqlStr & " Join db_event.dbo.tbl_Gift G"
	    sqlStr = sqlStr & " on O.gift_code=G.gift_code"
	    sqlStr = sqlStr & " Join db_event.dbo.tbl_event E"
	    sqlStr = sqlStr & " on E.evt_code=G.evt_code"
        sqlStr = sqlStr & " where O.orderserial='" & FRectOrderserial & "'"
        sqlStr = sqlStr & " and O.gift_scope in (1,9)"
        sqlStr = sqlStr & " and O.chg_giftStr is Not NULL"
        rsget.Open sqlStr,dbget,1
        FResultCount = rsget.RecordCount
        FTotalPage   = FResultCount

        redim preserve FItemList(FResultCount)
		i=0

        if Not rsget.Eof then
            do until rsget.Eof
                SET FItemList(i) = new CopenGiftItem
                FItemList(i).Fgift_code         = rsget("gift_code")
                FItemList(i).Fgiftkind_code     = rsget("giftkind_code")
                FItemList(i).Fgift_type         = rsget("gift_type")
                FItemList(i).Fgift_range1       = rsget("gift_range1")
                FItemList(i).Fgift_range2       = rsget("gift_range2")
                FItemList(i).Fchg_giftStr       = db2html(rsget("chg_giftStr"))
                FItemList(i).Fevt_code          = rsget("evt_code")
                FItemList(i).Fevt_name          = db2html(rsget("evt_name"))
                if Not isNull(FItemList(i).Fevt_name) then FItemList(i).Fevt_name = split(FItemList(i).Fevt_name,"|")(0)

                FItemList(i).Fgift_scope     = rsget("gift_scope")
                FItemList(i).Fgiftkind_cnt   = rsget("giftkind_cnt")
                i=i+1
                rsget.MoveNext
            loop
        end if
        rsget.Close
    end function

    public function getGiftListInOrder
	    dim sqlStr, i
	    ''' 201204 리뉴얼시 추가.
	    sqlStr = " select O.*,G.gift_name as evt_name, O.chg_giftStr, Gk.giftkind_name "
	    sqlStr = sqlStr & " from db_order.dbo.tbl_order_Gift O"
	    sqlStr = sqlStr & " Join db_event.dbo.tbl_Gift G"
	    sqlStr = sqlStr & " on O.gift_code=G.gift_code"
	    sqlStr = sqlStr & " Join db_event.dbo.tbl_giftkind Gk"
		sqlStr = sqlStr & " on O.giftkind_code=Gk.giftkind_code"
	    ''sqlStr = sqlStr & " 	left Join db_event.dbo.tbl_event E"
	    ''sqlStr = sqlStr & " 	on E.evt_code=G.evt_code"
        sqlStr = sqlStr & " where O.orderserial='" & FRectOrderserial & "'"

        rsget.Open sqlStr,dbget,1
        FResultCount = rsget.RecordCount
        FTotalPage   = FResultCount

        redim preserve FItemList(FResultCount)
		i=0

        if Not rsget.Eof then
            do until rsget.Eof
                SET FItemList(i) = new CopenGiftItem
                FItemList(i).Fgift_code         = rsget("gift_code")
                FItemList(i).Fgiftkind_code     = rsget("giftkind_code")
                FItemList(i).Fgift_type         = rsget("gift_type")
                FItemList(i).Fgift_range1       = rsget("gift_range1")
                FItemList(i).Fgift_range2       = rsget("gift_range2")
                FItemList(i).Fchg_giftStr       = db2html(rsget("chg_giftStr"))
                FItemList(i).Fgiftkind_name		= db2html(rsget("giftkind_name"))
                ''FItemList(i).Fevt_code          = rsget("evt_code")
                FItemList(i).Fevt_name          = db2html(rsget("evt_name"))
                if Not isNull(FItemList(i).Fevt_name) then FItemList(i).Fevt_name = split(FItemList(i).Fevt_name,"|")(0)

                FItemList(i).Fgift_scope     = rsget("gift_scope")
                FItemList(i).Fgiftkind_cnt   = rsget("giftkind_cnt")
                i=i+1
                rsget.MoveNext
            loop
        end if
        rsget.Close
    end function

	public function IsOpenGiftExists(byRef evt_code, banImage, evtDesc)
	    dim sqlStr
	    sqlStr = "select top 1 O.event_code, O.openImage1, O.openHTML"
        sqlStr = sqlStr & " from db_event.dbo.tbl_openGift O"
        sqlStr = sqlStr & "     Join db_event.dbo.tbl_Event E"
        sqlStr = sqlStr & "     on O.event_code=E.evt_code"
        sqlStr = sqlStr & " where O.frontOpen='Y'"
        Select Case cStr(FRectGiftScope)		'적용범위(1:전체, 3:모바일, 5:APP) 20140818;허진원
        	Case "3"
        		sqlStr = sqlStr & " and O.opengiftScope in (1,3) "
        	Case "5"
        		sqlStr = sqlStr & " and O.opengiftScope in (1,3,5) "
        	Case Else
        		sqlStr = sqlStr & " and O.opengiftScope=1 "
        end Select
        sqlStr = sqlStr & " and E.evt_state=7"
        sqlStr = sqlStr & " and E.evt_using ='Y' "
        sqlStr = sqlStr & " and datediff(day,getdate(),E.evt_startdate) <=0 "
        sqlStr = sqlStr & " and datediff(day,getdate(),E.evt_enddate)>=0"
        sqlStr = sqlStr & " and O.openGiftType=1"
        sqlStr = sqlStr & " Order by O.event_code desc"

        rsget.Open sqlStr,dbget,1
        if Not rsget.Eof then
            evt_code = rsget("event_code")
            banImage = rsget("openImage1")
            evtDesc = rsget("openHTML")
            IsOpenGiftExists = TRUE
        else
            evt_code = 0
            banImage = ""
            IsOpenGiftExists = FALSE
        end if
        rsget.Close
    end function

    public function getGiftItemList(evt_code)
        dim sqlStr, i
        sqlStr = " select G.gift_code, G.giftkind_code"
        sqlStr = sqlStr & " ,G.gift_type, G.gift_range1, G.gift_range2, G.gift_name, G.gift_delivery"
        sqlStr = sqlStr & " ,K.giftkind_name, K.image120, G.giftkind_limit, G.giftkind_givecnt"
        sqlStr = sqlStr & " from db_event.dbo.tbl_gift G"
        sqlStr = sqlStr & " 	Join db_event.dbo.tbl_giftKind K"
        sqlStr = sqlStr & " 	On G.giftkind_code=K.giftkind_code"
        sqlStr = sqlStr & " where evt_code=" & evt_code
        sqlStr = sqlStr & " and gift_status=7"
        sqlStr = sqlStr & " and gift_scope=1"
        sqlStr = sqlStr & " and gift_using='Y'"
        ''sqlStr = sqlStr & " and gift_delivery='N'"  ''쿠폰 Gift인경우 업체배송으로 gift_delivery='Y'
        sqlStr = sqlStr & " Order By gift_range1, gift_delivery desc"

        rsget.Open sqlStr,dbget,1
        FResultCount = rsget.RecordCount
        FTotalPage   = FResultCount

        redim preserve FItemList(FResultCount)
		i=0

        if Not rsget.Eof then
            do until rsget.Eof
                SET FItemList(i) = new CopenGiftItem
                FItemList(i).Fgift_code         = rsget("gift_code")
                FItemList(i).Fgiftkind_code     = rsget("giftkind_code")
                FItemList(i).Fgift_type         = rsget("gift_type")
                FItemList(i).Fgift_range1       = rsget("gift_range1")
                FItemList(i).Fgift_range2       = rsget("gift_range2")
                FItemList(i).Fgift_name         = rsget("gift_name")
                FItemList(i).Fgiftkind_name     = rsget("giftkind_name")
                FItemList(i).Fimage120          = rsget("image120")

                FItemList(i).Fgift_delivery     = rsget("gift_delivery")

                FItemList(i).Fgiftkind_limit    = rsget("giftkind_limit")
                FItemList(i).Fgiftkind_givecnt  = rsget("giftkind_givecnt")
                i=i+1
                rsget.MoveNext
            loop
        end if
        rsget.Close
    end function

    public function IsDiaryOpenGiftExists(byRef evt_code, banImage)
        dim ievtDesc, ievtStDT, ievtEdDt
        call IsDiaryOpenGiftExistsWithDesc(evt_code, banImage, ievtDesc, ievtStDT, ievtEdDt)
    end function

    public function IsDiaryOpenGiftExistsWithDesc(byRef evt_code, banImage, evtDesc, evtStDT, evtEdDt)
	    dim sqlStr
	    sqlStr = "select top 1 O.event_code, O.openImage1, O.openHTML, convert(varchar(10),E.evt_startdate,21) as evtStDT,convert(varchar(10),E.evt_enddate,21) as evtEdDt"
        sqlStr = sqlStr & " from db_event.dbo.tbl_openGift O"
        sqlStr = sqlStr & "     Join db_event.dbo.tbl_Event E"
        sqlStr = sqlStr & "     on O.event_code=E.evt_code"
        sqlStr = sqlStr & " where O.frontOpen='Y'"
        Select Case cStr(FRectGiftScope)		'적용범위(1:전체, 3:모바일, 5:APP) 20140818;허진원
        	Case "3"
        		sqlStr = sqlStr & " and O.opengiftScope in (1,3) "
        	Case "5"
        		sqlStr = sqlStr & " and O.opengiftScope in (1,3,5) "
        	Case Else
        		sqlStr = sqlStr & " and O.opengiftScope=1 "
        end Select
        sqlStr = sqlStr & " and E.evt_state=7"
        sqlStr = sqlStr & " and E.evt_using ='Y' "
        sqlStr = sqlStr & " and datediff(day,getdate(),E.evt_startdate) <=0 "
        sqlStr = sqlStr & " and datediff(day,getdate(),E.evt_enddate)>=0"
        sqlStr = sqlStr & " and O.openGiftType=9"                               '''20121020/ 다이어리 이벤트 구분위해 추가
        sqlStr = sqlStr & " Order by O.event_code desc"

        rsget.Open sqlStr,dbget,1
        if Not rsget.Eof then
            evt_code = rsget("event_code")
            banImage = rsget("openImage1")
            evtDesc = rsget("openHTML")
            evtStDT  = rsget("evtStDT")
            evtEdDt  = rsget("evtEdDt")
            IsDiaryOpenGiftExistsWithDesc = TRUE
        else
            evt_code = 0
            banImage = ""
            evtDesc  = ""
            IsDiaryOpenGiftExistsWithDesc = FALSE
        end if
        rsget.Close
    end function

    public function getDiaryGiftItemList(evt_code)
        dim sqlStr, i
        sqlStr = " select G.gift_code, G.giftkind_code"
        sqlStr = sqlStr & " ,G.gift_type, G.gift_range1, G.gift_range2, G.gift_name, G.gift_delivery"
        sqlStr = sqlStr & " ,K.giftkind_name, K.image120, G.giftkind_limit, G.giftkind_givecnt"
        sqlStr = sqlStr & " from db_event.dbo.tbl_gift G"
        sqlStr = sqlStr & " 	Join db_event.dbo.tbl_giftKind K"
        sqlStr = sqlStr & " 	On G.giftkind_code=K.giftkind_code"
        sqlStr = sqlStr & " where evt_code=" & evt_code
        sqlStr = sqlStr & " and gift_status=7"
        sqlStr = sqlStr & " and gift_scope=9"
        sqlStr = sqlStr & " and gift_using='Y'"
        ''sqlStr = sqlStr & " and gift_delivery='N'"  ''쿠폰 Gift인경우 업체배송으로 gift_delivery='Y'
        sqlStr = sqlStr & " Order By gift_range1 asc , gift_delivery desc"

        rsget.Open sqlStr,dbget,1
        FResultCount = rsget.RecordCount
        FTotalPage   = FResultCount

        redim preserve FItemList(FResultCount)
		i=0

        if Not rsget.Eof then
            do until rsget.Eof
                SET FItemList(i) = new CopenGiftItem
                FItemList(i).Fgift_code         = rsget("gift_code")
                FItemList(i).Fgiftkind_code     = rsget("giftkind_code")
                FItemList(i).Fgift_type         = rsget("gift_type")
                FItemList(i).Fgift_range1       = rsget("gift_range1")
                FItemList(i).Fgift_range2       = rsget("gift_range2")
                FItemList(i).Fgift_name         = rsget("gift_name")
                FItemList(i).Fgiftkind_name     = rsget("giftkind_name")
                FItemList(i).Fimage120          = rsget("image120")

                FItemList(i).Fgift_delivery     = rsget("gift_delivery")

                FItemList(i).Fgiftkind_limit    = rsget("giftkind_limit")
                FItemList(i).Fgiftkind_givecnt  = rsget("giftkind_givecnt")
                i=i+1
                rsget.MoveNext
            loop
        end if
        rsget.Close
    end function

    public function getGiftKindItemAddImage()
        Dim sqlStr, i
        
        If FRectOnlyCnt = "o" Then
	        sqlStr = "select count(*) from db_event.dbo.tbl_giftkind_AddImage"
	        sqlStr = sqlStr & " where gift_kind_code=" & FRectGiftKindCode
	        rsget.CursorLocation = adUseClient
	        rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	        FResultCount = rsget(0)
	        rsget.Close
    	Else
    		IF FRectEventCode <> "" Then
    			sqlStr = "select gift_range1, gift_name from db_event.dbo.tbl_gift where evt_code='" & FRectEventCode & "' and giftkind_code='" & FRectGiftKindCode & "'"
		        rsget.CursorLocation = adUseClient
		        rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		        if not rsget.eof then
					FGiftRange	= rsget(0)
					FGiftName	= db2html(rsget(1))
				end if
		        rsget.Close
    		End If
    		
	        sqlStr = "select * from db_event.dbo.tbl_giftkind_AddImage"
	        sqlStr = sqlStr & " where gift_kind_code=" & FRectGiftKindCode
	        sqlStr = sqlStr & " order by addnum"
	
	        rsget.Open sqlStr,dbget,1
	        FResultCount = rsget.RecordCount
	        FTotalPage   = FResultCount
	
	        redim preserve FItemList(FResultCount)
			i=0
	
	
	        if Not rsget.Eof then
	            do until rsget.Eof
	                SET FItemList(i) = new CGiftKindItemAddImage
	                FItemList(i).Fgiftkind_code     = rsget("gift_kind_code")
	                FItemList(i).Fgift_kind_addimage= db2HTML(rsget("gift_kind_addimage"))
	                FItemList(i).Faddnum            = rsget("addnum")
	                i=i+1
	                rsget.MoveNext
	            loop
	        end if
	        rsget.Close
    	End IF

    end function

    Private Sub Class_Initialize()
		redim  FItemList(0)

		FCurrPage =1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub

	Private Sub Class_Terminate()

	End Sub

	public Function HasPreScroll()
		HasPreScroll = StarScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StarScrollPage + FScrollCount -1
	end Function

	public Function StarScrollPage()
		StarScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
End Class
%>
