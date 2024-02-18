<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 디스카운트 전(모바일 인증페이지)
' History : 2015.05.12 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
	Dim eCode , vQuery , allcnt, eMainCode, vUserID, myuserLevel, nowDate, confirmChk, dailyProductItemid, dailyProductLinkUrl, dailyProductImgName, dailyProductNextImgName, sqlstr, dateitemlimitcnt, vUserinputNumber, refip, refer

	vUserID = GetLoginUserID()

	nowDate = Left(Now(), 10)
'	nowDate = "2015-05-13"


	IF application("Svr_Info") = "Dev" THEN
		eCode		=  61786
		eMainCode = 61785
	Else
		eCode		=  62087
		eMainCode = 62086
	End If


	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	vUserinputNumber = requestcheckvar(request("userinputNumber"),32)


	if InStr(refer,"10x10.co.kr")<1 Then
		Response.Write "<script type='text/javascript'>alert('잘못된 접속입니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"	
		response.End
	End If

	If not(left(nowdate,10)>="2015-05-13" and left(nowdate,10)<"2015-05-30") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"	
		response.End
	End If

	If Left(nowdate, 10)="2015-05-16" Or Left(nowdate, 10)="2015-05-17" Then
		Response.Write "<script type='text/javascript'>alert('주말에는 이벤트가 진행되지 않습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"	
		response.End
	End If


	If Not(IsUserLoginOK) Then
		Response.Write "<script type='text/javascript'>alert('로그인 후 참여하실 수 있습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"	
		response.End
	End If

	'// 현재 입력한 인증코드값이 존재하는지 확인한다(일별로만 유효함)
	sqlstr = "select userid, sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eMainCode &""
	sqlstr = sqlstr & " and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt3 = '"&Trim(vUserinputNumber)&"' "
	rsget.Open sqlstr, dbget, 1
	If Not rsget.Eof Then
		'// 존재한다면

		'// 만약 인증 요청한 회원과 인증을 받아주는 회원 아이디가 동일하다면 튕겨낸다.
		If rsget("userid") = vUserID Then
			Response.Write "<script type='text/javascript'>alert('동일한 아이디로 초대 수락을 하실 수 없습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"	
			response.End
		End If

		'// 로그 넣음
		vQuery = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
		vQuery = vQuery & " VALUES("& eMainCode &", '"& vUserID &"', '"&refip&"', '친구 초대 인증확인', 'A')"
		dbget.execute vQuery

		'// disEvent 테이블에 밀어넣음
		vQuery = "INSERT INTO [db_temp].[dbo].[tbl_disEvent] (evt_code , sendid, confirmcode, receiveid, receivedate)" + vbcrlf
		vQuery = vQuery & " VALUES("& eMainCode &", '"& rsget("userid") &"', '"&Trim(vUserinputNumber)&"', '"&vUserID&"', getdate())"
		dbget.execute vQuery

		Response.Write "<script type='text/javascript'>alert('인증이 완료되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"	
		response.End
	Else
		'// 존재 안하면 튕겨낸다
		Response.Write "<script type='text/javascript'>alert('인증번호가 맞지 않습니다.\n다시한번 확인해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"	
		response.End
	End If
	rsget.close

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->