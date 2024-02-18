<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	dim refer
	refer = request.ServerVariables("HTTP_REFERER")

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		response.end
	end If
	
	dim sqlStr, loginid, evt_code, releaseDate, evt_option, evt_option1, strsql
	Dim kit , coupon3 , coupon5 , arrList , i, mylist
	dim usermail, couponkey
	evt_code = requestCheckVar(Request("evt_code"),32)		'이벤트 코드
	evt_option1 = requestCheckVar(Request("uphone"),32)		'이벤트 코드
	loginid = GetLoginUserID()

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script language='javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end If

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"top.location.href='/event/eventmain.asp?eventid="& evt_code &"';" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'응모 처리
	'중복 응모 확인
	Dim cnt
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code='" & evt_code & "'" &_
			" and userid='" & loginid & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
	rsget.Open sqlStr,dbget,1
	cnt = rsget(0)
	rsget.Close

	If cnt >= 1 Then
	response.write "<script type='text/javascript'>" &_
					"alert('하루에 한 번 응모 가능합니다.\n\n내일 다시 응모해주세요.');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & evt_code& "';" &_
					"</script>"

	else
		'이벤트 정상응모
		'키트 당첨
			sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
					" (evt_code, userid, sub_opt1) values " &_
					" (" & evt_code &_
					",'" & loginid & "'" &_
					",'" & evt_option1 & "')"
					'response.write sqlstr
			dbget.execute(sqlStr)

			response.write "<script type='text/javascript'>" &_
				"alert('응모 되었습니다.\n당첨자 발표일은 10월 23일 입니다.');" &_
				"top.location.href='/event/eventmain.asp?eventid=" & evt_code& "';" &_
				"</script>"
			dbget.close()	:	response.End
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->