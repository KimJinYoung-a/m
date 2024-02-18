<% option Explicit %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
	IF Len(Request.ServerVariables("HTTP_REFERER")) = 0 Then
	   response.write "<script>alert('access is incorrect');history.back();</script>"
	   response.End
	END IF
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%

	'###########################################################
	' Description : 텐바이텐 X 알람몬 10시에 만나요!
	' History : 2014.07.16 원승현
	'###########################################################

	Dim renloop, renloop2

'// randomize
	randomize
	renloop=int(Rnd*1000)+1 '100%


	dim sqlStr, loginid, evt_code, releaseDate, evt_option, evt_option2, strsql, Linkevt_code
	Dim kit , coupon3 , coupon5 , arrList , i, mylist
	dim usermail, couponkey
	evt_code = requestCheckVar(Request("eventid"),32)		'이벤트 코드
	Linkevt_code = requestCheckVar(Request("linkeventid"),32) '링크코드

	loginid = GetLoginUserID()
	releaseDate = requestCheckVar(Request("releaseDate"),42)

	dim referer
	referer = request.ServerVariables("HTTP_REFERER")

	Dim dfDate, daysum_tent, daysum_mug, daysum_maka, nowdate

	'// 일자별 각 텐트, 머그, 마카룽 일자별 당첨갯수 제한
	Function sDate()
		nowdate=now()
		Select Case left(nowdate,10)
			Case "2014-07-21"
				daysum_tent=3
				daysum_mug=6
				daysum_maka=30
			Case "2014-07-22"
				daysum_tent=2
				daysum_mug=5
				daysum_maka=20
			Case "2014-07-23"
				daysum_tent=1
				daysum_mug=5
				daysum_maka=15
			Case "2014-07-24"
				daysum_tent=1
				daysum_mug=5
				daysum_maka=15
			Case "2014-07-25"
				daysum_tent=1
				daysum_mug=4
				daysum_maka=10
			Case "2014-07-26"
				daysum_tent=1
				daysum_mug=3
				daysum_maka=10
			Case "2014-07-27"
				daysum_tent=1
				daysum_mug=2
				daysum_maka=10
		End Select
		'// 도합 텐트(daysum_tent) 10개, 머그(daysum_mug) 30개, 마카룽(daysum_maka) 110개

	End function

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"77"
		dbget.close()	:	response.End
	end If

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"99"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"88"
		dbget.close()	:	response.End
	end if
	rsget.Close


	'// 각 상품별 당첨확률(텐트-0.1%, 머그-0.5%, 마카룽-1%)	
	'// 각 상품별 당첨확률 변경 2014-07-25 (텐트-0.2%, 머그-1%, 마카룽-2%)	
	'// 도합 상품에 당첨될 확률은 약 1.6%
	'// 각 상품별 당첨 확률 조정은 이쪽에서..
	'// evt_option2값 리턴(1-텐트, 2-머그, 3-마카룽, 4-미당첨)
	'// 텐트(0.1%)
	If renloop < 3 Then
			call sDate()
			If daysum_tent="" Then daysum_tent="1"

			dim kitsum_tent , mykitcnt_tent , totsum_tent
			sqlstr= "select count(case when sub_opt2 = '1' and convert(varchar(10),regdate,120) = '" & left(Now(),10) & "' then sub_opt2 end) as kitsum  " &_
				" ,count(case when sub_opt2 in ('1','2','3') and userid = '" & loginid & "' then sub_opt2 end ) as mykitcnt  " &_
				" ,count(case when sub_opt2 = '1' then sub_opt2 end) as totsum  " &_
				" FROM db_event.dbo.tbl_event_subscript " &_
				" where evt_code='" & evt_code &"' "

			rsget.Open sqlStr,dbget,1
			kitsum_tent = rsget(0)
			mykitcnt_tent = rsget(1)
			totsum_tent	= rsget(2)
			rsget.Close

			If totsum_tent >= 10 Then '// 전체 상품갯수 체크
				evt_option2 = "4"
			else
				If mykitcnt_tent > 0 Then '// 한번이라도 당첨된 이력이 있는지..
					evt_option2 = "4"
				Else
					If kitsum_tent >= daysum_tent Then '// 하루 할당량을 초과하였는지..
						evt_option2 = "4"
					Else
						evt_option2 = "1" '// 텐트
					End If
				End If
			End If
	
	'// 머그컵(0.5%)
	ElseIf renloop >= 3 And renloop < 13 Then
		call sDate()
		If daysum_mug="" Then daysum_mug="2"

			dim kitsum_mug , mykitcnt_mug , totsum_mug
			sqlstr= "select count(case when sub_opt2 = '2' and convert(varchar(10),regdate,120) = '" & left(Now(),10) & "' then sub_opt2 end) as kitsum  " &_
				" ,count(case when sub_opt2 in ('1','2','3') and userid = '" & loginid & "' then sub_opt2 end ) as mykitcnt  " &_
				" ,count(case when sub_opt2 = '2' then sub_opt2 end) as totsum  " &_
				" FROM db_event.dbo.tbl_event_subscript " &_
				" where evt_code='" & evt_code &"' "

			rsget.Open sqlStr,dbget,1
			kitsum_mug = rsget(0)
			mykitcnt_mug = rsget(1)
			totsum_mug	= rsget(2)
			rsget.Close

			If totsum_mug >= 30 Then
				evt_option2 = "4"
			else
				If mykitcnt_mug > 0 Then
					evt_option2 = "4"
				Else
					If kitsum_mug >= daysum_mug Then
						evt_option2 = "4"
					Else
						evt_option2 = "2" '// 머그컵
					End If
				End If
			End If


	'// 마카룽(1%)
	ElseIf renloop >= 13 And renloop < 33 Then
		call sDate()
		If daysum_maka="" Then daysum_maka="10"

			dim kitsum_maka , mykitcnt_maka , totsum_maka
			sqlstr= "select count(case when sub_opt2 = '3' and convert(varchar(10),regdate,120) = '" & left(Now(),10) & "' then sub_opt2 end) as kitsum  " &_
				" ,count(case when sub_opt2 in ('1','2','3') and userid = '" & loginid & "' then sub_opt2 end ) as mykitcnt  " &_
				" ,count(case when sub_opt2 = '3' then sub_opt2 end) as totsum  " &_
				" FROM db_event.dbo.tbl_event_subscript " &_
				" where evt_code='" & evt_code &"' "

			rsget.Open sqlStr,dbget,1
			kitsum_maka = rsget(0)
			mykitcnt_maka = rsget(1)
			totsum_maka	= rsget(2)
			rsget.Close

			If totsum_maka >= 110 Then
				evt_option2 = "4"
			else
				If mykitcnt_maka > 0 Then
					evt_option2 = "4"
				Else
					If kitsum_maka >= daysum_maka Then
						evt_option2 = "4"
					Else
						evt_option2 = "3" '// 마카룽
					End If
				End If
			End If

	Else
		evt_option2 = "4" '// 미당첨
	End If


	'// evt_option2값을 기준으로 사은품명 작성
	Dim giftNameMon

	Select Case Trim(evt_option2)

		Case "1"
			giftNameMon = "메티몬스터 팝업텐트"
		Case "2"
			giftNameMon = "스티키몬스터 머그"
		Case "3"
			giftNameMon = "쿠키몬스터 마카룽"
		Case Else
			giftNameMon = "미당첨"
	
	End Select

	'// 응모 처리
	'// 일자별 중복 응모 확인
	Dim cnt
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code='" & evt_code & "'" &_
			" and userid='" & loginid & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
	rsget.Open sqlStr,dbget,1
	cnt = rsget(0)
	rsget.Close

	If cnt = 0 Then
		sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
				" (evt_code, userid, sub_opt2, sub_opt3, device) values " &_
				" (" & evt_code &_
				",'" & loginid & "'" &_
				",'" & evt_option2 & "'" &_
				",'" & giftNameMon & "'" &_
				",'A')"
				'response.write sqlstr
			dbget.execute(sqlStr)
			response.write evt_option2
			dbget.close()	:	response.End
	else
		response.write "66"
		response.End
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->