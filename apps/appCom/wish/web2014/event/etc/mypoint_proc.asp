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
Dim totmypoint , sqlStr
Dim userid : userid = GetLoginUserID()

'// 로그인 여부 확인 //
if userid="" or isNull(userid) then
	Response.Write	"<script>alert('마일리지를 확인 하려면 로그인이 필요합니다.');</script>"
	Response.Write	"<script>top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';</script>"
	dbget.close()	:	response.End
end If

'// 토탈 마일리지 //
sqlStr = " select  " &VBCRLF
sqlStr = sqlStr & " isnull(sum(case " &VBCRLF
sqlStr = sqlStr & "	when g.chg_gift_code = '14157' then 2000 " &VBCRLF
sqlStr = sqlStr & "	when g.chg_gift_code = '14159' then 5000 " &VBCRLF
sqlStr = sqlStr & "	when g.chg_gift_code = '14161' then 10000 " &VBCRLF
sqlStr = sqlStr & "	end),0) as chg_gift_code " &VBCRLF
sqlStr = sqlStr & " from [db_order].[dbo].[tbl_order_master] as m " &VBCRLF
sqlStr = sqlStr & " inner join db_order.dbo.tbl_order_gift as g " &VBCRLF
sqlStr = sqlStr & " on m.orderserial = g.orderserial " &VBCRLF
sqlStr = sqlStr & " where m.userid <> '' and m.regdate between '2014-10-06 00:00:00' and '2014-10-20 23:59:59' " &VBCRLF
sqlStr = sqlStr & " AND m.ipkumdiv>3  AND m.jumundiv<>9 AND m.cancelyn='N' and m.sitename = '10x10' and m.userid <> '' " &VBCRLF
sqlStr = sqlStr & " and (m.subtotalprice+miletotalprice) >= 50000 " &VBCRLF
sqlStr = sqlStr & " and chg_gift_code in ('14157','14159','14161') " &VBCRLF
sqlStr = sqlStr & " and m.userid = '"& userid &"' "
rsget.Open sqlStr,dbget,1
	totmypoint = rsget(0)
rsget.Close

response.write "<div id='totmypoint' value='"& FormatNumber(totmypoint,0) &"'></div>"

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->