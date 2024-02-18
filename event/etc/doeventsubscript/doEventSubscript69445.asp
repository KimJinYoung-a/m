<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 별헤는밤 출첵 이벤트 MA
' History : 2016-02-29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" --> 
<%
dim eCode, userid, mode, vTotalCount , myCount , loststars, device
Dim vQuery, couponidx
Dim prize1, prize2, prize3
dim currenttime
	currenttime =  now()
'	currenttime = #03/13/2016 09:00:00#

mode = requestcheckvar(request("mode"),32)
loststars = requestcheckvar(request("loststars"),10) '응모할 상품 번호

userid = GetEncLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66053
		couponidx = "2770"
	Else
		eCode   =  69445
		couponidx = "829"
	End If

	'' M,A 에서사용
	IF isapp THEN
		device   =  "A"
	Else
		device   =  "M"
	End If

	''// 로그인 체크
	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If

	''//이벤트 기간 체크
	If not( left(currenttime,10)>="2016-03-07" and left(currenttime,10)<"2016-03-14" ) Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If 
'---------------------------------------------------------------------------------------------------------
'//출석체크 응모
If mode = "daily" Then 
	'// 당일 이벤트 출석 응모 내역
	vQuery = "SELECT count(*) FROM db_temp.[dbo].[tbl_event_attendance] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	''//오늘 출첵 했으면 종료
	If vTotalCount > 0 Then
		Response.Write "{ "
		response.write """resultcode"":""22"""
		response.write "}"
		dbget.close()
		response.end
	End If

	'//오늘 출첵 안했으면 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO db_temp.[dbo].[tbl_event_attendance](evt_code, userid) VALUES('" & eCode & "', '" & userid & "')"
	dbget.Execute vQuery
	Response.Write "{ "
	response.write """resultcode"":""11"""
	response.write "}"
	dbget.close()
	response.End
End If 
'---------------------------------------------------------------------------------------------------------
''//총 출첵 갯수 체크, 상품 응모 현황
if mode = "stars" Then
	vQuery = "select "
	vQuery = vQuery & " count(*) as totcnt "
	vQuery = vQuery & " from db_temp.[dbo].[tbl_event_attendance] as t "
	vQuery = vQuery & " inner join db_event.dbo.tbl_event as e "
	vQuery = vQuery & " on t.evt_code = e.evt_code and convert(varchar(10),t.regdate,120) between convert(varchar(10),e.evt_startdate,120) and convert(varchar(10),e.evt_enddate,120) "
	vQuery = vQuery & "	where t.userid = '"& userid &"' and t.evt_code = '"& eCode &"' " 
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		myCount = rsget("totcnt")
	End IF
	rsget.close()

	vQuery = "select "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 2 and userid = '"& userid &"' then 1 else 0 end),0) as prize1 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 4 and userid = '"& userid &"' then 1 else 0 end),0) as prize2 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 7 and userid = '"& userid &"' then 1 else 0 end),0) as prize3  "
	vQuery = vQuery & "	from db_event.dbo.tbl_event_subscript "
	vQuery = vQuery & "	where evt_code = '"& eCode &"'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		prize1	= rsget("prize1")	'// 2일차 응모
		prize2	= rsget("prize2")	'//	4일차 응모
		prize3	= rsget("prize3")	'//	7일차 응모
	End IF
	rsget.close()
end if

'//상품 응모
if mode= "stars" then
	If loststars = "2" Then
		if myCount < 2 then	''출첵 2번이하면 응모 안됨
			Response.Write "{ "
			response.write """resultcode"":""33"""	''별을 더 켜주세요
			response.write "}"
			dbget.close()
			response.end
		else
			if prize1 = 1 then
				Response.Write "{ "
				response.write """resultcode"":""99"""	''이미 응모 하셨습니다.
				response.write "}"
				dbget.close()
				response.end
			else
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& loststars &"', '2', '"& device &"')"
				dbget.Execute vQuery
				Response.Write "{ "
				response.write """resultcode"":""77"""		''마일리지 응모 완료
		''		Response.write ",""Lcode"":"""& v &""""
				Response.write "}"
				dbget.close()
				Response.end
			end if
		end if
	elseif loststars = "4" Then
		if myCount < 4 then	''출첵 4번이하면 응모 안됨
			Response.Write "{ "
			response.write """resultcode"":""33"""	''별을 더 켜주세요
			response.write "}"
			dbget.close()
			response.end
		else
			if prize2 = 1 then
				Response.Write "{ "
				response.write """resultcode"":""99"""	''이미 응모 하셨습니다.
				response.write "}"
				dbget.close()
				response.end
			else
				dim CPdate
				CPdate = Year(now) &"-"& right("0"&Month(now),2) &"-"& right("0"&Day(now)+1,2) &" "& right("0"& Hour(now),2) &":"& right("0"&Minute(now),2) &":"& right("0"&Second(now),2)
'				response.write CPdate

				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& loststars &"', '4', '"& device &"')"
				dbget.Execute vQuery

				vQuery = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				vQuery = vQuery & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
				vQuery = vQuery & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'"& left(currenttime,10) &" 00:00:00','"& CPdate &"',couponmeaipprice,validsitename" + vbcrlf
				vQuery = vQuery & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
				vQuery = vQuery & " 	where idx="& couponidx &""
				'response.write vQuery & "<Br>"
				dbget.execute vQuery
				
				Response.Write "{ "
				response.write """resultcode"":""55"""		''쿠폰 발급 완료
		''		Response.write ",""Lcode"":"""& v &""""
				Response.write "}"
				dbget.close()
				Response.end
			end if
		end if
	elseif loststars = "7" Then
		if myCount < 7 then	''출첵 7번이하면 응모 안됨
			Response.Write "{ "
			response.write """resultcode"":""33"""	''별을 더 켜주세요
			response.write "}"
			dbget.close()
			response.end
		else
			if prize3 = 1 then
				Response.Write "{ "
				response.write """resultcode"":""99"""	''이미 응모 하셨습니다.
				response.write "}"
				dbget.close()
				response.end
			else
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& loststars &"', '7', '"& device &"')"
				dbget.Execute vQuery
				Response.Write "{ "
				response.write """resultcode"":""11"""		''lamp 응모 완료
		''		Response.write ",""Lcode"":"""& v &""""
				Response.write "}"
				dbget.close()
				Response.end
			end if
		end if
	else
		Response.Write "{ "
		response.write """resultcode"":""66"""	''잘못된 접속 입니다.
		response.write "}"
		dbget.close()
		response.end
	end if
else
	Response.Write "{ "
	response.write """resultcode"":""66"""	''잘못된 접속 입니다.
	response.write "}"
	dbget.close()
	response.end
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->