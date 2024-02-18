<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 2015 주년이벤트 - 출석 체크
' History : 2015-10-02 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, vTotalCount , myCount , waterdrops , returncnt
Dim vQuery , Lcode
Dim prize1 , prize2 , prize3 , prize4 , prize5 , prize6
Dim win1 , win2 , win3 , win4 , win5 , win6
Dim allwin2 , allwin4 , allwin6 , tempwin2 , tempwin4 , tempwin6
Dim renloop '//확률
Dim device

randomize
renloop=int(Rnd*1000)+1 '100%

mode = requestcheckvar(request("mode"),32)
waterdrops = requestcheckvar(request("waterdrops"),10) '응모할 상품 번호

userid = GetLoginUserID

If isapp = "1" Then device = "A" Else device = "M" End if

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64908
	Else
		eCode   =  66520
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If

	if date() < "2015-10-10" or date() > "2015-10-26" Then
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
	vQuery = "INSERT INTO db_temp.[dbo].[tbl_event_attendance](evt_code, userid , device) VALUES('" & eCode & "', '" & userid & "' , '"& device &"')"
	dbget.Execute vQuery

	'//현재 카운트
	vQuery = "SELECT count(*) FROM db_temp.[dbo].[tbl_event_attendance] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		returncnt = rsget(0)
	End If
	rsget.close

	If returncnt = 2 Then
		Lcode = 1
	ElseIf returncnt = 5 Then
		Lcode = 2
	ElseIf returncnt = 8 Then
		Lcode = 3
	ElseIf returncnt = 11 Then
		Lcode = 4
	ElseIf returncnt = 14 Then
		Lcode = 5
	ElseIf returncnt = 17 Then
		Lcode = 6
	Else
		Lcode = 9
	End If 	

	Response.Write "{ "
	Response.write """resultcode"":""11"""
	Response.write ",""Tcnt"":"""& returncnt &""""
	Response.write ",""Lcode"":"""& Lcode &""""
	If Date() = "2015-10-26" Then '//마지막날
	Response.write ",""txt"":""<strong>오늘의 물이 <span class='cRd1'>충전되었습니다.</span></strong><p class=tMar05>매일 놀러와 주셔서 감사합니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
	else
	Response.write ",""txt"":""<strong>오늘의 물이 <span class='cRd1'>충전되었습니다.</span></strong><p class=tMar05>내일 또 참여해주세요.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
	End If 
	Response.write "}"
	dbget.close() :	response.End
End If 
'########################################################################################
'//상품 응모
If mode = "water" Then
	'//어뷰징 아웃!
	if userBlackListCheck(userid) Then
		'Response.write "이색히야 넌 영원히 꽝이야"
		renloop = "999"
	End If 

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
	
	'//개인 당첨
	vQuery = "select "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 1 then 1 else 0 end),0) as prize1 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 1 and sub_opt2 = 1 then 1 else 0 end),0) as mywin1 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 2 then 1 else 0 end),0) as prize2 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 2 and sub_opt2 = 1 then 1 else 0 end),0) as mywin2 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 3 then 1 else 0 end),0) as prize3 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 3 and sub_opt2 = 1 then 1 else 0 end),0) as mywin3 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 4 then 1 else 0 end),0) as prize4 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 4 and sub_opt2 = 1 then 1 else 0 end),0) as mywin4 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 5 then 1 else 0 end),0) as prize5 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 5 and sub_opt2 = 1 then 1 else 0 end),0) as mywin5 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 6 then 1 else 0 end),0) as prize6 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 6 and sub_opt2 = 1 then 1 else 0 end),0) as mywin6  "
	vQuery = vQuery & "	from db_temp.dbo.tbl_event_66520 "
	vQuery = vQuery & "	where evt_code = '"& eCode &"' and userid = '"& userid &"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		prize1	= rsget("prize1")	'// 2일차 응모 - 마일리지 200point - 전원지급
		win1	= rsget("mywin1")	'// 당첨여부
		prize2	= rsget("prize2")	'//	5일차 응모 - 새싹키우기(랜덤) - 200명 - 5%
		win2	= rsget("mywin2")	'// 당첨여부
		prize3	= rsget("prize3")	'//	8일차 응모 - 마일리지 300point - 전원지급
		win3	= rsget("mywin3")	'// 당첨여부
		prize4	= rsget("prize4")	'//	11일차 응모 - 기상예측 유리병 - 100명 - 5%
		win4	= rsget("mywin4")	'// 당첨여부
		prize5	= rsget("prize5")	'//	14일차 응모 - 마일리지 500point -  전원지급
		win5	= rsget("mywin5")	'// 당첨여부
		prize6	= rsget("prize6")	'//	17일차 응모 - 샤오미 공기청정기 50명 - 1%
		win6	= rsget("mywin6")	'// 당첨여부
	End IF
	rsget.close()

	'//전체 당첨 개수
	vQuery = "select "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 2 then 1 else 0 end),0) as allwin2 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 4 then 1 else 0 end),0) as allwin4 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 6 then 1 else 0 end),0) as allwin6  "
	vQuery = vQuery & "	from db_temp.dbo.tbl_event_66520 "
	vQuery = vQuery & "	where evt_code = '"& eCode &"' and sub_opt2 = 1 "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		allwin2	= rsget("allwin2")	'// 전체당첨수
		allwin4	= rsget("allwin4")	'// 전체당첨수
		allwin6	= rsget("allwin6")	'// 전체당첨수
	End IF
	rsget.close()

	Sub fnGetPrize(v) 'v 응모 번호 1~6

		If v = 1 Or v = 3 Or v = 5 Then '//비추첨식 응모만 가능 // 마일리지 200 / 300 / 500
			vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '1', '"& device &"')"
			dbget.Execute vQuery
			Response.Write "{ "
			Response.write """resultcode"":""11"""
			Response.write ",""Lcode"":"""& v &""""
			Response.write ",""txt"":""<strong>응모가 <span class='cRd1'>완료</span>되었습니다.</strong><p class='tMar20 contInfo'>마일리지는 <span class='cRd1'>2015년 10월 28일 (수)</span>에 <br />일괄 지급 될 예정입니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
			Response.write "}"
			dbget.close()
			Response.end
		End If 

		If v = 2 Or v = 4 Or v = 6 Then '//추첨식 
			tempwin2 = 200	'//5일차 새싹 키우기(랜덤) 5%
			tempwin4 = 100  '//11일차 기상예측 유리병 5%
			tempwin6 = 10	'//17일차 샤오미 공기청정기 0.5%
			
			If v = 2 Then
				If allwin2 < tempwin2 Then '// 상품 수량 있음
					If renloop < 151 Then '15%
						vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '1', '"& device &"')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""11"""
						Response.write ",""Lcode"":"""& v &""""
						If isapp = "1" Then
						Response.write ",""txt"":""<strong>새싹키우기<span class='cRd1'>당첨</span></strong><span class='giftPhoto'><a href='javascript:fnAPPpopupProduct(802395);return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/gift1.png' alt='새싹키우기' /></a></span><p class='tMar30 congMsg'>축하합니다 : )</p><p class='tMar10 contInfo'><span class='cRd1'>2015년 10월 28일 (수)</span>에 <br />배송지 주소를 입력해주세요.<br />배송지 주소 입력 후 1주일 안에 배송됩니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						Else
						Response.write ",""txt"":""<strong>새싹키우기<span class='cRd1'>당첨</span></strong><span class='giftPhoto'><a href='/shopping/category_prd.asp?itemid=802395'><img src='http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/gift1.png' alt='새싹키우기' /></a></span><p class='tMar30 congMsg'>축하합니다 : )</p><p class='tMar10 contInfo'><span class='cRd1'>2015년 10월 28일 (수)</span>에 <br />배송지 주소를 입력해주세요.<br />배송지 주소 입력 후 1주일 안에 배송됩니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						End If
						Response.write "}"
						dbget.close()
						Response.end
					Else '//확률 꽝
						'//이벤트 테이블에 등록
						vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', '"& device &"')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""22"""
						Response.write ",""Lcode"":"""& v &""""
						If Date() = "2015-10-26" Then '//마지막날
						Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 이벤트를 기다려주세요.<br />매일 놀러와 주셔서 감사합니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						else
						Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 기회를 노려보세요.<br />내일 물주는것 잊지 말기!</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						End If 
						Response.write "}"
						dbget.close()
						Response.end
					End If 
				Else '// 상품수량 오링 -> 꽝처리
					'//이벤트 테이블에 등록
					vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', '"& device &"')"
					dbget.Execute vQuery
					Response.Write "{ "
					Response.write """resultcode"":""22"""
					Response.write ",""Lcode"":"""& v &""""
					If Date() = "2015-10-26" Then '//마지막날
					Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 이벤트를 기다려주세요.<br />매일 놀러와 주셔서 감사합니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
					else
					Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 기회를 노려보세요.<br />내일 물주는것 잊지 말기!</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
					End If 
					Response.write "}"
					dbget.close()
					Response.end
				End If 
			End If 

			If v = 4 Then
				If allwin4 < tempwin4 Then '// 상품 수량 있음
					If renloop < 51 Then '5% 
						vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '1', '"& device &"')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""11"""
						Response.write ",""Lcode"":"""& v &""""
						If isapp = "1" Then 
						Response.write ",""txt"":""<strong>포그링 가습기 <span class='cRd1'>당첨</span></strong><span class='giftPhoto'><a href='javascript:fnAPPpopupProduct(1308640);return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/gift2.png' alt='포그링 가습기' /></a></span><p class='tMar30 congMsg'>축하합니다 : )</p><p class='tMar10 contInfo'><span class='cRd1'>2015년 10월 28일 (수)</span>에 <br />배송지 주소를 입력해주세요.<br />배송지 주소 입력 후 1주일 안에 배송됩니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						Else
						Response.write ",""txt"":""<strong>포그링 가습기 <span class='cRd1'>당첨</span></strong><span class='giftPhoto'><a href='/shopping/category_prd.asp?itemid=1308640'><img src='http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/gift2.png' alt='포그링 가습기' /></a></span><p class='tMar30 congMsg'>축하합니다 : )</p><p class='tMar10 contInfo'><span class='cRd1'>2015년 10월 28일 (수)</span>에 <br />배송지 주소를 입력해주세요.<br />배송지 주소 입력 후 1주일 안에 배송됩니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						End If
						Response.write "}"
						dbget.close()
						Response.end
					Else '//확률 꽝
						'//이벤트 테이블에 등록
						vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', '"& device &"')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""22"""
						Response.write ",""Lcode"":"""& v &""""
						If Date() = "2015-10-26" Then '//마지막날
						Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 이벤트를 기다려주세요.<br />매일 놀러와 주셔서 감사합니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						else
						Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 기회를 노려보세요.<br />내일 물주는것 잊지 말기!</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						End If 
						Response.write "}"
						dbget.close()
						Response.end
					End If 
				Else '// 상품수량 오링 -> 꽝처리
					'//이벤트 테이블에 등록
					vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', '"& device &"')"
					dbget.Execute vQuery
					Response.Write "{ "
					Response.write """resultcode"":""22"""
					Response.write ",""Lcode"":"""& v &""""
					If Date() = "2015-10-26" Then '//마지막날
					Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 이벤트를 기다려주세요.<br />매일 놀러와 주셔서 감사합니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
					else
					Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 기회를 노려보세요.<br />내일 물주는것 잊지 말기!</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
					End If 
					Response.write "}"
					dbget.close()
					Response.end
				End If 			
			End If 

			If v = 6 Then
				If allwin6 < tempwin6 Then '// 상품 수량 있음
					If renloop < 351 Then '35%
						vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '1', '"& device &"')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""11"""
						Response.write ",""Lcode"":"""& v &""""
						If isapp = "1" Then 
						Response.write ",""txt"":""<strong>샤오미 공기청정기 <span class='cRd1'>당첨</span></strong><span class='giftPhoto'><a href='javascript:fnAPPpopupProduct(1284401);return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/gift3.png' alt='샤오미 공기청정기' /></a></span><p class='tMar30 congMsg'>축하합니다 : )</p><p class='tMar10 contInfo'><span class='cRd1'>2015년 10월 28일 (수)</span>에 <br />배송지 주소를 입력해주세요.<br />배송지 주소 입력 후 1주일 안에 배송됩니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						Else 
						Response.write ",""txt"":""<strong>샤오미 공기청정기 <span class='cRd1'>당첨</span></strong><span class='giftPhoto'><a href='/shopping/category_prd.asp?itemid=1284401'><img src='http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/gift3.png' alt='샤오미 공기청정기' /></a></span><p class='tMar30 congMsg'>축하합니다 : )</p><p class='tMar10 contInfo'><span class='cRd1'>2015년 10월 28일 (수)</span>에 <br />배송지 주소를 입력해주세요.<br />배송지 주소 입력 후 1주일 안에 배송됩니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						End If 
						Response.write "}"
						dbget.close()
						Response.end
					Else '//확률 꽝
						'//이벤트 테이블에 등록
						vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', '"& device &"')"
						dbget.Execute vQuery
						Response.Write "{ "
						Response.write """resultcode"":""22"""
						Response.write ",""Lcode"":"""& v &""""
						If Date() = "2015-10-26" Then '//마지막날
						Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 이벤트를 기다려주세요.<br />매일 놀러와 주셔서 감사합니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						else
						Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 기회를 노려보세요.<br />내일 물주는것 잊지 말기!</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
						End If 
						Response.write "}"
						dbget.close()
						Response.end
					End If 
				Else '// 상품수량 오링 -> 꽝처리
					'//이벤트 테이블에 등록
					vQuery = "INSERT INTO db_temp.dbo.tbl_event_66520 (evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& v &"', '2', '"& device &"')"
					dbget.Execute vQuery
					Response.Write "{ "
					Response.write """resultcode"":""22"""
					Response.write ",""Lcode"":"""& v &""""
					If Date() = "2015-10-26" Then '//마지막날
					Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 이벤트를 기다려주세요.<br />매일 놀러와 주셔서 감사합니다.</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
					else
					Response.write ",""txt"":""<strong>앗! <span class='cRd1'>미안</span>해요!</strong><p class='tMar20 contInfo'>아쉽지만 다음 기회를 노려보세요.<br />내일 물주는것 잊지 말기!</p><span class='tMar20 button btM2 bgGry2 cWh1 btnLyrClose'><button onclick='clolyr();'>확인</button></span>"""
					End If 
					Response.write "}"
					dbget.close()
					Response.end
				End If 			
			End If
		End If 
	End Sub

	'//응모 처리
	Dim scnum
	Dim arrcnt : arrcnt = array(2,5,8,11,14,17) '//필요 별 포인트 배열
	Dim prizenum : prizenum = array(prize1,prize2,prize3,prize4,prize5,prize6) '//상품 응모여부 배열
	Dim winnum : winnum = array(win1,win2,win3,win4,win5,win6) '//상품 당첨여부 배열

	For scnum = 1 To 6 '//응모 가짓수
		If myCount >= arrcnt(scnum-1) Then
			If prizenum(scnum-1) = 0 And winnum(scnum-1) = 0 And cstr(arrcnt(scnum-1)) = cstr(waterdrops) Then '// 별 개수 충족 하면서 응모 내역,당첨내역이 없을 경우
				Call fnGetPrize(scnum)
				Exit For '//호출 하고 루프 끝내삼
			ElseIf prizenum(scnum-1) = 1 And cstr(arrcnt(scnum-1)) = cstr(waterdrops) Then '//별 개수 충족 하면서 응모 내역 있을 경우
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