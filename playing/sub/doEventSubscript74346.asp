<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim resultcnt, totalsubsctiptcnt, currenttime, refer, vBookNo
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, num, sel, kitnum, vQuery, resultvalue
dim kitresultcnt, myresultCnt
dim cLayerValue, resultimg, resultalt
		
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66233
	Else
		eCode   =  74346
	End If

currenttime = date()
mode			= requestcheckvar(request("mode"),32)
num				= requestcheckvar(request("num"),1)
sel				= requestcheckvar(request("sel"),1)
kitnum				= requestcheckvar(request("kitnum"),1)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

if mode<>"add" and mode<>"result" and mode<>"kitresult" and mode<>"snsresult" then		
	Response.Write "Err|잘못된 접속입니다.E04"
	dbget.close: Response.End
end If


'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

if isapp then
	device = "A"
Else
	device = "M"
end if

if mode="add" then
	''num 첫번째면 db 날리고 새로 저장
	if num = 1 Then
		vQuery = "delete from [db_event].[dbo].[tbl_event_subscript]  WHERE userid = '" & LoginUserid & "' AND evt_code = '" & eCode & "' AND sub_opt1 <> 'result' "
		dbget.Execute vQuery

		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, sub_opt1, sub_opt2, device)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&sel&"', '"&num&"', '"&device&"')"
		dbget.execute sqlstr

		Response.write "OK|"&num
		dbget.close()	:	response.End

	else
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, sub_opt1, sub_opt2, device)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&sel&"', '"&num&"', '"&device&"')"
		dbget.execute sqlstr

		Response.write "OK|"&num
		dbget.close()	:	response.End
	End If
elseif mode="result" then
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' AND sub_opt1 <> 'result' "
	rsget.Open sqlstr, dbget, 1
		resultcnt = rsget("cnt")
	rsget.close

	If resultcnt < 5 Then
		Response.Write "Err|모든 테스트를 완료해야 결과를 볼 수 있습니다."
		dbget.close()	:	response.End
	Else
		sqlstr = "SELECT DISTINCT userid, " & vbCrlf
		sqlstr = sqlstr &"       STUFF(( " & vbCrlf
		sqlstr = sqlstr &"SELECT '' + sub_opt1 " & vbCrlf
		sqlstr = sqlstr &"FROM    [db_event].[dbo].[tbl_event_subscript] " & vbCrlf
		sqlstr = sqlstr &"WHERE   evt_code="&eCode&" and sub_opt1<>'result' and userid='"& LoginUserid &"' " & vbCrlf
		sqlstr = sqlstr &"FOR XML PATH('') " & vbCrlf
		sqlstr = sqlstr &"),1,0,'') AS sub_opt1 " & vbCrlf
		sqlstr = sqlstr &"FROM [db_event].[dbo].[tbl_event_subscript] " & vbCrlf
		sqlstr = sqlstr &"WHERE   evt_code="&eCode&" and sub_opt1<>'result' and userid='"& LoginUserid &"' " & vbCrlf

		rsget.Open sqlstr, dbget, 1
			resultvalue = trim(rsget("sub_opt1"))
		rsget.close

		select case resultvalue
			case "AAAAA", "AAAAB", "AAABA", "AABAA", "BAAAA"
				resultvalue = 1
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_result_01.png"
				resultalt = "연애감! 당신은 일보다 사랑에 대한 감이 더욱 시급해요! 연애감이 필요한 당신! 요즘 날씨에 급 연애감이 떨어진 건 아닌가요? 이럴 때일수록 감을 단단히 챙기세요! 언제나 열린 마음으로 공감해줄 공감 나 자신에 대한 만족, 자신감 그리고 연애감의 필수! 다정다감 이 세 가지만 챙겨도 연애감이 UP 될 거에요!"
			case "AAABB", "AABBA", "AABAB", "ABBAA", "ABABA", "ABAAB", "BBAAA", "BABAA", "BAABA", "BAAAB"
				resultvalue = 2
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_result_02.png"
				resultalt = "연애감! 외롭지 않나요? 이럴 때일수록 더 연애감을 챙기셔야죠! 연애는 남의 일인 것처럼 생각하는 건 아닌가요? 그런 생각을 한다면 당장 버리세요! 먼저 이 3가지를 챙긴다면 자연스레 연애감이 상승할 거에요! 다른 사람들의 마음을 함께 고민해 줄 공감, 누구와 함께해도 충분하다는, 자신감, 무심한 듯 챙기는 츤데레같은 다정다감"
			case "BBBBB", "BBBBA", "BBBAB", "BBABB", "BABBB", "ABBBB"
				resultvalue = 3
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_result_03.png"
				resultalt = "업무감! 요즘 일 때문에 힘드셨나요? 업무감이 필요해 보이네요! 한 번씩 일에 대한 권태가 오는 시기가 있죠. 이 시기를 잘 지나면 다시 술술 풀리는 날이 기다리지만 그 시간 동안 나에게 전환이 필요하다면! 의욕을 자극할 수 있는 영감을 찾으세요! 그리고 내가 뱉은 대로 이루어 질 거라는 자신감을 가지세요! 그러면 내가 뿌듯하게 해온 일들에 대한 애정과 책임감이 자극이 되어 업무감이 UP 될 거에요!"
			case "BBBAA", "BBAAB", "BBABA", "BAABB", "BABBA", "BABAB", "AABBB", "ABABB", "ABBBA", "ABBAB"
				resultvalue = 4
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_result_04.png"
				resultalt = "업무감! 들인 시간에 비해 일이 잘 안 풀리나요? 업무의 감을 채워 주세요! 시간대비 일이 잘 안 되는 때가 있어요! 그럴 땐 당신의 마음을 단단하게 잡아줄 영감을 찾아, 맡은 업무에 대한 확신, 자신감을 갖고! 내가 시작 한 일에 대한 책임감으로 업무의 감을 채워 주세요! 당신의 들인 시간이 빛을 보는 시간이 될 거에요!"
			case else
				resultvalue = 1
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_result_01.png"
				resultalt = "연애감! 당신은 일보다 사랑에 대한 감이 더욱 시급해요! 연애감이 필요한 당신! 요즘 날씨에 급 연애감이 떨어진 건 아닌가요? 이럴 때일수록 감을 단단히 챙기세요! 언제나 열린 마음으로 공감해줄 공감 나 자신에 대한 만족, 자신감 그리고 연애감의 필수! 다정다감 이 세 가지만 챙겨도 연애감이 UP 될 거에요!"
		end select

		'//결과페이지 만듬
		cLayerValue = ""
		if resultvalue = 1 or resultvalue = 2 then 
			cLayerValue = cLayerValue & " <div class='section result'> "
		else
			cLayerValue = cLayerValue & " <div class='section result blue'> "
		end if
'		cLayerValue = cLayerValue & " 	<p class='id'><span class='word word1'><span></span>지금,</span><b>"&LoginUserid&"</b><span class='word word2'><span></span>님에게 가장 필요한 감!</span></p> "
		cLayerValue = cLayerValue & " 	<p class='id'>지금 <b>"&LoginUserid&"</b>님에게 가장 필요한 감!</p> "
		cLayerValue = cLayerValue & " 	<div class='grouping result' id='resultimg'> "
		cLayerValue = cLayerValue & " 		<p><img id='resultimg' src='"&resultimg&"' alt='"&resultalt&"' /></p> "
		cLayerValue = cLayerValue & " 		<a href='#start' class='btnMore' id='restart' onclick='restart(); return false;'><span></span>TEST 한번 더</a> "
		cLayerValue = cLayerValue & " 	</div> "
		cLayerValue = cLayerValue & " </div> "

		Response.write "OK|"&resultvalue&"|"&cLayerValue
		dbget.close()	:	response.End
	end if
elseif mode="kitresult" Then
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' AND sub_opt1 = 'result' "
	rsget.Open sqlstr, dbget, 1
		kitresultcnt = rsget("cnt")
	rsget.close

	If kitresultcnt > 0 Then
		Response.Write "Err|이미 신청 하셨습니다."
		dbget.close()	:	response.End
	Else
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and userid = '" & LoginUserid & "' AND sub_opt1 <> 'result' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			myresultCnt = rsget(0)
		End IF
		rsget.close

		if myresultCnt > 4 then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, sub_opt1, sub_opt2, device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', 'result', '"&kitnum&"', '"&device&"')"
			dbget.execute sqlstr

'			sqlStr = ""
'			sqlstr = "SELECT DISTINCT userid, " & vbCrlf
'			sqlstr = sqlstr &"       STUFF(( " & vbCrlf
'			sqlstr = sqlstr &"SELECT '' + sub_opt1 " & vbCrlf
'			sqlstr = sqlstr &"FROM    [db_event].[dbo].[tbl_event_subscript] " & vbCrlf
'			sqlstr = sqlstr &"WHERE   evt_code="&eCode&" and sub_opt1<>'result' and userid='"& LoginUserid &"' " & vbCrlf
'			sqlstr = sqlstr &"FOR XML PATH('') " & vbCrlf
'			sqlstr = sqlstr &"),1,0,'') AS sub_opt1 " & vbCrlf
'			sqlstr = sqlstr &"FROM [db_event].[dbo].[tbl_event_subscript] " & vbCrlf
'			sqlstr = sqlstr &"WHERE   evt_code="&eCode&" and sub_opt1<>'result' and userid='"& LoginUserid &"' " & vbCrlf
'
'			rsget.Open sqlstr, dbget, 1
'				resultvalue = trim(rsget("sub_opt1"))
'			rsget.close
'
'			select case resultvalue
'				case "AAAAA", "AAAAB", "AAABA", "AABAA", "BAAAA"
'					resultvalue = 1
'				case "AAABB", "AABBA", "AABAB", "ABBAA", "ABABA", "ABAAB", "BBAAA", "BABAA", "BAABA", "BAAAB"
'					resultvalue = 2
'				case "BBBBB", "BBBBA", "BBBAB", "BBABB", "BABBB", "ABBBB"
'					resultvalue = 3
'				case "BBBAA", "BBAAB", "BBABA", "BAABB", "BABBA", "BABAB", "AABBB", "ABABB", "ABBBA", "ABBAB"
'					resultvalue = 4
'				case else
'					resultvalue = 1
'			end select

			'//결과페이지 만듬
			cLayerValue = ""
			if kitnum = 1 then
				cLayerValue = cLayerValue & " <p class='done1'><span></span>연애감 신청완료</p>"
			elseif kitnum = 2 then
				cLayerValue = cLayerValue & " <p class='done2'><span></span>업무감 신청완료</p>"
			else
				Response.Write "Err|잘못된 접속 입니다."
				dbget.close()	:	response.End	
			end if

			Response.write "OK|"&kitnum&"|"&cLayerValue
			dbget.close()	:	response.End
		Else
			Response.Write "Err|테스트를 완료 하셔야 신청할 수 있습니다.."
			dbget.close()	:	response.End			
		end if
	end if
elseif mode="snsresult" Then
	myresultCnt=0
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and userid = '" & LoginUserid & "' AND sub_opt1 <> 'result' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		myresultCnt = rsget(0)
	End IF
	rsget.close

	if myresultCnt > 4 then
		sqlstr = "SELECT DISTINCT userid, " & vbCrlf
		sqlstr = sqlstr &"       STUFF(( " & vbCrlf
		sqlstr = sqlstr &"SELECT '' + sub_opt1 " & vbCrlf
		sqlstr = sqlstr &"FROM    [db_event].[dbo].[tbl_event_subscript] " & vbCrlf
		sqlstr = sqlstr &"WHERE   evt_code="&eCode&" and sub_opt1<>'result' and userid='"& LoginUserid &"' " & vbCrlf
		sqlstr = sqlstr &"FOR XML PATH('') " & vbCrlf
		sqlstr = sqlstr &"),1,0,'') AS sub_opt1 " & vbCrlf
		sqlstr = sqlstr &"FROM [db_event].[dbo].[tbl_event_subscript] " & vbCrlf
		sqlstr = sqlstr &"WHERE   evt_code="&eCode&" and sub_opt1<>'result' and userid='"& LoginUserid &"' " & vbCrlf

		rsget.Open sqlstr, dbget, 1
			resultvalue = trim(rsget("sub_opt1"))
		rsget.close

		select case resultvalue
			case "AAAAA", "AAAAB", "AAABA", "AABAA", "BAAAA"
				resultvalue = 1
			case "AAABB", "AABBA", "AABAB", "ABBAA", "ABABA", "ABAAB", "BBAAA", "BABAA", "BAABA", "BAAAB"
				resultvalue = 2
			case "BBBBB", "BBBBA", "BBBAB", "BBABB", "BABBB", "ABBBB"
				resultvalue = 3
			case "BBBAA", "BBAAB", "BBABA", "BAABB", "BABBA", "BABAB", "AABBB", "ABABB", "ABBBA", "ABBAB"
				resultvalue = 4
			case else
				resultvalue = 1
		end select

		Response.write "OK|"&resultvalue
		dbget.close()	:	response.End
	else
		Response.Write "Err|테스트를 완료 하셔야 공유할 수 있습니다.."
		dbget.close()	:	response.End	
	end if
else
	Response.Write "Err|잘못된 접속입니다.E05"
	dbget.close: Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->