<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : ## 낮ver. 신데렐라2
' History : 2015-08-10 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
dim nowdate, refer, device, couponid, totalbonuscouponcount
dim eCode, userid, sqlstr, mode , vTotalCount
Dim vQuery

	userid = GetLoginUserID
	mode = requestcheckvar(request("mode"),32)
	totalbonuscouponcount = 0

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64849"
		couponid = 2730
	Else
		eCode = "65433"
		couponid = 762
	End If

	if isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = date()
'	nowdate = "2015-08-12"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
			response.write "88"
			dbget.close()
			response.end
	end if

	if mode<>"appdowncnt" then
		If userid = "" Then
			response.write "44"
			dbget.close()
			response.end
		End IF
	end if

	'// 이벤트 응모 내역 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	'//쿠폰발행수량
	totalbonuscouponcount = getbonuscoupontotalcount(couponid, "", "", Date())

	if mode="add" then

		If not(nowdate>="2015-08-12" and nowdate<"2015-08-15") Then
			response.write "33"
			dbget.close()
			response.end
		End IF	
	
		if vTotalCount > 0 then
			response.write "22"
			dbget.close()
			response.end
		end if
	
		'// 이벤트 테이블에 내역을 남긴다.
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', '" & device & "')"
		dbget.Execute vQuery

		vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
				 "values('"& couponid &"', '" & userid & "', '2','10000','신데렐라쿠폰(1만원)','50000','2015-08-12 09:00:00','2015-08-14 23:59:59','',0,'system','app')"
		dbget.execute vQuery
		
		'// 해당 유저의 로그값 집어넣는다.
		Call fnCautionEventLog(eCode,userid,nowdate,"","",device)

		response.write "99"
		dbget.close()
		response.End

	elseif mode="appdowncnt" then
	
		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
		sqlstr = sqlstr & " VALUES('"& eCode &"', 'appdowncnt')"
		dbget.execute sqlstr
	
		response.write "OK"
		response.End

	else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->