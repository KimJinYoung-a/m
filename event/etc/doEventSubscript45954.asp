<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'#######################################################
'	History	:  2013.04.14 허진원 생성
'#######################################################


dim eCode , userid , i , sub_opt1, sub_opt2
	sub_opt1 = requestCheckVar(request("sub_opt1"),11)
	sub_opt2 = requestCheckVar(request("sub_opt2"),1)
	userid = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  20975	'모바일 20978
	Else
		eCode   =  45886	'모바일 45954
	End If

'로그인체크
if userid = "" then
	response.write "<script>"
	response.write "alert('로그인해주세요');"
	response.write "</script>"
	response.end
end if

'이벤트코드 확인
if sub_opt1="" or sub_opt2="" then
	response.write "<script>"
	response.write "alert('잘못된 전송값입니다.');"
	response.write "</script>"
	response.end
end if

dim sql , cnt

	'유효 주문번호 확인
	sql = "select count(orderserial) as cnt " &_
		" from db_order.dbo.tbl_order_master " &_
		" where regdate between '2012-10-10 00:00:00.000' and '2013-10-22 00:00:00.000' " &_
		" 	and ipkumdiv>3 " &_
		" 	and cancelyn='N' " &_
		" 	and userid='" & userid & "' " &_
		" 	and jumundiv<>'9' " &_
		" 	and orderserial='" & sub_opt1 & "'"
		rsget.open sql,dbget,1
		if not rsget.EOF  then
		  cnt = rsget("cnt")
		end if
		rsget.close

		if cnt=0 then
			response.write "<script>"
			response.write "alert('잘못된 주문번호입니다.');"
			'response.write "parent.location.reload();"
			response.write "</script>"
			response.end
		end if

	'중복응모 검사
		sql = "select count(userid) as cnt from db_event.dbo.tbl_event_subscript where userid='"&userid&"' and evt_code = "&eCode&" and sub_opt1='" & sub_opt1 & "'"
		rsget.open sql,dbget,1
		if not rsget.EOF  then
		  cnt = rsget("cnt")
		end if
		rsget.close

		'//중복처리
		if cnt <> 0 then
			response.write "<script>"
			response.write "alert('이미 참여 하셨습니다.');"
			'response.write "parent.location.reload();"
			response.write "</script>"
			response.end
		end if

		'//내용 저장
		sql = "insert into db_event.dbo.tbl_event_subscript (evt_code,sub_opt1,sub_opt2,userid) values"
		sql = sql & "("
		sql = sql & " "& eCode &" , '"& sub_opt1 & "','" & sub_opt2 &"','" &userid &"'"
		sql = sql & ")"

		dbget.execute sql
%>
<script>
	alert('참여해 주셔서 감사합니다.\n당첨자는 10월24일(목)에 발표합니다.');
	parent.location.reload();
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->

