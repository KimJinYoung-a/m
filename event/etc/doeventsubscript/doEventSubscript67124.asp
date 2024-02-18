<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'#######################################################
'	History	: 2015.11.04 유태욱 생성
'	Description : 주말 데이트 1
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	Dim LoginUserid, LoginUsermail, cnt, device
	Dim eCode, sqlstr, nowdate, refer
	Dim pdName1, renloop, renloop1min, renloop1max
	Dim evtItemCnt1, evtItemCode1
	Dim result1, result2, mode, md5userid, evtUserCell

	If isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = now()
'	nowdate = "2015-11-07 10:10:00"

	LoginUserid = GetEncLoginUserID()
	LoginUsermail = getLoginUserEmail()

	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  65943
	Else
		eCode   =  67124
	End If

	'//총 상품 수량
	evtItemCnt1 = 1000

	'//당첨코드(아무거나)
	evtItemCode1 = 987654

	'//이벤트이름
	pdName1 = "주말데이트1"

	'//응모 확율
	randomize
	renloop=int(Rnd*10000)+1

	''확율조정
	If left(nowdate,10)="2015-11-06" Then	''//금요일
		renloop1min = 7000		''30 %
		renloop1max = 10001
	elseif left(nowdate,10)="2015-11-07" Then	''//토요일
		renloop1min = 7000		''30 %
		renloop1max = 10001
	elseif left(nowdate,10)="2015-11-08" Then	''//일요일
		renloop1min = 3000		''50 %
		renloop1max = 10001
	else
		renloop1min = 99999		''0
		renloop1max = 99999
	end if

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
'	md5userid = md5(LoginUserid&"10")

	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// 나간 수량
	''//and datediff(day,regdate,getdate()) = 0
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2<>0 "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

'	cnt= 1000

	'// 남은 수량 없으면 비당첨처리
		If cnt >= 1000 Then
			renloop = 99999
		'	Response.Write "Err|오늘은 마감되었습니다.!"
		'	Response.End
		End If

	'// expiredate
	If not(left(nowdate,10)>="2015-11-06" and left(nowdate,10)<"2015-11-09") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

	If mode = "add" Then '//응모하기 버튼 클릭

		If renloop > renloop1min and renloop < renloop1max Then ''난수 걸림
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 당첨코드가 들어가 있을경우엔 당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
			End IF
			rsget.close

			'// 현재 재고 파악
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &"  And sub_opt2='"&evtItemCode1&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close

			'// 최초 응모자면
			If result1="" And result2="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log01","전화번호중복비당첨",device)
	
					Response.write "NO"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt1 then
					'// 최초응모자이고, 상품 남은수량이있고, 입력한값이 난수에걸리면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode1&"', '"&device&"')"
					dbget.execute sqlstr
	
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log02",pdName1,device)
	
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2015/67124/txt_date_win.png' alt='당첨을 축하합니다! 관람 기간은 11월 13일 금요일부터 12월 13일 일요일 중 하루를 선택하여 관람하실 수 있으며 자세한 사항은 자세한 사항은 11월 9일 이메일과 사이트 공지사항을 통해 안내드릴 예정입니다. 이메일을 확인해주세요!' /></p><div class='emailbox'><div class='email'><div><p><span>"&LoginUsermail&"</span></p></div></div><a href='' onclick=""fnConfirmuser(); return false;""><img src='http://webimage.10x10.co.kr/eventIMG/2015/67124/btn_check.png' alt='확인' /></a></div><button type='button' id='btnClose' onclick=""fnClosemask();"" class='btnClose'>닫기</button>"
					dbget.close()	:	response.End
				Else
					'// 1등 남은게 없으면 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log03","비당첨",device)
	
					Response.write "NO"
					dbget.close()	:	response.End
				end if
			'// 응모를 했을경우
			Else
				Response.Write "Err|이미 응모 되었습니다."
				response.End
			End If
		else
			''//비당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2"
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
			End IF
			rsget.close
	
			''// 최초 응모자면
			If result1="" And result2="" Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
	
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log4","비당첨",device)
	
				Response.write "NO"
				dbget.close()	:	response.End
			Else
				Response.Write "Err|이미 응모 되었습니다."
				response.End
			End If
		end if
	else
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->