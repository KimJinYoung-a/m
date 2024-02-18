<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 마이펫의 이중생활
' History : 2016.07.13 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode, LoginUserid, sqlStr, device
Dim mypet, iweekend, ialt, todayCnt

IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66170"
Else
	eCode 		= "71789"
End If

LoginUserid	= GetEncLoginUserID()
mypet		= requestCheckVar(Trim(request("mypet")),8)

If isapp = "1" Then device = "A" Else device = "M" End If 

If (mypet <> "pops") AND (mypet <> "gidget") AND (mypet <> "max") AND (mypet <> "snowball") AND (mypet <> "duke") AND (mypet <> "mel") AND (mypet <> "chloe") Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

Select Case WeekDay(Date())
   Case 1, 6, 7
		iweekend = "_weekend"
		ialt	= "응모 완료 월요일 오전 10시 당첨자 발표를 기대해라멍! 당첨자는 텐바이텐 홈페이지 공지사항과, SMS로 공지될 예정입니다."
   Case Else
		iweekend = ""
		ialt	= "응모 완료 내일 오전 10시 당첨자 발표를 기대해라멍! 당첨자는 텐바이텐 홈페이지 공지사항과, SMS로 공지될 예정입니다."
End Select

sqlstr = ""
sqlstr = sqlstr & " SELECT COUNT(*) as cnt "
sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
sqlstr = sqlstr & " WHERE evt_code="& eCode &""
sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
rsget.Open sqlstr, dbget, 1
If Not(rsget.bof Or rsget.Eof) Then
	todayCnt = rsget("cnt")
End IF
rsget.close

If todayCnt = 0 Then
	sqlstr = ""
	sqlstr = sqlstr & " INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, device)"& vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&mypet&"', 1, '"&device&"')"
	dbget.execute sqlstr
	'Response.write "OK|<p>"&sqlStr&"</p>"
	Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_layer_"&mypet&iweekend&".png' alt='"&ialt&"' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
Else
	Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
	Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


