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

arrItem = requestCheckVar(Request("arriid"),240)	'// 상품코드들; 8*30
sUnit = requestCheckVar(Request("unit"),4)			'// 가격 표시 단위

if sUnit="" then sUnit="원"
Select Case sUnit
	Case "hw" : sUnit="원"
	Case "ew" : sUnit="won"
	Case "hp" : sUnit="포인트"
	Case "ep" : sUnit="pt"
	Case "none" : sUnit=""
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
		strSort = strSort & "When i.itemid=" & srt & " then " & lp & " "
	next

	dim sqlStr
	sqlStr = "Select i.itemid, i.itemname, i.orgprice, i.sellcash, i.sailyn, i.basicimage, i.itemdiv "
	sqlStr = sqlStr & ", i.sellyn, i.limityn, i.limitno, i.limitsold , i.itemcoupontype , i.itemcouponvalue , i.itemcouponyn , i.brandname , i.optioncnt "
	sqlStr = sqlStr & ", i.evalcnt , c.favcount , isNull(e.totalpoint,0) as totalpoint "
	sqlStr = sqlStr & "from db_item.dbo.tbl_item as i "
	sqlStr = sqlStr & "INNER JOIN db_item.dbo.tbl_item_contents as c "
	sqlStr = sqlStr & "ON i.itemid = c.itemid "
	sqlStr = sqlStr & "LEFT OUTER JOIN db_board.dbo.tbl_const_eval_pointsummary as e "
	sqlStr = sqlStr & "ON e.itemid = i.itemid "
	sqlStr = sqlStr & "where i.itemid in (" & arrItem & ") "
	sqlStr = sqlStr & "order by case " & strSort & " end "
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
			'oJson("items")(null)("sellprice") = FormatNumber(rsget("sellcash"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)

			'// 쿠폰 
			If (rsget("sailyn")="N") and (rsget("itemcouponyn")="N") Then
				oJson("items")(null)("sellprice") = FormatNumber(rsget("orgprice"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
			End If
			If (rsget("sailyn")="Y") and (rsget("itemcouponyn")="N") Then
				oJson("items")(null)("sellprice") = FormatNumber(rsget("sellcash"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
			End If

			if (rsget("itemcouponyn")="Y") And (rsget("itemcouponvalue") > 0) Then
				If (rsget("itemcoupontype")="1") Then
					oJson("items")(null)("sellprice") = FormatNumber(rsget("sellcash") - CLng(rsget("itemcouponvalue")*rsget("sellcash")/100),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
				ElseIf (rsget("itemcoupontype")="2") Then
					oJson("items")(null)("sellprice") = FormatNumber(rsget("sellcash") - rsget("itemcouponvalue"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
				ElseIf (rsget("itemcoupontype")="3") Then
					oJson("items")(null)("sellprice") = FormatNumber(rsget("sellcash"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
				Else
					oJson("items")(null)("sellprice") = FormatNumber(rsget("sellcash"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
				End If
			End If


			oJson("items")(null)("itemdiv") = rsget("itemdiv")

			IF rsget("itemdiv") = "21" THEN '// 딜상품
				oJson("items")(null)("sellprice") = FormatNumber(rsget("sellcash"),0) & chkIIF(rsget("itemdiv")="82","Pt",sUnit)
				oJson("items")(null)("saleper") = rsget("optioncnt")&"%"
				oJson("items")(null)("saleTag") = "sale"
			ELSE
				If (rsget("sailyn")="Y") And (rsget("itemcouponyn")="Y") Then
					If (rsget("itemcoupontype")="1") Then
						'//할인 + %쿠폰
						oJson("items")(null)("saleper") = cStr(CLng((rsget("orgprice")-(rsget("sellcash") - CLng(rsget("itemcouponvalue")*rsget("sellcash")/100)))/rsget("orgprice")*100))&"%"
						oJson("items")(null)("saleTag") = "sale"
					ElseIf (rsget("itemcoupontype")="2") Then
						'//할인 + 원쿠폰
						oJson("items")(null)("saleper") = cStr(CLng((rsget("orgprice")-(rsget("sellcash") - rsget("itemcouponvalue")))/rsget("orgprice")*100))&"%"
						oJson("items")(null)("saleTag") = "sale"
					Else
						'//할인 + 무배쿠폰
						oJson("items")(null)("saleper") = cStr(CLng((rsget("orgprice")-rsget("sellcash"))/rsget("orgprice")*100)) & "%"
						oJson("items")(null)("saleTag") = "sale"
					End If 
				ElseIf (rsget("sailyn")="Y") and (rsget("itemcouponyn")="N") Then
					If (rsget("orgprice") - rsget("sellcash") > 0) Then
						oJson("items")(null)("saleper") = cStr(CLng((rsget("orgprice")-rsget("sellcash"))/rsget("orgprice")*100)) & "%"
						oJson("items")(null)("saleTag") = "sale"
					End If
				elseif (rsget("sailyn")="N") And (rsget("itemcouponyn")="Y") And (rsget("itemcouponvalue") > 0) Then
					If (rsget("itemcoupontype")="1") Then
						oJson("items")(null)("saleper") = CStr(rsget("itemcouponvalue")) & "%"
						oJson("items")(null)("saleTag") = "coupon"
					ElseIf (rsget("itemcoupontype")="2") Then
						oJson("items")(null)("saleper") = "쿠폰"
					ElseIf (rsget("itemcoupontype")="3") Then
						oJson("items")(null)("saleper") = "쿠폰"
					Else
						oJson("items")(null)("saleper") = CStr(rsget("itemcouponvalue")) &"%"
						oJson("items")(null)("saleTag") = "coupon"
					End If
				Else 
					oJson("items")(null)("saleper") = ""
					oJson("items")(null)("saleTag") = "coupon"
				End If

				'// 할인 표기
				If rsget("sailyn")="Y" Then
					If (rsget("orgprice") - rsget("sellcash") > 0) Then
						oJson("items")(null)("saleString") = cStr(CLng((rsget("orgprice")-rsget("sellcash"))/rsget("orgprice")*100)) & "%"
					End If
				End If

				'// 쿠폰 표기
				If (rsget("itemcouponyn")="Y") And (rsget("itemcouponvalue") > 0) Then
					If (rsget("itemcoupontype")="1") Then
						oJson("items")(null)("couponString") = CStr(rsget("itemcouponvalue")) & "%"
					End If
				End If
			END IF 

			'// 상품 속성 deal 상품 일반 상품
			oJson("items")(null)("itemType") = chkiif(rsget("itemdiv") = "21","deal","item")

			' If (rsget("sailyn")="Y") and (rsget("orgprice") - rsget("sellcash") > 0) THEN
			' 	oJson("items")(null)("saleper") = cStr(CLng((rsget("orgprice")-rsget("sellcash"))/rsget("orgprice")*100)) & "%"
			' else
			' 	oJson("items")(null)("saleper") = ""
			' end if

			IF rsget("itemdiv") = "21" THEN '// 딜상품
				if (rsget("sellyn")<>"Y") then
					oJson("items")(null)("soldout") = "true"
				else
					oJson("items")(null)("soldout") = "false"
				end if
			else
				if (rsget("sellyn")<>"Y") or (rsget("limityn")="Y" and rsget("limitno")-rsget("limitsold")<=0) then
					oJson("items")(null)("soldout") = "true"
				else
					oJson("items")(null)("soldout") = "false"
				end if
			end if 

			oJson("items")(null)("limityn") = rsget("limityn")
			if (rsget("limityn")="Y" and rsget("limitno")-rsget("limitsold")>0) then
				oJson("items")(null)("limitRemain") = cStr(rsget("limitno")-rsget("limitsold"))
			else
				oJson("items")(null)("limitRemain") = "0"
			end if

			oJson("items")(null)("brandname") = cStr(rsget("brandname"))

			oJson("items")(null)("evalCount") = rsget("evalcnt")
			oJson("items")(null)("favCount") = rsget("favcount")
		    oJson("items")(null)("totalPoint") = fnEvaluteTotalPointAVG(rsget("totalpoint"),"")

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
