<%
Class clsMyAddressItem
	Public FReqname
	Public FReqzipcode
	Public FReqzipaddr
	Public FReqaddress
	Public FReqhp
End Class 

Class clsMyAddress
	Public FItemList()
	Public FOneItem
	Public FTotalCount
	Public FPageSize
	Public FCurrPage
	Public FResultCount
	Public FTotalPage
	Public FPageCount
	Public FScrollCount
	
	Public FRectCatecode
	Public FRectUserid
	Public FRectyyyymm


	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()

	End Sub

	Public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	End Function

	Public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	End Function

	Public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	End Function

	Public Sub getMyAddressList
		Dim sqlStr, i
		sqlStr = "Select "
		sqlStr = sqlStr & "	reqname, reqzipcode, reqzipaddr, reqaddress, reqhp "
		sqlStr = sqlStr & " from db_order.dbo.tbl_order_master "
		sqlStr = sqlStr & " where sitename='10x10' "
		sqlStr = sqlStr & "	and rdsite='betweenshop' "
		sqlStr = sqlStr & "	and rduserid='" & fnGetUserInfo("tenSn") & "' "
		sqlStr = sqlStr & "	and ipkumdiv>1 "
		sqlStr = sqlStr & "	and jumundiv<>'9' "
		sqlStr = sqlStr & "	and cancelyn='N' "
		sqlStr = sqlStr & " GROUP BY reqname, reqzipcode, reqzipaddr, reqaddress, reqhp "
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FtotalPage = FtotalPage + 1
		End If
		FResultCount = rsget.RecordCount - (FPageSize * (FCurrPage - 1))
		Redim preserve FItemList(FResultCount)
		i = 0
		If  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			Do until rsget.eof
				Set FItemList(i) = new clsMyAddressItem
					FItemList(i).FReqname		= rsget("reqname")
					FItemList(i).FReqzipcode	= rsget("reqzipcode")
					FItemList(i).FReqzipaddr	= rsget("reqzipaddr")
					FItemList(i).FReqaddress	= rsget("reqaddress")
					FItemList(i).FReqhp			= rsget("reqhp")
				i = i + 1
				rsget.moveNext
			Loop
		End If
		rsget.Close
	End Sub	

End Class
%>

