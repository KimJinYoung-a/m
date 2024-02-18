<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim userid,username
dim reqname,reqphone,reqhp,reqzip
dim reqaddr1,reqaddr2,reqetc
dim id, ePCode

id = requestCheckVar(request("id"),10)
ePCode = requestCheckVar(request("ePC"),10)
userid = getEncLoginUserID
username = html2db(request("username"))
reqname = html2db(request("reqname"))
reqphone = request("reqphone1") & "-" & request("reqphone2") & "-" & request("reqphone3")
reqhp = request("reqhp1") & "-" & request("reqhp2") & "-" & request("reqhp3")
reqzip = requestCheckVar(request("txZip"),8)
reqaddr1 = html2db(request("txAddr1"))
reqaddr2 = html2db(request("txAddr2"))
reqetc = html2db(request("reqetc"))

if reqzip="-" or trim(reqzip)="" then
	Call Alert_return("입력된 주소가 없습니다. 확인 후 다시 시도해주세요.")
	dbget.close: Response.End
end if

dim sqlStr, prizechk, prizechkdate
'### 당첨 내역 체크 및 당첨확인일자 받아옴. 날짜 지나면 back.
sqlStr = "select convert(varchar(10),evtprize_enddate,120) from [db_event].[dbo].[tbl_event_prize] where evtprize_code = '" & ePCode & "' and evt_winner = '" & userid & "'"
rsget.Open sqlStr, dbget
if rsget.eof then
	prizechk = "x"
else
	prizechkdate = rsget(0)
	prizechk = "o"
end if
rsget.close


if prizechk = "x" then
	response.write "<script>alert('당첨 내역이 없습니다.'); location.href = '/my10x10/myeventmaster.asp';</script>"
	dbget.close()
	response.end
else
	if date() > CDate(prizechkdate) then
		response.write "<script>alert('당첨 확인기한이 지났습니다.\n당첨확인기한 : " & prizechkdate & ", 오늘 날짜 : " & date() & "'); location.href = '/my10x10/myeventmaster.asp';</script>"
		dbget.close()
		response.end
	end if
end if


dbget.beginTrans
sqlStr = "update [db_sitemaster].[dbo].tbl_etc_songjang" + VbCrlf
sqlStr = sqlStr + " set username='" + username + "'" + VbCrlf
sqlStr = sqlStr + " ,reqname='" + reqname + "'" + VbCrlf
sqlStr = sqlStr + " ,reqphone='" + reqphone + "'" + VbCrlf
sqlStr = sqlStr + " ,reqhp='" + reqhp + "'" + VbCrlf
sqlStr = sqlStr + " ,reqzipcode='" + reqzip + "'" + VbCrlf
sqlStr = sqlStr + " ,reqaddress1='" + reqaddr1 + "'" + VbCrlf
sqlStr = sqlStr + " ,reqaddress2='" + reqaddr2 + "'" + VbCrlf
sqlStr = sqlStr + " ,reqetc='" + reqetc + "'" + VbCrlf
sqlStr = sqlStr + " ,inputdate=getdate()" + VbCrlf
sqlStr = sqlStr + " where id=" + id

rsget.Open sqlStr, dbget, 1
IF Err.Number <> 0 THEN		dbget.RollBackTrans	  	
	
sqlStr = " IF EXISTS(SELECT evtprize_code FROM [db_event].[dbo].[tbl_event_prize] WHERE evtprize_code = "&ePCode&")"&_
		 " update [db_event].[dbo].[tbl_event_prize] set evtprize_status = 3 "&_
		"	WHERE evtprize_code = "&ePCode
rsget.Open sqlStr, dbget, 1
IF Err.Number <> 0 THEN		dbget.RollBackTrans	  	
dbget.CommitTrans	
dim referer
referer = request.ServerVariables("HTTP_REFERER")
'response.write "<script>alert('저장 되었습니다.'); opener.location.replace('/my10x10/myeventmaster.asp'); opener.focus(); window.close();</script>"
response.write "<script>alert('저장 되었습니다.'); location.href = '/my10x10/myeventmaster.asp';</script>"
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
