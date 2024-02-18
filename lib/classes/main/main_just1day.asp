<%
Class CPickItem

	public Fidx
	public Ftextname
	Public FsortNo
	public Fregdate
	Public Ftitle
	Public Flinkinfo
	Public FisUsing
	Public Fis1day
	
	Public Ftodayban
	Public Fextraurl

	Public Fsubtitle
	Public Fsaleper

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

Class CPick
	public FItemList()
	public FItemOne

	public FTotalCount
	public FResultCount

	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount

	public FRectIdx
	public FRectUsing
	public FRectSearch
	public FRectSort
	public FCategoryPrdList()

	Private Sub Class_Initialize()
		'redim preserve FItemList(0)
		redim  FItemList(0)

		FCurrPage =1
		FPageSize = 15
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
		redim preserve FCategoryPrdList(0)
	End Sub

	Private Sub Class_Terminate()

	End Sub


	public Sub GetPickOne()
		'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
		Dim cTime , dummyName
		If timer > 10 And Cint(timer/60) < 6 Then
			cTime = 60*1
			dummyName = "JUST_"&Cint(timer/60)
		Else
			cTime = 60*5
			dummyName = "JUST"
		End If

		dim sqlStr, addSql, i
		sqlStr = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_GetOne] "
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,dummyName,sqlStr,cTime)
		If Not rsMem.EOF Then
			FTotalCount = 1
			set FItemOne = new CPickItem
			FItemOne.Fidx = rsMem("idx")
			FItemOne.Ftitle = db2html(rsMem("title"))
			FItemOne.Fis1day = db2html(rsMem("is1day"))
			FItemOne.Ftodayban = db2html(rsMem("todayban"))
			FItemOne.Fextraurl = db2html(rsMem("extraurl"))
			FItemOne.Fsubtitle = db2html(rsMem("subtitle"))
			FItemOne.Fsaleper = db2html(rsMem("saleper"))
		End if
		rsMem.close
	End Sub
	

	public Function GetPickItemList()
		dim strSql, addSql, i, arrItem, intI
		dim rsMem 
		
		'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
		Dim cTime , dummyName1 , dummyName2
		If timer > 10 And Cint(timer/60) < 6 Then
			cTime = 60*1
			dummyName1 = "JUSTCNT_"&Cint(timer/60)
			dummyName2 = "JUSTLIST_"&Cint(timer/60)
		Else
			cTime = 60*5
			dummyName1 = "JUSTCNT"
			dummyName2 = "JUSTLIST"
		End If

		strSql = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_ItemList_temp] '1', '" & (FPageSize*FCurrPage) & "', '" & FRectIdx & "', ' '"
		set rsMem = getDBCacheSQL(dbget,rsget,dummyName1,strSql,cTime)
		If Not rsMem.EOF Then
			FTotalCount = rsMem(0)
			FTotalPage = rsMem(1)
		End if
		rsMem.close

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_ItemList_temp] '2', '" & (FPageSize*FCurrPage) & "', '" & FRectIdx & "', '" & FRectSort & "'"
			set rsMem = getDBCacheSQL(dbget,rsget,dummyName2,strSql,cTime) '// 분단위로 갱신
			If Not rsMem.EOF Then
				arrItem = rsMem.GetRows
			End if
			rsMem.close
	
			IF isArray(arrItem) THEN
				FResultCount = Ubound(arrItem,2)
				redim preserve FCategoryPrdList(FResultCount)

				For intI = 0 To FResultCount
				set FCategoryPrdList(intI) = new CCategoryPrdItem
					FCategoryPrdList(intI).FItemID       = arrItem(0,intI)
					FCategoryPrdList(intI).FItemName    = db2html(arrItem(1,intI))
	
					FCategoryPrdList(intI).FSellcash    = arrItem(2,intI)
					FCategoryPrdList(intI).FOrgPrice   	= arrItem(3,intI)
					FCategoryPrdList(intI).FMakerId   	= db2html(arrItem(4,intI))
					FCategoryPrdList(intI).FBrandName  	= db2html(arrItem(5,intI))
	
					FCategoryPrdList(intI).FSellYn      = arrItem(9,intI)
					FCategoryPrdList(intI).FSaleYn     	= arrItem(10,intI)
					FCategoryPrdList(intI).FLimitYn     = arrItem(11,intI)
					FCategoryPrdList(intI).FLimitNo     = arrItem(12,intI)
					FCategoryPrdList(intI).FLimitSold   = arrItem(13,intI)
	
					FCategoryPrdList(intI).FRegdate 		= arrItem(14,intI)
					FCategoryPrdList(intI).FReipgodate		= arrItem(15,intI)
	
	                FCategoryPrdList(intI).Fitemcouponyn 	= arrItem(16,intI)
					FCategoryPrdList(intI).FItemCouponValue	= arrItem(17,intI)
					FCategoryPrdList(intI).Fitemcoupontype	= arrItem(18,intI)
	
					FCategoryPrdList(intI).Fevalcnt 		= arrItem(19,intI)
					FCategoryPrdList(intI).FitemScore 		= arrItem(20,intI)
	
					FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
					FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
					FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
					FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
					FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
					If arrItem(24,intI)="21" then
						if instr(arrItem(26,intI),"/") > 0 then
							FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&arrItem(26,intI)
						Else
							FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
						End If
					Else
						FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
					End If

					If Not(isnull(arrItem(31,intI)) Or arrItem(31,intI) = "")  Then
						FCategoryPrdList(intI).Ftentenimage400 = "http://webimage.10x10.co.kr/image/tenten400/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(31,intI)
					Else
						FCategoryPrdList(intI).Ftentenimage400 = ""
					End If  

					FCategoryPrdList(intI).FItemSize	= arrItem(23,intI)
					FCategoryPrdList(intI).Fitemdiv		= arrItem(24,intI)
					FCategoryPrdList(intI).Fldv			= arrItem(29,intI)
					FCategoryPrdList(intI).Flabel		= arrItem(30,intI)
					FCategoryPrdList(intI).Fsaleper		= arrItem(32,intI)

	
				Next
			END IF
		ELSE
			FTotalCount = -1
		END IF
	end Function

end Class
%>
