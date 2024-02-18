<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 웨딩 기획전 사용자 정보 저장
' History : 2018.03.19 정태훈
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
Dim mode, vQuery, refer, getbonuscoupon1, getbonuscoupon2, rvalue1, rvalue2
Dim userid, username, partnername, weddingdate, sms, email, sex

	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),4)

	username = requestcheckvar(request("username"),32)
	partnername = requestcheckvar(request("partnername"),32)
	weddingdate = requestcheckvar(request("yyyy"),4) & "-" & requestcheckvar(request("mm"),2) & "-" & requestcheckvar(request("dd"),2)
	sms = requestcheckvar(request("sms"),1)
	email = requestcheckvar(request("email"),1)
	sex = requestcheckvar(request("sex"),1)

	refer = request.ServerVariables("HTTP_REFERER")

	'쿠폰 정보
IF application("Svr_Info") = "Dev" THEN
	getbonuscoupon1 = 2874
	getbonuscoupon2 = 2875
Else
	getbonuscoupon1 = 1040
	getbonuscoupon2 = 1041
End If


if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "01|잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "02|로그인을 해주세요."
	dbget.close() : Response.End
End IF

If Cdate(weddingdate) < now() Then
	Response.Write "04|결혼 예정일이 지났습니다."
	dbget.close() : Response.End
End If

'## 이벤트쿠폰 다운	함수(선택고객,중복발급 불가)
Function fnSetSelectCouponDown(ByVal userid, ByVal idx)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_user].[dbo].sp_Ten_eventcoupon_down_selected("&idx&",'"&userid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With
		fnSetSelectCouponDown = objCmd(0).Value
	Set objCmd = Nothing
END Function

If mode="add" Then
	dbget.beginTrans

	vQuery = "INSERT INTO [db_sitemaster].[dbo].[tbl_wedding_user_info] (UserID, UserName, Sex, PartnerName, WeddingDate, SMS, Email)" & vbCrlf
	vQuery = vQuery & " VALUES ('"& userid &"', '"& username &"', '"&sex&"','"&partnername&"','"&weddingdate&"','"&sms&"','"&email&"')"
	dbget.execute vQuery
	
	rvalue1 = fnSetSelectCouponDown(userid,getbonuscoupon1)
	rvalue2 = fnSetSelectCouponDown(userid,getbonuscoupon2)

	If rvalue1=0 Or rvalue2=0 Then 	'문제 발생시 롤백처리
		dbget.CommitTrans
		Response.Write "03|정상적인 경로가 아닙니다."
		dbget.close() : Response.End
	ElseIf rvalue1=1 And rvalue2=1 Then '정상처리
		dbget.CommitTrans
		Response.Write "98|쿠폰이 발급되었습니다."
		dbget.close() : Response.End
	ElseIf (rvalue1=2 Or rvalue2=2) Then
		dbget.CommitTrans
		Response.Write "05|기간이 종료되었거나 유효하지 않은 쿠폰입니다."
		dbget.close() : Response.End
	ElseIf (rvalue1=3 Or rvalue2=3) Then
		dbget.CommitTrans
		Response.Write "06|이미 쿠폰을 받으셨습니다."
		dbget.close() : Response.End
	End If
ElseIf mode="edit" Then
	vQuery = "update [db_sitemaster].[dbo].[tbl_wedding_user_info]" & vbCrlf
	vQuery = vQuery & " set UserName='"&username&"'" & vbCrlf
	vQuery = vQuery & " , Sex='"&sex&"'" & vbCrlf
	vQuery = vQuery & " , PartnerName='"&partnername&"'" & vbCrlf
	vQuery = vQuery & " , WeddingDate='"&weddingdate&"'" & vbCrlf
	vQuery = vQuery & " , SMS='"&sms&"'" & vbCrlf
	vQuery = vQuery & " , Email='"&email&"'" & vbCrlf
	vQuery = vQuery & " where userid='"& userid &"'"
	dbget.execute vQuery
	Response.Write "99|수정 되었습니다."
	dbget.close() : Response.End
ElseIf mode="del" Then
	vQuery = "update [db_sitemaster].[dbo].[tbl_wedding_user_info]" & vbCrlf
	vQuery = vQuery & " set isusing='N'" & vbCrlf
	vQuery = vQuery & " where userid='"& userid &"'"
	dbget.execute vQuery
	Response.Write "97|삭제 되었습니다."
	dbget.close() : Response.End
Else
	Response.Write "03|정상적인 경로가 아닙니다."
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->