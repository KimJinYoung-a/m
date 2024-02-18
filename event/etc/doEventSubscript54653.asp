<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
Dim renloop, renloop2 , wincount
randomize
renloop=int(Rnd*1000)+1 '100%

renloop2 = 1

'wincount = 101 '확률 기본 5% 일별로 하단에서 바뀜
wincount = 1001 '확률 기본 5% 일별로 하단에서 바뀜


dim sqlStr, loginid, evt_code, evt_option2, strsql , spoint
Dim kit , coupon3 , coupon5 , arrList , i, mylist
dim usermail

IF application("Svr_Info") = "Dev" THEN
	evt_code 		= "21279"
Else
	evt_code 		= "54652"
End If

loginid = GetLoginUserID()
spoint = requestCheckVar(Request("spoint"),1)		'선택 상품 1~4
dim referer
referer = request.ServerVariables("HTTP_REFERER")

Dim dfDate, daysum, nowdate
Dim daysubsum1 , daysubsum2 , daysubsum3 , daysubsum4 '텐텐 사은품

'에뛰드 1000개 일별 확률 조정 가능
Function sDate()
nowdate=now()
	Select Case left(nowdate,10)
'			Case "2014-09-18" '테스트 지울꺼
'				daysum=140 
'				daysubsum1 = 35 '촉촉 패키지 + 드리밍 웨일티 인퓨저
'				daysubsum2 = 35 '촉촉 패키지 + 잼 스튜디오 리본 손거울
'				daysubsum3 = 35 '촉촉 패키지 + 메모렛 아이스크림 휴대용 스피커
'				daysubsum4 = 35 '촉촉 패키지 + 아노락 각질제거용 페이스 글로쓰
		Case "2014-09-22"
			daysum=140 
			daysubsum1 = 35
			daysubsum2 = 35
			daysubsum3 = 35
			daysubsum4 = 35
			'wincount = 51
			wincount = 201 '자정까지 20%
		Case "2014-09-23"
			daysum=180
			daysubsum1 = 45
			daysubsum2 = 45
			daysubsum3 = 45
			daysubsum4 = 45
			'wincount = 51
			'wincount = 101
			wincount = 201 '자정까지 20%
		Case "2014-09-24"
			daysum=180
			daysubsum1 = 66
			daysubsum2 = 77
			daysubsum3 = 94
			daysubsum4 = 57
			'wincount = 51
			wincount = 201 '자정까지 20%
		Case "2014-09-25"
			daysum=140
			daysubsum1 = 35
			daysubsum2 = 35
			daysubsum3 = 35
			daysubsum4 = 35
			'wincount = 101
			wincount = 201 '자정까지 20%
		Case "2014-09-26"
			daysum=100
			daysubsum1 = 25
			daysubsum2 = 25
			daysubsum3 = 25
			daysubsum4 = 25
			wincount = 101
		Case "2014-09-27"
			daysum=48
			daysubsum1 = 12
			daysubsum2 = 12
			daysubsum3 = 12
			daysubsum4 = 12
			wincount = 101
		Case "2014-09-28"
			daysum=52
			daysubsum1 = 13
			daysubsum2 = 13
			daysubsum3 = 13
			daysubsum4 = 13
			wincount = 101
		Case "2014-09-29"
			daysum=72
			daysubsum1 = 18
			daysubsum2 = 18
			daysubsum3 = 18
			daysubsum4 = 18
			wincount = 101
		Case "2014-09-30"
			daysum=48
			daysubsum1 = 12
			daysubsum2 = 12
			daysubsum3 = 12
			daysubsum4 = 12
			wincount = 101
		Case "2014-10-01"
			daysum=269
			daysubsum1 = 70
			daysubsum2 = 76
			daysubsum3 = 99
			daysubsum4 = 24
			wincount = 301
		Case "2014-10-02"
			daysum=150
			daysubsum1 = 43
			daysubsum2 = 42
			daysubsum3 = 65
			daysubsum4 = 0
			wincount = 1001
	End Select

End Function


'// 로그인 여부 확인 //
if loginid="" or isNull(loginid) then
	Response.Write	"<script>alert('이벤트에 응모를 하려면 로그인이 필요합니다.');</script>"
	Response.Write	"<script>location.href='/login/login.asp?backpath=" & RefURLQ() & "';</script>"
	dbget.close()	:	response.End
end If

'// 이벤트 기간 확인 //
sqlStr = "Select evt_startdate, evt_enddate " &_
		" From db_event.dbo.tbl_event " &_
		" WHERE evt_code='" & evt_code & "'"
rsget.Open sqlStr,dbget,1
if rsget.EOF or rsget.BOF then
	Response.Write	"<script>alert('존재하지 않는 이벤트입니다.');</script>"
	dbget.close()	:	response.End
elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
	Response.Write	"<script>alert('죄송합니다. 이벤트 기간이 아닙니다.');</script>"
	response.write	"<script>location.replace('" + Cstr(referer) + "');</script>"
	dbget.close()	:	response.End
end if
rsget.Close

'// 5% 당첨확률
'//2014-09-22 오후 6시 확률 조정 5% -> 20%
'//2014-09-23 오전 9시 40분 확률 조정 5% -> 10%
'//2014-09-23 오후 5시 20분 확률 조정 10% -> 20%
'//2014-09-24 오후 1시 40분 확률 조정 5% -> 20%
'//2014-09-25 오후 6시 00분 확률 조정 기본 확률 조정 5% -> 10%
If renloop < wincount Then
		call sDate()
		dim mykitcnt , totsum , kitsum1 , kitsum2 , kitsum3 , kitsum4
		sqlstr= "select count(case when sub_opt2 = '3' and convert(varchar(10),regdate,120) = '" & left(Now(),10) & "' and sub_opt1 = '1' then sub_opt2 end) as kitsum1  " &_
			" ,count(case when sub_opt2 = '3' and convert(varchar(10),regdate,120) = '" & left(Now(),10) & "' and sub_opt1 = '2' then sub_opt2 end) as kitsum2  " &_
			" ,count(case when sub_opt2 = '3' and convert(varchar(10),regdate,120) = '" & left(Now(),10) & "' and sub_opt1 = '3' then sub_opt2 end) as kitsum3  " &_
			" ,count(case when sub_opt2 = '3' and convert(varchar(10),regdate,120) = '" & left(Now(),10) & "' and sub_opt1 = '4' then sub_opt2 end) as kitsum4  " &_
			" ,count(case when sub_opt2 = '3' and userid = '" & loginid & "' then sub_opt2 end ) as mykitcnt  " &_
			" ,count(case when sub_opt2 = '3' then sub_opt2 end) as totsum  " &_
			" FROM db_event.dbo.tbl_event_subscript " &_
			" where evt_code='" & evt_code &"' "

		rsget.Open sqlStr,dbget,1
		kitsum1 = rsget(0)
		kitsum2 = rsget(1)
		kitsum3 = rsget(2)
		kitsum4 = rsget(3)
		mykitcnt = rsget(4)
		totsum	= rsget(5)
		rsget.Close

		If totsum >= 1000 Then '// 총 당첨갯수가 1000개가 넘으면..
			evt_option2 = renloop2
		else
			If mykitcnt > 0 Then '// 한번이라도 당첨된 이력이 있으면..
				evt_option2 = renloop2
			Else
				If (kitsum1 + kitsum2 + kitsum3 + kitsum4) >= daysum Then '// 하루 당첨된 인원이 할당량보다 많으면..
					evt_option2 = renloop2
				Else
					If (spoint ="1" And kitsum1 >= daysubsum1) Or (spoint ="2" And kitsum2 >= daysubsum2) Or (spoint ="3" And kitsum3 >= daysubsum3) Or (spoint ="4" And kitsum4 >= daysubsum4) Then
						evt_option2 = renloop2
					Else
						evt_option2 = "3" 'kit '// 아님 킷에 당첨됨..
					End If 
				End If
			End If
		End If
Else
	evt_option2 = "1" '꽝
End If

'응모 처리
'중복 응모 확인
Dim cnt
sqlStr = "Select count(sub_idx) " &_
		" From db_event.dbo.tbl_event_subscript " &_
		" WHERE evt_code='" & evt_code & "'" &_
		" and userid='" & loginid & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
rsget.Open sqlStr,dbget,1
cnt = rsget(0)
rsget.Close

If cnt >= 1 Then
	response.write "<script>alert('하루 1회만 응모 가능합니다.');</script>"
	response.write	"<script>location.replace('" + Cstr(referer) + "');</script>"
else
	'이벤트 정상응모 
	If evt_option2 ="1" Then '꽝임

		sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
				" (evt_code, userid, sub_opt1, sub_opt2 , device) values " &_
				" (" & evt_code &_
				",'" & loginid & "'" &_
				",'" & spoint & "'" &_
				",'" & evt_option2 & "'" &_
				",'M')"
				'response.write sqlstr
				'response.write sqlstr
		dbget.execute(sqlStr)
		
		If Left(now(),10) = "2014-10-02" then
			response.write "<script>alert('앗, 아쉬워요! \n이벤트는 오늘이 마지막 , 그동안 함께 해줘서 고마워요.\n당신이 늘 촉촉하길 바래요');</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
		Else 
			response.write "<script>alert('앗, 아쉬워요! \n당신의 재도전이 필요한 순간, 내일 다시 도전해주세요!');</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
		End If 
		dbget.close()	:	response.End

	else	'키트 당첨
		sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
				" (evt_code, userid, sub_opt1, sub_opt2 , device) values " &_
				" (" & evt_code &_
				",'" & loginid & "'" &_
				",'" & spoint & "'" &_
				",'" & evt_option2 & "'" &_
				",'M')"
				'response.write sqlstr
		dbget.execute(sqlStr)
			response.write "<script>alert('축하합니다!\n촉촉 탱탱 패키지에 당첨되셨습니다.');</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
			dbget.close()	:	response.End
	End If
End If

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->