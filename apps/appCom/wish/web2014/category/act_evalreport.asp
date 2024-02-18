<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 상품후기 신고
' History : 2021.11.12 정태훈
'####################################################
%>

<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	Dim mode, referer, refip, objCmd, resultCode
	Dim userid, evalidx, vQuery, evaluate_type

	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")
	mode = requestcheckvar(request("mode"),10)
    evalidx = requestcheckvar(request("evalidx"),10)
    evaluate_type = requestcheckvar(request("evaluate_type"),1)

	'// 아이디
	userid = getEncLoginUserid()

	IF application("Svr_Info") <> "Dev" THEN
		if InStr(referer,"10x10.co.kr")<1 Then
			Response.Write "Err|잘못된 접속입니다."
			Response.End
		end If
	end If

    '// 로그인시에만 응모가능
    If not(IsUserLoginOK()) Then
        Response.Write "Err|로그인이 필요합니다."
        Response.End
    End If

	Select Case Trim(mode)
		Case "add"

            Set objCmd = Server.CreateObject("ADODB.COMMAND")
            With objCmd
                .ActiveConnection = dbget
                .CommandType = adCmdText
                .CommandText = "{?= call [db_board].[dbo].[usp_Ten_Evaluate_report]('" & userid & "','" & evaluate_type & "'," & evalidx & ")}"
                .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
                .Execute, , adExecuteNoRecords
                End With
                resultCode = objCmd(0).Value
            Set objCmd = Nothing
            if resultCode >= 0 then
                Response.Write "OK|신고가 완료되었습니다."
                Response.End
            else
                Response.Write "Err|이미 신고된 후기입니다. 신고 10회 누적 시 내용이 가려집니다."
                Response.End
            end if
		Case Else
			Response.Write "Err|잘못된 접근 입니다."
			response.End
	End Select
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


