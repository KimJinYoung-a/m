<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'### 셋콤달콤-메가박스
'### 2015-04-17 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, sqlstr, refer , renloop , couponid, couponidx, couponkey, subcouponkey, cnt, cntcom
Dim result1 , result2 , result3, gubun
Dim refip
dim nowdate
	nowdate = date()
'	nowdate = "2015-04-22"

	refip = Request.ServerVariables("REMOTE_ADDR")

	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)

	'//응모 확율
	randomize
	renloop=int(Rnd*1000)+1 '100%
'	renloop=9999

''확율 조정시 첫번째응모,두번째 응모 두군데 수정해야함
''구분1 : 메가박스		renloop > 999 and renloop < 1001		10%		SUCCESS1	끝
''구분2 : 팝콘			renloop > 199 and renloop < 999		70%		SUCCESS2
''구분3 : 토이스토리	renloop > 9 and renloop < 31		3%		SUCCESS3
''구분4 : lgbeam		renloop > 0 and renloop < 2			0.1%	SUCCESS4
''꽝	: 무배쿠폰 		COUPON

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  61757
		couponid = 385
	Else
		eCode   =  60932
		couponid = 729
	End If

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	'// 이벤트 응모기간 확인
	If not(nowdate>="2015-04-21" and nowdate < "2015-04-25") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

	If mode = "add" Then '//응모하기 버튼 클릭
		'// 당일 응모내역 검색
		sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'"
		rsget.Open sqlstr, dbget, 1
		If Not rsget.Eof Then
			result1 = rsget(0) '//응모회수 1,2
			result2 = rsget(1) '//당첨여부 0,1
			result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
		End IF
		rsget.close

		If result1 = "" And result2="" Then '//응모 내역이 없음
			If renloop > 499 and renloop < 601 Then '메가박스쿠폰 난수 당첨시
				''메가박스쿠폰 하루 발급량 카운팅
				sqlStr = "Select count(idx) " &_
						" From db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox " &_
						" WHERE gubun='1' and convert(varchar(10),regdate,120) = '" & nowdate & "' and userid is not null"
				rsget.Open sqlStr,dbget,1
				cnt = rsget(0)
				rsget.Close

				if cnt >= 999 then	''메가박스쿠폰 하루 발급량이 999 넘으면 무배쿠폰 발급
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
					dbget.execute sqlstr

					'로그 1
					sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
					sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '1' )" + vbcrlf
					dbget.execute sqlstr

					Response.write "COUPON"
					dbget.close()	:	response.End
				end if

				if cnt < 999 then	''메가박스쿠폰 하루 발급량이 999 개 미만이면 메가박스쿠폰 발급
					''당첨된 이력 있는지 체크
					sqlstr = "select count(userid) as cnt "
					sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
					sqlstr = sqlstr & " where userid='"& userid &"'"
					rsget.Open sqlstr, dbget, 1

					If Not rsget.Eof Then
						cntcom = rsget(0)
					End IF
					rsget.close

					if cntcom > 0 then	''오늘 응모이력이 없는데 이전에 당첨된 이력이 있으면 무배쿠폰 발급
						If result1 = "" Then
							sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
							dbget.execute sqlstr

							'로그 2
							sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
							sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '2' )" + vbcrlf
							dbget.execute sqlstr

							Response.write "COUPON"
							dbget.close()	:	response.End
						else
							Response.write "END"
							dbget.close()	:	response.End
						end if
					end if

					sqlstr = "select top 1 idx, couponkey, subcouponkey"
					sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
					sqlstr = sqlstr & " where isusing='N' and isnull(userid,'')='' and gubun='1'"
					rsget.Open sqlstr, dbget, 1

					If Not rsget.Eof Then
						couponidx = rsget(0)
						couponkey = rsget(1)
						subcouponkey = rsget(2)
					End IF
					rsget.close

					if userid <> "" then
						''메가박스쿠폰 하나에 userid넣음
						sqlstr = "update [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_megabox] set userid='"& userid &"',isusing='Y',regdate='" & nowdate & "' " + vbcrlf
						sqlstr = sqlstr & " where idx='"& couponidx &"' and isusing='N' and isnull(userid,'')='' and gubun='1' " + vbcrlf
						dbget.execute sqlstr

						''이벤트 응모 및 당첨여부 넣음
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '1', 'A','"& nowdate &"' )" + vbcrlf
						dbget.execute sqlstr

						'로그 3
						sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
						sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '3' )" + vbcrlf
						dbget.execute sqlstr

						Response.write "SUCCESS1" &"!/!"&couponkey&"!/!"&subcouponkey
						dbget.close()	:	response.End
					else
						Response.write "END"
						dbget.close()	:	response.End
					end if
				End if
			Elseif renloop > 199 and renloop < 999 Then '팝콘
				''팝콘 하루 발급량 카운팅
				sqlStr = "Select count(idx) " &_
						" From db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox " &_
						" WHERE gubun='2' and convert(varchar(10),regdate,120) = '" &  nowdate & "' and userid is not null"
				rsget.Open sqlStr,dbget,1
				cnt = rsget(0)
				rsget.Close

				if cnt >= 1699 then	''팝콘 하루 발급량이 1699 개 넘으면 무배쿠폰 발급
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
					dbget.execute sqlstr

					'로그 4
					sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
					sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '4' )" + vbcrlf
					dbget.execute sqlstr

					Response.write "COUPON"
					dbget.close()	:	response.End
				end if

				if cnt < 1699 then	''팝콘 하루 발급량이 1699 개 미만이면 팝콘 발급
					''당첨된 이력 있는지 체크
					sqlstr = "select count(userid) as cnt "
					sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
					sqlstr = sqlstr & " where userid='"& userid &"'"
					rsget.Open sqlstr, dbget, 1

					If Not rsget.Eof Then
						cntcom = rsget(0)
					End IF
					rsget.close

					if cntcom > 0 then	''오늘 응모이력이 없는데 이전에 당첨된 이력이 있으면 무배쿠폰 발급
						If result1 = "" Then
							sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
							dbget.execute sqlstr

							'로그 5
							sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
							sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '5' )" + vbcrlf
							dbget.execute sqlstr

							Response.write "COUPON"
							dbget.close()	:	response.End
						else
							Response.write "END"
							dbget.close()	:	response.End
						end if
					end if

					sqlstr = "select top 1 idx, couponkey, subcouponkey"
					sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
					sqlstr = sqlstr & " where isusing='N' and isnull(userid,'')='' and gubun='2'"
					rsget.Open sqlstr, dbget, 1

					If Not rsget.Eof Then
						couponidx = rsget(0)
						couponkey = rsget(1)
						subcouponkey = rsget(2)
					End IF
					rsget.close

					if userid <> "" then
						''팝콘 하나에 userid넣음
						sqlstr = "update [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_megabox] set userid='"& userid &"',isusing='Y',regdate='" & nowdate & "' " + vbcrlf
						sqlstr = sqlstr & " where idx='"& couponidx &"' and isusing='N' and isnull(userid,'')='' and gubun='2' " + vbcrlf
						dbget.execute sqlstr

						''이벤트 응모 및 당첨여부 넣음
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '1', 'A','"& nowdate &"' )" + vbcrlf
						dbget.execute sqlstr

						'로그 6
						sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
						sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '6' )" + vbcrlf
						dbget.execute sqlstr

						Response.write "SUCCESS2"
						dbget.close()	:	response.End
					else
						Response.write "END"
						dbget.close()	:	response.End
					end if
				End if
			Elseif renloop > 9 and renloop < 31 Then '토이스토리
				''토이스토리 하루 발급량 카운팅
				sqlStr = "Select count(idx) " &_
						" From db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox " &_
						" WHERE gubun='3' and convert(varchar(10),regdate,120) = '" &  nowdate & "' and userid is not null"
				rsget.Open sqlStr,dbget,1
				cnt = rsget(0)
				rsget.Close

				if cnt >= 300 then	''토이스토리 하루 발급량이 300 개 넘으면 무배쿠폰 발급
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
					dbget.execute sqlstr

					'로그 7
					sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
					sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '7' )" + vbcrlf
					dbget.execute sqlstr

					Response.write "COUPON"
					dbget.close()	:	response.End
				end if

				if cnt < 300 then	''토이스토리 하루 발급량이 300 미만이면 토이스토리 발급
					''당첨된 이력 있는지 체크
					sqlstr = "select count(userid) as cnt "
					sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
					sqlstr = sqlstr & " where userid='"& userid &"'"
					rsget.Open sqlstr, dbget, 1

					If Not rsget.Eof Then
						cntcom = rsget(0)
					End IF
					rsget.close

					if cntcom > 0 then	''오늘 응모이력이 없는데 이전에 당첨된 이력이 있으면 무배쿠폰 발급
						If result1 = "" Then
							sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
							dbget.execute sqlstr

							'로그 8
							sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
							sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '8' )" + vbcrlf
							dbget.execute sqlstr

							Response.write "COUPON"
							dbget.close()	:	response.End
						else
							Response.write "END"
							dbget.close()	:	response.End
						end if
					end if

					sqlstr = "select top 1 idx, couponkey, subcouponkey"
					sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
					sqlstr = sqlstr & " where isusing='N' and isnull(userid,'')='' and gubun='3'"
					rsget.Open sqlstr, dbget, 1

					If Not rsget.Eof Then
						couponidx = rsget(0)
						couponkey = rsget(1)
						subcouponkey = rsget(2)
					End IF
					rsget.close

					if userid <> "" then
						''토이스토리 하나에 userid넣음
						sqlstr = "update [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_megabox] set userid='"& userid &"',isusing='Y',regdate='" & nowdate & "' " + vbcrlf
						sqlstr = sqlstr & " where idx='"& couponidx &"' and isusing='N' and isnull(userid,'')='' and gubun='3' " + vbcrlf
						dbget.execute sqlstr

						''이벤트 응모 및 당첨여부 넣음
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '1', 'A','"& nowdate &"' )" + vbcrlf
						dbget.execute sqlstr

						'로그 9
						sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
						sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '9' )" + vbcrlf
						dbget.execute sqlstr

						Response.write "SUCCESS3"
						dbget.close()	:	response.End
					else
						Response.write "END"
						dbget.close()	:	response.End
					end if
				End if
			Elseif renloop > 0 and renloop < 2 Then 'lgbeam
				''lgbeam 하루 발급량 카운팅
				sqlStr = "Select count(idx) " &_
						" From db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox " &_
						" WHERE gubun='4' and convert(varchar(10),regdate,120) = '" &  nowdate & "' and userid is not null"
				rsget.Open sqlStr,dbget,1
				cnt = rsget(0)
				rsget.Close

				if cnt > 0 then	''lgbeam 하루 발급량이 1개 넘으면 무배쿠폰 발급
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
					dbget.execute sqlstr

					'로그 10
					sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
					sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '10' )" + vbcrlf
					dbget.execute sqlstr

					Response.write "COUPON"
					dbget.close()	:	response.End
				end if

				if cnt < 1 then	''lgbeam 하루 발급량이 1 미만이면 lgbeam 발급
					''당첨된 이력 있는지 체크
					sqlstr = "select count(userid) as cnt "
					sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
					sqlstr = sqlstr & " where userid='"& userid &"'"
					rsget.Open sqlstr, dbget, 1

					If Not rsget.Eof Then
						cntcom = rsget(0)
					End IF
					rsget.close

					if cntcom > 0 then	''오늘 응모이력이 없는데 이전에 당첨된 이력이 있으면 무배쿠폰 발급
						If result1 = "" Then
							sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
							dbget.execute sqlstr

							'로그 11
							sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
							sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '11' )" + vbcrlf
							dbget.execute sqlstr

							Response.write "COUPON"
							dbget.close()	:	response.End
						else
							Response.write "END"
							dbget.close()	:	response.End
						end if
					end if

					sqlstr = "select top 1 idx, couponkey, subcouponkey"
					sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
					sqlstr = sqlstr & " where isusing='N' and isnull(userid,'')='' and gubun='4'"
					rsget.Open sqlstr, dbget, 1

					If Not rsget.Eof Then
						couponidx = rsget(0)
						couponkey = rsget(1)
						subcouponkey = rsget(2)
					End IF
					rsget.close

					if userid <> "" then
						''lgbeam 하나에 userid넣음
						sqlstr = "update [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_megabox] set userid='"& userid &"',isusing='Y',regdate='" & nowdate & "' " + vbcrlf
						sqlstr = sqlstr & " where idx='"& couponidx &"' and isusing='N' and isnull(userid,'')='' and gubun='4' " + vbcrlf
						dbget.execute sqlstr

						''이벤트 응모 및 당첨여부 넣음
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '1', 'A','"& nowdate &"' )" + vbcrlf
						dbget.execute sqlstr

						'로그 12
						sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
						sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '12' )" + vbcrlf
						dbget.execute sqlstr

						Response.write "SUCCESS4"
						dbget.close()	:	response.End
					else
						Response.write "END"
						dbget.close()	:	response.End
					end if
				End if
			Else '//비당첨은 무배쿠폰 발급 레이어
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A','"& nowdate &"' )" + vbcrlf
				dbget.execute sqlstr

				'로그 13
				sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
				sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '13' )" + vbcrlf
				dbget.execute sqlstr

				Response.write "COUPON"
				dbget.close()	:	response.end
			End If
		ElseIf result1 = "1" Then '// 두번째 응모시
			If result2 = "0" Then '//두번쨰 응모지만 첫번째응모가 미당첨일 경우
				If result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL" Then '//카카오 초대 안하고 응모를 누른경우
					Response.write "KAKAO" '//카카오 초대를 누르시오 - 카카오 버튼 누를때 update
					Response.end
				Else '//카카오 초대 누르고 응모 누름
					If renloop > 499 and renloop < 601 Then '메가박스 난수 당첨시
						''메가박스 하루 발급량 카운팅
						sqlStr = "Select count(idx) " &_
								" From db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox " &_
								" WHERE gubun='1' and convert(varchar(10),regdate,120) = '" & nowdate & "' and userid is not null"
						rsget.Open sqlStr,dbget,1
						cnt = rsget(0)
						rsget.Close

						if cnt >= 999 then	''메가박스 하루 발급량이 999 개 넘으면 무배쿠폰 발급
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
							dbget.execute sqlstr

							'로그 14
							sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
							sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '14' )" + vbcrlf
							dbget.execute sqlstr

							Response.write "COUPON"
							dbget.close()	:	response.End
						end if

						if cnt < 999 then	''메가박스 하루 발급량이 999 개 미만이면 메가박스 발급
							''당첨된 이력 있는지 체크
							sqlstr = "select count(userid) as cnt "
							sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
							sqlstr = sqlstr & " where userid='"& userid &"'"
							rsget.Open sqlstr, dbget, 1

							If Not rsget.Eof Then
								cntcom = rsget(0)
							End IF
							rsget.close

							if cntcom > 0 then	''오늘 응모이력이 없는데 이전에 당첨된 이력이 있으면 무배쿠폰 발급
								If result1 = "1" Then ''응모횟수가 1이면 무배쿠폰 발급, 2면 종료
									sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
									sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
									dbget.execute sqlstr

									'로그 15
									sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
									sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '15' )" + vbcrlf
									dbget.execute sqlstr

									Response.write "COUPON"
									dbget.close()	:	response.End
								else
									Response.write "END"
									dbget.close()	:	response.End
								end if
							end if

							sqlstr = "select top 1 idx, couponkey, subcouponkey"
							sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
							sqlstr = sqlstr & " where isusing='N' and isnull(userid,'')='' and gubun='1'"
							rsget.Open sqlstr, dbget, 1
		
							If Not rsget.Eof Then
								couponidx = rsget(0)
								couponkey = rsget(1)
								subcouponkey = rsget(2)
							End IF
							rsget.close

							if userid <> "" then
								''메가박스 하나에 userid넣음
								sqlstr = "update [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_megabox] set userid='"& userid &"',isusing='Y',regdate='" & nowdate & "' " + vbcrlf
								sqlstr = sqlstr & " where idx='"& couponidx &"' and isusing='N' and isnull(userid,'')='' and gubun='1' " + vbcrlf
								dbget.execute sqlstr

								''이벤트 응모 및 당첨여부 넣음
								sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '1'" + vbcrlf
								sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
								dbget.execute sqlstr

								'로그 16
								sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
								sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '16' )" + vbcrlf
								dbget.execute sqlstr

								Response.write "SUCCESS1" &"!/!"&couponkey&"!/!"&subcouponkey
								dbget.close()	:	response.End
							else
								Response.write "END"
								dbget.close()	:	response.End
							end if
						End if
					Elseif renloop > 199 and renloop < 999 Then '팝콘
						''팝콘 하루 발급량 카운팅
						sqlStr = "Select count(idx) " &_
								" From db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox " &_
								" WHERE gubun='2' and convert(varchar(10),regdate,120) = '" &  nowdate & "' and userid is not null"
						rsget.Open sqlStr,dbget,1
						cnt = rsget(0)
						rsget.Close

						if cnt >= 1699 then	''팝콘 하루 발급량이 1699 개 넘으면 무배쿠폰 발급
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
							dbget.execute sqlstr

							'로그 17
							sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
							sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '17' )" + vbcrlf
							dbget.execute sqlstr

							Response.write "COUPON"
							dbget.close()	:	response.End
						end if

						if cnt < 1699 then	''팝콘 하루 발급량이 1699 개 미만이면 팝콘 발급
							''당첨된 이력 있는지 체크
							sqlstr = "select count(userid) as cnt "
							sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
							sqlstr = sqlstr & " where userid='"& userid &"'"
							rsget.Open sqlstr, dbget, 1

							If Not rsget.Eof Then
								cntcom = rsget(0)
							End IF
							rsget.close

							if cntcom > 0 then	''오늘 응모이력이 없는데 이전에 당첨된 이력이 있으면 무배쿠폰 발급
								If result1 = "1" Then ''응모횟수가 1이면 무배쿠폰 발급, 2면 종료
									sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
									sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
									dbget.execute sqlstr

									'로그 18
									sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
									sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '18' )" + vbcrlf
									dbget.execute sqlstr
	
									Response.write "COUPON"
									dbget.close()	:	response.End
								else
									Response.write "END"
									dbget.close()	:	response.End
								end if
							end if

							sqlstr = "select top 1 idx, couponkey, subcouponkey"
							sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
							sqlstr = sqlstr & " where isusing='N' and isnull(userid,'')='' and gubun='2'"
							rsget.Open sqlstr, dbget, 1
		
							If Not rsget.Eof Then
								couponidx = rsget(0)
								couponkey = rsget(1)
								subcouponkey = rsget(2)
							End IF
							rsget.close

							if userid <> "" then
								''팝콘 하나에 userid넣음
								sqlstr = "update [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_megabox] set userid='"& userid &"',isusing='Y',regdate='" & nowdate & "' " + vbcrlf
								sqlstr = sqlstr & " where idx='"& couponidx &"' and isusing='N' and isnull(userid,'')='' and gubun='2' " + vbcrlf
								dbget.execute sqlstr

								''이벤트 응모 및 당첨여부 넣음
								sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '1'" + vbcrlf
								sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
								dbget.execute sqlstr

								'로그 19
								sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
								sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '19' )" + vbcrlf
								dbget.execute sqlstr

								Response.write "SUCCESS2"
								dbget.close()	:	response.End
							else
								Response.write "END"
								dbget.close()	:	response.End
							end if
						End if
					Elseif renloop > 9 and renloop < 31 Then '토이스토리
						''토이스토리 하루 발급량 카운팅
						sqlStr = "Select count(idx) " &_
								" From db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox " &_
								" WHERE gubun='3' and convert(varchar(10),regdate,120) = '" &  nowdate & "' and userid is not null"
						rsget.Open sqlStr,dbget,1
						cnt = rsget(0)
						rsget.Close

						if cnt >= 300 then	''토이스토리 하루 발급량이 300 개 넘으면 무배쿠폰 발급
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
							dbget.execute sqlstr

							'로그 20
							sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
							sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '20' )" + vbcrlf
							dbget.execute sqlstr
							
							Response.write "COUPON"
							dbget.close()	:	response.End
						end if

						if cnt < 300 then	''토이스토리 하루 발급량이 300 미만이면 토이스토리 발급
							''당첨된 이력 있는지 체크
							sqlstr = "select count(userid) as cnt "
							sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
							sqlstr = sqlstr & " where userid='"& userid &"'"
							rsget.Open sqlstr, dbget, 1

							If Not rsget.Eof Then
								cntcom = rsget(0)
							End IF
							rsget.close

							if cntcom > 0 then	''오늘 응모이력이 없는데 이전에 당첨된 이력이 있으면 무배쿠폰 발급
								If result1 = "1" Then ''응모횟수가 1이면 무배쿠폰 발급, 2면 종료
									sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
									sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
									dbget.execute sqlstr

									'로그 21
									sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
									sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '21' )" + vbcrlf
									dbget.execute sqlstr
									
									Response.write "COUPON"
									dbget.close()	:	response.End
								else
									Response.write "END"
									dbget.close()	:	response.End
								end if
							end if

							sqlstr = "select top 1 idx, couponkey, subcouponkey"
							sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
							sqlstr = sqlstr & " where isusing='N' and isnull(userid,'')='' and gubun='3'"
							rsget.Open sqlstr, dbget, 1
		
							If Not rsget.Eof Then
								couponidx = rsget(0)
								couponkey = rsget(1)
								subcouponkey = rsget(2)
							End IF
							rsget.close

							if userid <> "" then
								''토이스토리 하나에 userid넣음
								sqlstr = "update [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_megabox] set userid='"& userid &"',isusing='Y',regdate='" & nowdate & "' " + vbcrlf
								sqlstr = sqlstr & " where idx='"& couponidx &"' and isusing='N' and isnull(userid,'')='' and gubun='3' " + vbcrlf
								dbget.execute sqlstr

								''이벤트 응모 및 당첨여부 넣음
								sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '1'" + vbcrlf
								sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
								dbget.execute sqlstr

								'로그 22
								sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
								sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '22' )" + vbcrlf
								dbget.execute sqlstr
								
								Response.write "SUCCESS3"
								dbget.close()	:	response.End
							else
								Response.write "END"
								dbget.close()	:	response.End
							end if
						End if
					Elseif renloop > 0 and renloop < 2 Then 'lgbeam
						''lgbeam 하루 발급량 카운팅
						sqlStr = "Select count(idx) " &_
								" From db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox " &_
								" WHERE gubun='4' and convert(varchar(10),regdate,120) = '" &  nowdate & "' and userid is not null"
						rsget.Open sqlStr,dbget,1
						cnt = rsget(0)
						rsget.Close

						if cnt > 0 then	''lgbeam 하루 발급량이 1개 넘으면 무배쿠폰 발급
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
							dbget.execute sqlstr

							'로그 23
							sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
							sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '23' )" + vbcrlf
							dbget.execute sqlstr
							
							Response.write "COUPON"
							dbget.close()	:	response.End
						end if

						if cnt < 1 then	''lgbeam 하루 발급량이 1 미만이면 lgbeam 발급
							''당첨된 이력 있는지 체크
							sqlstr = "select count(userid) as cnt "
							sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
							sqlstr = sqlstr & " where userid='"& userid &"'"
							rsget.Open sqlstr, dbget, 1

							If Not rsget.Eof Then
								cntcom = rsget(0)
							End IF
							rsget.close

							if cntcom > 0 then	''오늘 응모이력이 없는데 이전에 당첨된 이력이 있으면 무배쿠폰 발급
								If result1 = "1" Then ''응모횟수가 1이면 무배쿠폰 발급, 2면 종료
									sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
									sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
									dbget.execute sqlstr

									'로그 24
									sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
									sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '24' )" + vbcrlf
									dbget.execute sqlstr
									
									Response.write "COUPON"
									dbget.close()	:	response.End
								else
									Response.write "END"
									dbget.close()	:	response.End
								end if
							end if

							sqlstr = "select top 1 idx, couponkey, subcouponkey"
							sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015_megabox"
							sqlstr = sqlstr & " where isusing='N' and isnull(userid,'')='' and gubun='4'"
							rsget.Open sqlstr, dbget, 1
		
							If Not rsget.Eof Then
								couponidx = rsget(0)
								couponkey = rsget(1)
								subcouponkey = rsget(2)
							End IF
							rsget.close

							if userid <> "" then
								''lgbeam 하나에 userid넣음
								sqlstr = "update [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_megabox] set userid='"& userid &"',isusing='Y',regdate='" & nowdate & "' " + vbcrlf
								sqlstr = sqlstr & " where idx='"& couponidx &"' and isusing='N' and isnull(userid,'')='' and gubun='4' " + vbcrlf
								dbget.execute sqlstr

								''이벤트 응모 및 당첨여부 넣음
								sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '1'" + vbcrlf
								sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
								dbget.execute sqlstr

								'로그 25
								sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
								sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '25' )" + vbcrlf
								dbget.execute sqlstr
								
								Response.write "SUCCESS4"
								dbget.close()	:	response.End
							else
								Response.write "END"
								dbget.close()	:	response.End
							end if
						End if
					Else '//비당첨은 무배쿠폰 발급 레이어
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
						dbget.execute sqlstr

						'로그 26
						sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
						sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '26' )" + vbcrlf
						dbget.execute sqlstr
						
						Response.write "COUPON"
						dbget.close()	:	response.end
					End If
				End If
			Else '// 두번째 응모지만 첫번째 응모의 당첨이력이 있는 경우 꽝처리
				If result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL" Then '//카카오 초대 안하고 응모를 누른경우
					Response.write "KAKAO" '//카카오 초대를 누르시오 - 카카오 버튼 누를때 update
					Response.end
				Else '//카카오 초대 누르고 응모 누름
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'" + vbcrlf
					dbget.execute sqlstr

					'로그 27
					sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
					sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '27' )" + vbcrlf
					dbget.execute sqlstr
					
					Response.write "COUPON"
					dbget.close()	:	response.End
				End If
			End If
		Else '//이미 이벤트에 참여했음
			Response.write "END"
			Response.end
		End if
	elseif mode="kakao" then
		'//카카오초대 클릭 카운트
		'// 응모내역 검색
		sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"'"
		rsget.Open sqlstr, dbget, 1
		If Not rsget.Eof Then
			'//최초 응모
			result1 = rsget(0) '//응모회수 1,2
			result2 = rsget(1) '//당첨여부 0,1
			result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
		End IF
		rsget.close

		If result1 = "" Or isnull(result1) Then
			Response.write "NOT1" '//참여 이력이 없음 - 응모후 이용 하시오
			Response.End
		ElseIf result1 = "1" And (result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL") Then '//1회 참여시
			sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
			sqlstr = sqlstr & " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = 'kakao'" + vbcrlf
			sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& nowdate &"' " + vbcrlf
			dbget.execute sqlstr '// 응모 기회 한번 더줌

			'로그 28
			sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_3comdalcom_coupon_2015_log] ( userid , refip , renloop, gubun)" + vbcrlf
			sqlstr = sqlstr & " VALUES('"& userid &"', '"& refip &"' ,'"& renloop &"', '28' )" + vbcrlf
			dbget.execute sqlstr
			
			Response.write "SUCCESS"
			dbget.close()	:	response.End
		ElseIf result1 = "1" And result3 = "kakao" Then
			Response.write "NOT2"
			Response.end
		ElseIf (result1 = "1" And result3 = "kakao") Or result1 = "2" Then
			Response.write "END" '//오늘 참여 끝
			Response.End
		End If

'	elseif mode="banner1" Or mode="banner2" then
'		'//기획전배너 1 , 2
'		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
'		sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
'		dbget.execute sqlstr
'
'		Response.write "OK"
'		dbget.close()	:	response.end

	elseif mode="app_main" then
'		'//앱실행 메인배너 클릭 카운트
		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
		dbget.execute sqlstr

		Response.write "OK"
		dbget.close()	:	response.end

'	elseif mode="notlogin" then
'		'쿠키꿉는다
'		response.cookies("etc").domain="10x10.co.kr"
'		response.cookies("etc")("evtcode") = 58539
'
'		response.write "OK"		'//성공임
'		dbget.close()	:	response.end

	ElseIf mode="coupon" Then
		'//쿠폰 발급
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
		sqlstr = sqlstr & " values('" &couponid &"','"& userid &"','3','2000','셋콤달콤 <무료배송권>','10000','"& nowdate &" 00:00:00','"& nowdate &" 23:59:59','',0,'system')"
		dbget.execute sqlstr
		Response.write "SUCCESS"
		dbget.close()	:	response.end
	Else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="& eCode &"'</script>"
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->