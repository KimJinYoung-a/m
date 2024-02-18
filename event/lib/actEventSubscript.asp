<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
	dim sqlStr, loginid, evt_code, releaseDate, evt_opt1, evt_opt2, evt_opt3, flgChkOpt
	evt_code = requestCheckVar(Request("evt_code"),32)		'이벤트 코드
	evt_opt1 = requestCheckVar(Request("evt_option"),20)	'이벤트 선택사항1
	evt_opt2 = requestCheckVar(Request("evt_option2"),8)	'이벤트 선택사항2
	evt_opt3 = requestCheckVar(Request("evt_option3"),128)	'이벤트 선택사항3
	flgChkOpt = requestCheckVar(Request("flgChkOpt"),3)		'옵션 중복 검사방법(000:검사안함, 100:옵션1검사, 101:옵션1/3검사, 111:모든옵션검사)
	loginid = GetLoginUserID()
	releaseDate = requestCheckVar(Request("releaseDate"),42)
	if releaseDate="" then releaseDate = "공지된 날짜에"
	if len(flgChkOpt)<3 then flgChkOpt="000"

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"{""result"":""01""," &_
						"""message"":""존재하지 않는 이벤트입니다.""}"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"{""result"":""02""," &_
						"""message"":""죄송합니다. 이벤트 기간이 아닙니다.""}"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"{""result"":""03""," &_
						"""message"":""이벤트에 응모를 하려면 로그인이 필요합니다.""}"
		dbget.close()	:	response.End
	end if

	'// 이벤트 응모 //
	
	'중복 응모 확인
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code=" & evt_code &_
			" and userid='" & loginid & "'"

		'옵션중복검사
		if Mid(flgChkOpt,1,1)="1" then sqlStr = sqlStr & " and sub_opt1='" & evt_opt1 & "'"
		if Mid(flgChkOpt,2,1)="1" then sqlStr = sqlStr & " and sub_opt2='" & evt_opt2 & "'"
		if Mid(flgChkOpt,3,1)="1" then sqlStr = sqlStr & " and sub_opt3='" & evt_opt3 & "'"

	rsget.Open sqlStr,dbget,1
	if rsget(0)>0 then
		Response.Write	"{""result"":""04""," &_
						"""message"":""이미 응모하셨습니다.\n\n※당첨자는 " & releaseDate & " 발표합니다.""}"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'응모 처리
	sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
			" (evt_code, userid, sub_opt1, sub_opt2, sub_opt3) values " &_
			" (" & evt_code &_
			",'" & loginid & "'" &_
			",'" & evt_opt1 & "'" &_
			",'" & evt_opt2 & "'" &_
			",'" & evt_opt3 & "')"
	dbget.execute(sqlStr)
	Response.Write	"{""result"":""00""," &_
					"""message"":""이벤트에 응모되었습니다.\n\n※당첨자는 " & releaseDate & " 발표합니다.""}"
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->