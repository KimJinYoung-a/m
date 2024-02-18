<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/giftiConCls.asp"-->
<%
	Dim vCouponNO, vIsPaperMoney, vArrPaperMoney, oGicon, vStatus, strData, vItemID

	vCouponNO 		= requestCheckVar(request("pin_no"),15)
	
	If vCouponNO = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vCouponNO) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If

	'################################### 현금액 상품권 ###################################
	vIsPaperMoney	= "x"
	IF application("Svr_Info") = "Dev" THEN
		vArrPaperMoney = ",374487,374488,374489,374490,374491,"
	Else
		vArrPaperMoney = ",588084,588085,588088,588089,588095,"
	End If
	'################################### 현금액 상품권 ###################################

	'################################### 소켓 통신 ###################################
		Set oGicon = New CGiftiCon
		strData = oGicon.reqCouponState(vCouponNO,"100100")  ''쿠폰번호, 추적번호
	    
		If (strData) Then
			vStatus = Trim(oGicon.FConResult.getResultCode)
			vItemID = Trim(oGicon.FConResult.FSubItemBarCode)
		Else
			Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
			dbget.close()
			Response.End
		End If
		Set oGicon = Nothing
	'################################### 소켓 통신 ###################################

	If CStr(vStatus) = "0000" Then		'### 성공
		If instr(1, vArrPaperMoney, ","&vItemID&",") <> "0" Then
			vIsPaperMoney = "o"
		End If
	Else
		Response.write "no"
		Response.End
	End If

	If vIsPaperMoney = "o" Then		'####### 현금액상품권이면 무조건 기프트카드로~
		Response.write "giftcard"
	Else
		Response.write "no"
	End IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->