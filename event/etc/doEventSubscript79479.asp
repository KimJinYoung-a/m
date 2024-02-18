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
' Description : DistroDojo 설문조사 이벤트
' History : 2017-07-06 원승현 생성
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
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	'// 모드값(ins)
	mode = requestcheckvar(request("mode"),32)
	SurveyScore = requestcheckvar(request("SVS"),32)
	SVTxt = requestcheckvar(request("SVTxt"),512)

	Dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66382
	Else
		eCode   =  79479
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
	'apgubun = "W"


	if InStr(referer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	If not(nowdate >= "2017-07-24" and nowdate < "2017-07-25") Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		dbget.close() : Response.End
	End IF


	'// 쿠키에 담겨져 있는 해당 설문조사 데이터를 가져온다.
	If request.Cookies("dojo")("survey") Then
		Response.Write "Err|이미 참여하셨습니다."
		dbget.close() : Response.End
	End If

	If Trim(userid)="" Then
		userid="guest"
	End If


	'// 이벤트 참여
	if mode="ins" Then
		'// 참여 데이터를 넣는다.
		Call InsAppearData(eCode, userid, apgubun, "ins", SurveyScore, SVTxt)
		response.Cookies("dojo")("survey") = True
		Response.Write "OK|1"
		dbget.close() : Response.End
	Else
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	End If

	'// 참여 데이터 ins
	Function InsAppearData(evt_code, uid, device, sub_opt1, sub_opt2, sub_opt3)
		Dim vQuery
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt1, sub_opt2, sub_opt3, regdate)" & vbCrlf
		vQuery = vQuery & " VALUES ("& evt_code &", '"& uid &"', '"&apgubun&"','"&sub_opt1&"','"&sub_opt2&"', '"&sub_opt3&"', getdate())"
		dbget.execute vQuery
	End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


