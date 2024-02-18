<%
Class evt_wishfolder_item
	Public FUserid
	Public FDt
	Public FCnt
	Public FArrIcon2Img
	Public Fitemid
	Public Ficonimg
	Public Fitemname
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

	Public Fgubun

	Public Function evt_wishfolder_list
		Dim strSQL, i
		'if FeCode="" or Frectuserid="" then exit Function
		
		if userid <> "" then
			strSQL = ""
			strSQL = strSQL & " select count(*) as cnt" & VBCRLF
			strSQL = strSQL & " 	FROM   db_temp.dbo.tbl_wishlist_event " & VBCRLF
			strSQL = strSQL & " 	WHERE evt_code = '"&FeCode&"' and userid = '"&Frectuserid&"' "

			rsget.Open strSQL, dbget, 1
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FmyTotalCount = rsget(0)
			END IF
			rsget.close

			if FmyTotalCount <> 0 then
				strSQL = ""
				strSQL = strSQL & " SELECT top 1 count(*) as cnt " & VBCRLF
				strSQL = strSQL & " , STUFF((  " & VBCRLF
				strSQL = strSQL & "		SELECT ',' + cast(i.itemid as varchar(8)) +'|'+ cast(i.icon2image as varchar(24)) +'|'+ cast(i.sellcash as varchar(10)) " & VBCRLF
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

				rsget.Open strSQL, dbget, 1
				IF Not (rsget.EOF OR rsget.BOF) THEN
					Fmylist = rsget(1)
				END IF
				rsget.close

			end if
		end If
		
		strSQL = ""
		strSQL = strSQL & " select count(*) as cnt, CEILING(CAST(Count(userid) AS FLOAT)/5) as tp " & VBCRLF
		strSQL = strSQL & " FROM ( " & VBCRLF
		strSQL = strSQL & " 	SELECT userid, max(regdate) as dt " & VBCRLF
		strSQL = strSQL & " 	FROM   db_temp.dbo.tbl_wishlist_event as E " & VBCRLF
		strSQL = strSQL & " 	WHERE E.evt_code = '"&FeCode&"' " & VBCRLF	'####### 이벤트코드 구분자. 중간에 추가된거라 여러사정으로 현재 이벤코드를 0으로 잡고 끝나면 진짜 이벤코드를 update 시킴.
		strSQL = strSQL & " 	GROUP  BY userid "
		strSQL = strSQL & " 	HAVING count(*)>4 "
		strSQL = strSQL & " ) AS t "

		rsget.Open strSQL, dbget, 1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotalCount = rsget(0)
			FTotalpage = rsget(1)
		END IF
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
		strSQL = strSQL & " HAVING count(*)>4 " & VBCRLF
		strSQL = strSQL & " order by dt desc, userid "

		rsget.Open strSQL, dbget, 1
		rsget.pagesize = FPageSize
			
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

	'/디비캐쉬		'/2015.12.28 한용민 생성
	Public Function evt_wishfolder_list_B
		Dim strSQL, i
        Dim rsMem

		'if FeCode="" or Frectuserid="" then exit Function
		
		if userid <> "" then
			strSQL = ""
			strSQL = strSQL & " select count(*) as cnt" & VBCRLF
			strSQL = strSQL & " 	FROM   db_temp.dbo.tbl_wishlist_event " & VBCRLF
			strSQL = strSQL & " 	WHERE evt_code = '"&FeCode&"' and userid = '"&Frectuserid&"'"
			
			'response.write strSQL & "<br>"
			set rsMem = getDBCacheSQL(dbget,rsget,"WISHEVT",strSQL,60*3)
			if (rsMem is Nothing) then Exit function ''추가
				
			IF Not (rsMem.EOF OR rsMem.BOF) THEN
				FmyTotalCount = rsMem(0)
			END IF
			rsMem.close

			if FmyTotalCount <> 0 then
				strSQL = ""
				strSQL = strSQL & " SELECT top 1 count(*) as cnt " & VBCRLF
				strSQL = strSQL & " , STUFF((  " & VBCRLF
				strSQL = strSQL & "		SELECT ',' + cast(i.itemid as varchar(8)) +'|'+ cast(i.icon2image as varchar(24)) +'|'+ cast(i.sellcash as varchar(10)) " & VBCRLF
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

				set rsMem = getDBCacheSQL(dbget,rsget,"WISHEVT",strSQL,60*3)
				if (rsMem is Nothing) then Exit function ''추가

				IF Not (rsMem.EOF OR rsMem.BOF) THEN
					Fmylist = rsMem(1)
				END IF
				rsMem.close

			end if
		end If
		
		strSQL = ""
		strSQL = strSQL & " select count(*) as cnt, CEILING(CAST(Count(userid) AS FLOAT)/5) as tp " & VBCRLF
		strSQL = strSQL & " FROM ( " & VBCRLF
		strSQL = strSQL & " 	SELECT userid, max(regdate) as dt " & VBCRLF
		strSQL = strSQL & " 	FROM   db_temp.dbo.tbl_wishlist_event as E " & VBCRLF
		strSQL = strSQL & " 	WHERE E.evt_code = '"&FeCode&"' " & VBCRLF	'####### 이벤트코드 구분자. 중간에 추가된거라 여러사정으로 현재 이벤코드를 0으로 잡고 끝나면 진짜 이벤코드를 update 시킴.
		strSQL = strSQL & " 	GROUP  BY userid "
		strSQL = strSQL & " 	HAVING count(*)>4 "
		strSQL = strSQL & " ) AS t "

		set rsMem = getDBCacheSQL(dbget,rsget,"WISHEVT",strSQL,60*3)
		if (rsMem is Nothing) then Exit function ''추가
			
		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			FTotalCount = rsMem(0)
			FTotalpage = rsMem(1)
		END IF
		rsMem.close

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
		strSQL = strSQL & " HAVING count(*)>4 " & VBCRLF
		strSQL = strSQL & " order by dt desc, userid "

		'// dbcache
		set rsMem = getDBCacheSQL(dbget,rsget,"WISHEVT",strSQL,60*3)
		if (rsMem is Nothing) then Exit function ''추가

		rsMem.pagesize = FPageSize
			
		If (FCurrPage * FPageSize < FTotalCount) Then
			FResultCount = FPageSize
		Else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		End If

		Redim preserve FList(FResultCount)
		FPageCount = FCurrPage - 1

		i = 0
		If not rsMem.EOF Then
			rsMem.absolutepage = FCurrPage
			Do until rsMem.EOF
				Set FList(i) = new evt_wishfolder_item
				FList(i).FUserid 		= rsMem("userid")
				FList(i).FDt 			= rsMem("dt")
				FList(i).FCnt 			= rsMem("cnt")
				FList(i).FArrIcon2Img 	= rsMem("arrIcon2Img")
				rsMem.movenext
				i = i + 1
			Loop
		End if
		rsMem.Close

		set rsMem = Nothing
	End Function

	Public Function evt_daily_itemselect '// 상품코드만 위시처럼 담는 이벤트 전용 예)76291 2017-02-20 이종화
		Dim strSQL, i
		
		if userid <> "" then
			strSQL = ""
			strSQL = strSQL & " select count(*) as cnt" & VBCRLF
			strSQL = strSQL & " FROM db_temp.dbo.tbl_event_itemwish " & VBCRLF
			strSQL = strSQL & " WHERE evt_code = '"& FeCode &"' and userid = '"& Frectuserid &"' and gubun = '"& Fgubun &"' "

			rsget.Open strSQL, dbget, 1
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FmyTotalCount = rsget(0)
			END IF
			rsget.close

			if FmyTotalCount <> 0 then
				strSQL = ""
				strSQL = strSQL & " SELECT top 1 count(*) as cnt " & VBCRLF
				strSQL = strSQL & " , STUFF((  " & VBCRLF
				strSQL = strSQL & "		SELECT ',' + cast(i.itemid as varchar(8)) +'|'+ cast(i.icon2image as varchar(24))" & VBCRLF
				strSQL = strSQL & " 	FROM db_temp.dbo.tbl_event_itemwish as w " & VBCRLF
				strSQL = strSQL & " 	JOIN db_item.dbo.tbl_item as i " & VBCRLF
				strSQL = strSQL & " 	ON w.itemid=i.itemid " & VBCRLF
				strSQL = strSQL & " 	WHERE w.userid = E.userid AND w.evt_code = '"&FeCode&"' and w.gubun = '"& Fgubun &"' " & VBCRLF
				strSQL = strSQL & " 	order by w.itemid " & VBCRLF
				strSQL = strSQL & " 	FOR XML PATH('')  " & VBCRLF
				strSQL = strSQL & " 	), 1, 1, '') AS arrIcon2Img " & VBCRLF
				strSQL = strSQL & " FROM   db_temp.dbo.tbl_event_itemwish as E " & VBCRLF
				strSQL = strSQL & " 	WHERE E.evt_code = '"&FeCode&"' and E.userid = '"&Frectuserid&"' and E.gubun = '"& Fgubun &"' " & VBCRLF
				strSQL = strSQL & " GROUP  BY userid, E.evt_code " & VBCRLF

				rsget.Open strSQL, dbget, 1
				IF Not (rsget.EOF OR rsget.BOF) THEN
					Fmylist = rsget(1)
				END IF
				rsget.close

			end if
		end If
		
		strSQL = ""
		strSQL = strSQL & " select count(*) as cnt, CEILING(CAST(Count(gubun) AS FLOAT)/6) as tp  " & VBCRLF
		strSQL = strSQL & " FROM ( " & VBCRLF
		strSQL = strSQL & " 	SELECT gubun " & VBCRLF
		strSQL = strSQL & " 	FROM   db_temp.dbo.tbl_event_itemwish as E " & VBCRLF
		strSQL = strSQL & " 	WHERE E.evt_code = '"& FeCode &"' and e.gubun = '"& Fgubun &"'  " & VBCRLF
		strSQL = strSQL & " ) AS t "

		rsget.Open strSQL, dbget, 1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotalCount = rsget(0)
			FTotalpage = rsget(1)
		END IF
		rsget.close

		strSQL = ""
		strSQL = strSQL & " SELECT top "& Cstr(FPageSize * FCurrPage) &" E.userid , E.itemid , i.icon2image , i.itemname " & VBCRLF
		strSQL = strSQL & "	FROM db_temp.dbo.tbl_event_itemwish as E  " & VBCRLF
		strSQL = strSQL & "	JOIN db_item.dbo.tbl_item as i ON e.itemid=i.itemid " & VBCRLF
		strSQL = strSQL & "	WHERE E.evt_code = '"& FeCode &"' and E.gubun = '"& Fgubun &"' " & VBCRLF
		strSQL = strSQL & " order by E.regdate desc "

		rsget.Open strSQL, dbget, 1
		rsget.pagesize = FPageSize

		
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
				FList(i).Fitemid 		= rsget("itemid")
				FList(i).Ficonimg	 	= rsget("icon2image")
				FList(i).Fitemname	 	= rsget("itemname")
				rsget.movenext
				i = i + 1
			Loop
		End if
		rsget.Close

	End Function
End Class
%>