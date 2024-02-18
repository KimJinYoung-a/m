<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : PLAYing 용돈을 부탁해 처리페이지
' History : 2017-01-24 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim resultcnt, totalsubsctiptcnt, currenttime, refer
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, num, sel, vQuery, resultvalue
dim myresultCnt
dim cLayerValue, resultimg, resultalt, resultgroup
		
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66268
	Else
		eCode   =  75805
	End If

currenttime = date()
mode			= requestcheckvar(request("mode"),32)
num				= requestcheckvar(request("num"),1)
sel				= requestcheckvar(request("sel"),1)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

if mode<>"add" and mode<>"result" then		
	Response.Write "Err|잘못된 접속입니다.E04"
	dbget.close: Response.End
end If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

if isapp Then
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
			case "AABAA", "BAAAA", "BABAA", "BBBAA", "BABBA", "BABAB"
				resultvalue = 1
				resultgroup = "#group199392"
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_result_01.png"
				resultalt = "내 손에 돈이 들어오면 일단 쓰고 나중에 생각할래! 인생은 한방이야 TYPE 나에게 맞는 아이템 보기"

			case "BABBB", "BBBBA", "BBBAB", "BAABA", "BAAAB", "BBAAA", "AABBA", "AABAB", "ABBAA", "AAAAA"
				resultvalue = 2
				resultgroup = "#group199393"
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_result_02.png"
				resultalt = "돈을 쓰긴 썼는데 어디에 썼는지 모르겠다! 언제 다 썼지? TYPE 나에게 맞는 아이템 보기"

			case "AAABB", "ABABA", "ABABB", "ABAAB", "ABBBB", "BBABB"
				resultvalue = 3
				resultgroup = "#group199395"
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_result_03.png"
				resultalt = "티끌 모아 태산이라는 말 100%공감! 티끌 모아 태산 TYPE"

			case "AAAAB", "AAABA", "ABAAA", "AABBB", "ABBAB", "ABBBA", "BBBBB", "BBAAB", "BBABA", "BAABB"
				resultvalue = 4
				resultgroup = "#group199394"
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_result_04.png"
				resultalt = "한 번 마음먹고 미리 계획세우면 꼭 이룬다! 버킷 리스트 TYPE  나에게 맞는 아이템 보기"

			case else
				resultvalue = 1
				resultgroup = "#group199392"
				resultimg = "http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_result_01.png"
				resultalt = "내 손에 돈이 들어오면 일단 쓰고 나중에 생각할래! 인생은 한방이야 TYPE 나에게 맞는 아이템 보기"

		end select

dim evtlink
if isapp Then
	evtlink = "/apps/appcom/wish/web2014/event/eventmain.asp?eventid=75805&"&resultgroup&""
else
	evtlink = "/event/eventmain.asp?eventid=75805&"&resultgroup&""
end if
		'//결과페이지 만듬
		cLayerValue = ""
'		if resultvalue = 1 or resultvalue = 2 then 
'			cLayerValue = cLayerValue & " <div class='section result'> "
'		else
		cLayerValue = cLayerValue & " <div class='thumb'><img src='http://webimage.10x10.co.kr/playing/thing/vol007/m/img_thumb.png' alt='' /></div> "
'		end if
		cLayerValue = cLayerValue & " 	<div class='grouping result"&resultvalue&"'> "
		cLayerValue = cLayerValue & " 		<a href='"&evtlink&"'><img src='"&resultimg&"' alt='"&resultalt&"' /></a> "
		cLayerValue = cLayerValue & " 	</div> "
		cLayerValue = cLayerValue & " 		<a href='#start' class='btnMore' id='restart' onclick='restart(); return false;'><img src='http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_re_test.png' alt='test 다시하기' /></a> "
'		cLayerValue = cLayerValue & " 	</div> "
'		cLayerValue = cLayerValue & " </div> "

		Response.write "OK|"&resultvalue&"|"&cLayerValue
		dbget.close()	:	response.End
	end if
else
	Response.Write "Err|잘못된 접속입니다.E05"
	dbget.close: Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->