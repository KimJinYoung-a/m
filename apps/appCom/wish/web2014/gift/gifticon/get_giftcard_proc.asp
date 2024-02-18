<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/giftiConCls.asp"-->

<%
	Dim vQuery, vQuery1, vUserID, vIdx, vResult, vItemOption, vItemID, vOptionName, vRequireDetail, vCouponNo, vSellCash, vNowDate, v60LaterDate, vMasterIdx
	vIdx 			= requestCheckVar(request("idx"),10)
	vUserID			= GetLoginUserID

	If vUserID = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	If vIdx = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vIdx) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	
	
	vQuery = "SELECT * From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND IsPAy = 'N'"
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vCouponNo 	= rsget("couponno")
		vItemID		= rsget("itemid")
		rsget.close
	Else
		rsget.close
		dbget.close()
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		Response.End
	End IF
	
	vQuery = "SELECT sellcash From [db_item].[dbo].[tbl_item] Where itemid = '" & vItemID & "'"
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vSellCash = rsget("sellcash")
	End IF
	rsget.close


	'################################################################# [System 으로 기프트카드 주문] #################################################################
		Dim tmpOrdSn, tmpMstCd, rndjumunno, strSql, ordIdx, rstCd
		tmpOrdSn="": tmpMstCd=""
	    '임시주문번호 생성
	    Randomize
		rndjumunno = CLng(Rnd * 100000) + 1
		rndjumunno = CStr(rndjumunno)
		'### 옵션코드는 0000으로 함.


		'### ipkumdiv 를 1로 해둠. xml통신 후 8로 업데이트.
		'@주문건 저장 (GiftCardGbn:0, 추후 1으로 변경;POS수정후)
		strSql = "Insert Into [db_order].[dbo].tbl_giftcard_order "
		strSql = strSql & " (giftOrderSerial,cardItemid,cardOption,masterCardCode,userid,buyname,totalsum,jumundiv,accountdiv,ipkumdiv,ipkumdate "
		strSql = strSql & " ,discountrate,subtotalprice,miletotalprice,tencardspend,referip,userlevel,sumPaymentEtc,designId,resendCnt,GiftCardGbn,notRegSpendSum) "
		strSql = strSql & " Values "
		strSql = strSql & " ('" & rndjumunno & "','101','0000','','system','텐바이텐'," & vSellCash
		strSql = strSql & " ,'5','560','1',getdate(),1," & vSellCash & ",0,0,'" & Left(request.ServerVariables("REMOTE_ADDR"),32) & "'"
		strSql = strSql & " ,7,0,'101',0,0,0)"
		dbget.Execute strSql

		'@IDX접수
		strSql = "Select IDENT_CURRENT('[db_order].[dbo].tbl_giftcard_order') as maxitemid "
		rsget.Open strSql,dbget,1
			ordIdx = rsget("maxitemid")
		rsget.close

		'## 실 주문번호/카드코드 Setting
		if (Not IsNull(ordIdx)) and (ordIdx<>"") then
			dim sh: sh=0
			tmpOrdSn = "G" & Mid(replace(CStr(DateSerial(Year(now),month(now),Day(now))),"-",""),4,256)
			tmpOrdSn = tmpOrdSn & Format00(5,Right(CStr(ordIdx),5))
			tmpMstCd = getMasterCode(ordIdx,16,sh)

			strSql = " update [db_order].[dbo].tbl_giftcard_order" + vbCrlf
			strSql = strSql + " set giftOrderSerial='" + tmpOrdSn + "'" + vbCrlf
			strSql = strSql + " ,masterCardCode='" + tmpMstCd + "'" + vbCrlf
			strSql = strSql + " where idx=" + CStr(ordIdx) + vbCrlf

			dbget.Execute strSql

			'# 기프트카드 인증번호 발급 로그 저장
			Call putGiftCardMasterCDLog(tmpOrdSn,tmpMstCd,sh-1)
	    end if

	'################################################################# [System 으로 기프트카드 주문] #################################################################


	'<!-- //-->
	'################################################################# [소켓 통신] #################################################################
		Dim oGicon, strData, vIsSuccess, vStatus
		vIsSuccess = "x"

		Set oGicon = New CGiftiCon
		strData = oGicon.reqCouponApproval(vCouponNO,"100100",vSellCash) ''쿠폰번호, 추적번호, 상품 교환가
	    
		If (strData) Then
			vStatus = Trim(oGicon.FConResult.getResultCode)
		Else
			Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
			dbget.close()
			Response.End
		End If
		Set oGicon = Nothing
	
		If CStr(vStatus) = "0000" Then		'### 성공
			vIsSuccess = "o"
		Else
			vIsSuccess = "x"
		End If
	'################################################################# [소켓 통신] #################################################################
	
	If vIsSuccess = "o" Then
		'################################################################# [기프트 리스트 저장] #################################################################
		'// 등록처리
		vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order] SET ipkumdiv = '8' WHERE giftOrderSerial = '" & tmpOrdSn & "' "
		dbget.execute vQuery
		
		Call procGiftCardReg(tmpMstCd)
		
		vQuery = "UPDATE [db_order].[dbo].[tbl_mobile_gift] SET IsPay = 'Y', masterCardCode = '" & tmpMstCd & "', userid = '" & vUserID & "', userlevel = '" & GetLoginUserLevel() & "' WHERE idx = '" & vIdx & "'"
		dbget.execute vQuery
		'################################################################# [기프트 리스트 저장] #################################################################
	Else
		Response.write "<script language='javascript'>alert('기프팅에 조회 중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
%>
<form name="frm" action="success_result.asp" method="post">
<input type="hidden" name="orderserial" value="0">
<input type="hidden" name="idx" value="<%=vIdx%>">
<input type="hidden" name="gubun" value="g">
<form>
<script language="javascript">
frm.submit();
</script>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->