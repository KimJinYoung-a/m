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
' Description : 모바일 리뉴얼 설문 이벤트 
' History : 2017-09-18 유태욱 생성
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	dim mode, referer, apgubun, nowDate, vQuery
	Dim new1, new2, newtenTxt, UserAppearChk
	referer = request.ServerVariables("HTTP_REFERER")

	'// 모드값(ins)
	mode = requestcheckvar(request("mode"),5)
	new1 = requestcheckvar(request("new1"),1)
	new2 = requestcheckvar(request("new2"),1)
	newtenTxt = requestcheckvar(request("newtenTxt"),64)

	Dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66430
	Else
		eCode   =  80502
	End If

	nowdate = Left(Now(), 10)
'																							nowdate = "2017-09-20"

	'// 아이디
	userid = getEncLoginUserid()

	'// 모바일웹&앱전용
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If

	if InStr(referer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	If not(nowdate >= "2017-09-19" and nowdate < "2017-10-02") Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		dbget.close() : Response.End
	End If
	
	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?n설문에 참아하실 수 있습니다."
		dbget.close() : Response.End
	End If

	if checkNotValidTxt(newtenTxt) then
		Response.Write "Err|내용에 유효하지 않은 글자가 포함되어 있습니다.>?n다시 작성 해주세요."
		dbget.close() : Response.End
	end if
	newtenTxt = html2db(CheckCurse(newtenTxt))


	if userid <> "" then 
		UserAppearChk = getevent_subscriptexistscount(eCode,userid,"","","")
	else
		UserAppearChk=1
	end if
	
	if UserAppearChk > 0 then
		Response.Write "Err|이미 응모 하셨습니다."
		dbget.close() : Response.End
	end if

	'// 이벤트 참여
	if mode="newq" Then
		'// 참여 데이터를 넣는다.
		Call InsAppearData(eCode, userid, apgubun, new1, new2, newtenTxt)
		Response.Write "OK|1"
		dbget.close() : Response.End
	Else
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	End If

	Function InsAppearData(evt_code, uid, device, sub_opt1, sub_opt2, sub_opt3)
		Dim vQuery
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt1, sub_opt2, sub_opt3, regdate)" & vbCrlf
		vQuery = vQuery & " VALUES ("& evt_code &", '"& uid &"', '"&device&"','"&sub_opt1&"','"&sub_opt2&"', '"&sub_opt3&"', getdate())"
		dbget.execute vQuery
	End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


