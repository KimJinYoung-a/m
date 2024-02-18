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
' Description : 슈퍼백의 기적(박스이벤트)
' History : 2015.03.11 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event59795Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
dim eCode, userid, itemid, oItem, mode, renloop, winnumber, sqlstr, result1, result2, result3, bonuscouponexistscount
	mode = requestcheckvar(request("mode"),32)

eCode=getevt_code
userid = getloginuserid()

bonuscouponexistscount=0
winnumber = 0
renloop = 0
itemid=""

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

if mode="mo_main" then
	'//앱바로가기 클릭 카운트
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')"
	
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end

elseif mode="KAKAOHOILDAY" then
	if not( left(currenttime,10)>="2015-03-21" and left(currenttime,10)<"2015-03-23" ) then
		Response.Write "DATENOT"
		dbget.close() : Response.End
	end if

	'//앱바로가기 클릭 카운트
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')"
	
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end

Else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
