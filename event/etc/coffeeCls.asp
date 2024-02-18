<%
Class CEvtElectricFanItem
	Public FUserid
	Public Fcomment
	Public Fdevice
End Class

Class CEvtElectricFan
	Public FItemList()
	Public FTotalCount
	Public FPageSize
	Public FCurrPage
	Public FResultCount
	Public FTotalPage
	Public FPageCount
	Public FScrollCount
	Public FECode
	Public Frectuserid
	Public FmyTotalCount
	Public Fmylist
	Public Fgubun

	'/디비캐쉬		'/2015.12.28 한용민 생성
	Public Sub GetElectricFanList
		Dim strSQL, i
        Dim rsMem

		strSQL = ""
		strSQL = strSQL & " select count(*) as cnt" & VBCRLF
		strSQL = strSQL & " 	FROM [db_event].[dbo].[tbl_event_subscript]" & VBCRLF
		strSQL = strSQL & " 	WHERE evt_code = '"&FECode&"'"
		'response.write strSQL & "<br>"
		rsget.Open strSQL,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close

		strSQL = ""
		strSQL = strSQL & " SELECT top "& Cstr(FPageSize * FCurrPage) &" userid, sub_opt2, sub_opt3, device " & VBCRLF
		strSQL = strSQL & " FROM [db_event].[dbo].[tbl_event_subscript]" & VBCRLF
		strSQL = strSQL & " WHERE evt_code='"&FECode&"'" & VBCRLF
		strSQL = strSQL & " order by sub_idx desc"

		rsget.pagesize = FPageSize
		rsget.Open strSQL,dbget,1

		FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)
		FPageCount = FCurrPage - 1

        if not rsget.EOF then
            i = 0
            rsget.absolutepage = FCurrPage
            do until (rsget.eof)
                set FItemList(i) = new CEvtElectricFanItem
                FItemList(i).Fuserid       	= rsget("userid")
                FItemList(i).Fcomment     	= db2html(rsget("sub_opt3"))
				FItemList(i).Fdevice	      	= rsget("device")
        		rsget.MoveNext
        		i = i + 1
            loop
        end if
		rsget.Close
	End Sub

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
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
End Class

Class CEvtCoffee
	Public FECode
	Public Frectuserid
	Public Fidx
	Public Fcomment

	Public Sub GetMyComment
		Dim strSQL, i
		strSQL = ""
		strSQL = strSQL & " SELECT top 1 sub_idx, sub_opt3 " & VBCRLF
		strSQL = strSQL & " FROM [db_event].[dbo].[tbl_event_subscript]" & VBCRLF
		strSQL = strSQL & " WHERE evt_code='"&FECode&"'" & VBCRLF
		strSQL = strSQL & " and userid='"&Frectuserid&"'" & VBCRLF
		strSQL = strSQL & " order by sub_idx desc"
		rsget.Open strSQL,dbget,1
        if not rsget.EOF then
           Fidx = rsget("sub_idx")
		   Fcomment = db2html(rsget("sub_opt3"))
        end if
		rsget.Close
	End Sub

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class
%>