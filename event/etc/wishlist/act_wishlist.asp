<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 귀여움 저장소 이벤트
' History : 2021.04.29 정태훈 생성
'####################################################
Response.ContentType = "application/json"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
dim current_page, row_count
Dim eCode, LoginUserid, mode, sqlStr, device
dim oJson, mktTest, teaTimeNum, eventStartDate, eventEndDate
'object 초기화
mode = request("mode")
current_page = request("current_page")
row_count = request("row_count")

Set oJson = jsObject()
oJson("subscription_count")=400
set oJson("products") = jsArray()

sqlStr = "select top " + CStr(row_count*current_page) 
sqlStr = sqlStr + " itemid, basicimage, itemname"
sqlStr = sqlStr + " From [db_temp].[dbo].[tbl_event_110936] with(nolock)"
sqlStr = sqlStr + " order by idx ASC"
rsget.pagesize = row_count
rsget.Open sqlStr, dbget, 1
if not rsget.EOF  then
    rsget.absolutepage = current_page
    do until rsget.eof
        set oJson("products")(null) = jsObject()
        oJson("products")(null)("item_id") = rsget("itemid")
        oJson("products")(null)("item_image") = "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") + "?cmd=thumb&fit=true&ws=false&w=300&wh=300"
        oJson("products")(null)("item_name") = rsget("itemname")
        rsget.moveNext
    loop
end if
rsget.Close
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->