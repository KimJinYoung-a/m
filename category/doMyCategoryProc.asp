<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim vQuery, vUserID, vCateCode, vDepth
	vUserID	= requestCheckVar(Request("userid"),32)
	vCateCode = requestCheckVar(Request("catecode"),15)
	
	If vCateCode = "" Then
		Response.Write "<script>alert('올바른 경로가 아닙니다.');top.location.href='"&wwwURL&"';</script>"
		dbget.close()
		Response.End
	End IF
	If isNumeric(vCateCode) = False Then
		Response.Write "<script>alert('올바른 경로가 아닙니다.');top.location.href='"&wwwURL&"';</script>"
		dbget.close()
		Response.End
	End IF
	IF vUserID = "" OR getLoginUserID = "" THEN
		Response.Write "<script>alert('올바른 경로가 아닙니다.');top.location.href='"&wwwURL&"';</script>"
		dbget.close()
		Response.End
	END IF
	IF vUserID <> getLoginUserID THEN
		Response.Write "<script>alert('아이디 정보가 일치하지 않습니다.');top.location.href='"&wwwURL&"';</script>"
		dbget.close()
		Response.End
	END IF
	
	vDepth = Len(vCateCode)/3
	
	vQuery = "EXECUTE [db_my10x10].[dbo].[sp_Ten_MyCategory_Proc] '" & vUserID & "', '" & vCateCode & "', '" & vDepth & "'"
	dbget.execute vQuery
	
	IF Err.Number = 0 THEN
		Response.Write "ok"
	Else
		Response.Write "<script>alert('데이터 처리에 실패하였습니다. 새로 고침 후 다시 시도해 주세요.\n\n 지속적으로 문제 발생시 고객센터로 연락주세요.');</script>"
	End IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->