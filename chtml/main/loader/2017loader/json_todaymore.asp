<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"
Dim gaParam
Dim jcnt
Dim sqlStr
Dim rsMem , arrList
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 1

Dim catecode_sort , contents_type , contents_sort , catecode , itemid , itemname , basicimage
Dim tentenimage400 , sellcash , orgprice , sailyn , itemcouponyn , itemcouponvalue , itemcoupontype

Dim temp_catecode : temp_catecode = ""
Dim itemint , eventint
Dim evtName1 , evtName2

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MAINMORE_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MAINMORE"
End If

sqlStr = "db_sitemaster.[dbo].[usp_Ten_today_categoryMore_ver2] "

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

Function cateName(v)
	Select Case v
		Case "101"
			cateName = "디자인문구"
		Case "102"
			cateName = "디지털/핸드폰"
		Case "124"
			cateName = "디자인가전"
		Case "121"
			cateName = "가구/수납"
		Case "122"
			cateName = "데코/조명"
		Case "120"
			cateName = "패브릭/생활"
		Case "112"
			cateName = "키친"
		Case "119"
			cateName = "푸드"
		Case "117"
			cateName = "패션의류"
		Case "116"
			cateName = "패션잡화"
		Case "125"
			cateName = "주얼리/시계"
		Case "118"
			cateName = "뷰티"
		Case "103"
			cateName = "캠핑"
		Case "104"
			cateName = "토이/취미"
		Case "115"
			cateName = "베이비/키즈"
		Case "110"
			cateName = "캣앤독"
		Case Else
			cateName = "디자인문구"
	end select
End Function

Function cateClass(v)
	cateClass = "icon icon-category"&v
End Function

Function gaparamReturn(c,v)
	Dim addparam
	If v = 1 then
		addparam = "?"
	Else
		addparam = "&"
	End If

	Select Case c
		Case "101"
			gaparamReturn = addparam & "gaparam=today_stationery_"
		Case "102"
			gaparamReturn = addparam & "gaparam=today_digital_"
		Case "124"
			gaparamReturn = addparam & "gaparam=today_appliances_"
		Case "121"
			gaparamReturn = addparam & "gaparam=today_furniture_"
		Case "122"
			gaparamReturn = addparam & "gaparam=today_light_"
		Case "120"
			gaparamReturn = addparam & "gaparam=today_fabric_"
		Case "112"
			gaparamReturn = addparam & "gaparam=today_kitchen_"
		Case "119"
			gaparamReturn = addparam & "gaparam=today_food_"
		Case "117"
			gaparamReturn = addparam & "gaparam=today_fashion_"
		Case "116"
			gaparamReturn = addparam & "gaparam=today_shoes_"
		Case "125"
			gaparamReturn = addparam & "gaparam=today_jewely_"
		Case "118"
			gaparamReturn = addparam & "gaparam=today_beauty_"
		Case "103"
			gaparamReturn = addparam & "gaparam=today_travel_"
		Case "104"
			gaparamReturn = addparam & "gaparam=today_toy_"
		Case "115"
			gaparamReturn = addparam & "gaparam=today_kids_"
		Case "110"
			gaparamReturn = addparam & "gaparam=today_pet_"
		Case Else
			gaparamReturn = addparam & "gaparam=today_stationery_"
	end select
End Function

on Error Resume Next

If IsArray(arrList) Then

	Dim obj ,json
	Set obj = jsObject()
	Set json = jsArray() '// 카테코드가 다를때마다 배열 초기화
	'Set	json(null) = obj ''배열 처리 따로 해줘야함

	Dim	cateItems , cateEvents
	Dim itemList() , eventList()

	For jcnt = 0 to ubound(arrList,2)

			catecode_sort	= arrList(0,jcnt)
			contents_type	= arrList(1,jcnt)
			contents_sort	= arrList(2,jcnt)
			catecode		= arrList(3,jcnt)
			itemid			= arrList(4,jcnt) '// 상품일경우 itemid , 이벤트 일경우 event_code
			itemname		= arrList(5,jcnt) '// 상품일경우 itemname , 이벤트 일경우 event_name
		If contents_type = "i" Then '// 상품일경우 이미지
			basicimage		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(itemid) + "/" + (arrList(6,jcnt))
			tentenimage400	= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(itemid) + "/" + (arrList(7,jcnt))
		Else '// 이벤트 일경우 subcopy
			basicimage		= db2Html(arrList(6,jcnt))
			tentenimage400	= db2Html(arrList(7,jcnt)) '// 이벤트 일경우 모바일 설명
		End If
			sellcash		= arrList(8,jcnt)
			orgprice		= arrList(9,jcnt)
			sailyn			= arrList(10,jcnt)
			itemcouponyn	= arrList(11,jcnt)
			itemcouponvalue	= arrList(12,jcnt)
			itemcoupontype	= arrList(13,jcnt)


		'// 기본 값 + 배열 선언
		If jcnt=0 Then '// 초기선언
			Set obj("cateitem") = jsArray()
			Set obj("cateevent") = jsArray()

			'// 1번만 담을 배열
			obj("catecode")  = ""& catecode &""
			obj("catename")  = ""& cateName(catecode) &""
			obj("cateclass") = ""& cateClass(catecode)&""
			If isapp = "1" then
				obj("cateurl")   = ""& catecode &""
			Else
			    obj("cateurl")   = "/category/category_main2020.asp?disp="& catecode & gaparamReturn(catecode,0) &"0"
			End If
		else
			If catecode <> temp_catecode Then '// 루프 외에 기본 뼈대 만들것
				Set	json(null) = obj ''배열 처리 따로 해줘야함
				Set obj = Nothing
				Set obj = jsObject()
				Set obj("cateitem") = jsArray()
				Set obj("cateevent") = jsArray()

				'// 1번만 담을 배열
				obj("catecode")  = ""& catecode &""
				obj("catename")  = ""& cateName(catecode) &""
				obj("cateclass") = ""& cateClass(catecode)&""
				If isapp = "1" then
					obj("cateurl")   = ""& catecode &""
				Else
					If application("Svr_Info")="staging" or application("Svr_Info")="Dev" Then '// *** 2020리뉴얼 임시 ***
                        obj("cateurl")   = "/category/category_main2020.asp?disp="& catecode & gaparamReturn(catecode,0) &"0"
                    Else
                        obj("cateurl")   = "/category/category_list.asp?disp="& catecode & gaparamReturn(catecode,0) &"0"
                    End If
				End If
			End If
		end if

		'// 전체 소팅 순서 (item , event 섞임)
		'// 상품들
		If contents_type = "i" Then
			'// 상품들 json object
			Set obj("cateitem")(null) = jsObject()

				'// 상품 링크
				obj("cateitem")(null)("link") = "/category/category_itemPrd.asp?itemid="& itemid & gaparamReturn(catecode,0) & contents_sort &""
				obj("cateitem")(null)("itemid") = ""& itemid &""
				obj("cateitem")(null)("itemimage") = ""& chkiif(arrList(7,jcnt) <> "" , getThumbImgFromURL(tentenimage400,200,200,"true","false") , getThumbImgFromURL(basicimage,200,200,"true","false") ) &""
				obj("cateitem")(null)("itemname") = ""& itemname &""
				'// 가격 할인
				If sailYN = "N" and itemcouponyn = "N" Then
					obj("cateitem")(null)("price") = ""& formatNumber(orgPrice,0) &""
				End If
				If sailYN = "Y" and itemcouponyn = "N" Then
					obj("cateitem")(null)("price") = ""& formatNumber(sellCash,0) &""
				End If

				if itemcouponyn = "Y" And itemcouponvalue>0 Then
					If itemcoupontype = "1" Then
						obj("cateitem")(null)("price") =  ""& formatNumber(sellCash - CLng(itemcouponvalue*sellCash/100),0) &""
					ElseIf itemcoupontype = "2" Then
						obj("cateitem")(null)("price") =  ""& formatNumber(sellCash - itemcouponvalue,0) &""
					ElseIf itemcoupontype = "3" Then
						obj("cateitem")(null)("price") =  ""& formatNumber(sellCash,0) &""
					Else
						obj("cateitem")(null)("price") =  ""& formatNumber(sellCash,0) &""
					End If
				End If

				If sailYN = "Y" and itemcouponyn = "N" Then
					If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
						obj("cateitem")(null)("sale") = ""& CLng((orgPrice-sellCash)/orgPrice*100) &"%"
					End If
				elseif itemcouponyn = "Y" And itemcouponvalue>0 Then
					If itemcoupontype = "1" Then
						obj("cateitem")(null)("sale") = ""& CStr(itemcouponvalue) &"%"
					ElseIf itemcoupontype = "2" Then
						obj("cateitem")(null)("sale") = "쿠폰"
					ElseIf itemcoupontype = "3" Then
						obj("cateitem")(null)("sale") = ""
					Else
						obj("cateitem")(null)("sale") = ""& itemcouponvalue &"%"
					End If
				Else
						obj("cateitem")(null)("sale") = ""
				End If
		End If
		'// 이벤트 들
		If contents_type = "e" Then
			'// 이벤트 명에서 상품명과 할인율 분리
			If ubound(Split(itemname,"|"))> 0 Then
				evtName1	= cStr(Split(itemname,"|")(0))
				evtName2	= cStr(Split(itemname,"|")(1))
			Else
				evtName1	= itemname
				evtName2	= ""
			End If

			If InStr(evtName1,"<br>") > 0 Then
				evtName1 = Replace(evtName1,"<br>","")
			ElseIf InStr(evtName1,"<br/>") > 0 Then
				evtName1 = Replace(evtName1,"<br/>","")
			ElseIf InStr(evtName1,"</br>") > 0 Then
				evtName1 = Replace(evtName1,"</br>","")
			ElseIf InStr(evtName1,"<BR>") > 0 Then
				evtName1 = Replace(evtName1,"<BR>","")
			End If

			If InStr(tentenimage400,"<br>") > 0 Then
				tentenimage400 = Replace(tentenimage400,"<br>","")
			ElseIf InStr(tentenimage400,"<br/>") > 0 Then
				tentenimage400 = Replace(tentenimage400,"<br/>","")
			ElseIf InStr(tentenimage400,"</br>") > 0 Then
				tentenimage400 = Replace(tentenimage400,"</br>","")
			ElseIf InStr(tentenimage400,"<BR>") > 0 Then
				tentenimage400 = Replace(tentenimage400,"<BR>","")
			End if

			'// 이벤트 json object
			Set obj("cateevent")(null) = jsObject()
				obj("cateevent")(null)("eventimage") = ""& basicimage &""
				obj("cateevent")(null)("maincopy") = ""& evtName1 &""
				obj("cateevent")(null)("subcopy") = ""& tentenimage400 &""
				obj("cateevent")(null)("link") = "/event/eventmain.asp?eventid="& itemid & gaparamReturn(catecode,0) &"event"& contents_sort &""
				obj("cateevent")(null)("sale") = ""& evtName2 &""
		End If

		if jcnt=ubound(arrList,2) Then '// 마지막선언
			Set	json(null) = obj ''배열 처리 따로 해줘야함
			Set obj = Nothing
		End if

		temp_catecode  = catecode
	Next

	'json.Flush
	Response.write Replace(toJSON(json),",null","")
End If

on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->