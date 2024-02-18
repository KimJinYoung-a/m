<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 텐텐 언박싱 콘테스트 액션페이지
' History : 2019-01-02 최종원
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, videoLink, urlCnt	

	IF application("Svr_Info") = "Dev" THEN
		eCode = "90204"
	Else
		eCode = "91528"
	End If

	mode 			= request("mode")
	currenttime 	= date()
	LoginUserid		= getencLoginUserid()
	videoLink		= request("videoLink")
	refer 			= request.ServerVariables("HTTP_REFERER")	

	device = "M"

if mode = "regAlram" then '수상자발표알림받기
	'알림 응모 여부 체크 
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt2 = '1' "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt2)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '1')"
		dbget.execute sqlstr

		Response.write "OK|alram"
		dbget.close()	:	response.End
	Else				
		Response.write "ERR|이미 신청하셨습니다."
		dbget.close()	:	response.End
	End If
elseif mode = "entryEvt" then '응모
	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If
	if Not(currenttime >= "2019-01-02" And currenttime <= "2019-01-31") then	'이벤트 참여기간		
		Response.write "ERR|이벤트 참여 기간이 아닙니다."
		response.end
	end if
		
	'응모 여부 체크
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code='"& eCode &"'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	'같은 url 거르기
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt3 = '"& videoLink &"'"
	rsget.Open sqlstr, dbget, 1
		urlCnt = rsget("cnt")
	rsget.close
	
	if urlCnt > 0 then
		Response.write "ERR|영상을 중복 업로드할 수 없습니다."
		dbget.close()	:	response.End		
	end if
	
	If cnt < 100 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt3)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '"&videoLink&"')"
		dbget.execute sqlstr
		Response.write "OK|entry"
		dbget.close()	:	response.End		
	Else				
		Response.write "ERR|시스템 오류입니다."
		dbget.close()	:	response.End
	End If
elseif mode="viewEntryList" then

		dim urlArr
		dim i

		sqlStr = "SELECT sub_opt3 "
		sqlStr = sqlStr & " , case "	
		sqlStr = sqlStr & "    when sub_opt1 <> '' then sub_opt1  "	
		sqlStr = sqlStr & "    else '일반' "	
		sqlStr = sqlStr & "  end "	
		sqlStr = sqlStr & "   from db_event.dbo.tbl_event_subscript as a "	
		sqlStr = sqlStr & "  where evt_code = '"& CStr(eCode) &"'"	
		sqlStr = sqlStr & "    and sub_opt3 <> '' "

		'response.write sqlStr &"<br>"
		'response.end
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		
 		if not rsget.EOF then
		    urlArr = rsget.getRows()	
		end if
		rsget.close		

		if GetLoginUserLevel = "7" then
		response.write "<div style=""color:red"">*스태프만 노출</div>"
			if isArray(urlArr) then 
				for i=0 to uBound(urlArr,2) 
				response.write "<div><a href="&urlArr(0,i)&" target=""_blank"">"& urlArr(0,i) &"</a> / 진입경로 : " 				
				response.write urlArr(1,i)
				response.write "</div>"
				next 
			end if 										
		end if	
else
		Response.write "ERR|시스템 오류입니다."
end if	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->