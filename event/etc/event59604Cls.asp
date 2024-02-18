<%
function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-02-16"
	
	getnowdate = nowdate
end function

Class evt_wishfolder_item
	Public FUserid
	Public FDt
	Public FCnt
	Public FArrIcon2Img
End Class

Class evt_wishfolder
	Public FList()
	Public FTotalCount
	Public FPageSize
	Public FCurrPage
	Public FResultCount
	Public FTotalPage
	Public FPageCount
	Public FScrollCount
	Public FeCode

	Public Frectuserid
	Public FmyTotalCount
	Public Fmylist

	Public Function evt_wishfolder_list
		Dim strSQL, i

		'if FeCode="" or Frectuserid="" then exit Function
		
		if userid <> "" then
			strSQL = ""
			strSQL = strSQL & " select count(*) as cnt" & VBCRLF
			strSQL = strSQL & " 	FROM   db_temp.dbo.tbl_wishlist_event " & VBCRLF
			strSQL = strSQL & " 	WHERE evt_code = '"&FeCode&"' and userid = '"&Frectuserid&"' "

			'response.write strSQL
			rsget.open strSQL, dbget, 1
				FmyTotalCount = rsget("cnt")
			rsget.close

			if FmyTotalCount <> 0 then
				strSQL = ""
				strSQL = strSQL & " SELECT top 1 count(*) as cnt " & VBCRLF
				strSQL = strSQL & " , STUFF((  " & VBCRLF
				strSQL = strSQL & "		SELECT ',' + cast(i.itemid as varchar(8)) +'|'+ cast(i.icon2image as varchar(24)) " & VBCRLF
				strSQL = strSQL & " 	FROM db_temp.dbo.tbl_wishlist_event as w " & VBCRLF
				strSQL = strSQL & " 	JOIN db_item.dbo.tbl_item as i " & VBCRLF
				strSQL = strSQL & " 	ON w.itemid=i.itemid " & VBCRLF
				strSQL = strSQL & " 	WHERE w.userid = E.userid AND w.evt_code = '"&FeCode&"' " & VBCRLF
				strSQL = strSQL & " 	order by w.itemid " & VBCRLF
				strSQL = strSQL & " 	FOR XML PATH('')  " & VBCRLF
				strSQL = strSQL & " 	), 1, 1, '') AS arrIcon2Img " & VBCRLF
				strSQL = strSQL & " FROM   db_temp.dbo.tbl_wishlist_event as E " & VBCRLF
				strSQL = strSQL & " 	WHERE E.evt_code = '"&FeCode&"' and E.userid = '"&Frectuserid&"' " & VBCRLF
				strSQL = strSQL & " GROUP  BY userid, E.evt_code " & VBCRLF

				'response.write strSQL
				rsget.open strSQL, dbget, 1
					Fmylist = rsget("arrIcon2Img")
				rsget.close
			end if
		end if
		
		strSQL = ""
		strSQL = strSQL & " select count(*) as cnt, CEILING(CAST(Count(userid) AS FLOAT)/5) as tp " & VBCRLF
		strSQL = strSQL & " FROM ( " & VBCRLF
		strSQL = strSQL & " 	SELECT userid, max(regdate) as dt " & VBCRLF
		strSQL = strSQL & " 	FROM   db_temp.dbo.tbl_wishlist_event as E " & VBCRLF
		strSQL = strSQL & " 	WHERE E.evt_code = '"&FeCode&"' " & VBCRLF	'####### 이벤트코드 구분자. 중간에 추가된거라 여러사정으로 현재 이벤코드를 0으로 잡고 끝나면 진짜 이벤코드를 update 시킴.
		strSQL = strSQL & " 	GROUP  BY userid "
		strSQL = strSQL & " 	HAVING count(*)>0 "
		strSQL = strSQL & " ) AS t "

		'response.write strSQL
		rsget.open strSQL, dbget, 1
			FTotalCount = rsget("cnt")
			FTotalpage = rsget("tp")
		rsget.close

		strSQL = ""
		strSQL = strSQL & " SELECT top "& Cstr(FPageSize * FCurrPage) &" userid, max(regdate) as dt, count(*) as cnt " & VBCRLF
		strSQL = strSQL & " , STUFF((  " & VBCRLF
		strSQL = strSQL & "		SELECT ',' + cast(i.itemid as varchar(8)) +'|'+ cast(i.icon2image as varchar(24)) " & VBCRLF
		strSQL = strSQL & " 	FROM db_temp.dbo.tbl_wishlist_event as w " & VBCRLF
		strSQL = strSQL & " 	JOIN db_item.dbo.tbl_item as i " & VBCRLF
		strSQL = strSQL & " 	ON w.itemid=i.itemid " & VBCRLF
		strSQL = strSQL & " 	WHERE w.userid = E.userid AND w.evt_code = '"&FeCode&"' " & VBCRLF
		strSQL = strSQL & " 	order by w.itemid " & VBCRLF
		strSQL = strSQL & " 	FOR XML PATH('')  " & VBCRLF
		strSQL = strSQL & " 	), 1, 1, '') AS arrIcon2Img " & VBCRLF
		strSQL = strSQL & " FROM   db_temp.dbo.tbl_wishlist_event as E " & VBCRLF
		strSQL = strSQL & " 	WHERE E.evt_code = '"&FeCode&"' " & VBCRLF
		strSQL = strSQL & " GROUP  BY userid, E.evt_code " & VBCRLF
		strSQL = strSQL & " HAVING count(*)>0 " & VBCRLF
		strSQL = strSQL & " order by dt desc, userid "

		'response.write strSQL
		rsget.pagesize = FPageSize
		rsget.Open strSQL,dbget,1

		If (FCurrPage * FPageSize < FTotalCount) Then
			FResultCount = FPageSize
		Else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		End If

		Redim preserve FList(FResultCount)
		FPageCount = FCurrPage - 1

		i = 0
		If not rsget.EOF Then
			rsget.absolutepage = FCurrPage
			Do until rsget.EOF
				Set FList(i) = new evt_wishfolder_item
				FList(i).FUserid 		= rsget("userid")
				FList(i).FDt 			= rsget("dt")
				FList(i).FCnt 			= rsget("cnt")
				FList(i).FArrIcon2Img 	= rsget("arrIcon2Img")
				rsget.movenext
				i = i + 1
			Loop
		End if
		rsget.Close
	End Function
End Class
%>