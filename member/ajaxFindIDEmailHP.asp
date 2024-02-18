<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'// 유효 접근 주소 검사 //
dim refer, refip, recentqcount
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	response.write "<script type='text/javascript'>alert('유효하지 못한 접근입니다.');</script>ERROR"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

dim sName, sEmail, sCell
sName = requestCheckVar(Request.form("nm"),32)
sEmail = requestCheckVar(Request.form("mail"),128)
sCell = requestCheckVar(Request.form("cell"),18)

if sName="" or (sEmail="" and sCell="") then
	response.write "<script type='text/javascript'>alert('검색 파라메터 오류.');</script>ERROR"	'--파라메터 없음
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
	response.write "<script type='text/javascript'>$('#lyrResultIDBtn').hide();alert('같은 아이피로 단시간 내에 연속으로 여러번 접속하였습니다.\n잠시 후 다시 시도해주세요.');</script><li>잠시 후 다시 시도해주세요.</li>"
	dbget.close(): response.End
else
	''조회로그저장.
	sqlStr = "insert into [db_log].[dbo].tbl_user_search_log"
	sqlStr = sqlStr + " (searchname,searchuid,searchuno,refip)"
	sqlStr = sqlStr + " values("
	sqlStr = sqlStr + " '" + LEFT(sName,1) + "**'"
	sqlStr = sqlStr + " ,''"
	if sEmail<>"" then
		sqlStr = sqlStr + " ,'" + left(sEmail,3) + "**'"
	else
		sqlStr = sqlStr + " ,'" + left(sCell,5) + "**'"
	end if
	sqlStr = sqlStr + " ,'" + refip + "'"
	sqlStr = sqlStr + " )"
	dbget.Execute(sqlStr)
end if

'// 아이디 찾기
dim sqlStr
sqlStr = "EXEC [db_user_Hold].[dbo].[usp_WWW_FindUserid_Get] '" & sName & "','" & sEmail & "','" & sCell & "'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

if Not rsget.Eof then
	Do Until rsget.EOF
		'#회원대기구분에 따라 아이디 별표처리 (일단 구분없이 추후 변경 가능)
		'if isNull(rsget("userStat")) then
			Response.Write "<li><strong>" & printUserId(rsget("userid"),2,"*") & "</strong> (" & left(FormatDateTime(rsget("regdate"),1),len(FormatDateTime(rsget("regdate"),1))-4) & ")</li>"
		'else
		'	Response.Write "<li>" & rsget("userid") & " (" & left(FormatDateTime(rsget("regdate"),1),len(FormatDateTime(rsget("regdate"),1))-4) & ")</li>"
		'end if
	rsget.MoveNext
	Loop
	'확인버튼 표시(2015.09.02; 허진원)
	Response.Write "<script type='text/javascript'>$('#lyrResultIDBtn').show();</script>"

	'전체 아이디 확인용 정보 서버세션에 저장
	session("findIDName") = sName
	session("findIDCell") = sCell
	session("findIDMail") = sEmail
	
	
else
	Response.Write "<script type='text/javascript'>$('#lyrResultIDBtn').hide();alert('입력하신 정보와 일치하는 아이디가 없습니다.');</script><li>* 입력하신 정보와 일치하는 아이디가 없습니다. 다시 입력 부탁드립니다.</li>"

	'전체 아이디 확인용 정보 세션 정리
	session.contents.remove("findIDName")
	session.contents.remove("findIDCell")
	session.contents.remove("findIDMail")
end if
rsget.Close
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->