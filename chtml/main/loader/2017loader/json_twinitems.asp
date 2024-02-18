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
response.charset = "utf-8"
'#######################################################
' Discription : mobile_todaykeyword_json // cache DB경유
' History : 2017-08-07 이종화 생성
'#######################################################

Dim gaParam : gaParam = "&gaparam=today_itembanner_" '//GA 체크 변수
Dim tmpjson : tmpjson = ""
Dim dataList()
Dim json , jcnt
Dim sqlStr
Dim rsMem , arrList
Dim vItemimg1 , vItemimg2
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 0
Dim ii

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MTWIN_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MTWIN"
End If

dim prevDate, sqlDate, vTotalCount , lprevDate , sumDate
Dim sellCash, orgPrice, sailYN, couponYn, couponvalue, coupontype, itemimg
Dim L_price , R_price , L_saleper , R_saleper , price , saleper

	sqlStr = "db_sitemaster.dbo.[usp_Ten_today_twinitems] "
	set rsMem = getDBCacheSQL(dbget,rsget,dummyName,sqlStr,cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.GetRows
	END IF
	rsMem.close

	on Error Resume Next

	'L_img , L_maincopy , L_itemname ,  L_itemid , L_newbest , R_img , R_maincopy , R_itemname ,  R_itemid , R_newbest , iteminfo

	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			vItemimg1 = staticImgUrl & "/mobile/twinitems" & arrList(0,jcnt)
			vItemimg2 = staticImgUrl & "/mobile/twinitems" & arrList(5,jcnt)

			If ubound(Split(arrList(10,jcnt),",")) > 0 Then ' 이미지 2개 정보
				For ii = 0 To ubound(Split(arrList(10,jcnt),","))
					
					sellCash	= Split(Split(arrList(10,jcnt),",")(ii),"|")(1)
					orgPrice	= Split(Split(arrList(10,jcnt),",")(ii),"|")(2)
					sailYN		= Split(Split(arrList(10,jcnt),",")(ii),"|")(3)
					couponYn	= Split(Split(arrList(10,jcnt),",")(ii),"|")(4)
					couponvalue = Split(Split(arrList(10,jcnt),",")(ii),"|")(5)
					coupontype	= Split(Split(arrList(10,jcnt),",")(ii),"|")(7)
					itemimg		= Split(Split(arrList(10,jcnt),",")(ii),"|")(9)

					'//가격
					If sailYN = "N" and couponYn = "N" Then
						price = ""&formatNumber(orgPrice,0) &""
					End If
					If sailYN = "Y" and couponYn = "N" Then
						price = ""&formatNumber(sellCash,0) &""
					End If
					if couponYn = "Y" And couponvalue>0 Then
						If coupontype = "1" Then
							price = ""&formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &""
						ElseIf coupontype = "2" Then
							price = ""&formatNumber(sellCash - couponvalue,0) &""
						ElseIf coupontype = "3" Then
							price = ""&formatNumber(sellCash,0) &""
						Else
							price = ""&formatNumber(sellCash,0) &""
						End If
					End If
					If sailYN = "Y" And couponYn = "Y" Then
						If coupontype = "1" Then
							'//할인 + %쿠폰
							saleper = ""& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%"
						ElseIf coupontype = "2" Then
							'//할인 + 원쿠폰
							saleper = ""& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%"
						Else
							'//할인 + 무배쿠폰
							saleper = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
						End If 
					ElseIf sailYN = "Y" and couponYn = "N" Then
						If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
							saleper = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
						End If
					elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
						If coupontype = "1" Then
							saleper = ""&  CStr(couponvalue) & "%"
						ElseIf coupontype = "2" Then
							saleper = ""
						ElseIf coupontype = "3" Then
							saleper = ""
						Else
							saleper = ""& couponvalue &"%"
						End If
					Else 
						saleper = ""
					End If
					'//가격

					If CStr(arrList(3,jcnt)) = CStr(Split(Split(arrList(10,jcnt),",")(ii),"|")(0)) Then
						L_price = price
						L_saleper = saleper 
					End If 

					If CStr(arrList(8,jcnt)) = CStr(Split(Split(arrList(10,jcnt),",")(ii),"|")(0)) Then
						R_price = price
						R_saleper = saleper
					End If 

					If CStr(arrList(3,jcnt)) = CStr(Split(Split(arrList(10,jcnt),",")(ii),"|")(0)) And vItemimg1 = (staticImgUrl & "/mobile/twinitems") Then
						vItemimg1 =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(3,jcnt)) & "/" & itemimg
					End If

					If CStr(arrList(8,jcnt)) = CStr(Split(Split(arrList(10,jcnt),",")(ii),"|")(0)) And vItemimg2 = (staticImgUrl & "/mobile/twinitems") Then
						vItemimg2 =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(8,jcnt)) & "/" & itemimg
					End If
				Next 
			End If 

			Set tmpjson =  jsObject()
				tmpjson("L_maincopy")	= ""& arrList(1,jcnt) &""
				tmpjson("L_itemname")	= ""& arrList(2,jcnt) &""
				tmpjson("L_itemurl")	= "/category/category_itemPrd.asp?itemid="& Trim(arrList(3,jcnt)) & gaParam &"1"
				tmpjson("L_newbest")	= ""& arrList(4,jcnt) &""
				tmpjson("R_maincopy")	= ""& arrList(6,jcnt) &""
				tmpjson("R_itemname")	= ""& arrList(7,jcnt) &""
				tmpjson("R_itemurl")	= "/category/category_itemPrd.asp?itemid="& Trim(arrList(8,jcnt)) & gaParam &"2"
				tmpjson("R_newbest")	= ""& arrList(9,jcnt) &""

				tmpjson("L_img")		= ""& vItemimg1 &""
				tmpjson("R_img")		= ""& vItemimg2 &""
				
				tmpjson("L_price")		= ""& L_price  &""
				tmpjson("L_saleper")	= ""& L_saleper &""
				tmpjson("R_price")		= ""& R_price &""
				tmpjson("R_saleper")	= ""& R_saleper &""

				tmpjson("L_itemid")		= ""& Trim(arrList(3,jcnt)) &""
				tmpjson("R_itemid")		= ""& Trim(arrList(8,jcnt)) &""

			 Set dataList(jcnt) = tmpjson
		Next
		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
