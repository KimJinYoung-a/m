<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'#############################################################
'	Description : 사람은 돌아오는거야 MA
'	History		: 2015.01.20 유태욱 생성
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
''dim username
Dim chkid, eCode, sqlstr, vsmCount, vUserCount, couponnum
Dim Fulladdr, addr1, addr2, mode
Dim zipcode, usercell, userphone
Dim strQuery, device
dim currenttime
	currenttime =  now()

'														currenttime = #01/22/2016 09:00:00#

mode = requestCheckVar(Request("mode"),22)
chkid 	= GetEncLoginUserID()

If isApp then
	device = "A"
else
	device = "M"
end if

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66005
	couponnum = 2793
Else
	eCode   =  68736
	couponnum = 866
End If

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "{ "
	response.write """chcode"":""55"""	''잘못된 접속입니다.
	response.write "}"
	dbget.close()	:	response.End
end If

If chkid = "" Then
	Response.Write "{ "
	response.write """chcode"":""77"""	''신청하려면 로그인을 해야합니다.
	response.write "}"
	dbget.close()	:	response.End
End IF

If not( left(currenttime,10)>="2016-01-22" and left(currenttime,10)<"2017-01-01" ) Then
	Response.Write "{ "
	response.write """chcode"":""88"""	''이벤트 기간이 아닙니다.
	response.write "}"
	dbget.close()	:	response.End
End IF

'// 대상자여부
sqlstr = "select top 1 userid "
sqlstr = sqlstr & " from [db_temp].[dbo].[tbl_event_68736]"
sqlstr = sqlstr & " where userid='"&chkid&"' "
rsget.Open sqlstr, dbget, 1

If Not rsget.Eof Then
	vUserCount = rsget(0)
End IF
rsget.close

'									if chkid = "greenteenz" then
'										vUserCount = "greenteenz"
'									elseif chkid = "cogusdk" then
'										vUserCount = "cogusdk"
'									elseif chkid = "helele223" then
'										vUserCount = "helele223"
'									end if


'// 대상자인지 확인  //
IF chkid <> vUserCount THEN
	Response.Write "{ "
	response.write """chcode"":""99"""	''이벤트 대상자가 아닙니다.
	response.write "}"
	dbget.close()	:	response.End
END IF

If mode = "ballstart" Then
	Response.Write "{ "
	response.write """chcode"":""44"""	''주소입력으로 이동
	response.write "}"
	dbget.close()	:	response.End
elseIf mode = "cp" Then

	'// 참여여부
	sqlstr = "select count(*) "
	sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript"
	sqlstr = sqlstr & " where evt_code='"& eCode &"' and userid='"&chkid&"' and sub_opt3='201606' "
	rsget.Open sqlstr, dbget, 1
	
	If Not rsget.Eof Then
		vsmCount = rsget(0)
	End IF
	rsget.close
	
	if vsmCount > 0 then
		Response.Write "{ "
		response.write """chcode"":""22"""	''이미 참여 하셨습니다.
		response.write "}"
		dbget.close()	:	response.End
	end if

	'쿠폰주고 끝
	'----------------------------------------------------
	sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] "	& VbCrlf
	sqlStr = sqlStr & " (evt_code, userid, sub_opt1, sub_opt3, device)" & VbCrlf
	sqlStr = sqlStr & " VALUES " & VbCrlf
	sqlStr = sqlStr & " ("&eCode&",'"&chkid&"', 'cp', '201606', '"&device&"')"
	dbget.execute sqlStr

	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
	sqlstr = sqlstr & " 	SELECT idx, '"& chkid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), dateadd(hh, +24, getdate()),couponmeaipprice,validsitename" + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx in ("& couponnum &")"
	dbget.execute sqlstr
	'----------------------------------------------------
	Response.Write "{ "
	response.write """chcode"":""11"""	''쿠폰 받아진 화면으로go
	response.write "}"
	dbget.close()	:	response.End

elseIf mode = "balladd" Then

	'// 참여여부
	sqlstr = "select count(*) "
	sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript"
	sqlstr = sqlstr & " where evt_code='"& eCode &"' and userid='"&chkid&"' and sub_opt3='201606' "
	rsget.Open sqlstr, dbget, 1
	
	If Not rsget.Eof Then
		vsmCount = rsget(0)
	End IF
	rsget.close
	
	if vsmCount > 0 then
		Response.Write "{ "
		response.write """chcode"":""22"""	''이미 신청하셨습니다.
		response.write "}"
		dbget.close()	:	response.End
	end if
	

	zipcode = requestCheckVar(request("txZip1"),3) + "-" + requestCheckVar(request("txZip2"),3)

'	Fulladdr = html2db(request("txAddr1")) + html2db(request("txAddr2"))'' + "!/!" + requestCheckVar(request("reqname"),32)
	userphone = requestCheckVar(request("userphone1"),4) + "-" + requestCheckVar(request("userphone2"),4) + "-" + requestCheckVar(request("userphone3"),4)

'	usercell = requestCheckVar(request("reqhp1"),3)+ "-" + requestCheckVar(request("reqhp2"),4) + "-" +requestCheckVar(request("reqhp3"),4)
'	username = requestCheckVar(request("reqname"),32)
	addr1 = html2db(request("txAddr1"))
	addr2 = html2db(request("txAddr2"))



	If requestCheckVar(request("txZip1"),3) = "" OR requestCheckVar(request("txZip2"),3) = "" OR addr1 = "" OR addr2 = "" OR requestCheckVar(request("userphone1"),3) = "" OR requestCheckVar(request("userphone2"),3) = "" OR requestCheckVar(request("userphone3"),3) = "" Then	''OR username = "" 
		Response.Write "{ "
		response.write """chcode"":""66"""	''주소 입력이 잘못되었습니다.
		response.write "}"
		dbget.close()	:	response.End
	End If

'Response.Write "{ "
'response.write """chcode"":""999"""	''오류 입니다.
'response.write "}"
'dbget.close()	:	response.End
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] "	& VbCrlf
		sqlStr = sqlStr & " (evt_code, userid, sub_opt3, device)" & VbCrlf
		sqlStr = sqlStr & " VALUES " & VbCrlf
		sqlStr = sqlStr & " ("&eCode&",'"&chkid&"', '201606', '"&device&"')"
		dbget.execute sqlStr

		sqlStr = "update [db_user].[dbo].tbl_user_n" + VbCrlf
		sqlStr = sqlStr + " set zipcode='" + zipcode + "'"  + VbCrlf
		sqlStr = sqlStr + " ,useraddr='" + addr2 + "'"  + VbCrlf
		sqlStr = sqlStr + " ,userphone='" + userphone + "'"  + VbCrlf
'		sqlStr = sqlStr + " ,usercell='" + usercell + "'"  + VbCrlf
		sqlStr = sqlStr + " where userid='" + chkid + "'" + VbCrlf

		dbget.Execute sqlStr
		Response.Write "{ "
		response.write """chcode"":""33"""	''신청이 완료 되었습니다.
		response.write "}"
		dbget.close()	:	response.End
	End Sub
'===================================================================================================================================================================================================
	Call fnGetPrize() '//응모
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->