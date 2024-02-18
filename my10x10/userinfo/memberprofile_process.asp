<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 나의정보
'	History	:  2014.09.18 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim userid, usericonno, mode, sqlStr
	userid = getEncLoginUserID
	usericonno = getNumeric(requestCheckVar(request.form("usericonno"),2))
	mode = requestCheckVar(request.form("mode"),32)

if mode="usericonnoreg" then
	if userid="" then
		response.write "2"		'//로그인을 해주세요
	    dbget.close()	:	response.end
	end if
	if usericonno="" then
		response.write "3"		'//프로필 이미지를 선택해 주세요
	    dbget.close()	:	response.end
	end if
	
	sqlStr = "update db_user.dbo.tbl_user_n" + vbcrlf
	sqlStr = sqlStr & " set usericonno="& usericonno &" where" + vbcrlf
	sqlStr = sqlStr & " userid='"& userid &"'"
	
	dbget.execute sqlStr
	
	''쿠키꿉는다
	response.cookies("etc").domain="10x10.co.kr"
	response.cookies("etc")("musericonNo") = usericonno
	
	response.write "1"		'//성공임
	dbget.close()	:	response.end
else
	response.write "99"
	dbget.close()	:	response.end	
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->