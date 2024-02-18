<%@ language=vbscript %>
<% option Explicit %>
<%
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Expires","0"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/mainCls.asp" -->
<%
	Dim cMainItem, vPage, vSort, vTopCount, vPage2, vTopCount2
	vSort = requestCheckVar(request("sort"),10)
	vPage = requestCheckVar(request("page"),3)
	vPage2 = requestCheckVar(request("page2"),3)
	vTopCount = vPage * 10
	vTopCount2 = vPage2 * 10

	If vSort = "N" Then
		sbMainNewItemList
	Else
		sbMainBestItemList
	End If
%>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->