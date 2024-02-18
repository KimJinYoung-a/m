<%@ language=vbscript %>
<% option Explicit %>
<%
Response.CharSet = "euc-kr"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Expires","0"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/projectCls.asp" -->
<%
	Dim cProj, vIdx, vPage, vSort, vTopCount, vGroupCode, vPrjGender
	vIdx = requestCheckVar(request("idx"),10)
	vSort = requestCheckVar(request("sort"),10)
	vPage = requestCheckVar(request("page"),3)
	vPrjGender = requestCheckVar(request("gen"),3)
	vGroupCode = 0
	vTopCount = vPage * 10
	

%>
<% sbEvtItemList %>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->