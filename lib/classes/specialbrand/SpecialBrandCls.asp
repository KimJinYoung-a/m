<%
Class SpecialBrandObj
	public Fidx
	public FBrandid
	public FIsexposure
	public FFrequency
	public FExposure_seq
	public FAlways_exposure
	public FStartdate
	public FgotNewItem
	public FEnddate
	public FRegdate

    public Fsocname
    public Fsocname_kor
    public Fbrand_icon

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class SpecialBrandCls
    public FOneItem
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	PUBLIC FRectBrandId

    Public Function getSpecialBrandInfo(listtype, numOfItems, categorySort)
        dim tmpSQL,i, itemList()

        tmpSQL = " exec [db_sitemaster].[dbo].[usp_cm_special_brand_list_get] '"&listtype&"', '"&numOfItems&"', '"&categorySort&"' "
          
        rsget.CursorLocation = adUseClient
        rsget.CursorType=adOpenStatic
        rsget.Locktype=adLockReadOnly
        rsget.Open tmpSQL, dbget,2

        redim preserve itemList(rsget.recordcount)

        If Not rsget.EOF Then
            do until rsget.EOF

                set itemList(i) = new SpecialBrandObj                               

                itemList(i).FBrandid            = rsget("brandid") 
                itemList(i).Fsocname            = rsget("socname") 
                itemList(i).Fsocname_kor        = rsget("socname_kor")
                itemList(i).Fstartdate          = rsget("startdate")
                itemList(i).Fenddate            = rsget("enddate")
                itemList(i).Fbrand_icon         = rsget("brand_icon")
                itemList(i).FgotNewItem         = rsget("gotnewitem")
            
                rsget.movenext
                i=i+1
            loop
            getSpecialBrandInfo = itemList
        ELSE		
            getSpecialBrandInfo = itemList
        End if
        rsget.close
    End Function

    Public Function getSpecialBrandEvents(numOfItems)
        dim sqlStr

		sqlStr = " exec [db_sitemaster].[dbo].[usp_cm_special_brand_event_list_get] '"&numOfItems&"'"

		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			getSpecialBrandEvents = rsget.GetRows()
		END IF
		rsget.close
    End Function

    Public Function getSpecialBrandReviews(numOfItems)
        dim sqlStr

		sqlStr = " exec [db_sitemaster].[dbo].[usp_cm_special_brand_review_list_get] '"&numOfItems&"'"

		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			getSpecialBrandReviews = rsget.GetRows()
		END IF
		rsget.close
    End Function

    Public Function getSpecialBrandItems(listType, numOfItems, categorySort)
        dim sqlStr

		sqlStr = " exec [db_sitemaster].[dbo].[usp_cm_special_brand_item_list_get] '"&listType&"', '"&numOfItems&"', '"&categorySort&"'"

		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			getSpecialBrandItems = rsget.GetRows()
		END IF
		rsget.close
    End Function

	function fnEvalTotalPointAVG(t,g)
		dim vTmp
		vTmp = 0
		If t <> "" Then
			If isNumeric(t) Then
				If t > 0 Then
					If g = "search" Then
						vTmp = (t/5)
					Else
						vTmp = ((Round(t,2) * 100)/5)
					End If
					vTmp = Round(vTmp)
				End If
			End If
		End If
		fnEvalTotalPointAVG = vTmp
	end function

	'// wish리스트
	Public Function getMyWishList(userId)
		if userId = "" then
			exit function
		end if

		dim SqlStr 

		sqlStr = sqlStr & " select itemid "&vbCrLf
		sqlStr = sqlStr & "   from db_my10x10.dbo.tbl_myfavorite "&vbCrLf
		sqlStr = sqlStr & "  where userid = '" & userId & "'		 "&vbCrLf  
		sqlStr = sqlStr & "  group by itemid  "&vbCrLf  

		' response.write sqlStr &"<br>"
		' response.end
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		if not rsget.EOF then
			getMyWishList = rsget.getRows()    
		end if
		rsget.close 
	End Function

	public Function getLinkImage1(gubun, linkimg1, itemid)
		if gubun="0" then
			getLinkImage1 = "http://imgstatic.10x10.co.kr/goodsimage/" + GetImageSubFolderByItemid(itemid) + "/" + linkimg1
		else
			getLinkImage1 = "http://imgstatic.10x10.co.kr/contents/maniaimg/evaluate/" & CStr(gubun) & "/file1/" + linkimg1
		end if
	end function 

    Private Sub Class_Initialize()
		redim  FItemList(0)

		FCurrPage         = 1
		FPageSize         = 10
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0
	End Sub

	Private Sub Class_Terminate()

    End Sub
end Class
%>
