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
dim resultcnt, totalsubsctiptcnt, currenttime, refer
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, num, sel, resultvalue
dim myresultCnt, cLayerValue
Dim ex2, ex3, ex4, ex5, username, vYear, vMonth, vDay, vType, yyyymmdd

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66288
Else
	eCode   =  76711
End If

currenttime = Date()
mode		= requestcheckvar(request("mode"),10)
LoginUserid	= getencLoginUserid()
refer 		= request.ServerVariables("HTTP_REFERER")
ex2			= requestcheckvar(request("tmpex2"),1)
ex3			= requestcheckvar(request("tmpex3"),1)
ex4			= requestcheckvar(request("tmpex4"),1)
ex5			= requestcheckvar(request("tmpex5"),2)
username	= html2db(requestcheckvar(request("uName"),32))
vYear		= requestcheckvar(request("uYear"),4)
vMonth		= requestcheckvar(request("uMonth"),2)
vDay		= requestcheckvar(request("uDay"),2)

If (NOT isnumeric(vYear)) OR (NOT isnumeric(vYear)) OR (NOT isnumeric(vYear)) Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If
vMonth	= Num2Str(vMonth,2,"0","R")
vDay	= Num2Str(vDay,2,"0","R")

yyyymmdd	= vYear & vMonth & vDay

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

If mode <> "add" and mode <> "result" Then
	Response.Write "Err|잘못된 접속입니다."
	dbget.close: Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

If isapp Then
	device = "A"
Else
	device = "M"
End If

If ex2 = "1" Then
	If ex4 = "1" OR ex4 = "2" OR ex4 = "3" Then
		vType = "A"	
	Else
		vType = "B"
	End If
ElseIf ex2 = "2" Then
	If ex4 = "1" OR ex4 = "2" OR ex4 = "3" Then
		vType = "C"	
	Else
		vType = "D"
	End If
ElseIf ex2 = "3" Then	
	vType = "E"
End If

If mode="add" then
	cLayerValue = ""
	cLayerValue = cLayerValue & "<p class=""name""><em>"&username&"</em> <img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_nim.png"" alt=""님은"" style=""width:2.8rem;"" /></p>"
	If vType = "A" Then
		cLayerValue = cLayerValue & "<div class=""result1"">"
		cLayerValue = cLayerValue & "	<p><img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_result_1_v2.png"" alt=""앞만 봤다 목 디스크 증상입니다."" /></p>"
		cLayerValue = cLayerValue & "</div>"
	ElseIf vType = "B" Then
		cLayerValue = cLayerValue & "<div class=""result2"">"
		cLayerValue = cLayerValue & "	<p><img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_result_2_v2.png"" alt=""걱정 과다증상입니다."" /></p>"
		cLayerValue = cLayerValue & "</div>"
	ElseIf vType = "C" Then
		cLayerValue = cLayerValue & "<div class=""result3"">"
		cLayerValue = cLayerValue & "	<p><img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_result_3_v2.png"" alt=""눈에 씌인 콩깍지증상입니다."" /></p>"
		cLayerValue = cLayerValue & "</div>"
	ElseIf vType = "D" Then
		cLayerValue = cLayerValue & "<div class=""result4"">"
		cLayerValue = cLayerValue & "	<p><img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_result_4_v2.png"" alt=""핑퐁 밀당 현상입니다."" /></p>"
		cLayerValue = cLayerValue & "</div>"
	ElseIf vType = "E" Then
		cLayerValue = cLayerValue & "<div class=""result5"">"
		cLayerValue = cLayerValue & "	<p><img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_result_5_v2.png"" alt=""작심삼일 증후군입니다."" /></p>"
		cLayerValue = cLayerValue & "</div>"
	End If
	cLayerValue = cLayerValue & "<div class=""overHidden""><button type=""button"" class=""btnAgain"" onclick=""fnReTest(); return false;"" ><img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_again.png"" alt=""테스트 다시하기"" /></button><button type=""button"" class=""btnShare"" onclick=""snschkresult('"& vType &"'); return false;""><img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_share.png"" alt=""내 결과 공유하기"" /></button></div><a href=""#kit"" class=""btnGo""><img src=""http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_go.gif"" alt=""키트 신청하러 가기"" /></a>"
	Response.Write "OK|"&cLayerValue
ElseIf mode="result" Then
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' AND sub_opt1 = 'result' "
	rsget.Open sqlstr, dbget, 1
		resultcnt = rsget("cnt")
	rsget.close

	If resultcnt > 0 Then
		Response.Write "03|이미 응모 하였습니다."
		dbget.close()	:	response.End
	Else
		'//temp 저장
		sqlstr = "INSERT INTO db_temp.[dbo].[tbl_event_76711] (userid, username, yyyymmdd, ex2 , ex3 , ex4 , ex5, vtype)" & vbcrlf
		sqlstr = sqlstr & " VALUES('" & LoginUserid & "', '"& username &"', '"& yyyymmdd &"', '"& ex2 &"' , '"& ex3 &"' , '"& ex4 &"' , '"& html2db(ex5) &"', '"&vType&"')"
		dbget.execute(sqlStr)

		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, sub_opt1, device)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', 'result', '"&device&"')"
		dbget.execute sqlstr
		Response.Write "05|end"
		dbget.close()	:	response.End
	End If
Else
	Response.Write "Err|잘못된 접속입니다."
	dbget.close: Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->