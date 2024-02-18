<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 텐바이텐X호로요이 응모 액션페이지
' History : 2018-12-05 최종원
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, chasu
	dim vIsApp

	'1차, 2차 이벤트 구분
	if date() < "2018-12-25" then
		chasu = 1
	Else
		chasu = 2	
	end if		

	IF application("Svr_Info") = "Dev" THEN
		eCode = "90200"
	Else
		eCode = "90905"
	End If

	mode 			= request("mode")
	currenttime 	= date()
	LoginUserid		= getencLoginUserid()
	refer 			= request.ServerVariables("HTTP_REFERER")
	vIsApp			= request("vIsApp")

	function dispScript(vEvtcode, vResultParam)	
		dim alertMsg
		Select Case vResultParam		
			Case "1"			
				alertMsg = "alert('이벤트 참여기간이 아닙니다.');" 				
			Case "2"
				alertMsg = "alert('로그인을 하셔야합니다.');" 				
			Case "3"
				alertMsg = "alert('성인만 참여 가능한 이벤트입니다.');"				
			Case "5"
				alertMsg = "alert('이미 응모하셨습니다. 당첨일을 기대해주세요!');"
			case "0"	
				alertMsg = ""
		end Select

		if vIsApp = "1" then
			dispScript = "<script language='javascript'>"&alertMsg&" location.href='"& wwwUrl &"/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&vEvtcode&"&resultParam="&vResultParam&"';</script>"
		else
			dispScript = "<script language='javascript'>"& alertMsg &" location.href='/event/eventmain.asp?eventid="&vEvtcode&"&resultParam="&vResultParam&"';</script>"
		end if
	end function	

	device = "M"

if mode = "regAlram" then '2차 응모 알람
	'알림 응모 여부 체크 
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt2 = '1' "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt2)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '1')"
		dbget.execute sqlstr

		Response.write "OK|alram"
		dbget.close()	:	response.End
	Else				
		Response.write "ERR|이미 신청하셨습니다."
		dbget.close()	:	response.End
	End If
elseif mode = "entryEvt" then '인증 받은 고객은 바로 응모
	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If
	if session("isAdult") = false then
		Response.write "ERR|성인만 참여 가능한 이벤트입니다."
		dbget.close()	:	response.End	
	end if
	if Not(currenttime >= "2018-12-05" And currenttime <= "2019-01-10") then	'이벤트 참여기간		
		Response.write "ERR|이벤트 참여 기간이 아닙니다."
		response.end
	end if
		
	'응모 여부 체크
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt3 = '"& chasu &"'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt3)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '"&chasu&"')"
		dbget.execute sqlstr
		Response.write "OK|entry"
		dbget.close()	:	response.End		
	Else				
		Response.write "ERR|이미 응모하셨습니다."
		dbget.close()	:	response.End
	End If
else '성인인증 모듈 태우기
	if Not(currenttime >= "2018-12-05" And currenttime <= "2019-01-10") then	'이벤트 참여기간		
		Response.write dispScript(eCode, "1")
		response.end
	end if
	If Not(IsUserLoginOK) Then
		Response.write dispScript(eCode, "2")
		response.End
	End If
	if session("isAdult") = false then
		Response.write dispScript(eCode, "3")
		dbget.close()	:	response.End	
	end if		
	
	'응모 여부 체크
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt3 = '"& chasu &"'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt3)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '"&chasu&"')"
		dbget.execute sqlstr

		Response.write dispScript(eCode, "0")
		dbget.close()	:	response.End
	Else				
		Response.write dispScript(eCode, "5")
		dbget.close()	:	response.End
	End If
end if	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->