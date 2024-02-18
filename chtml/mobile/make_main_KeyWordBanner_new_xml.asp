<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
dim flgDevice: flgDevice="W"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim i, j, arrRows, rstMsg
dim savePath, FileName, refip
dim vTerm, vTerm2, prevDate, sqlDate, vTotalCount , lprevDate
dim sqlStr , FResultCount

vTerm = requestCheckVar(Request("term"),3)

'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")
if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
	response.end
end If

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

	sqlStr = "select count(*) "
	sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_keywordbanner "
	sqlStr = sqlStr + " where isusing='Y'"
	sqlStr = sqlStr + " and convert(varchar(10),StartDate,120) between '" & prevDate &"' and '" & prevDate &"' "

	rsget.Open SqlStr, dbget, 1
	FResultCount = rsget(0)
	rsget.Close

	if (FResultCount<7) then
	    response.write "<script>alert('[" & prevDate & "]일의 적용할 데이터가 [ "& 7-FResultCount &" ] 개가 없습니다.');self.close();</script>"
		response.End
	end If
Next

For j=1 to cInt(vTerm2)
	'// 생성파일 경로 및 파일명 선언
	lprevDate = dateadd("d",(j-1),date)
	sqlDate = "('" & lprevDate & "' between convert(varchar(10),startdate,120) and convert(varchar(10),startdate,120))"

	sqlStr = ""
	sqlStr = sqlStr & " select keywordtype, keyword, imagepath, linkpath, imgalt, orderno "
	sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_mobile_main_keywordbanner "
	sqlStr = sqlStr & " where isusing = 'Y' and (" & sqlDate & ") "
	sqlStr = sqlStr & " ORDER BY orderno ASC, regdate DESC  "

'	response.write  sqlStr
'	response.End

	rsget.Open SqlStr, dbget, 1
	vTotalCount = rsget.RecordCount
	arrRows = rsget.getRows()

	savePath = server.mappath("/chtml/main/xml/keywordbanner") + "\"
	Call CreateDir(savePath,replace(dateadd("d",(j-1),date),"-",""))
	savePath = savePath & replace(dateadd("d",(j-1),date),"-","") & "\"
	FileName = "main_keywordbanner_new.xml"


	dim objXML, objXMLv, blnFileExist, strRst, tFile

	'// 파일 생성
	if vTotalCount>0 then
		Dim fso, delFile
		Set fso = CreateObject("Scripting.FileSystemObject")
		If fso.FileExists(savePath & FileName) Then
			Set delFile = fso.GetFile(savePath & FileName)
				delFile.Delete 
			Set delFile = Nothing
		End If
		Set fso = Nothing

		Set objXML = server.CreateObject("Microsoft.XMLDOM")
			objXML.async = False
			objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
			objXML.appendChild(objXML.createElement("mainPage"))
			Set objXMLv = objXML.createElement("item")
				objXMLv.appendChild(objXML.createElement("keyword0"))
				objXMLv.appendChild(objXML.createElement("imagepath0"))
				objXMLv.appendChild(objXML.createElement("linkpath0"))
				objXMLv.appendChild(objXML.createElement("imgalt0"))

				objXMLv.appendChild(objXML.createElement("keyword1"))
				objXMLv.appendChild(objXML.createElement("imagepath1"))
				objXMLv.appendChild(objXML.createElement("linkpath1"))
				objXMLv.appendChild(objXML.createElement("imgalt1"))

				objXMLv.appendChild(objXML.createElement("keyword2"))
				objXMLv.appendChild(objXML.createElement("imagepath2"))
				objXMLv.appendChild(objXML.createElement("linkpath2"))
				objXMLv.appendChild(objXML.createElement("imgalt2"))

				objXMLv.appendChild(objXML.createElement("keyword3"))
				objXMLv.appendChild(objXML.createElement("imagepath3"))
				objXMLv.appendChild(objXML.createElement("linkpath3"))
				objXMLv.appendChild(objXML.createElement("imgalt3"))

				objXMLv.appendChild(objXML.createElement("keyword4"))
				objXMLv.appendChild(objXML.createElement("imagepath4"))
				objXMLv.appendChild(objXML.createElement("linkpath4"))
				objXMLv.appendChild(objXML.createElement("imgalt4"))

				objXMLv.appendChild(objXML.createElement("keyword5"))
				objXMLv.appendChild(objXML.createElement("imagepath5"))
				objXMLv.appendChild(objXML.createElement("linkpath5"))
				objXMLv.appendChild(objXML.createElement("imgalt5"))

				objXMLv.appendChild(objXML.createElement("keyword6"))
				objXMLv.appendChild(objXML.createElement("imagepath6"))
				objXMLv.appendChild(objXML.createElement("linkpath6"))
				objXMLv.appendChild(objXML.createElement("imgalt6"))

				objXMLv.childNodes(0).text = db2Html(arrRows(1,0))
				objXMLv.childNodes(1).text = db2Html(arrRows(2,0))
				objXMLv.childNodes(2).text = db2Html(arrRows(3,0))
				objXMLv.childNodes(3).text = db2Html(arrRows(4,0))

				objXMLv.childNodes(4).text = db2Html(arrRows(1,1))
				objXMLv.childNodes(5).text = db2Html(arrRows(2,1))
				objXMLv.childNodes(6).text = db2Html(arrRows(3,1))
				objXMLv.childNodes(7).text = db2Html(arrRows(4,1))

				objXMLv.childNodes(8).text = db2Html(arrRows(1,2))
				objXMLv.childNodes(9).text = db2Html(arrRows(2,2))
				objXMLv.childNodes(10).text = db2Html(arrRows(3,2))
				objXMLv.childNodes(11).text = db2Html(arrRows(4,2))

				objXMLv.childNodes(12).text = db2Html(arrRows(1,3))
				objXMLv.childNodes(13).text = db2Html(arrRows(2,3))
				objXMLv.childNodes(14).text = db2Html(arrRows(3,3))
				objXMLv.childNodes(15).text = db2Html(arrRows(4,3))

				objXMLv.childNodes(16).text = db2Html(arrRows(1,4))
				objXMLv.childNodes(17).text = db2Html(arrRows(2,4))
				objXMLv.childNodes(18).text = db2Html(arrRows(3,4))
				objXMLv.childNodes(19).text = db2Html(arrRows(4,4))

				objXMLv.childNodes(20).text = db2Html(arrRows(1,5))
				objXMLv.childNodes(21).text = db2Html(arrRows(2,5))
				objXMLv.childNodes(22).text = db2Html(arrRows(3,5))
				objXMLv.childNodes(23).text = db2Html(arrRows(4,5))

				objXMLv.childNodes(24).text = db2Html(arrRows(1,6))
				objXMLv.childNodes(25).text = db2Html(arrRows(2,6))
				objXMLv.childNodes(26).text = db2Html(arrRows(3,6))
				objXMLv.childNodes(27).text = db2Html(arrRows(4,6))
				objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
		 '-----파일 저장
		  objXML.save(savePath & FileName)
		  rstMsg = rstMsg & "- 파일 [" & FileName & "] 생성 완료\n"
	End If
	rsget.Close

	'// xml 최종 생성 DB-update
	sqlStr = "Update [db_sitemaster].[dbo].tbl_mobile_main_keywordbanner " &_
				" Set xmlregdate =getdate()" &_
				" Where  isusing = 'Y' and (('" & lprevDate & "' between convert(varchar(10),startdate,120) and convert(varchar(10),startdate,120)))  "
	'response.write sqlStr
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
<script language='javascript'>
alert("<%=rstMsg%>");
self.close();
</script>
<body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
