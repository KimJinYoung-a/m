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
' History : 2017-08-07 이종화 생성
'#######################################################
Dim intI ,intJ
Dim sqlStr , rsMem , arrList
Dim gaParam
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MBIMG_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MBIMG"
End If

sqlStr = "db_sitemaster.dbo.[usp_Ten_today_OneBanner]"
set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
'// 파일 생성
intJ = 0 '실제 json 생성 넘버
If IsArray(arrList) Then
	Dim tmpjson , dataList() , poscode
	Dim img, link ,startdate , enddate , altname , idx , socname , socname_kor , makerid , maincopy , subcopy , cgubun , culopt , backcolor
	Dim maincopy2 , tag_gift , tag_plusone , tag_launching , tag_actively , sale_per , coupon_per , evttag
	ReDim dataList(ubound(arrlist,2))
	For intI = 0 To ubound(arrlist,2)
		evttag			= ""
		poscode			= arrlist(0,intI)

		If poscode = 2078 Then
			gaParam = "&gaparam=today_mkt_" '// 마케팅롤링
		ElseIf poscode = 2079 Then
			gaParam = "&gaparam=today_imgbanner_a" '//이미지배너A
		ElseIf poscode = 2080 Then
			gaParam = "&gaparam=today_imgbanner_b" '//이미지배너B
		ElseIf poscode = 2081 Then
			gaParam = "&gaparam=today_imgbanner_gif" '//이미지배너C_gif
		ElseIf poscode = 2082 Then '// A/B TEST BType
			gaParam = "&gaparam=today_HCP_" '// H.C.P 히치하이커 , 컬쳐 , 플레잉
		ElseIf poscode = 2083 Then 
			gaParam = "&gaparam=guide_banner" '// 가이드배너 20180809 추가
		End If

		if instr(arrlist(1,intI),"webimage.10x10.co.kr/eventIMG/") > 0 then
		img	= db2Html(arrlist(1,intI))
		else
		img	= staticImgUrl & "/mobile/" + db2Html(arrlist(1,intI))
		end if

		link			= Trim(db2Html(arrlist(2,intI)))

		If InStr(Left(link,1),"/") = 0 Then '// 운영이슈 맨 앞에 / 빼 먹을 경우 자동 추가
			link = "/"& link
		End If

		startdate		= arrlist(3,intI)
		enddate			= arrlist(4,intI)
		altname			= db2Html(arrlist(5,intI))
		If poscode = 2082 Then '2070 히치하이커/그라운드/컬처 고정
			maincopy	= db2Html(arrlist(6,intI))
			subcopy		= db2Html(arrlist(7,intI))
			cgubun		= db2Html(arrlist(8,intI))
			culopt		= db2Html(arrlist(9,intI))
			backcolor	= db2Html(arrlist(10,intI))
		End If

		If poscode = 2079 Or poscode = 2080 Then
			maincopy	= db2Html(arrlist(6,intI))
			subcopy		= arrlist(7,intI)
		End If

		maincopy2		= db2Html(arrlist(11,intI))
		tag_gift		= db2Html(arrlist(12,intI))
		tag_plusone		= db2Html(arrlist(13,intI))
		tag_launching	= db2Html(arrlist(14,intI))
		tag_actively	= db2Html(arrlist(15,intI))
		sale_per		= db2Html(arrlist(16,intI))
		coupon_per		= db2Html(arrlist(17,intI))

		If tag_actively = "Y"	Then evttag = "참여"	'//actively
		If tag_launching = "Y"	Then evttag = "런칭"	'//launching
		If tag_plusone = "Y"	Then evttag = "1+1"	'//plusone
		If tag_gift = "Y"		Then evttag = "GIFT"	'//gift

		'//json생성
		Set tmpjson = jsObject()
			If poscode = 2082 then
				tmpjson("link") = ""& link & gaparamchk(link,gaParam) & (cgubun) &""
			ElseIf poscode = 2078 then
				tmpjson("link") = ""& link & gaparamchk(link,gaParam) & (intJ+1) &""
			Else
				tmpjson("link") = ""& link & gaparamchk(link,gaParam) &""
			End If
			If poscode = 2079 Or poscode = 2080 Then '단면배너
				If application("Svr_Info") = "Dev" Then
					tmpjson("imgsrc") = ""& img &""
				Else
					tmpjson("imgsrc") = ""& getThumbImgFromURL(img,750,"","","") &""
				End If
			Else
				If poscode = 2082 And cgubun = 2 Then
					tmpjson("imgsrc") = ""& getThumbImgFromURL(img,200,"","","") &""
				Else
					tmpjson("imgsrc") = ""& img &""
				End If
			End If
			'	tmpjson("alt") = ""& altname &""
			If poscode = 2082 Then '2070 히치하이커/그라운드/컬처 고정
				tmpjson("maincopy") = ""& maincopy &""
				tmpjson("subcopy") = ""& subcopy &""
				tmpjson("cgubun") = ""& cgubun &""
				If cgubun = 2 Then
				tmpjson("culopt") = ""& culopt &""
				End If
				tmpjson("backcolor") = ""& backcolor &""
			End If

			If poscode = 2079 Or poscode = 2080 Then
				tmpjson("maincopy") = ""& maincopy &""
				tmpjson("subcopy") = ""& subcopy &""
				tmpjson("maincopy2") = ""& maincopy2 &""
				tmpjson("evttag") = ""& evttag &""
				tmpjson("sale_per") = ""& sale_per &""
				If coupon_per = "" Then
					tmpjson("coupon_per") = ""
				Else
					tmpjson("coupon_per") = "쿠폰 "& coupon_per &""
				End If
			End If

			If poscode = 2078 Then
				tmpjson("poscode") = ""& poscode &""
				tmpjson("ampevt") = "click_mainbanner"
				tmpjson("ampevtp") = "bannertype"
				tmpjson("ampevtpv") = "mkt"&intJ+1
			ElseIf poscode = 2079 Then
				tmpjson("poscode") = ""& poscode &""
				tmpjson("ampevt") = "click_mainbanner"
				tmpjson("ampevtp") = "bannertype"
				tmpjson("ampevtpv") = "imga"
			ElseIf poscode = 2080 Then
				tmpjson("poscode") = ""& poscode &""
				tmpjson("ampevt") = "click_mainbanner"
				tmpjson("ampevtp") = "bannertype"
				tmpjson("ampevtpv") = "imgb"
			ElseIf poscode = 2081 Then
				tmpjson("poscode") = ""& poscode &""
				tmpjson("ampevt") = "click_mainbanner"
				tmpjson("ampevtp") = "bannertype"
				tmpjson("ampevtpv") = "imgcgif"
			ElseIf poscode = 2082 Then '// A/B TEST BType
				tmpjson("poscode") = ""& poscode &""
				If cgubun = 1 Then
					tmpjson("ampevt") = "click_mainhitchhiker"
					tmpjson("ampevtp") = ""
					tmpjson("ampevtpv") = ""
				ElseIf cgubun = 2 Then
					tmpjson("ampevt") = "click_mainculture"
					tmpjson("ampevtp") = ""
					tmpjson("ampevtpv") = ""
				ElseIf cgubun = 3 Then
					tmpjson("ampevt") = "click_mainplaying"
					tmpjson("ampevtp") = ""
					tmpjson("ampevtpv") = ""
				End If
			ElseIf poscode = 2083 Then
				tmpjson("poscode") = ""& poscode &""
				tmpjson("ampevt") = "click_guidebanner"
				tmpjson("ampevtp") = "bannertype"
				tmpjson("ampevtpv") = "guide"&intJ+1		
			End If

		'//top 메인롤링
		Set dataList(intJ) = tmpjson

		intJ = intJ + 1
	Next
End If

Response.write Replace(toJSON(dataList),",null","")

on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->