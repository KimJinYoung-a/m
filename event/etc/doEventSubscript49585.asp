<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	dim sqlStr, loginid, eCode, releaseDate , result, opt1, opt2, opt3, opt4, opt
	Dim resulthtml ,  vDown1Cnt , vCoupon1Idx , vCoupon2Idx , vCoupon3Idx , vBuyCnt
	Dim sub_opt2 : sub_opt2 = requestcheckvar(request("spoint"),1)
	Dim sel1 , sel2 , sel2today , sel3 , sel4 , mytotsum
	Dim refer

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21092"
		vCoupon1Idx = "311"
		vCoupon2Idx = "312"
	Else
		eCode 		= "49584"
		vCoupon1Idx = "558"
		vCoupon2Idx = "559"
	End If

	loginid = GetLoginUserID()

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & eCode & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script type='text/javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	end If

	'응모한 내역 확인
	sqlStr = " select  "&_
		" count(case when sub_opt2 = 1 then sub_opt2 end) as sel1 "&_
		" ,count(case when sub_opt2 = 2 then sub_opt2 end) as sel2 "&_
		" ,count(case when sub_opt2 = 2 and convert(varchar(10),regdate,120)='" & left(Now(),10) & "' then sub_opt2 end) as sel2today "&_
		" ,count(case when sub_opt2 = 3 then sub_opt2 end) as sel3 "&_
		" ,count(case when sub_opt2 = 4 then sub_opt2 end) as sel4 "&_
		" ,count(sub_opt2) as mytotsum "&_
		" from db_event.dbo.tbl_event_subscript " &_
		" WHERE evt_code = '" & eCode & "' and userid = '"& loginid &"'" 
	rsget.Open sqlStr,dbget,1
	sel1 = rsget("sel1")
	sel2 = rsget("sel2")
	sel2today = rsget("sel2today")
	sel3 = rsget("sel3")
	sel4 = rsget("sel4")
	mytotsum = rsget("mytotsum")
	rsget.Close

	If mytotsum >= 5 Then '모든 응모 완료일 경우 팅
			response.write "<script>" &_
			"alert('모든 응모가 완료 되었습니다.');" &_
			"top.location.href='/event/eventmain.asp?eventid=" & eCode& "';" &_
			"</script>"
	Else
		If sub_opt2 = "1" Then '10%
		
			If sel1 = 0 Then '받기전
				sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
				" (evt_code, userid, sub_opt2) values " &_
				" (" & eCode &_
				",'" & loginid & "'" &_
				",'1')"
				dbget.execute(sqlStr)

				'//쿠폰 다운
				sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon1Idx & "'"
				rsget.Open sqlStr,dbget,1
				IF Not rsget.Eof Then
					vDown1Cnt = rsget(0)
				End IF
				rsget.close
				
				If vDown1Cnt = 0  Then
					sqlStr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & vbCrLf
					sqlStr = sqlStr & "select '" & vCoupon1Idx & "' , '" & loginid & "','1','10','[신학기이벤트]10% 할인쿠폰','50000','2014-02-24 00:00:00','2014-03-02 23:59:59','',0,'system'"
					dbget.execute(sqlStr)
				End IF

				response.write  "<div id='result' value='1'></div>"
			Else
				response.write "<script type='text/javascript'>" &_
					"alert('한번만 응모 가능합니다.');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & eCode& "';" &_
					"</script>"
			End If 
		
		ElseIf sub_opt2 = "2" Then  ' 2일체크
			
			If sel2 = 0 Then '등록안됨
				
				sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
				" (evt_code, userid, sub_opt2) values " &_
				" (" & eCode &_
				",'" & loginid & "'" &_
				",'2')"
				dbget.execute(sqlStr)

				response.write  "<div id='result' value='21'></div>"
				
			ElseIf sel2 = 1 Then '체크1

				If sel2today = 0 Then '1회 등록 오늘은 아님

					sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
					" (evt_code, userid, sub_opt2) values " &_
					" (" & eCode &_
					",'" & loginid & "'" &_
					",'2')"
					dbget.execute(sqlStr)

					response.write  "<div id='result' value='22'></div>"

				Else ' 1회 등록후 오늘 재응모시

					response.write "<script type='text/javascript'>" &_
						"alert('하루에 한번만 응모 가능합니다.');" &_
						"</script>"

				End If 
			
			ElseIf sel2 = 2 Then

				response.write "<script type='text/javascript'>" &_
						"alert('이미 응모 하셨습니다.');" &_
						"top.location.href='/event/eventmain.asp?eventid=" & eCode& "';" &_
						"</script>"

			End If 

		ElseIf sub_opt2 = "3" Then  ' 무료배송쿠폰

			If sel3 = 0 Then '받기전
				sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
				" (evt_code, userid, sub_opt2) values " &_
				" (" & eCode &_
				",'" & loginid & "'" &_
				",'3')"
				dbget.execute(sqlStr)

'				'//쿠폰 다운
'				sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon2Idx & "'"
'				rsget.Open sqlStr,dbget,1
'				IF Not rsget.Eof Then
'					vDown1Cnt = rsget(0)
'				End IF
'				rsget.close
'				
'				If vDown1Cnt = 0  Then
'					sqlStr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & vbCrLf
'					sqlStr = sqlStr & "select '" & vCoupon2Idx & "' , '" & loginid & "','2','0','[신학기이벤트] 배송비 환급 쿠폰','20000','2014-02-24 00:00:00','2014-03-02 23:59:59','',0,'system'"
'					dbget.execute(sqlStr)
'				End IF

				response.write  "<div id='result' value='3'></div>"
			Else
				response.write "<script type='text/javascript'>" &_
					"alert('한번만 응모 가능합니다.');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & eCode& "';" &_
					"</script>"
			End If 

		ElseIf sub_opt2 = "4" Then  ' 쇼핑후 응모

			If sel4 = 0 Then

				'//구매이력 체크
				sqlStr = "SELECT count(*) FROM db_order.dbo.tbl_order_master WHERE userid = '" & loginid & "'" &_
							" and regdate >= '2014-02-24 00:00:00' and regdate <= '2014-03-02 23:59:59'	" &_
							" and jumundiv<>'9'	" &_
							" and ipkumdiv > 3 and cancelyn = 'N'"

				rsget.Open sqlStr,dbget,1
				IF Not rsget.Eof Then
					vBuyCnt = rsget(0)
				End IF
				rsget.close

				If vBuyCnt > 0 Then
						sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
						" (evt_code, userid, sub_opt2) values " &_
						" (" & eCode &_
						",'" & loginid & "'" &_
						",'4')"
						dbget.execute(sqlStr)

						response.write  "<div id='result' value='4'></div>"
				Else
						response.write "<script>" &_
							"alert('이벤트 기간 동안 쇼핑 후 참여 가능 합니다.');" &_
							"</script>"
				
				End If
				
			End if

		End If 
	End If 

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->