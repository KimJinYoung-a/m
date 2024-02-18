<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
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

	dim sqlStr, loginid, evt_code, releaseDate, evt_option, strsql , evt_option1 , evt_option2 , evt_option3
	Dim kit , coupon3 , coupon5 , arrList , i, mylist
	dim usermail, couponkey

	IF application("Svr_Info") = "Dev" THEN
		evt_code 		= "21193"
	Else
		evt_code 		= "52391"
	End If

	evt_option2 = requestCheckVar(Request("spoint"),1)
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
	sqlStr = "Select evt_startdate, evt_enddate " &VBCRLF
	sqlStr = sqlStr & " From db_event.dbo.tbl_event " &VBCRLF
	sqlStr = sqlStr & " WHERE evt_code='" & evt_code & "'"
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

	Dim cnt , totalsum

	'하루 1회 중복 응모 확인
	sqlStr="Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code='" & evt_code & "'" &_
			" and userid='" & loginid & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
	rsget.Open sqlStr,dbget,1
	cnt=rsget(0)
	rsget.Close

	'토탈 3회 중복 응모 확인
	sqlStr="Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code='" & evt_code & "'" &_
			" and userid='" & loginid & "'"
	rsget.Open sqlStr,dbget,1
	totalsum=rsget(0)
	rsget.Close

	If cnt = 0 Then
		If totalsum < 3 then
			sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &VBCRLF
			sqlStr = sqlStr &" (evt_code, userid, sub_opt2 , device) values " &VBCRLF
			sqlStr = sqlStr &" (" & evt_code & VBCRLF
			sqlStr = sqlStr &",'" & loginid & "'" &VBCRLF
			sqlStr = sqlStr &",'" & evt_option2 & "'" &VBCRLF
			sqlStr = sqlStr &",'M')"
			'response.write sqlstr
			dbget.execute(sqlStr)

			response.write "<script>" &_
				"alert('응모가 완료 되었습니다.\n남은 응모 횟수 : "& 3-(totalsum+1) &" 회 \n당첨자 발표일은 6월 16일 입니다.');" &_
				"top.location.href='/event/eventmain.asp?eventid=52392';" &_
				"</script>"
			dbget.close()	:	response.End
		Else
			Response.write "<script>" &_
				"alert('최대 3회 응모 가능합니다.');" &_
				"top.location.href='/event/eventmain.asp?eventid=52392';" &_
				"</script>"
			response.End
		End If 
	Else
		Response.write "<script>" &_
				"alert('하루에 1번 응모 가능합니다.\n남은 응모 횟수 : "& 3-totalsum &" 회');" &_
				"top.location.href='/event/eventmain.asp?eventid=52392';" &_
				"</script>"
		response.End	
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->