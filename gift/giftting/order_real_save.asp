<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->


<%
	Dim vQuery, vIdx, vResult, vItemOption, vItemID, vOptionName, vUserID, vSellCash, vBuyCash, vCouponno, vUserLevel, vRequireDetail, vMakerID, vMileage, vVatinclude
	Dim vItemName, vItemDiv, vMWDiv, vDeliveryType, vDeliverfixday, vOrgPrice, vIsSuccessNext, vDeliveryOptionCode
	Dim vDefaultFreebeasongLimit,vDefaultDeliverPay, vDiliItemBuycash
	
	vIdx 		= requestCheckVar(request("idx"),10)
	vItemID		= requestCheckVar(request("itemid"),10)
	vItemOption	= requestCheckVar(request("itemoption"),10)
	vUserID		= GetLoginUserID
	
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
	
	vQuery = "SELECT * From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND gubun = 'giftting' AND IsPay = 'N'"
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vCouponno		= rsget("couponno")
		vItemID			= rsget("itemid")
		vItemOption		= rsget("itemoption")
		vOptionName		= rsget("optionname")
		vUserLevel		= rsget("userlevel")
		vMakerID		= rsget("makerid")
		vRequireDetail	= CHKIIF(isNull(rsget("requiredetail"))=true,"",rsget("requiredetail"))
		
		rsget.close
	Else
		rsget.close
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	END IF
	
	
	Dim vTotSellcash, vRealSellcash, vDiliItemCost
	vQuery = "SELECT tot_sellcash, sellcash, dili_itemcost From [db_order].[dbo].[tbl_mobile_gift_item] Where itemid = '" & vItemID & "' AND gubun = 'giftting'"
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vTotSellcash	= rsget("tot_sellcash")
		vRealSellcash	= rsget("sellcash")
		vDiliItemCost	= rsget("dili_itemcost")
		
		rsget.close
	Else
		rsget.close
		Response.Write "<script language='javascript'>alert('상품이 존재하지 않습니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	END IF
	
	
	vQuery = "SELECT i.itemname, i.sellcash, i.buycash, i.mileage, i.vatinclude, i.itemdiv, i.mwdiv, i.deliverytype, i.deliverfixday, i.orgprice "
	vQuery = vQuery & " ,isNULL(c.defaultFreebeasongLimit,0) as defaultFreebeasongLimit"
	vQuery = vQuery & " ,isNULL(c.defaultDeliverPay,0) as defaultDeliverPay "
	vQuery = vQuery & " From [db_item].[dbo].[tbl_item] AS i "
	vQuery = vQuery & "     Left Join [db_user].[dbo].[tbl_user_c] AS c on i.makerid=c.userid "
	vQuery = vQuery & " Where i.itemid = '" & vItemID & "'"
	
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vItemName		= db2html(rsget("itemname"))
		'vSellCash 		= rsget("sellcash")
		vSellCash		= vRealSellcash
		vBuyCash		= rsget("buycash")
		vMileage		= rsget("mileage")
		vVatinclude		= rsget("vatinclude")
		vItemDiv		= rsget("itemdiv")
		vMWDiv			= rsget("mwdiv")
		vDeliveryType	= rsget("deliverytype")
		vDeliverfixday	= rsget("deliverfixday")
		vOrgPrice		= rsget("orgprice")
		vDefaultFreebeasongLimit 	= rsget("defaultFreebeasongLimit")
		vDefaultDeliverPay 			= rsget("defaultDeliverPay")
		vDiliItemBuycash = 0
		
		If vDeliveryType = "1" Then			'텐바이텐배송
			vDeliveryOptionCode = "1000"
		ElseIf vDeliveryType = "4" Then		'텐바이텐무료배송
			vDeliveryOptionCode = "1000"
		ElseIf vDeliveryType = "2" Then		'업체(무료)배송
			vDeliveryOptionCode = "2000"
		ElseIf vDeliveryType = "9" Then		'업체조건배송(개별 배송비부과)
			vDeliveryOptionCode = "9001"
			if (vSellCash<vDefaultFreebeasongLimit) then
    			vDiliItemBuycash=vDefaultDeliverPay
    		end if
		ElseIf vDeliveryType = "7" Then		'업체착불배송
			vDeliveryOptionCode = "0901"
		Else
			vDeliveryOptionCode = "1000"
		End IF
	END IF
	rsget.close
	
	'################################################################# [Real 주문 저장] #################################################################
    Dim rndjumunno, sqlStr, iid, iorderserial, ErrStr, vBuyName, vBuyPhone, vBuyHP, vBuyEmail, vReqName, vReqZip, vAddr1, vAddr2, vReqPhone, vReqHP, vComment
    vBuyName 	= LeftB((request.Form("buyname")),30)
    vBuyPhone 	= request.Form("buyphone1") + "-" + request.Form("buyphone2") + "-" + request.Form("buyphone3")
    vBuyHP 		= request.Form("buyhp1") + "-" + request.Form("buyhp2") + "-" + request.Form("buyhp3")
    vBuyEmail 	= LeftB((request.Form("buyemail")),100)
    vReqName 	= LeftB((request.Form("reqname")),30)
    vReqZip 	= request.Form("txZip1") + "-" + request.Form("txZip2")
    vAddr1 		= LeftB((request.Form("txAddr1")),120)
    vAddr2 		= LeftB((request.Form("txAddr2")),255)
    vReqPhone 	= request.Form("reqphone1") + "-" + request.Form("reqphone2") + "-" + request.Form("reqphone3")
    vReqHP 		= request.Form("reqhp1") + "-" + request.Form("reqhp2") + "-" + request.Form("reqhp3")
    vComment 	= LeftB((request.Form("comment")),255)
    
    Randomize
	rndjumunno = CLng(Rnd * 100000) + 1
	rndjumunno = CStr(rndjumunno)
	
	dbget.BeginTrans
	On Error Resume Next


	'################################################################# [master 저장] #################################################################
	sqlStr = "select * from [db_order].[dbo].tbl_order_master where 1=0"
	rsget.Open sqlStr,dbget,1,3
	rsget.AddNew
	    rsget("orderserial")    = rndjumunno
	    rsget("jumundiv")       = "1"
	    rsget("userid")         = CStr(vUserID)
	    rsget("ipkumdiv")       = "0"
		rsget("accountdiv")     = "550"
		rsget("subtotalprice")  = CLNG(vTotSellcash)
		rsget("discountrate")   = "1"
		rsget("sitename")       = "10x10"
		rsget("cancelyn")       = "N"
		
		rsget("accountname")    = vBuyName
		rsget("accountno")      = ""
		rsget("buyname")        = vBuyName
		rsget("buyphone")       = vBuyPhone
		rsget("buyhp")          = vBuyHP
		rsget("buyemail")       = vBuyEmail
		rsget("reqname")        = vReqName
		rsget("reqzipcode")     = vReqZip
		rsget("reqzipaddr")     = vAddr1
		rsget("reqaddress")     = vAddr2
		rsget("reqphone")       = vReqPhone
		rsget("reqhp")          = vReqHP
		rsget("comment")        = vComment
		
		rsget("miletotalprice") = "0"
		rsget("tencardspend")   = "0"
		rsget("allatdiscountprice") = "0"
		rsget("sumPaymentEtc") = CLng("0")
		
		rsget("paygatetid") = vCouponno
		rsget("rdsite") = "giftting_mob"
		rsget("userlevel") = vUserLevel

		rsget("rduserid")       = ""
        rsget("referip")        = Left(request.ServerVariables("REMOTE_ADDR"),32)
		
		rsget.update
		iid = rsget("idx")
	rsget.close
	
	IF (Err) then
	    ErrStr = "[Err-ORD-001.]" & Err.Description & rndjumunno
	    dbget.RollBackTrans
	    On Error Goto 0
	end if
	
	
	'' 실 주문번호 Setting
	if (Not IsNull(iid)) and (iid<>"") then
		iorderserial = Mid(replace(CStr(DateSerial(Year(now),month(now),Day(now))),"-",""),3,256)
		iorderserial = iorderserial & Format00(5,Right(CStr(iid),5))

		sqlStr = " update [db_order].[dbo].tbl_order_master" + vbCrlf
		sqlStr = sqlStr + " set orderserial='" + iorderserial + "'" + vbCrlf
		sqlStr = sqlStr + " where idx = " + CStr(iid) + vbCrlf

		dbget.Execute sqlStr
		
		IF (Err) then
		    ErrStr = "[Err-ORD-002]" & Err.Description
		    dbget.RollBackTrans
		    On Error Goto 0
		end if


		'################################################################# [master 저장] #################################################################
		
		
		'################################################################# [detail 배송비 저장] #################################################################

		'' 주문 상세 내역 저장.
		'' itemcost,  reducedprice, orgitemcost, itemcostCouponNotApplied
		
		'' 일반 배송비(텐바이텐, 업체 무료배송 ) : 업체 개별배송만 있는경우 체크
		'' 배송비 상품 쿠폰 있는경우 쿠폰 번호.. <!-- //-->
    	sqlStr = "insert into [db_order].[dbo].tbl_order_detail"
    	sqlStr = sqlStr & " (masteridx, orderserial, itemid, itemoption, makerid, itemno, itemname, itemoptionname,"
    	sqlStr = sqlStr & " itemcost, buycash, mileage, reducedprice, orgitemcost, itemcostCouponNotApplied, buycashCouponNotApplied, itemcouponidx, bonuscouponidx)" + vbCrlf
    	sqlStr = sqlStr & " values(" + CStr(iid)
    	sqlStr = sqlStr & " ,'" & iorderserial & "'"
    	sqlStr = sqlStr & " , 0"								'''itemid
    	sqlStr = sqlStr & " , '" & vDeliveryOptionCode & "'"                           '''배송코드
    	sqlStr = sqlStr & " , '" & CHKIIF(vDeliveryType="9",vMakerID,"") & "'"
    	sqlStr = sqlStr & " , 1"
    	sqlStr = sqlStr & " , '배송비'"                                  ''' 배송비 (명)
    	sqlStr = sqlStr & " , '" & CHKIIF(vDeliveryType="9","업체개별","") & "'"
    	sqlStr = sqlStr & " , " & CStr(vDiliItemCost)  ''' 상품쿠폰 적용금액(itemcost) : 기존
    	sqlStr = sqlStr & " , " & CStr(vDiliItemBuycash)                                ''' 매입가
    	sqlStr = sqlStr & " , 0"
    	sqlStr = sqlStr & " , " & CStr(vDiliItemCost)
    	sqlStr = sqlStr & " , " & CStr(vDiliItemCost)               ''' 소비자가(orgitemcost)
    	sqlStr = sqlStr & " , " & CStr(vDiliItemCost) ''' 판매가 = 상품쿠폰 적용안한금액(itemcostCouponNotApplied)
    	sqlStr = sqlStr & " , " & CStr(vDiliItemBuycash)                                ''' 매입가 (buycashCouponNotApplied)
    	sqlStr = sqlStr & " , NULL"					'''itemcouponidx
    	sqlStr = sqlStr & " , NULL"					'''bonuscouponidx
    	sqlStr = sqlStr & ")"

    	dbget.Execute sqlStr
    	
    	IF (Err) then
		    ErrStr = "[Err-ORD-003]" & Err.Description
		    dbget.RollBackTrans
		    On Error Goto 0
		end if

		'################################################################# [detail 배송비 저장] #################################################################
		
		
		'################################################################# [detail 상품 저장] #################################################################

    	'' 상품 저장.
    	dim ubeasongStr, issailitem, requiredetail, itemcouponidx, sellcash, buycash, bonuscouponidx
        
        ubeasongStr = "N"
		if ((vDeliveryType="2") or (vDeliveryType="5") or (vDeliveryType="7") or (vDeliveryType="9")) then
			ubeasongStr = "Y"
		end if


		''우수회원세일, 플러스 세일 구분위해 변경.
		issailitem = "N"
		if (vOrgPrice>vSellCash) then  
			issailitem = "Y"
		end if
						
		itemcouponidx = "0"
		sellcash	= vSellCash
		buycash		= vBuyCash
		
		vMileage	= CLng(vMileage)
		
		''감성마니아 3배마일리지
		if CStr(vUserLevel) = "9" then
			vMileage   = vMileage * 3
		end if

		'' VIp GOLD & VVIP 1.3
		if CStr(vUserLevel) = "4" or CStr(vUserLevel) = "6" then
			vMileage   = CLng(vMileage * 1.3)
		end if

		If vItemOption = "" Then
			vItemOption = "0000"
		End IF

		sqlStr = "insert into [db_order].[dbo].tbl_order_detail"
    	sqlStr = sqlStr + "(masteridx,orderserial,itemid,itemoption,makerid," + vbCrlf
		sqlStr = sqlStr + "itemno,itemcost,buycash,itemvat,mileage,reducedprice, " + vbCrlf
		sqlStr = sqlStr + "itemname,itemoptionname,vatinclude,isupchebeasong," + vbCrlf
		sqlStr = sqlStr + "issailitem,oitemdiv,omwdiv,odlvType,requiredetail,itemcouponidx,bonuscouponidx," + vbCrlf
		sqlStr = sqlStr + "orgitemcost, itemcostCouponNotApplied, buycashCouponNotApplied, odlvfixday, plusSaleDiscount, specialshopDiscount)" + vbCrlf
		sqlStr = sqlStr + " values (" + Cstr(iid) + "," + vbCrlf
		sqlStr = sqlStr + " '" + iorderserial + "'," + vbCrlf
		sqlStr = sqlStr + " " + CStr(vItemID) + "," + vbCrlf
		sqlStr = sqlStr + " '" + CStr(vItemOption) + "'," + vbCrlf
		sqlStr = sqlStr + " '" + CStr(vMakerID) + "'," + vbCrlf
		sqlStr = sqlStr + " " + CStr("1") + "," + vbCrlf
		sqlStr = sqlStr + " " + CStr(sellcash) + "," + vbCrlf		'' itemcost
		sqlStr = sqlStr + " " + CStr(buycash) + "," + vbCrlf 		'' buycash
		sqlStr = sqlStr + " " + ChkIIF(vVatinclude = "Y",CStr(sellcash-CLng(sellcash*10/11)),CStr(0)) + "," + vbCrlf
		sqlStr = sqlStr + " " + CStr(vMileage) + "," + vbCrlf
		sqlStr = sqlStr + " " + CStr(sellcash) + "," + vbCrlf		''reducedprice ------> GetDiscountAssignedItemCost ?????
		sqlStr = sqlStr + " '" + Left(html2db(vItemName),64) + "'," + vbCrlf
		sqlStr = sqlStr + " '" + Left(html2db(vOptionName),64) + "'," + vbCrlf
		sqlStr = sqlStr + " '" + CStr(vVatinclude) + "'," + vbCrlf
		sqlStr = sqlStr + " '" + ubeasongStr + "'," + vbCrlf
		sqlStr = sqlStr + " '" + issailitem + "'," + vbCrlf						''issailitem ''우수회원세일, 플러스 세일 구분위해 변경. issailitem = "N"
		sqlStr = sqlStr + " '" + CStr(vItemDiv) + "'," + vbCrlf
		sqlStr = sqlStr + " '" + CStr(vMWDiv) + "'," + vbCrlf
		sqlStr = sqlStr + " '" + CStr(vDeliveryType) + "'," + vbCrlf
		sqlStr = sqlStr + " " + ChkIIF(vRequireDetail = "","NULL","'" & vRequireDetail & "'") + "," + vbCrlf
		sqlStr = sqlStr + " NULL," + vbCrlf
		sqlStr = sqlStr + " NULL," + vbCrlf
		sqlStr = sqlStr + " " + CStr(vOrgPrice) +  "," + vbCrlf		''orgitemcost
		sqlStr = sqlStr + " " + CStr(sellcash) +  "," + vbCrlf		''sellcash
		sqlStr = sqlStr + " " + CStr(buycash) +  "," + vbCrlf		''buycash
		sqlStr = sqlStr + " '" + vDeliverfixday + "'," +  vbCrlf
		sqlStr = sqlStr + " " + CStr("0") +  "," + vbCrlf		''plusSaleDiscount ------> getPlusSaleDiscount ?????
		sqlStr = sqlStr + " " + CStr("0") + "" + vbCrlf		''specialshopDiscount ------> getSpecialshopDiscount ?????
		sqlStr = sqlStr + " )"
		
		dbget.Execute sqlStr
    end if
    
    IF (Err) then
	    ErrStr = "[Err-ORD-004.1]" & Err.Description
	    dbget.RollBackTrans
	    On Error Goto 0
	ELSE
	    dbget.CommitTrans
	end if

	'################################################################# [detail 상품 저장] #################################################################
	
	'################################################################# [XML 통신] #################################################################
	Dim xmlHttp, postdata, strData, vntPostedData, vIsSuccess, vURL
	vIsSuccess = "x"
	vURL = "http://admin.giftting.co.kr/outPinCheck.do"
	'vURL = "http://tcms.giftting.co.kr/outPinCheck.do"
	
	Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")

	postdata = "mdcode=10x10&pin_status=C&pin_no=" & vCouponNO & "&trd_dt=" & Replace(date(),"-","") & "&trd_tm=" & TwoNumber(hour(now))&TwoNumber(minute(now))&TwoNumber(second(now)) & "" '보낼 데이터 <!-- //-->

	xmlHttp.open "POST",vURL, False
    xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlHttp.Send postdata	'post data send

	IF Err.Number <> 0 then
		Response.write "<script language='javascript'>alert('기프팅에 조회 중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If

	vntPostedData = BinaryToText(xmlHttp.responseBody, "euc-kr")
	
	strData = vntPostedData

	Set xmlHttp = nothing
	
	If CStr(Right(Split(strData,"|")(0),2)) = "00" Then		'### Split(strData,"|")(0) 맨 앞에 빈값도 아닌 빈값이 같이 나와서 Right로 2자 자름.
		vIsSuccess = "o"
	Else
		vIsSuccess = "x"
	End If
	'################################################################# [XML 통신] #################################################################
	
	
	vIsSuccessNext = "x"
	If vIsSuccess = "o" Then
'		dbget.BeginTrans
		On Error Resume Next

		'################################################################# [master 테이블 UPDATE] #################################################################

		''' 주문 마스타 서머리 재저장
		sqlStr = " update [db_order].[dbo].tbl_order_master" + vbCrlf
		sqlStr = sqlStr + " set totalsum=" + Cstr(vTotSellcash) + "" + vbCrlf		''getTotalsum(packtype) -------> ??????
		sqlStr = sqlStr + " , subtotalpriceCouponNotApplied=" + Cstr(vTotSellcash) + "" + vbCrlf '''2011-04 추가		getCouponNotAppliedSum -------> ???????
		sqlStr = sqlStr + " ,ipkumdiv='4'" + vbCrlf
		sqlStr = sqlStr + " ,ipkumdate=getdate()" + vbCrlf
		sqlStr = sqlStr + " ,totalvat=" + Cstr(getTotalVat()) + "" + vbCrlf					'' getTotalVat() ----------> ?????????
		sqlStr = sqlStr + " ,totalmileage=" + Cstr(vMileage) + "" + vbCrlf
		sqlStr = sqlStr + " where orderserial='" + CStr(iorderserial) + "'" + vbCrlf
''response.write sqlStr
		dbget.Execute(sqlStr)
        
        IF (Err) then
		    ErrStr = "[Err-ORD-012]" & Err.Description
		    'dbget.RollBackTrans
		    On Error Goto 0
		end if

		''########## 주문마일리지 적립 ##########
		If vUserID <> "" Then
		''## 주문 마일리지 업데이트 ##''
			sqlStr = "update [db_user].[dbo].tbl_user_current_mileage" + VbCrlf
			sqlStr = sqlStr + " set jumunmileage=jumunmileage+" + CStr(vMileage) + VbCrlf
			sqlStr = sqlStr + " ,michulmile=michulmile+" + CStr(vMileage) + VbCrlf  ''2015/03/06 추가
			sqlStr = sqlStr + " where userid='" + CStr(vUserID) + "'"

			dbget.Execute(sqlStr)
			
			IF (Err) then
    		    ErrStr = "[Err-ORD-014]" & Err.Description
    		    'dbget.RollBackTrans
    		    On Error Goto 0
    		end if
		end if
        
        '''2011-04 각 지불 수단별 결제 금액 저장 // 차후 작업..
        sqlStr = " insert into db_order.dbo.tbl_order_PaymentEtc"
        sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate,PayEtcResult)"
        sqlStr = sqlStr + " values('"&iorderserial&"'"
        sqlStr = sqlStr + " ,'550'"		''' iOrderParams.Faccountdiv
        sqlStr = sqlStr + " ,"&vTotSellcash&""		''''iOrderParams.FSubtotalPrice
        sqlStr = sqlStr + " ,"&vTotSellcash&""		''' iOrderParams.FSubtotalPrice   ''''''sqlStr = sqlStr + " ,0"  ''무통장도 초기 같은금액입력
        sqlStr = sqlStr + " ,''"
        sqlStr = sqlStr + " ,''"
        sqlStr = sqlStr + " ,NULL"		''' iOrderParams.FPayEtcResult
        sqlStr = sqlStr + " )"
        
        dbget.Execute sqlStr
        
        IF (Err) then
		    ErrStr = "[Err-ORD-014.0]" & Err.Description
		    'dbget.RollBackTrans
		    On Error Goto 0
		ELSE
			vIsSuccessNext = "o"
'		    dbget.CommitTrans
		end if

		On Error resume Next
		dim osms, helpmail
		helpmail = "텐바이텐<customer@10x10.co.kr>"
		 
	    IF vIsSuccessNext = "o" THEN
	        call sendmailorder(iorderserial,helpmail)
	        
	        set osms = new CSMSClass
			osms.SendJumunOkMsg vBuyHP, iorderserial
		    set osms = Nothing
		    
		    '####### 재고 빼기
			sqlStr = "exec [db_summary].[dbo].sp_Ten_RealtimeStock_regOrder '" & iorderserial & "'"
			dbget.Execute(sqlStr)
	    end if
		on Error Goto 0

		vQuery = "UPDATE [db_order].[dbo].[tbl_mobile_gift] SET IsPay = 'Y', orderserial = '" & iorderserial & "' WHERE idx = '" & vIdx & "'"
		dbget.Execute vQuery

		'################################################################# [master 테이블 UPDATE] #################################################################
	Else
		'################################################################# [XML 통신 결과 실패] #################################################################
		vQuery = "UPDATE [db_order].[dbo].[tbl_mobile_gift] SET resultmessage = '" & strData & "' WHERE idx = '" & vIdx & "'" & vbCrLf
		vQuery = vQuery & " UPDATE [db_order].[dbo].[tbl_order_master] SET ipkumdiv = '1', resultmsg = '" & strData & "' WHERE orderserial = '" & iorderserial & "'"
		dbget.Execute vQuery
		dbget.close()
		Response.write "<script language='javascript'>alert('기프팅에 조회 후 정상적인 쿠폰이 아닙니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
		Response.End
		'################################################################# [XML 통신 결과 실패] #################################################################
	End IF
%>


<form name="frm" action="<%=wwwUrl%>/gift/giftting/success_result.asp" method="post">
<input type="hidden" name="idx" value="<%=vIdx%>">
<input type="hidden" name="orderserial" value="<%=iorderserial%>">
<input type="hidden" name="itemid" value="<%=vItemID%>">
<form>
<script language="javascript">
frm.submit();
</script>

<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->