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
<%

	dim sqlStr, loginid, evt_code,  evt_option, evt_option2, strsql, secret_cnt2, secret_cnt4
	Dim arrList , i, mylist, result, upmode, aa
	Dim renloop
	randomize
	renloop=int(Rnd*1000)+1 '1000
'	renloop=300
	evt_code = requestCheckVar(Request("evt_code"),32)		'이벤트 코드
	result = requestCheckVar(Request("result"),32)
	loginid = GetLoginUserID()
	upmode = requestCheckVar(Request("upmode"),32)
	if upmode="" then upmode="insert"
	dim referer
	referer = request.ServerVariables("HTTP_REFERER")
	Dim totalsum, cnt

	'//접속 경로 확인
	if InStr(referer,"10x10.co.kr")<1 then
		Response.Write	"<script type='text/javascript'>" &_
						"alert('잘못된 접속입니다.');" &_
						"</script>"
		dbget.close()	:	response.end
	end if

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script type='text/javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	end If

	If Not(loginid="" or isNull(loginid)) Then
		sqlstr = "Select count(sub_idx) as totcnt" &_
				"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & evt_code & "' and userid='" & GetLoginUserID() & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			totalsum = rsget(0)
			cnt = rsget(1)
		rsget.Close
	End if

	'// 중복이벤트 참여 여부 확인
'	if cnt >= 2 then
'		Response.Write	"<script type='text/javascript'>" &_
'						"alert('하루에 2번 응모 가능합니다.\n\n내일 다시 응모해주세요.');" &_
'						"</script>"
'		dbget.close()	:	response.End
'	end if

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script type='text/javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script type='text/javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close


if upmode="result_update" then

	Dim sidx
	sqlstr="Select top 1 sub_idx from db_event.dbo.tbl_event_subscript where evt_code='" & evt_code & "' and userid='" & loginid & "' order by regdate desc"

	rsget.Open sqlStr,dbget,1
	IF Not (rsget.EOF OR rsget.BOF) THEN
		sidx= rsget(0)
	END IF
	rsget.Close

	If result="1" Then	'꽝
		Response.Write	"<script language='javascript'>" &_
						"top.location.href='/event/eventmain.asp?eventid=44416';" &_
						"</script>"


		sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt2='" & result & "'" &_
				 " where userid='" & loginid & "' and sub_idx='"& sidx & "'"
		dbget.execute(sqlStr)
	ElseIf result="2" Then
		If renloop = 300 Then
			'시크릿선물일 경우
			sqlstr = "select count(case when sub_opt2='2' then sub_idx end) as cnt2 " &_
					"  from db_event.dbo.tbl_event_subscript where evt_code='44415' and sub_opt3='secret'"
					'response.write sqlstr
			rsget.Open sqlStr,dbget,1
				secret_cnt2 = rsget(0)
			rsget.Close
			If secret_cnt2 >= 2 Then
				aa = "<img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_gift01.png' alt='3000원 할인쿠폰' style='width:100%;' /> <p class='okBtn'><a href='/event/eventmain.asp?eventid=44416' target='_top'><img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn02.png' alt='확인' style='width:100%;' /></a></p>"
				sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
						" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
						" select '445','" & loginid & "','2','3000','우는 아이를 달래주세요!(3,000원 할인쿠폰)','20000','2013-08-14 00:00:00.000' ,'2013-08-25 23:59:59.000','',0,'system'"

						'response.write sqlstr
				dbget.execute(sqlStr)

				sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt2='" & result & "'" &_
						 " where userid='" & loginid & "' and sub_idx='"& sidx & "'"
				dbget.execute(sqlStr)
			else
				sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt2='" & result & "', sub_opt3='secret'" &_
						 " where userid='" & loginid & "' and sub_idx='"& sidx & "'"
				dbget.execute(sqlStr)

				aa = "<img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_gift03.png' alt='시크릿선물' style='width:100%;' /> <p class='okBtn'><a href='/event/eventmain.asp?eventid=44416' target='_top'><img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn02.png' alt='확인' style='width:100%;' /></a></p>"
			End If

		else
			aa = "<img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_gift01.png' alt='3000원 할인쿠폰' style='width:100%;' /> <p class='okBtn'><a href='/event/eventmain.asp?eventid=44416' target='_top'><img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn02.png' alt='확인' style='width:100%;' /></a></p>"
			sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
					" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
					" select '445','" & loginid & "','2','3000','우는 아이를 달래주세요!(3,000원 할인쿠폰)','20000','2013-08-14 00:00:00.000' ,'2013-08-25 23:59:59.000','',0,'system'"

					'response.write sqlstr
			dbget.execute(sqlStr)
			sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt2='" & result & "'" &_
					 " where userid='" & loginid & "' and sub_idx='"& sidx & "'"
			dbget.execute(sqlStr)
		End If
	ElseIf result="3" Then
		aa = "<img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_gift01.png' alt='3000원 할인쿠폰' style='width:100%;' /> <p class='okBtn'><a href='/event/eventmain.asp?eventid=44416' target='_top'><img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn02.png' alt='확인' style='width:100%;' /></a></p>"
		sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
				" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
				" select '445','" & loginid & "','2','3000','우는 아이를 달래주세요!(3,000원 할인쿠폰)','20000','2013-08-14 00:00:00.000' ,'2013-08-25 23:59:59.000','',0,'system'"

				'response.write sqlstr
		dbget.execute(sqlStr)

		sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt2='" & result & "'" &_
				 " where userid='" & loginid & "' and sub_idx='"& sidx & "'"
		dbget.execute(sqlStr)
	ElseIf result="4" Then
		If renloop = 300 Then
			'시크릿선물일 경우
			sqlstr = "select count(case when sub_opt2='4' then sub_idx end) as cnt4 " &_
					"  from db_event.dbo.tbl_event_subscript where evt_code='44415' and sub_opt3='secret'"
					'response.write sqlstr
			rsget.Open sqlStr,dbget,1
				secret_cnt4 = rsget(0)
			rsget.Close
			If secret_cnt4 >= 3 Then	'시크릿선물갯수 초과
				aa = "<img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_gift02.png' alt='무료배송쿠폰' style='width:100%;' /> <p class='okBtn'><a href='/event/eventmain.asp?eventid=44416' target='_top'><img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn02.png' alt='확인' style='width:100%;' /></a></p>"

				sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
						" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
						" select '446','" & loginid & "','3','2000','우는 아이를 달래주세요!(무료배송쿠폰)','20000','2013-08-14 00:00:00.000' ,'2013-08-25 23:59:59.000','',0,'system'"

						'response.write sqlstr
				dbget.execute(sqlStr)

				sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt2='" & result & "'" &_
						 " where userid='" & loginid & "' and sub_idx='"& sidx & "'"
				dbget.execute(sqlStr)
			else
				sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt2='" & result & "', sub_opt3='secret'" &_
						 " where userid='" & loginid & "' and sub_idx='"& sidx & "'"
				dbget.execute(sqlStr)

				aa = "<img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_gift03.png' alt='시크릿선물' style='width:100%;' /> <p class='okBtn'><a href='/event/eventmain.asp?eventid=44416' target='_top'><img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn02.png' alt='확인' style='width:100%;' /></a></p>"
			End If

		else
			aa = "<img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_gift02.png' alt='무료배송쿠폰' style='width:100%;' /> <p class='okBtn'><a href='/event/eventmain.asp?eventid=44416' target='_top'><img src='http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn02.png' alt='확인' style='width:100%;' /></a></p>"

			sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
					" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
					" select '446','" & loginid & "','3','2000','우는 아이를 달래주세요!(무료배송쿠폰)','20000','2013-08-14 00:00:00.000' ,'2013-08-25 23:59:59.000','',0,'system'"

					'response.write sqlstr
			dbget.execute(sqlStr)

			sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt2='" & result & "'" &_
					 " where userid='" & loginid & "' and sub_idx='"& sidx & "'"
			dbget.execute(sqlStr)
		End If

	End If

		response.write "<script type='text/javascript'>" &_
		"parent.document.getElementById(""result_win"").innerHTML=""" & aa & """;" &_
		"</script>"
else
	sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
			" (evt_code, userid, sub_opt2) values " &_
			" (" & evt_code &_
			",'" & loginid & "'" &_
			",'" & evt_option2 & "')"
			'response.write sqlstr
	dbget.execute(sqlStr)

End If








%>
<!-- #include virtual="/lib/db/dbclose.asp" -->