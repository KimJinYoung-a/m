<%@  codepage="65001" language="VBScript" %>
<% option explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

response.Charset = "utf-8"
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<%
	Dim vMode, CsAsID, vQuery, vResultCount, vAlert, vUserID
	vMode	= requestCheckVar(request("mode"),10)
	CsAsID 	= requestCheckVar(request("CsAsID"),10)
	vUserID	= getEncLoginUserID

	If vMode = "" Then
		dbget.close()
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');window.close();</script>"
		Response.End
	End IF

	If CsAsID = "" OR IsNumeric(CsAsID) = false Then
		dbget.close()
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');window.close();</script>"
		Response.End
	End IF

	'####### 여러 mode 가 생길지 모르니 mode 값을 받고 If로 각각 처리. 2011-08-04 강준구.

	If vMode = "delete" Then	'### 반품접수 철회
		vQuery = "UPDATE [db_cs].[dbo].tbl_new_as_list SET " & _
				 "		deleteyn = 'Y', " & _
				 "		finishuser = '" & CHKIIF(vUserID="","system",vUserID) & "', " & _
				 "		finishdate = getdate(), " & _
				 "		contents_finish = '" & CHKIIF(vUserID="","비회원 고객 직접 취소","고객 직접 취소") & "' " & _
				 "	WHERE " & _
				 "		id = '" & CsAsID & "' AND currstate < 'B006' "

		dbget.Execute vQuery, vResultCount

		If vResultCount < 1 Then
			vAlert = "반품접수 철회를 처리하는데 문제가 발생했습니다.\n자세한 문의는 고객센터 Tel.1644-6030 으로 연락을 주시기 바랍니다."
		Else
			vAlert = "반품접수 철회가 되었습니다."

			'// 이전 처리자 아이디 저장
			Call SaveCSListHistory(CsAsID)
		End If
	ElseIf vMode="editRefund" Then
		Dim reBankAame, reBankAccount, reBankOwnerName, encmethod, currstate, sqlStr
		reBankAame 	= requestCheckVar(request("rebankname"),32)
		reBankAccount 	= requestCheckVar(request("rebankaccount"),32)
		reBankOwnerName 	= requestCheckVar(request("rebankownername"),32)

        sqlStr = " select top 1 currstate"
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_new_as_list"
        sqlStr = sqlStr + " where id='" & CStr(CsAsID) & "'" + VbCrlf
        rsget.Open sqlStr,dbget,1
        If Not rsget.Eof Then
        	currstate = rsget("currstate")
        End If
        rsget.Close

		If currstate="B001" Then
			encmethod 			= ""
			If (rebankaccount <> "") Then
				encmethod = "AE2" ''"PH1"
			End If
			Call EditCSMasterRefundEncInfo(CsAsID, encmethod, reBankAccount)

			vQuery = "UPDATE [db_cs].[dbo].tbl_as_refund_info SET " & _
					" rebankname = '" & reBankAame & "'" & _
					" ,rebankownername='" & reBankOwnerName & "'" & _
					" WHERE asid = '" & CsAsID & "'"
			dbget.Execute vQuery, vResultCount
			If vResultCount < 1 Then
				vAlert = "환불 정보 업데이트를 처리하는데 문제가 발생했습니다.\n자세한 문의는 고객센터 Tel.1644-6030 으로 연락을 주시기 바랍니다."
			Else
				vAlert = "환불 정보가 저장 되었습니다."

				vQuery = "UPDATE [db_cs].[dbo].tbl_new_as_list SET " & _
				 		"		writeuser = '" & CHKIIF(vUserID="","system",vUserID) & "' " & _
				 		"	WHERE " & _
				 		"		id = '" & CsAsID & "' AND currstate = 'B001' "
				dbget.Execute vQuery, vResultCount

				'// 이전 처리자 아이디 저장
				Call SaveCSListHistory(CsAsID)
			End If
		Else
			vAlert = "환불 접수 상태가 아닙니다.\n자세한 문의는 고객센터 Tel.1644-6030 으로 연락을 주시기 바랍니다."
		End If
	End If
%>

<script language="javascript">
	alert("<%=vAlert%>");
	document.location.href='/apps/appCom/wish/web2014/my10x10/order/order_cslist.asp';
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->
