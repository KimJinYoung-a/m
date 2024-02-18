<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'#############################################################
' Description : DistroDojo 설문조사 이벤트(전화)
' History : 2017-07-31 원승현 생성
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	dim mode, referer,refip, apgubun, nowDate, nowpos, act, sqlstr, md5userid, eCouponID, vQuery, SurveyScore, SVTxt
	Dim SVSYN, SVgoodTxt, SVorderTxt
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	'// 모드값(ins)
	mode = requestcheckvar(request("mode"),32)
	SVSYN = requestcheckvar(request("SVSYN"),32)
	SVgoodTxt = requestcheckvar(request("SVgoodTxt"),2048)
	SVorderTxt = requestcheckvar(request("SVorderTxt"),2048)

	Dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66404
	Else
		eCode   =  79617
	End If

	nowdate = Left(Now(), 10)

	'// 아이디
	userid = getEncLoginUserid()

	'// 모바일웹&앱전용
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If
'	apgubun = "W"


	if InStr(referer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	If not(nowdate >= "2017-07-31" and nowdate < "2017-08-03") Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		dbget.close() : Response.End
	End If
	
	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?n설문에 참아하실 수 있습니다."
		dbget.close() : Response.End
	End If

	if checkNotValidTxt(SVgoodTxt) then
		Response.Write "Err|내용에 유효하지 않은 글자가 포함되어 있습니다.>?n다시 작성 해주세요."
		dbget.close() : Response.End
	end if
	SVgoodTxt = html2db(CheckCurse(SVgoodTxt))

	if checkNotValidTxt(SVorderTxt) then
		Response.Write "Err|내용에 유효하지 않은 글자가 포함되어 있습니다.>?n다시 작성 해주세요."
		dbget.close() : Response.End
	end if
	SVorderTxt = html2db(CheckCurse(SVorderTxt))

'	SVgoodTxt = Server.URLDecode(SVgoodTxt)
'	SVorderTxt = Server.URLDecode(SVorderTxt)

	sqlstr = "Select count(*)" &_
			" From db_temp.dbo.tbl_tenSurvey" &_
			" WHERE evt_code='" & eCode & "' And userid='"&userid&"'  "
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
		If rsget(0) > 0 Then
			Response.Write "Err|이미 참여하셨습니다."
			Response.End
		End If
	rsget.Close


	'// 이벤트 참여
	if mode="ins" Then
		'// 참여 데이터를 넣는다.
		Call InsAppearData(eCode, userid, apgubun, SVSYN, SVgoodTxt, SVorderTxt)
		Response.Write "OK|1"
		dbget.close() : Response.End
	Else
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	End If

	'// 참여 데이터 ins
	Function InsAppearData(evt_code, uid, device, sub_opt1, sub_opt2, sub_opt3)
		Dim vQuery
		vQuery = "INSERT INTO [db_temp].[dbo].[tbl_tenSurvey] (evt_code , userid, device, sub_opt1, sub_opt2, sub_opt3, regdate)" & vbCrlf
		vQuery = vQuery & " VALUES ("& evt_code &", '"& uid &"', '"&device&"','"&sub_opt1&"','"&sub_opt2&"', '"&sub_opt3&"', getdate())"
		dbget.execute vQuery
	End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


