<%@  codepage="65001" language="VBScript" %>
<% option explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

response.Charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/class/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<!-- #include virtual="/lib/util/DcCyberAcctUtil.asp"-->
<%
Const CFINISH_SYSTEM = "system"

''데이콤 휴대폰 실취소
function CanCelMobileDacom(ipaygatetid,irefundrequire,irdSite,byREF iretval,byREF iResultCode,byREF iResultMsg,byREF iCancelDate,byREF iCancelTime)
    Dim CST_PLATFORM, CST_MID, LGD_MID, LGD_TID,Tradeid, LGD_CANCELREASON, LGD_CANCELREQUESTER, LGD_CANCELREQUESTERIP
    Dim configPath, xpay

    IF (application("Svr_Info") = "Dev") THEN                   ' LG유플러스 결제서비스 선택(test:테스트, service:서비스)
		CST_PLATFORM = "test"
	Else
		CST_PLATFORM = "service"
	End If


    CST_MID              = "tenbyten02"                         ' LG유플러스으로 부터 발급받으신 상점아이디를 입력하세요. //모바일, 서비스 동일.
                                                                ' 테스트 아이디는 't'를 제외하고 입력하세요.
    if CST_PLATFORM = "test" then                               ' 상점아이디(자동생성)
        LGD_MID = "t" & CST_MID
    else
        LGD_MID = CST_MID
    end if

    Tradeid     = Split(ipaygatetid,"|")(0)
	LGD_TID     = Split(ipaygatetid,"|")(1)                     ' LG유플러스으로 부터 내려받은 거래번호(LGD_TID) : 24 byte

    LGD_CANCELREASON        = "고객요청"                        ' 취소사유
    LGD_CANCELREQUESTER     = "고객"                            ' 취소요청자
    LGD_CANCELREQUESTERIP   = Request.ServerVariables("REMOTE_ADDR")     ' 취소요청IP


    configPath           = "C:/lgdacom" ''"C:/lgdacom/conf/"&CST_MID         				' 환경설정파일 통합.
    Set xpay = CreateObject("XPayClientCOM.XPayClient")
    xpay.Init configPath, CST_PLATFORM
    xpay.Init_TX(LGD_MID)

    xpay.Set "LGD_TXNAME", "Cancel"
    xpay.Set "LGD_TID", LGD_TID
    xpay.Set "LGD_CANCELREASON", LGD_CANCELREASON
    xpay.Set "LGD_CANCELREQUESTER", LGD_CANCELREQUESTER
    xpay.Set "LGD_CANCELREQUESTERIP", LGD_CANCELREQUESTERIP

    '/*
    ' * 1. 결제취소 요청 결과처리
    ' *
    ' * 취소결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
	' *
	' * [[[중요]]] 고객사에서 정상취소 처리해야할 응답코드
	' * 1. 신용카드 : 0000, AV11
	' * 2. 계좌이체 : 0000, RF00, RF10, RF09, RF15, RF19, RF23, RF25 (환불진행중 응답-> 환불결과코드.xls 참고)
	' * 3. 나머지 결제수단의 경우 0000(성공) 만 취소성공 처리
	' *
    ' */

    if xpay.TX() then
        '1)결제취소결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
'Response.Write("결제취소 요청이 완료되었습니다. <br>")
'Response.Write("TX Response_code = " & xpay.resCode & "<br>")
'Response.Write("TX Response_msg = " & xpay.resMsg & "<p>")

        iretval = "0"
        iResultCode = xpay.resCode
		iResultMsg	= xpay.resMsg
    else
        '2)API 요청 실패 화면처리
'Response.Write("결제취소 요청이 실패하였습니다. <br>")
'Response.Write("TX Response_code = " & xpay.resCode & "<br>")
'Response.Write("TX Response_msg = " & xpay.resMsg & "<p>")
        iResultCode = xpay.resCode
		iResultMsg	= xpay.resMsg
    end if

    iCancelDate	= year(now) & "년 " & month(now) & "월 " & day(now) & "일"
	iCancelTime	= hour(now) & "시 " & minute(now) & "분 " & second(now) & "초"

end function

''모빌리언스 휴대폰 실취소
function CanCelMobileMCASH(ipaygatetid,irefundrequire,irdSite,byREF iretval,byREF iResultCode,byREF iResultMsg,byREF iCancelDate,byREF iCancelTime)
    Dim McashCancelObj, Mrchid, Svcid, Tradeid, Prdtprice, Mobilid

	Set McashCancelObj = Server.CreateObject("Mcash_Cancel.Cancel.1")

	Mrchid      = "10030289"
	If irdSite = "mobile" Then
		Svcid       = "100302890002"
	Else
		Svcid       = "100302890001"
	End If
	Tradeid     = Split(ipaygatetid,"|")(0)
	Prdtprice   = irefundrequire
	Mobilid     = Split(ipaygatetid,"|")(1)

	McashCancelObj.Mrchid			= Mrchid
	McashCancelObj.Svcid			= Svcid
	McashCancelObj.Tradeid			= Tradeid
	McashCancelObj.Prdtprice		= Prdtprice
	McashCancelObj.Mobilid	        = Mobilid

	iretval = McashCancelObj.CancelData

	set McashCancelObj = nothing

	If iretval = "0" Then
		iResultCode 	= "00"
		iResultMsg	= "정상처리"
	Else
		iResultCode = iretval
		Select Case iResultCode
			Case "14"
				iResultMsg = "해지"
			Case "20"
				iResultMsg = "휴대폰 등록정보 오류(PG사) (LGT의 경우 사용자정보변경에 의한 인증실패)"
			Case "41"
				iResultMsg = "거래내역 미존재"
			Case "42"
				iResultMsg = "취소기간경과"
			Case "43"
				iResultMsg = "승인내역오류 ( 인증정보와의 불일치, 승인번호 유효시간 초과( 3분 ) )"
			Case "44"
				iResultMsg = "중복 취소 요청"
			Case "45"
				iResultMsg = "취소 요청 시 취소 정보 불일치"
			Case "97"
				iResultMsg = "요청자료 오류"
			Case "98"
				iResultMsg = "통신사 통신오류"
			Case "99"
				iResultMsg = "기타"
			Case Else
				iResultMsg = ""
		End Select
	End If

	iCancelDate	= year(now) & "년 " & month(now) & "월 " & day(now) & "일"
	iCancelTime	= hour(now) & "시 " & minute(now) & "분 " & second(now) & "초"
end function

dim mode, backurl
mode        = requestCheckvar(request.Form("mode"), 32)
backurl     = request.ServerVariables("HTTP_REFERER")

dim userid, orderserial, IsBiSearch
dim returnmethod
dim rebankname, rebankaccount, rebankownername
dim encmethod

userid          = fnGetUserInfo("tenSn")
orderserial     = requestCheckvar(request.form("orderserial"), 32)

returnmethod    = requestCheckvar(request.form("returnmethod"), 32)

rebankname      = requestCheckvar(request.form("rebankname"), 128)
rebankaccount   = requestCheckvar(request.form("rebankaccount"), 128)
rebankownername = requestCheckvar(request.form("rebankownername"), 128)

if ((userid="") and session("userorderserial")<>"") then
	IsBiSearch = true
	orderserial = session("userorderserial")
end if

encmethod 			= ""
if (rebankaccount <> "") then
	encmethod = "AE2"
end if



'웹에서의 입력은 mode, 주문번호, 환불방식, 무통장정보 이외에 어떠한 값도 받지 않는다.(해킹대비)
'모든 체크는 아래에서 전부 다시 한다.(해킹대비)

'TODO : 파라미터 조작을 이용해 카드취소를 하면서 무통장 환불할 수 있다. 환불수단 체크필요.



'==============================================================================
dim myorder
set myorder = new CMyOrder
if (IsBiSearch) then
    ''비회원주문
	myorder.FRectOrderserial = orderserial
	if (orderserial<>"") then
	    myorder.GetOneOrder
	end if
else
    ''회원주문
	myorder.FRectUserID = userid
	myorder.FRectOrderserial = orderserial

	if (userid<>"") and (orderserial<>"") then
	    myorder.GetOneOrder
	end if
end if

dim IsChangeOrder
IsChangeOrder = myorder.FOneItem.Fjumundiv = "6"


'==============================================================================
dim myorderdetail
set myorderdetail = new CMyOrder
myorderdetail.FRectOrderserial = orderserial

if (myorder.FResultCount>0) then
    myorderdetail.GetOrderDetail
end if



'==============================================================================
dim IsAllCancelAvail

IsAllCancelAvail = (myorder.FOneItem.IsValidOrder) and (myorder.FOneItem.IsWebOrderCancelEnable) and (myorder.FOneItem.IsDirectALLCancelEnable(myorderdetail)) and (Not IsChangeOrder)

if (Not IsAllCancelAvail) then
    response.write "<script language='javascript'>alert('주문 취소 가능 상태가 아닐 수 있습니다. 다시 확인해 주시기 바랍니다.');</script>"
    response.write "<script language='javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if

if (myorder.FResultCount<1) then
    response.write "<script language='javascript'>alert('주문 취소 가능 상태가 아니거나 거래내역이 없습니다.');</script>"
    response.write "<script language='javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if

if (returnmethod = "") then
    response.write "<script language='javascript'>alert('주문을 취소하는 과정에서 오류가 발생했습니다.\n\n지속적으로 오류가 발생시 고객센터로 연락주시기 바랍니다.');</script>"
    response.write "<script language='javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if




'==============================================================================
'핸드폰 결제 취소일과 결제일 비교. UP이 취소월이 결제월보다 뒤
Dim vIsMobileCancelDateUpDown

If myorder.FOneItem.Faccountdiv = "400" AND DateDiff("m", myorder.FOneItem.FIpkumDate, Now) > 0 Then
	vIsMobileCancelDateUpDown = "UP"
Else
	vIsMobileCancelDateUpDown = "DOWN"
End If

Dim IsDacomMobile
if (myorder.FOneItem.Faccountdiv = "400") and (Len(myorder.FOneItem.Fpaygatetid)>=31) then
    IsDacomMobile = True        ''46~49 Tradeid(23) & "|" & vTID(24)
else
    IsDacomMobile = False       ''32~35 Tradeid(23) & "|" & vTID(10)
end if


'==============================================================================
dim modeflag2, divcd, id, reguserid, ipkumdiv
dim title, gubun01, gubun02, contents_jupsu
dim finishuser, contents_finish
dim newasid, isCsMailSend
dim ScanErr, ResultMsg, ReturnUrl, errcode
dim CsId
dim refundrequire



'==============================================================================
''데이콤 가상계좌인지.
dim retVal
dim IsCyberAcctCancel : IsCyberAcctCancel = myorder.FOneItem.IsDacomCyberAccountPay
IsCyberAcctCancel = IsCyberAcctCancel And (Not myorder.FOneItem.IsPayed)



if (mode="cancelorder") then
    '' 전체 취소
	'==============================================================================
	newasid 		= -1

	modeflag2   	= "regcsas"
	divcd       	= "A008"
	id          	= 0
	ipkumdiv    	= myorder.FOneItem.FIpkumDiv
	reguserid   	= userid
	finishuser  	= CFINISH_SYSTEM
	title       	= "[고객취소]" & GetDefaultTitle(divcd, 0, orderserial)
	gubun01     	= "C004"  ''공통
	gubun02     	= "CD01"  ''단순변심
	contents_jupsu  = ""
	contents_finish = ""
	isCsMailSend 	= "on"

	refundrequire	= myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc

	if (myorder.FOneItem.Fipkumdiv < 4) then
		refundrequire = "0"
	end if

	if (reguserid = "") then
		reguserid="GuestOrder"
	end if

	'==============================================================================
	On Error Resume Next
        dbget.beginTrans

        If (Err.Number = 0) and (ScanErr="") Then
            errcode = "001"
            '' CS Master 접수
            CsId = RegCSMaster(divcd, orderserial, reguserid, title, contents_jupsu, gubun01, gubun02)
        end if

	    If (Err.Number = 0) and (ScanErr="") Then
            errcode = "002"
            '' CS Detail 접수
            Call RegWebCSDetailAllCancel(CsId, orderserial)
        end if

	    If (Err.Number = 0) and (ScanErr="") Then
            errcode = "003"
            '' 환불 관련정보 (선)저장
	        if (refundrequire<>"0") and (returnmethod<>"R000") then
	            Call RegWebCancelRefundInfo(CsId, orderserial, returnmethod, refundrequire , rebankname, rebankaccount, rebankownername)
	            Call EditCSMasterRefundEncInfo(CsId, encmethod, rebankaccount)
	        end if

	    End if

        If (Err.Number = 0) and (ScanErr="") Then
            errcode = "004"
            ''환불 등록건이 있는지 체크 후 환불요청/신용카드 취소요청 등록
            if (refundrequire<>"0") and (returnmethod<>"R000") then
	            newasid = CheckNRegRefund(CsId, orderserial, reguserid)

	            if (newasid>0) then
	                ResultMsg = ResultMsg + "->. 환불 요청 접수 완료\n\n"
	            end if
			end if
        End If

        If (Err.Number = 0) and (ScanErr="") Then
            errcode = "005"
            Call CancelProcess(CsId, orderserial, true)
            ResultMsg = ResultMsg + "->. 주문건 취소 완료\n\n"
        End IF

        If (Err.Number = 0) and (ScanErr="") Then
            errcode = "009"
            Call FinishCSMaster(CsId, finishuser, html2db(contents_finish))
        End If

        If (Err.Number = 0) and (ScanErr="") Then
            dbget.CommitTrans
            'dbget.RollBackTrans

            ''가상계좌 입금기한 변경. : 취소시 입금기한 오는 0시로
            if (IsCyberAcctCancel) then
                retVal = ChangeCyberAcct(orderserial, myorder.FOneItem.FSubtotalPrice-myorder.FOneItem.FsumPaymentEtc, Replace(Left(CStr(now()),10),"-","") & "000000" )
            end if

    		'########################################### 핸드폰 결제 취소 프로세스 [모빌리언스 접속 후 실제 취소]<!-- //--> ###########################################
    		If (vIsMobileCancelDateUpDown = "DOWN") AND (myorder.FOneItem.FAccountDiv = "400") Then
    		        Dim ResultCode, CancelDate, CancelTime

                    IF (IsDacomMobile) then
                        CALL CanCelMobileDacom(myorder.FOneItem.Fpaygatetid,refundrequire,myorder.FOneItem.Frdsite,retval,ResultCode,ResultMsg,CancelDate,CancelTime)
                        ''(ResultCode="0000") , AV11 확인(해외카드 매입전취소 실패 의 경우확인.)
                    ELSE
                        CALL CanCelMobileMCASH(myorder.FOneItem.Fpaygatetid,refundrequire,myorder.FOneItem.Frdsite,retval,ResultCode,ResultMsg,CancelDate,CancelTime)
                    ENd IF

					dim sqlStr
					dim refundresult
					dim iorderserial, ibuyhp

					contents_finish = "결과 " & "[" & ResultCode & "]" & ResultMsg & VbCrlf
					contents_finish = contents_finish & "취소일시 : " & CancelDate & " " & CancelTime & VbCrlf
					contents_finish = contents_finish & "취소자 ID " & CFINISH_SYSTEM

					if (ResultCode="00") or (ResultCode="0000") then

					    sqlStr = "select r.*, a.userid, m.orderserial, m.buyhp from "
					    sqlStr = sqlStr + " [db_cs].[dbo].tbl_as_refund_info r,"
					    sqlStr = sqlStr + " [db_cs].dbo.tbl_new_as_list a"
					    sqlStr = sqlStr + "     left join db_order.dbo.tbl_order_master m "
						sqlStr = sqlStr + "     on a.orderserial=m.orderserial"
					    sqlStr = sqlStr + " where r.asid=" + CStr(newasid)
					    sqlStr = sqlStr + " and r.asid=a.id"

					    rsget.Open sqlStr,dbget,1
					    if Not rsget.Eof then
					        returnmethod    = rsget("returnmethod")
					        refundrequire   = rsget("refundrequire")
					        refundresult    = rsget("refundresult")
					        userid          = rsget("userid")
					        iorderserial    = rsget("orderserial")
					        ibuyhp          = rsget("buyhp")
					    end if
					    rsget.Close


					    sqlStr = " update [db_cs].[dbo].tbl_as_refund_info"
					    sqlStr = sqlStr + " set refundresult=" + CStr(refundrequire)
					    sqlStr = sqlStr + " where asid=" + CStr(newasid)
					    dbget.Execute sqlStr

					    Call AddCustomerOpenContents(newasid, "환불(취소) 완료: " & CStr(refundrequire))


					    dim IsCsErrStockUpdateRequire
					    IsCsErrStockUpdateRequire = False

					    sqlStr = "select divcd, finishdate, currstate"
					    sqlStr = sqlStr + " from [db_cs].[dbo].tbl_new_as_list"
					    sqlStr = sqlStr + " where id=" + CStr(newasid)
					    rsget.Open sqlStr,dbget,1
					    if Not rsget.Eof then
					        IsCsErrStockUpdateRequire = (rsget("divcd")="A011") and (IsNULL(rsget("finishdate"))) and (rsget("currstate")<>"B007")
					    end if
					    rsget.close

					    sqlStr = " update [db_cs].[dbo].tbl_new_as_list"                      + VbCrlf
					    sqlStr = sqlStr + " set finishuser='" + CFINISH_SYSTEM + "'"            + VbCrlf
					    sqlStr = sqlStr + " , contents_finish='" + contents_finish + "'"    + VbCrlf
					    sqlStr = sqlStr + " , finishdate=getdate()"                         + VbCrlf
					    sqlStr = sqlStr + " , currstate='B007'"                             + VbCrlf
					    sqlStr = sqlStr + " where id=" + CStr(newasid)

					    dbget.Execute sqlStr

					    ''맞교환회수 완료일경우 재고없데이트. 2007.11.16
					    if (IsCsErrStockUpdateRequire) then
					        sqlStr = " exec db_summary.dbo.ten_RealTimeStock_CsErr " & newasid & ",'','" + CFINISH_SYSTEM + "'"
					        dbget.Execute sqlStr
					    end if

					    ''승인 취소 요청 SMS 발송
					    if (iorderserial<>"") and (ibuyhp<>"") then
					    	dim osms
					    	set osms = new CSMSClass
					        osms.SendAcctCancelMsg ibuyhp, iorderserial
					        set osms = Nothing

					    end if

					    ''메일
					    dim oCsAction,strMailHTML,strMailTitle
						Set oCsAction = New CsActionMailCls
						strMailHTML = oCsAction.makeMailTemplate(newasid)
						strMailTitle = "[텐바이텐]"& oCsAction.FCustomerName & "님께서 요청하신 ["& oCsAction.GetAsDivCDName &"] 처리가 "& oCsAction.FCurrStateName &" 되었습니다."

						'//=======  메일 발송 =========/
						dim MailHTML

						IF oCsAction.FBuyEmail<>"" THEN
							Call SendMail("mailzine@10x10.co.kr", oCsAction.FBuyEmail, strMailTitle, strMailHTML)
						End IF

					    Set oCsAction = Nothing

					end if

    		End IF
    		'########################################### 핸드폰 결제 취소 프로세스 [모빌리언스 접속 후 실제 취소] ###########################################


            response.write "<script>alert('" + ResultMsg + " ');</script>"
            response.write "<script>location.href='/apps/appCom/between/my10x10/order/myorderlist.asp';</script>"
        Else
            dbget.RollBackTrans
            response.write "<script>alert(" + Chr(34) + "데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망.(에러코드 : " + CStr(errcode) + ":" + Err.Description + "|" + ScanErr + ")" + Chr(34) + ")</script>"
            response.write "<script>history.back()</script>"
            dbget.close()	:	response.End
        End If
	On error Goto 0




elseif (mode="partialcancelorder") then
    '' 접수된 내역 취소 확인. : 부분취소.
    On Error Resume Next
    dbget.beginTrans
    reguserid   = userid

    If (Err.Number = 0) and (ScanErr="") Then
        errcode = "006"
        Call CancelProcess(id, orderserial, false)
        ResultMsg = ResultMsg + "->. 주문취소 처리\n\n"
    End IF

    If (Err.Number = 0) and (ScanErr="") Then
        errcode = "007"
        '' 환불 관련정보 업데이트
        if (refundrequire<>"0") and (returnmethod<>"R000") then
            if  (NOT UpdateWebRefundInfo(id, orderserial, returnmethod , rebankname, rebankaccount, rebankownername)) then
                ScanErr = "환불 정보 등록중 오류가 발생하였습니다."
            end if
            Call EditCSMasterRefundEncInfo(id, encmethod, rebankaccount)
        end if
    End if


    If (Err.Number = 0) and (ScanErr="") Then
        errcode = "008"
        ''환불 등록건이 있는지 체크 후 환불요청/신용카드 취소요청 등록
        newasid = CheckNRegRefund(id, orderserial, reguserid)

        if (newasid>0) then
            ResultMsg = ResultMsg + "->. [환불 등록] 처리\n\n"
        end if
    End If


    If (Err.Number = 0) and (ScanErr="") Then
        errcode = "009"
        Call FinishCSMaster(id, reguserid, contents_finish)
    End If



    If (Err.Number = 0) and (ScanErr="") Then
        dbget.CommitTrans
        response.write "<script>alert('" + ResultMsg + "');</script>"
        response.write "<script>location.href='/my10x10/order/myorderlist.asp?aflag=XX';</script>"
	Else
        dbget.RollBackTrans
        response.write "<script>alert(" + Chr(34) + "데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망.(에러코드 : " + CStr(errcode) + ":" + Err.Description + "|" + ScanErr + ")" + Chr(34) + ")</script>"
        response.write "<script>history.back()</script>"
        dbget.close()	:	response.End
    End If

    isCsMailSend = false
    ''주문취소 완료 메일 : 없슴.
    If (isCsMailSend) then
        ''Call SendCsActionMail(id)

        ''환불 접수 메일
        if (newasid>0) then
            ''Call SendCsActionMail(newasid)
        end if
    End IF
    On error Goto 0
end if

%>

<%
set myorder = Nothing
set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->