<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	'/////////////////////////////////////////////////////////////////////////////
	'///// 1. GET값 받기                                                      ////
	'/////////////////////////////////////////////////////////////////////////////
	Dim P_OID, vIdx, vIOrder, vIsSuccess, vAppName, vAppLink
	P_OID			= trim(request("P_OID"))		'// 결제요청 페이지에서 세팅한 주문번호
	vIdx			= trim(request("idx"))

    vIdx = replace(vIdx,"null","")  ''2013/05/27추가 
    
	Dim vQuery
	vQuery = "SELECT orderserial, IsSuccess, rdsite From [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vIOrder = rsget("orderserial")
		vIsSuccess = rsget("IsSuccess")
		vAppName = rsget("rdsite")
		
		session("before_orderserial") = vIOrder
		
		if vIsSuccess = "True" then
			session("before_issuccess") = "true"
		else
			session("before_issuccess") = "false"
		end if
	End IF
	rsget.close()
	
	SELECT CASE vAppName
		Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
		Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
		Case "betweenshop" : vAppLink = "/apps/appCom/between"
	End SELECT
	
	
    ''SSL 경우 스크립트로 replace
    response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipay/displayorder.asp');</script>"
    ''Response.Redirect "" & vAppLink & "/inipay/DisplayOrder.asp"
%>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->