<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>

<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->


<%
	Dim i, sqlStr, vFuid, vTuid, vGubun


	vFuid = requestCheckVar(Request("Fuid"),32)
	vTuid = requestCheckVar(Request("Tuid"),32)
	vGubun = requestCheckVar(Request("gubun"),32)

	If Trim(vFuid)="" Or Trim(vTuid)="" Or Trim(vGubun)="" Then
'		response.write "<script>alert('�������� ��η� �������ּ���');</script>"
		response.write "3" '// ����
		response.End
	End If



	If vGubun="ins" Then
		sqlStr = " insert into [db_contents].[dbo].tbl_app_wish_followinfo" + VbCrlf
	    sqlStr = sqlStr + " (userid,followUid,regdate) values " + VbCrlf
	    sqlStr = sqlStr + " ('"&vFuid&"','"&vTuid&"',getdate()) "
	    dbget.Execute sqlStr
		response.write "1" '// �ȷο� �ֱ�
		response.End

	End If

	If vGubun="del" Then
		sqlStr = " Delete From [db_contents].[dbo].tbl_app_wish_followinfo" + VbCrlf
	    sqlStr = sqlStr + " Where userid='"&vFuid&"' And followUid='"&vTuid&"' "
	    dbget.Execute sqlStr
		response.write "2" '// �ȷο� ����
		response.End
	End If


%>