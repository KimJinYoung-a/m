<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 플레이띵 Vol.16 슬기로운 생활
' History : 2017-06-02 원승현
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
dim resultcnt, sqlstrcnt, resultaftercnt, vQuery
Dim refer, eCode, LoginUserid, mode, sqlStr, device, cLayerValue, currenttime
Dim com_egC, bidx, iCC, iCTot, spoint, isMC, pagereload, gubunval
Dim q1val, q2val, q3val, q4val, q5val, q6val, qUserTotalVal
Dim q1chk, q2chk, q3chk, q4chk, q5chk
Dim totalscore, refip, returnurl
Dim objCmd, returnValue, txtcomm
totalscore = 0
	
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66334
Else
	eCode   =  78257
End If

currenttime = date()

If isapp Then
	device = "A"
Else
	device = "M"
End If

LoginUserid		= getencLoginUserid()
mode			= requestcheckvar(request("mode"),32)
refer 			= request.ServerVariables("HTTP_REFERER")
refip			= request.ServerVariables("REMOTE_ADDR")
returnurl		= requestCheckVar(request.Form("returnurl"),100)
com_egC			= requestcheckvar(request("com_egC"),32)
bidx			= requestcheckvar(request("bidx"),32)
iCC				= requestcheckvar(request("iCC"),32)
iCTot			= requestcheckvar(request("iCTot"),32)
spoint			= requestcheckvar(request("spoint"),32)
isMC			= requestcheckvar(request("isMC"),32)
pagereload		= requestcheckvar(request("pagereload"),32)
gubunval		= requestcheckvar(request("gubunval"),32)
q1val			= requestcheckvar(request("q1val"),32)
q2val			= requestcheckvar(request("q2val"),32)
q3val			= requestcheckvar(request("q3val"),32)
q4val			= requestcheckvar(request("q4val"),32)
q5val			= requestcheckvar(request("q5val"),32)
q6val			= requestcheckvar(request("q6val"),100)

IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egC = "" THEN com_egC = 0


'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err||잘못된 접속입니다."
	Response.End
End If


If Trim(mode)="add" Then
	If Not(IsUserLoginOK) Then
		Response.Write "Err||로그인 후 참여하실 수 있습니다."
		response.End
	End If

	if Not(currenttime >= "2017-06-02" and currenttime < "2017-06-19") then		
		Response.Write "Err||이벤트 기간이 아닙니다."
		dbget.close: Response.End
	end If

	'// 각 문항의 답안이 없으면 튕겨낸다.
	If Trim(q1val)="" Then
		Response.Write "Err||시험지를 모두 다 풀어야 채점(응모)이 됩니다."
		Response.End
	End If
	If Trim(q2val)="" Then
		Response.Write "Err||시험지를 모두 다 풀어야 채점(응모)이 됩니다."
		Response.End
	End If
	If Trim(q3val)="" Then
		Response.Write "Err||시험지를 모두 다 풀어야 채점(응모)이 됩니다."
		Response.End
	End If
	If Trim(q4val)="" Then
		Response.Write "Err||시험지를 모두 다 풀어야 채점(응모)이 됩니다."
		Response.End
	End If
	If Trim(q5val)="" Then
		Response.Write "Err||시험지를 모두 다 풀어야 채점(응모)이 됩니다."
		Response.End
	End If
	If Trim(q6val)="" Then
		Response.Write "Err||시험지를 모두 다 풀어야 채점(응모)이 됩니다."
		Response.End
	End If

	'// 기존에 응모하였는지 확인한다.(1회만 참여가능)
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & LoginUserid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	If rsget(0)>0 Then
		Response.Write "Err||이미 시험에 참여하셨습니다."
		Response.End
	End If
	rsget.close

	'// 각 문항의 점수를 산출한다.
	'// q1chk값 1은 맞음, 0은 틀림
	If q1val = "1" Then
		totalscore = totalscore + 20
		q1chk = 1
	Else
		q1chk = 0
	End If
	If q2val = "4" Then
		totalscore = totalscore + 20
		q2chk = 1
	Else
		q2chk = 0
	End If
	If q3val = "4" Then
		totalscore = totalscore + 20
		q3chk = 1
	Else
		q3chk = 0
	End If
	If q4val = "4" Then
		totalscore = totalscore + 20
		q4chk = 1
	Else
		q4chk = 0
	End If
	If q5val = "3" Then
		totalscore = totalscore + 20
		q5chk = 1
	Else
		q5chk = 0
	End If

	'// db에 넣기위해 사용자 답안을 합친다.
	qUserTotalVal = q1val&"|"&q2val&"|"&q3val&"|"&q4val&"|"&q5val

	'// 총점이 100점일 경우 91~98점까지 랜덤하게 점수를 산출한다.
	If totalscore = 100 Then
		randomize
		totalscore = CInt("9"&int(Rnd*8)+1)

		If totalscore > 98 Then
			totalscore = 98
		End If
		If totalscore < 91 Then
			totalscore = 91
		End If
	End If

	'// 6번문항 사용자가 입력한 답안을 코멘트테이블에 넣는다.
	If pagereload = "ON" Then 
		pagereload = "&pagereload="&pagereload 
	Else 
		pagereload = "" 
	End If
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	txtcomm = q6val
	txtcomm = html2db(CheckCurse(txtcomm))
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert("&eCode&","&com_egC&",'"&LoginUserid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','', '"&device&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
	End With	
	returnValue = objCmd(0).Value		    
	Set objCmd = Nothing
	IF returnValue = 1 THEN	
		'// 이벤트 테이블에 유저가 선택한 답안 및 총점수를 넣는다.
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1, sub_opt2, sub_opt3, regdate, device)" + vbcrlf
		vQuery = vQuery & " VALUES("& eCode &", '"& LoginUserid &"', '"&qUserTotalVal&"', '"&totalscore&"', '"&txtcomm&"', getdate(), '"&device&"')"
		dbget.execute vQuery

		response.write "ok||"&refer&"&test=ok#testStart"
		response.End
	Else
		Response.Write "Err||잘못된 접속입니다."
		Response.End
	End If

ElseIf Trim(mode)="view" Then

Else
	Response.Write "Err||잘못된 접속입니다."
	Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->