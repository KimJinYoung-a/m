<%@ language=vbscript %>
<% option explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<%
	Dim vMode, CsAsID, vQuery, vResultCount, vAlert, vUserID
	vMode	= requestCheckVar(request("mode"),10)
	CsAsID 	= requestCheckVar(request("CsAsID"),10)
	vUserID	= getEncLoginUserID

	If vMode = "" Then
		dbget.close()
		Response.Write "<script>alert('잘못된 접근입니다.');window.close();</script>"
		Response.End
	End IF

	If CsAsID = "" OR IsNumeric(CsAsID) = false Then
		dbget.close()
		Response.Write "<script>alert('잘못된 접근입니다.');window.close();</script>"
		Response.End
	End IF

	'####### 여러 mode 가 생길지 모르니 mode 값을 받고 If로 각각 처리. 2011-08-04 강준구.

	If vMode = "delete" Then	'### 반품접수 철회
		vQuery = "UPDATE [db_cs].[dbo].tbl_new_as_list SET " & _
				 "		deleteyn = 'Y', " & _
				 "		finishuser = '" & CHKIIF(vUserID="","system",vUserID) & "', " & _
				 "		finishdate = getdate(), " & _
				 "		contents_finish = '" & CHKIIF(vUserID="","비회원 고객 직접 취소","고객 직접 취소") & "' " & _
				 "	WHERE " & _
				 "		id = '" & CsAsID & "' AND currstate < 'B006' "

		dbget.Execute vQuery, vResultCount

		If vResultCount < 1 Then
			vAlert = "반품접수 철회를 처리하는데 문제가 발생했습니다.\n자세한 문의는 고객센터 Tel.1644-6030 으로 연락을 주시기 바랍니다."
		Else
			vAlert = "반품접수 철회가 되었습니다."
		End If
	End If
%>

<script language="javascript">
	alert("<%=vAlert%>");
	opener.document.location.reload();
	window.close();
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->