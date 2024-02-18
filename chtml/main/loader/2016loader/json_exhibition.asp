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
' Discription : mobile_exhibition // cache DB경유
' History : 2016-04-28 이종화 생성
'#######################################################

Dim lprevDate , sqlStr , arrExhibition , i , ii
Dim image , itemname , itemid , sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , tentenimg400
Dim coupontype , newyn , limitno , limitdispyn , makerid , brandname , gubun , linkurl , listidx , extitle
Dim gaParam 
Dim CtrlTime : CtrlTime = hour(time)
Dim CtrlDate : CtrlDate = date() 
Dim tmpgubun : tmpgubun = ""

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime
If CDate(now()) <= CDate(Date() & " 00:05:00") Then
	cTime = 60*1
Else
	cTime = 60*5
End If

	sqlStr = " select s.subidx , s.listidx , s.itemid , s.isusing as itemusing , s.sortnum "
	sqlStr = sqlStr & ", isnull(s.itemname,i.itemname) as itemname , i.basicimage , datepart(hh, l.startdate) as starttime "
	sqlStr = sqlStr & ", datepart(hh, l.enddate) as endtime "
	sqlStr = sqlStr & ", (case when DATEDIFF ( day , i.regdate , getdate()) < 14 then 'Y' else 'N' end) as newyn "
	sqlStr = sqlStr & ", i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn , i.itemcouponvalue "
	sqlStr = sqlStr & ", i.limitYN , i.itemcoupontype , (i.limitno - i.limitsold) as limitno "
	sqlStr = sqlStr & ", i.limitdispyn , i.makerid , i.brandname , i.tentenimage400 , l.exhibitiontitle , l.linkurl "
	sqlStr = sqlStr & "From [db_sitemaster].[dbo].[tbl_mobile_main_exhibition_item] as s "
	sqlStr = sqlStr & "left join db_item.dbo.tbl_item as i "
	sqlStr = sqlStr & "on s.itemid=i.itemid and i.itemid<>0 "
	sqlStr = sqlStr & "left join [db_sitemaster].[dbo].[tbl_mobile_main_exhibition_list] as l "
	sqlStr = sqlStr & "on s.listidx = l.idx "
	sqlStr = sqlStr & "Where s.isusing = 'Y' and ('" & CtrlDate & "' between convert(varchar(10),l.startdate,120) and "
	sqlStr = sqlStr & "convert(varchar(10),l.startdate,120)) and ('"& CtrlTime &"' between datepart(hh, l.startdate) and "
	sqlStr = sqlStr & "datepart(hh, l.enddate)) and l.isusing = 'Y' "
	sqlStr = sqlStr & "and s.listidx in ("
	sqlStr = sqlStr & "	Select top 2 idx from [db_sitemaster].[dbo].[tbl_mobile_main_exhibition_list] "
	sqlStr = sqlStr & "	where ('" & CtrlDate & "' between convert(varchar(10),startdate,120) and "
	sqlStr = sqlStr & "	convert(varchar(10),startdate,120)) and ('"& CtrlTime &"' between datepart(hh, startdate) and "
	sqlStr = sqlStr & "	datepart(hh, enddate)) and isusing = 'Y' order by topview desc "
	sqlStr = sqlStr & ") "
	sqlStr = sqlStr & "order by l.topview desc , s.listidx desc , s.sortnum asc  "

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"exhbt",sqlStr,cTime)
	If Not rsMem.EOF Then
		arrExhibition 	= rsMem.GetRows
	End if
	rsMem.close

	on Error Resume Next

	If isArray(arrExhibition) and not(isnull(arrExhibition)) Then
		ii = 0

		Dim obj ,json
		Set obj = jsObject()
		Set obj("exhibition1") = jsArray()
		Set obj("exhibition2") = jsArray()
		Set json = jsArray()
		Set	json(null) = obj ''배열 처리 따로 해줘야함

		FOR i=0 to ubound(arrExhibition,2)
			tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrExhibition(2,i))) + "/" + db2Html(arrExhibition(21,i))
			image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrExhibition(2,i))) + "/" + db2Html(arrExhibition(6,i))
			itemname	= arrExhibition(5,i)
			itemid		= db2Html(trim(arrExhibition(2,i)))
			sellCash	= db2Html(arrExhibition(10,i))
			orgPrice	= db2Html(arrExhibition(11,i))
			sailYN		= db2Html(arrExhibition(12,i))
			couponYn	= db2Html(arrExhibition(13,i))
			couponvalue = db2Html(arrExhibition(14,i))
			LimitYn		= db2Html(arrExhibition(15,i))
			coupontype	= db2Html(arrExhibition(16,i))
			newyn		= db2Html(arrExhibition(9,i))
			limitno		= db2Html(arrExhibition(17,i))
			limitdispyn = db2Html(arrExhibition(18,i))
			listidx		= db2Html(arrExhibition(1,i))
			extitle		= db2Html(arrExhibition(22,i))
			linkurl		= db2Html(arrExhibition(23,i))

			If db2Html(arrExhibition(21,i)) = "" Or isnull(db2Html(arrExhibition(21,i))) Then '//tentenimg
				tentenimg400 = ""
			End If

			If tmpgubun = "" or tmpgubun <> listidx Then
				ii = ii + 1
			End If

			If ii = 1 Then
				gaParam = "&gaparam=today_conceptpicka_"&(i+1) ''//컨셉픽A
			Else
				gaParam = "&gaparam=today_conceptpickb_"&(i+1) ''//컨셉픽B
			End If 

			Set obj("exhibition"&ii&"")(null) = jsObject()
				'//이미지루프
				If isapp ="1" then
					obj("exhibition"&ii&"")(null)("link") = ""& itemid & gaParam &""
				Else
					obj("exhibition"&ii&"")(null)("link") = "/category/category_itemPrd.asp?itemid="& itemid & gaParam &""
				End If 
				If application("Svr_Info") = "Dev" Then
					obj("exhibition"&ii&"")(null)("imgsrc") = ""& chkiif(Not(isnull(tentenimg400) Or tentenimg400 = "" ),tentenimg400,image) &""
				else
					obj("exhibition"&ii&"")(null)("imgsrc") = ""& chkiif(Not(isnull(tentenimg400) Or tentenimg400 = "" ),tentenimg400,getThumbImgFromURL(image,200,200,"true","false")) &""
				End if
					obj("exhibition"&ii&"")(null)("alt") = ""& itemname &""
					obj("exhibition"&ii&"")(null)("name") = ""& itemname &""
				If sailYN = "N" and couponYn = "N" Then
					obj("exhibition"&ii&"")(null)("price") = ""& formatNumber(orgPrice,0) &""
				End If
				If sailYN = "Y" and couponYn = "N" Then
					obj("exhibition"&ii&"")(null)("price") = ""& formatNumber(sellCash,0) &""
				End If
				if couponYn = "Y" And couponvalue>0 Then
					If coupontype = "1" Then
						obj("exhibition"&ii&"")(null)("price") =  ""& formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &""
					ElseIf coupontype = "2" Then
						obj("exhibition"&ii&"")(null)("price") =  ""& formatNumber(sellCash - couponvalue,0) &""
					ElseIf coupontype = "3" Then
						obj("exhibition"&ii&"")(null)("price") =  ""& formatNumber(sellCash,0) &""
					Else
						obj("exhibition"&ii&"")(null)("price") =  ""& formatNumber(sellCash,0) &""
					End If
				End If

				If sailYN = "Y" and couponYn = "N" Then
					If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
						obj("exhibition"&ii&"")(null)("sale") = ""& CLng((orgPrice-sellCash)/orgPrice*100) &"%"
					Else
						obj("exhibition"&ii&"")(null)("sale") = ""
					End If
				elseif couponYn = "Y" And couponvalue>0 Then
					If coupontype = "2" OR coupontype = "3" Then
						obj("exhibition"&ii&"")(null)("sale") = ""
					Else
						If coupontype = "1" Then
							obj("exhibition"&ii&"")(null)("sale") = ""& CStr(couponvalue) &"%"
						'ElseIf coupontype = "2" Then
						'	obj("exhibition"&ii&"")(null)("sale") = ""& formatNumber(couponvalue,0) & "원 할인"
						'ElseIf coupontype = "3" Then
						'	obj("exhibition"&ii&"")(null)("sale") = "무료배송"
						Else
							obj("exhibition"&ii&"")(null)("sale") = ""& couponvalue &"%"
						End If
					End If
				Else
						obj("exhibition"&ii&"")(null)("sale") = ""
				End If
				If LimitYn="Y" And limitdispyn = "Y" then
						obj("exhibition"&ii&"")(null)("itemno") = ""& limitno &""
				End if

			'//타이틀영역
			If tmpgubun <> listidx Then
					obj("extitle"&ii&"") = ""& extitle &""
					obj("link"&ii&"") = ""& linkurl &""
			End if

			tmpgubun = listidx '// 코드값 넣어주기
		Next
	End If

	Response.write Replace(toJSON(json),",null","")

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->