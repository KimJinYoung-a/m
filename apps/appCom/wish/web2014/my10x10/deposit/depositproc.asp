<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<%
	Dim vUserID, vUserName, oTenCash, vReturnCash, vCurrentDeposit, vDivCD, vReturnMethod, vBankName, vBankAccount, vBankOwnerName, vTitle, vRegUserID, vCSID, vOrderSerial
	Dim vQuery, vOpenerRe, vIsOK, vErr

    vUserID = getEncLoginUserID
    vUserName = getLoginUserName
	vReturnCash		= requestCheckvar(Request("returncash"),10)
	vDivCD			= "A003"	'### CS 접수 - 환불접수
	vReturnMethod	= "R007"	'### 무통장
	vTitle			= "예치금을 무통장으로 환불"
	vRegUserID		= "system"
	vBankName		= requestCheckvar(Request("rebankname"),20)
	vBankAccount	= requestCheckvar(Request("rebankaccount"),20)
	vBankOwnerName	= requestCheckvar(Request("rebankownername"),10)
	vOrderSerial	= ""
	vOpenerRe		= "/apps/appcom/wish/web2014/my10x10/deposit/mydepositlist.asp"

    if instr(vBankAccount,"-") > 0 then 
        vBankAccount    = replace(vBankAccount,"-","")
    end if 
	
	If vUserID = "" Then
		Response.Write "<script>alert('아이디가 없습니다.');</script>"
        response.redirect(vOpenerRe)
		dbget.close()
		Response.End
	End IF
	
	If vReturnCash = "" OR vReturnCash = "0" Then
		Response.Write "<script>alert('환불액이 없거나 0원 입니다.');</script>"
        response.redirect(vOpenerRe)
		dbget.close()
		Response.End
	End IF
	
	If IsNumeric(vReturnCash) = false Then
		Response.Write "<script>alert('잘못된 환불금액 입니다.');</script>"
        response.redirect(vOpenerRe)
		dbget.close()
		Response.End
	End IF

	'####### 최종 적립된 주문번호 가져옴. 없으면 빈값.
	vQuery = "SELECT TOP 1 orderserial FROM [db_user].[dbo].[tbl_depositlog] WHERE userid = '" & vUserID & "' AND deleteyn = 'N' AND deposit > 0 ORDER BY orderserial DESC"
	rsget.Open vQuery,dbget,1
	If Not rsget.Eof Then
		vOrderSerial = rsget(0)
	End IF
	rsget.close()

	'####### 현시점 예치금 가져오기.
	Set oTenCash = New CTenCash
	oTenCash.FRectUserID = vUserID
	oTenCash.getUserCurrentTenCash
	vCurrentDeposit = oTenCash.Fcurrentdeposit
	Set oTenCash = Nothing
	
	If vCurrentDeposit = "0" Then
		Response.Write "<script>alert('예치금이 0원 입니다.');</script>"
        response.redirect(vOpenerRe)
		dbget.close()
		Response.End
	End IF
	
	If (CDbl(vCurrentDeposit) - CDbl(vReturnCash)) < 0 Then
		Response.Write "<script>alert('환불액이 예치금보다 큽니다.');</script>"
        response.redirect(vOpenerRe)
		dbget.close()
		Response.End
	End IF
		
    On Error Resume Next
        dbget.beginTrans

		If (Err.Number = 0) Then
			vErr = "1"
		End IF
		
		'### cs등록 후 idx 가져오기.
		'vCSID = RegCSMaster(vDivCD, orderserial, vRegUserID, vTitle, "예치금 무통장 환불", "C004", "CD99")
	    '' CS Master 저장
	    'userid 등 다른 내용도 같이 저장을 하려고 RegCSMaster 이 함수를 풀어서 수정하여 저장.
	    Dim sqlStr
	    sqlStr = " select * from [db_cs].[dbo].tbl_new_as_list where 1=0 "
	    rsget.Open sqlStr,dbget,1,3
	    rsget.AddNew
	        rsget("divcd")          = vDivCD
	    	rsget("customername")   = vUserName
	    	rsget("userid")         = vUserID
	    	rsget("writeuser")      = vRegUserID
	    	rsget("title")          = vTitle
	    	rsget("contents_jupsu") = "예치금 무통장 환불"
	    	rsget("gubun01")        = "C004"
	    	rsget("gubun02")        = "CD99"
	    	rsget("currstate")      = "B001"
	    	rsget("deleteyn")       = "N"
	    	rsget("opentitle")      = "환불"
	    	rsget("opencontents")   = ""
	    	rsget("orderserial")   	= vOrderSerial
	    rsget.update
		    vCSID = rsget("id")
		rsget.close

		'### 무통장 환불 insert.
		If (Err.Number = 0) Then
			vErr = "2"
		End IF
        Call RegCSMasterRefundInfo(vCSID, vReturnMethod, vReturnCash, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, vBankName, vBankAccount, vBankOwnerName, "0")

		If (Err.Number = 0) Then
			vErr = "3"
		End IF
        Call AddCSMasterRefundInfo(vCSID, 0, 0, 0, 0)

        '### 계좌 암호화 추가.
		If (Err.Number = 0) Then
			vErr = "4"
		End IF
        Call EditCSMasterRefundEncInfo(vCSID, "AE2", vBankAccount)

		'### 로그 저장 및 실제 예치금액 수정.
		If (Err.Number = 0) Then
			vErr = "5"
		End IF
		vQuery = "INSERT INTO [db_user].[dbo].[tbl_depositlog](userid,deposit,jukyocd,jukyo,orderserial,deleteyn,asid) " & _
				 "	VALUES('" & vUserID & "',-" & vReturnCash & ",'300','예치금 무통장 환불'," & CHKIIF(vOrderSerial<>"","'"&vOrderSerial&"'","null") & ",'N','"&vCSID&"') "
		dbget.Execute vQuery
		
		If (Err.Number = 0) Then
			vErr = "6"
		End IF
		vQuery = "UPDATE [db_user].[dbo].[tbl_user_current_deposit] SET " & VBCRLF
		vQuery = vQuery & "		currentdeposit = currentdeposit - " & vReturnCash & " " & VBCRLF
		vQuery = vQuery & "		,spenddeposit = spenddeposit + " & vReturnCash & " " & VBCRLF
		vQuery = vQuery & "	WHERE userid = '" & vUserID & "' "
		
		dbget.Execute vQuery


		If (Err.Number = 0) Then
			dbget.CommitTrans
			vIsOK = "o"
		Else
			dbget.RollBackTrans
			vIsOK = "x"
		End If
	On Error Goto 0
%>

<script type="text/javascript">
<% If vIsOK = "o" Then %>
	alert("처리되었습니다.");
<% Else %>
	alert("데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자에게 에러코드 <%=vErr%> 과 함께 문의 요망.");
<% End IF %>
<%
    response.redirect(vOpenerRe)
    response.end
%>	
</script>