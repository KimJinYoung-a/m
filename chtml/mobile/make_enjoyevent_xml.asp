<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' PageName : make_enjoyevent_xml.asp
' Discription : 사이트 메인 페이지용 XML생성 (모바일)
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/main/main_enjoyeventCls.asp" -->
<%
'' 관리자 확정시 Data 작성. 

dim i, j
dim poscode
dim savePath, FileName, refip

'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")

'if (InStr(refip,"10x10.co.kr")<1) then
'	response.write "not valid Referer"
'    response.end
'end if
'
dim oenjoyevent
dim vTerm, vTerm2, prevDate, sqlDate, vTotalCount , lprevDate , sumDate
dim sqlStr

vTerm = requestCheckVar(Request("term"),3)
vTerm2 = vTerm
If vTerm2 = "" Then vTerm2 = 1
If vTerm <> "" Then
	vTerm = DateAdd("d",date(),vTerm-1)
End IF
sqlDate = ""

'// 최소 제한수 검사
for j=1 to cInt(vTerm2)
	'해당 날짜 접수
	prevDate = dateadd("d",(j-1),date)
	sqlDate = sqlDate & "('" & prevDate & "' between startdate and enddate)"
	if j<cInt(vTerm2) then sqlDate = sqlDate & " or "

	set oenjoyevent = New CMainbanner
	oenjoyevent.FPageSize		= 20
	oenjoyevent.FCurrPage		= 1
	oenjoyevent.Fsdt			= prevDate
	oenjoyevent.GetContentsList()

	if (oenjoyevent.FResultCount<1) then
	    response.write "<script>alert('[" & prevDate & "]일의 적용할 데이터가 없습니다.');self.close();</script>"
		response.end
	end If
	
	set oenjoyevent = Nothing
Next


For j=1 to cInt(vTerm2)
	lprevDate = dateadd("d",(j-1),date)
	sumDate = sumDate &"//"& lprevDate & "\n"
	sqlDate = "('" & lprevDate & "' between convert(varchar(10),startdate,120) and convert(varchar(10),enddate,120))"
	'// 메인 데이터 접수
	sqlStr = "select * from [db_sitemaster].[dbo].tbl_mobile_main_enjoyevent"
	sqlStr = sqlStr & " where isusing = 'Y' "
	sqlStr = sqlStr & "		and (" & sqlDate & ") "
	sqlStr = sqlStr & " order by idx desc "

	'response.write sqlStr
	'response.End

	rsget.Open SqlStr, dbget, 1
	vTotalCount = rsget.RecordCount

	'// 생성파일 경로 및 파일명 선언
	savePath = server.mappath("/chtml/main/xml/enjoyevent") + "\"
	Call CreateDir(savePath,replace(dateadd("d",(j-1),date),"-",""))
	savePath = savePath & replace(dateadd("d",(j-1),date),"-","") & "\"
	FileName = "main_enjoyevent_"&lprevDate&".xml"

	dim objXML, objXMLv, blnFileExist

	'// 파일 생성
	if vTotalCount>0 then
		 Set objXML = server.CreateObject("Microsoft.XMLDOM")
		 objXML.async = False

		'// 기존 파일 삭제
		Dim fso, delFile
		Set fso = CreateObject("Scripting.FileSystemObject")
		if fso.FileExists(savePath & FileName) then
			Set delFile = fso.GetFile(savePath & FileName)
			delFile.Delete 
			set delFile = Nothing
		end if
		set fso = Nothing
		

		 '----- XML 해더 생성
		  objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
		  objXML.appendChild(objXML.createElement("mainPage"))
		 
		 '-----프로세스 시작
		Do Until rsget.EOF
			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("img1"))
			objXMLv.appendChild(objXML.createElement("img2"))
			objXMLv.appendChild(objXML.createElement("img3"))
			objXMLv.appendChild(objXML.createElement("img4"))
			objXMLv.appendChild(objXML.createElement("img1alt"))
			objXMLv.appendChild(objXML.createElement("img2alt"))
			objXMLv.appendChild(objXML.createElement("img3alt"))
			objXMLv.appendChild(objXML.createElement("img4alt"))
			objXMLv.appendChild(objXML.createElement("img1url"))
			objXMLv.appendChild(objXML.createElement("img2url"))
			objXMLv.appendChild(objXML.createElement("img3url"))
			objXMLv.appendChild(objXML.createElement("img4url"))

			objXMLv.appendChild(objXML.createElement("img1text"))
			objXMLv.appendChild(objXML.createElement("img2text"))
			objXMLv.appendChild(objXML.createElement("img3text"))
			objXMLv.appendChild(objXML.createElement("img4text"))

			objXMLv.appendChild(objXML.createElement("img1sale"))
			objXMLv.appendChild(objXML.createElement("img2sale"))
			objXMLv.appendChild(objXML.createElement("img3sale"))
			objXMLv.appendChild(objXML.createElement("img4sale"))

			objXMLv.appendChild(objXML.createElement("img1stdate"))
			objXMLv.appendChild(objXML.createElement("img2stdate"))
			objXMLv.appendChild(objXML.createElement("img3stdate"))
			objXMLv.appendChild(objXML.createElement("img4stdate"))

			objXMLv.appendChild(objXML.createElement("img1eddate"))
			objXMLv.appendChild(objXML.createElement("img2eddate"))
			objXMLv.appendChild(objXML.createElement("img3eddate"))
			objXMLv.appendChild(objXML.createElement("img4eddate"))

			objXMLv.appendChild(objXML.createElement("startdate"))
			objXMLv.appendChild(objXML.createElement("enddate"))

			objXMLv.appendChild(objXML.createElement("img1sc"))
			objXMLv.appendChild(objXML.createElement("img2sc"))
			objXMLv.appendChild(objXML.createElement("img3sc"))
			objXMLv.appendChild(objXML.createElement("img4sc"))

			objXMLv.childNodes(0).text = staticImgUrl & "/mobile/enjoyevent" + db2Html(rsget("img1"))
			objXMLv.childNodes(1).text = staticImgUrl & "/mobile/enjoyevent" + db2Html(rsget("img2"))
			objXMLv.childNodes(2).text = staticImgUrl & "/mobile/enjoyevent" + db2Html(rsget("img3"))
			objXMLv.childNodes(3).text = staticImgUrl & "/mobile/enjoyevent" + db2Html(rsget("img4"))
			objXMLv.childNodes(4).text = db2Html(rsget("img1alt"))
			objXMLv.childNodes(5).text = db2Html(rsget("img2alt"))
			objXMLv.childNodes(6).text = db2Html(rsget("img3alt"))
			objXMLv.childNodes(7).text = db2Html(rsget("img4alt"))
			objXMLv.childNodes(8).text = Replace(db2Html(rsget("img1url")),"&","%26")
			objXMLv.childNodes(9).text = Replace(db2Html(rsget("img2url")),"&","%26")
			objXMLv.childNodes(10).text = Replace(db2Html(rsget("img3url")),"&","%26")
			objXMLv.childNodes(11).text = Replace(db2Html(rsget("img4url")),"&","%26")

			objXMLv.childNodes(12).text = db2Html(rsget("img1text"))
			objXMLv.childNodes(13).text = db2Html(rsget("img2text"))
			objXMLv.childNodes(14).text = db2Html(rsget("img3text"))
			objXMLv.childNodes(15).text = db2Html(rsget("img4text"))

			objXMLv.childNodes(16).text = db2Html(rsget("img1sale"))
			objXMLv.childNodes(17).text = db2Html(rsget("img2sale"))
			objXMLv.childNodes(18).text = db2Html(rsget("img3sale"))
			objXMLv.childNodes(19).text = db2Html(rsget("img4sale"))

			objXMLv.childNodes(20).text = Replace(Left(rsget("img1stdate"),10),"-",",")
			objXMLv.childNodes(21).text = Replace(Left(rsget("img2stdate"),10),"-",",")
			objXMLv.childNodes(22).text = Replace(Left(rsget("img3stdate"),10),"-",",")
			objXMLv.childNodes(23).text = Replace(Left(rsget("img4stdate"),10),"-",",")

			objXMLv.childNodes(24).text = Replace(Left(rsget("img1eddate"),10),"-",",")
			objXMLv.childNodes(25).text = Replace(Left(rsget("img2eddate"),10),"-",",")
			objXMLv.childNodes(26).text = Replace(Left(rsget("img3eddate"),10),"-",",")
			objXMLv.childNodes(27).text = Replace(Left(rsget("img4eddate"),10),"-",",")

			objXMLv.childNodes(28).text = Replace(Left(rsget("startdate"),10),"-",",")
			objXMLv.childNodes(29).text = Replace(Left(rsget("enddate"),10),"-",",")

			objXMLv.childNodes(30).text = db2Html(rsget("img1sc"))
			objXMLv.childNodes(31).text = db2Html(rsget("img2sc"))
			objXMLv.childNodes(32).text = db2Html(rsget("img3sc"))
			objXMLv.childNodes(33).text = db2Html(rsget("img4sc"))


			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
			rsget.MoveNext
		Loop
		 '-----파일 저장
		  objXML.save(savePath & FileName)

		 '-----객체 해제
		 Set objXML = Nothing
	end if

	rsget.Close

	'// xml 최종 생성 DB-update
	sqlStr = "Update [db_sitemaster].[dbo].tbl_mobile_main_enjoyevent " &_
				" Set xmlregdate =getdate()" &_
				" Where  isusing = 'Y' and (('" & lprevDate & "' between convert(varchar(10),startdate,120) and convert(varchar(10),startdate,120)))  "
	'response.write sqlStr
	'response.end
	dbget.Execute(sqlStr)
Next 

Sub CreateDir(defaultpath, subpath)
	dim fso

	set fso = server.createobject("Scripting.fileSystemObject")
	if not fso.FolderExists(defaultpath) Then
		fso.createfolder(defaultpath)
	end if

	if not fso.FolderExists(defaultpath + "\" + subpath) Then
		fso.createfolder(defaultpath + "\" + subpath)
	end if
	set fso = Nothing
end Sub

%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<title>텐바이텐 메인페이지 생성기</title>
</head>
<body>
<script>
alert("<%=sumDate%>생성완료");
self.close();
</script>
<body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->