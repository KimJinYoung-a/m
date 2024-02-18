<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/logincheckandback.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim chkid, Vol, chklevel

chkid 	= requestCheckVar(request.Form("chkid"),32)
Vol = requestCheckVar(request.Form("Vol"),10)
chklevel = requestCheckVar(request.Form("chklevel"),10)
'----------------------------------
' fnAlertMsg : 메시지 표시
'----------------------------------
Function fnAlertMsg(ByVal strMsg)
%>
	<script language="javascript">
		alert("<%=strMsg%>");
		location.replace('http://www.10x10.co.kr/')
	</script>
<%
End Function

	'// 아이디 확인  //
	IF chkid <> getEncLoginUserID THEN
		fnAlertMsg("아이디 정보가 일치하지 않습니다.")
		response.end
	END IF


	'// vip 회원이상만 신청가능 //
	IF  (  chklevel <> 3 and chklevel <> 4 and chklevel <> 7 and chkid <>"star088") THEN
		fnAlertMsg("V.I.P 회원만 이용가능합니다.\n\n고객등급을 확인해주세요")
		response.end
	END IF

Dim zipcode, addr1, addr2, userphone, usercell
Dim strSql,strQuery
Dim iVol

zipcode = requestCheckVar(request.Form("txZip1"),3) + "-" + requestCheckVar(request.Form("txZip2"),3)
addr1 = html2db(request.Form("txAddr1"))
addr2 = html2db(request.Form("txAddr2"))

userphone = requestCheckVar(request.Form("userphone1"),3) + "-" + requestCheckVar(request.Form("userphone2"),4) + "-" + requestCheckVar(request.Form("userphone3"),4)
usercell = requestCheckVar(request.Form("usercell1"),3)+ "-" + requestCheckVar(request.Form("usercell2"),4) + "-" +requestCheckVar(request.Form("usercell3"),4)
iVol = requestCheckVar(request.Form("Vol"),10)

dbget.beginTrans

	strSql = " UPDATE [db_user].[dbo].tbl_user_n" & VbCrlf
	strSql = strSql & " SET " & VbCrlf
	strSql = strSql & " zipcode='" + zipcode + "'" & VbCrlf
	strSql = strSql & " ,useraddr='" + addr2 + "'" & VbCrlf
	strSql = strSql & " ,userphone='" + userphone + "'" & VbCrlf
	strSql = strSql & " ,usercell='" + usercell + "'"  & VbCrlf
	strSql = strSql & " where userid='" + chkid + "'"
	dbget.execute strSql

	strQuery =" SELECT userid FROM [db_temp].[dbo].[tbl_user_VVip] WHERE VVol = '"&iVol&"' and userid ='"&chkid&"'"
	rsget.Open strQuery, dbget
	IF NOT (rsget.EOF OR rsget.BOF) THEN
		strSql = "UPDATE [db_temp].[dbo].[tbl_user_VVip]"	& VbCrlf
		strSql = strSql & " SET SubmitDate =getdate()"	& VbCrlf
		strSql = strSql & " WHERE VVol = '"& iVol &"'" & VbCrlf
		strSql = strSql & " and userid='"&chkid&"'"
	ELSE
		strSql = "INSERT INTO [db_temp].[dbo].[tbl_user_VVip] "	& VbCrlf
		strSql = strSql & " (VVol, userid, userlevel, SubmitDate )" & VbCrlf
		strSql = strSql & " VALUES " & VbCrlf
		strSql = strSql & " ('"&iVol&"','"&chkid&"','"&chklevel&"',getdate())"
	END IF
		dbget.execute strSql
	rsget.Close

IF Err.Number = 0 THEN
	dbget.CommitTrans
		fnAlertMsg("주소확인 되었습니다. 감사합니다.")
		response.end
Else
   	dbget.RollBackTrans
   		fnAlertMsg("데이터 처리에 실패하였습니다. 다시 시도해 주세요.\n\n 지속적으로 문제 발생시 고객센터로 연락주세요.")
		response.end
End IF

%>