<%
Class cConitem
	public fvalue1
	public fvalue2
	public fvalue3
	public fvalue4
	public fvalue5
	public fvalue6
	public fvalue7
	public fvalue8
	public fvalue9
	public fvalue10
	public fuserid
	public fimagename
	public fusernum
	public fsubject
	public fcontents
	public fpollcount
	public fpollcount_tot
	public fentry_sdate
	public fentry_edate
	public fimagename2

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class


Class cContest
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FOneItem
	public FUserID
	public FUserNum
	public FContest
	public FPollTotalCount
	public FPageCount
	public FImgcode

	public sub FContestChk()
		dim SqlStr,i
		SqlStr = "SELECT entry_sdate, entry_edate FROM [db_event].[dbo].[tbl_contest_master] WHERE contest = '" & FContest & "' "
		rsget.Open sqlStr,dbget,1
		FTotalCount = rsget.RecordCount
		
		If Not rsget.Eof Then
			set FOneItem = new cConitem
			FOneItem.fentry_sdate = rsget("entry_sdate")
			FOneItem.fentry_edate = rsget("entry_edate")
		End If

		rsget.Close
	End Sub



	public sub fevt_ContestList()
		dim SqlStr,i
		SqlStr = "SELECT idx, userid FROM [db_event].[dbo].[tbl_contest_poll] WHERE contest = '" & FContest & "' GROUP BY idx, userid ORDER BY NEWID()"
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new cConitem
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fimagename = Left(rsget("userid"),Len(rsget("userid"))-2) & "_01_m.jpg"
				FItemList(i).fusernum = rsget("idx")
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	End Sub


	'메인 이미지 뽑기'
	public sub fevt_ContestList_imgmain()
		dim SqlStr,i
		sqlStr = "SELECT poll_idx, img_name, userid, subject " + vbcrlf
		sqlStr = sqlStr &  "FROM [db_event].[dbo].[tbl_contest_poll] as p " + vbcrlf
		sqlStr = sqlStr &  "Inner Join [db_event].[dbo].[tbl_contest_poll_image] as i " + vbcrlf
		sqlStr = sqlStr &  "ON p.idx = i.poll_idx " + vbcrlf
		sqlStr = sqlStr &  "where p.contest = '" & FContest & "' and i.img_code = '1' ORDER BY NEWID()" + vbcrlf
		rsget.Open sqlStr,dbget,1
		response.write sqlStr
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new cConitem
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fimagename = rsget("img_name")
				FItemList(i).fusernum = rsget("poll_idx")
				FItemList(i).fsubject = db2html(rsget("subject"))
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	End Sub


	public sub fevt_ContestView()
		dim SqlStr,i
		SqlStr = "SELECT idx, userid, subject, contents FROM [db_event].[dbo].[tbl_contest_poll] WHERE contest = '" & FContest & "' AND idx = '" & FUserNum & "'"
		rsget.Open sqlStr,dbget,1
		set FOneItem = new cConitem
		FOneItem.fusernum = rsget("idx")
		FOneItem.fuserid = rsget("userid")
		FOneItem.fsubject = db2html(rsget("subject"))
		FOneItem.fcontents = db2html(rsget("contents"))
		'FOneItem.fimagename = Left(rsget("userid"),Len(rsget("userid"))-2) & "_01_m.jpg"

		rsget.Close
	End Sub


	public sub Fevt_ContestImageList()
		dim sqlStr,i , sqlsearch
'		if FUserID <> "" then
'			sqlsearch = sqlsearch & " and userid = '"&FUserID&"'" + vbcrlf
'		end if

		'총 갯수 구하기
		sqlStr = "SELECT COUNT(p.idx) as cnt" + vbcrlf
		sqlStr = sqlStr & " FROM [db_event].[dbo].[tbl_contest_poll_image] as i " + vbcrlf
		sqlStr = sqlStr &  "Inner Join [db_event].[dbo].[tbl_contest_poll] as p " + vbcrlf
		sqlStr = sqlStr &  "ON p.idx = i.poll_idx " + vbcrlf
		sqlStr = sqlStr & " WHERE p.contest = '" & FContest & "' AND i.poll_idx = '" & FUserNum & "' AND i.img_code = '"&FImgcode&"' "
'response.write sqlStr
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close

		'데이터 리스트
		sqlStr = "SELECT TOP " & Cstr(FPageSize * FCurrPage) + vbcrlf
		sqlStr = sqlStr & " i.idx , i.poll_idx , i.contest , i.img_code , i.img_name , isNull(i.img_name2,'') AS img_name2 , p.subject, p.contents, p.userid " + vbcrlf
		sqlStr = sqlStr & " FROM [db_event].[dbo].[tbl_contest_poll_image] as i " + vbcrlf
		sqlStr = sqlStr &  "Inner Join [db_event].[dbo].[tbl_contest_poll] as p " + vbcrlf
		sqlStr = sqlStr &  "ON p.idx = i.poll_idx " + vbcrlf
		sqlStr = sqlStr & " WHERE p.contest = '" & FContest & "' AND i.poll_idx = '" & FUserNum & "' AND i.img_code = '"&FImgcode&"' " & sqlsearch
		sqlStr = sqlStr & " ORDER BY img_code ASC, sortno DESC, i.idx ASC" + vbcrlf

		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)
		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new cConitem
				FItemList(i).fimagename = rsget("img_name")
				FItemList(i).fimagename2 = rsget("img_name2")
				FItemList(i).fsubject = db2html(rsget("subject"))
				FItemList(i).fcontents = db2html(rsget("contents"))
				FItemList(i).fuserid = rsget("userid")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	end sub


	public sub fevt_ContestResult()
		dim SqlStr

		SqlStr = "SELECT idx, userid, poll_count " + vbcrlf
		SqlStr = SqlStr & " 	FROM [db_event].[dbo].[tbl_contest_poll] " + vbcrlf
		SqlStr = SqlStr & " WHERE contest = '" & FContest & "' " + vbcrlf
		SqlStr = SqlStr & " ORDER BY poll_count DESC " + vbcrlf
		rsget.Open SqlStr, dbget, 1
		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new cConitem
				FItemList(i).fusernum = rsget("idx")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fpollcount = rsget("poll_count")

				FPollTotalCount = FPollTotalCount + FItemList(i).fpollcount
				i=i+1
				rsget.moveNext
			loop
		end if

		If FPollTotalCount = "0" Then
			FPollTotalCount = "1"
		End If

		rsget.close
	end sub


	public sub fevt_ContestResult2()
		dim SqlStr

		SqlStr = "SELECT p.idx, p.userid, p.poll_count, i.img_name " + vbcrlf
		SqlStr = SqlStr & " FROM [db_event].[dbo].[tbl_contest_poll] as p " + vbcrlf
		SqlStr = SqlStr & " Inner Join [db_event].[dbo].[tbl_contest_poll_image] as i " + vbcrlf
		SqlStr = SqlStr & " ON p.idx = i.poll_idx " + vbcrlf
		SqlStr = SqlStr & " WHERE p.contest = '" & FContest & "' and i.img_code = '3' " + vbcrlf
		SqlStr = SqlStr & " ORDER BY poll_count DESC " + vbcrlf

		rsget.Open SqlStr, dbget, 1
		FResultCount = rsget.RecordCount
		'response.write SqlStr
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new cConitem
				FItemList(i).fusernum = rsget("idx")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fpollcount = rsget("poll_count")
				FItemList(i).fimagename = rsget("img_name")
				FPollTotalCount = FPollTotalCount + FItemList(i).fpollcount
				i=i+1
				rsget.moveNext
			loop
		end if

		If FPollTotalCount = "0" Then
			FPollTotalCount = "1"
		End If

		rsget.close
	end sub

	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 5
		FResultCount = 0
		FScrollCount = 5
		FTotalCount =0
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

Function TotalPageCount(vUserNum)
	If vUserNum = "2" Then
		TotalPageCount = "3,12"
	ElseIf vUserNum = "3" Then
		TotalPageCount = "4,19"
	ElseIf vUserNum = "4" Then
		TotalPageCount = "2,10"
	ElseIf vUserNum = "5" Then
		TotalPageCount = "5,24"
	ElseIf vUserNum = "6" Then
		TotalPageCount = "3,12"
	ElseIf vUserNum = "7" Then
		TotalPageCount = "6,29"
	ElseIf vUserNum = "8" Then
		TotalPageCount = "6,26"
	ElseIf vUserNum = "9" Then
		TotalPageCount = "4,19"
	ElseIf vUserNum = "10" Then
		TotalPageCount = "6,28"
	ElseIf vUserNum = "11" Then
		TotalPageCount = "4,16"
	ElseIf vUserNum = "12" Then
		TotalPageCount = "2,10"
	ElseIf vUserNum = "13" Then
		TotalPageCount = "4,17"
	ElseIf vUserNum = "14" Then
		TotalPageCount = "5,24"
	ElseIf vUserNum = "15" Then
		TotalPageCount = "3,15"
	End IF
End Function

Function PercentView(cnt,totcnt)
	PercentView = FormatPercent(cnt/totcnt)
	If Right(Replace(PercentView,"%",""),2) = "00" Then
		PercentView = FormatPercent(cnt/totcnt,0)
	End If
End Function
%>