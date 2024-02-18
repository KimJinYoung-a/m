<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 31-1 M/A 찰떡식물
' History : 2016-06-03 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/badgelibUTF8.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim eCode, userid, mode, sqlstr, refer, myscent, mycomcnt, vQuery, enterCnt, vQanswer, vYCnt, vResultScore, splitQanswer, vSubOpt1Val, deviceGubun
Dim refip, myfolderCnt, vFidx, foldername, vqWishItems , totcnt, suncnt, sansecnt, hubcnt, maricnt
Dim myfavorite, vWishEventOX, vqWishItemsLen, intResult, intloop, r1Cnt, r2Cnt, r3Cnt, r4Cnt, rankingDataResult, qSelectAnswer, qSelectAnsTxt


	userid = GetEncLoginUserID
	refer = request.ServerVariables("HTTP_REFERER")
	refip = Request.ServerVariables("REMOTE_ADDR")
	vQanswer = requestcheckvar(request("qAnswer"),128)
	mode = requestcheckvar(request("mode"),128)

	'// 디바이스 구분
	If isApp = "1" Then
		deviceGubun = "A"
	Else
		deviceGubun = "M"
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66145
	Else
		eCode   =  71150
	End If

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If not( left(now(),10)>="2016-06-03" and left(now(),10)<"2016-09-01" ) Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End If

	If mode = "add" Then '//응모하기 버튼 클릭
		'// 무조건 총합 1자이여야 하므로 해당 값 체크하여 1자가 넘거나 초과하면 튕김
		If Len(Trim(vQanswer))=1 Then
			'// 들어온값 추출
			 vQanswer = Trim(vQanswer)
		Else
			Response.Write "Err|정상적인 경로가 아닙니다."
			dbget.close() : Response.End
		End If

		'// 들어온값으로 결과도출
		Select Case vQanswer
			Case "1"
				qSelectAnswer = 1
				qSelectAnsTxt = "선인장"
			Case "2"
				qSelectAnswer = 2
				qSelectAnsTxt = "산세베리아"
			Case "3","4"
				qSelectAnswer = 3
				qSelectAnsTxt = "마리모"
			Case "5"
				qSelectAnswer = 4
				qSelectAnsTxt = "허브"
			Case Else
				qSelectAnswer = 1
				qSelectAnsTxt = "선인장"
		End Select

		'// 결과값(사용자응모값, 타입값)을 집어넣는다.
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, device, regdate)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vQanswer&"', '"&qSelectAnswer&"','"&Trim(qSelectAnsTxt)&"', '"&deviceGubun&"',getdate() )" + vbcrlf
		dbget.execute sqlstr

		'// 전체 갯수를 가져온다.
		sqlstr = "Select cnt, typename From "
		sqlstr = sqlstr & " ( "
		sqlstr = sqlstr & " 	Select count(sub_opt2) as cnt, '1' as typename from [db_event].[dbo].[tbl_event_subscript] Where evt_code='"&eCode&"' And sub_opt2=1 "
		sqlstr = sqlstr & " 	union all "
		sqlstr = sqlstr & " 	Select count(sub_opt2) as cnt, '2' as typename from [db_event].[dbo].[tbl_event_subscript] Where evt_code='"&eCode&"' And sub_opt2=2 "
		sqlstr = sqlstr & " 	union all "
		sqlstr = sqlstr & " 	Select count(sub_opt2) as cnt, '3' as typename from [db_event].[dbo].[tbl_event_subscript] Where evt_code='"&eCode&"' And sub_opt2=3 "
		sqlstr = sqlstr & " 	union all "
		sqlstr = sqlstr & " 	Select count(sub_opt2) as cnt, '4' as typename from [db_event].[dbo].[tbl_event_subscript] Where evt_code='"&eCode&"' And sub_opt2=4 "
		sqlstr = sqlstr & " 	union all "
		sqlstr = sqlstr & " 	Select count(sub_opt2) as cnt, 't' as typename from [db_event].[dbo].[tbl_event_subscript] Where evt_code='"&eCode&"' "
		sqlstr = sqlstr & " ) aa order by cnt desc "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If Not rsget.Eof Then
			Do Until rsget.eof
				Select Case Trim(rsget("typename"))
					Case "t"
						totcnt = FormatNumber(rsget("cnt"), 0)
					Case "1"
						suncnt = FormatNumber(rsget("cnt"), 0)
					Case "2"
						sansecnt = FormatNumber(rsget("cnt"), 0)
					Case "3"
						maricnt = FormatNumber(rsget("cnt"), 0)
					Case "4"
						hubcnt = FormatNumber(rsget("cnt"), 0)
				End Select					
			rsget.movenext
			Loop
		End If

		Response.Write "OK|"&qSelectAnswer&"|"&suncnt&"|"&sansecnt&"|"&hubcnt&"|"&maricnt&"|"&totcnt
		dbget.close() : Response.End

	Else
		Response.Write "Err|정상적인 경로가 아닙니다."
		dbget.close() : Response.End
	end If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->