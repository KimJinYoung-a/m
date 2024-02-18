<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [럭키백]크리스박스의 기적 
' History : 2014.12.01 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event57117Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

if mode="c1countchk" then
    'c1 - 카카오초대 클릭 카운트 
	if userid<>"" then
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', 'kakaocount', 'A')" + vbcrlf
		dbget.execute sqlstr
	else
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '57117kkcount', 'kakaocount', 'A')" + vbcrlf
		dbget.execute sqlstr
	end if
   dbget.close()	:	response.end
   
elseif mode="c2countchk" then
    'c2 - 하단배터 클릭 카운트
	if userid<>"" then
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', 'bannercount', 'A')" + vbcrlf
		dbget.execute sqlstr
	else
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '57117bncount', 'bannercount', 'A')" + vbcrlf
		dbget.execute sqlstr
	end if
   dbget.close()	:	response.end

elseif mode="c3countchk" then
    'c3 - App 메인배너 이벤트바로가기 클릭 카운트
	if userid<>"" then
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', 'count', 'A')" + vbcrlf
		dbget.execute sqlstr
	else
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '57117count', 'count', 'A')" + vbcrlf
		dbget.execute sqlstr
	end if
   dbget.close()	:	response.end

elseif mode="notlogin" then
	'쿠키꿉는다
	response.cookies("etc").domain="10x10.co.kr"
	response.cookies("etc")("evtcode") = 57117
	
	response.write "111"		'//성공임
	dbget.close()	:	response.end
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_code&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->