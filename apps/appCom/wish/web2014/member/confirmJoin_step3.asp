<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

Dim strKey, rstKey, txUserid, cnfIdx, sqlStr
Dim cfmChk, cfmRdt, cfmPF, cfmEF, chkStat
'전송된 인증키
strKey = requestCheckVar(Request("strKey"),128)

On Error Resume Next
	rstKey = tenDec(strKey)
	rstKey = split(rstKey,"||")

	txUserid = rstKey(0)
	cnfIdx = rstKey(1)

	If Err.Number Then
		Call Alert_Move("잘못된 키값입니다.","/")
		dbget.close(): response.End
	end if
on error Goto 0

'// 인증기록 접수
	sqlStr = "Select isConfirm, regdate, pFlag, evtFlag From db_log.dbo.tbl_userConfirm Where idx='" & getNumeric(cnfIdx) & "' and userid='" & txUserid & "'"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		cfmChk = rsget("isConfirm")
		cfmRdt = rsget("regdate")
		cfmPF = rsget("pFlag")
		cfmEF = rsget("evtFlag")
	end if
	rsget.close

'// 회원상태 접수
	sqlStr = "Select userStat From db_user.dbo.tbl_user_n Where userid='" & txUserid & "'"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkStat = rsget("userStat")
	end if
	rsget.close

	if cfmChk="" then
		Call Alert_Move("잘못된 키값입니다.","/")
		dbget.close(): response.End
	end if

	if cfmChk="Y" then
		'# 세션에 아이디 저장
		Session("sUserid") = txuserid

		if chkStat="N" then
			'신규가입 승인시
			if cfmPF="O" then
				Call Alert_Move("가입승인이 완료되었습니다.","/offshop/point/complete.asp")
			else
				Call Alert_Move("가입승인이 완료되었습니다.","/apps/appcom/wish/web2014/member/join_welcome.asp")
			end if
		else
			'기존회원 승인시
			Call Alert_Move("승인이 완료되었습니다.","/")
		end if
		dbget.close(): response.End
	end if

	if datediff("h",cfmRdt,now())>12 then
		if chkStat="N" then
			'신규가입 승인시
			Call Alert_Move("가입승인 시간이 경과되었습니다.\n재가입 부탁드립니다. ","/apps/appcom/wish/web2014/member/join.asp")
		else
			'기존회원 승인시
			Call Alert_Move("승인 유효시간이 경과되었습니다.\n다시 승인 요청해주세요.","/")
		end if
		dbget.close(): response.End
	end if

On Error Resume Next
dbget.beginTrans
'// 회원 정보 변경(인증처리)
	'# 인증기록 변경
	sqlStr = "Update db_log.dbo.tbl_userConfirm Set isConfirm='Y', confDate=getdate() Where idx=" & CnfIdx
	dbget.execute(sqlStr)

	'# 회원정보 변경
	sqlStr = "Update db_user.dbo.tbl_user_n Set userStat='Y', isEmailChk='Y' Where userid='" & txUserid & "'"
	dbget.execute(sqlStr)
	
	
	If Err.Number = 0 Then
		'// 처리 완료
		dbget.CommitTrans
	
		'# 세션에 아이디 저장
		Session("sUserid") = txuserid

		'# 인증완료
		if chkStat="N" then
			'신규가입 승인시
			if cfmPF="O" then
				Call Alert_Move("가입승인이 완료되었습니다.","/offshop/point/complete.asp")
			else
				Call Alert_Move("가입승인이 완료되었습니다.","/apps/appcom/wish/web2014/member/join_welcome.asp?eFlg="&cfmEF)
			end if
		else
			'기존회원 승인시
			Call Alert_Move("승인이 완료되었습니다.","/")
		end if

	Else
		'//오류가 발생했으므로 롤백
		dbget.RollBackTrans
		Call Alert_Move("처리중 오류가 발생했습니다.\n다시 시도해주세요.","/")
	End If
on error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->