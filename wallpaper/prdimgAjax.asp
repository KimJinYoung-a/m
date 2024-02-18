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
' Discription : 상품 이미지
' History : 2019-01-24
'###############################################

dim itemid, oJson, arrItem, strSort

arrItem = Request("arriid")	'// 상품코드들; 8*20

'//헤더 출력
Response.ContentType = "application/json"

'// json객체 선언
Set oJson = jsObject()

if arrItem<>"" then
	'정렬순서 쿼리
	dim srt, lp
	for each srt in split(arrItem,",")
		lp = lp +1
		strSort = strSort & "When itemid=" & srt & " then " & lp & " "
	next

	dim sqlStr
	sqlStr = "Select itemid, basicimage "
	sqlStr = sqlStr & "from db_item.dbo.tbl_item "
	sqlStr = sqlStr & "where itemid in (" & arrItem & ")"
	sqlStr = sqlStr & "order by case " & strSort & " end"
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	
	if Not(rsget.EOF or rsget.BOF) then
		Set oJson("items") = jsArray()
		
		Do Until rsget.EOF            

			Set oJson("items")(null) = jsObject()
			oJson("items")(null)("itemid") = cStr(rsget("itemid"))			
			if Not(rsget("basicimage")="" or isNull(rsget("basicimage"))) then
				oJson("items")(null)("imgurl") = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
			else
				oJson("items")(null)("imgurl") = ""
			end if
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
