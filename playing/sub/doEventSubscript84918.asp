<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 플레이띵 Vol.36 오늘 뭐하지?
' History : 2018-03-02 원승현
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
Dim eCode, currenttime, vQuery, vSelectTaroCardImg, vSelectTaroCardIdx
Dim device, refer, mode, recentViewHtml
	
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67511
Else
	eCode   =  84918
End If

currenttime = date()

if isapp then
	device = "A"
else
	device = "M"
end If
recentViewHtml = ""

mode			= requestcheckvar(request("mode"),32)
refer 			= request.ServerVariables("HTTP_REFERER")

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

	if Not(currenttime >= "2018-03-02" and currenttime < "2018-03-17") then		
		Response.Write "Err||이벤트 기간이 아닙니다."
		dbget.close: Response.End
	end If

	'// 기존에 응모하였는지 확인한다.(일당 1회만 참여가능)
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & getEncLoginUserId & "' And evt_code='"&eCode&"' And convert(varchar(10), regdate, 120) ='"&currenttime&"'  "
	rsget.Open vQuery,dbget,1
	If rsget(0)>0 Then
		Response.Write "Err||금일은 이미 취미를 점치셨습니다."
		Response.End
	End If
	rsget.close

	'// db_temp.[dbo].[tbl_playingV36Taro] 테이블에서 랜덤하게 하나의 타로카드 데이터를 가져온다.
	vQuery = "SELECT TOP 1 Idx, imgsrc FROM db_temp.[dbo].[tbl_playingV36Taro] ORDER BY NEWID()  "
	rsget.Open vQuery,dbget,1
	If Not(rsget.eof) Then
		vSelectTaroCardImg = rsget("imgsrc")
		vSelectTaroCardIdx = rsget("Idx")
	Else
		Response.Write "Err||잘못된 접속입니다."
		Response.End
	End If
	rsget.close

	'// 이벤트 테이블에 금일 유저가 점친 타로카드를 넣는다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1, sub_opt2, sub_opt3, regdate, device)" + vbcrlf
	vQuery = vQuery & " VALUES("& eCode &", '"& getEncLoginUserId &"', '"&Mid(currenttime, 6, 2)&"월 "&Right(currenttime, 2)&"일"&"', '"&vSelectTaroCardIdx&"', '"&vSelectTaroCardImg&"', getdate(), '"&device&"')"
	dbget.execute vQuery

	response.write "ok||<span>"&Mid(currenttime, 6, 2)&"월 "&Right(currenttime, 2)&"일</span><img src='http://webimage.10x10.co.kr/playing/thing/vol036/m/"&vSelectTaroCardImg&"' alt='' />"
	response.End


ElseIf Trim(mode)="RecentView" Then
	If Not(IsUserLoginOK) Then
		Response.Write "Err||로그인 후 확인하실 수 있습니다."
		response.End
	End If

	vQuery = "SELECT sub_idx, sub_opt1, sub_opt2, sub_opt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & getEncLoginUserId & "' And evt_code='"&eCode&"' ORDER BY sub_idx  "
	rsget.Open vQuery,dbget,1
	If Not(rsget.eof) Then
		recentViewHtml = recentViewHtml & "<div class='swiper-wrapper'>" &vbCrLf
		Do Until rsget.eof
			recentViewHtml = recentViewHtml & " <div class='swiper-slide'><p> " &vbCrLf
			recentViewHtml = recentViewHtml & rsget("sub_opt1")
			recentViewHtml = recentViewHtml & " </p><img src='http://webimage.10x10.co.kr/playing/thing/vol036/m/"
			recentViewHtml = recentViewHtml & rsget("sub_opt3")
			recentViewHtml = recentViewHtml & " ' alt='' /></div>" &vbCrLf 
		rsget.movenext
		Loop
		recentViewHtml = recentViewHtml & "</div>"
		response.write "ok||"&recentViewHtml
		response.End
	Else
		Response.Write "Err||지난 카드가 없습니다."
		Response.End
	End If
	rsget.close

Else
	Response.Write "Err||잘못된 접속입니다."
	Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->