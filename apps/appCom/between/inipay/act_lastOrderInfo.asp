<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.Charset = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
	dim oJson, sqlStr
	dim buyname, buyemail_Pre, buyemail_Tx, buyhp1, buyhp2, buyhp3, buyphone1, buyphone2, buyphone3
	dim reqname, txZip1, txZip2, txAddr1, txAddr2, reqhp1, reqhp2, reqhp3, reqphone1, reqphone2, reqphone3

	'// json객체 선언
	Set oJson = jsObject()

	'// 최근 주문 접수
	sqlStr = "Select top 1 "
	sqlStr = sqlStr & "	buyname, buyphone, buyhp, buyemail "
	sqlStr = sqlStr & "	,reqname, reqzipcode, reqzipaddr, reqaddress, reqphone, reqhp "
	sqlStr = sqlStr & "from db_order.dbo.tbl_order_master "
	sqlStr = sqlStr & "where sitename='10x10' "
	sqlStr = sqlStr & "	and rdsite='betweenshop' "
	sqlStr = sqlStr & "	and rduserid='" & fnGetUserInfo("tenSn") & "' "
	sqlStr = sqlStr & "	and ipkumdiv>1 "
	sqlStr = sqlStr & "	and jumundiv<>'9' "
	sqlStr = sqlStr & "	and cancelyn='N' "
	sqlStr = sqlStr & "order by idx desc"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		buyname			= cStr(rsget("buyname"))
		if inStr(rsget("buyemail"),"@")>1 then
			buyemail_Pre	= cStr(Split(rsget("buyemail"),"@")(0))
			buyemail_Tx		= cStr(Split(rsget("buyemail"),"@")(1))
		end if
		if Not(rsget("buyhp")="" or isNull(rsget("buyhp"))) then
			if ubound(Split(rsget("buyhp"),"-"))>1 then
				buyhp1			= cStr(Split(rsget("buyhp"),"-")(0))
				buyhp2			= cStr(Split(rsget("buyhp"),"-")(1))
				buyhp3			= cStr(Split(rsget("buyhp"),"-")(2))
			end if
		end if
		if Not(rsget("buyphone")="" or isNull(rsget("buyphone"))) then
			if ubound(Split(rsget("buyphone"),"-"))>1 then
				buyphone1		= cStr(Split(rsget("buyphone"),"-")(0))
				buyphone2		= cStr(Split(rsget("buyphone"),"-")(1))
				buyphone3		= cStr(Split(rsget("buyphone"),"-")(2))
			end if
		end if
		reqname			= cStr(rsget("reqname"))
		if Not(rsget("reqzipcode")="" or isNull(rsget("reqzipcode"))) then
			txZip1			= left(rsget("reqzipcode"),3)
			txZip2			= right(rsget("reqzipcode"),3)
		end if
		txAddr1			= cStr(rsget("reqzipaddr"))
		txAddr2			= cStr(rsget("reqaddress"))

		if Not(rsget("reqhp")="" or isNull(rsget("reqhp"))) then
			if ubound(Split(rsget("reqhp"),"-"))>1 then
				reqhp1		= cStr(Split(rsget("reqhp"),"-")(0))
				reqhp2		= cStr(Split(rsget("reqhp"),"-")(1))
				reqhp3		= cStr(Split(rsget("reqhp"),"-")(2))
			end if
		end if
		if Not(rsget("reqphone")="" or isNull(rsget("reqphone"))) then
			if ubound(Split(rsget("reqphone"),"-"))>1 then
				reqphone1		= cStr(Split(rsget("reqphone"),"-")(0))
				reqphone2		= cStr(Split(rsget("reqphone"),"-")(1))
				reqphone3		= cStr(Split(rsget("reqphone"),"-")(2))
			end if
		end if
	end if
	rsget.Close

	oJson("buyname")		= buyname
	oJson("buyemail_Pre")	= buyemail_Pre
	oJson("buyemail_Tx")	= buyemail_Tx
	oJson("buyhp1")			= buyhp1
	oJson("buyhp2")			= buyhp2
	oJson("buyhp3")			= buyhp3
	oJson("buyphone1")		= buyphone1
	oJson("buyphone2")		= buyphone2
	oJson("buyphone3")		= buyphone3

	oJson("reqname")		= reqname
	oJson("txZip1")			= txZip1
	oJson("txZip2")			= txZip2
	oJson("txAddr1")		= txAddr1
	oJson("txAddr2")		= txAddr2
	oJson("reqhp1")			= reqhp1
	oJson("reqhp2")			= reqhp2
	oJson("reqhp3")			= reqhp3
	oJson("reqphone1")		= reqphone1
	oJson("reqphone2")		= reqphone2
	oJson("reqphone3")		= reqphone3

	'Json 출력(JSON)
	oJson.flush
	Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->