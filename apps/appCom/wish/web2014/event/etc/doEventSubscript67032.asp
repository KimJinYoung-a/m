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
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, com_egCode, bidx,Cidx, vOrderSerial, vQuery
dim userid, txtcomm, txtcommURL, mode, spoint
Dim qtext1,qtext2,qtext3, tmpReferer, apgubun, sqlStr, strSql

IF application("Svr_Info") = "Dev" THEN
	eCode = "64940"
Else
	eCode = "67032"
End If

userid = GetencLoginUserID
vOrderSerial = requestCheckVar(request("orderNum"),128)

dim referer,refip, returnurl
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)

If isApp="1" Then
	apgubun = "A"
Else
	apgubun = "M"
End If


if InStr(referer,"10x10.co.kr")<1 then
	Response.Write "Err|잘못된 접속입니다."
	dbget.close() : Response.End
end If

If GetencLoginUserID() = "" Then
	Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있어요."
	dbget.close() : Response.End
End If

If not( left(Now(),10)>="2015-10-30" and left(Now(),10)<"2015-11-03" ) Then
	Response.Write "Err|이벤트 기간이 아닙니다."
	dbget.close() : Response.End
End If


'// 이미 tbl_event_subscript에 sub_opt1 필드에 해당 오더값 들어 있음 참여한 상태이니 여기서 튕겨낸다.
strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& userid &"' and evt_code = '"& ecode &"' And sub_opt1='"&vOrderSerial&"' " 
rsget.CursorLocation = adUseClient
rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
IF rsget(0) >= 1 Then
	Response.Write "Err|이미 마일리지를 발급받은 주문번호 입니다."
	dbget.close() : Response.End
End IF
rsget.close()

'// 이 주문코드가 본인의 주문코드가 맞는지 확인한다.
strSql = "select count(*) from db_order.dbo.tbl_order_master where userid = '"& userid &"' and cancelyn='N' And sitename='10x10' And orderserial = '"&vOrderSerial&"' And jumundiv<>9 and ipkumdiv>3  " 
rsget.CursorLocation = adUseClient
rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
IF rsget(0) = 0 Then
	Response.Write "Err|주문 내역이 없습니다."
	dbget.close() : Response.End
End IF
rsget.close()


'// 마일리지 테이블에 넣는다.
'vQuery = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 1000, lastupdate=getdate() Where userid='"&userid&"' "
'dbget.Execute vQuery

'// 마일리지 로그 테이블에 넣는다.
'vQuery = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+1000','1000', '마일리지는 돌아오는 거야 이벤트 마일리지 지급','N') "
'dbget.Execute vQuery

'// 이벤트 테이블에 내역을 남긴다.
vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', '" & vOrderSerial & "', '"&apgubun&"')"
dbget.Execute vQuery	

Response.Write "OK|"&vOrderSerial
dbget.close() : Response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->