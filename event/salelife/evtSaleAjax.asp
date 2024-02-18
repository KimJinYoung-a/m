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
' Discription : 이벤트 정보
' History : 2019-03-28
'###############################################

dim itemid, oJson, evtArr, strSort

evtArr = Request("evtArr")	'// 상품코드들; 8*20

'//헤더 출력
Response.ContentType = "application/json"

'// json객체 선언
Set oJson = jsObject()

if evtArr<>"" then	
	dim sqlStr
	sqlStr = "Select evt_code, salePer "
	sqlStr = sqlStr & "from db_event.dbo.tbl_event_display "
	sqlStr = sqlStr & "where evt_code in (" & evtArr & ")"	
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	
	if Not(rsget.EOF or rsget.BOF) then
		Set oJson("items") = jsArray()
		
		Do Until rsget.EOF
			Set oJson("items")(null) = jsObject()
			oJson("items")(null)("evtCode") = rsget("evt_code")
			oJson("items")(null)("salePer") = rsget("salePer")			
			rsget.MoveNext
		loop
	else
		oJson("items") = ""
	end if
	rsget.Close
else
	oJson("items") = ""
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
