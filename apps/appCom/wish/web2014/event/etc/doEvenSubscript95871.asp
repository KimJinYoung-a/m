<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 쿠폰전
' History : 2019-07-05 최종원
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
	dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer, subscriptcount, couponIdx
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, videoLink, urlCnt	
	subscriptcount = 0
	eCode			= request("eCode")
	currenttime 	= date()
	LoginUserid		= getencLoginUserid()			
	couponIdx 		= request("couponIdx")

	device = "W"

	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 쿠폰을 받으실 수 있습니다."
		response.End
	End If	

	'//본인 참여 여부
	if LoginUserid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", couponIdx)
	end if

	if subscriptcount > 0 then
		Response.write "ERR|1"
		dbget.close()	:	response.End
	Else
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & LoginUserid & "', '', '', '"& couponIdx &"', '"& device &"')" + vbcrlf

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr	

		Response.write "OK|OK"
		dbget.close()	:	response.End		
	End IF

		Response.write "ERR|시스템 오류입니다."
		dbget.close()	:	response.End	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->