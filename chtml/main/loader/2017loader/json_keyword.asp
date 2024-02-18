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

Dim gaParam : gaParam = "&gaparam=today_keyword_0" '//GA 체크 변수
Dim tmpjson : tmpjson = ""
Dim dataList()
Dim json , jcnt
Dim sqlStr
Dim rsMem , arrList
Dim vKeyName1 , vKeyName2 , vKeyName3 , vKeyName4
Dim vKeyImg1 , vKeyImg2 , vKeyImg3 , vKeyImg4
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 0
Dim ii

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MHKY_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MHKY"
End If

dim prevDate, sqlDate, vTotalCount , lprevDate , sumDate

	sqlStr = "db_sitemaster.[dbo].[usp_Ten_today_keyword] "
	set rsMem = getDBCacheSQL(dbget,rsget,dummyName,sqlStr,cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.GetRows
	END IF
	rsMem.close

	on Error Resume Next

	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			vKeyImg1 = staticImgUrl & "/mobile/todaykeyword" & arrList(17,jcnt)
			vKeyImg2 = staticImgUrl & "/mobile/todaykeyword" & arrList(18,jcnt)
			vKeyImg3 = staticImgUrl & "/mobile/todaykeyword" & arrList(19,jcnt)
			vKeyImg4 = staticImgUrl & "/mobile/todaykeyword" & arrList(20,jcnt)

			If ubound(Split(arrList(22,jcnt),",")) > 0 Then ' 이미지 3개 정보
                For ii = 0 To ubound(Split(arrList(22,jcnt),","))
                    If CStr(arrList(12,jcnt)) = CStr(Split(Split(arrList(22,jcnt),",")(ii),"|")(0)) And vKeyImg1 = (staticImgUrl & "/mobile/todaykeyword") Then
                        'vKeyName1 = Split(Split(arrList(22,jcnt),",")(ii),"|")(1)
                        vKeyImg1 =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(12,jcnt)) & "/" & Split(Split(arrList(22,jcnt),",")(ii),"|")(2)
                    End If

                    If CStr(arrList(13,jcnt)) = CStr(Split(Split(arrList(22,jcnt),",")(ii),"|")(0)) And vKeyImg2 = (staticImgUrl & "/mobile/todaykeyword") Then
                        'vKeyName2 = Split(Split(arrList(22,jcnt),",")(ii),"|")(1)
                        vKeyImg2 =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(13,jcnt)) & "/" & Split(Split(arrList(22,jcnt),",")(ii),"|")(2)
                    End If

                    If CStr(arrList(14,jcnt)) = CStr(Split(Split(arrList(22,jcnt),",")(ii),"|")(0)) And vKeyImg3 = (staticImgUrl & "/mobile/todaykeyword") Then
                        'vKeyName3 = Split(Split(arrList(22,jcnt),",")(ii),"|")(1)
                        vKeyImg3 =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(14,jcnt)) & "/" & Split(Split(arrList(22,jcnt),",")(ii),"|")(2)
                    End If

                    If CStr(arrList(15,jcnt)) = CStr(Split(Split(arrList(22,jcnt),",")(ii),"|")(0)) And vKeyImg4 = (staticImgUrl & "/mobile/todaykeyword") Then
                        'vKeyName4 = Split(Split(arrList(22,jcnt),",")(ii),"|")(1)
                        vKeyImg4 =  webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(arrList(15,jcnt)) & "/" & Split(Split(arrList(22,jcnt),",")(ii),"|")(2)
                    End If
                Next
            End If

			Set tmpjson =  jsObject()
				tmpjson("ver_no")	= ""& arrList(9,jcnt) &""
				tmpjson("maincopy") = ""& arrList(10,jcnt) &""
				tmpjson("link")		= ""& arrList(11,jcnt) & gaParam &""

				If application("Svr_Info") = "Dev" Then
					tmpjson("imgsrc1") = ""& vKeyImg1 &""
					tmpjson("imgsrc2") = ""& vKeyImg2 &""
					tmpjson("imgsrc3") = ""& vKeyImg3 &""
					tmpjson("imgsrc4") = ""& vKeyImg4 &""
				Else
					tmpjson("imgsrc1") = ""& vKeyImg1 &""
					tmpjson("imgsrc2") = ""& vKeyImg2 &""
					tmpjson("imgsrc3") = ""& vKeyImg3 &""
					tmpjson("imgsrc4") = ""& vKeyImg4 &""
'					tmpjson("imgsrc1") = ""& getThumbImgFromURL(vKeyImg1,300,300,"true","false") &""
'					tmpjson("imgsrc2") = ""& getThumbImgFromURL(vKeyImg2,300,300,"true","false") &""
'					tmpjson("imgsrc3") = ""& getThumbImgFromURL(vKeyImg3,300,300,"true","false") &""
'					tmpjson("imgsrc4") = ""& getThumbImgFromURL(vKeyImg4,300,300,"true","false") &""
				end if

				tmpjson("itemid1url") = "/category/category_itemPrd.asp?itemid="& arrList(12,jcnt) &"&gaparam=today_keyword_1"
				tmpjson("itemid2url") = "/category/category_itemPrd.asp?itemid="& arrList(13,jcnt) &"&gaparam=today_keyword_2"
				tmpjson("itemid3url") = "/category/category_itemPrd.asp?itemid="& arrList(14,jcnt) &"&gaparam=today_keyword_3"
				tmpjson("itemid4url") = "/category/category_itemPrd.asp?itemid="& arrList(15,jcnt) &"&gaparam=today_keyword_4"
				tmpjson("picknum") = ""& arrList(16,jcnt) &""
'				tmpjson("title1") = ""& vKeyName1 &""
'				tmpjson("title2") = ""& vKeyName2 &""
'				tmpjson("title3") = ""& vKeyName3 &""
'				tmpjson("title4") = ""& vKeyName4 &""
'				tmpjson("alts1") = ""& vKeyName1 &""
'				tmpjson("alts2") = ""& vKeyName2 &""
'				tmpjson("alts3") = ""& vKeyName3 &""
'				tmpjson("alts4") = ""& vKeyName4 &""
				tmpjson("bgcolor") = ""& arrList(21,jcnt) &""
				tmpjson("itemid_1") = ""& arrList(12,jcnt) &""
				tmpjson("itemid_2") = ""& arrList(13,jcnt) &""
				tmpjson("itemid_3") = ""& arrList(14,jcnt) &""
				tmpjson("itemid_4") = ""& arrList(15,jcnt) &""

			 Set dataList(jcnt) = tmpjson
		Next
		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
