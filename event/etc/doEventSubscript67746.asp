<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 텐바이텐 X 영화 <스누피: 더 피너츠 무비>
' History : 2015.11.30 원승현
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, eCouponID, RvchrNum, LoginUserid, deviceGubun, snsGubun
Dim vQuery, strsql
Dim RvSelNum '// 상품 셀렉트 랜덤숫자
Dim RvConNum '// 당첨 랜덤숫자
Dim result1, result2, result3
Dim evtUserCell, refer, refip
Dim vMovieTicket, vSisaTicket, vTshirt
Dim vMovieTicketSt, vMovieTicketEd, vSisaTicketSt, vSisaTicketEd, vTshirtSt, vTshirtEd

Dim vQueryCheck, imgLoop, imgLoopVal

	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	snsGubun = requestcheckvar(request("snsGubun"),32)
	userid = GetEncLoginUserID


	'// 디바이스 구분
	If isApp = "1" Then
		deviceGubun = "A"
	Else
		deviceGubun = "M"
	End If

	evtUserCell = get10x10onlineusercell(userid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "65963"
		eCouponID = 800
	Else
		eCode 		= "67746"
		eCouponID = 800
	End If


	'// 각 상품별 일자별 한정갯수 셋팅
	Select Case Trim(Left(Now(), 10))
		Case "2015-11-30" 
			vMovieTicket = 20
			vSisaTicket = 10
			vTshirt = 5

		Case "2015-12-01"
			vMovieTicket = 30
			vSisaTicket = 20
			vTshirt = 10

		Case "2015-12-02"
			vMovieTicket = 30
			vSisaTicket = 20
			vTshirt = 10

		Case "2015-12-03"
			vMovieTicket = 30
			vSisaTicket = 10
			vTshirt = 10

		Case "2015-12-04"
			vMovieTicket = 30
			vSisaTicket = 10
			vTshirt = 5

		Case "2015-12-05"
			vMovieTicket = 30
			vSisaTicket = 10
			vTshirt = 5

		Case "2015-12-06"
			vMovieTicket = 30
			vSisaTicket = 20
			vTshirt = 5

		Case "2015-12-07"
			vMovieTicket = 86
			vSisaTicket = 57
			vTshirt = 0

		Case "2015-12-08"
			vMovieTicket = 0
			vSisaTicket = 0
			vTshirt = 0

		Case "2015-12-09"
			vMovieTicket = 0
			vSisaTicket = 0
			vTshirt = 0

		Case Else
			vMovieTicket = 0
			vSisaTicket = 0
			vTshirt = 0

	End Select


	'// 각 상품별 확률 셋팅
	vMovieTicketSt = 500 '// 영화 예매권(200)(40%)
	vMovieTicketEd = 900 '// 영화 예매권(200)(40%)

	vSisaTicketSt = 100 '// 시사회 초대(100)(30%)
	vSisaTicketEd = 300 '// 시사회 초대(100)(30%)

	vTshirtSt = 0 '// 티셔츠(50)(0%)
	vTshirtEd = 0 '// 티셔츠(50)(0%)

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(userid&"10")


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	Select Case Trim(mode)
		Case "add"

			'// expiredate
			If not(left(Now(),10)>="2015-11-30" and left(Now(),10)<"2015-12-10") Then
			'If not(left(Now(),10)>="2015-11-19" and left(Now(),10)<"2015-11-28") Then
				Response.Write "Err|이벤트 응모 기간이 아닙니다."
				Response.End
			End If


			'// 11월 23일만 10시부터 응모 가능함, 그 이후에는 0시 기준으로 응모가능
'			If Left(Now(), 10) = "2015-11-23" Then
			'If Left(Now(), 10) = "2015-11-19" Then
'				If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(23, 59, 59)) Then
'					Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
'					Response.End
'				End If
'			End If

			'// 로그인 여부 체크
			If Not(IsUserLoginOK) Then
				Response.Write "Err|로그인 후 참여하실 수 있습니다."
				response.End
			End If


			'// 당첨 상품 랜덤 셀렉트
			randomize
			RvSelNum=int(Rnd*3)+1
			'RvSelNum = 1

			Select Case Trim(RvSelNum)
				Case "1" '// 영화 예매권(총200장)
					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 쿠폰, 1-영화 예매권, 2-시사회, 3-티셔츠
						result3 = rsget(2) '// 일단 안씀
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close
					If Trim(result1)="" Then
						'// 응모내역이 없을시
						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						End If

						'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
						If userBlackListCheck(userid) Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						End If

						'// 현재 재고 파악(영화 예매권)
						'// 일자별로 정해진 수량 체크
						If chkProductCntToday(eCode, "1") >= vMovieTicket Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "영화예매권재고초과비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						Else
							'// 수량이 남아 있을경우
							'// 랜덤숫자 부여
							randomize
							RvConNum=int(Rnd*1000)+1 '100%
							'// 당첨확률 2%
							If RvConNum >= vMovieTicketSt And RvConNum < vMovieTicketEd Then
								'// 당첨
								Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "영화 예매권 당첨", eCouponID, "1")
								dbget.close()	:	response.End
							Else
								'// 비당첨
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "영화 예매권 비당첨", eCouponID, "0")
								dbget.close()	:	response.End
							End If
						End If
					Else
						'// 응모를 1회 했을시
						If Left(now(), 10) >= "2015-12-09" Then
							Response.Write "Err|하루 1회만 응모 가능합니다."
						Else
							Response.Write "Err|하루 1회만 응모 가능합니다.>?n내일 다시 응모해주세요. :)"
						End If
						response.End
					End If


				Case "2" '// 시사회 초대권(총100장)
					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 쿠폰, 1-영화 예매권, 2-시사회, 3-티셔츠
						result3 = rsget(2) '// 일단 안씀
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close
					If Trim(result1)="" Then
						'// 응모내역이 없을시
						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						End If

						'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
						If userBlackListCheck(userid) Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						End If

						'// 현재 재고 파악(시사회 초대권)
						'// 일자별로 정해진 수량 체크
						If chkProductCntToday(eCode, "2") >= vSisaTicket Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "시사회초대권재고초과비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						Else
							'// 수량이 남아 있을경우
							'// 랜덤숫자 부여
							randomize
							RvConNum=int(Rnd*1000)+1 '100%

							'// 당첨확률 1%
							If RvConNum >= vSisaTicketSt And RvConNum < vSisaTicketEd Then
								'// 당첨
								Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "시사회 초대권 당첨", eCouponID, "2")
								dbget.close()	:	response.End
							Else
								'// 비당첨
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "시사회 초대권 비당첨", eCouponID, "0")
								dbget.close()	:	response.End
							End If
						End If
					Else
						'// 응모를 1회 했을시
						If Left(now(), 10) >= "2015-12-09" Then
							Response.Write "Err|하루 1회만 응모 가능합니다."
						Else
							Response.Write "Err|하루 1회만 응모 가능합니다.>?n내일 다시 응모해주세요. :)"
						End If
						response.End
					End If


				Case "3" '// 스누피 티셔츠(총50장)
					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 쿠폰, 1-영화 예매권, 2-시사회, 3-티셔츠
						result3 = rsget(2) '// 일단 안씀
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close
					If Trim(result1)="" Then
						'// 응모내역이 없을시
						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						End If

						'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
						If userBlackListCheck(userid) Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						End If

						'// 현재 재고 파악(스누피 티셔츠)
						'// 일자별로 정해진 수량 체크
						If chkProductCntToday(eCode, "3") >= vTshirt Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "스누피티셔츠재고초과비당첨처리", eCouponID, "0")
							dbget.close()	:	response.End
						Else
							'// 수량이 남아 있을경우
							'// 랜덤숫자 부여
							randomize
							RvConNum=int(Rnd*1000)+1 '100%

							'// 당첨확률 0.5%
							If RvConNum >= vTshirtSt And RvConNum < vTshirtEd Then
								'// 당첨
								Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "스누피 티셔츠 당첨", eCouponID, "3")
								dbget.close()	:	response.End
							Else
								'// 비당첨
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "스누피 티셔츠 비당첨", eCouponID, "0")
								dbget.close()	:	response.End
							End If
						End If
					Else
						'// 응모를 1회 했을시
						If Left(now(), 10) >= "2015-12-09" Then
							Response.Write "Err|하루 1회만 응모 가능합니다."
						Else
							Response.Write "Err|하루 1회만 응모 가능합니다.>?n내일 다시 응모해주세요. :)"
						End If
						response.End
					End If

				Case Else
					Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
					Response.End
			End Select

		Case Else
			Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
			Response.End
	End Select



	Function confirmChkValue(gubun, userid, eCode, deviceGubun, refip, logValue, eCouponID, rightValue)

		Dim sqlstr

		'// gubun - 당첨 비당첨 구분
		'// userid - 유저아이디
		'// deviceGubun - 디바이스 구분
		'// refip - 유저 아이피
		'// logValue - 로그에 들어갈 문구
		'// eCouponID - 쿠폰 아이디
		'// rightValue - 당첨상품번호(1-리플렉트 에코히터, 2-기상예측 유리병, 3-호우호우 텀블러1, 4-호우호우 텀블러2)

		If gubun="Y" Then
			'// 당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '"&rightValue&"', '', getdate(), '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&logValue&"', '"&deviceGubun&"')"
			dbget.execute sqlstr


			If Trim(rightValue) = "1" Then
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/img_gift_01.png' alt='당첨! 영화 전용 예매권 1인 2매 당첨 공지 12월 9일' /></p><button type='button' id='btnClose' class='btnClose' onclick='fnSnoopyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_close.png' alt='닫기' /></button>"
			ElseIf Trim(rightValue) = "2" Then
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/img_gift_02.png' alt='당첨! 시사회 초대권 1인 2매 당첨 공지 12월 9일' /></p><button type='button' id='btnClose' class='btnClose' onclick='fnSnoopyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_close.png' alt='닫기' /></button>"
			ElseIf Trim(rightValue) = "3" Then
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/img_gift_03.png' alt='당첨! 스누피 오리지널 티셔츠 당첨 공지 12월 9일' /></p><button type='button' id='btnClose' class='btnClose' onclick='fnSnoopyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_close.png' alt='닫기' /></button>"
			Else
				If isApp="1" Then
					Response.write "OK|<p><a href='' onclick=""fnAPPpopupBrowserURL('쿠폰북','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;"" title='쿠폰 확인하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/img_gift_04.png' alt='고마워요 스누피! 즐거운 쇼핑을 선물할께!' /></a></p><button type='button' id='btnClose' class='btnClose' onclick='fnSnoopyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_close.png' alt='닫기' /></button>"
				Else
					Response.write "OK|<p><a href='/my10x10/couponbook.asp' title='쿠폰 확인하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/img_gift_04.png' alt='고마워요 스누피! 즐거운 쇼핑을 선물할께!' /></a></p><button type='button' id='btnClose' class='btnClose' onclick='fnSnoopyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_close.png' alt='닫기' /></button>"
				End If
			End If
		Else
			'// 비당첨시
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '"&rightValue&"', getdate(), '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&logValue&"', '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 쿠폰 넣어준다.
			sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & _
					 "values('"& eCouponID &"', '" & userid & "', '3','2000','고마워, 스누피 무료배송 쿠폰','10000','"&Left(now(), 10)&" 00:00:00','2015-12-09 23:59:59','',0,'system')"
			dbget.execute sqlstr

			If isApp="1" Then
				Response.write "OK|<p><a href='' onclick=""fnAPPpopupBrowserURL('쿠폰북','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;"" title='쿠폰 확인하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/img_gift_04.png' alt='고마워요 스누피! 즐거운 쇼핑을 선물할께!' /></a></p><button type='button' id='btnClose' class='btnClose' onclick='fnSnoopyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_close.png' alt='닫기' /></button>"
			Else
				Response.write "OK|<p><a href='/my10x10/couponbook.asp' title='쿠폰 확인하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/img_gift_04.png' alt='고마워요 스누피! 즐거운 쇼핑을 선물할께!' /></a></p><button type='button' id='btnClose' class='btnClose' onclick='fnSnoopyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_close.png' alt='닫기' /></button>"
			End If

		End If

	End Function


	Function chkrightCntToday(eCode, userid)

		Dim sqlstr

		'// 해당 아이디로 금일 당첨된 상품이 있다면 무조건 비당첨 처리한다.
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2 in ('1','2','3') And userid='"&userid&"' "	
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If rsget(0) > 0 Then
			chkrightCntToday = True
		Else
			chkrightCntToday = False
		End If
		rsget.close
	End Function 

	Function chkProductCntToday(eCode, rightvalue)

		Dim sqlstr

		'// 현재 재고 파악
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&rightvalue&"' "			
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		chkProductCntToday = rsget(0)
		rsget.close

	End Function
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->