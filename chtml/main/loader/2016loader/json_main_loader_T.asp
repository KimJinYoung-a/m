<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : mobile_main_banner // cache DB경유
' History : 2016-04-27 이종화 생성
'#######################################################
Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList
Dim gaParam
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수

poscode = requestCheckVar(request("poscode"),4)

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime
If CDate(now()) <= CDate(Date() & " 00:05:00") Then
	cTime = 60*1
Else
	cTime = 60*5
End If

IF poscode = "" THEN 
	Call Alert_Return("잘못된 접근입니다.")
	response.End
END IF

Dim topcnt : topcnt = 10

If poscode = 2067 Or poscode = 2068 Or poscode = 2073 Then '단면배너
	topcnt = 5
	limitcnt = 0 '배열이라 -1개 총 1개
End If

If poscode = 2069 Then '브랜드배너
	topcnt = 20
	limitcnt = 0 '배열이라 -1개 총 1개
End If

If poscode = 2070 Or poscode = 2071 Then '컨텐츠배너
	topcnt = 12
	limitcnt = 3 '배열이라 -1개 총 4개
End If

If poscode = 2063 Or poscode = 2065 Then
	'topcnt = 15
	topcnt = 40
	If isapp = "1" Then
		limitcnt = 5 '배열이라 -1개 총 6개 (app 전용 배너)
	Else
		limitcnt = 4 '배열이라 -1개 총 5개
	End If 
End If 

sqlStr = ""
If poscode = 2069 Then '2069 브랜드
	gaParam = "&gaparam=today_brand_" '// 브랜드롤링

	sqlStr = " select top "& topcnt &" imageurl , linkurl , startdate ,  enddate , altname , socname , socname_kor , makerid from [db_sitemaster].[dbo].tbl_mobile_mainCont as m "
	sqlStr = sqlStr & " inner join [db_user].[dbo].tbl_user_c as c on m.makerid = c.userid "
	sqlStr = sqlStr & " where m.poscode = " & poscode & " and m.isusing = 'Y' and isnull(m.imageurl,'') <> ''  "
	sqlStr = sqlStr & " and m.enddate >= getdate() "
	sqlStr = sqlStr & " order by m.orderidx asc , m.idx desc "
ElseIf poscode = 2070 Then
	gaParam = "&gaparam=today_contents_" '// 컨텐츠롤링

	sqlStr = "select top "& topcnt &" imageurl , linkurl , startdate ,  enddate , altname , maincopy , subcopy from [db_sitemaster].[dbo].tbl_mobile_mainCont"
	sqlStr = sqlStr & " where poscode = " & poscode & " and isusing = 'Y' and isnull(imageurl,'') <> '' "
	sqlStr = sqlStr & " and enddate >= getdate() "
	sqlStr = sqlStr & " order by orderidx asc , idx desc "
ElseIf poscode = 2071 Then '// A/B TEST BType
	gaParam = "&gaparam=today_contents_B_" '// 컨텐츠롤링

	sqlStr = "select top "& topcnt &" imageurl , linkurl , startdate ,  enddate , altname , maincopy , subcopy , cgubun , (case when culopt = 1 then '연극' when culopt = 2 then '뮤지컬' when culopt = 3 then '공연' when culopt = 4 then '전시' when culopt = 5 then '도서' when culopt = 6 then '영화' when culopt = 7 then '음반' end ) as culopt , backcolor from [db_sitemaster].[dbo].tbl_mobile_mainCont  "
	sqlStr = sqlStr & " where poscode = " & poscode & " and isusing = 'Y' and isnull(imageurl,'') <> '' "
	sqlStr = sqlStr & " and enddate >= getdate()   "
	sqlStr = sqlStr & " order by orderidx asc , idx desc  "
ElseIf poscode = 2063 Or poscode = 2065 Then
	sqlStr = "select top "& topcnt &" imageurl , linkurl , startdate ,  enddate , altname from [db_sitemaster].[dbo].tbl_mobile_mainCont "
	If poscode = 2063 Then
		gaParam = "&gaparam=today_mainroll_" '// 메인롤링

		If isapp ="1" Then 
			sqlStr = sqlStr & " where poscode in (2063,2064)  "
		Else
			sqlStr = sqlStr & " where poscode = (2063)  "
		End If 
	ElseIf poscode = 2065 Then
		gaParam = "&gaparam=today_mkt_" '// 마케팅롤링

		If isapp ="1" Then 
			sqlStr = sqlStr & " where poscode in (2065,2066) "
		Else
			sqlStr = sqlStr & " where poscode = (2065) "
		End If 
	End If 
	sqlStr = sqlStr & " and isusing = 'Y' and isnull(imageurl,'') <> '' "
	sqlStr = sqlStr & " and enddate >= getdate() "
	sqlStr = sqlStr & " order by orderidx asc , idx desc , poscode asc"
Else
	sqlStr = "select top "& topcnt &" imageurl , linkurl , startdate ,  enddate , altname from [db_sitemaster].[dbo].tbl_mobile_mainCont"
	sqlStr = sqlStr & " where poscode = " & poscode & " and isusing = 'Y' and isnull(imageurl,'') <> '' "
	sqlStr = sqlStr & " and enddate >= getdate() "
	sqlStr = sqlStr & " order by orderidx asc , idx desc"
End If

If poscode = 2067 Then
	gaParam = "&gaparam=today_imgbanner_a" '//이미지배너A
End If 

If poscode = 2068 Then
	gaParam = "&gaparam=today_imgbanner_b" '//이미지배너B
End If 

If poscode = 2073 Then
	gaParam = "&gaparam=today_imgbanner_c" '//이미지배너C
End If 

set rsMem = getDBCacheSQL(dbget, rsget, "MBIMG", sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
'// 파일 생성
intJ = 0 '실제 json 생성 넘버
If IsArray(arrList) Then
	Dim tmpjson , dataList()
	Dim img, link ,startdate , enddate , altname , idx , socname , socname_kor , makerid , maincopy , subcopy , cgubun , culopt , backcolor	
	ReDim dataList(ubound(arrlist,2))
	For intI = 0 To ubound(arrlist,2)
		
		If CDate(CtrlDate) >= CDate(arrlist(2,intI)) AND CDate(CtrlDate) <= CDate(arrlist(3,intI)) Then
			If intJ > limitcnt Then Exit For '//매뉴별 최대 갯수

		img				= staticImgUrl & "/mobile/" + db2Html(arrlist(0,intI))
		link			= Trim(db2Html(arrlist(1,intI)))

		If InStr(Left(link,1),"/") = 0 Then '// 운영이슈 맨 앞에 / 빼 먹을 경우 자동 추가
			link = "/"& link
		End If 

		startdate		= arrlist(2,intI)
		enddate			= arrlist(3,intI)
		altname			= db2Html(arrlist(4,intI))
		If poscode = 2069 Then '2069 브랜드
			socname		= db2Html(arrlist(5,intI))
			socname_kor	= db2Html(arrlist(6,intI))
			makerid		= db2Html(arrlist(7,intI))
		End If
		If poscode = 2070 Then '2070 히치하이커/그라운드/컬처 고정
			maincopy	= db2Html(arrlist(5,intI))
			subcopy		= db2Html(arrlist(6,intI))
		End If
		If poscode = 2071 Then '2070 히치하이커/그라운드/컬처 고정
			maincopy	= db2Html(arrlist(5,intI))
			subcopy		= arrlist(6,intI)
			cgubun		= db2Html(arrlist(7,intI))
			culopt		= db2Html(arrlist(8,intI))
			backcolor	= db2Html(arrlist(9,intI))
		End If

		'//json생성
		Set tmpjson = jsObject()
			If poscode = 2071 then
				tmpjson("link") = ""& link & gaparamchk(link,gaParam) & (cgubun) &""
			else
				tmpjson("link") = ""& link & gaparamchk(link,gaParam) & (intJ+1) &""
			End If
			If poscode = 2067 Or poscode = 2068 Then '단면배너
				tmpjson("imgsrc") = ""& getThumbImgFromURL(img,640,"","","") &""
			Else
				tmpjson("imgsrc") = ""& img &""
			End If 
				tmpjson("alt") = ""& altname &""
			If poscode = 2069 Then '2069 브랜드
				tmpjson("socname") = ""& socname &""
				tmpjson("socname_kor") = ""& socname_kor &""
				tmpjson("makerid") = ""& makerid &""
			End If 
			If poscode = 2070 Or poscode = 2071 Then '2070 히치하이커/그라운드/컬처 고정
				tmpjson("maincopy") = ""& maincopy &""
				tmpjson("subcopy") = ""& subcopy &""
			End If 
			If poscode = 2071 Then '2070 히치하이커/그라운드/컬처 고정
				tmpjson("cgubun") = ""& cgubun &""
				tmpjson("culopt") = ""& culopt &""
				tmpjson("backcolor") = ""& backcolor &""
			End If 
		'//top 메인롤링
		Set dataList(intJ) = tmpjson

		intJ = intJ + 1

		End If 
	Next
End If 

Response.write Replace(toJSON(dataList),",null","")

on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->