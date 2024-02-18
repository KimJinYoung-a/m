<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'// 유효 접근 주소 검사 //
dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	response.write "-ERR.01"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

' -------------------------------------------------
'  아이디를 받아 유효한 정보인지 확인 후 SMS 발송
' -------------------------------------------------
dim txUserId, txUserHP, chkStat, joinDt, sqlStr
dim sRndKey, sLatency

	txUserId = requestCheckVar(Request.form("id"),32)	' 사용자 아이디 입력 받음
	txUserHP = requestCheckVar(Request.form("ph"),13)

	If txUserId="" Then 
		response.write "잘못된 접근입니다."
		dbget.close(): response.End
	end if

	'국내 휴대폰 번호인지 확인
	if Not(left(txUserHP,3)="010" or left(txUserHP,3)="011" or left(txUserHP,3)="016" or left(txUserHP,3)="017" or left(txUserHP,3)="018" or left(txUserHP,3)="019") then
		response.write "대한민국 통신사의 휴대폰번호만 인증을 받으실 수 있습니다."
		dbget.close(): response.End
	end if

	'// 회원 여부 확인
	sqlStr = "Select count(userid) From db_user.dbo.tbl_user_n Where userid='" & txUserid & "'"
	rsget.Open sqlStr,dbget,1
	if rsget(0) > 0 then
		rsget.close
		response.write "이미 가입된 아이디입니다."
		dbget.close(): response.End
	end if
	rsget.close


	'// 폰번호 중복 확인 (5개 중복까지 가능; 2015.05.06 허진원)
	sqlStr = "Select count(userid) From db_user.dbo.tbl_user_n Where usercell='" & txUserHP & "'"
	rsget.Open sqlStr,dbget,1
	if rsget(0) > 5 then
		rsget.close
		response.write "이미 가입된 휴대폰 번호입니다."
		dbget.close(): response.End
	end if
	rsget.close
	

	'# 유효 인증 대기값이 있는지 확인(100초 이내 / 확인은 120초까지 유효)
	sqlStr = "Select top 1 smsCD, datediff(s,regdate,getdate()) as latency From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and confDiv='S' and isConfirm='N' and datediff(s,regdate,getdate())<=120 order by idx desc "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		sRndKey = rsget("smsCD")
		sLatency = rsget("latency")
	end if
	rsget.close

	if sRndKey<>"" then
		'// 2분 이내에는 재발송 없음(SPAM 등에 걸리지 않는 이상 거의 대부분 늦게라도 전송됨)
		if sLatency >= 60 then
			response.write "1분 후에 다시 시도해주세요."
		else
			response.write "2분 후에 다시 시도해주세요."
		end if
		dbget.close(): response.End
	else
		'//신규발송

		'# sRndKey값 생성
		randomize(time())
		sRndKey=Num2Str(left(round(rnd*(1000000)),6),6,"0","R")

		'# 인증 로그에 저장
		sqlStr = "insert into db_log.dbo.tbl_userConfirm (userid, confDiv, usercell, smsCD, pFlag, evtFlag) values ("
		sqlStr = sqlStr + " '" & txuserid & "'"
		sqlStr = sqlStr + " ,'S'"
		sqlStr = sqlStr + " ,'" & txUserHP & "'"
		sqlStr = sqlStr + " ,'" & sRndKey & "'"
		sqlStr = sqlStr + " ,'T','N'"
		sqlStr = sqlStr + " )"
		dbget.execute(sqlStr)
		
		'# 인증 SMS 발송
		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) values " &_
		'		" ('" & txUserHP & "'" &_
		'		" ,'1644-6030','1',getdate()" &_
		'		" ,'인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐')"
		
		''2015/08/16 수정 - 2021.10.28 정태훈 수정 카톡 -> sms 원복
	 	sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '" & txUserHP & "','1644-6030','인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐'"
	 	dbget.execute(sqlStr)

		''2018/01/22 수정; 허진원 카카오 알림톡으로 전송
		'if txUserHP="010-7742-3094" then
		'	sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '" & txUserHP & "','1644-6030','인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐'"
	 	'	dbget.execute(sqlStr)
		'else
		'	Call SendKakaoMsg_LINK(txUserHP,"1644-6030","S0001","[텐바이텐] 고객님의 인증번호는 [" & sRndKey & "]입니다.","SMS","","인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐","")
		'end if
		'response.write "카카오톡이나 SMS로 받으신 인증번호를 입력해주세요."
		response.write "SMS로 받으신 인증번호를 입력해주세요."
		dbget.close(): response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->