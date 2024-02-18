<%
'' Require iteminfoCls.asp

Class CSpecialShop
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FNowDate
	public Ftitle
	public Fsdate
	public Fedate

	public FRectUserLevelUnder


	public Sub GetSpecialShopInfo()
		dim sqlStr, i
		sqlStr = "exec [db_item].[dbo].sp_Ten_SpecialShopInfo '"&FNowDate&"' " + vbcrlf

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget, 1
		If Not rsget.Eof Then
			Ftitle = db2html(rsget("title"))
			Fsdate = rsget("openDate")
			Fedate = rsget("endDate")
		End If
		rsget.Close
	end sub
	

	public Sub GetSpecialItemList()
		dim sqlStr, i

		sqlStr = "exec [db_item].[dbo].sp_Ten_SpecialItemListCnt '"&FRectUserLevelUnder&"' " + vbcrlf

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget, 1

		FTotalCount = rsget(0)
		rsget.Close

		sqlStr = "exec [db_item].[dbo].sp_Ten_SpecialItemList_2013 '"&((FCurrPage-1)*FPageSize)&"','"&FPageSize&"','"&FRectUserLevelUnder&"' " + vbcrlf
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount
        
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then

			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem
				FItemList(i).FItemId       = rsget("itemid")
				FItemList(i).FItemName     = db2html(rsget("itemname"))
				FItemList(i).Fmakerid     = rsget("makerid")
				FItemList(i).FSellCash     = rsget("sellcash")
				FItemList(i).FOrgPrice     = rsget("orgprice")

				FItemList(i).FSellyn       = rsget("sellyn")
				FItemList(i).FLimitYn      = rsget("limityn")
				FItemList(i).FLimitNo      = rsget("limitno")
				FItemList(i).FLimitSold    = rsget("limitsold")

				FItemList(i).FSaleYN		= rsget("sailyn")
				FItemList(i).FSpecialuseritem = rsget("specialuseritem")
                FItemList(i).FBrandName     = db2html(rsget("brandname"))
                
				FItemList(i).FImageSmall    = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("smallimage")
				FItemList(i).FImageList     = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("listimage")
				FItemList(i).FImageIcon2     = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("icon2image")
				FItemList(i).FImageBasic     = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("basicimage")

                FItemList(i).Fitemcouponyn      = rsget("itemcouponyn")
                FItemList(i).Fitemcoupontype    = rsget("itemcoupontype")
                FItemList(i).Fitemcouponvalue   = rsget("itemcouponvalue")
                FItemList(i).Fcurritemcouponidx    = rsget("curritemcouponidx")
                FItemList(i).FEvalCnt       = rsget("EvalCnt")

                FItemList(i).FFavCount       = rsget("favcount")
                FItemList(i).FOptioncnt		= rsget("optioncnt")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

	end sub

	Private Sub Class_Initialize()
		redim FItemList(0)
		FCurrPage =1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0

	End Sub


	Public Function OneWeekCalc()
		Dim vNow, vTerm, vTuesDay
		vNow = now()
		vTerm = Weekday(vNow)-3
		IF Left(vTerm,1) = "-" Then
			vTerm 		= vTerm + 7
			vTuesDay 	= DateAdd("d",-vTerm,vNow)
			vTuesDay 	= formatdate(vTuesDay,"0000.00.00") & " ~ " & formatdate(DateAdd("d",6,vTuesDay),"00.00")
		ElseIf Left(vTerm,1) = "0" Then
			vTuesDay 	= formatdate(vNow,"0000.00.00") & " ~ " & formatdate(DateAdd("d",6,vNow),"00.00")
		Else
			vTuesDay 	= DateAdd("d",-vTerm,vNow)
			vTuesDay 	= formatdate(vTuesDay,"0000.00.00") & " ~ " & formatdate(DateAdd("d",6,vTuesDay),"00.00")
		End If
		OneWeekCalc = vTuesDay
	End Function


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


Function fnReservDate()
	Dim vQuery, vDate
	vQuery = "SELECT TOP 1 convert(varchar(10),openDate,120) as openDate FROM [db_item].[dbo].[tbl_specialShop] WHERE openDate > getdate() AND isusing = 'Y' AND status = '0' "
	vQuery = vQuery & "ORDER BY openDate ASC"
	rsget.Open vQuery, dbget, 1
	If Not rsget.Eof Then
		vDate = rsget(0)
	Else
		vDate = ""
	End If
	rsget.close
	fnReservDate = vDate
End Function
%>
