<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description :  드래곤볼 시사회 이벤트
' History : 2015-09-23 원승현 생성
'####################################################
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
Dim vMovieTicket, vMoonSticker
Dim vMovieTicketSt, vMovieTicketEd, vMoonStickerSt, vMoonStickerEd, vQueryCheck

	
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
		eCode = "64896"
		eCouponID = 786
	Else
		eCode = "66390"
		eCouponID = 786
	End If


	'// 각 상품별 일자별 한정갯수 셋팅
	Select Case Trim(Left(Now(), 10))
		Case "2015-09-23" 
			vMovieTicket = 0
			vMoonSticker = 0

		Case "2015-09-24"
			vMovieTicket = 30
			vMoonSticker = 30

		Case "2015-09-25"
			vMovieTicket = 20
			vMoonSticker = 21

		Case "2015-09-26"
			vMovieTicket = 20
			vMoonSticker = 20

		Case "2015-09-27"
			vMovieTicket = 5
			vMoonSticker = 5

		Case "2015-09-28"
			vMovieTicket = 5
			vMoonSticker = 5

		Case "2015-09-29"
			vMovieTicket = 10
			vMoonSticker = 10

		Case "2015-09-30"
			vMovieTicket = 10
			vMoonSticker = 10

		Case Else
			vMovieTicket = 0
			vMoonSticker = 0
	End Select

	'// 각 상품별 확률 셋팅
	vMovieTicketSt = 1 '// 예매권(5%)
	vMovieTicketEd = 51 '// 예매권(5%)

	vMoonStickerSt = 120 '// 달빛 스티커(5%)
	vMoonStickerEd = 171 '// 달빛 스티커(5%)


	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(userid&"10")


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If


	'// expiredate
	If not(left(Now(),10)>="2015-09-23" and left(Now(),10)<"2015-10-01") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If


	'// 7월 14일만 10시부터 응모 가능함, 그 이후에는 0시 기준으로 응모가능
'	If Left(Now(), 10) = "2015-07-14" Then
'		If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(23, 59, 59)) Then
'			Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
'			Response.End
'		End If
'	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

	Select Case Trim(mode)
		Case "add"

			'// 당첨 상품 랜덤 셀렉트
			randomize
			RvSelNum=int(Rnd*2)+1
			'RvSelNum = 1



			Select Case Trim(RvSelNum)

				Case "1" '// 영화 예매권(총100개)
					
					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 쿠폰당첨, 1-예매권, 2-달빛스티커
						result3 = rsget(2) '// sns 공유시 공유채널(,로 구분하여 배열로 저장)
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close


					'// 최대 4회까지 응모 가능하기 때문에 각 응모횟수별 alert창 다름 해서.. 응모 횟수별 조건으로 체크해야됨
					Select Case Trim(result1)
						Case "" '// 최초 응모시
							'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
							If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0", "1")
								dbget.close()	:	response.End
							End If

							'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
							If userBlackListCheck(userid) Then
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0", "1")
								dbget.close()	:	response.End
							End If

							'// 현재 재고 파악(예매권)
							'// 일자별로 정해진 수량 체크
							If chkProductCntToday(eCode, "1") >= vMovieTicket Then
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "예매권재고초과비당첨처리", eCouponID, "0", "1")
								dbget.close()	:	response.End
							Else
								'// 수량이 남아 있을경우
								'// 랜덤숫자 부여
								randomize
								RvConNum=int(Rnd*1000)+1 '100%
								'// 당첨확률 2%
								If RvConNum >= vMovieTicketSt And RvConNum < vMovieTicketEd Then
									'// 당첨
									Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "드래곤볼 예매권 당첨", eCouponID, "1", "1")
									dbget.close()	:	response.End
								Else
									'// 비당첨
									Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "드래곤볼 예매권 비당첨", eCouponID, "0", "1")
									dbget.close()	:	response.End
								End If
							End If


						Case "1" '// 기존에 1회 응모시

							'// sns에 1회 이상 남겼는지 확인
							If chkSnsCnt(userid, eCode) >= 1 Then
								'// 해당 아이디로 금일 당첨된 상품이 있다면 무조건 비당첨 처리한다.
								If chkrightCntToday(eCode, userid) Then
									Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "해당일자중복비당첨처리", eCouponID, "0", "2")
									dbget.close()	:	response.End
								Else
									'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
									If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0", "2")
										dbget.close()	:	response.End
									End If

									'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
									If userBlackListCheck(userid) Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0", "2")
										dbget.close()	:	response.End
									End If

									'// 현재 재고 파악(예매권)
									'// 일자별로 정해진 수량 체크
									If chkProductCntToday(eCode, "1") >= vMovieTicket Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "예매권재고초과비당첨처리", eCouponID, "0", "2")
										dbget.close()	:	response.End
									Else
										'// 수량이 남아 있을경우
										'// 랜덤숫자 부여
										randomize
										RvConNum=int(Rnd*1000)+1 '100%
										'// 당첨확률 2%
										If RvConNum >= vMovieTicketSt And RvConNum < vMovieTicketEd Then
											'// 당첨
											Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "드래곤볼 예매권 당첨", eCouponID, "1", "2")
											dbget.close()	:	response.End
										Else
											'// 비당첨
											Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "드래곤볼 예매권 비당첨", eCouponID, "0", "2")
											dbget.close()	:	response.End
										End If
									End If
								End If
							Else
								Response.Write "Err|하루 한 번만 참여할 수 있습니다.>?n한 번 더 참여하려면 SNS에 공유해주세요."
								Response.End
							End If

						Case "2" '// 기존에 2회 응모시
							'// sns에 2회 이상 남겼는지 확인
							If chkSnsCnt(userid, eCode) >= 2 Then
								'// 해당 아이디로 금일 당첨된 상품이 있다면 무조건 비당첨 처리한다.
								If chkrightCntToday(eCode, userid) Then
									Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "해당일자중복비당첨처리", eCouponID, "0", "3")
									dbget.close()	:	response.End
								Else
									'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
									If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0", "3")
										dbget.close()	:	response.End
									End If

									'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
									If userBlackListCheck(userid) Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0", "3")
										dbget.close()	:	response.End
									End If

									'// 현재 재고 파악(예매권)
									'// 일자별로 정해진 수량 체크
									If chkProductCntToday(eCode, "1") >= vMovieTicket Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "예매권재고초과비당첨처리", eCouponID, "0", "3")
										dbget.close()	:	response.End
									Else
										'// 수량이 남아 있을경우
										'// 랜덤숫자 부여
										randomize
										RvConNum=int(Rnd*1000)+1 '100%
										'// 당첨확률 2%
										If RvConNum >= vMovieTicketSt And RvConNum < vMovieTicketEd Then
											'// 당첨
											Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "드래곤볼 예매권 당첨", eCouponID, "1", "3")
											dbget.close()	:	response.End
										Else
											'// 비당첨
											Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "드래곤볼 예매권 비당첨", eCouponID, "0", "3")
											dbget.close()	:	response.End
										End If
									End If
								End If
							Else
								Response.Write "Err|하루 한 번만 참여할 수 있습니다.>?n한 번 더 참여하려면 SNS에 공유해주세요."
								Response.End
							End If

						Case "3" '// 기존에 3회 응모시
							'// sns에 3회 이상 남겼는지 확인
							If chkSnsCnt(userid, eCode) >= 3 Then
								If chkrightCntToday(eCode, userid) Then
									Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "해당일자중복비당첨처리", eCouponID, "0", "4")
									dbget.close()	:	response.End
								Else
									'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
									If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0", "4")
										dbget.close()	:	response.End
									End If

									'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
									If userBlackListCheck(userid) Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0", "4")
										dbget.close()	:	response.End
									End If

									'// 현재 재고 파악(예매권)
									'// 일자별로 정해진 수량 체크
									If chkProductCntToday(eCode, "1") >= vMovieTicket Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "예매권재고초과비당첨처리", eCouponID, "0", "4")
										dbget.close()	:	response.End
									Else
										'// 수량이 남아 있을경우
										'// 랜덤숫자 부여
										randomize
										RvConNum=int(Rnd*1000)+1 '100%
										'// 당첨확률 2%
										If RvConNum >= vMovieTicketSt And RvConNum < vMovieTicketEd Then
											'// 당첨
											Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "드래곤볼 예매권 당첨", eCouponID, "1", "4")
											dbget.close()	:	response.End
										Else
											'// 비당첨
											Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "드래곤볼 예매권 비당첨", eCouponID, "0", "4")
											dbget.close()	:	response.End
										End If
									End If
								End If
							Else
								Response.Write "Err|하루 한 번만 참여할 수 있습니다.>?n한 번 더 참여하려면 SNS에 공유해주세요."
								Response.End
							End If

						Case Else '// 모든 응모를 완료하였을시
							If Left(now(), 10) < "2015-09-30" Then
								Response.Write "Err|오늘의 응모기회는 끝!>?n내일 다시 참여해주세요.:)"
							Else
								Response.Write "Err|오늘의 응모를 모두 하셨습니다!"
							End If
							response.End
					End Select

				Case "2" '// 달빛 스티커(총100개)

					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 쿠폰당첨, 1-예매권, 2-달빛스티커
						result3 = rsget(2) '// sns 공유시 공유채널(,로 구분하여 배열로 저장)
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close


					'// 최대 4회까지 응모 가능하기 때문에 각 응모횟수별 alert창 다름 해서.. 응모 횟수별 조건으로 체크해야됨
					Select Case Trim(result1)
						Case "" '// 최초 응모시
							'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
							If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0", "1")
								dbget.close()	:	response.End
							End If

							'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
							If userBlackListCheck(userid) Then
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0", "1")
								dbget.close()	:	response.End
							End If

							'// 현재 재고 파악(달빛 스티커)
							'// 일자별로 정해진 수량 체크
							If chkProductCntToday(eCode, "2") >= vMoonSticker Then
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "스티커재고초과비당첨처리", eCouponID, "0", "1")
								dbget.close()	:	response.End
							Else
								'// 수량이 남아 있을경우
								'// 랜덤숫자 부여
								randomize
								RvConNum=int(Rnd*1000)+1 '100%
								'// 당첨확률 2%
								If RvConNum >= vMoonStickerSt And RvConNum < vMoonStickerEd Then
									'// 당첨
									Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "달빛 스티커 당첨", eCouponID, "2", "1")
									dbget.close()	:	response.End
								Else
									'// 비당첨
									Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "달빛 스티커 비당첨", eCouponID, "0", "1")
									dbget.close()	:	response.End
								End If
							End If

						Case "1" '// 기존에 1회 응모시
							'// sns에 1회 이상 남겼는지 확인
							If chkSnsCnt(userid, eCode) >= 1 Then
								If chkrightCntToday(eCode, userid) Then
									Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "해당일자중복비당첨처리", eCouponID, "0", "2")
									dbget.close()	:	response.End
								Else
									'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
									If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0", "2")
										dbget.close()	:	response.End
									End If

									'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
									If userBlackListCheck(userid) Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0", "2")
										dbget.close()	:	response.End
									End If

									'// 현재 재고 파악(달빛 스티커)
									'// 일자별로 정해진 수량 체크
									If chkProductCntToday(eCode, "2") >= vMoonSticker Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "스티커재고초과비당첨처리", eCouponID, "0", "2")
										dbget.close()	:	response.End
									Else
										'// 수량이 남아 있을경우
										'// 랜덤숫자 부여
										randomize
										RvConNum=int(Rnd*1000)+1 '100%
										'// 당첨확률 2%
										If RvConNum >= vMoonStickerSt And RvConNum < vMoonStickerEd Then
											'// 당첨
											Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "달빛 스티커 당첨", eCouponID, "2", "2")
											dbget.close()	:	response.End
										Else
											'// 비당첨
											Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "달빛 스티커 비당첨", eCouponID, "0", "2")
											dbget.close()	:	response.End
										End If
									End If
								End If
							Else
								Response.Write "Err|하루 한 번만 참여할 수 있습니다.>?n한 번 더 참여하려면 SNS에 공유해주세요."
								Response.End
							End If

						Case "2" '// 기존에 2회 응모시
							'// sns에 2회 이상 남겼는지 확인
							If chkSnsCnt(userid, eCode) >= 2 Then
								If chkrightCntToday(eCode, userid) Then
									Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "해당일자중복비당첨처리", eCouponID, "0", "3")
									dbget.close()	:	response.End
								Else
									'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
									If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0", "3")
										dbget.close()	:	response.End
									End If

									'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
									If userBlackListCheck(userid) Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0", "3")
										dbget.close()	:	response.End
									End If

									'// 현재 재고 파악(달빛 스티커)
									'// 일자별로 정해진 수량 체크
									If chkProductCntToday(eCode, "2") >= vMoonSticker Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "스티커재고초과비당첨처리", eCouponID, "0", "3")
										dbget.close()	:	response.End
									Else
										'// 수량이 남아 있을경우
										'// 랜덤숫자 부여
										randomize
										RvConNum=int(Rnd*1000)+1 '100%
										'// 당첨확률 2%
										If RvConNum >= vMoonStickerSt And RvConNum < vMoonStickerEd Then
											'// 당첨
											Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "달빛 스티커 당첨", eCouponID, "2", "3")
											dbget.close()	:	response.End
										Else
											'// 비당첨
											Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "달빛 스티커 비당첨", eCouponID, "0", "3")
											dbget.close()	:	response.End
										End If
									End If
								End If
							Else
								Response.Write "Err|하루 한 번만 참여할 수 있습니다.>?n한 번 더 참여하려면 SNS에 공유해주세요."
								Response.End
							End If

						Case "3" '// 기존에 3회 응모시
							'// sns에 3회 이상 남겼는지 확인
							If chkSnsCnt(userid, eCode) >= 3 Then
								If chkrightCntToday(eCode, userid) Then
									Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "해당일자중복비당첨처리", eCouponID, "0", "4")
									dbget.close()	:	response.End
								Else
									'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
									If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", eCouponID, "0", "4")
										dbget.close()	:	response.End
									End If

									'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
									If userBlackListCheck(userid) Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", eCouponID, "0", "4")
										dbget.close()	:	response.End
									End If

									'// 현재 재고 파악(예매권)
									'// 일자별로 정해진 수량 체크
									If chkProductCntToday(eCode, "2") >= vMoonSticker Then
										Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "스티커재고초과비당첨처리", eCouponID, "0", "4")
										dbget.close()	:	response.End
									Else
										'// 수량이 남아 있을경우
										'// 랜덤숫자 부여
										randomize
										RvConNum=int(Rnd*1000)+1 '100%
										'// 당첨확률 2%
										If RvConNum >= vMoonStickerSt And RvConNum < vMoonStickerEd Then
											'// 당첨
											Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "달빛 스티커 당첨", eCouponID, "2", "4")
											dbget.close()	:	response.End
										Else
											'// 비당첨
											Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "달빛 스티커 비당첨", eCouponID, "0", "4")
											dbget.close()	:	response.End
										End If
									End If
									rsget.close
								End If
							Else
								Response.Write "Err|하루 한 번만 참여할 수 있습니다.>?n한 번 더 참여하려면 SNS에 공유해주세요."
								Response.End
							End If

						Case Else '// 모든 응모를 완료하였을시
							If Left(now(), 10) < "2015-09-30" Then
								Response.Write "Err|오늘의 응모기회는 끝!>?n내일 다시 참여해주세요.:)"
							Else
								Response.Write "Err|오늘의 응모를 모두 하셨습니다!"
							End If
							response.End
					End Select

				Case Else

			End Select


		Case "snsadd"
			'// 응모여부를 확인하고 응모하였으면 진행 하지 않았으면 alert창 표시
			sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '// 응모횟수
				result2 = rsget(1) '// 당첨여부 0일 경우엔 쿠폰당첨, 1-예매권, 2-달빛스티커
				result3 = rsget(2) '// sns 공유시 공유채널(,로 구분하여 배열로 저장)
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			If Trim(result1)="" Then
				'// 응모여부가 없으면 alert창 표시
				Response.Write "Err|먼저 응모하신 후 SNS 채널에 공유하셔야 한 번 더 신룡을 부를 수 있습니다."
				response.End
			Else
				If Trim(result3) = "" Or isnull(result3) Then
					result3 = snsGubun
				Else
					result3 = result3&","&snsGubun
				End If
				Select Case Trim(result1)

					Case "" '// 한번도 응모 안하였을경우
						Response.Write "Err|먼저 응모하신 후 SNS 채널에 공유하셔야 한 번 더 신룡을 부를 수 있습니다."
						response.End

					Case "1" '// 한번 응모하였을 경우

						'// 응모를 1회 했다면 sns는 최대 한번까지만 가능함
						If chkSnsCnt(userid, eCode) >= 1 Then
							Response.Write "Err|먼저 응모하신 후 SNS 채널에 공유하셔야 한 번 더 신룡을 부를 수 있습니다."
							response.End
						Else
							'// sns 공유채널 입력
							sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = '"&result3&"' Where evt_code='"&eCode&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(now(), 10)&"' "
							dbget.execute sqlstr

							'// 로그 집어넣음
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value1, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&snsGubun&"', '"&deviceGubun&"')"
							dbget.execute sqlstr

							Response.Write "OK|"&snsGubun
							response.End
						End If 

					Case "2" '// 2번 응모하였을 경우
						'// 응모를 2회 했다면 sns는 최대 2번까지만 가능함
						If chkSnsCnt(userid, eCode) >= 2 Then
							Response.Write "Err|먼저 응모하신 후 SNS 채널에 공유하셔야 한 번 더 신룡을 부를 수 있습니다."
							response.End
						Else
							'// sns 공유채널 입력
							sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = '"&result3&"' Where evt_code='"&eCode&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(now(), 10)&"' "
							dbget.execute sqlstr

							'// 로그 집어넣음
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value1, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&snsGubun&"', '"&deviceGubun&"')"
							dbget.execute sqlstr

							Response.Write "OK|"&snsGubun
							response.End
						End If 

					Case "3" '// 3번 응모하였을 경우
						'// 응모를 3회 했다면 sns는 최대 3번까지만 가능함
						If chkSnsCnt(userid, eCode) >= 3 Then
							Response.Write "Err|먼저 응모하신 후 SNS 채널에 공유하셔야 한 번 더 신룡을 부를 수 있습니다."
							response.End
						Else
							'// sns 공유채널 입력
							sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = '"&result3&"' Where evt_code='"&eCode&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(now(), 10)&"' "
							dbget.execute sqlstr

							'// 로그 집어넣음
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value1, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&snsGubun&"', '"&deviceGubun&"')"
							dbget.execute sqlstr

							Response.Write "OK|"&snsGubun
							response.End
						End If 

					Case Else
						If Left(now(), 10) < "2015-09-30" Then
							Response.Write "Err|오늘의 SNS채널 추가응모기회는 끝!!>?n내일 다시 참여해주세요.:)"
						Else
							Response.Write "Err|오늘의 SNS채널 추가응모기회를 모두 사용하였습니다."
						End If
						response.End

				End Select
			End If

	End Select



	Function confirmChkValue(gubun, userid, eCode, deviceGubun, refip, logValue, eCouponID, rightValue, confirmcnt)

		Dim sqlstr

		'// gubun - 당첨 비당첨 구분
		'// userid - 유저아이디
		'// deviceGubun - 디바이스 구분
		'// refip - 유저 아이피
		'// logValue - 로그에 들어갈 문구
		'// eCouponID - 쿠폰번호
		'// rightValue - 당첨상품번호(0-쿠폰, 1-예매권, 2-달빛스티커)
		'// confirmcnt - 응모횟수

		If gubun="Y" Then
			'// 당첨
			If confirmcnt >= 2 Then
				sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '"&confirmcnt&"', sub_opt2='"&rightvalue&"' Where evt_code='"&eCode&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(now(), 10)&"' "
				dbget.execute sqlstr
			Else
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&confirmcnt&"', '"&rightValue&"', '', getdate(), '"&deviceGubun&"')"
				dbget.execute sqlstr
			End If

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&logValue&"', '"&deviceGubun&"')"
			dbget.execute sqlstr

			If Trim(rightValue) = "1" Then
				Response.write "OK|<div class='layerCont'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/66390/m/cupn_movie.png' alt='영화 &lt;드래곤볼Z : 부활의 F&gt; 전용 예매권 1인2매 당첨!' /></div><button class='btnLyrClose' onclick=""jsCloseDragonPopup();"">닫기</button></div>"
			ElseIf Trim(rightValue) = "2" Then
				Response.write "OK|<div class='layerCont'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/66390/m/cupn_sticker.png' alt='소원을 이뤄주는 달빛 스티커' /></div><button class='btnLyrClose' onclick=""jsCloseDragonPopup();"">닫기</button></div>"
			Else
				Response.write "OK|<div class='layerCont'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/66390/m/cupn_sticker.png' alt='영화 &lt;드래곤볼Z : 부활의 F&gt; 전용 예매권 1인2매 당첨!' /></div><button class='btnLyrClose' onclick=""jsCloseDragonPopup();"">닫기</button></div>"
			End If

		Else
			'// 비당첨시
			If confirmcnt >= 2 Then
				sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '"&confirmcnt&"' Where evt_code='"&eCode&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(now(), 10)&"' "
				dbget.execute sqlstr
			Else
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&confirmcnt&"', '"&rightValue&"', getdate(), '"&deviceGubun&"')"
				dbget.execute sqlstr
			End If

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&logValue&"', '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 쿠폰 넣어준다.
			sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
					 "values('"& eCouponID &"', '" & userid & "', '2','3000','드래곤볼 쿠폰 3,000원-3만원이상','30000','2015-09-21 00:00:00','2015-10-04 23:59:59','',0,'system','app')"
			dbget.execute sqlstr


			confirmChkValue = "OK|<div class='layerCont'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/66390/m/cupn_apponly.png' alt='APP 전용 3,000원 쿠폰' /></div><button class='btnLyrClose' onclick=""jsCloseDragonPopup();"">닫기</button></div>"
		End If

	End Function

	Function chkSnsCnt(userid, eCode)

		Dim sqlstr

		sqlstr = " Select count(userid) From db_log.dbo.tbl_caution_event_log Where value1 in ('tw','ka','fb') And userid='"&userid&"' and convert(varchar(10), regdate, 120) = '"&Left(now(), 10)&"' and evt_code='"&eCode&"' "
		rsget.Open sqlstr,dbget,adOpenForwardOnly,adLockReadOnly
		chkSnsCnt = rsget(0)
		rsget.close

	End Function


	Function chkrightCntToday(eCode, userid)

		Dim sqlstr

		'// 해당 아이디로 금일 당첨된 상품이 있다면 무조건 비당첨 처리한다.
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2 in ('1','2') And userid='"&userid&"' "	
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

		'// 현재 재고 파악(예매권)
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&rightvalue&"' "			
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		chkProductCntToday = rsget(0)
		rsget.close

	End Function
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->