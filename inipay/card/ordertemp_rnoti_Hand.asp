<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

Session.Codepage = 949
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->

<%

'' noti 가 실패할경우  이곳에서 강제로 처리하자.

'**********************************************************************************
' 처리 흐름
'1) 결과 결과 수신 => 2) 상점 DB 처리 => 3) DB 처리 성공시 "OK 응답" 실패시 "FAIL" 응답
'**********************************************************************************
Dim vQuery
Dim vIdx : vIdx = 7648832  ''
  
''''===========================================================================================================
    
    ''장바구니 userlevel 값이 getLoginUserLevel로 되어 있음.
    Dim iuserlevel, iPrice
    vQuery = "select userlevel,price from [db_order].[dbo].[tbl_order_temp] where temp_idx = '" & vIdx & "'"
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    IF Not rsget.EOF THEN
    	iuserlevel			= rsget("userlevel")
    	iPrice          = rsget("price")
    END IF
    rsget.close
    
    ''2018/05/03 결제금액 검증
    ' if (Trim(CStr(P_AMT))<>Trim(CStr(iPrice))) then
    '     Response.Write("FAIL")
    '     vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','결제금액 검증 오류(Mo_IniNoti) :" + vIdx +":"+CStr(P_AMT)+":"+CStr(iPrice)+ "'"
    ' 	dbget.Execute vQuery
    '     dbget.close()
    ' 	response.end
    ' end if
    
    response.Cookies("uinfo").domain = "10x10.co.kr"
    response.cookies("uinfo")("muserlevel") = iuserlevel
    session("ssnuserlevel") = iuserlevel
    
    Dim retChkOK, oshoppingbag, iErrStr, ireserveParam 
    iErrStr = ""
    G_TempBabuni_SoldOut_Check = False  '' Async로 날라올경우 품절체크 안함.
    retChkOK = fnCheckOrderTemp(vIdx, oshoppingbag,iErrStr, ireserveParam, "")
     
    if NOT(retChkOK) then
        Response.Write("FAIL")
        
        'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','Order Check1 err(Payed Mo_IniNoti) :" + CStr(vIdx) +":"+ replace(iErrStr,"'","") + "'"
    	'dbget.Execute vQuery
        dbget.close()
        response.end
    end if
    
    if (oshoppingbag is Nothing) then
        Response.Write("FAIL")
        
        'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','Order Check2 err(Payed Mo_IniNoti) :" + CStr(vIdx) +":"+ replace(iErrStr,"'","") + "'"
    	'dbget.Execute vQuery
        dbget.close()
        response.end
    end if
    
    ''201712 임시장바구니 변경.
    dim iorderserial
    iErrStr = ""
    iorderserial = oshoppingbag.SaveOrderDefaultDB_TmpBaguni(vIdx, iErrStr)
    
    if (iErrStr<>"") then
        Response.Write("FAIL")
    
    	'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','Order Check3 err(Payed Mo_IniNoti) :" + CStr(vIdx) +":"+ replace(iErrStr,"'","") + "'"
    	'dbget.Execute vQuery
        dbget.close()
    	response.end
    end if



    Dim vResult, vIsSuccess, iPaymethod
    iPaymethod =""
    iErrStr = ""
    Call oshoppingbag.SaveOrderResultDB_TmpBaguni(vIdx, iPaymethod, iErrStr, vResult, vIsSuccess)
    
    if (iErrStr<>"") then
        Response.Write("FAIL")
        
        'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030',''Order Saved err(Payed Mo_IniNoti2) :" + CStr(vIdx) +":"+ replace(iErrStr,"'","") + "'"
    	'dbget.Execute vQuery
    	dbget.close()
        response.end
    end if
    
    ' On Error resume Next
    ' dim osms, helpmail
    ' helpmail = oshoppingbag.GetHelpMailURL
    
    ' IF (vIsSuccess) THEN
    '     call sendmailorder(iorderserial,helpmail)
    
    '     set osms = new CSMSClass
    ' 	osms.SendJumunOkMsg ireserveParam.FBuyhp, iorderserial
    '     set osms = Nothing
    
    ' end if
    ' on Error Goto 0
    

    Response.Write("OK") '절대로 지우지 마세요
    
    session("ssnuserlevel") = ""
    response.Cookies("uinfo").domain = "10x10.co.kr"
	response.Cookies("uinfo")("muserlevel") = ""
    response.Cookies("uinfo").Expires = Date - 1

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->