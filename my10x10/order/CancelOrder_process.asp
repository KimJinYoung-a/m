<%@  codepage="65001" language="VBScript" %>
<% option explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

response.Charset = "utf-8"
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/util/DcCyberAcctUtil.asp"-->
<!-- #include virtual="/lib/email/cs_action_mail_Function.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cancelOrderLib.asp" -->

<% '### 결제별 취소 함수 include %>
<!-- #include file="./inc_Cancel_Function_by_Pay.asp" -->
<%
'///////// 해당페이지의 취소 로직 관련해서 수정이 읽어 날경우 밑에 페이지도 반드시 모두 같이 수정해야 합니다.
' WAPI : /autojob/cs_cancel_autojob.asp , 관련펑션, 관련lib, 관련클래스
' WWW : /my10x10/orderPopup/CancelOrder_process.asp , 관련펑션, 관련lib, 관련클래스
' M : /my10x10/order/CancelOrder_process.asp , 관련펑션, 관련lib, 관련클래스
' APP : /apps/appCom/wish/web2014/my10x10/order/CancelOrder_process.asp , 관련펑션, 관련lib, 관련클래스
'////////////////////////////////////

Const CFINISH_SYSTEM = "system"

Dim vQuery
dim mode, backurl
mode        = requestCheckvar(request.Form("mode"), 32)
backurl     = request.ServerVariables("HTTP_REFERER")

dim userid, orderserial, IsBiSearch
dim returnmethod
dim rebankname, rebankaccount, rebankownername
dim encmethod
dim ResultCount

userid          = getEncLoginUserID()
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
	encmethod = "AE2" ''"PH1"
end if


if (mode = "socancelorder") and (IsAllStockOutCancel(orderserial) <> True) then
	response.write "<script language='javascript'>alert('주문을 취소하는 과정에서 오류가 발생했습니다.\n\n지속적으로 오류가 발생시 고객센터로 연락주시기 바랍니다.');</script>"
    response.write "<script language='javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if


'웹에서의 입력은 mode, 주문번호, 환불방식, 무통장정보 이외에 어떠한 값도 받지 않는다.(해킹대비)
'모든 체크는 아래에서 전부 다시 한다.(해킹대비)

'TODO : 파라미터 조작을 이용해 카드취소를 하면서 무통장 환불할 수 있다. 환불수단 체크필요.


'// ============================================================================
dim IsAllCancelProcess, IsPartCancelProcess, IsStockoutCancelProcess, isEvtGiftDisplay

IsAllCancelProcess = ((mode = "socancelorder") or (mode = "cancelorder"))
IsPartCancelProcess = (mode = "stockoutcancel")
IsStockoutCancelProcess = ((mode = "socancelorder") or (mode = "stockoutcancel"))
isEvtGiftDisplay = IsAllCancelProcess


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


'// ============================================================================
dim IsCancelOK, CancelFailMSG

IsCancelOK = True
CancelFailMSG = ""


'// ============================================================================
'// 주문상태 체크
CancelFailMSG = OrderCancelValidMSG(myorder, myorderdetail, IsAllCancelProcess, IsPartCancelProcess, IsStockoutCancelProcess)
if CancelFailMSG <> "" then
	IsCancelOK = False
end if


'// ============================================================================
'// 환불 가능한지
dim IsCancelOrderByOne : IsCancelOrderByOne = False
if IsCancelOK then
	'// 한방 주문 전체취소인지
	IsCancelOrderByOne = GetIsCancelOrderByOne(myorder, mode) and Not IsPartCancelProcess
end if

dim validReturnMethod : validReturnMethod = "R000"
if IsCancelOK then
	validReturnMethod = GetValidReturnMethod(myorder, IsCancelOrderByOne)
end if

if (validReturnMethod = "FAIL") then
	IsCancelOK = False
	CancelFailMSG = "웹취소 불가 주문입니다. <a href='javascript:GotoCSCenter()'><font color='blue'>1:1 상담</font></a> 또는 고객센터로 문의주세요."
end if

'// ============================================================================
'// 핸드폰 결제 취소일과 결제일 비교. UP이 취소월이 결제월보다 뒤
Dim vIsMobileCancelDateUpDown
'If myorder.FOneItem.Faccountdiv = "400" AND DateDiff("m", myorder.FOneItem.FIpkumDate, Now) = 0 Then
If myorder.FOneItem.Faccountdiv = "400" AND DateDiff("m", myorder.FOneItem.FIpkumDate, Now) > 0 Then
	vIsMobileCancelDateUpDown = "UP"
Else
	vIsMobileCancelDateUpDown = "DOWN"
End If


'// ============================================================================
dim ismoneyrefundok			'무통장, 마일리지 환불 가능한지


if IsCancelOK then
	if validReturnMethod = "R007" then
		if (returnmethod <> "R007") and (returnmethod <> "R910") and (returnmethod <> "R000") then
			response.write "<script language='javascript'>alert('잘못된 접근입니다.(환불방식 오류[0])');</script>"
			response.write "<script language='javascript'>history.back();</script>"
			dbget.close()	:	response.End
		end if
	else
		returnmethod = validReturnMethod
	end if
else
	response.write "<script language='javascript'>alert('잘못된 접근입니다.(환불방식 오류[1])');</script>"
	response.write "<script language='javascript'>history.back();</script>"
	dbget.close()	:	response.End
end if

ismoneyrefundok = false
if returnmethod = "R007" then
	ismoneyrefundok = true
end if


'========================================================================================
'### 품절취소시 1개 주문에 전체상품이 품절인 경우 cancelorder 전체취소 를 태움.
Dim i, IsSoldOutCancel
IsSoldOutCancel = false
if (mode = "stockoutcancel") or (mode = "socancelorder") then
	IsSoldOutCancel = true
end if


''휴대폰 결제 추가 2015/04/21 IsINIMobile
Dim IsINIMobile : IsINIMobile = false
if (myorder.FOneItem.Faccountdiv = "400") and (Len(myorder.FOneItem.Fpaygatetid)=40) then
    IsINIMobile = (LEFT(myorder.FOneItem.Fpaygatetid,LEN("IniTechPG_"))="IniTechPG_") or (LEFT(myorder.FOneItem.Fpaygatetid,LEN("INIMX_HPP_"))="INIMX_HPP_") or (LEFT(myorder.FOneItem.Fpaygatetid,LEN("StdpayHPP_"))="StdpayHPP_")
end if

Dim IsDacomMobile : IsDacomMobile = false
if (NOT IsINIMobile) then
    if (myorder.FOneItem.Faccountdiv = "400") and (Len(myorder.FOneItem.Fpaygatetid)>=31) then
        IsDacomMobile = True        ''46~49 Tradeid(23) & "|" & vTID(24)
    else
        IsDacomMobile = False       ''32~35 Tradeid(23) & "|" & vTID(10)
    end if
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
dim orgsubtotalprice, orgitemcostsum, orgbeasongpay, orgmileagesum, orgcouponsum, orgallatdiscountsum
Dim canceltotal, refunditemcostsum, refundmileagesum, refundcouponsum, refundallatsubtractsum, refundbeasongpay, refunddeliverypay, refundadjustpay, paygatetid
Dim remainsubtotalprice, remainitemcostsum, remainbeasongpay, remainmileagesum, remaincouponsum, remainallatdiscountsum, remaindepositsum, remaingiftcardsum
Dim orgdepositsum, orggiftcardsum, refundgiftcardsum, refunddepositsum
dim CancelValidResultMessage

'// 원주문
orgsubtotalprice		= myorder.FOneItem.Fsubtotalprice
orgitemcostsum			= myorder.FOneItem.Ftotalsum - myorder.FOneItem.FDeliverprice
orgbeasongpay			= myorder.FOneItem.FDeliverPrice
orgmileagesum			= myorder.FOneItem.FMileTotalPrice
orgcouponsum			= myorder.FOneItem.FTenCardSpend
orgallatdiscountsum		= myorder.FOneItem.FAllatDiscountPrice
orgdepositsum			= myorder.FOneItem.Fspendtencash
orggiftcardsum			= myorder.FOneItem.Fspendgiftmoney
paygatetid				= myorder.FOneItem.Fpaygatetid

remainsubtotalprice		= orgsubtotalprice
remainitemcostsum		= orgitemcostsum
remainbeasongpay		= orgbeasongpay
remainmileagesum		= orgmileagesum
remaincouponsum			= orgcouponsum
remainallatdiscountsum	= orgallatdiscountsum
remaindepositsum		= orgdepositsum
remaingiftcardsum		= orggiftcardsum

refunditemcostsum		= 0
refundmileagesum		= 0
refundcouponsum			= 0
refundallatsubtractsum	= 0
refundbeasongpay		= 0
refunddeliverypay		= 0
refundadjustpay			= 0
refundgiftcardsum		= 0
refunddepositsum		= 0


'==============================================================================
''데이콤 가상계좌인지.
dim retVal
dim IsCyberAcctCancel : IsCyberAcctCancel = myorder.FOneItem.IsDacomCyberAccountPay
IsCyberAcctCancel = IsCyberAcctCancel And (Not myorder.FOneItem.IsPayed)

'### 선물포장여부
dim vIsPacked
vIsPacked = requestCheckvar(request("ispacked"),1)

if (mode="cancelorder") or (mode="socancelorder") then
    '' 전체 취소
	'==============================================================================
	vQuery = " select "
	vQuery = vQuery & "		sum(case when d.itemid <> 0 then d.itemcost*d.itemno else 0 end) as refunditemcostsum "
	vQuery = vQuery & "		, sum(d.itemcost*d.itemno - (d.reducedPrice + IsNull(d.etcDiscount,0))*d.itemno) as refundcouponsum "
	vQuery = vQuery & "		, sum(IsNull(d.etcDiscount,0)*d.itemno) as refundallatsubtractsum "
	vQuery = vQuery & "		, sum(case when d.itemid = 0 then d.itemcost*d.itemno else 0 end) as refundbeasongpay "
	vQuery = vQuery & "	from "
	vQuery = vQuery & "		[db_order].[dbo].[tbl_order_detail] d "
	vQuery = vQuery & "	where "
	vQuery = vQuery & "		1 = 1 "
	vQuery = vQuery & "		and d.orderserial = '" & orderserial & "' "
	vQuery = vQuery & "		and d.cancelyn <> 'Y' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	If not rsget.Eof Then
		refunditemcostsum = rsget("refunditemcostsum")
		refundcouponsum = rsget("refundcouponsum")
		refundallatsubtractsum = rsget("refundallatsubtractsum")
		refundbeasongpay = rsget("refundbeasongpay")
	End IF
	rsget.close

	if (remainitemcostsum < refunditemcostsum) or (remaincouponsum < refundcouponsum) or (remainbeasongpay < refundbeasongpay) then
		response.write "<script>alert('취소접수 할 수 없습니다.[코드번호:3-3]\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
		response.write "<script>history.back()</script>"
		dbget.close()	:	response.End
	end if

	'기타할인, 퍼센트쿠폰 당연차감
	refundrequire = refunditemcostsum - refundallatsubtractsum - refundcouponsum + refundbeasongpay

	'마일리지, 예치금, 기프트카드 제외
	'// 2018-02-22, skyer9, 마일리지 이미 빠져있음.
	remainsubtotalprice = remainsubtotalprice - 0 - remaindepositsum - remaingiftcardsum

	'마일리지
	if (remainsubtotalprice < refundrequire) then
		if (remainmileagesum > 0) then
			if ((refundrequire - remainsubtotalprice) >= remainmileagesum) then
				refundmileagesum = remainmileagesum
			else
				refundmileagesum = (refundrequire - remainsubtotalprice)
			end if
			refundrequire = refundrequire - refundmileagesum
		end if
	end if

	'기프트카드
	if (remainsubtotalprice < refundrequire) then
		if (remaingiftcardsum > 0) then
			if ((refundrequire - remainsubtotalprice) >= remaingiftcardsum) then
				refundgiftcardsum = remaingiftcardsum
			else
				refundgiftcardsum = (refundrequire - remainsubtotalprice)
			end if
			refundrequire = refundrequire - refundgiftcardsum
		end if
	end if

	'예치금
	if (remainsubtotalprice < refundrequire) then
		if (remaindepositsum > 0) then
			if ((refundrequire - remainsubtotalprice) >= remaindepositsum) then
				refunddepositsum = remaindepositsum
			else
				refunddepositsum = (refundrequire - remainsubtotalprice)
			end if
			refundrequire = refundrequire - refunddepositsum
		end if
	end if

	'==============================================================================
	'에러
	if (remainsubtotalprice < refundrequire) then
		response.write "<script>alert('취소접수 할 수 없습니다.[코드번호:4-1]\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
		response.write "<script>history.back()</script>"
		dbget.close()	:	response.End
	end if

	if refundrequire < 0 then
		response.write "<script>alert('취소접수 할 수 없습니다.[코드번호:4-2]\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
		response.write "<script>history.back()</script>"
		dbget.close()	:	response.End
	end if

	'==============================================================================
	canceltotal = refundrequire


	newasid 		= -1

	modeflag2   	= "regcsas"
	divcd       	= "A008"
	id          	= 0
	ipkumdiv    	= myorder.FOneItem.FIpkumDiv
	reguserid   	= userid
	finishuser  	= CFINISH_SYSTEM
	title       	= "[고객취소]" & GetDefaultTitle(divcd, 0, orderserial)
	gubun01     	= "C004"  ''공통

	If IsSoldOutCancel Then
		gubun02     	= "CD05"  ''품절
	Else
		gubun02     	= "CD01"  ''단순변심
	End If

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
			'// 언제나 등록한다. 2019-01-10, skyer9
			''if (refundrequire<>"0") and (returnmethod<>"R000") then
				refundcouponsum = refundcouponsum * -1
				refundmileagesum = refundmileagesum * -1
				refundgiftcardsum = refundgiftcardsum * -1
				refunddepositsum = refunddepositsum * -1

				'CS Master 환불 관련정보 저장	''# RegCSMasterRefundInfo, AddCSMasterRefundInfo -> /cscenter/lib/csAsfunction.asp
				Call RegCSMasterRefundInfo(CsId, returnmethod, refundrequire , orgsubtotalprice, orgitemcostsum, orgbeasongpay , orgmileagesum, orgcouponsum, orgallatdiscountsum  , canceltotal, refunditemcostsum, refundmileagesum, refundcouponsum, refundallatsubtractsum*-1, refundbeasongpay, refunddeliverypay, refundadjustpay , rebankname, rebankaccount, rebankownername, paygateTid)
				Call AddCSMasterRefundInfo(CsId, orggiftcardsum, orgdepositsum, refundgiftcardsum, refunddepositsum)

				'''계좌 암호화 추가.
				Call EditCSMasterRefundEncInfo(CsId, encmethod, rebankaccount)
			''end if
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

			'' 취소 업배 상품중 품절상품의 경우 상품정보에 품절설정
			if (mode="socancelorder") then
				ResultCount   = SetStockOutByCsAs(CsId)
				if (ResultCount > 0) then
					ResultMsg = ResultMsg + "->. [상품정보 품절 설정] 완료 처리\n\n"
				end if
			end if
		End IF

		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "009"
			Call FinishCSMaster(CsId, finishuser, html2db(contents_finish))
		End If

		If (Err.Number = 0) and (ScanErr="") Then
			dbget.CommitTrans

			''가상계좌 입금기한 변경. : 취소시 입금기한 오는 0시로
			if (IsCyberAcctCancel) then
				retVal = ChangeCyberAcct(orderserial, myorder.FOneItem.FSubtotalPrice-myorder.FOneItem.FsumPaymentEtc, Replace(Left(CStr(now()),10),"-","") & "000000" )
			end if


			'########################################### 선물포장 결제 취소. 전체취소만 됨. ###########################################
			If vIsPacked = "Y" Then
				sqlStr = "UPDATE [db_order].[dbo].[tbl_order_pack_master] SET cancelyn = 'Y' WHERE orderserial = '" & orderserial & "' " & vbCrLf
				sqlStr = sqlStr & "UPDATE [db_order].[dbo].[tbl_order_pack_detail] SET cancelyn = 'Y' "
				sqlStr = sqlStr & "WHERE midx IN(select midx from [db_order].[dbo].[tbl_order_pack_master] where orderserial = '" & orderserial & "')"
				dbget.Execute sqlStr
			End If
			'########################################### 선물포장 결제 취소. 전체취소만 됨. ###########################################


			'########################################### 핸드폰 결제 취소 프로세스 [모빌리언스 접속 후 실제 취소]<!-- //--> ###########################################
			If (returnmethod = "R400") and (vIsMobileCancelDateUpDown = "DOWN") AND (myorder.FOneItem.FAccountDiv = "400") Then
    			Dim ResultCode, CancelDate, CancelTime

				IF (IsINIMobile) then  ''2014/04/21 추가
					CALL CanCelMobileINI(myorder.FOneItem.Fpaygatetid,refundrequire,myorder.FOneItem.Frdsite,retval,ResultCode,ResultMsg,CancelDate,CancelTime)
				ELSEIF (IsDacomMobile) then
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
			response.write "<script>location.href='/my10x10/order/myorderlist.asp?aflag=XX';</script>"
		Else
			dbget.RollBackTrans
			response.write "<script>alert(" + Chr(34) + "데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망.(에러코드 : " + CStr(errcode) + ":" + Err.Description + "|" + ScanErr + ")" + Chr(34) + ")</script>"
			response.write "<script>history.back()</script>"
			dbget.close()	:	response.End
		End If
	On error Goto 0

elseif (mode="stockoutcancel") then	'### 품절 취소(부분취소일때) 프로세스 ###
    '' 품절취소.
	'On Error Resume Next

	If vIsPacked = "Y" Then
		response.write "<script>alert('선물포장인 주문건 입니다.\n선물포장 주문은 전체취소만 가능합니다.\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
		response.write "<script>history.back()</script>"
		dbget.close()	:	response.End
	End If

	vQuery = " select "
	vQuery = vQuery & "		sum(case when d.itemid <> 0 then d.itemcost*(case when d.itemid = 0 then d.itemno else IsNull(m.itemlackno,0) end) else 0 end) as refunditemcostsum "
	vQuery = vQuery & "		, sum(d.itemcost*(case when d.itemid = 0 then d.itemno else IsNull(m.itemlackno,0) end) - (d.reducedPrice + IsNull(d.etcDiscount,0))*(case when d.itemid = 0 then d.itemno else IsNull(m.itemlackno,0) end)) as refundcouponsum "
	vQuery = vQuery & "		, sum(IsNull(d.etcDiscount,0)*(case when d.itemid = 0 then d.itemno else IsNull(m.itemlackno,0) end)) as refundallatsubtractsum "
	vQuery = vQuery & "		, sum(case when d.itemid = 0 then d.itemcost*(case when d.itemid = 0 then d.itemno else IsNull(m.itemlackno,0) end) else 0 end) as refundbeasongpay "
	vQuery = vQuery & "	from "
	vQuery = vQuery & "		[db_order].[dbo].[tbl_order_detail] d "
	vQuery = vQuery & "		left join db_temp.dbo.tbl_mibeasong_list m "
	vQuery = vQuery & "		on "
	vQuery = vQuery & "			d.idx = m.detailidx "
	vQuery = vQuery & "	where "
	vQuery = vQuery & "		1 = 1 "
	vQuery = vQuery & "		and d.orderserial = '" & orderserial & "' "
	vQuery = vQuery & "		and d.cancelyn <> 'Y' "
	vQuery = vQuery & " 	and IsNull(d.currstate, '0') < '7' "
    vQuery = vQuery & " 	and ((IsNull(m.itemlackno,0) > 0) or (d.itemid = 0)) "
	vQuery = vQuery & "		and ( "
	'vQuery = vQuery & "			((d.itemid <> 0) and (IsNull(m.code, '') in ('05') or (IsNull(m.code, '') in ('03') and d.isupchebeasong='N'))) "
	vQuery = vQuery & "			((d.itemid <> 0) and (IsNull(m.code, '') in ('05') or IsNull(m.code, '') in ('06'))) "
	vQuery = vQuery & "			or "
	vQuery = vQuery & "			((d.itemid = 0) and (d.makerid in ( "
	vQuery = vQuery & "				select "
	vQuery = vQuery & "					(case when d.isupchebeasong = 'Y' or d.itemid = 0 then d.makerid else '' end) as makerid "
	vQuery = vQuery & "				from "
	vQuery = vQuery & "				[db_order].[dbo].[tbl_order_detail] d "
	vQuery = vQuery & "				left join db_temp.dbo.tbl_mibeasong_list m "
	vQuery = vQuery & "				on "
	vQuery = vQuery & "					d.idx = m.detailidx "
	vQuery = vQuery & "				where "
	vQuery = vQuery & "					1 = 1 "
	vQuery = vQuery & "					and d.orderserial = '" & orderserial & "' "
	vQuery = vQuery & "					and d.cancelyn <> 'Y' "
	vQuery = vQuery & "				group by "
	vQuery = vQuery & "					(case when d.isupchebeasong = 'Y' or d.itemid = 0 then d.makerid else '' end) "
	vQuery = vQuery & "				having "
	'vQuery = vQuery & "					sum(case when d.itemid <> 0 then d.itemno else 0 end) = sum(case when d.itemid <> 0 and (IsNull(m.code, '') in ('05') or (IsNull(m.code, '') in ('03') and d.isupchebeasong='N')) then IsNull(m.itemlackno,0) else 0 end) "
	vQuery = vQuery & "					sum(case when d.itemid <> 0 then d.itemno else 0 end) = sum(case when d.itemid <> 0 and (IsNull(m.code, '') in ('05') or IsNull(m.code, '') in ('06')) then IsNull(m.itemlackno,0) else 0 end) "
	vQuery = vQuery & "			))) "
	vQuery = vQuery & "		) "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	If not rsget.Eof Then
		refunditemcostsum = rsget("refunditemcostsum")
		refundcouponsum = rsget("refundcouponsum")
		refundallatsubtractsum = rsget("refundallatsubtractsum")
		refundbeasongpay = rsget("refundbeasongpay")
	End IF
	rsget.close

	if (remainitemcostsum < refunditemcostsum) or (remaincouponsum < refundcouponsum) or (remainbeasongpay < refundbeasongpay) then
		response.write "<script>alert('품절취소접수 할 수 없습니다.[코드번호:3-3]\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
		response.write "<script>history.back()</script>"
		dbget.close()	:	response.End
	end if

	'기타할인, 퍼센트쿠폰 당연차감
	refundrequire = refunditemcostsum - refundallatsubtractsum - refundcouponsum + refundbeasongpay

	'마일리지, 예치금, 기프트카드 제외
	'// 2018-02-22, skyer9, 마일리지 이미 빠져있음.
	remainsubtotalprice = remainsubtotalprice - 0 - remaindepositsum - remaingiftcardsum

	''response.write "remainsubtotalprice : " & remainsubtotalprice & "<br />"
	''dbget.close()
	''response.end

	'정액쿠폰(주문마스터에 있는 것)
	'// 2018-02-22, skyer9, 정액쿠폰 이미 안분되어 있음.
	''dim OCoupon
	''if (remainsubtotalprice < refundrequire) then
	''	set OCoupon = new CCoupon
	''	OCoupon.FRectUserID      = userid
	''	OCoupon.FRectOrderserial = orderserial
	''	OCoupon.FRectIsUsing     = "Y"   ''사용했는지여부
	''	OCoupon.FRectDeleteYn    = "N"
	''	OCoupon.getOneUserCoupon
	''	if (remaincouponsum > 0) and (OCoupon.FResultCount > 0) and (OCoupon.FOneItem.Fcoupontype <> "1") then
	''		if ((refundrequire - remainsubtotalprice) >= remaincouponsum) then
	''			refundcouponsum = remaincouponsum
	''		else
	''			refundcouponsum = (refundrequire - remainsubtotalprice)
	''		end if
	''		refundrequire = refundrequire - refundcouponsum
	''	end if
	''end if

	'마일리지
	if (remainsubtotalprice < refundrequire) then
		if (remainmileagesum > 0) then
			if ((refundrequire - remainsubtotalprice) >= remainmileagesum) then
				refundmileagesum = remainmileagesum
			else
				refundmileagesum = (refundrequire - remainsubtotalprice)
			end if
			refundrequire = refundrequire - refundmileagesum
		end if
	end if

	'기프트카드
	if (remainsubtotalprice < refundrequire) then
		if (remaingiftcardsum > 0) then
			if ((refundrequire - remainsubtotalprice) >= remaingiftcardsum) then
				refundgiftcardsum = remaingiftcardsum
			else
				refundgiftcardsum = (refundrequire - remainsubtotalprice)
			end if
			refundrequire = refundrequire - refundgiftcardsum
		end if
	end if

	'예치금
	if (remainsubtotalprice < refundrequire) then
		if (remaindepositsum > 0) then
			if ((refundrequire - remainsubtotalprice) >= remaindepositsum) then
				refunddepositsum = remaindepositsum
			else
				refunddepositsum = (refundrequire - remainsubtotalprice)
			end if
			refundrequire = refundrequire - refunddepositsum
		end if
	end if

	'==============================================================================
	'에러
	if (remainsubtotalprice < refundrequire) then
		response.write "<script>alert('품절취소접수 할 수 없습니다.[코드번호:4-1]\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
		response.write "<script>history.back()</script>"
		dbget.close()	:	response.End
	end if

	if refundrequire < 0 then
		response.write "<script>alert('품절취소접수 할 수 없습니다.[코드번호:4-2]\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
		response.write "<script>history.back()</script>"
		dbget.close()	:	response.End
	end if

	'==============================================================================
	canceltotal = refundrequire

	newasid 		= -1

	modeflag2   	= "regcsas"
	divcd       	= "A008"
	id          	= 0
	ipkumdiv    	= myorder.FOneItem.FIpkumDiv
	reguserid   	= userid
	finishuser  	= CFINISH_SYSTEM
	title       	= "[고객취소]" & GetDefaultTitle(divcd, 0, orderserial)
	gubun01     	= "C004"  ''공통
	gubun02     	= "CD05"  ''품절
	ScanErr = ""

	contents_jupsu  = ""
	contents_finish = ""
	isCsMailSend 	= "on"

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
			id = RegCSMaster(divcd, orderserial, reguserid, title, contents_jupsu, gubun01, gubun02)
		end if

		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "002"
			'' CS Detail 접수
			Call RegWebCSDetailStockoutCancel(id, orderserial)
		end if

		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "003"
			'' 환불 관련정보 (선)저장

			'// 언제나 등록한다. 2019-01-10, skyer9
			''if (refundrequire<>"0") and (returnmethod<>"R000") then
				refundcouponsum = refundcouponsum * -1
				refundmileagesum = refundmileagesum * -1
				refundgiftcardsum = refundgiftcardsum * -1
				refunddepositsum = refunddepositsum * -1

				'CS Master 환불 관련정보 저장	''# RegCSMasterRefundInfo, AddCSMasterRefundInfo -> /cscenter/lib/csAsfunction.asp
				Call RegCSMasterRefundInfo(id, returnmethod, refundrequire , orgsubtotalprice, orgitemcostsum, orgbeasongpay , orgmileagesum, orgcouponsum, orgallatdiscountsum  , canceltotal, refunditemcostsum, refundmileagesum, refundcouponsum, refundallatsubtractsum*-1, refundbeasongpay, refunddeliverypay, refundadjustpay , rebankname, rebankaccount, rebankownername, paygateTid)
				Call AddCSMasterRefundInfo(id, orggiftcardsum, orgdepositsum, refundgiftcardsum, refunddepositsum)

				'''계좌 암호화 추가.
				Call EditCSMasterRefundEncInfo(id, encmethod, rebankaccount)
			''end if
		End if

		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "005"

			CancelValidResultMessage = GetPartialCancelRegValidResult(id, orderserial)

			if (CancelValidResultMessage <> "") then
				ScanErr = CancelValidResultMessage
			end if
		End If

		'출고완료 또는 취소된 상품이 있을 경우, 진행정지(주문취소 불가)
		'출고완료된 상품은 반품만 가능하다.
		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "006"

			''출고 완료 또는 취소된 내역이 있는지 확인
			if Not (IsCancelValidState(id, orderserial)) then
				dbget.RollBackTrans
				response.write "<script>alert('품절취소접수 할 수 없습니다.[코드번호:5]\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
				response.write "<script>history.back()</script>"
				dbget.close()	:	response.End
			end if
		end if

		'' 완료처리 바로 진행할지 검토
		'' 업체 확인중 상태가 있는경우 - > 접수로만 진행
		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "007"
			contents_finish = ""
		End If

		ResultMsg = ResultMsg + "->. [주문 취소 CS] 접수\n\n"

		'' 완료처리 프로세스
		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "008"

			Call CancelProcess(id, orderserial, false)

			ResultMsg = ResultMsg + "->. 주문건 취소 완료\n\n"
		End IF

		''순서?. 위로?
		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "009"

			'환불 정보가 있는지 체크 후 무통장환불/마일리지환불/신용카드취소 CS 접수 등록
			newasid = CheckNRegRefund(id, orderserial,reguserid)

			If (newasid>0) then
				ResultMsg = ResultMsg + "->. 환불 접수 완료\n\n"
			end if
		End If

		If (Err.Number = 0) and (ScanErr="") Then
			errcode = "010"

			Call FinishCSMaster(id, CFINISH_SYSTEM, contents_finish)

			ResultMsg = ResultMsg + "->. [주문 취소 CS] 완료 처리\n\n"
		End If

		If (Err.Number = 0) and (ScanErr="") Then
			dbget.CommitTrans

			response.write "<script>alert('품절취소접수가 완료 되었습니다.')</script>"
			response.write "<script>location.href='/my10x10/order/myorderlist.asp';</script>"
			dbget.close()	:	response.End
		Else
			dbget.RollBackTrans
			response.write "<script>alert('품절취소접수 할 수 없습니다.[99-"&errcode&"]\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다.')</script>"
			response.write "<script>history.back()</script>"
			dbget.close()	:	response.End
		End If
	On error Goto 0
end if

set myorder = Nothing
set myorderdetail = Nothing
''set OCoupon = Nothing

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
