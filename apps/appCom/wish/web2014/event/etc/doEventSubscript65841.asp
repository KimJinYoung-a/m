<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 동숭동 제목학원(앱)
' History : 2015.08.31 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%	

	Dim eCode, vUserID, getbonuscoupon, currenttime, getlimitcnt, vmode, apgubun, vprocdate, strSql, sqlstr, totcnt, refer, vUserVoteChk, vJemokChasu, vLstevtcomIdx
	Dim vOrd, vchasu, vQuery, refip, eLinkCode, ReceiveDate, NowDate, vTxt, eCouponID, vVoteCls, vDtCls, vRank, vListContents, comidx, PageSize, CurrPage

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64871"
		eLinkCode = "64872"
		eCouponID = "772"
	Else
		eCode = "65841"
		eLinkCode = "65803"
		eCouponID = "772"
	End If

	vUserID = GetEncLoginUserID
	refer = request.ServerVariables("HTTP_REFERER")
	refip = Request.ServerVariables("REMOTE_ADDR")
	vmode = requestcheckvar(request("mode"),32)
	ReceiveDate = requestcheckvar(request("rDate"),32)
	vTxt = requestcheckvar(request("vTxt"),128)
	vOrd = requestcheckvar(request("ord"),32)
	comidx = requestcheckvar(request("comidx"),128)
	PageSize = getNumeric(requestCheckVar(request("psz"),9))
	CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	vLstevtcomIdx = requestcheckvar(request("vLstevtcomIdx"),128)

	NowDate = left(now(), 10)

	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If


	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If not( left(now(),10)>="2015-09-02" and left(now(),10)<"2015-09-12" ) Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End If


	Select Case Trim(ReceiveDate)
		Case "2015-09-02"
			vJemokChasu = 1

		Case "2015-09-03"
			vJemokChasu = 2

		Case "2015-09-04"
			vJemokChasu = 3

		Case "2015-09-05"
			vJemokChasu = 4

		Case "2015-09-06"
			vJemokChasu = 5

		Case "2015-09-07"
			vJemokChasu = 6

		Case "2015-09-08"
			vJemokChasu = 7

		Case "2015-09-09"
			vJemokChasu = 8

		Case "2015-09-10"
			vJemokChasu = 9

		Case "2015-09-11"
			vJemokChasu = 10

		Case Else
			vJemokChasu = 1

	End Select


	Select Case Trim(vmode)

		Case "kakao"
			'// 로그 넣음
			vQuery = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
			vQuery = vQuery & " VALUES("& eCode &", '"& vUserID &"', '"&refip&"', '동숭동 제목학원 카카오톡 클릭 카운트', '"&apgubun&"')"
			dbget.execute vQuery
			Response.write "99"
			Response.End

		Case "comment"

			If vUserID = "" Then
				Response.Write "Err|로그인이 필요한 서비스 입니다."
				dbget.close() : Response.End
			End If

			If Trim(ReceiveDate) <> Trim(NowDate) Then
				Response.Write "Err|오늘 날짜에 응모해주세요."
				dbget.close() : Response.End
			End If

			'// 해당일자 10시부터 응모 가능함, 그 이전에는 응모불가
			If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(23, 59, 59)) Then
				Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
				Response.End
			End If

			'// 해당 날짜 기준으로 입력한 값이 있는지 확인한다.
			sqlstr = "select count(userid) "
			sqlstr = sqlstr & " from db_event.dbo.tbl_event_comment "
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& vUserID &"' and convert(varchar(10), evtcom_regdate, 120) = '"&Trim(ReceiveDate)&"' And evtcom_using='Y' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly			
			If rsget(0) > 0 Then
				Response.Write "Err|본 이벤트는 하루에 한번>?n응모 가능합니다."
				rsget.close()
				dbget.close()
				Response.End
			End If

			'// 해당 코멘트 내용중 비속어 필터링 한다.
			vTxt = CheckCurse(vTxt)

			'// 코멘트 입력한다.
			vQuery = " INSERT INTO [db_event].[dbo].[tbl_event_comment] (evt_code,evtgroup_code, userid, evtcom_txt, evtcom_point, evtbbs_idx, refip, blogurl, device) "
			vQuery = vQuery & " VALUES("& eCode &",'"&vJemokChasu&"', '"& vUserID &"','"&vTxt&"',0,0, '"&refip&"', '', '"&apgubun&"')"
			dbget.execute vQuery

			'// 쿠폰 넣어준다.
			sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
					 "values('"& eCouponID &"', '" & vUserID & "', '2','3000','출석 쿠폰 3,000원-3만원이상','30000','"&NowDate&" 00:00:00','"&NowDate&" 23:59:59','',0,'system','app')"
			dbget.execute sqlstr

			If isApp="1" Then
				Response.write "OK|<figure><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_coupon_v1.png' alt='당첨을 축하합니다. 3만원 이상 구매시 사용가능한 3천원 출석쿠폰이 발급되었습니다. 오늘 자정까지 텐바이텐에서만 사용가능해요' /></figure><a href='' onclick='parent.fnAPPpopupEvent(""65724"");return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/img_bnr_01.png' alt='한가위만 같아라 주고 받는 선물에 훈훈해지는 추석' /></a><button type='button' class='btnclose' onclick='lyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_close_06.png' alt='레이어 팝업 닫기' /></button>"
			Else
				Response.write "OK|<figure><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_coupon_v1.png' alt='당첨을 축하합니다. 3만원 이상 구매시 사용가능한 3천원 출석쿠폰이 발급되었습니다. 오늘 자정까지 텐바이텐에서만 사용가능해요' /></figure><a href='/event/eventmain.asp?eventid=65724' target='_blank'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/img_bnr_01.png' alt='한가위만 같아라 주고 받는 선물에 훈훈해지는 추석' /></a><button type='button' class='btnclose' onclick='lyClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_close_06.png' alt='레이어 팝업 닫기' /></button>"
			End If
			dbget.close()	:	response.End

		Case "list"

			sqlstr = " Select top 10 evtcom_idx, evt_code, userid, evtcom_txt, evtcom_regdate, evtcom_using, device,  evtcom_point, "
			sqlstr = sqlstr & " (Select count(sub_idx) From db_event.dbo.tbl_event_subscript Where evt_code = '"&eCode&"' And sub_opt2 = c.evtcom_idx And evtgroup_code='"&vJemokChasu&"' And userid='"&vUserID&"') as userchk  "
			sqlstr = sqlstr & " From db_event.dbo.tbl_event_comment c Where evt_code='"&eCode&"' And c.evtgroup_code='"&vJemokChasu&"' "
			If vOrd = "vote" Then
				sqlstr = sqlstr & " order by evtcom_point desc, evtcom_idx asc "
			ElseIf vOrd = "dt" Then
				sqlstr = sqlstr & " order by evtcom_idx desc, evtcom_point desc "
			Else
				sqlstr = sqlstr & " order by evtcom_point desc, evtcom_idx asc "
			End If
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			vRank = 1
			If Not(rsget.bof Or rsget.eof) Then
				If vOrd = "vote" Then
					vVoteCls = "class='on'"
					vDtCls = ""
				ElseIf vOrd = "dt" Then
					vDtCls = "class='on'"
					vVoteCls = ""
				Else
					vVoteCls = "class='on'"
					vDtCls = ""
				End If
				If ReceiveDate < NowDate Then
					vListContents = "	<h4><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/tit_winner.png' alt='제목학원 우등생 발표' /></h4> "
					vListContents = vListContents & " <p class='hidden'>축하합니다. 우등생으로 뽑히신 분들께는 익일 당첨 문자가 발송될 예정이니 참고해주세요!</p> "
					vListContents = vListContents & "		<div class='nameList'> "
					vListContents = vListContents & "			<ul> "
				Else
					vListContents = "	<h4><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_vote.png' alt='제목학원 우등생' /></h4> "
					vListContents = vListContents & " <p class='hidden'>당신의 선택이 오늘의 당첨자를 만듭니다. 마음에 드는 제목에 투표해주세요!</p> "
					vListContents = vListContents & " 	<ul class='sort'> "
					vListContents = vListContents & "			<li><a href='' "&vVoteCls&" onclick='getNameLadderList(""vote"", """&ReceiveDate&""");return false;'><span></span>인기순</a></li> "
					vListContents = vListContents & "			<li><a href='' "&vDtCls&" onclick='getNameLadderList(""dt"", """&ReceiveDate&""");return false;'><span></span>최신순</a></li> "
					vListContents = vListContents & "		</ul>"
					vListContents = vListContents & "		<div class='nameList'> "
					vListContents = vListContents & "			<ul> "
				End If

				' for dev msg : <li>...</li>는 10개까지 노출해주세요, 인기 순일 경우 등수 <em>1등~10등</em> 넣어주세요
				Do Until rsget.eof
					
					If rsget("userid") = vUserId Then
						vUserVoteChk = "1"
					Else
						vUserVoteChk = ""
					End If

					vListContents = vListContents & "				<li> "
					If vOrd = "vote" Then
						vListContents = vListContents & "					<em>"&vRank&"등</em> "
					End If
					vListContents = vListContents & "					<strong class='name'>"&ReplaceBracket(db2html(rsget("evtcom_txt")))&"</strong> "
					vListContents = vListContents & "					<span class='id'>"&printUserId(rsget("userid"),2,"*")&"</span> "
					vListContents = vListContents & "					<div class='vote'> "
					' for dev msg : 내가 투표한것에는 클래스 on 붙여주세요
					If ReceiveDate < NowDate Then
						If rsget("userchk") >= 1 Then
							vListContents = vListContents & "						<button type='button' style='cursor:default;outline:none;' class='on'>투표하기</button> "
						Else
							vListContents = vListContents & "						<button type='button' style='cursor:default;outline:none;'>투표하기</button> "
						End If
					Else
						If rsget("userchk") >= 1 Then
							vListContents = vListContents & "						<button type='button' id='btn"&rsget("evtcom_idx")&"' style='outline:none;' class='on' onclick='goVoteChk("""&rsget("evtcom_idx")&""", """&ReceiveDate&""","""&vUserVoteChk&""");return false;'>투표하기</button> "
						Else
							vListContents = vListContents & "						<button type='button' id='btn"&rsget("evtcom_idx")&"' style='outline:none;' onclick='goVoteChk("""&rsget("evtcom_idx")&""", """&ReceiveDate&""","""&vUserVoteChk&""");return false;'>투표하기</button> "
						End If
					End If

					' for dev msg : 투표수가 0일 경우 +로 표현해주세요 -->
					If rsget("evtcom_point") = 0 Then
						vListContents = vListContents & "						<strong><span id='vtcnt"&rsget("evtcom_idx")&"'>+</span></strong> "
					Else
						vListContents = vListContents & "						<strong><span id='vtcnt"&rsget("evtcom_idx")&"'>"&rsget("evtcom_point")&"</span></strong> "
					End If
					vListContents = vListContents & "					</div> "
					vListContents = vListContents & "				</li> "
				rsget.movenext
				vRank = vRank + 1
				Loop
				vListContents = vListContents & "			</ul> "
				If ReceiveDate = NowDate Then
					vListContents = vListContents & "			<a href='' onclick='jemokmorePop();return false;' class='btnmore'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_more.png' alt='더 많은 제목 보러가기' /></a> "
				Else
					vListContents = vListContents & "			<p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_sms.png' alt='금, 토, 일 당첨자는 월요일에 문자가 발송될 예정이니 참고해주세요' /></p> "
				End If
				vListContents = vListContents & "		</div> "

				Response.write "OK|"&vListContents

				rsget.close()
				dbget.close()
				Response.End
			Else
				Response.write "Err|"
				rsget.close()
				dbget.close()
				Response.End
			End If

		Case "vote"

			If vUserID = "" Then
				Response.Write "Err|로그인이 필요한 서비스 입니다."
				dbget.close() : Response.End
			End If

			If comidx = "" Then
				Response.Write "Err|잘못된 접근 입니다."
				dbget.close() : Response.End
			End If

			'// 해당일자 10시부터 응모 가능함, 그 이전에는 응모불가
			If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(23, 59, 59)) Then
				Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
				Response.End
			End If

			'// 해당 날짜 기준으로 해당 글에 투표한 값이 있는지 확인한다.
			sqlstr = "select count(userid) "
			sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript "
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& vUserID &"' and sub_opt1 = '"&Trim(ReceiveDate)&"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If rsget(0) > 0 Then
				Response.Write "Err|투표는 한 ID당 1일 1회만 할 수 있습니다."
				dbget.close() : Response.End				
			End If
			
			'// 투표값이 없으면 commentpoint 늘려주고 로그로 subscript에 남긴다.
			vQuery = " update db_event.dbo.tbl_event_comment set evtcom_point = evtcom_point+1 Where evtcom_idx='"&comidx&"' And evt_code='"&eCode&"' "
			dbget.execute vQuery

			vQuery = " INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, device, sub_opt3) "
			vQuery = vQuery & " VALUES("& eCode &",'"& vUserID &"','"&Trim(ReceiveDate)&"', '"&comidx&"', '"&apgubun&"','"&vJemokChasu&"')"
			dbget.execute vQuery
			Response.write "OK|"&comidx
			rsget.close()
			dbget.close() : Response.End

		Case "popupList"
			sqlstr = " Select * From "
			sqlstr = sqlstr & " ( "
			sqlstr = sqlstr & " 	Select Row_Number() Over (order by evtcom_idx desc) as RowNum, evtcom_idx, evt_code, userid, evtcom_txt, evtcom_regdate, evtcom_using, device, evtcom_point,  "
			sqlstr = sqlstr & " 	(Select count(userid) From db_event.dbo.tbl_event_subscript Where evt_code = '"&eCode&"' And sub_opt2 = c.evtcom_idx And evtgroup_code='"&vJemokChasu&"' And userid='"&vUserId&"') as userchk  "
			sqlstr = sqlstr & " 	From db_event.dbo.tbl_event_comment c Where evt_code='"&eCode&"' And evtgroup_code='"&vJemokChasu&"' "
			If vLstevtcomIdx="0" Then
			Else
				sqlstr = sqlstr & " And evtcom_idx <= "&vLstevtcomIdx&" "
			End If
			sqlstr = sqlstr & " )AA "
			sqlstr = sqlstr & " Where RowNum between "&(CurrPage*PageSize)+1&" And "&(CurrPage+1)*PageSize
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.eof) Then
				vListContents = ""
				Do Until rsget.eof
					vListContents = vListContents & "				<li> "
					vListContents = vListContents & "					<strong class='name'>"&ReplaceBracket(db2html(rsget("evtcom_txt")))&"</strong> "
					vListContents = vListContents & "					<span class='id'>"&printUserId(rsget("userid"),2,"*")&"</span> "
					vListContents = vListContents & "					<div class='vote'> "
					' for dev msg : 내가 투표한것에는 클래스 on 붙여주세요
					If ReceiveDate < NowDate Then
						If rsget("userchk") >= 1 Then
							vListContents = vListContents & "						<button type='button' style='cursor:default;outline:none;' class='on'>투표하기</button> "
						Else
							vListContents = vListContents & "						<button type='button' style='cursor:default;outline:none;'>투표하기</button> "
						End If
					Else
						If rsget("userchk") >= 1 Then
							vListContents = vListContents & "						<button type='button' id='btn"&rsget("evtcom_idx")&"' class='on' onclick='goVoteChk("""&rsget("evtcom_idx")&""", """&ReceiveDate&""","""&vUserVoteChk&""");return false;'>투표하기</button> "
						Else
							vListContents = vListContents & "						<button type='button' id='btn"&rsget("evtcom_idx")&"' onclick='goVoteChk("""&rsget("evtcom_idx")&""", """&ReceiveDate&""","""&vUserVoteChk&""");return false;'>투표하기</button> "
						End If
					End If

					' for dev msg : 투표수가 0일 경우 +로 표현해주세요 -->
					If rsget("evtcom_point") = 0 Then
						vListContents = vListContents & "						<strong><span id='vtcnt"&rsget("evtcom_idx")&"'>+</span></strong> "
					Else
						vListContents = vListContents & "						<strong><span id='vtcnt"&rsget("evtcom_idx")&"'>"&rsget("evtcom_point")&"</span></strong> "
					End If
					vListContents = vListContents & "					</div> "
					vListContents = vListContents & "				</li> "
				rsget.movenext
				Loop

				Response.write vListContents
				rsget.close()
				dbget.close()
				Response.End
			End If

		Case Else
			If vUserid = "" Then
				Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있어요."
				dbget.close() : Response.End
			End If
			
			Response.Write "Err|잘못된 접속입니다."
			dbget.close() : Response.End

	End Select

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->