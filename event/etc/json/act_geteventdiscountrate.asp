<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
'###############################################
' Discription : 이벤트 최대 할인률 가저오기
' History : 2019.04.01 이종화
'###############################################

dim itemid, oJson, arrEventid, strSort, sUnit
arrEventid = requestCheckVar(Request("arreventid"),160)	'// 이벤트 코드들

'//헤더 출력
Response.ContentType = "application/json"

'// json객체 선언
Set oJson = jsObject()

if arrEventid<>"" then
	'정렬순서 쿼리
	dim srt, lp
	for each srt in split(arrEventid,",")
		lp = lp +1
		strSort = strSort & "WHEN evt_code =" & srt & " THEN " & lp & " "
	next

	dim sqlStr
	sqlStr = " SELECT E.evt_code ,"&vbcrlf
    sqlStr = sqlStr & " MAX(CASE WHEN I.sailyn = 'Y' and I.itemcouponyn = 'Y' THEN"&vbcrlf
    sqlStr = sqlStr & "             CASE WHEN I.itemcoupontype = 1 THEN "&vbcrlf
    sqlStr = sqlStr & "                     CAST((I.orgprice - (I.sellcash - I.itemcouponvalue * I.sellcash / 100)) / I.orgprice * 100 AS INT)"&vbcrlf
    sqlStr = sqlStr & "                 WHEN I.itemcoupontype = 2 THEN"&vbcrlf
    sqlStr = sqlStr & "                     CAST((I.orgprice - (I.sellcash - I.itemcouponvalue)) / I.orgprice * 100 AS INT)"&vbcrlf
    sqlStr = sqlStr & "                 ELSE"&vbcrlf
    sqlStr = sqlStr & "                     CAST((I.orgprice - I.sellcash) / I.orgprice * 100 AS INT)"&vbcrlf
    sqlStr = sqlStr & "             END"&vbcrlf
    sqlStr = sqlStr & "         WHEN I.sailyn = 'Y' and I.itemcouponyn = 'N' THEN"&vbcrlf
    sqlStr = sqlStr & "             CAST((I.orgprice - I.sellcash) / I.orgprice * 100 AS INT)"&vbcrlf
    sqlStr = sqlStr & "         WHEN I.sailyn = 'N' and I.itemcouponyn = 'Y' and I.itemcouponvalue > 0 THEN"&vbcrlf
    sqlStr = sqlStr & "             CASE WHEN I.itemcoupontype = 1 THEN"&vbcrlf
    sqlStr = sqlStr & "                 CAST(I.itemcouponvalue AS INT)"&vbcrlf
    sqlStr = sqlStr & "             END"&vbcrlf
    sqlStr = sqlStr & "     END) saleper "&vbcrlf
	sqlStr = sqlStr & "FROM"&vbcrlf
    sqlStr = sqlStr & "     db_event.dbo.tbl_eventitem AS E"&vbcrlf
    sqlStr = sqlStr & "     INNER JOIN db_item.dbo.tbl_item AS I"&vbcrlf
    sqlStr = sqlStr & "     on E.itemid = I.itemid"&vbcrlf
	sqlStr = sqlStr & "WHERE E.evt_code in (" & arrEventid & ")"&vbcrlf
    sqlStr = sqlStr & "     and (I.sailyn = 'Y' or (I.itemcouponyn = 'Y' and I.itemcoupontype = 1))"&vbcrlf
    sqlStr = sqlStr & "     and I.sellyn = 'Y'"&vbcrlf
    sqlStr = sqlStr & "GROUP BY E.evt_code"&vbcrlf
	sqlStr = sqlStr & "ORDER BY CASE " & strSort & " END"
	
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		Set oJson("events") = jsArray()
		
		Do Until rsget.EOF
			Set oJson("events")(null) = jsObject()
			oJson("events")(null)("evt_code") = cStr(rsget("evt_code"))
			oJson("events")(null)("saleper") = cStr(rsget("saleper"))
			rsget.MoveNext
		loop
	else
		oJson("events") = ""
	end if
	rsget.Close
else
	oJson("events") = ""
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
