<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : mobile_mdpick // cache DB경유
' History : 2016-04-27 이종화 생성
'#######################################################

Dim lprevDate , sqlStr , arrMdpick , i 
Dim image , itemname , itemid , sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , tentenimg400
Dim coupontype , newyn , limitno , limitdispyn , makerid , brandname , gubun , linkurl
Dim rt_mdpick , rt_new , rt_best , rt_sale , htmlstr'// 2016년 1 2 4 3
Dim rt_mdpick_c , rt_new_c , rt_best_c , rt_sale_c '// 컨텐츠
Dim CtrlTime : CtrlTime = hour(time)

Dim mdpick, newarrival , bestseller , onsale

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime
If CDate(now()) <= CDate(Date() & " 00:05:00") Then
	cTime = 60*1
Else
	cTime = 60*5
End If

''//fngaparam 
function fngaParam(gubun)
	if gubun = "" then exit Function
	If gubun = 1 Then
		fngaParam = "&gaparam=today_mdpick_" ''//MDPICK
	ElseIf gubun = 2 Then
		fngaParam = "&gaparam=today_new_" ''//NEW
	ElseIf gubun = 3 Then
		fngaParam = "&gaparam=today_best_" ''//BEST
	ElseIf gubun = 4 Then
		fngaParam = "&gaparam=today_sale_" ''//SALE
	End If 
end Function


'	sqlStr = "Select s.subidx , s.listidx , s.itemid , s.isusing as itemusing , s.sortnum , isnull(s.itemname,i.itemname) as itemname , i.basicimage , datepart(hh, l.startdate) as starttime , datepart(hh, l.enddate) as endtime  , l.mdpicktitle"
'	sqlStr = sqlStr & " , (case when DATEDIFF ( day , i.regdate  , getdate()) < 14 then 'Y' else 'N' end) as newyn "
'	sqlStr = sqlStr & " , i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn , i.itemcouponvalue , i.limitYN , i.itemcoupontype , (i.limitno - i.limitsold) as limitno , i.limitdispyn , i.makerid , i.brandname , s.gubun , i.tentenimage400" 
'	sqlStr = sqlStr & " From [db_sitemaster].[dbo].tbl_mobile_main_mdpick_item as s "
'	sqlStr = sqlStr & "	left join db_item.dbo.tbl_item as i "
'	sqlStr = sqlStr & "		on s.itemid=i.itemid "
'	sqlStr = sqlStr & "			and i.itemid<>0 "
'	sqlStr = sqlStr & "	left join [db_sitemaster].dbo.tbl_mobile_main_mdpick_list as l "
'	sqlStr = sqlStr & "	on s.listidx = l.idx  "
'	sqlStr = sqlStr & " Where s.isusing = 'Y' and ('" & Date() & "' between convert(varchar(10),l.startdate,120) and convert(varchar(10),l.startdate,120)) "
'	sqlStr = sqlStr & " and ('"& CtrlTime &"' between datepart(hh, l.startdate) and datepart(hh, l.enddate)) and l.isusing = 'Y' and s.gubun <> 0 "
'	sqlStr = sqlStr & " order by s.gubun , s.listidx asc , s.sortnum asc "
	'Response.write sqlStr

	sqlStr = "db_sitemaster.dbo.usp_Ten_Mdpick_ItemListGet "

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"MDPICK",sqlStr,cTime)
	If Not rsMem.EOF Then
		arrMdpick 	= rsMem.GetRows
	End if
	rsMem.close

	on Error Resume Next

	If isArray(arrMdpick) and not(isnull(arrMdpick)) Then

		Dim obj ,json
		Set obj = jsObject()
		Set obj("gubun1") = jsArray()
		Set obj("gubun2") = jsArray()
		Set obj("gubun3") = jsArray()
		Set obj("gubun4") = jsArray()
		Set json = jsArray()
		Set	json(null) = obj ''배열 처리 따로 해줘야함
		'----------
		FOR i=0 to ubound(arrMdpick,2)

			tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
			image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(6,i))
			itemname	= arrMdpick(5,i)
			itemid		= trim(arrMdpick(2,i))
			sellCash	= arrMdpick(11,i)
			orgPrice	= arrMdpick(12,i)
			sailYN		= arrMdpick(13,i)
			couponYn	= arrMdpick(14,i)
			couponvalue = arrMdpick(15,i)
			LimitYn		= arrMdpick(16,i)
			coupontype	= arrMdpick(17,i)
			newyn		= arrMdpick(10,i)
			limitno		= arrMdpick(18,i)
			limitdispyn = arrMdpick(19,i)
			makerid		= arrMdpick(20,i)
			brandname	= arrMdpick(21,i)
			gubun		= arrMdpick(22,i) '//gubun mdpick , rookie , chance , best

			If db2Html(arrMdpick(23,i)) = "" Or isnull(db2Html(arrMdpick(23,i))) Then '//tentenimg
				tentenimg400 = ""
			End If 
			
			Set obj("gubun"& gubun &"")(null) = jsObject()
				obj("gubun"& gubun &"")(null)("gubun") = ""& gubun &""
			If isapp = "1" Then
				obj("gubun"& gubun &"")(null)("link") = ""& itemid & fngaParam(gubun) & (i+1) &""
			Else
				obj("gubun"& gubun &"")(null)("link") = "/category/category_itemPrd.asp?itemid="& itemid & fngaParam(gubun) & (i+1) &""
			End If 
			If application("Svr_Info") = "Dev" Then
				obj("gubun"& gubun &"")(null)("imgsrc") = ""& chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,image) &""
			Else
				obj("gubun"& gubun &"")(null)("imgsrc") = ""& chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,getThumbImgFromURL(image,200,200,"true","false")) &""
			End If 
				obj("gubun"& gubun &"")(null)("alt") = ""& CStr(itemname) &""
				obj("gubun"& gubun &"")(null)("name") = ""& CStr(itemname) &""
			If sailYN = "N" and couponYn = "N" Then
				obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(orgPrice,0) &"원"
			End If
			If sailYN = "Y" and couponYn = "N" Then
				obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash,0) &"원"
			End If
			if couponYn = "Y" And couponvalue>0 Then
				If coupontype = "1" Then
				obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &"원"
				ElseIf coupontype = "2" Then
				obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash - couponvalue,0) &"원"
				ElseIf coupontype = "3" Then
				obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash,0) &"원"
				Else
				obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash,0) &"원"
				End If
			End If
			If sailYN = "Y" And couponYn = "Y" Then
				If coupontype = "1" Then
					'//할인 + %쿠폰
					obj("gubun"& gubun &"")(null)("sale") = ""& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%"
				ElseIf coupontype = "2" Then
					'//할인 + 원쿠폰
					obj("gubun"& gubun &"")(null)("sale") = ""& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%"
				Else
					'//할인 + 무배쿠폰
					obj("gubun"& gubun &"")(null)("sale") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
				End If 
			ElseIf sailYN = "Y" and couponYn = "N" Then
				If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
					obj("gubun"& gubun &"")(null)("sale") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
				End If
			elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
				If coupontype = "1" Then
					obj("gubun"& gubun &"")(null)("sale") = ""&  CStr(couponvalue) & "%"
				ElseIf coupontype = "2" Then
					obj("gubun"& gubun &"")(null)("sale") = ""
				ElseIf coupontype = "3" Then
					obj("gubun"& gubun &"")(null)("sale") = ""
				Else
					obj("gubun"& gubun &"")(null)("sale") = ""& couponvalue &"%"
				End If
			Else 
				obj("gubun"& gubun &"")(null)("sale") = ""
			End If
			If LimitYn="Y" And limitdispyn = "Y" then
				obj("gubun"& gubun &"")(null)("itemno") = ""& limitno &""
			End If
		Next
	End If

	Response.write toJSON(json)

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->