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
' Discription : mobile_brandbanner json // cache DB경유
' History : 2017-08-09 이종화 생성
'#######################################################

Dim gaParam : gaParam = "&gaparam=today_brand_" '//GA 체크 변수
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
	dummyName = "BBAN_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "BBAN"
End If


dim prevDate, sqlDate, vTotalCount , lprevDate , sumDate
Dim vImgsrc1 , vImgsrc2

	sqlStr = "db_sitemaster.[dbo].[usp_Ten_today_BrandBanner] "
	set rsMem = getDBCacheSQL(dbget,rsget,dummyName,sqlStr,cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.GetRows
	END IF
	rsMem.close

	on Error Resume Next

	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			If ubound(Split(arrList(8,jcnt),",")) > 0 Then ' 이미지 3개 정보
				For ii = 0 To ubound(Split(arrList(8,jcnt),","))
					If CStr(arrList(6,jcnt)) = CStr(Split(Split(arrList(8,jcnt),",")(ii),"|")(0)) Then
						vItemimg1 =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(6,jcnt)) & "/" & Split(Split(arrList(8,jcnt),",")(ii),"|")(1)
					End If

					If CStr(arrList(7,jcnt)) = CStr(Split(Split(arrList(8,jcnt),",")(ii),"|")(0)) Then
						vItemimg2 =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(7,jcnt)) & "/" & Split(Split(arrList(8,jcnt),",")(ii),"|")(1)
					End If
				Next 
			End If 
			
			if (inStr(arrList(1,jcnt),"http://")>0) then
				vImgsrc1 = arrList(1,jcnt)
			else
				If arrList(1,jcnt) <> "" Then vImgsrc1 = staticImgUrl & "/mobile/brandinfo" & arrList(1,jcnt)
			end if
			if (inStr(arrList(2,jcnt),"http://")>0) then
				vImgsrc2 = arrList(2,jcnt)
			else
				If arrList(2,jcnt) <> "" Then vImgsrc2 = staticImgUrl & "/mobile/brandinfo" & arrList(2,jcnt)
			end if

			Set tmpjson =  jsObject()
				tmpjson("brandid")= ""& arrList(0,jcnt) &""
				tmpjson("brandlink")= "/brand/brand_detail2020.asp?brandid="& arrList(0,jcnt) & gaParam &"img"
				tmpjson("imgsrc1")  = ""& vImgsrc1 &""
				tmpjson("imgsrc2")  = ""& vimgsrc2 &""
				tmpjson("maincopy") = ""& arrList(3,jcnt) &""
				tmpjson("subcopy") = ""& db2html(arrList(4,jcnt)) &""
				tmpjson("link")		= ""& arrList(5,jcnt) & gaParam &"0"
'				tmpjson("itemid1") = ""& arrList(6,jcnt) &""
'				tmpjson("itemid2") = ""& arrList(7,jcnt) &""
				tmpjson("itemid1url") = "/category/category_itemPrd.asp?itemid="& arrList(6,jcnt) & gaParam &"1"
				tmpjson("itemid2url") = "/category/category_itemPrd.asp?itemid="& arrList(7,jcnt) & gaParam &"2"
				If application("Svr_Info") = "Dev" Then
					tmpjson("itemimg1") = ""& vItemimg1 &""
					tmpjson("itemimg2") = ""& vItemimg2 &""
				else
					tmpjson("itemimg1") = ""& getThumbImgFromURL(vItemimg1,200,200,"true","false") &""
					tmpjson("itemimg2") = ""& getThumbImgFromURL(vItemimg2,200,200,"true","false") &""
				end if

				'// amplitude 브랜드 배너 클릭용
				tmpjson("ampevt") 	= "click_mainbrand"
				tmpjson("ampevtp") 	= "brand_id"
				tmpjson("ampevtpv") = ""& arrList(0,jcnt) &""

				'// amplitude 상품클릭 1
				tmpjson("ampevt_item") 	= "click_mainbrand_items"
				tmpjson("ampevtp_item") = "indexnumber|itemid"
				tmpjson("ampevtpv_1") 	= "1|"& arrList(6,jcnt) &""
				'// amplitude 상품클릭 2
				tmpjson("ampevtpv_2") 	= "2|"& arrList(7,jcnt) &""

			 Set dataList(jcnt) = tmpjson
		Next
		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
