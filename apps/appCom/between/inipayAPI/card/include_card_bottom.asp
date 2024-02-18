
dim INIpay, PInst
dim Tid, ResultCode, ResultMsg, PayMethod       
dim Price1, Price2, AuthCode, CardQuota, QuotaInterest   
dim CardCode, AuthCertain, PGAuthDate, PGAuthTime, OCBSaveAuthCode, OCBUseAuthCode, OCBAuthDate, CardIssuerCode, PrtcCode
dim AckResult
dim DirectBankCode, Rcash_rslt, ResultCashNoAppl




dim i_Resultmsg
i_Resultmsg = replace(ResultMsg,"|","_")

iorderParams.Fresultmsg  = i_Resultmsg
iorderParams.Fauthcode = AuthCode
iorderParams.Fpaygatetid = Tid
iorderParams.IsSuccess = (ResultCode = "00")

''2011-04-27 추가(부분취소시 필요항목)
IF (Tn_paymethod="20") Then     
    iorderParams.FPayEtcResult = LEFT(DirectBankCode,16)
ELSe
    iorderParams.FPayEtcResult = LEFT(CardCode&"|"&CardIssuerCode&"|"&CardQuota&"|"&PrtcCode,16)
END IF

Call oshoppingbag.SaveOrderResultDB(iorderParams, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script type='text/javascript'>alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.: \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"
    vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요. 오류 -" & replace(iErrStr,"'",""))
	response.redirect fnGetUserInfo("FAILURL")
    response.end
end if

if (Err) then
    iErrStr = replace(err.Description,"'","")
    
	response.write "<script type='text/javascript'>javascript:alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.: \n\n" & iErrStr & "')</script>"
	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요." & iErrStr)
	response.redirect fnGetUserInfo("FAILURL")
	'response.write "<script type='text/javascript'>javascript:history.back();</script>"
	response.end
end if



On Error resume Next   
dim osms, helpmail
helpmail = oshoppingbag.GetHelpMailURL
 
    IF (iorderParams.IsSuccess) THEN
        call sendmailorder(iorderserial,helpmail)
        
        set osms = new CSMSClass
		osms.SendJumunOkMsg iorderParams.Fbuyhp, iorderserial
	    set osms = Nothing
	
    end if
on Error Goto 0