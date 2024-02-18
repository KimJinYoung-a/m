<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Dim sqlStr, itemid
	dim itemImg, adultType
	dim oJson
	Set oJson = jsObject()

	itemid	 = requestCheckVar(request("itemid"),20)

	if itemid = "" then
		dbget.close
		response.end
	end if
	
	if not isNumeric(itemid) then
		dbget.close
		response.end
	end if
	
	sqlStr = "select basicimage, adultType from db_item.dbo.tbl_item where itemid = '"&itemid&"'"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if not rsget.eof then
		itemImg = "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(itemid)  & "/" & rsget("basicimage")
		adultType = session("isAdult") <> true and rsget("adultType") = 1		
	End If
	rsget.close
	
	Set oJson("data") = jsObject() 
	oJson("data")("img") = itemImg
	oJson("data")("adultType") = adultType
	oJson.flush

'	Set oJson("data") = jsArray()
'	Set oJson("data")(null) = jsObject() 
'	oJson("data")(null)("img") = itemImg
'	oJson("data")(null)("adultType") = adultType
'	oJson.flush

	Set oJson = Nothing
	dbget.close() : Response.End	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->