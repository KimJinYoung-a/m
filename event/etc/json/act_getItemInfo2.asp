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
' Discription : 상품 정보 접수
' History : 2017.09.26 허진원 : 신규 생성
'###############################################

dim itemid, oJson, arrItem, strSort, sUnit

arrItem = requestCheckVar(Request("arriid"),160)	'// 상품코드들; 8*20
sUnit = requestCheckVar(Request("unit"),4)			'// 가격 표시 단위

if sUnit="" then sUnit="원"
Select Case sUnit
	Case "hw" : sUnit="원"
	Case "ew" : sUnit="won"
	Case "hp" : sUnit="포인트"
	Case "ep" : sUnit="pt"
End select

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
	sqlStr = "Select itemid, itemname, orgprice, sellcash, sailyn, basicimage, itemdiv, sellyn, limityn, limitno, limitsold "
	sqlStr = sqlStr & "from db_item.dbo.tbl_item "
	sqlStr = sqlStr & "where itemid in (" & arrItem & ")"
	sqlStr = sqlStr & "order by case " & strSort & " end"
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	
	if Not(rsget.EOF or rsget.BOF) then
		Set oJson("items") = jsArray()
		
		Do Until rsget.EOF
			Set oJson("items")(null) = jsObject()
			oJson("items")(null)("itemid") = cStr(rsget("itemid"))
			oJson("items")(null)("itemname") = cStr(rsget("itemname"))
			if Not(rsget("basicimage")="" or isNull(rsget("basicimage"))) then
				oJson("items")(null)("imgurl") = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
			else
				oJson("items")(null)("imgurl") = ""
			end if
			oJson("items")(null)("orgprice") = FormatNumber(rsget("orgprice"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
			oJson("items")(null)("sellprice") = FormatNumber(rsget("sellcash"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
			oJson("items")(null)("sellprice2") = rsget("sellcash")

			If (rsget("sailyn")="Y") and (rsget("orgprice") - rsget("sellcash") > 0) THEN
				oJson("items")(null)("saleper") = cStr(CLng((rsget("orgprice")-rsget("sellcash"))/rsget("orgprice")*100)) & "%"
			else
				oJson("items")(null)("saleper") = ""
			end if

			if (rsget("sellyn")<>"Y") or (rsget("limityn")="Y" and rsget("limitno")-rsget("limitsold")<=0) then
				oJson("items")(null)("soldout") = "true"
			else
				oJson("items")(null)("soldout") = "false"
			end if

			oJson("items")(null)("limityn") = rsget("limityn")
			if (rsget("limityn")="Y" and rsget("limitno")-rsget("limitsold")>0) then
				oJson("items")(null)("limitRemain") = cStr(rsget("limitno")-rsget("limitsold"))
			else
				oJson("items")(null)("limitRemain") = "0"
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
