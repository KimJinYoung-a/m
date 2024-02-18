<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'####################################################
' Description : to get her, TOGETHER 발렌타인 이벤트
' History : 2014.02.04 허진원 생성
'####################################################

Response.Expires = -1
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cahce"
Response.AddHeader "cache-Control", "no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, mECd, userid, mode, evtOpt
dim strSql, chkOpt2, chkDate
dim chkOrder: chkOrder=false
IF application("Svr_Info") = "Dev" THEN
	eCode = "21072"
	mECd = "21073"
Else
	eCode = "48946"
	mECd = "48948"
End If

userid = getloginuserid()
mode = requestCheckVar(Request("mode"),3)
evtOpt = getNumeric(requestCheckVar(Request("evt_option"),1))

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요');</script>"
	dbget.close() : Response.End
End IF
If not(date>="2014-02-04" and date<="2014-02-10") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.');</script>"
	dbget.close() : Response.End
End IF

if mode="stp" then
	'// 일정 진행
	if evtOpt="" or evtOpt=5 then
		Response.Write "<script type='text/javascript'>alert('잘못된 접근입니다.'); top.location.href='/event/eventmain.asp?eventid="&mECd&"';</script>"
		dbget.close() : Response.End
	end if

	'#일정에 맞는 호출인지 확인 후 처리
	strSql = "Select sub_opt2, regdate From db_event.dbo.tbl_event_subscript "
	strSql = strSql & "Where evt_code=" & eCode & " and userid='" & userid & "'"
	rsget.Open strSql,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkOpt2 = rsget("sub_opt2")
		chkDate = rsget("regdate")
	end if
	rsget.Close

	if chkOpt2=evtOpt or chkOpt2>evtOpt then
		Response.Write "<script type='text/javascript'>alert('이미 참여하신 미션입니다!');top.history.go(0);</script>"
		dbget.close() : Response.End
	elseif chkOpt2="" and evtOpt=1 then
		'신규참여
		strSql = "Insert into db_event.dbo.tbl_event_subscript (evt_code,userid,sub_opt2) values "
		strSql = strSql & "(" & eCode & ",'" & userid & "',1)"
		dbget.Execute(strSql)
	elseif chkOpt2=1 and DateDiff("d",chkDate,date)=0 and evtOpt=2 then
		'Step1 참여날짜 확인
		Response.Write "<script type='text/javascript'>alert('너무 조급하지 않게!!\n내일 다시 들러주세요 :)');top.history.go(0);</script>"
		dbget.close() : Response.End
	else
		if chkOpt2=3 and evtOpt=4 then
			'Step3 이벤트 기간 주문 확인
			strSql = "select count(*) cnt "
			strSql = strSql & "From db_order.dbo.tbl_order_master "
			strSql = strSql & "Where regdate between '2014-02-04' and '2014-02-11' "
			strSql = strSql & "	and ipkumdiv>3 and jumundiv<>'9' and cancelyn='N' and userid='" & GetLoginUserID & "'"
			rsget.Open strSql,dbget,1
			if rsget(0)>0 then
				chkOrder = true
			end if
			rsget.Close
		else
			chkOrder = true
		end if
	
		if not(chkOrder) then
			Response.Write "<script type='text/javascript'>alert('조금만 더 노력하면 그녀를 만날 수 있어요!\n지금 바로 설레는 쇼핑을 시작해볼까요?');top.history.go(0);</script>"
			dbget.close() : Response.End
		else
			'다음단계 참여
			strSql = "update db_event.dbo.tbl_event_subscript "
			strSql = strSql & "Set sub_opt2=" & evtOpt & " "
			strSql = strSql & "Where evt_code=" & eCode & " and userid='" & userid & "'"
			dbget.Execute(strSql)
		end if
	end if

	'#참여 결과 안내
	Select Case cStr(evtOpt)
		Case "1"
			Response.Write "<script type='text/javascript'>alert('그녀에게 한 발 더 가까워졌어요.\n내일 다음 미션도 도전해주세요!');top.history.go(0);</script>"
		Case "2"
			Response.Write "<script type='text/javascript'>alert('그녀에게 점점 더 가까워지고 있어요.\n마지막 미션까지 화이팅!');top.history.go(0);</script>"
		Case "3"
			Response.Write "<script type='text/javascript'>alert('조금만 더 노력하면 그녀를 만날 수 있어요!\n지금 바로 설레는 쇼핑을 시작해볼까요?');top.history.go(0);</script>"
		Case "4"
			Response.Write "<script type='text/javascript'>top.history.go(0);</script>"
	End Select

elseif mode="sel" then
	'// 사은품 선택
	if evtOpt="" then
		Response.Write "<script type='text/javascript'>alert('선택된 선물이 없습니다.'); top.location.href='/event/eventmain.asp?eventid="&mECd&"';</script>"
		dbget.close() : Response.End
	end if

	'#중복 참여인지 확인 후 처리
	strSql = "Select sub_opt2 From db_event.dbo.tbl_event_subscript "
	strSql = strSql & "Where evt_code=" & eCode & " and userid='" & userid & "'"
	rsget.Open strSql,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkOpt2 = rsget("sub_opt2")
	end if
	rsget.Close

	if chkOpt2=5 then
		Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.\n당첨자 발표는 2014년 2월 13일 목요일입니다!'); top.location.href='/event/eventmain.asp?eventid="&mECd&"';</script>"
	else
		'# 선물 선택 응모
		strSql = "update db_event.dbo.tbl_event_subscript "
		strSql = strSql & "Set sub_opt2=5, sub_opt1='" & evtOpt & "'"
		strSql = strSql & "Where evt_code=" & eCode & " and userid='" & userid & "'"
		dbget.Execute(strSql)
	end if

	'결과 안내
	Response.Write "<script type='text/javascript'>alert('원하는 선물에 응모되었습니다.\n당첨자 발표는 2014년 2월 13일 목요일!\n행운을 빌어요!');top.history.go(0);</script>"
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); top.location.href='/event/eventmain.asp?eventid="&mECd&"';</script>"
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->