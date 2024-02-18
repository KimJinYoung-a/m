<% option Explicit %>
<% Response.CharSet = "euc-kr" %>
<%
	Response.Expires = -1
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cahce"
	Response.AddHeader "cache-Control", "no-cache"
%>
<!-- include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim sqlStr, loginid, eCode, releaseDate , result, opt1, opt2, opt3, opt4, opt
	Dim resulthtml ,  vDown1Cnt , vCoupon1Idx , vCoupon2Idx , vCoupon3Idx

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21048"
		vCoupon1Idx = "288"
		vCoupon2Idx = "289"
		vCoupon3Idx = "290"
	Else
		eCode 		= "48222"
		vCoupon1Idx = "529"
		vCoupon2Idx = "528"
		vCoupon3Idx = "530"
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
	Dim chknum
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code='" & eCode & "'" &_
			" and userid='" & loginid & "' and convert(varchar(10),regdate,120)='" & left(Now(),10) & "' "

	rsget.Open sqlStr,dbget,1
	chknum = rsget(0)
	rsget.Close

	If chknum > 0 then	'오늘 응모 내역이 있을 경우 팅
			response.write "<script type='text/javascript'>" &_
					"alert('하루에 한 번 응모 가능합니다.\n\n내일 다시 응모해주세요.');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & eCode& "';" &_
					"</script>"
	else	'오늘 응모 내역이 없음

		'//응모내역 확인
		sqlstr = "Select " &_
				" sub_opt3" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & loginid & "' "
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			opt = rsget(0)
		End If
		rsget.Close

		opt1 = SplitValue(opt,"//",0)
		opt2 = SplitValue(opt,"//",1)
		opt3 = SplitValue(opt,"//",2)

		If opt1="" then opt1=0
		If opt2="" then opt2=0
		If opt3="" then opt3=0

		If opt1 = 0  And opt2 = 0 And opt3 = 0 then
			sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
			" (evt_code, userid, sub_opt3) values " &_
			" (" & eCode &_
			",'" & loginid & "'" &_
			",'1//')"
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
				sqlStr = sqlStr & "select '" & vCoupon1Idx & "' , '" & loginid & "','2','5000','작심쿠폰_5000원 할인','40000','2014-01-06 00:00:00.000','2014-01-12 23:59:59.000','',0,'system'"
				dbget.execute(sqlStr)
			End IF

			response.write  "<div id='result' value='1'></div>"

		ElseIf  opt1 = 1  And opt2 = 0 And opt3 = 0 then
			sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt3='1//2//' , regdate=getdate()" &_
					" where evt_code='" & eCode & "' and userid='" & loginid & "' "
			dbget.execute(sqlStr)

			'//쿠폰 다운
			sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon2Idx & "'"
			rsget.Open sqlStr,dbget,1
			IF Not rsget.Eof Then
				vDown1Cnt = rsget(0)
			End IF
			rsget.close
			
			If vDown1Cnt = 0  Then
				sqlStr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & vbCrLf
				sqlStr = sqlStr & "select '" & vCoupon2Idx & "' , '" & loginid & "','2','10000','작심쿠폰_10000원 할인','70000','2014-01-06 00:00:00.000','2014-01-12 23:59:59.000','',0,'system'"
				dbget.execute(sqlStr)
			End IF

			response.write  "<div id='result' value='2'></div>"

		ElseIf  opt1 = 1  And opt2 = 2 And opt3 = 0 then
			sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt3='1//2//3//' , regdate=getdate()" &_
					" where evt_code='" & eCode & "' and userid='" & loginid & "' "
			dbget.execute(sqlStr)

			'//쿠폰 다운
			sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon3Idx & "'"
			rsget.Open sqlStr,dbget,1
			IF Not rsget.Eof Then
				vDown1Cnt = rsget(0)
			End IF
			rsget.close
			
			If vDown1Cnt = 0  Then
				sqlStr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & vbCrLf
				sqlStr = sqlStr & "select '" & vCoupon3Idx & "' , '" & loginid & "','2','15000','작심쿠폰_15000원 할인','100000','2014-01-06 00:00:00.000','2014-01-12 23:59:59.000','',0,'system'"
				dbget.execute(sqlStr)
			End IF

			response.write  "<div id='result' value='3'></div>"
		End If 

	end If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->