<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_orderCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%
'' 아이폰 ISP 결제.
	'/////////////////////////////////////////////////////////////////////////////
	'///// 1. GET값 받기                                                      ////
	'/////////////////////////////////////////////////////////////////////////////
	Dim P_OID, vIdx, vIOrder, vIsSuccess, vAppName, vAppLink
	P_OID			= trim(request("P_OID"))		'// 결제요청 페이지에서 세팅한 주문번호
	vIdx			= trim(request("idx"))

    vIdx = replace(vIdx,"null","")  ''2013/05/27추가 
    
	Dim vQuery
	vQuery = "SELECT giftOrderSerial, IsSuccess, rdsite From [db_order].[dbo].[tbl_giftcard_order_temp] WHERE temp_idx = '" & vIdx & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vIOrder = rsget("giftOrderSerial")
		vIsSuccess = rsget("IsSuccess")
		vAppName = rsget("rdsite")
		
		Response.Cookies("shoppingbag").domain = "10x10.co.kr"
		Response.Cookies("shoppingbag")("before_GiftOrdSerial") = vIOrder
		
		if vIsSuccess = "True" then
			Response.Cookies("shoppingbag")("before_GiftisSuccess") = "true"
		else
			Response.Cookies("shoppingbag")("before_GiftisSuccess") = "false"
		end if
		
		dim dumi : dumi=LEFT(MD5(vIOrder&"ten"&vIOrder),20)	''TenOrderSerialHash(vIOrder)	in "/lib/classes/ordercls/sp_myordercls.asp"
	End IF
	rsget.close()
	
	SELECT CASE vAppName
		Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
		Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	End SELECT
	
	''Response.Redirect "" & vAppLink & "/giftcard/DisplayOrder.asp?dumi="&dumi
	response.write "<script language='javascript'>location.replace('"& vAppLink & "/giftcard/DisplayOrder.asp?dumi="&dumi&"');</script>"
%>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->