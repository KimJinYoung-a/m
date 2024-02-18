<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/giftiConCls.asp"-->
<!-- #INCLUDE Virtual="/gift/gifticon/check_auto.asp" -->
<%
	Dim vCouponNO, vStatus, vItemID, vItemName, vResult, vQuery, vQuery1, vUserID, vGuestSeKey, vUserLevel, vIdx, vActionURL, vMakerID
	Dim vBrandName, vListImage, vSoldOUT, vArrPaperMoney, vIsPaperMoney
	Dim oGicon, postdata, strData, vntPostedData

	vCouponNO 		= requestCheckVar(request("pin_no"),15)
	vUserID			= GetLoginUserID
	vGuestSeKey		= GetGuestSessionKey
	vUserLevel		= GetLoginUserLevel
	vSoldOUT 		= False
	
	
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
		'##################################### 0000 성공 인경우 #####################################
		If instr(1, vArrPaperMoney, ","&vItemID&",") <> "0" Then
			vIsPaperMoney = "o"
		End If
		
		vQuery = "SELECT itemname, makerid, brandname, listimage, sellyn, limityn, limitno, limitsold From [db_item].[dbo].[tbl_item] WHERE itemid = '" & vItemID & "'"
		rsget.Open vQuery,dbget
		IF Not rsget.EOF THEN
			vItemName	= Replace(rsget("itemname"),"'","")
			vMakerID	= Replace(rsget("makerid"),"'","")
			vBrandName	= Replace(rsget("brandname"),"'","")
			vListImage	= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(vItemID) + "/" + rsget("listimage")
			
			IF vIsPaperMoney <> "o" Then
				IF rsget("limitno")<>"" and rsget("limitsold")<>"" Then
					vSoldOUT = (rsget("sellyn")<>"Y") or ((rsget("limityn") = "Y") and (clng(rsget("limitno"))-clng(rsget("limitsold"))<1))
				Else
					vSoldOUT = (rsget("sellyn")<>"Y")
				End If
				
				If (rsget("sellyn") = "S") Then
					vSoldOUT = (rsget("sellyn") = "S")
				End IF
			End IF
			rsget.close
		Else
			rsget.close
			dbget.close()
			Response.write "<script language='javascript'>alert('잘못된 경로입니다. 고객센터로 문의해 주세요.');document.location.href='/';</script>"
			Response.End
		End IF

		
		vQuery = "INSERT INTO [db_order].[dbo].[tbl_mobile_gift]("
		vQuery = vQuery & "gubun, userid, guestSessionID, userlevel, couponno, itemid, itemname, makerid, brandname, listimage, status, IsPay, refip"
		vQuery = vQuery & ") VALUES("
		vQuery = vQuery & "'gifticon', '" & vUserID & "', '" & vGuestSeKey & "', '" & vUserLevel & "', '" & vCouponNO & "', '" & vItemID & "', '" & vItemName & "', "
		vQuery = vQuery & "'" & vMakerID & "', '" & vBrandName & "', '" & vListImage & "', '" & vStatus & "', 'N', '" & Request.ServerVariables("REMOTE_ADDR") & "'"
		vQuery = vQuery & ")"
		dbget.execute vQuery
		
		vQuery1 = " SELECT SCOPE_IDENTITY() "
		rsget.Open vQuery1,dbget
		IF Not rsget.EOF THEN
			vIdx = rsget(0)
		END IF
		rsget.close
	Else
		'##################################### 실패 인경우 #####################################
		vResult		= getErrCode2Name(vStatus)
		
		If vStatus = "3115" OR vStatus = "3121" Then
			vQuery = "SELECT top 1 idx, itemid From [db_order].[dbo].[tbl_mobile_gift] WHERE IsPay = 'Y' AND couponno = '" & vCouponNO & "' AND gubun = 'gifticon' order by idx desc"
			rsget.Open vQuery,dbget
			IF Not rsget.EOF THEN
				vIdx = rsget("idx")
				vItemID	= rsget("itemid")
			END IF
			rsget.close
		Else
			vQuery = "INSERT INTO [db_order].[dbo].[tbl_mobile_gift]("
			vQuery = vQuery & "gubun, userid, guestSessionID, userlevel, couponno, status, IsPay, resultmessage, refip"
			vQuery = vQuery & ") VALUES("
			vQuery = vQuery & "'gifticon', '" & vUserID & "', '" & vGuestSeKey & "', '" & vUserLevel & "', '" & vCouponNO & "', '" & vStatus & "', 'N', '" & vResult & "', '" & Request.ServerVariables("REMOTE_ADDR") & "'"
			vQuery = vQuery & ")"
			dbget.execute vQuery
			
			vQuery1 = " SELECT SCOPE_IDENTITY() "
			rsget.Open vQuery1,dbget
			IF Not rsget.EOF THEN
				vIdx = rsget(0)
			END IF
			rsget.close
		End IF
	End If
	
	
	
	'##################################### 경우에 따른 이동 페이지 설정 #####################################
	If vStatus = "0000" Then
		If vIsPaperMoney = "o" Then		'####### 현금액상품권이면 무조건 기프트카드로~
			vActionURL = "get_giftcard.asp"
		Else
			If vSoldOUT = True Then		'####### 품절이면 무조건 예치금전환으로~
				vActionURL = "get_deposit.asp"
			Else
				'####### 옵션이 있는지 체크. 유무에 따라 페이지 이동 경로 다름.
				vQuery = "SELECT Count(*) From [db_item].[dbo].[tbl_item_option] Where itemid = '" & vItemID & "'"
				rsget.Open vQuery,dbget
				IF rsget(0) = "0" THEN
					vActionURL = M_SSLUrl & "/gift/gifticon/" & "userInfo.asp"
				Else
					vActionURL = "option_select.asp"
				END IF
				rsget.close
			End IF
		End IF
	Else
		vActionURL = "fail_result.asp"
	End IF
%>

<form name="frm" action="<%=vActionURL%>" method="post">
<input type="hidden" name="idx" value="<%=vIdx%>">
<input type="hidden" name="itemid" value="<%=vItemID%>">
<input type="hidden" name="soldout" value="<%=vSoldOUT%>">
<input type="hidden" name="ispapermoney" value="<%=vIsPaperMoney%>">
<form>
<script language="javascript">
document.frm.submit();
</script>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->