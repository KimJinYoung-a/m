<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'#################################################################
' Description : 플레잉 왜 우리는 다이어리를 끝까지 써 본적이 없을까?
' History : 2017.10.26 정태훈
'#################################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, referer, Cidx
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, word, hp, txtcomm, username, userinfo
		
IF application("Svr_Info") = "Dev" THEN
	eCode = "67457"
Else
	eCode = "81508"
End If

currenttime = date()
mode		= requestcheckvar(request("mode"),32)
word			= requestcheckvar(request("word"),1)
username	= requestcheckvar(request("username"),16)
hp	= requestcheckvar(request("hp"),16)
txtcomm	= requestcheckvar(request("txtcomm"),100)
Cidx	= requestcheckvar(request("Cidx"),10)
LoginUserid		= getencLoginUserid()
referer 			= request.ServerVariables("HTTP_REFERER")

userinfo = username & "|" & hp
'// 바로 접속시엔 오류 표시
If InStr(referer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	response.write "<script>alert('로그인 후 참여하실 수 있습니다.');history.back();</script>"
	response.End
End If

device = "I"

If mode = "add" Then
	If not(word > 0 and  word < 4) Then
		response.write "<script>alert('빈말 유형을 선택해주세요.');history.back();</script>"
		response.End
	End If
	'// expiredate
	If (currenttime >= "2017-11-28") Then
		response.write "<script>alert('이벤트 기간이 아닙니다.');history.back();</script>"
		Response.End
	End If

	sqlstr = "SELECT COUNT(*) as cnt FROM db_event.dbo.tbl_event_subscript WHERE userid= '"&LoginUserid&"' and evt_code='"&eCode&"'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 5 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2 , sub_opt3, device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & userinfo & "'," & word &", '" & txtcomm & "','" &device&"')"
			dbget.execute sqlstr

			 response.write "<script>alert('응모 완료했습니다.');</script>"
			 response.write "<script>location.replace('" + Cstr(referer) + "#card_list');</script>"
			 dbget.close()	:	response.End
	Else
		 response.write "<script>alert('이벤트는 5회까지 참여 가능 합니다.');</script>"
		 response.write "<script>location.replace('" + Cstr(referer) + "#card_list');</script>"
		 dbget.close()	:	response.End
	End If
ElseIf mode = "del" Then
	sqlStr = ""
	sqlstr = "delete from [db_event].[dbo].[tbl_event_subscript] where userid='" & LoginUserid & "' and sub_idx='" & Cidx & "' and evt_code='"&eCode&"'" & vbCrlf
	dbget.execute sqlstr
	response.write "<script>alert('삭제되었습니다.');</script>"
	response.write "<script>location.replace('" + Cstr(referer) + "#card_list');</script>"
	dbget.close() : Response.End
Else
	 response.write "<script>alert('정상적인 경로로 참여해주시기 바랍니다.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "#card_list');</script>"
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->