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
<!-- #INCLUDE Virtual="/gift/gifticon/check_auto.asp" -->
<%
	Dim vURL, vCouponNO, vStatus, vItemID, vItemName, vResult, vQuery, vQuery1, vUserID, vGuestSeKey, vUserLevel, vIdx, vActionURL, vMakerID
	Dim vBrandName, vListImage, vSoldOUT, vArrPaperMoney, vIsPaperMoney
	Dim xmlHttp, postdata, strData, vntPostedData

	vURL 			= "http://admin.giftting.co.kr/outPinCheck.do"
	'vURL 			= "http://tcms.giftting.co.kr/outPinCheck.do"
	vCouponNO 		= requestCheckVar(request("pin_no"),20)
	vUserID			= GetLoginUserID
	vGuestSeKey		= GetGuestSessionKey
	vUserLevel		= GetLoginUserLevel
	vSoldOUT 		= False


	If vCouponNO = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다..');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vCouponNO) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다...');docum.ent.location.href = '/';</script>"
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



	'################################### XML 통신 ###################################
	Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")

	postdata = "mdcode=10x10&pin_status=A&pin_no=" & vCouponNO & "" '보낼 데이터 <!-- //-->

	xmlHttp.open "POST",vURL, False
    xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlHttp.Send postdata	'post data send

	IF Err.Number <> 0 then
		Response.write "<script language='javascript'>alert('기프팅에 조회 중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href='/';</script>"
		dbget.close()
		Response.End
	End If

	vntPostedData = BinaryToText(xmlHttp.responseBody, "euc-kr")

	strData = vntPostedData

	Set xmlHttp = nothing
	'################################### XML 통신 ###################################



	If CStr(Right(Split(strData,"|")(0),2)) = "00" Then		'### Split(strData,"|")(0) 맨 앞에 빈값도 아닌 빈값이 같이 나와서 Right로 2자 자름.
		'##################################### 00 성공 인경우 #####################################
		vStatus			= CStr(Right(Split(strData,"|")(0),2))
		vItemID			= Trim(Split(strData,"|")(1))

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
		vQuery = vQuery & "'giftting', '" & vUserID & "', '" & vGuestSeKey & "', '" & vUserLevel & "', '" & vCouponNO & "', '" & vItemID & "', '" & vItemName & "', "
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
		vStatus		= CStr(Right(Split(strData,"|")(0),2))
		vResult		= Split(strData,"|")(1)

		If vStatus = "10" Then
			vQuery = "SELECT idx, itemid From [db_order].[dbo].[tbl_mobile_gift] WHERE IsPay = 'Y' AND couponno = '" & vCouponNO & "' AND gubun = 'giftting'"
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
			vQuery = vQuery & "'giftting', '" & vUserID & "', '" & vGuestSeKey & "', '" & vUserLevel & "', '" & vCouponNO & "', '" & vStatus & "', 'N', '" & vResult & "', '" & Request.ServerVariables("REMOTE_ADDR") & "'"
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
	If vStatus = "00" Then
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
					vActionURL = testM_SSLUrl & "/gift/giftting/" & "userInfo.asp"
				Else
					vActionURL = "option_select.asp"
				END IF
				rsget.close
			End IF
		End IF
	Else
	    'response.write strData
	    'response.end
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