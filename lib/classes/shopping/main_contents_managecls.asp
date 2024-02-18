<%
'' [db_sitemaster].[dbo].tbl_mobile_mainCont_code
'' poscode, posname, linktype, fixtype, isusing

'-----------------------------------------------------------------------
' 이벤트 전역변수 선언 (2007.04.19; 허진원)
'2007년 11월 9일 한용민 수정
'-----------------------------------------------------------------------
 Dim staticImgUrl
 IF application("Svr_Info")="Dev" THEN
 	staticImgUrl	= "http://testimgstatic.10x10.co.kr"	'테스트
 ELSE
 	staticImgUrl	= "http://imgstatic.10x10.co.kr"	
 END IF	
'-----------------------------------------------------------------------

Class CMainContentsCodeItem
    public Fposcode
    public Fposname
    public FposVarname
    public Flinktype
    public Ffixtype
    public Fimagewidth
    public Fimageheight
    public FuseSet
    public Fisusing
    
    public function getlinktypeName()
        select case Flinktype
            case "L"
                getlinktypeName = "링크"
            case "M"
                getlinktypeName = "맵"
            case "X"
                getlinktypeName = "XML"
            case else
                getlinktypeName = Flinktype
        end select
    end function
    
    public function getfixtypeName()
        select case Ffixtype
            case "K"
                getfixtypeName = "관리자확정시"
            case "D"
                getfixtypeName = "일별"
            case else
                getfixtypeName = Flinktype
        end select
    end function
    
    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
	
end Class 

Class CMainContentsCode
    public FOneItem
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
    
    public FRectPoscode
    
    public Sub GetOneContentsCode()
        dim SqlStr
        SqlStr = "select top 1 * "
        SqlStr = SqlStr + " from [db_sitemaster].[dbo].tbl_mobile_mainCont_code"
        SqlStr = SqlStr + " where poscode=" + CStr(FRectPoscode)
              
        rsget.Open SqlStr, dbget, 1
        'response.write SqlStr&"<br>"
        FResultCount = rsget.RecordCount
        
        set FOneItem = new CMainContentsCodeItem
        if Not rsget.Eof then
            
            FOneItem.Fposcode  = rsget("poscode")
            FOneItem.Fposname  = db2html(rsget("posname"))
            FOneItem.FposVarname = rsget("posVarname")
            FOneItem.Flinktype = rsget("linktype")
            FOneItem.Ffixtype  = rsget("fixtype")
            FOneItem.Fimagewidth= rsget("imagewidth")
            FOneItem.FuseSet  = rsget("useSet")
            FOneItem.Fisusing  = rsget("isusing")
            
            FOneItem.Fimageheight = rsget("imageheight")
        end if
        rsget.close
    end Sub
    
    public Sub GetposcodeList()
        dim sqlStr
        sqlStr = "select count(poscode) as cnt from [db_sitemaster].[dbo].tbl_mobile_mainCont_code where 1=1 and left(posVarname,5)<> 'other'"
        rsget.Open sqlStr, dbget, 1
		FTotalCount = rsget("cnt")
		rsget.close
        
        sqlStr = "select top " + CStr(FPageSize * FCurrPage) + " * from [db_sitemaster].[dbo].tbl_mobile_mainCont_code where 1=1 and left(posVarname,5)<> 'other'"
        sqlStr = sqlStr + " order by poscode desc"
        
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		'response.write SqlStr&"<br>"
		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		        i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMainContentsCodeItem

				FItemList(i).Fposcode  = rsget("poscode")
                FItemList(i).Fposname  = db2html(rsget("posname"))
                FItemList(i).FposVarname = rsget("posVarname")
                FItemList(i).Flinktype = rsget("linktype")
                FItemList(i).Ffixtype  = rsget("fixtype")
                FItemList(i).Fimagewidth= rsget("imagewidth")
                FItemList(i).FuseSet= rsget("useSet")
                FItemList(i).Fisusing  = rsget("isusing")
                
                FItemList(i).Fimageheight = rsget("imageheight")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub

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

    public Function HasPreScroll()
		HasPreScroll = StarScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StarScrollPage + FScrollCount -1
	end Function

	public Function StarScrollPage()
		StarScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class

Class CMainContentsItem
    public Fidx
    public Fposcode
    public FposVarname
    public Fposname
    public Flinktype
    public Ffixtype
    public Fimageurl
    public Flinkurl
    public Fimagewidth
    public Fimageheight
    public FuseSet
    public Fstartdate
    public Fenddate
    public Fregdate
    public Freguserid
    public Fisusing
    public Fccd
    public Fitemid
    
    public function getImageHeightStr()
        getImageHeightStr =  ""
        
        if IsNULL(Fimageheight) or (Fimageheight="") or (Fimageheight="0") then Exit function
        
        getImageHeightStr = " height='" + Fimageheight + "' "
    end function 

    public function GetImageUrl()
        if (IsNULL(Fimageurl) or (Fimageurl="")) then
            GetImageUrl = ""
        else
            GetImageUrl = staticImgUrl & "/mobile/" + Fimageurl
        end if
    end function

    public function getlinktypeName()
        select case Flinktype
            case "L"
                getlinktypeName = "링크"
            case "M"
                getlinktypeName = "맵"
            case "X"
                getlinktypeName = "XML"
            case else
                getlinktypeName = Flinktype
        end select
    end function
    
    public function getfixtypeName()
        select case Ffixtype
            case "K"
                getfixtypeName = "관리자확정시"
            case "D"
                getfixtypeName = "일별"
            case else
                getfixtypeName = Flinktype
        end select
    end function
    
    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

Class CMainContents
    public FOneItem
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
       
    public FRectIdx
    public FRectIsusing
    public FRectPoscode
    public FRectfixtype
    public FRectSelDate
	public frectorderidx
	public FRectCCd
	    
    public function GetNowDateTime()
        dim sqlStr
        sqlStr = "select convert(varchar(19),getdate(),21) as nowdatetime "
        
        rsget.Open SqlStr, dbget, 1
        if Not rsget.Eof then
            GetNowDateTime = rsget("nowdatetime")
        end if
        rsget.Close
    end function
    
    public Sub GetMainContentsValidList()
        dim sqlStr, i , yyyymmdd, nowdatetime
        nowdatetime = GetNowDateTime()
        yyyymmdd = Left(nowdatetime,10)
        
        sqlStr = "select top " + CStr(FPageSize) + " * "
        sqlStr = sqlStr + " from [db_sitemaster].[dbo].tbl_mobile_mainCont"
        sqlStr = sqlStr + " where 1=1 and left(posVarname,5)<> 'other' and poscode='" + FRectPoscode + "'"
        sqlStr = sqlStr + " and isusing='Y'"
        if FRectSelDate<>"" then
        	sqlStr = sqlStr + " and '" & FRectSelDate & "' between startdate and enddate "
        else
        	sqlStr = sqlStr + " and enddate>'" + nowdatetime + "'"
        end if
        
        if frectorderidx = "main" then
        sqlStr = sqlStr + " order by orderidx asc, idx desc"
        else
        sqlStr = sqlStr + " order by startdate desc, idx desc"
		end if
        
        'response.write sqlStr &"<br>"	
        rsget.Open SqlStr, dbget, 1
        
        FResultCount = rsget.RecordCount
        FTotalCount = FResultCount
        
        redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CMainContentsItem

				FItemList(i).Fidx        = rsget("idx")
                FItemList(i).Fposcode    = rsget("poscode")
                FItemList(i).FposVarname = rsget("posVarname")
                FItemList(i).Flinktype   = rsget("linktype")
                FItemList(i).Ffixtype    = rsget("fixtype")
                FItemList(i).Fimageurl   = db2html(rsget("imageurl"))
                FItemList(i).Flinkurl    = db2html(rsget("linkurl"))
                FItemList(i).Fimagewidth = rsget("imagewidth")
                FItemList(i).Fstartdate  = rsget("startdate")
                FItemList(i).Fenddate    = rsget("enddate")
                FItemList(i).Fregdate    = rsget("regdate")
                FItemList(i).Freguserid  = rsget("reguserid")
                FItemList(i).Fisusing    = rsget("isusing")
                FItemList(i).Fimageheight= rsget("imageheight")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
        
    End Sub
    
    public Sub GetOneMainContents()
        dim sqlStr
        sqlStr = "select top 1 c.*, p.posname, p.useSet "
        sqlStr = sqlStr + " from [db_sitemaster].[dbo].tbl_mobile_mainCont c"
        sqlStr = sqlStr + " left join [db_sitemaster].[dbo].tbl_mobile_mainCont_code p"
        sqlStr = sqlStr + " on c.poscode=p.poscode"
        sqlStr = sqlStr + " where idx=" + CStr(FRectIdx)
        
        rsget.Open SqlStr, dbget, 1
        FResultCount = rsget.RecordCount
        
        set FOneItem = new CMainContentsItem
        
        if Not rsget.Eof then
    
    		FOneItem.Fidx        = rsget("idx")
            FOneItem.Fposcode    = rsget("poscode")
            FOneItem.Fposname    = db2html(rsget("posname"))
            FOneItem.FposVarname = rsget("posVarname")
            FOneItem.Flinktype   = rsget("linktype")
            FOneItem.Ffixtype    = rsget("fixtype")
            FOneItem.Fimageurl   = db2html(rsget("imageurl"))
            FOneItem.Flinkurl    = db2html(rsget("linkurl"))
            FOneItem.Fimagewidth= rsget("imagewidth")
            FOneItem.FuseSet	= rsget("useSet")
            FOneItem.Fstartdate  = rsget("startdate")
            FOneItem.Fenddate    = rsget("enddate")
            FOneItem.Fregdate    = rsget("regdate")
            FOneItem.Freguserid  = rsget("reguserid")
            FOneItem.Fisusing    = rsget("isusing")
            
            FOneItem.Fimageheight= rsget("imageheight")

        end if
        rsget.Close
    end Sub

    public Sub GetMainContentsList()
        dim sqlStr, addSql, i

        if FRectIdx<>"" then
            addSql = addSql + " and c.idx=" + CStr(FRectIdx)
        end if
        
        if FRectfixtype<>"" then
            addSql = addSql + " and c.fixtype='" + CStr(FRectfixtype) + "'"
        end if
        
        if FRectIsusing<>"" then
            addSql = addSql + " and c.isusing='" + CStr(FRectIsusing) + "'"
        end if
        
        if FRectPoscode<>"" then
            addSql = addSql + " and c.poscode='" + CStr(FRectPoscode) + "'"
        end if

        if FRectSelDate<>"" then
            addSql = addSql + " and '" & FRectSelDate & "' between c.startdate and c.enddate "
        end if
        
        sqlStr = " select count(idx) as cnt from [db_sitemaster].[dbo].tbl_mobile_mainCont c"
        sqlStr = sqlStr + " where 1=1 and left(posVarname,5)<> 'other'" & addSql
        
        rsget.Open sqlStr, dbget, 1
		FTotalCount = rsget("cnt")
		rsget.close
        
        
        sqlStr = "select top " + CStr(FPageSize * FCurrPage) + " c.*, p.posname, p.useSet "
        sqlStr = sqlStr + " from [db_sitemaster].[dbo].tbl_mobile_mainCont c"
        sqlStr = sqlStr + " left join [db_sitemaster].[dbo].tbl_mobile_mainCont_code p"
        sqlStr = sqlStr + " on c.poscode=p.poscode"
        sqlStr = sqlStr + " where 1=1 and left(c.posVarname,5)<> 'other'" & addSql
       
        sqlStr = sqlStr + " order by c.idx desc"
        
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		        i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMainContentsItem

				FItemList(i).Fidx        = rsget("idx")
                FItemList(i).Fposcode    = rsget("poscode")
                FItemList(i).FposVarname = rsget("posVarname")
                FItemList(i).Fposname    = db2html(rsget("posname"))
                FItemList(i).Flinktype   = rsget("linktype")
                FItemList(i).Ffixtype    = rsget("fixtype")
                FItemList(i).Fimageurl   = db2html(rsget("imageurl"))
                FItemList(i).Flinkurl    = db2html(rsget("linkurl"))
                FItemList(i).Fimagewidth = rsget("imagewidth")
                FItemList(i).FuseSet = rsget("useSet")
                FItemList(i).Fstartdate  = rsget("startdate")
                FItemList(i).Fenddate    = rsget("enddate")
                FItemList(i).Fregdate    = rsget("regdate")
                FItemList(i).Freguserid  = rsget("reguserid")
                FItemList(i).Fisusing    = rsget("isusing")

                FItemList(i).Fimageheight    = rsget("imageheight")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub


	'// 메인 컬러 상품 목록
    public Sub GetMainColorItemValidList()
        dim sqlStr, i
        
		sqlStr = "select top " + CStr(FPageSize) + "" + vbcrlf
		sqlStr = sqlStr + " c.idx, c.colorCode, c.itemid, i.itemname, i.smallimage " + vbcrlf
		sqlStr = sqlStr + " ,o.smallimage as [csImg] " + vbcrlf
		sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_colorItem c " + vbcrlf
		sqlStr = sqlStr + " 	join [db_item].[dbo].tbl_item i" + vbcrlf
		sqlStr = sqlStr + " 		on c.itemid = i.itemid " + vbcrlf
		sqlStr = sqlStr + " 	left join db_item.dbo.tbl_item_colorOption o " + vbcrlf
		sqlStr = sqlStr + " 		on o.itemid = c.itemid " + vbcrlf
		sqlStr = sqlStr + " 			and o.colorCode = c.colorCode " + vbcrlf
        sqlStr = sqlStr + " where c.colorCode='" + FRectCCd + "'"
         
        if frectorderidx = "main" then
        sqlStr = sqlStr + " order by c.sortNo asc, c.idx desc"
        else
        sqlStr = sqlStr + " order by c.idx desc"
		end if
        
        rsget.Open SqlStr, dbget, 1
        
        FResultCount = rsget.RecordCount
        FTotalCount = FResultCount
        
        redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CMainContentsItem

				FItemList(i).Fidx		= rsget("idx")
                FItemList(i).Fccd		= rsget("colorCode")
                FItemList(i).Fitemid	= rsget("itemid")
				if Not(rsget("csImg")="" or isNull(rsget("csImg"))) then
					FItemList(i).Fimageurl = "http://webimage.10x10.co.kr/color/small/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsget("csImg")
				else
					FItemList(i).Fimageurl = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsget("smallimage")
				end if
                FItemList(i).Flinkurl    = "/category/category_itemPrd.asp?itemid=" & FItemList(i).Fitemid

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
        
    End Sub


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

    public Function HasPreScroll()
		HasPreScroll = StarScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StarScrollPage + FScrollCount -1
	end Function

	public Function StarScrollPage()
		StarScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class
%>
