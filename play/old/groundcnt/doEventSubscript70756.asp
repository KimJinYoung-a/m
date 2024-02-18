<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 30-3 M/A 유형선택
' History : 2016-05-14 원승현 생성
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
Dim refip, myfolderCnt, vFidx, foldername, vqWishItems
Dim myfavorite, vWishEventOX, vqWishItemsLen, intResult, intloop, r1Cnt, r2Cnt, r3Cnt, r4Cnt, rankingDataResult


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
		eCode   =  66130
	Else
		eCode   =  70756
	End If

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If not( left(now(),10)>="2016-05-14" and left(now(),10)<"2016-07-01" ) Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End If

	If mode = "add" Then '//응모하기 버튼 클릭
		'// 무조건 총합 4자이여야 하므로 해당 값 체크하여 4자가 넘거나 초과하면 튕김
		If Len(Trim(vQanswer))=4 Then
			'// 들어온값 추출
			 splitQanswer = Trim(vQanswer)
		Else
			Response.Write "Err|정상적인 경로가 아닙니다."
			dbget.close() : Response.End
		End If

		vSubOpt1Val = "type0"&getResultSbsValue(Trim(splitQanswer))

		'// 결과값(사용자응모값, 타입값)을 집어넣는다.
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, device, regdate)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vSubOpt1Val&"', '"&getResultSbsValue(Trim(splitQanswer))&"','"&Trim(vQanswer)&"', '"&deviceGubun&"',getdate() )" + vbcrlf
		dbget.execute sqlstr

		Response.Write "OK|"&getResultSbsValue(Trim(splitQanswer))
		dbget.close() : Response.End
	ElseIf mode="ranking" Then
		Dim r1stvalue, maxval, rightpervalue
		r1stvalue=1
		maxval = 0
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
		sqlstr = sqlstr & " ) aa order by cnt desc "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If Not rsget.Eof Then
			rankingDataResult = "<h3><img src='http://webimage.10x10.co.kr/playmo/ground/20160516/tit_ranking.png' alt='나와 비슷한 사람들은? 유형별 순위 공개' /></h3>"
			rankingDataResult = rankingDataResult & " <ul> "
			Do Until rsget.eof
				If r1stvalue = 1 Then
					maxval = rsget("cnt")
					rightpervalue = 100
				Else
					rightpervalue = CInt((((rsget("cnt")/maxval)*100)*0.54)+46)

				End If
				Select Case Trim(rsget("typename"))
					Case "1"
						rankingDataResult = rankingDataResult & " <li> "
						rankingDataResult = rankingDataResult & " <div style='width:"&rightpervalue&"%;'> "
						rankingDataResult = rankingDataResult & " <p><span>뛰뛰빵빵형</span> "
						rankingDataResult = rankingDataResult & " <b>"&FormatNumber(rsget("cnt"), 0)&"</b></p></div></li> "
					Case "2"
						rankingDataResult = rankingDataResult & " <li> "
						rankingDataResult = rankingDataResult & " <div style='width:"&rightpervalue&"%;'> "
						rankingDataResult = rankingDataResult & " <p><span>유유자적형</span> "
						rankingDataResult = rankingDataResult & " <b>"&FormatNumber(rsget("cnt"), 0)&"</b></p></div></li> "
					Case "3"
						rankingDataResult = rankingDataResult & " <li> "
						rankingDataResult = rankingDataResult & " <div style='width:"&rightpervalue&"%;'> "
						rankingDataResult = rankingDataResult & " <p><span>간지나는형</span> "
						rankingDataResult = rankingDataResult & " <b>"&FormatNumber(rsget("cnt"), 0)&"</b></p></div></li> "
					Case "4"
						rankingDataResult = rankingDataResult & " <li> "
						rankingDataResult = rankingDataResult & " <div style='width:"&rightpervalue&"%;'> "
						rankingDataResult = rankingDataResult & " <p><span>쳐묵쳐묵형</span> "
						rankingDataResult = rankingDataResult & " <b>"&FormatNumber(rsget("cnt"), 0)&"</b></p></div></li> "
				End Select
				r1stvalue = r1stvalue + 1
			rsget.movenext
			Loop
			rankingDataResult = rankingDataResult & "</ul>" 
		End IF
		rsget.close

		Response.Write "OK|"&rankingDataResult
		dbget.close() : Response.End

	Else
		Response.Write "Err|정상적인 경로가 아닙니다."
		dbget.close() : Response.End
	end If
	
	'// 결과값별 type값 산정
	Function getResultSbsValue(rs)
		Dim SelTypeVal

		Select Case Trim(rs)
			Case "AAAA"
				SelTypeVal = "1"
			Case "AAAB"
				SelTypeVal = "1"
			Case "AABA"
				SelTypeVal = "4"
			Case "AABB"
				SelTypeVal = "4"
			Case "ABAA"
				SelTypeVal = "1"
			Case "ABAB"
				SelTypeVal = "3"
			Case "ABBA"
				SelTypeVal = "1"
			Case "ABBB"
				SelTypeVal = "3"
			Case "BAAA"
				SelTypeVal = "2"
			Case "BAAB"
				SelTypeVal = "2"
			Case "BABA"
				SelTypeVal = "4"
			Case "BABB"
				SelTypeVal = "4"
			Case "BBAA"
				SelTypeVal = "2"
			Case "BBAB"
				SelTypeVal = "3"
			Case "BBBA"
				SelTypeVal = "2"
			Case "BBBB"
				SelTypeVal = "3"
			Case Else
				SelTypeVal = "1"
		End Select
		getResultSbsValue = SelTypeVal
	End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->