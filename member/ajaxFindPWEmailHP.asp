<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'// 유효 접근 주소 검사 //
dim refer, refip, recentqcount
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	response.write " (유효하지 못한 접근입니다.)"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

dim sUserid, sName, sEmail, sCell
sUserid = requestCheckVar(Request.form("id"),32)
sName = requestCheckVar(Request.form("nm"),32)
sEmail = requestCheckVar(Request.form("mail"),128)
sCell = requestCheckVar(Request.form("cell"),18)

if sUserid="" or sName="" or (sEmail="" and sCell="") then
	response.write " (검색 파라메터 오류)"	'--파라메터 없음
	dbget.close(): response.End
end if

'// 로그 저장/검색 제한
refip = request.ServerVariables("REMOTE_ADDR")

'// 최근 15분간 5번 제한
sqlStr = "select count(idx) as cnt "
sqlStr = sqlStr + " from [db_log].[dbo].tbl_user_search_log "
sqlStr = sqlStr + " where refip='" + refip + "' "
sqlStr = sqlStr + " and datediff(n,regdate,getdate())<=15"

rsget.Open sqlStr, dbget, 1
	recentqcount = rsget("cnt")
rsget.close

if recentqcount>=5 then
	response.write "같은 아이피로 단시간 내에 연속으로 여러번 접속하였습니다. 잠시 후 다시 시도해주세요."
	dbget.close(): response.End
else
	''조회로그저장.
	sqlStr = "insert into [db_log].[dbo].tbl_user_search_log"
	sqlStr = sqlStr + " (searchname,searchuid,searchuno,refip)"
	sqlStr = sqlStr + " values("
	sqlStr = sqlStr + " '" + LEFT(sName,1) + "**'"
	sqlStr = sqlStr + " ,'" + sUserid + "'"
	if sEmail<>"" then
		sqlStr = sqlStr + " ,'" + left(sEmail,3) + "**'"
	else
		sqlStr = sqlStr + " ,'" + left(sCell,5) + "**'"
	end if
	sqlStr = sqlStr + " ,'" + refip + "'"
	sqlStr = sqlStr + " )"
	dbget.Execute(sqlStr)
end if

'// 패스워드 찾기 (인증받은 고객 제한)
dim sqlStr, addSql, chkRst, bEm, bMb, userDiv

sqlStr = "EXEC [db_user_Hold].[dbo].[usp_WWW_FindUseridPw_Get] '" & sName & "','" & sEmail & "','" & sCell & "','" & sUserid & "'" 
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

if Not(rsget.EOF or rsget.BOF) then
	chkRst=true
	bEm = rsget("isEmailChk")
	bMb = rsget("isMobileChk")
	userDiv = rsget("userDiv")
else
	chkRst=false
end if
rsget.Close

if chkRst then
	'// 인증수단 확인
	if bEm="N" and bMb="Y" and sEmail<>"" then
		response.write "3"		'이메일 인증자 아님
		dbget.close(): response.End
	elseif bEm="Y" and bMb="N" and sCell<>"" then
		response.write "4"		'휴대폰 인증자 아님
		dbget.close(): response.End
	end if

	'// SNS 간편로그인 가입회원 확인
	if userDiv="05" then
		response.write "6"		'휴대폰 인증자 아님
		dbget.close(): response.End
	end if

	'// 회원 정보 일치 (임시비번 발급 후 요청 수단으로 발송)
	dim strRdm
	strRdm = RandomStr()
	call setTempPassword(sUserid,strRdm)

	if sEmail<>"" then
		'### 이메일로 발송
	    call sendmailsearchpass(sEmail,sName,strRdm) 
	    Response.Write "1"
	else
		'### SMS로 발송
		dim cSMS
		set cSMS = New CSMSClass
		cSMS.sendSMSUserPassword sCell,strRdm
		set cSMS = Nothing
		Response.Write "2"
	end if
else
	'//일치 아이디 없음
	Response.Write "5"
end if

'------------------------------------------------
'//임시번호 생성
function RandomStr()
    dim str, strlen
    dim rannum, ix
    
    str = "abcdefghijklmnopqrstuvwxyz0123456789"
    strlen = 6
    
    Randomize
    
    For ix = 1 to strlen
    	 rannum = Int((36 - 1 + 1) * Rnd + 1)
    	 RandomStr = RandomStr + Mid(str,rannum,1)
    Next
end Function

'//회원비번 수정
sub setTempPassword(userid,strRdm)
    dim sqlStr
    dim Enc_userpass, Enc_userpass64
    
    Enc_userpass = MD5(CStr(strRdm))
    Enc_userpass64 = SHA256(MD5(CStr(strRdm)))
    
    
    '##########################################################
    '임시비밀번호로 변경
    sqlStr = " update [db_user].[dbo].[tbl_logindata]" + vbCrlf
    sqlStr = sqlStr + " set userpass=''" + vbCrlf
    sqlStr = sqlStr + " ,Enc_userpass=''" + vbCrlf
    sqlStr = sqlStr + " ,Enc_userpass64='" + Enc_userpass64 + "'" + vbCrlf
    sqlStr = sqlStr + " where userid='" + userid + "'"
    dbget.Execute(sqlStr)
    
    '##########################################################
end sub
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->