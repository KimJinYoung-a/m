<%
Class UserWishFolderObj
'폴더 리스트
	public Fidx							
	public Ffidx							
	public Fuserid							
	public Fviewcnt							
	public Fregdate	
	public Fuserlevel

'폴더 안 상품	
	public FIimg
	public FItemId

'유저 폴더 리스트	
	public FUfidx
	public FUuserid
	public FUfoldername
	public FUregdate
	public FUviewisusing
	public FUitemCnt
	public FUlastupdate
	public FUopenItemCnt
	public FUsortno

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class UserWishFolder
    public FOneItem
    public FItemList()	
	public FFolderItemList()	

	public FTotalCount
	public FUfolderTotalCount	
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount	
	public FScrollCount
	public FcolorCode	
    
	Public FRectUserId
	Public FRectUsersId	
	Public FRectOrderOption
	Public FRectFidx	
	Public FRectFidxs
	
    public Sub GetUserFolderList()
        dim sqlStr, i, sqlWhere, sqlOrder

		sqlwhere = ""		
		sqlOrder = ""

		sqlStr = " select count(idx) as cnt from [db_temp].[dbo].[tbl_wish_event_userfolder] as a "
		sqlStr = sqlStr + " LEFT join db_user.dbo.tbl_logindata as l with (nolock) on a.userid = l.userid "
		sqlStr = sqlStr + " where 1=1 "
		sqlStr = sqlStr + sqlWhere		

		if FRectOrderOption <> "" then 
			if FRectOrderOption = 1 then '인기순
				sqlOrder = " order by id_priority desc, viewcnt desc "
			else	'최신순
				sqlOrder = " order by id_priority desc, idx desc "
			end if			
		end if

        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close
        
        if FTotalCount < 1 then exit Sub        	
			
        sqlStr = "select top " + CStr(FPageSize * FCurrPage) + " "
		sqlStr = sqlStr + "  idx "
		sqlStr = sqlStr + " , fidx "
		sqlStr = sqlStr + " , a.userid "
		sqlStr = sqlStr + " , viewcnt "
		sqlStr = sqlStr + " , regdate "		
		sqlStr = sqlStr + " , l.userlevel "				
		sqlStr = sqlStr + " , case when a.userid = '"& FRectUserId &"' then '1' else '0' end id_priority "						
        sqlStr = sqlStr + " from [db_temp].[dbo].[tbl_wish_event_userfolder] as a "
		sqlStr = sqlStr + " LEFT join db_user.dbo.tbl_logindata as l with (nolock) on a.userid = l.userid "		
        sqlStr = sqlStr + " where 1=1 "
		sqlStr = sqlStr + sqlWhere
        
		sqlStr = sqlStr + sqlOrder

'		response.write sqlStr &"<br>"
		
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
				set FItemList(i) = new UserWishFolderObj

				FItemList(i).Fidx		 = rsget("idx")
				FItemList(i).Ffidx		 = rsget("fidx")
				FItemList(i).Fuserid	 = rsget("userid")	
				FItemList(i).Fviewcnt	 = rsget("viewcnt")	
				FItemList(i).Fregdate	 = rsget("regdate")											
				FItemList(i).Fuserlevel	 = rsget("userlevel")											

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub

    public Sub GetUsersFolderList()
        dim sqlStr, i, sqlWhere, sqlOrder

		sqlwhere = ""		
		sqlOrder = " order by regdate desc "

		if FRectUserId <> "" then
			sqlwhere = sqlwhere + " and userid = '"&FRectUserId&"'"
			sqlwhere = sqlwhere + " and viewisusing = 'Y'"
		end if

		sqlStr = " select count(*) as cnt from [db_my10x10].[dbo].[tbl_myfavorite_folder] "
		sqlStr = sqlStr + " where 1=1 "
		sqlStr = sqlStr + sqlWhere							

        rsget.Open sqlStr, dbget, 1
			FUfolderTotalCount = rsget("cnt")
		rsget.close
        
        if FUfolderTotalCount < 1 then exit Sub        	
			
		sqlStr = " select top 50 * from [db_my10x10].[dbo].[tbl_myfavorite_folder] "
		sqlStr = sqlStr + " where 1=1 "
		sqlStr = sqlStr + sqlWhere		
		sqlStr = sqlStr + sqlOrder	

'		response.write sqlStr &"<br>"
		        
		rsget.Open sqlStr, dbget, 1
 	
		redim preserve FFolderItemList(FUfolderTotalCount)
		if  not rsget.EOF  then
		    i = 0			
			do until rsget.eof
				set FFolderItemList(i) = new UserWishFolderObj

				FFolderItemList(i).FUfidx			= rsget("fidx")	
				FFolderItemList(i).FUuserid			= rsget("userid")
				FFolderItemList(i).FUfoldername		= rsget("foldername")	
				FFolderItemList(i).FUregdate		= rsget("regdate")	
				FFolderItemList(i).FUviewisusing	= rsget("viewisusing")		
				FFolderItemList(i).FUitemCnt		= rsget("itemCnt")	
				FFolderItemList(i).FUlastupdate		= rsget("lastupdate")	
				FFolderItemList(i).FUopenItemCnt	= rsget("openItemCnt")		
				FFolderItemList(i).FUsortno			= rsget("sortno")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub	
    	
	public Sub GetMyWishFolder()
		dim SqlStr
        sqlStr = " Select top 1 * "
        sqlStr = sqlStr & " From DB_TEMP.DBO.tbl_wish_event_userfolder "
        SqlStr = SqlStr & " where userid='" + CStr(FRectUserId) + "'"
		SqlStr = SqlStr & " and fidx ='" + CStr(FRectFidx) + "'"		

'		response.write sqlStr &"<br>"
'		response.end

        rsget.Open SqlStr, dbget, 1
        FResultCount = rsget.RecordCount

        set FOneItem = new UserWishFolderObj

        if Not rsget.Eof then
            FOneItem.Fidx		= rsget("idx")		
            FOneItem.Ffidx		= rsget("fidx")
            FOneItem.Fuserid	= rsget("userid")	
			FOneItem.Fviewcnt	= rsget("viewcnt")	
            FOneItem.Fregdate	= rsget("regdate")				
        end if
        rsget.close
	End Sub

	public function GetMyItems(vUid, vFidx)
		dim SqlStr,  i  'FItemResultCount, FUserProductList(),
        sqlStr = " Select top 4 "
		sqlStr = sqlStr & " a.itemid "
		sqlStr = sqlStr & " , b.basicimage "
        sqlStr = sqlStr & " From DB_MY10X10.DBO.tbl_myfavorite as a with(nolock) "
		sqlStr = sqlStr & " inner join db_item.dbo.tbl_item b with(nolock) on a.itemid = b.itemid "		
        SqlStr = SqlStr & " where userid='" + CStr(vUid) + "'"
		SqlStr = SqlStr & " and fidx ='" + CStr(vFidx) + "'"		
		SqlStr = SqlStr & " order by A.REGDATE desc"		

'		response.write sqlStr &"<br>"
'		response.end
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

        'FItemResultCount = rsget.RecordCount
		'['redim preserve FUserProductList(FItemResultCount)
 		if not rsget.EOF then
		    GetMyItems = rsget.getRows()	
		end if
		rsget.close			
	End function

	public Function isParticipatedUser(userid)
        dim sqlStr		
		
		sqlStr = "SELECT * "
		sqlStr = sqlStr + " FROM DB_TEMP.DBO.tbl_wish_event_userfolder WITH (NOLOCK) " 
		sqlStr = sqlStr + " WHERE userid='"&userid&"'"
		
		rsget.Open sqlStr, dbget, 1
		If Not(rsget.bof Or rsget.eof) Then					
			isParticipatedUser = true		
		else
			isParticipatedUser = false
		End If
		rsget.close		
    end function		

	Function getItemImageUrl()
		IF application("Svr_Info")	= "Dev" THEN
			if FcolorCode="" or FcolorCode="0" then
				getItemImageUrl = "http://webimage.10x10.co.kr/image"
			else
				getItemImageUrl = "http://webimage.10x10.co.kr/color"
			end if
		Else
			if FcolorCode="" or FcolorCode="0" then
				getItemImageUrl = "http://webimage.10x10.co.kr/image"
			else
				getItemImageUrl = "http://webimage.10x10.co.kr/color"
			end if
		End If
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

    public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class
%>
