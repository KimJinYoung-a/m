<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  <PLAY> 여행하듯 랄랄라
' History : 2014.07.04 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, txtcomm, sub_idx
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	sub_idx = requestcheckvar(request("sub_idx"),10)
	txtcomm = requestcheckvar(request("txtcomm"),300)

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-07-07"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21229
	Else
		evt_code   =  53346
	End If
	
	getevt_code = evt_code
end function

refer = request.ServerVariables("HTTP_REFERER")

if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 하셔야 참여가 가능 합니다.');</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-07-07" and getnowdate<"2014-07-18") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.location.reload();</script>"
	dbget.close() : Response.End
End IF

if mode="addcomment" then
	if txtcomm="" then
		Response.Write "<script type='text/javascript'>alert('내용을 입력해 주세요.'); parent.location.reload();</script>"
		dbget.close() : Response.End		
	end if	
	if checkNotValidTxt(txtcomm) then
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.location.reload();</script>"
		dbget.close() : Response.End		
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& html2db(txtcomm) &"' , 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	Response.Write "<script>" &_
			"alert('참여완료!');" &_
			"parent.location.reload();" &_
			"</script>"

elseif mode="delcomment" then
	If sub_idx = "" Then
		Response.Write "<script type='text/javascript'>alert('구분자가 없습니다.'); parent.location.reload();</script>"
		dbget.close() : Response.End
	End IF
	
	sqlstr="delete from db_event.dbo.tbl_event_subscript where sub_idx='"& sub_idx &"' and userid='"& userid &"' and evt_code='"& eCode &"'"
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('삭제되었습니다.'); parent.location.reload();</script>"

else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.location.reload();</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->