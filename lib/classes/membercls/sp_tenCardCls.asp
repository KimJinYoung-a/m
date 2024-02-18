<%
'//tentencard 발급
Function fnGetTenTenCardNo(userid)
	Dim strsql , ierrCode
	Dim newCardNo, newUserSeq
	Dim rsUserid, rsCardNo, rsUserseq, rsUserlevel
	Dim regidCnt
	strsql = ""
	strsql = strsql & " SELECT TOP 1 n.userid, sc.CardNo, su.userseq, IsNULL(l.userlevel,5) as userlevel "
	strsql = strsql & " FROM db_user.dbo.tbl_user_n as n "
	strsql = strsql & " JOIN db_shop.dbo.tbl_total_shop_user as su on n.userid = su.onlineUserID "
	strsql = strsql & " JOIN db_shop.dbo.tbl_total_shop_card as sc on su.userseq = sc.userseq and sc.useYN = 'Y' "
	strsql = strsql & " JOIN [db_user].[dbo].[tbl_logindata] as l on n.userid = l.userid "
	strsql = strsql & " WHERE n.userid = '"&userid&"' "
	strsql = strsql & " ORDER BY sc.Regdate DESC "
	rsget.Open strSql, dbget, 1
	If rsget.RecordCount > 0 Then
		rsUserid	= rsget("userid")
		rsCardNo	= rsget("CardNo")
		rsUserseq	= rsget("userseq")
		rsUserlevel	= rsget("userlevel")
	Else
		rsUserid	= ""
	End If
	rsget.Close

	If rsCardNo <> "" And Len(rsCardNo) < 16 Then
		ierrCode = "0009"
		Response.write ierrCode
		Response.end
	End If 

	If (rsUserid <> "") and (rsCardNo <> "") And (rsUserseq <> "") and (rsUserlevel <> "") Then	'회원이면서 실제 카드가 있는 경우
		ierrCode = "2101"
		Response.write ierrCode
	Else	'회원이면서 카드가 없는 경우
		On Error Resume Next
		dbget.beginTrans
			'1.카드번호 생성 프로시저를 통해 카드번호 생성
			strsql = ""
			strsql = strsql & " exec [db_shop].[dbo].[sp_ten_getTenTenCardNo] "
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strsql, dbget
			If (Not rsget.Eof) then
				newCardNo = rsget("CardNo")
			End If
			rsget.close

			'2.카드 번호를 넘어온 UserID에 입력 => db_shop.dbo.tbl_total_shop_user이것은 user_n 데이터와 똑같다 생각하자
			strsql = ""
			strsql = "SELECT COUNT(*) as cnt FROM db_shop.dbo.tbl_total_shop_user WHERE OnlineUserID = '"&userid&"'"
			rsget.Open strsql, dbget, 1
				regidCnt = rsget("cnt")
			rsget.Close

			If regidCnt = 0 Then
				strsql = ""
				strsql = strsql & " INSERT INTO db_shop.dbo.tbl_total_shop_user (username, jumin1, HpNo, Email, EmailYN, SMSYN, RegShopID, lastupdate, regdate, OnlineUserID) " & VBCRLF
				strsql = strsql & " SELECT TOP 1 username, LEFT(juminno, 6), usercell, usermail, emailok, smsok, 'tenten', getdate(), getdate(), userid " & VBCRLF
				strsql = strsql & " FROM db_user.dbo.tbl_user_n " & VBCRLF
				strsql = strsql & " WHERE userid = '"&userid&"' " & VBCRLF
				dbget.Execute strSql, 1
			End If

			'3.db_shop.dbo.tbl_total_shopcard에 카드 저장, tbl_total_card_list의 useYN을 Y로 수정
			strsql = ""
			strsql = strsql & " SELECT TOP 1 UserSeq FROM db_shop.dbo.tbl_total_shop_user WHERE OnlineUserID = '"&userid&"' "
			rsget.Open strsql, dbget, 1
			If Not Rsget.Eof Then
				newUserSeq = rsget("UserSeq")
			End If
			rsget.close

			If newUserSeq <> "" Then
				strsql = ""
				strsql = strsql & " INSERT INTO db_shop.dbo.tbl_total_shop_card (UserSeq, CardNo, point, useYN, RegShopID, Regdate) VALUES " & VBCRLF
				strsql = strsql & " ('"&newUserSeq&"', '"&newCardNo&"', 0, 'Y', 'tenten', getdate()) " & VBCRLF
				dbget.Execute strSql, 1
	
				strsql = ""
				strsql = strsql & " UPDATE db_shop.dbo.tbl_total_card_list SET " & VBCRLF
				strsql = strsql & " useYN = 'Y' " & VBCRLF
				strsql = strsql & " WHERE cardNo = '"&newCardNo&"' " & VBCRLF
				dbget.Execute strSql, 1
			End If

		If Err.Number = 0 Then
		    dbget.CommitTrans
			ierrCode = "0000"
			Response.write ierrCode
		Else
		    dbget.RollBackTrans
		    ierrCode = "2222"
			Response.write ierrCode
		End If
		On error Goto 0
	End If
End Function
%>