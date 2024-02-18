<%

'// 아래 세개의 파일이 일치해야 한다.
'//
'// /2013www/lib/util/badgelib.asp
'// /imgstatic/lib/badgelib.asp
'// /imgstatic/lib/badgelibUTF8.asp

'// gubunCode : 0001 로그인, 0002 상품구매, 0003 쇼핑톡, 0004 위시담기, 0005 후기작성, 0006 기프트초이스, 0007 커스텀 뱃지
'//
'// 상품 코드는 여러개일 수 있다.
'// (참조 : /my10x10/myfavorite_process.asp)
'//
Function MyBadge_CheckInsertBadgeLog(userid, gubunCode, refCode, refItemID, refItemOption)
	dim strSql, i, minIdx, maxIdx, returnStr
	dim itemidArr

	MyBadge_CheckInsertBadgeLog = ""

	Select Case gubunCode
		Case "0001"
			'// 로그인
			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcWithLogin ('"&userid&"', '" + CStr(gubunCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcCheck ('"&userid&"', '" + CStr(gubunCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			response.Cookies("mybadge").domain = "10x10.co.kr"
			response.Cookies("mybadge")("logindate") = Left(FormatDate(Now, "0000.00.00-00:00:00"), 13)
		Case "0003"
			'// 쇼핑톡
			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcWithGift ('"&userid&"', '" + CStr(gubunCode) + "','" + cStr(refCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcCheck ('"&userid&"', '" + CStr(gubunCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			if (MyBadge_CheckNewObtainedBadge(userid) = True) then
				response.Cookies("mybadge").domain = "10x10.co.kr"
				response.Cookies("mybadge")("newbadge") = "Y"
			end if

		Case "0004"
			'// ================================================================
			'// 위시담기
			'// ================================================================
			itemidArr = refItemID
			if (itemidArr <> "") then
				if (Left(itemidArr,1)=",") then itemidArr = Mid(itemidArr,2,1024)
				if (Right(itemidArr,1)=",") then itemidArr = Left(itemidArr, Len(itemidArr) - 1)
			end if

			itemidArr = split(itemidArr, ",")
			for i = 0 to ubound(itemidArr)
				if IsNumeric(itemidArr(i)) then
					strSql ="[db_log].[dbo].usp_Ten_Badge_ProcWithItemID ('"&userid&"', '" + CStr(gubunCode) + "', " + CStr(itemidArr(i)) + ")"
					rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
				end if
   			next

			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcCheck ('"&userid&"', '" + CStr(gubunCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			if (MyBadge_CheckNewObtainedBadge(userid) = True) then
				response.Cookies("mybadge").domain = "10x10.co.kr"
				response.Cookies("mybadge")("newbadge") = "Y"
			end if
		Case "0005"
			'// 후기작성
			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcWithItemID ('"&userid&"', '" + CStr(gubunCode) + "', " + CStr(refItemID) + ", '" + CStr(refItemOption) + "', '" + CStr(refCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcCheck ('"&userid&"', '" + CStr(gubunCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			if (MyBadge_CheckNewObtainedBadge(userid) = True) then
				response.Cookies("mybadge").domain = "10x10.co.kr"
				response.Cookies("mybadge")("newbadge") = "Y"
			end if
		Case "0006"
			'// 기프트 초이스
			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcWithGift ('"&userid&"', '" + CStr(gubunCode) + "','" + cStr(refCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			strSql ="[db_log].[dbo].usp_Ten_Badge_ProcCheck ('"&userid&"', '" + CStr(gubunCode) + "')"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

			if (MyBadge_CheckNewObtainedBadge(userid) = True) then
				response.Cookies("mybadge").domain = "10x10.co.kr"
				response.Cookies("mybadge")("newbadge") = "Y"
			end if

		Case "0007"
			'// 이벤트 커스텀

		Case Else
			'// 처리 안함
	End Select

End Function

Function MyBadge_CheckNewObtainedBadge(userid)
	dim strSql, badgeIdx

	MyBadge_CheckNewObtainedBadge = False

	strSql = " select top 1 u.badgeIdx "
	strSql = strSql + " from "
	strSql = strSql + " 	db_my10x10.dbo.tbl_badge_userObtain u "
	strSql = strSql + " where "
	strSql = strSql + " 	1 = 1 "
	strSql = strSql + " 	and u.userid = '" + CStr(userid) + "' "
	strSql = strSql + " 	and u.announceDate is NULL "

	rsget.open strSql,dbget,1
	if  not rsget.EOF  then
		MyBadge_CheckNewObtainedBadge = True
	end if
	rsget.Close

End Function

Function MyBadge_GetNewObtainedBadge(userid)
	dim strSql, i, minIdx, maxIdx, arrBadgeIdx
	dim returnStr

	response.Cookies("mybadge").domain = "10x10.co.kr"
	response.Cookies("mybadge")("newbadge") = ""

	MyBadge_GetNewObtainedBadge = ""

	strSql = " select top 10 u.idx, b.badgeIdx, b.dispno "
	strSql = strSql + " from "
	strSql = strSql + " 	db_my10x10.dbo.tbl_badge_userObtain u "
	strSql = strSql + " 	join db_my10x10.dbo.tbl_badge_info b "
	strSql = strSql + " 	on "
	strSql = strSql + " 		u.badgeIdx = b.badgeIdx "
	strSql = strSql + " where "
	strSql = strSql + " 	1 = 1 "
	strSql = strSql + " 	and u.userid = '" + CStr(userid) + "' "
	strSql = strSql + " 	and u.announceDate is NULL "
	strSql = strSql + " order by "
	strSql = strSql + " 	u.idx "

	minIdx = 0
	maxIdx = 0
	arrBadgeIdx = ""

	rsget.open strSql,dbget,1
	if  not rsget.EOF  then
		i = 0
		do until rsget.eof
			if (i = 0) then
				minIdx = rsget("idx")
				maxIdx = rsget("idx")
				arrBadgeIdx = CStr(rsget("dispno"))
			else
				maxIdx = rsget("idx")
				arrBadgeIdx = arrBadgeIdx + "," + db2html(rsget("dispno"))
			end if
			i = i + 1
			rsget.moveNext
		loop
	end if
	rsget.Close

	if (minIdx > 0) then
		strSql = " update db_my10x10.dbo.tbl_badge_userObtain "
		strSql = strSql + " set announceDate = CONVERT(VARCHAR(10), GETDATE(), 121) "
		strSql = strSql + " where "
		strSql = strSql + " 	1 = 1 "
		strSql = strSql + " 	and userid = '" + CStr(userid) + "' "
		strSql = strSql + " 	and idx >= " + CStr(minIdx) + " "
		strSql = strSql + " 	and idx <= " + CStr(maxIdx) + " "
		strSql = strSql + " 	and announceDate is NULL "
		dbget.Execute strSql

		MyBadge_GetNewObtainedBadge = arrBadgeIdx
	end if

End Function

Function MyBadge_MyBadgeList(userid)
	Dim strSql
	strSql ="[db_my10x10].[dbo].usp_Ten_MyBadgeGetList ('"&userid&"')"
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
	IF Not (rsget.EOF OR rsget.BOF) THEN
		MyBadge_MyBadgeList = rsget.GetRows()
	END IF
	rsget.close
end Function

Function MyBadge_MyBadgeGetRecommandItem(userid, badgeIdx)
	Dim strSql
	strSql ="[db_my10x10].[dbo].usp_Ten_MyBadge_GetRecommandItem ('"&userid&"', " + CStr(badgeIdx) + ")"
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
	IF Not (rsget.EOF OR rsget.BOF) THEN
		MyBadge_MyBadgeGetRecommandItem = rsget.GetRows()
	END IF
	rsget.close
end Function

%>
