<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/giftcard/cs_giftcard_ordercls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<!-- #include virtual="/lib/util/DcCyberAcctUtil.asp"-->
<!-- #include virtual="/lib/email/cs_action_mail_Function.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->

<%
Const CFINISH_SYSTEM = "system"



'==============================================================================
dim giftorderserial
dim mode

giftorderserial = requestCheckvar(request("giftorderserial"),11)
mode = requestCheckvar(request("mode"),20)

dim userid
userid = getEncLoginUserID()



'==============================================================================
dim oGiftOrder

set oGiftOrder = new cGiftCardOrder

if (giftorderserial <> "") then
	oGiftOrder.FRectGiftOrderSerial = giftorderserial

	if (IsUserLoginOK()) then
		oGiftOrder.getCSGiftcardOrderDetail
	end if
end if




'==============================================================================
dim ErrMsg

if (oGiftOrder.FResultCount = 0) or (oGiftOrder.FOneItem.Fuserid <> userid) then
	ErrMsg = "잘못된 접속입니다."
else
	if (oGiftOrder.FOneItem.Fcancelyn <> "N") then
		ErrMsg = "취소된 주문입니다."
	end if

	if (oGiftOrder.FOneItem.Fjumundiv = "7") then
		ErrMsg = "Gift카드가 이미 등록되었습니다. 취소할 수 없습니다."
	end if

	if (oGiftOrder.FOneItem.FAccountdiv <> "7") and (oGiftOrder.FOneItem.FAccountdiv <> "100") and (oGiftOrder.FOneItem.FAccountdiv <> "20") then
		ErrMsg = "취소할 수 없습니다.\n\n오류정보 : 잘못된 결제정보"
	end if
end if

if (ErrMsg <> "") then
    response.write "<script language='javascript'>alert('" + CStr(ErrMsg) + "');location.href='/my10x10/giftcard/giftCardList.asp';</script>"
    dbget.close()	:	response.End
end if



'==============================================================================
dim returnmethod, returnmethodstring, refundrequire

if (oGiftOrder.FOneItem.FAccountdiv = "7") and (oGiftOrder.FOneItem.Fipkumdiv < "4") and (oGiftOrder.FOneItem.Fipkumdiv >= "2") then
	'결제이전 취소
	returnmethod		= "R000"
	returnmethodstring	= "환불없음"
	refundrequire 		= "0"
elseif (oGiftOrder.FOneItem.FAccountdiv = "7") and (oGiftOrder.FOneItem.Fipkumdiv >= "4") and (oGiftOrder.FOneItem.Fipkumdiv <> "9") then
	'결제이전 취소
	returnmethod		= "R007"
	returnmethodstring	= "무통장환불"
	refundrequire 		= oGiftOrder.FOneItem.Fsubtotalprice
elseif (oGiftOrder.FOneItem.FAccountdiv = "20") then
	'실시간이체 취소
	returnmethod		= "R020"
	returnmethodstring	= "실시간이체 취소"
	refundrequire 		= oGiftOrder.FOneItem.Fsubtotalprice
elseif (oGiftOrder.FOneItem.FAccountdiv = "100") then
	'결제이전 취소
	returnmethod		= "R100"
	returnmethodstring	= "신용카드 취소"
	refundrequire 		= oGiftOrder.FOneItem.Fsubtotalprice
else
	ErrMsg = "취소할 수 없습니다.\n\n오류정보 : 잘못된 결제정보"

    response.write "<script language='javascript'>alert('" + CStr(ErrMsg) + "');location.href='/my10x10/giftcard/giftCardList.asp';</script>"
    dbget.close()	:	response.End
end if



'==============================================================================
dim rebankname, rebankaccount, rebankownername
dim encmethod
dim paygatetid

rebankname      = requestCheckvar(request.form("rebankname"), 128)
rebankaccount   = requestCheckvar(request.form("rebankaccount"), 128)
rebankownername = requestCheckvar(request.form("rebankownername"), 128)
encmethod 		= "AE2"
paygatetid		= oGiftOrder.FOneItem.Fpaydateid


'웹에서의 입력은 mode, 주문번호, 환불방식, 무통장정보 이외에 어떠한 값도 받지 않는다.(해킹대비)
'모든 체크는 아래에서 전부 다시 한다.(해킹대비)

'TODO : 파라미터 조작을 이용해 카드취소를 하면서 무통장 환불할 수 있다. 환불수단 체크필요.



'==============================================================================
dim modeflag2, divcd, id, reguserid, ipkumdiv
dim title, gubun01, gubun02, contents_jupsu
dim finishuser, contents_finish
dim newasid, isCsMailSend
dim ScanErr, ResultMsg, ReturnUrl, errcode
dim CsId

dim sqlStr



'==============================================================================
''데이콤 가상계좌인지.
dim retVal
dim IsCyberAcctCancel : IsCyberAcctCancel = oGiftOrder.FOneItem.IsDacomCyberAccountPay
IsCyberAcctCancel = IsCyberAcctCancel And (refundrequire = 0)



if (mode="cancelorder") then
    '' 전체 취소
	'==============================================================================
	newasid 		= -1

	modeflag2   	= "regcsas"
	divcd       	= "A008"
	id          	= 0
	reguserid   	= userid
	finishuser  	= CFINISH_SYSTEM
	title       	= "[고객취소] Gift카드 구매취소"
	gubun01     	= "C004"  ''공통
	gubun02     	= "CD01"  ''단순변심
	contents_jupsu  = ""
	contents_finish = ""
	isCsMailSend 	= "on"

	'==============================================================================
	On Error Resume Next
        dbget.beginTrans

        If (Err.Number = 0) and (ScanErr="") Then
            errcode = "001"
            '' CS Master 접수
            CsId = RegCSMaster(divcd, giftorderserial, reguserid, title, contents_jupsu, gubun01, gubun02)
        end if

	    If (Err.Number = 0) and (ScanErr="") Then
            errcode = "003"
            '' 환불 관련정보 (선)저장
	        if (refundrequire<>"0") and (returnmethod<>"R000") then
	            Call RegWebGiftCardCancelRefundInfo(CsId, giftorderserial, returnmethod, refundrequire , rebankname, rebankaccount, rebankownername, paygatetid)
	            Call EditCSMasterRefundEncInfo(CsId, encmethod, rebankaccount)

	            '''계좌 암호화 추가.
		        Call EditCSMasterRefundEncInfo(id, encmethod, rebankaccount)
	        end if

	    End if

        If (Err.Number = 0) and (ScanErr="") Then
            errcode = "004"
            ''환불 등록건이 있는지 체크 후 환불요청/신용카드 취소요청 등록
            if (refundrequire<>"0") and (returnmethod<>"R000") then
	            newasid = CheckNRegRefund(CsId, giftorderserial, reguserid)

	            if (newasid>0) then
	                ResultMsg = ResultMsg + "->. 환불 요청 접수 완료\n\n"
	            end if
			end if
        End If

        If (Err.Number = 0) and (ScanErr="") Then
            errcode = "005"

		    sqlStr = "update [db_order].[dbo].tbl_giftcard_order " + VbCrlf
		    sqlStr = sqlStr + " set cancelyn='Y'" + VbCrlf
		    sqlStr = sqlStr + " ,canceldate=IsNULL(canceldate,getdate())" + VbCrlf
		    sqlStr = sqlStr + " where giftorderserial='" + giftorderserial + "'" + VbCrlf
		    dbget.Execute sqlStr

		    ''전자보증서 발급된 경우 취소
		    if (ogiftcardordermaster.FOneItem.FInsureCd="0") then
		        Call UsafeCancel(giftorderserial)
		    end if

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
                'retVal = ChangeCyberAcct(giftorderserial, oGiftOrder.FOneItem.FSubtotalPrice-oGiftOrder.FOneItem.FsumPaymentEtc, Replace(Left(CStr(now()),10),"-","") & "000000" )
            end if

            response.write "<script>alert('" + ResultMsg + " '); location.href='/my10x10/giftcard/giftCardList.asp';</script>"
        Else
            dbget.RollBackTrans
            response.write "<script>alert(" + Chr(34) + "데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망.(에러코드 : " + CStr(errcode) + ":" + Err.Description + "|" + ScanErr + ")" + Chr(34) + ")</script>"
            response.write "<script>location.href='/my10x10/giftcard/giftCardList.asp';</script>"
            dbget.close()	:	response.End
        End If
	On error Goto 0

end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->