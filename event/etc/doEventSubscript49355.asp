<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<%
dim eCode, userid, vGubun, vTotalCount, v3Count, vItemID
vTotalCount = 0
v3Count = 0

If date() > "2014-02-21" Then
	dbget.close()
    response.end
End If

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21082"
	Else
		eCode = "49354"
	End If

userid = GetLoginUserID
vGubun = requestCheckVar(Request("gubun"),1)
vItemID = requestCheckVar(Request("itemid"),10)

If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

Dim vQuery

IF vGubun = "1" Then
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & userid & "' AND sub_opt3 = '" & date() & "' AND sub_opt1 = 'm1'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			vTotalCount = rsget(0)
		End IF
		rsget.close
		If vTotalCount > 0 Then
			response.write "<script language='javascript'>parent.location.reload();</script>"
			dbget.close()
		    response.end
		Else
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3) VALUES('" & eCode & "', '" & userid & "', 'm1', '" & date() & "')"
			dbget.Execute vQuery
			
			vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & userid & "' AND sub_opt1 = 'm1'"
			rsget.Open vQuery,dbget,1
			IF Not rsget.Eof Then
				v3Count = rsget(0)
			End IF
			rsget.close
			
			If CStr(v3Count) = CStr("3") Then
				vQuery = "update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 300 where userid = '" & userid & "' " & vbCrLf & _
						 "insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values('" & userid & "', '+300', 1000, '퍼즐 한판을 맞춰라!! 300 마일리지 적립','N')"
				dbget.Execute vQuery
				
				response.write "<script language='javascript'>alert('3개의 퍼즐을 완성하였습니다!\n300마일리지 지급!');parent.location.reload();</script>"
			Else
				IF date() = "2014-02-21" Then
					If CStr(v3Count) = CStr("5") Then
						response.write "<script language='javascript'>alert('축하해요! 모든 퍼즐을 완성하였습니다!\n이벤트에 자동 응모 되었습니다!');</script>"
					Else
						response.write "<script language='javascript'>alert('오늘의 퍼즐을 맞추셨습니다.');</script>"
					End IF
				Else
					response.write "<script language='javascript'>alert('오늘의 퍼즐을 맞추셨습니다.\n내일도 도전하세요!');parent.location.reload();</script>"
				End If
			End IF
		
			dbget.close()
		    response.end
		End IF
		
ElseIf vGubun = "2" Then
		vItemID = Replace(vItemID,".","")
		If isNumeric(vItemID) = False Then
			response.write "<script language='javascript'>alert('상품코드를 잘못 입력 하셨습니다.');parent.location.reload();</script>"
			dbget.close()
		    response.end
		End IF
	
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & userid & "' AND sub_opt3 = '" & date() & "' AND sub_opt1 = 'm2'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			vTotalCount = rsget(0)
		End IF
		rsget.close
		If vTotalCount > 3 Then
			If vTotalCount = 4 Then
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3) VALUES('" & eCode & "', '" & userid & "', 'm2', '" & vItemID & "', '" & date() & "')"
				dbget.Execute vQuery
				response.write "<script language='javascript'>alert('오늘 5회 모두 응모 완료하셨습니다.\n내일 다시 도전하세요!');parent.location.reload();</script>"
				dbget.close()
			    response.end
			Else
				response.write "<script language='javascript'>alert('오늘 5회 모두 응모 완료하셨습니다.\n내일 다시 도전하세요!');parent.location.reload();</script>"
				dbget.close()
			    response.end
			End IF
		Else
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3) VALUES('" & eCode & "', '" & userid & "', 'm2', '" & vItemID & "', '" & date() & "')"
			dbget.Execute vQuery
			response.write "<script language='javascript'>alert('응모 완료하셨습니다.\n오늘 하루 "&(4-vTotalCount)&"번 더 응모 가능합니다.');parent.location.reload();</script>"
			dbget.close()
		    response.end
		End IF
		
End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->