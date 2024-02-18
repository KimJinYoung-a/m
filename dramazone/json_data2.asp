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

'//테스트용 실서버 올릴땐 제거
'Call Response.AddHeader("Access-Control-Allow-Origin", "http://testm.10x10.co.kr:8080")

'#######################################################
' Discription : mobile_dramazone_json // 72서버
' History : 2018-05-02 이종화 생성
'#######################################################
Dim dramadata : dramadata = ""
Dim jcnt , icnt
Dim sqlStr , sqlStr2
Dim arrList , arrList2
Dim listidx , dramaidx , title , contents , mainimage , videourl , subimage1 , subimage2 , subimage3 , subimage4 , subimage5 , temp_listidx
Dim rsMem , rsMem2
Dim vSubidx , vListidx , vItemid , vItemusing , vSortnum , vItemname , vBasicimage , posterimage , regdate
Dim subimages(5) , item , videoYN
DIM bannerisusing, bannerimage, bannermaincopy, bannersubcopy, bannersaleper, bgcolor, rowLimit, viewFlag, evtcode, evtsdt, evtedt
dim bgArr(2)

Dim didx : didx = requestCheckVar(Request("dramaidx"),10) 
Dim lidx : lidx = requestCheckVar(Request("listidx"),10) 
Dim addsql

rowLimit = 4
viewFlag = 1
bgArr(0) = "#FBEEF1"
bgArr(1) = "#E9F5F9"
bgArr(2) = "#F9F3E5"

If didx = "" Then didx = 0
If lidx = "" Then lidx = 0

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "dramazone_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "dramazone"
End If
	
	addsql = " @idx=" & didx & ", @listidx=" & lidx

	sqlStr = "[db_sitemaster].[dbo].[usp_WWW_SBSvShop_DramaList_Get] " & addsql
	set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.GetRows
	END IF
	rsMem.close

	on Error Resume Next

	if isarray(arrList) Then

		Dim obj ,json
		Set obj = jsObject()
		Set json = jsArray() '// 카테코드가 다를때마다 배열 초기화

		Dim itemList() '// 아이템

		for jcnt = 0 to ubound(arrList,2)

			listidx		= arrList(0,jcnt)
			dramaidx	= arrList(1,jcnt)
			title		= db2html(arrList(2,jcnt))
			contents	= db2html(arrList(3,jcnt))
			mainimage	= chkiif(arrList(4,jcnt) <> "" ,staticImgUrl & "/mobile/drama" & arrList(4,jcnt),"")
			videourl	= arrList(5,jcnt)
			subimages(0)= chkiif(arrList(6,jcnt) <> "" ,staticImgUrl & "/mobile/drama" & arrList(6,jcnt),"")
			subimages(1)= chkiif(arrList(7,jcnt) <> "" ,staticImgUrl & "/mobile/drama" & arrList(7,jcnt),"")
			subimages(2)= chkiif(arrList(8,jcnt) <> "" ,staticImgUrl & "/mobile/drama" & arrList(8,jcnt),"")
			subimages(3)= chkiif(arrList(9,jcnt) <> "" ,staticImgUrl & "/mobile/drama" & arrList(9,jcnt),"")
			subimages(4)= chkiif(arrList(10,jcnt)<> "" ,staticImgUrl & "/mobile/drama" & arrList(10,jcnt),"")
			posterimage = chkiif(arrList(11,jcnt)<> "" ,staticImgUrl & "/mobile/drama" & arrList(11,jcnt),"")
			regdate		= FormatDate(arrList(12,jcnt),"0000.00.00")
			'배너 관련 데이터 추가 20180723 최종원
			bannerisusing = arrList(14,jcnt)
			bannerimage = arrList(16,jcnt)
			bannermaincopy = arrList(17,jcnt)
			bannersubcopy = arrList(21,jcnt)
			bannersaleper = arrList(18,jcnt)		
			evtcode = arrList(15,jcnt)			
			evtsdt = arrList(19,jcnt)			
			evtedt = arrList(20,jcnt)			
			Randomize
			bgcolor = bgArr(Int((3 * Rnd)))

			videoYN		= chkiif(videourl <> "" , 1 , 0)


			sqlStr2 = "[db_sitemaster].[dbo].[usp_WWW_SBSvShop_DramaListItem_Get] @listidx = " & listidx
			set rsMem2 = getDBCacheSQL(dbget, rsget, dummyName, sqlStr2, cTime)
			IF Not (rsMem2.EOF OR rsMem2.BOF) THEN
				arrList2 = rsMem2.GetRows
			Else
				arrList2 = ""
			END IF
			rsMem2.close


			If jcnt=0 Then '// 초기선언
				Set obj("dramaitem") = jsArray()
				Set obj("dramaimages") = jsArray()

					'// 1번만 담을 배열
					obj("listidx")		= ""& listidx &""
					obj("dramaidx")		= ""& dramaidx &""
					obj("title")		= ""& title &""
					obj("contents")		= ""& contents &""
					obj("mainimage")	= ""& mainimage &""
					obj("videourl")		= ""& videourl &""
					obj("videoYN")		= ""& videoYN &""
					obj("posterimage")	= ""& posterimage &""
					obj("bannerimage")	= ""& bannerimage &""
					obj("bannermaincopy")	= ""& bannermaincopy &""
					obj("bannersaleper")	= ""& bannersaleper &""
					obj("bannersubcopy")	= ""& bannersubcopy &""	
					obj("bannerisusing")	= ""& bannerisusing &""	
					obj("evtsdt")	= ""& evtsdt &""		
					obj("evtedt")	= ""& evtedt &""						
					obj("evtcode")	= ""& evtcode &""												 									
					obj("regdate")		= ""& regdate &""
					obj("bgcolor")		= ""& bgcolor &""
					obj("rowLimit")		= ""& rowLimit &""					
					obj("viewFlag")		= ""& viewFlag &""										

					obj("dramaurl")   = "/dramazone/share.asp?dramaidx="& dramaidx &"&listidx="& listidx
			else
				If listidx <> temp_listidx Then '// 루프 외에 기본 뼈대 만들것
					Set	json(null) = obj ''배열 처리 따로 해줘야함
					Set obj = Nothing
					Set obj = jsObject()
					Set obj("dramaitem") = jsArray()
					Set obj("dramaimages") = jsArray()

					'// 1번만 담을 배열
					obj("listidx")		= ""& listidx &""
					obj("dramaidx")		= ""& dramaidx &""
					obj("title")		= ""& title &""
					obj("contents")		= ""& contents &""
					obj("mainimage")	= ""& mainimage &""
					obj("videourl")		= ""& videourl &""
					obj("videoYN")		= ""& videoYN &""
					obj("posterimage")	= ""& posterimage &""
					obj("bannerimage")	= ""& bannerimage &""
					obj("bannermaincopy")	= ""& bannermaincopy &""
					obj("bannersaleper")	= ""& bannersaleper &""
					obj("bannersubcopy")	= ""& bannersubcopy &""	
					obj("bannerisusing")	= ""& bannerisusing &""	
					obj("evtsdt")	= ""& evtsdt &""		
					obj("evtedt")	= ""& evtedt &""						
					obj("evtcode")	= ""& evtcode &""												 																				 										
					obj("regdate")		= ""& regdate &""
					obj("bgcolor")		= ""& bgcolor &""
					obj("rowLimit")		= ""& rowLimit &""
					obj("viewFlag")		= ""& viewFlag &""															

					obj("dramaurl")   = "/dramazone/share.asp?dramaidx="& dramaidx &"&listidx="& listidx
				End If 
			end If

			'// images json
			For Each item In subimages
				If item <> "" Then 
					Set obj("dramaimages")(null) = jsObject()
						obj("dramaimages")(null)("images")	= ""& item &""
				End If 
			Next 

			If isarray(arrList2) Then 
				'// items json
				for icnt = 0 to ubound(arrList2,2)
					vSubidx		= arrList2(0,icnt)
					vListidx	= arrList2(1,icnt)
					vItemid		= arrList2(2,icnt)
					vItemusing	= arrList2(3,icnt)
					vSortnum	= arrList2(4,icnt)
					vItemname	= arrList2(5,icnt)
					vBasicimage	= webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(vItemid) + "/" & arrList2(6,icnt)

					If application("Svr_Info") = "Dev" Then
						vBasicimage = vBasicimage
					Else
						vBasicimage = getThumbImgFromURL(vBasicimage,200,200,"true","false")
					End If 

					Set obj("dramaitem")(null) = jsObject()
						obj("dramaitem")(null)("link")		= "/category/category_itemPrd.asp?itemid="& vItemid &""
						obj("dramaitem")(null)("itemimage") = ""& vBasicimage &""
						obj("dramaitem")(null)("itemname")	= ""& vItemname &""
						obj("dramaitem")(null)("itemid")	= ""& vItemid &""
						obj("dramaitem")(null)("ampevtname")= "click_dramazoneitem"
						obj("dramaitem")(null)("ampevtpk")= "itemid"

				Next 
			End If 
			
			if jcnt=ubound(arrList,2) Then '// 마지막선언
				Set	json(null) = obj ''배열 처리 따로 해줘야함
				Set obj = Nothing
			End If
		
	 		temp_listidx  = listidx
		Next

		Response.write Replace(toJSON(json),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
