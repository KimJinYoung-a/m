<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim nowCouponIdx, olderCouponIdxOne, olderCouponIdxTwo
Dim rvalue

'## 기존에 사용했던 APP전용쿠폰코드
olderCouponIdxOne = 1028
olderCouponIdxTwo = 1059

'## APP전용쿠폰코드
nowCouponIdx = 1060


'## APP 전용 쿠폰 발급
Function fnSetAppCouponIssued(ByVal userid, ByVal idx, ByVal olderCouponIdxOne, ByVal olderCouponIdxTwo)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_user].[dbo].[usp_Ten_APPPurchaseOnlyCouponIssued]("&idx&",'"&userid&"',"&olderCouponIdxOne&","&olderCouponIdxTwo&")}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With
		fnSetAppCouponIssued = objCmd(0).Value
	Set objCmd = Nothing
END Function


'## 로그인을 확인한다.
If IsUserLoginOK Then
	rvalue = fnSetAppCouponIssued(getEncLoginUserId,nowCouponIdx,olderCouponIdxOne,olderCouponIdxTwo)
	Response.Write rvalue
	response.cookies("appcoupon1060") = "Y"
	response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->