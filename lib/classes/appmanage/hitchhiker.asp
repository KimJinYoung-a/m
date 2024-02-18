<%
'////////////////////////////////////////////////////////////////////////////////////////////////////////////
'//
'// APIs
'//

' 책 목록 얻기
'Function API_GetBookList()
'	API_GetBookList = GetBookListJSON(Factory.Create("Args"))
'End Function

'////////////////////////////////////////////////////////////////////////////////////////////////////////////
'//
'// JSON Functions
'//2013.02.22 진영생성	///책 목록 얻기
CONST APPNAME = "hitchhiker"

Function GetBookListJSON(clienttype, clientver, isDEVIP)
	Dim strSQL, i, obj, NoticeContents

    ''2013/12/16추가
    strSQL = "insert into db_contents.dbo.tbl_app_comLog"& VBCRLF
    strSQL = strSQL & " (appName,clienttype,clientver,refip)"& VBCRLF
    strSQL = strSQL & " values('"&APPNAME&"'"& VBCRLF
    strSQL = strSQL & " ,'"&clienttype&"'"& VBCRLF
    strSQL = strSQL & " ,'"&clientver&"'"& VBCRLF
    strSQL = strSQL & " ,'"&Request.ServerVariables("REMOTE_ADDR")&"'"& VBCRLF
    strSQL = strSQL & " )"& VBCRLF
    dbget.Execute strSQL


	'공지사항 뽑는 쿼리
	strSQL = ""
	strSQL = strSQL & " SELECT top 1 contents " & VBCRLF
	strSQL = strSQL & " FROM db_contents.dbo.tbl_hhiker_notice "
	strSQL = strSQL & " WHERE isusing = 'Y' " & VBCRLF
	strSQL = strSQL & " and getdate() between startdate and enddate " & VBCRLF
	If clienttype = "ios" Then
		strSQL = strSQL & " and assigndevice in ('0', '1') " & VBCRLF
	ElseIf clienttype = "android" Then
		strSQL = strSQL & " and assigndevice in ('0', '2') " & VBCRLF
	Else
		strSQL = strSQL & " and assigndevice in ('0', '2') " & VBCRLF
	End If

	rsget.open strSQL, dbget, 1
	If not rsget.EOF Then
		NoticeContents = rsget("contents")
	End If
	rsget.close

	Set obj = jsObject()
		obj("protocol_ver") = "1"
		obj("device") = ""&clienttype&""
		obj("notice") = ""&NoticeContents&""
        obj("iosappid") = "635127946"           ''2013/04/24 서동석 추가 ''//
        obj("andappid") = "kr.tenbyten.hitchhiker"                    ''2013/04/24 서동석 추가 //kr.tenbyten.hitchhiker (버전업 후 )

    ''버전 2 변경사항 : zipFile 저장소 위치 /app/Documents/ => /app/Library/Caches,  페이스북 URL 추가

	Set obj("updateinfo") = jsObject()
	    if (TRUE) or (Request.ServerVariables("REMOTE_ADDR")="211.206.236.117") then  ''2014/06/25
	        IF (clienttype="ios") then
	            if (cInt(clientver)<8) then
	                obj("updateinfo")("appversion") = "8"
	                obj("updateinfo")("forceupdate") = true
	            else
        	        obj("updateinfo")("appversion") = "2"                '' 로그인 해시 변경 ios 8 and 10  //v8 까지 소스에 2로 밖혀있음
        	        obj("updateinfo")("forceupdate") = False
        	    end if
    	    else 
    	        if (cInt(clientver)<10) then
    		        obj("updateinfo")("appversion") = "10"     
    		        obj("updateinfo")("forceupdate") = true 
    		    else
    		        obj("updateinfo")("appversion") = "2"  
    		        obj("updateinfo")("forceupdate") = False    
    		    end if          
    	    end if
	    else
		    obj("updateinfo")("appversion") = "2"               '' 차후 신규 버전 승인 후 변경  2013/05/28
		    obj("updateinfo")("forceupdate") = False
	    end if
		
		obj("updateinfo")("notice") = "새로운 버전의 앱이 있습니다. 업데이트 하시겠습니까?"
		obj("updateinfo")("download_url") = ""


	'공통배너 뽑는 쿼리
	strSQL = ""
	strSQL = strSQL & " SELECT top 1 bannerImg, clickURL " & VBCRLF
	strSQL = strSQL & " FROM db_contents.dbo.tbl_hhiker_bannerImg " & VBCRLF
	strSQL = strSQL & " WHERE isusing = 'Y' " & VBCRLF
	strSQL = strSQL & " and getdate() between startdate and enddate " & VBCRLF
	strSQL = strSQL & " ORDER by idx desc " & VBCRLF
	rsget.Open strSQL,dbget,1
	If not rsget.EOF Then
 	Set obj("bannerInfo") = jsObject()
		obj("bannerInfo")("img") = rsget("bannerImg")
		obj("bannerInfo")("clickURL") = rsget("clickURL")
	End If
	rsget.Close

	'// 책 목록만 가져오는 함수 별도 생성(2014-06-20, skyer9)
	strSQL = ""
	strSQL = strSQL & " SELECT A.*,B.* " & VBCRLF
	strSQL = strSQL & " FROM " & VBCRLF
	strSQL = strSQL & " ( " & VBCRLF
	strSQL = strSQL & " 	SELECT vol,Max(rev) as lastREV " & VBCRLF
	strSQL = strSQL & " 	FROM db_contents.dbo.tbl_hhiker_book " & VBCRLF
	strSQL = strSQL & " 	WHERE 1=1 " & VBCRLF
	If isDEVIP = True Then
		strSQL = strSQL & " 	and openstate>=3 " & VBCRLF
	ElseIf isDEVIP = False Then
		strSQL = strSQL & " 	and openstate=7 " & VBCRLF
	End If
	strSQL = strSQL & " 	and openstate<9 " & VBCRLF
	strSQL = strSQL & " 	and opendate<getdate() " & VBCRLF
	strSQL = strSQL & " 	GROUP BY vol " & VBCRLF
	strSQL = strSQL & " ) as A " & VBCRLF
	strSQL = strSQL & " INNER JOIN db_contents.dbo.tbl_hhiker_book B " & VBCRLF
	strSQL = strSQL & " ON A.vol=B.vol " & VBCRLF
	strSQL = strSQL & " and A.lastREV=B.rev " & VBCRLF
	strSQL = strSQL & " ORDER by A.vol DESC " & VBCRLF
	rsget.Open strSQL,dbget,1
	Set obj("booklist") = jsArray()
	i = 0
	If not rsget.EOF Then
		Do until rsget.EOF
			Set obj("booklist")(i) = jsObject()
				obj("booklist")(i)("idx") 			= rsget("idx")
				obj("booklist")(i)("vol") 			= rsget("vol")
				obj("booklist")(i)("rev") 			= rsget("rev")
				obj("booklist")(i)("openstate") 	= rsget("openstate")
				obj("booklist")(i)("mtitlename")	= rsget("mtitlename")
				obj("booklist")(i)("mimgurl") 		= rsget("mimgurl")
				obj("booklist")(i)("mimgurl2") 		= rsget("mimgurl2")
				obj("booklist")(i)("mimgurl3")	 	= rsget("iPhoneImgURL")
				obj("booklist")(i)("zipurl") 		= rsget("zipurl")
				obj("booklist")(i)("reguserid") 	= rsget("reguserid")
				obj("booklist")(i)("regdate") 		= Left(rsget("regdate"),10)
			rsget.movenext
			i = i + 1
		Loop
	End if
	rsget.Close
	GetBookListJSON = obj.Flush
End Function

Function GetBookListOnlyJSON(clienttype, clientver, isDEVIP)
	Dim strSQL, i, obj, NoticeContents

    strSQL = "insert into db_contents.dbo.tbl_app_comLog"& VBCRLF
    strSQL = strSQL & " (appName,clienttype,clientver,refip)"& VBCRLF
    strSQL = strSQL & " values('"&APPNAME&"'"& VBCRLF
    strSQL = strSQL & " ,'"&clienttype&"'"& VBCRLF
    strSQL = strSQL & " ,'"&clientver&"'"& VBCRLF
    strSQL = strSQL & " ,'"&Request.ServerVariables("REMOTE_ADDR")&"'"& VBCRLF
    strSQL = strSQL & " )"& VBCRLF
    dbget.Execute strSQL

	Set obj = jsObject()

	strSQL = " SELECT A.*,B.* " & VBCRLF
	strSQL = strSQL & " FROM " & VBCRLF
	strSQL = strSQL & " ( " & VBCRLF
	strSQL = strSQL & " 	SELECT vol,Max(rev) as lastREV " & VBCRLF
	strSQL = strSQL & " 	FROM db_contents.dbo.tbl_hhiker_book " & VBCRLF
	strSQL = strSQL & " 	WHERE 1=1 " & VBCRLF
	If isDEVIP = True Then
		strSQL = strSQL & " 	and openstate>=3 " & VBCRLF
	ElseIf isDEVIP = False Then
		strSQL = strSQL & " 	and openstate=7 " & VBCRLF
	End If
	strSQL = strSQL & " 	and openstate<9 " & VBCRLF
	strSQL = strSQL & " 	and opendate<getdate() " & VBCRLF
	strSQL = strSQL & " 	GROUP BY vol " & VBCRLF
	strSQL = strSQL & " ) as A " & VBCRLF
	strSQL = strSQL & " INNER JOIN db_contents.dbo.tbl_hhiker_book B " & VBCRLF
	strSQL = strSQL & " ON A.vol=B.vol " & VBCRLF
	strSQL = strSQL & " and A.lastREV=B.rev " & VBCRLF
	strSQL = strSQL & " ORDER by A.vol DESC " & VBCRLF
	rsget.Open strSQL,dbget,1
	Set obj("booklist") = jsArray()
	i = 0
	If not rsget.EOF Then
		Do until rsget.EOF
			Set obj("booklist")(i) = jsObject()
				obj("booklist")(i)("idx") 			= rsget("idx")
				obj("booklist")(i)("vol") 			= rsget("vol")
				obj("booklist")(i)("rev") 			= rsget("rev")
				obj("booklist")(i)("openstate") 	= rsget("openstate")
				obj("booklist")(i)("mtitlename")	= rsget("mtitlename")
				obj("booklist")(i)("mimgurl") 		= rsget("mimgurl")
				obj("booklist")(i)("mimgurl2") 		= rsget("mimgurl2")
				obj("booklist")(i)("mimgurl3")	 	= rsget("iPhoneImgURL")
				obj("booklist")(i)("zipurl") 		= rsget("zipurl")
				obj("booklist")(i)("reguserid") 	= rsget("reguserid")
				obj("booklist")(i)("regdate") 		= Left(rsget("regdate"),10)
			rsget.movenext
			i = i + 1
		Loop
	End if
	rsget.Close
	GetBookListOnlyJSON = obj.Flush

End Function

'///히치하이커 BGM, BGIMAGE얻기
Function GetBookBGMListJSON(vol, device, isDEVIP)
	Dim strSQL, i, obj, strSQL2

	strSQL = ""
	strSQL = strSQL & " SELECT D.midx, D.ctgbnname, D.ctSeq, D.orgfileName"
	If (device = "" or device = "ios") Then                                                                         ''2013/05/28 수정
	    device = "ios"
	    strSQL = strSQL & ", D.contURL"
	ELSE
	    device = "android"
	    strSQL = strSQL & ", replace(replace(D.contURL,'http://','rtsp://'),'/playlist.m3u8','') as contURL"
    END If
	strSQL = strSQL & ", D.musicTitle, D.musician, D.linkURL, D.isusing, D.orderNo, " & VBCRLF
	strSQL = strSQL & " Case WHEN isNull(D.device, '') = '' OR D.device = 'ios' THEN 'ios'  " & VBCRLF
	strSQL = strSQL & " Else D.device End as device  " & VBCRLF
	strSQL = strSQL & " FROM db_contents.dbo.tbl_hhiker_book as B " & VBCRLF
	strSQL = strSQL & " Inner JOIN db_contents.dbo.tbl_hhiker_book_detail as D ON B.idx = D.midx " & VBCRLF
	strSQL = strSQL & " WHERE B.vol = '"&vol&"' " & VBCRLF
	If isDEVIP = True Then
		strSQL = strSQL & " 	and B.openstate>=3 " & VBCRLF
	ElseIf isDEVIP = False Then
		strSQL = strSQL & " 	and B.openstate=7 " & VBCRLF
	End If
	strSQL = strSQL & " and D.isusing = 'Y' " & VBCRLF
	strSQL = strSQL & " and D.ctgbnname = 'bgSound' " & VBCRLF
'	If device = "" or device = "ios" Then
'		strSQL = strSQL & " and (D.device = 'ios' OR isNull(D.device, '') = '')  " & VBCRLF
'	Else
'		strSQL = strSQL & " and D.device = 'android' " & VBCRLF
'	End If
	strSQL = strSQL & " ORDER BY D.ctgbnname ASC, D.orderNo ASC "
	rsget.Open strSQL,dbget,1
	i = 0
	Set obj = jsObject()
	Set obj("bgSound") = jsArray()
	Set obj("bgImage") = jsArray()
	If not rsget.EOF Then
		Do until rsget.EOF
			Set obj("bgSound")(i) = jsObject()
				obj("bgSound")(i)("midx") 		= rsget("midx")
				obj("bgSound")(i)("ctgbnname") 	= rsget("ctgbnname")
				obj("bgSound")(i)("ctSeq") 		= rsget("ctSeq")
				obj("bgSound")(i)("orgfileName")= rsget("orgfileName")
				obj("bgSound")(i)("contURL")	= rsget("contURL")
				obj("bgSound")(i)("musicTitle") = rsget("musicTitle")
				obj("bgSound")(i)("musician") 	= rsget("musician")
				obj("bgSound")(i)("isusing") 	= rsget("isusing")
				obj("bgSound")(i)("orderNo") 	= rsget("orderNo")
				obj("bgSound")(i)("clienttype")	= device '''trim(rsget("device"))   ''2013/05/28 수정
			rsget.movenext
			i = i + 1
		Loop
	End If
	rsget.Close

    strSQL2 = ""
	strSQL2 = strSQL2 & " SELECT D.midx, D.ctgbnname, D.ctSeq, D.orgfileName"
	strSQL2 = strSQL2 & ", D.contURL"
	strSQL2 = strSQL2 & ", D.musicTitle, D.musician, D.linkURL, D.isusing, D.orderNo, " & VBCRLF
	strSQL2 = strSQL2 & " Case WHEN isNull(D.device, '') = '' OR D.device = 'ios' THEN 'ios'  " & VBCRLF
	strSQL2 = strSQL2 & " Else D.device End as device  " & VBCRLF
	strSQL2 = strSQL2 & " FROM db_contents.dbo.tbl_hhiker_book as B " & VBCRLF
	strSQL2 = strSQL2 & " Inner JOIN db_contents.dbo.tbl_hhiker_book_detail as D ON B.idx = D.midx " & VBCRLF
	strSQL2 = strSQL2 & " WHERE B.vol = '"&vol&"' " & VBCRLF
	If isDEVIP = True Then
		strSQL = strSQL & " 	and B.openstate>=3 " & VBCRLF
	ElseIf isDEVIP = False Then
		strSQL = strSQL & " 	and B.openstate=7 " & VBCRLF
	End If
	strSQL2 = strSQL2 & " and D.isusing = 'Y' " & VBCRLF
	strSQL2 = strSQL2 & " and D.ctgbnname = 'bgImage' " & VBCRLF
	strSQL2 = strSQL2 & " ORDER BY D.ctgbnname ASC, D.orderNo ASC "
	rsget.Open strSQL2,dbget,1
	i = 0
	If not rsget.EOF Then
		Do until rsget.EOF
			Set obj("bgImage")(i) = jsObject()
				obj("bgImage")(i)("midx") 		= rsget("midx")
				obj("bgImage")(i)("ctgbnname") 	= rsget("ctgbnname")
				obj("bgImage")(i)("ctSeq") 		= rsget("ctSeq")
				obj("bgImage")(i)("orgfileName")= rsget("orgfileName")
				obj("bgImage")(i)("contURL")	= rsget("contURL")
				obj("bgImage")(i)("linkURL") 	= rsget("linkURL")
				obj("bgImage")(i)("isusing") 	= rsget("isusing")
				obj("bgImage")(i)("orderNo") 	= rsget("orderNo")
			rsget.movenext
			i = i + 1
		Loop
	End If
	rsget.Close
	GetBookBGMListJSON = obj.Flush
End Function

Function GetPw64(id, pw)
	Dim strSQL, i, obj, strSQL2
	strSQL = ""
	strSQL = strSQL & " SELECT userid, Enc_userpass64 FROM db_user.dbo.tbl_logindata where userid = '"&id&"'  " & VBCRLF
	rsget.Open strSQL,dbget,1
	If not rsget.EOF Then
		GetPw64 = rsget("Enc_userpass64")
	End If
	rsget.close
End Function

''사용중지
'Function GetPw(id, pw)
'	Dim strSQL, i, obj, strSQL2
'	strSQL = ""
'	strSQL = strSQL & " SELECT userid, Enc_userpass FROM db_user.dbo.tbl_logindata where userid = '"&id&"'  " & VBCRLF
'	rsget.Open strSQL,dbget,1
'	If not rsget.EOF Then
'		GetPw = rsget("Enc_userpass")
'	End If
'	rsget.close
'End Function


' 책 목록 얻기
Function GetBookListJSON_old(oArgs)
	Dim oBookListRS : Set oBookListRS = GetBookListRS(Factory.Create("Args").SetArgs(Array( _
		"pageSize", 10, _
		"pageNum", 1 _
	)))

	Dim oBookList : Set oBookList = Server.CreateObject("System.Collections.ArrayList")

	Do Until oBookListRS.EOF
		Dim sBookId : sBookId = oBookListRS("idx")
		Dim sVol : sVol = oBookListRS("vol")
		Dim sRev : sRev = oBookListRS("rev")

		Dim oBook : Set oBook = jsObject()
		oBook("bookid") = sBookId
		oBook("vol") = sVol
		oBook("rev") = sRev
		oBookList.Add oBook

		oBookListRS.MoveNext
	Loop

	GetBookListJSON_old = jsArray().RenderArray(oBookList.ToArray, 1, "")
End Function



'////////////////////////////////////////////////////////////////////////////////////////////////////////////
'//
'// RS Functions
'//

' 책 개수 얻기
Function GetNumBookList(oArgs)
	Dim oRS : Set oRS = GetRsFromArgs(oArgs)

	GetNumBookList = GetTableRows(oRS, "db_contents.dbo.tbl_hhiker_book")
End Function

' 책 목록 얻기
Function GetBookListRS(oTempArgs)
	Dim oArgs : Set oArgs = Factory.Create("Args").SetArgs(Array( _
		"pageSize", 20, _
		"pageNum", 1 _
	))
	oArgs.SetArgs(oTempArgs)

	Dim oRS : Set oRS = GetRsFromArgs(oArgs)

	Dim nPageSize : nPageSize = oArgs.Item("pageSize")
	Dim nPageNum : nPageNum =  IF_(oArgs.Item("pageNum") > 1, oArgs.Item("pageNum"), 1)
	Dim nFirstIndex : nFirstIndex = (nPageNum - 1) * nPageSize
	Dim nLastIndex : nLastIndex = nPageNum * nPageSize + 1

	Dim sSQL : sSQL = "SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY idx DESC) AS ROWINDEX, * FROM db_contents.dbo.tbl_hhiker_book) AS SUB WHERE SUB.ROWINDEX > " & nFirstIndex & " AND SUB.ROWINDEX < " & nLastIndex

	oRS.open sSQL, dbget, 0

	Set GetBookListRS = oRS
End Function
%>
