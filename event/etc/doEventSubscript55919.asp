<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, vQuery, tmpChk1, tmpChk2
dim userid, sub_opt1, sub_opt2

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21347"
	Else
		eCode = "55918"
	End If

userid = GetLoginUserID
sub_opt1 = getNumeric(requestCheckVar(request.Form("ordsn"),15))

If date>"2014-11-02" Then
	response.write "<script type='text/javascript'>alert('죄송합니다. 이벤트가 종료되었습니다.');</script>"
	dbget.close(): response.end
End IF

If userid="" or sub_opt1="" Then
	response.write "<script type='text/javascript'>alert('잘못된 접근입니다.');</script>"
	dbget.close(): response.end
End IF

'// 응모여부 확인
vQuery = "Select count(sub_idx) cnt, sum(Case When sub_opt1='" & sub_opt1 & "' then 1 else 0 end) as chk from [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "'"
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	tmpChk1 = rsget("cnt")
	tmpChk2 = rsget("chk")
end if
rsget.close

if tmpChk2>0 then
	response.write "<script type='text/javascript'>alert('이미 응모하신 주문번호입니다.');</script>"
	dbget.close(): response.end
end if
if tmpChk1>=5 then
	response.write "<script type='text/javascript'>alert('다섯번의 부메랑을 모두 날리셨습니다.');</script>"
	dbget.close(): response.end
end if

'// 주문번호 확인
vQuery = "Select miletotalprice from [db_order].[dbo].[tbl_order_master] WHERE userid='" & userid & "' AND orderserial='" & sub_opt1 & "' and ipkumdiv>3 and cancelyn='N' and jumundiv<>'9' "
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	sub_opt2 = rsget(0)
end if
rsget.close

if sub_opt2=0 or sub_opt2="" then
	response.write "<script type='text/javascript'>alert('없거나 잘못된 주문번호입니다.');</script>"
	dbget.close(): response.end
end if


'// 응모처리
vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2) VALUES('" & eCode & "', '" & userid & "', '" & sub_opt1 & "', '" & sub_opt2 & "')"
dbget.Execute vQuery

response.write "<script language='javascript'>alert('응모되셨습니다.\n돌려받는 마일리지는 11월 6일 일괄 지급됩니다.'); parent.location.reload();</script>"
dbget.close()
response.end
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->