<%
Class CEvtYouItem
	public FItemID
	public FItemName
	public Ftentenimage400
	public FBrandName
	public FMakerID
	public Fitemdiv

	public FSellCash
	public FOrgPrice
	public FSellyn
	public FSaleyn
	public FLimityn
	public FLimitNo
	public FLimitSold
	public FItemcouponyn
	public FItemCouponValue
	public FItemCouponType
	public FEvalCnt
	public FfavCount
	public FOptionCnt
End Class

Class CEvtYou
	public FItemList()
	Public FRectUserID
	Public FResultCount

	'// 해피투게더 신규(기존 best에서 채우던 방식 말고 순수 해피투게더 데이터만) 2017.06.08 원승현
	'// sp_Ten_happyTogether_List => sp_Ten_happyTogether_List_V2 2017.06.15 eastone
    Public sub GetCateRightHappyTogetherList()
        dim i, pItemArr, sqlStr, sqlStr2
		Dim rsMem
		sqlStr = "exec db_event.dbo.sp_Ten_happyTogether_List_V4 '" & CStr(FRectUserID) & "'"
        '커서 위치 지정
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
		set rsMem = getDBCacheSQL(dbget,rsget,"Evt_79281_"&CStr(FRectUserID),sqlStr,60*60)
		if (rsMem is Nothing) then Exit sub ''추가

		FResultCount = rsMem.RecordCount
		redim preserve FItemList(FResultCount)

		i=0
		pItemArr =""

		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CCategoryPrdItem
				FItemList(i).FItemID		= rsMem("itemid")
				FItemList(i).FItemName		= db2html(rsMem("itemname"))
				FItemList(i).Ftentenimage400 = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("addimage_400")
				FItemList(i).FBrandName		= db2html(rsMem("brandname"))
				FItemList(i).FMakerID		= db2html(rsMem("makerid"))
				FItemList(i).Fitemdiv		= rsMem("itemdiv")
				FItemList(i).FSellCash 		= rsMem("sellcash")
				FItemList(i).FOrgPrice 		= rsMem("orgprice")
				FItemList(i).FSellyn 		= rsMem("sellyn")
				FItemList(i).FSaleyn 		= rsMem("sailyn")
				FItemList(i).FLimityn 		= rsMem("limityn")
				FItemList(i).FLimitNo      = rsMem("limitno")
				FItemList(i).FLimitSold    = rsMem("limitsold")
				FItemList(i).FItemcouponyn 	= rsMem("itemcouponyn")
				FItemList(i).FItemCouponValue 	= rsMem("itemCouponValue")
				FItemList(i).FItemCouponType 	= rsMem("itemCouponType")
				FItemList(i).FEvalCnt 	= rsMem("evalcnt")
				FItemList(i).FfavCount 	= rsMem("favcount")
                FItemList(i).FOptionCnt = rsMem("optioncnt")
				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close
    end Sub

	Private Sub Class_Initialize()
		FResultCount = 0
	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class
%>