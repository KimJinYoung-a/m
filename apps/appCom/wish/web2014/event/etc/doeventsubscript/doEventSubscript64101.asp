<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 별세는 밤 for app
' History : 2015-06-24 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, userid, mode, vTotalCount , myCount , loststars
Dim vQuery
Dim prize1 , prize2 , prize3 , prize4 , prize5 , prize6
Dim win1 , win2 , win3 , win4 , win5 , win6
Dim allwin2 , allwin4 , allwin6 , tempwin2 , tempwin4 , tempwin6
Dim renloop '//확률

randomize
renloop=int(Rnd*1000)+1 '100%

mode = requestcheckvar(request("mode"),32)
loststars = requestcheckvar(request("loststars"),10) '응모할 상품 번호

userid = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63799
	Else
		eCode   =  64101
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If
	
	if date() < "2015-06-29" or date() > "2015-07-10" Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If 
'########################################################################################
'//출석체크 응모
If mode = "daily" Then 
	'// 이벤트 출석 내역 확인
	vQuery = "SELECT count(*) FROM db_temp.[dbo].[tbl_event_attendance] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	If vTotalCount > 0 Then
		Response.Write "{ "
		response.write """resultcode"":""22"""
		response.write "}"
		dbget.close()
		response.end
	End If 

	'//출석 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO db_temp.[dbo].[tbl_event_attendance](evt_code, userid) VALUES('" & eCode & "', '" & userid & "')"
	dbget.Execute vQuery
	Response.Write "{ "
	response.write """resultcode"":""11"""
	response.write "}"
	dbget.close()
	response.End
End If 
'########################################################################################
'//상품 응모
If mode = "stars" Then

	'//응모 횟수 체크
	vQuery = "select "
	vQuery = vQuery & " count(*) as totcnt "
	vQuery = vQuery & " from db_temp.[dbo].[tbl_event_attendance] as t "
	vQuery = vQuery & " inner join db_event.dbo.tbl_event as e "
	vQuery = vQuery & " on t.evt_code = e.evt_code and convert(varchar(10),t.regdate,120) between convert(varchar(10),e.evt_startdate,120) and convert(varchar(10),e.evt_enddate,120) "
	vQuery = vQuery & "	where t.userid = '"& userid &"' and t.evt_code = '"& eCode &"' " 
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		myCount = rsget("totcnt") '// 전체 응모수
	End IF
	rsget.close()

	vQuery = "select "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 1 and userid = '"& userid &"' then 1 else 0 end),0) as prize1 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 1 and sub_opt2 = 1 and userid = '"& userid &"' then 1 else 0 end),0) as mywin1 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 2 and userid = '"& userid &"' then 1 else 0 end),0) as prize2 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 2 and sub_opt2 = 1 and userid = '"& userid &"' then 1 else 0 end),0) as mywin2 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 2 and sub_opt2 = 1 then 1 else 0 end),0) as allwin2 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 3 and userid = '"& userid &"' then 1 else 0 end),0) as prize3 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 3 and sub_opt2 = 1 and userid = '"& userid &"' then 1 else 0 end),0) as mywin3 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 4 and userid = '"& userid &"' then 1 else 0 end),0) as prize4 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 4 and sub_opt2 = 1 and userid = '"& userid &"' then 1 else 0 end),0) as mywin4 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 4 and sub_opt2 = 1 then 1 else 0 end),0) as allwin4 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 5 and userid = '"& userid &"' then 1 else 0 end),0) as prize5 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 5 and sub_opt2 = 1 and userid = '"& userid &"' then 1 else 0 end),0) as mywin5 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 6 and userid = '"& userid &"' then 1 else 0 end),0) as prize6 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 6 and sub_opt2 = 1 and userid = '"& userid &"' then 1 else 0 end),0) as mywin6 ,  "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 6 and sub_opt2 = 1 then 1 else 0 end),0) as allwin6  "
	vQuery = vQuery & "	from db_event.dbo.tbl_event_subscript "
	vQuery = vQuery & "	where evt_code = '"& eCode &"'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		prize1	= rsget("prize1")	'// 3일차 응모 - 마일리지 500point - 전원지급
		win1	= rsget("mywin1")	'// 당첨여부
		prize2	= rsget("prize2")	'//	5일차 응모 - 미니무드등 - 200명 - 5%
		win2	= rsget("mywin2")	'// 당첨여부
		prize3	= rsget("prize3")	'//	7일차 응모 - 마일리지 1,000point - 전원지급
		win3	= rsget("mywin3")	'// 당첨여부
		prize4	= rsget("prize4")	'//	10일차 응모 - 에코백 - 100명 - 5%
		win4	= rsget("mywin4")	'// 당첨여부
		prize5	= rsget("prize5")	'//	11일차 응모 - 마일리지 1,000point -  전원지급
		win5	= rsget("mywin5")	'// 당첨여부
		prize6	= rsget("prize6")	'//	12일차 응모 - THE LAMP - 10명 - 1%
		win6	= rsget("mywin6")	'// 당첨여부
		allwin2	= rsget("allwin2")	'// 전체당첨수
		allwin4	= rsget("allwin4")	'// 전체당첨수
		allwin6	= rsget("allwin6")	'// 전체당첨수
	End IF
	rsget.close()

	'/// 다음 작업시 전체 당첨 수와 개인별 당첨 영역 쿼리 분리 작업 요망 2015-07-10 이종화

	Sub fnGetPrize(v) 'v 응모 번호 1~6
		If v = 1 Or v = 3 Or v = 5 Then '//비추첨식 응모만 가능 // 마일리지 500 / 1,000 / 1,000
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '1', 'A')"
			dbget.Execute vQuery
			Response.Write "{ "
			Response.write """resultcode"":""11"""
			Response.write ",""Lcode"":"""& v &""""
			Response.write "}"
			dbget.close()
			Response.end
		End If 

		If v = 2 Or v = 4 Or v = 6 Then '//추첨식 
			tempwin2 = 200	'//5일차 우주인 무드등 
			tempwin4 = 100  '//10일차 우주패턴 에코백
			tempwin6 = 10	'//12일차 THE LAMP
			
			If v = 2 Then
				If allwin2 < tempwin2 Then '// 상품 수량 있음
					If renloop < 11 Then '1%
						vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '1', 'A')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""11"""
						Response.write ",""Lcode"":"""& v &""""
						Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win01.jpg"""
						Response.write ",""imgalt"":""축하합니다! 우주인 무드등 당첨!"""
						Response.write "}"
						dbget.close()
						Response.end
					Else '//확률 꽝
						vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) values ('749', '" & userid & "', '1','10','[app 쿠폰] 별 세는 밤 쿠폰 10%-2만원이상','20000','2015-06-29 00:00:00','2015-07-20 23:59:59','',0,'system','app')"
						dbget.execute vQuery

						'//이벤트 테이블에 등록
						vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', 'A')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""22"""
						Response.write ",""Lcode"":"""& v &""""
						Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win00.jpg"""
						Response.write ",""imgalt"":""앗! 미안해요 10% 쿠폰"""
						Response.write "}"
						dbget.close()
						Response.end
					End If 
				Else '// 상품수량 오링 -> 꽝처리
					vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) values ('749', '" & userid & "', '1','10','[app 쿠폰] 별 세는 밤 쿠폰 10%-2만원이상','20000','2015-06-29 00:00:00','2015-07-20 23:59:59','',0,'system','app')"
					dbget.execute vQuery

					'//이벤트 테이블에 등록
					vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', 'A')"
					dbget.Execute vQuery
					Response.Write "{ "
					Response.write """resultcode"":""22"""
					Response.write ",""Lcode"":"""& v &""""
					Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win00.jpg"""
					Response.write ",""imgalt"":""앗! 미안해요 10% 쿠폰"""
					Response.write "}"
					dbget.close()
					Response.end
				End If 
			End If 

			If v = 4 Then
				If allwin4 < tempwin4 Then '// 상품 수량 있음
					If renloop < 101 Then '10% 2015-07-09 이종화 확률 조정 1% -> 10%
						vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '1', 'A')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""11"""
						Response.write ",""Lcode"":"""& v &""""
						Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win02.jpg"""
						Response.write ",""imgalt"":""축하합니다! 우주패턴 에코백 당첨!"""
						Response.write "}"
						dbget.close()
						Response.end
					Else '//확률 꽝
						vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) values ('749', '" & userid & "', '1','10','[app 쿠폰] 별 세는 밤 쿠폰 10%-2만원이상','20000','2015-06-29 00:00:00','2015-07-20 23:59:59','',0,'system','app')"
						dbget.execute vQuery

						'//이벤트 테이블에 등록
						vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', 'A')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""22"""
						Response.write ",""Lcode"":"""& v &""""
						Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win00.jpg"""
						Response.write ",""imgalt"":""앗! 미안해요 10% 쿠폰"""
						Response.write "}"
						dbget.close()
						Response.end
					End If 
				Else '// 상품수량 오링 -> 꽝처리
					vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) values ('749', '" & userid & "', '1','10','[app 쿠폰] 별 세는 밤 쿠폰 10%-2만원이상','20000','2015-06-29 00:00:00','2015-07-20 23:59:59','',0,'system','app')"
					dbget.execute vQuery

					'//이벤트 테이블에 등록
					vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', 'A')"
					dbget.Execute vQuery
					Response.Write "{ "
					Response.write """resultcode"":""22"""
					Response.write ",""Lcode"":"""& v &""""
					Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win00.jpg"""
					Response.write ",""imgalt"":""앗! 미안해요 10% 쿠폰"""
					Response.write "}"
					dbget.close()
					Response.end
				End If 			
			End If 

			If v = 6 Then
				If allwin6 < tempwin6 Then '// 상품 수량 있음
					If renloop < 11 Then '1%
						vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '1', 'A')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""11"""
						Response.write ",""Lcode"":"""& v &""""
						Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win03.jpg"""
						Response.write ",""imgalt"":""축하합니다! 스티키 몬스터랩 THE LAMP 당첨!"""
						Response.write "}"
						dbget.close()
						Response.end
					Else '//확률 꽝
						vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) values ('749', '" & userid & "', '1','10','[app 쿠폰] 별 세는 밤 쿠폰 10%-2만원이상','20000','2015-06-29 00:00:00','2015-07-20 23:59:59','',0,'system','app')"
						dbget.execute vQuery

						'//이벤트 테이블에 등록
						vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', 'A')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""22"""
						Response.write ",""Lcode"":"""& v &""""
						Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win00.jpg"""
						Response.write ",""imgalt"":""앗! 미안해요 10% 쿠폰"""
						Response.write "}"
						dbget.close()
						Response.end
					End If 
				Else '// 상품수량 오링 -> 꽝처리
					vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) values ('749', '" & userid & "', '1','10','[app 쿠폰] 별 세는 밤 쿠폰 10%-2만원이상','20000','2015-06-29 00:00:00','2015-07-20 23:59:59','',0,'system','app')"
					dbget.execute vQuery

					'//이벤트 테이블에 등록
					vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', 'A')"
					dbget.Execute vQuery
					Response.Write "{ "
					Response.write """resultcode"":""22"""
					Response.write ",""Lcode"":"""& v &""""
					Response.write ",""imgsrc"":""http://webimage.10x10.co.kr/eventIMG/2015/64101/img_win00.jpg"""
					Response.write ",""imgalt"":""앗! 미안해요 10% 쿠폰"""
					Response.write "}"
					dbget.close()
					Response.end
				End If 			
			End If
		End If 
	End Sub

	'//응모 처리
	Dim scnum
	Dim arrcnt : arrcnt = array(3,5,7,10,11,12) '//필요 별 포인트 배열
	Dim prizenum : prizenum = array(prize1,prize2,prize3,prize4,prize5,prize6) '//상품 응모여부 배열
	Dim winnum : winnum = array(win1,win2,win3,win4,win5,win6) '//상품 당첨여부 배열

	For scnum = 1 To 6 '//응모 가짓수
		If myCount >= arrcnt(scnum-1) Then
			If prizenum(scnum-1) = 0 And winnum(scnum-1) = 0 And cstr(arrcnt(scnum-1)) = cstr(loststars) Then '// 별 개수 충족 하면서 응모 내역,당첨내역이 없을 경우
				Call fnGetPrize(scnum)
				Exit For '//호출 하고 루프 끝내삼
			ElseIf prizenum(scnum-1) = 1 And cstr(arrcnt(scnum-1)) = cstr(loststars) Then '//별 개수 충족 하면서 응모 내역 있을 경우
				Response.Write "{ "
				Response.write """resultcode"":""99"""
				Response.write "}"
				Exit For 
			End If 
		Else
			Response.Write "{ "
			Response.write """resultcode"":""33"""
			Response.write "}"
			Exit For 
		End If
	Next 
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->