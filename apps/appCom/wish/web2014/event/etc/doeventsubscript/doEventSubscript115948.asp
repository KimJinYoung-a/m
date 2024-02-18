<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 스토리 꾸미기 파이터 이벤트
' History : 2021.12.14 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim oJson, refer, mode, sqlStr

    refer = request.ServerVariables("HTTP_REFERER") '// 레퍼러
	Set oJson = jsObject()
	mode = request("mode")
	IF application("Svr_Info") = "Dev" THEN
	else
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End If

if mode = "insta" then
    sqlStr = ""
    sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_115948] (snsdiv)" & vbCrlf
    sqlstr = sqlstr & " VALUES (0)"
    dbget.execute sqlstr

    oJson("response") = "ok"
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
elseif mode="ka" then
    sqlStr = ""
    sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_115948] (snsdiv)" & vbCrlf
    sqlstr = sqlstr & " VALUES (1)"
    dbget.execute sqlstr

    oJson("response") = "ok"
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
elseif mode="analysis" then
    oJson("response") = "ok"
    sqlstr = "SELECT CONVERT(VARCHAR(10),E.regdate,21) AS regdate" & vbcrlf
    sqlstr = sqlstr & ",(" & vbcrlf
    sqlstr = sqlstr & "SELECT COUNT(snsdiv) FROM [db_temp].[dbo].[tbl_event_115948]" & vbcrlf
    sqlstr = sqlstr & "WHERE snsdiv=0" & vbcrlf
    sqlstr = sqlstr & "AND regdate>=CONVERT(VARCHAR(10),E.regdate,21)" & vbcrlf
    sqlstr = sqlstr & "AND regdate<DATEADD(dd,1,CONVERT(VARCHAR(10),E.regdate,21))" & vbcrlf
    sqlstr = sqlstr & ") AS insta" & vbcrlf
    sqlstr = sqlstr & ",(" & vbcrlf
    sqlstr = sqlstr & "SELECT COUNT(snsdiv) FROM [db_temp].[dbo].[tbl_event_115948]" & vbcrlf
    sqlstr = sqlstr & "WHERE snsdiv=1" & vbcrlf
    sqlstr = sqlstr & "AND regdate>=CONVERT(VARCHAR(10),E.regdate,21)" & vbcrlf
    sqlstr = sqlstr & "AND regdate<DATEADD(dd,1,CONVERT(VARCHAR(10),E.regdate,21))" & vbcrlf
    sqlstr = sqlstr & ") AS kakao" & vbcrlf
    sqlstr = sqlstr & "FROM [db_temp].[dbo].[tbl_event_115948] AS E" & vbcrlf
    sqlstr = sqlstr & "GROUP BY CONVERT(VARCHAR(10),E.regdate,21)" & vbcrlf
    sqlstr = sqlstr & "ORDER BY CONVERT(VARCHAR(10),E.regdate,21)"
    rsget.Open sqlstr, dbget, 1
    If Not rsget.EOF Then
        Set oJson("items") = jsArray()
        Do Until rsget.EOF
            Set oJson("items")(null) = jsObject()
            oJson("items")(null)("regdate") = cStr(rsget("regdate"))
            oJson("items")(null)("insta") = rsget("insta")
            oJson("items")(null)("kakao") = rsget("kakao")
            rsget.MoveNext
        Loop
    end if
    rsget.close
   
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->