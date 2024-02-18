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
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
'' 아이폰 ISP 결제.
	'/////////////////////////////////////////////////////////////////////////////
	'///// 1. GET값 받기                                                      ////
	'/////////////////////////////////////////////////////////////////////////////
	Dim P_OID, vIdx, vIOrder, vIsSuccess, vAppName, vAppLink, vUserID
	P_OID			= trim(request("P_OID"))		'// 결제요청 페이지에서 세팅한 주문번호
	vIdx			= trim(request("idx"))

    vIdx = replace(vIdx,"null","")  ''2013/05/27추가 
    
	Dim vQuery
	vQuery = "SELECT orderserial, IsSuccess, rdsite, userid From [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vIOrder = rsget("orderserial")
		vIsSuccess = rsget("IsSuccess")
		vAppName = rsget("rdsite")
		vUserID = rsget("userid")  ''2017/10/24 추가
		
		Response.Cookies("shoppingbag").domain = "10x10.co.kr"
		Response.Cookies("shoppingbag")("before_orderserial") = vIOrder
		
		if vIsSuccess = "True" then
			Response.Cookies("shoppingbag")("before_issuccess") = "true"
		else
			Response.Cookies("shoppingbag")("before_issuccess") = "false"
		end if
		
		dim dumi : dumi=TenOrderSerialHash(vIOrder)
	End IF
	rsget.close()
	
	SELECT CASE vAppName
		Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
		Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	End SELECT

''비회원인 경우 orderserial-uk 값 저장. 2017/10/23 require commlib
IF (vIsSuccess="True") and (vUserID="") then
    Call fnUserLogCheck_AddGuestOrderserial_UK(vIOrder,request.Cookies("shoppingbag")("GSSN")) 
end if
	
	'Response.Redirect "" & vAppLink & "/inipay/DisplayOrder.asp?dumi="&dumi
	''response.write "<script language='javascript'>location.replace('"& vAppLink & "/inipay/DisplayOrder.asp?dumi="&dumi&"');</script>"
	'response.write "<script>fnUpdateCookieForWKWebView();</script>"
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<script language="javascript">
    setTimeout(function(){
        try{
            window.location.replace("<%=vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
        }catch(ss){
            location.href="<%=vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>";
        }
    },1200);  // 길게줌.
</script>