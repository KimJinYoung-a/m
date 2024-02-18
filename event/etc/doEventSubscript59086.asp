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
	<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="/lib/js/jquery-ui-1.10.3.custom.min.js"></script>
	<script type="text/javascript" src="/lib/js/swiper-2.1.min.js"></script>
<%
dim eCode, vUserID, vGubun, vQuestion, vTxtComm, vIdx, vIsClick, vLikeCnt, vListBest, vDevice
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21460"
	Else
		eCode = "59086"
	End If
	
	if isApp=1 then
		vDevice = "a"
	else
		vDevice = "m"
	end if
	
	vIdx = requestCheckVar(Request("idx"),5)
	vGubun = requestCheckVar(Request("gubun"),1)
	vUserID = GetLoginUserID
	vQuestion = requestCheckVar(Request("question"),1)
	vTxtComm = requestCheckVar(Request("txtcomm"),210)
	vTxtComm = html2db(vTxtComm)
	vListBest = requestCheckVar(Request("lb"),1)
	

	If vUserID = "" Then
		response.write "<script language='javascript'>alert('잘못된 접근입니다.'); parent.location.reload();</script>"
		dbget.close()
	    response.end
	End IF

	Dim vQuery

If vGubun = "1" Then
		vQuery = "INSERT INTO [db_temp].[dbo].[tbl_event_59086](userid, question, comment, device) VALUES('" & vUserID & "', '" & vQuestion & "', '" & vTxtComm & "', '" & vDevice & "')"
		dbget.Execute vQuery
		
		response.write "<script language='javascript'>alert('저장 되었습니다.'); parent.location.reload();</script>"
		dbget.close()
	    response.end
ElseIf vGubun = "2" Then
		If vIdx = "" Then
			response.write "<script language='javascript'>alert('잘못된 접근입니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		End IF
		
		If isNumeric(vIdx) = False Then
			response.write "<script language='javascript'>alert('잘못된 접근입니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		End IF
	
	
		vQuery = "SELECT COUNT(idx) FROM [db_temp].[dbo].[tbl_event_click_log] WHERE eventid = '" & eCode & "' AND chkid = '" & vUserID & "' AND temp1 = '" & vIdx & "'"
		rsget.open vQuery, dbget, 1
		If rsget(0) > 0 Then
			vIsClick = "o"
		Else
			vIsClick = "x"
		End If
		rsget.close
		
		If vIsClick = "x" Then
			vQuery = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid, temp1) VALUES('" & eCode & "', '" & vUserID & "', '" & vIdx & "') " & vbCrLf
			vQuery = vQuery & "UPDATE [db_temp].[dbo].[tbl_event_59086] SET likeCnt = likeCnt + 1 WHERE idx = '" & vIdx & "'"
			dbget.Execute vQuery
			
			vQuery = "SELECT likeCnt FROM [db_temp].[dbo].[tbl_event_59086] WHERE idx = '" & vIdx & "'"
			rsget.open vQuery, dbget, 1
			If Not rsget.Eof Then
				vLikeCnt = rsget(0)
			End If
			rsget.close
			
			If vListBest = "l" Then
				vListBest = "list"
			ElseIf vListBest = "b" Then
				vListBest = "best"
			End If
			
			response.write "<script>parent.$(""#"&vListBest&"likecount"&vIdx&""").empty().append("&vLikeCnt&"); parent.$(""#"&vListBest&"likecountBt"&vIdx&" > em"").addClass(""thisMyLike"");</script>"
			'response.write "<script>parent.location.reload();</script>"
			dbget.close()
			response.end
		ElseIf vIsClick = "o" then
			response.write "<script language='javascript'>alert('이미 LIKE 하셨습니다.');</script>"
			dbget.close()
		    response.end
		End If
ElseIf vGubun = "4" Then
		vQuery = "DELETE [db_temp].[dbo].[tbl_event_59086] WHERE idx = '" & vIdx & "' AND userid = '" & vUserID & "'"
		dbget.Execute vQuery
		
		response.write "<script>parent.location.reload();</script>"
		dbget.close()
		response.end
End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->