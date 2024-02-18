<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
dim flgDevice: flgDevice="W"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim i, j, sqlStr, arrRows, rstMsg
dim savePath, FileName, refip
Dim idxarr, type1cnt, type2cnt
Dim vTotalCount

vTerm = requestCheckVar(Request("term"),3)

idxarr		= request("idxarr")
type1cnt	= Cint(request("type1cnt"))
type2cnt	= Cint(request("type2cnt"))

If Right(idxarr,1) = "," Then
	idxarr = Left(idxarr, Len(idxarr) - 1)
End If

If Ubound(split(idxarr,","))+1 <> "7" Then
	response.write "<script>alert('not Select Count 7');self.close();</script>"
End If

sqlStr = ""
sqlStr = sqlStr & " SELECT count(*) as cnt FROM db_sitemaster.dbo.tbl_mobile_main_keywordbanner WHERE idx in ("&idxarr&") and keywordtype = '1' and isusing ='Y' "
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	If rsget("cnt") < type1cnt Then
		response.write "<script>alert('[ imageType(1) ] needCount = 3');self.close();</script>"
	ElseIf rsget("cnt") > type1cnt Then
		response.write "<script>alert('[ imageType(1) ] needCount = 3');self.close();</script>"
	End If
End If
rsget.Close

sqlStr = ""
sqlStr = sqlStr & " SELECT count(*) as cnt FROM db_sitemaster.dbo.tbl_mobile_main_keywordbanner WHERE idx in ("&idxarr&") and keywordtype = '2' and isusing ='Y' "
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	If rsget("cnt") < type2cnt Then
		response.write "<script>alert('[ imageType(2) ] needCount = 4');self.close();</script>"
	ElseIf rsget("cnt") > type2cnt Then
		response.write "<script>alert('[ imageType(2) ] needCount = 4');self.close();</script>"
	End If
End If
rsget.Close

'// 생성파일 경로 및 파일명 선언
savePath = server.mappath("/chtml/main/xml/keywordbanner/") + "\"
FileName = "main_keywordbanner.xml"

'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")
if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
    response.end
end if

sqlStr = ""
sqlStr = sqlStr & " select keywordtype, keyword, imagepath, linkpath, imgalt, orderno "
sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_mobile_main_keywordbanner "
sqlStr = sqlStr & " where idx in ("&idxarr&") and isusing = 'Y' "
sqlStr = sqlStr & " ORDER BY orderno ASC, regdate DESC  "
rsget.Open SqlStr, dbget, 1
vTotalCount = rsget.RecordCount
arrRows = rsget.getRows()

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
