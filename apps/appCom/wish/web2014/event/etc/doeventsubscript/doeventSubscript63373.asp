<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  비둘기 마켓 - for app
' History : 2015-06-05 이종화
'###########################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim vTotalCount , strSql , item1 ,  item2 , item3 , dailycnt , totcnt , tempdcnt , temptotcnt
dim eCode, userid, sqlstr, refer, renloop, getbonuscoupon
Dim myitem1 , myitem2

	IF application("Svr_Info") = "Dev" THEN
		eCode		=  63781 '//테섭
		getbonuscoupon = 2721
	Else
		eCode		=  63373 '//실섭
		getbonuscoupon = 742
	End If

	userid	= getloginuserid()

	randomize
	renloop=int(Rnd*1000)+1 '100%

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "{ "
		Response.write """resultcode"":""03"""
		Response.write "}"
		dbget.close() : Response.End
	end If
	
	if not(Date()>="2015-06-09" and Date()<"2015-06-15" ) then
		Response.Write "{ "
		Response.write """resultcode"":""01"""
		Response.write "}"
		dbget.close() : Response.End
	End If

	If userid = "" Then
		Response.Write "{ "
		Response.write """resultcode"":""02"""
		Response.write "}"
		dbget.close() : Response.End
	End If

	'##########################################################################################################################
	'// 응모 확인 일별1회
	strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' and convert(varchar(10),regdate,120) = '"& Date() &"' "
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	If vTotalCount > 0 Then
		Response.Write "{ "
		Response.write """resultcode"":""00"""
		Response.write "}"
		dbget.close()
		response.end
	End If 

	'// 응모 확인 당첨 이력 있으면 꽝처리
	strSql = "SELECT " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt1 = '1' then 1 else 0 end),0) as item1, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt1 = '2' then 1 else 0 end),0) as item2 " + vbcrlf
	strSql = strSql & " FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		myitem1 = rsget("item1")
		myitem2 = rsget("item2")
	End If
	rsget.close()

	If myitem1 > 0 Or myitem2 > 0 Then '당첨 이력 있으면 꽝처리
		renloop = 999
	End If 
	'##########################################################################################################################

	'// item1 = 1등 - 새장		item1 = 2
	'// item2 = 2등 - 마일리지  item2 = 100
	'// item3 = 3등 - 쿠폰      item3 = 무제한 꽝
	'// dailycnt = 일별 카운트 제한
	'// totcnt = 전체 응모수
	'// tempdcnt = 일별 카운트 제한 수 = 102명 고정
	'// temptotcnt = 전체 당첨 카운트  = 510명 고정
	
	tempdcnt = 102
	temptotcnt = 510

	'// 일별 당첨인원 제한
	strSql = "SELECT " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt1 = '1' then 1 else 0 end),0) as item1, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt1 = '2' then 1 else 0 end),0) as item2, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt1 = '3' then 1 else 0 end),0) as item3, " + vbcrlf
	strSql = strSql & " isnull(sum(case when convert(varchar(10),regdate,120) = '"& Date() &"' then 1 else 0 end),0) as dailycnt, " + vbcrlf
	strSql = strSql & " count(*) as totcnt " + vbcrlf
	strSql = strSql & " from db_event.dbo.tbl_event_subscript where evt_code = '"&eCode&"' and convert(varchar(10),regdate,120) = '"& Date() &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		item1 = rsget("item1")
		item2 = rsget("item2")
		item3 = rsget("item3")
		dailycnt = rsget("dailycnt")
		totcnt = rsget("totcnt")
	End If
	rsget.close()

	If (item1 + item2) < 102 Then '//일별 제한
		If renloop < 21 Then '2% 새장당첨
			If item1 <= 1 Then '1등 당첨자가 0~1명 일때까지만 당첨
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '1', 'A')" 
			
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "{ "
				Response.write """resultcode"":""11"""
				Response.write "}"
				dbget.close() : Response.End

			Else '// 넘어가면 꽝
				On Error Resume Next
				dbget.beginTrans
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '3', 'A')" 
				
					'response.write sqlstr & "<Br>"
					dbget.execute sqlstr , 1

					sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
					sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
					sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
					sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
					sqlstr = sqlstr & " 	where idx="& getbonuscoupon &""
				
					'response.write sqlstr & "<Br>"
					dbget.execute sqlstr , 1
				If Err.Number = 0 Then
					dbget.CommitTrans
					Response.Write "{ "
					Response.write """resultcode"":""33"""
					Response.write "}"
				Else
					dbget.RollBackTrans
					Response.Write "{ "
					Response.write """resultcode"":""99"""
					Response.write "}"
				End If
				On error Goto 0
			End If 
		ElseIf renloop > 20 And renloop < 171 then '5% 마일리지 당첨 추후 취합 적립 = > 15% 2015-06-10
			If item2 <= 99 Then '2등 당첨자 100명 이하일때 까지만 당첨
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '2', 'A')" 
			
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "{ "
				Response.write """resultcode"":""22"""
				Response.write "}"
				dbget.close() : Response.End
			Else '// 넘어가면 꽝
				On Error Resume Next
				dbget.beginTrans
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '3', 'A')" 
				
					'response.write sqlstr & "<Br>"
					dbget.execute sqlstr , 1

					sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
					sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
					sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
					sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
					sqlstr = sqlstr & " 	where idx="& getbonuscoupon &""
				
					'response.write sqlstr & "<Br>"
					dbget.execute sqlstr , 1
				If Err.Number = 0 Then
					dbget.CommitTrans
					Response.Write "{ "
					response.write """resultcode"":""33"""
					response.write "}"
				Else
					dbget.RollBackTrans
					Response.Write "{ "
					Response.write """resultcode"":""99"""
					Response.write "}"
				End If
				On error Goto 0			
			End If 
		Elseif renloop > 170 then '//꽝
			On Error Resume Next
			dbget.beginTrans
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '3', 'A')" 
			
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr , 1

				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
				sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
				sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
				sqlstr = sqlstr & " 	where idx="& getbonuscoupon &""
			
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr , 1
			If Err.Number = 0 Then
				dbget.CommitTrans
				Response.Write "{ "
				Response.write """resultcode"":""33"""
				Response.write "}"
			Else
				dbget.RollBackTrans
				Response.Write "{ "
				Response.write """resultcode"":""99"""
				Response.write "}"
			End If
			On error Goto 0
		End If 
	Else '//나머진 쿠폰발급
		On Error Resume Next
		dbget.beginTrans
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '3', 'A')" 
		
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr , 1

			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
			sqlstr = sqlstr & " 	where idx="& getbonuscoupon &""
		
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr , 1
		If Err.Number = 0 Then
		    dbget.CommitTrans
			Response.Write "{ "
			Response.write """resultcode"":""33"""
			Response.write "}"
		Else
		    dbget.RollBackTrans
			Response.Write "{ "
			Response.write """resultcode"":""99"""
			Response.write "}"
		End If
		On error Goto 0
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->