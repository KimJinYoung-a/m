<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/classes/main/hotkeyword.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
Dim gaParam
Dim tmpjson : tmpjson = ""
Dim optStr
Dim dataList()
Dim json , jcnt
Dim sqlStr
Dim vTrendImg , rsMem , arrList
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 1
Dim evttag
Dim sellCash,orgPrice,sailYN,couponYn,couponvalue,coupontype,itemimg , ii
Dim actively , launching , plusone , gift
Dim RvSelNum : RvSelNum = Session.SessionID Mod 2
Dim abtesttag
Dim amplitudeEventName, amplitudeEventProperties, amplitudeEventValue

If RvSelNum = 0 Then abtesttag = "A" Else abtesttag = "B" End if

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MAINTREND_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MAINTREND"
End If

sqlStr = "db_sitemaster.[dbo].[usp_Ten_today_TrendEvent]  "
set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next

If IsArray(arrList) Then
	ReDim dataList(ubound(arrList,2))
	For jcnt = 0 to ubound(arrList,2)
			evttag = ""
'			If (jcnt+1) < 4 Then
'				gaParam = "&gaparam=today_"& abtesttag &"eventa_"&(lcnt) ''//이벤트배너 1~3
'			ElseIf (jcnt+1) > 3 And (jcnt+1) < 7 then
'				gaParam = "&gaparam=today_"& abtesttag &"eventb_"&(lcnt) ''//이벤트배너 4~6
'			ElseIf (jcnt+1) > 6 And (jcnt+1) < 9 then
'				gaParam = "&gaparam=today_"& abtesttag &"eventc_"&(lcnt) ''//이벤트배너 7~8
'			ElseIf (jcnt+1) > 8 And (jcnt+1) < 11 then
'				gaParam = "&gaparam=today_"& abtesttag &"eventd_"&(lcnt) ''//이벤트배너 9~10
'			ElseIf (jcnt+1) > 10 then
'				gaParam = "&gaparam=today_"& abtesttag &"eventitem"& chkiif((jcnt+1)=11,"a","b") &"_0" ''//이벤트배너 11~12 + 상품형
'			End If

			If (jcnt+1) < 4 Then
				gaParam = "&gaparam=today_eventa_"&(lcnt) ''//이벤트배너 1~3
				amplitudeEventName = "click_mainenjoybanner"
				amplitudeEventProperties = "type|linkurl"
				amplitudeEventValue = "today_"& abtesttag &"eventa_"&(lcnt)&"|"&arrList(1,jcnt)&""
			ElseIf (jcnt+1) > 3 And (jcnt+1) < 7 then
				gaParam = "&gaparam=today_eventb_"&(lcnt) ''//이벤트배너 4~6
				amplitudeEventName = "click_mainenjoybanner"
				amplitudeEventProperties = "type|linkurl"
				amplitudeEventValue = "today_eventb_"&(lcnt)&"|"&arrList(1,jcnt)&""
			ElseIf (jcnt+1) > 6 And (jcnt+1) < 10 then
				gaParam = "&gaparam=today_eventc_"&(lcnt) ''//이벤트배너 7~8
				amplitudeEventName = "click_mainenjoybanner"
				amplitudeEventProperties = "type|linkurl"
				amplitudeEventValue = "today_"& abtesttag &"eventc_"&(lcnt)&"|"&arrList(1,jcnt)&""
			ElseIf (jcnt+1) > 9  then
				gaParam = "&gaparam=today_eventd_"&(lcnt) ''//이벤트배너 9~10
				amplitudeEventName = "click_mainenjoybanner"
				amplitudeEventProperties = "type|linkurl"
				amplitudeEventValue = "today_"& abtesttag &"eventd_"&(lcnt)&"|"&arrList(1,jcnt)&""
			End If

'			If lcnt = 2 Or (jcnt+1) = 3 Then 'gaparam number
'				lcnt = 1
'			Else
'				lcnt = lcnt + 1
'			End If

			lcnt = lcnt + 1

			If arrList(10,jcnt) = "1" Then
				If application("Svr_Info") = "Dev" Then
					vTrendImg = arrList(9,jcnt)
				Else
					vTrendImg = getThumbImgFromURL(arrList(9,jcnt),750,"","","")
				End If
			Else
				vTrendImg = staticImgUrl & "/mobile/enjoyevent" & arrList(3,jcnt)
			End If

			If arrList(16,jcnt) = "Y" Then evttag = "참여"	'//actively
			If arrList(15,jcnt) = "Y" Then evttag = "런칭"	'//launching
			If arrList(14,jcnt) = "Y" Then evttag = "1+1"	'//plusone
			If arrList(13,jcnt) = "Y" Then evttag = "GIFT"	'//gift
			If arrList(18,jcnt) <> "" Then evttag = "쿠폰"&arrList(18,jcnt)

			Set tmpjson =  jsObject()
				tmpjson("id")				= ""& jcnt + 1 &""

				tmpjson("link")				= ""& arrList(1,jcnt) & gaParam &""
				tmpjson("imgsrc")			= ""& vTrendImg &""
				tmpjson("alts")				= ""& arrList(4,jcnt) &""
				tmpjson("title1")			= ""& arrList(2,jcnt) &""
				tmpjson("title2")			= ""& arrList(5,jcnt) &""

				tmpjson("evttag")			= ""& evttag &""

				tmpjson("sale_per")			= ""& arrList(17,jcnt) &""
				tmpjson("coupon_flag")		= ""& chkiif(arrList(18,jcnt)<>"","1","0") &""
				tmpjson("onlytag")			= ""& chkiif(arrList(24,jcnt)="Y","1","0") &""

				tmpjson("ampevt")			= amplitudeEventName
				tmpjson("ampevtp")			= amplitudeEventProperties
				tmpjson("ampevtpv")			= amplitudeEventValue
			If arrList(22,jcnt) = 2 Then
'				tmpjson("itemid1")			= ""& arrList(19,jcnt) &""
'				tmpjson("itemid2")			= ""& arrList(20,jcnt) &""
'				tmpjson("itemid3")			= ""& arrList(21,jcnt) &""
				tmpjson("itemid1url") = "/category/category_itemPrd.asp?itemid="& arrList(19,jcnt) &"&gaparam=today_eventitem"& chkiif((jcnt+1)=11,"a","b") &"_1"
				tmpjson("itemid2url") = "/category/category_itemPrd.asp?itemid="& arrList(20,jcnt) &"&gaparam=today_eventitem"& chkiif((jcnt+1)=11,"a","b") &"_2"
				tmpjson("itemid3url") = "/category/category_itemPrd.asp?itemid="& arrList(21,jcnt) &"&gaparam=today_eventitem"& chkiif((jcnt+1)=11,"a","b") &"_3"
			End If

				tmpjson("addtype")			= ""& arrList(22,jcnt) &""

			 If arrList(22,jcnt) = 2 Then '//가격 정보 addtype 기본형 + 상품 3개 일때

				If arrList(23,jcnt) <> "" Or Not isnull(arrList(23,jcnt)) Then
					If ubound(Split(arrList(23,jcnt),",")) > 0 Then ' 이미지 3개 정보
						For ii = 0 To ubound(Split(arrList(23,jcnt),","))

							sellCash	= Split(Split(arrList(23,jcnt),",")(ii),"|")(1)
							orgPrice	= Split(Split(arrList(23,jcnt),",")(ii),"|")(2)
							sailYN		= Split(Split(arrList(23,jcnt),",")(ii),"|")(3)
							couponYn	= Split(Split(arrList(23,jcnt),",")(ii),"|")(4)
							couponvalue = Split(Split(arrList(23,jcnt),",")(ii),"|")(5)
							coupontype	= Split(Split(arrList(23,jcnt),",")(ii),"|")(7)
							itemimg		= Split(Split(arrList(23,jcnt),",")(ii),"|")(8)

							'//1번 상품
							If CStr(arrList(19,jcnt)) = CStr(Split(Split(arrList(23,jcnt),",")(ii),"|")(0)) Then
								tmpjson("itemimg1") =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(19,jcnt)) & "/" & itemimg

								If sailYN = "N" and couponYn = "N" Then
									tmpjson("price1") = ""&formatNumber(orgPrice,0) &""
								End If
								If sailYN = "Y" and couponYn = "N" Then
									tmpjson("price1") = ""&formatNumber(sellCash,0) &""
								End If
								if couponYn = "Y" And couponvalue>0 Then
									If coupontype = "1" Then
									tmpjson("price1") = ""&formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &""
									ElseIf coupontype = "2" Then
									tmpjson("price1") = ""&formatNumber(sellCash - couponvalue,0) &""
									ElseIf coupontype = "3" Then
									tmpjson("price1") = ""&formatNumber(sellCash,0) &""
									Else
									tmpjson("price1") = ""&formatNumber(sellCash,0) &""
									End If
								End If
								If sailYN = "Y" And couponYn = "Y" Then
									If coupontype = "1" Then
										'//할인 + %쿠폰
										tmpjson("sale1") = ""& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%"
									ElseIf coupontype = "2" Then
										'//할인 + 원쿠폰
										tmpjson("sale1") = ""& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%"
									Else
										'//할인 + 무배쿠폰
										tmpjson("sale1") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
									End If
								ElseIf sailYN = "Y" and couponYn = "N" Then
									If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
										tmpjson("sale1") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
									End If
								elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
									If coupontype = "1" Then
										tmpjson("sale1") = ""&  CStr(couponvalue) & "%"
									ElseIf coupontype = "2" Then
										tmpjson("sale1") = ""
									ElseIf coupontype = "3" Then
										tmpjson("sale1") = ""
									Else
										tmpjson("sale1") = ""& couponvalue &"%"
									End If
								Else
									tmpjson("sale1") = ""
								End If
							End If

							'//2번 상품
							If CStr(arrList(20,jcnt)) = CStr(Split(Split(arrList(23,jcnt),",")(ii),"|")(0)) Then
								tmpjson("itemimg2") =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(20,jcnt)) & "/" & itemimg

								If sailYN = "N" and couponYn = "N" Then
									tmpjson("price2") = ""&formatNumber(orgPrice,0) &""
								End If
								If sailYN = "Y" and couponYn = "N" Then
									tmpjson("price2") = ""&formatNumber(sellCash,0) &""
								End If
								if couponYn = "Y" And couponvalue>0 Then
									If coupontype = "1" Then
									tmpjson("price2") = ""&formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &""
									ElseIf coupontype = "2" Then
									tmpjson("price2") = ""&formatNumber(sellCash - couponvalue,0) &""
									ElseIf coupontype = "3" Then
									tmpjson("price2") = ""&formatNumber(sellCash,0) &""
									Else
									tmpjson("price2") = ""&formatNumber(sellCash,0) &""
									End If
								End If
								If sailYN = "Y" And couponYn = "Y" Then
									If coupontype = "1" Then
										'//할인 + %쿠폰
										tmpjson("sale2") = ""& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%"
									ElseIf coupontype = "2" Then
										'//할인 + 원쿠폰
										tmpjson("sale2") = ""& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%"
									Else
										'//할인 + 무배쿠폰
										tmpjson("sale2") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
									End If
								ElseIf sailYN = "Y" and couponYn = "N" Then
									If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
										tmpjson("sale2") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
									End If
								elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
									If coupontype = "1" Then
										tmpjson("sale2") = ""&  CStr(couponvalue) & "%"
									ElseIf coupontype = "2" Then
										tmpjson("sale2") = ""
									ElseIf coupontype = "3" Then
										tmpjson("sale2") = ""
									Else
										tmpjson("sale2") = ""& couponvalue &"%"
									End If
								Else
									tmpjson("sale2") = ""
								End If
							End If

							'//3번 상품
							If CStr(arrList(21,jcnt)) = CStr(Split(Split(arrList(23,jcnt),",")(ii),"|")(0)) Then
								tmpjson("itemimg3") =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(21,jcnt)) & "/" & itemimg

								If sailYN = "N" and couponYn = "N" Then
									tmpjson("price3") = ""&formatNumber(orgPrice,0) &""
								End If
								If sailYN = "Y" and couponYn = "N" Then
									tmpjson("price3") = ""&formatNumber(sellCash,0) &""
								End If
								if couponYn = "Y" And couponvalue>0 Then
									If coupontype = "1" Then
									tmpjson("price3") = ""&formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &""
									ElseIf coupontype = "2" Then
									tmpjson("price3") = ""&formatNumber(sellCash - couponvalue,0) &""
									ElseIf coupontype = "3" Then
									tmpjson("price3") = ""&formatNumber(sellCash,0) &""
									Else
									tmpjson("price3") = ""&formatNumber(sellCash,0) &""
									End If
								End If
								If sailYN = "Y" And couponYn = "Y" Then
									If coupontype = "1" Then
										'//할인 + %쿠폰
										tmpjson("sale3") = ""& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%"
									ElseIf coupontype = "2" Then
										'//할인 + 원쿠폰
										tmpjson("sale3") = ""& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%"
									Else
										'//할인 + 무배쿠폰
										tmpjson("sale3") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
									End If
								ElseIf sailYN = "Y" and couponYn = "N" Then
									If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
										tmpjson("sale3") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
									End If
								elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
									If coupontype = "1" Then
										tmpjson("sale3") = ""&  CStr(couponvalue) & "%"
									ElseIf coupontype = "2" Then
										tmpjson("sale3") = ""
									ElseIf coupontype = "3" Then
										tmpjson("sale3") = ""
									Else
										tmpjson("sale3") = ""& couponvalue &"%"
									End If
								Else
									tmpjson("sale3") = ""
								End If
							End If
						Next
					End If
				End If

			 End If

			 Set dataList(jcnt) = tmpjson
	Next
	Response.write Replace(toJSON(dataList),",null","")
End If

on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->