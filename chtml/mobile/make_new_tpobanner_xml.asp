<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' PageName : make_tpobanner_xml.asp
' Discription : 사이트 메인 페이지용 XML생성 (모바일)
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/main/main_tpobannerCls.asp"-->
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
dim otpobanner
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

	set otpobanner = New CMainbanner
	otpobanner.FPageSize		= 20
	otpobanner.FCurrPage		= 1
	otpobanner.Fsdt				= prevDate
	otpobanner.GetContentsList()

	if (otpobanner.FResultCount<1) then
	    response.write "<script>alert('[" & prevDate & "]일의 적용할 데이터가 없습니다.');self.close();</script>"
		response.end
	end If
	
	set otpobanner = Nothing
Next


For j=1 to cInt(vTerm2)
	lprevDate = dateadd("d",(j-1),date)
	sumDate = sumDate &"//"& lprevDate & "\n"
	sqlDate = "('" & lprevDate & "' between convert(varchar(10),startdate,120) and convert(varchar(10),enddate,120))"
	'// 메인 데이터 접수
	sqlStr = "select * from [db_sitemaster].[dbo].tbl_mobile_main_tpobanner"
	sqlStr = sqlStr & " where isusing = 'Y' "
	sqlStr = sqlStr & "		and (" & sqlDate & ") "
	sqlStr = sqlStr & " order by sortnum asc, idx desc "

	'response.write sqlStr
	'response.End

	rsget.Open SqlStr, dbget, 1
	vTotalCount = rsget.RecordCount

	'// 생성파일 경로 및 파일명 선언
	savePath = server.mappath("/chtml/main/xml/tpobanner") + "\"
	Call CreateDir(savePath,replace(dateadd("d",(j-1),date),"-",""))
	savePath = savePath & replace(dateadd("d",(j-1),date),"-","") & "\"
	FileName = "main_tpobanner_"&lprevDate&".xml"

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

			objXMLv.appendChild(objXML.createElement("bgimg"))
			objXMLv.appendChild(objXML.createElement("limg"))
			objXMLv.appendChild(objXML.createElement("rimg"))
			objXMLv.appendChild(objXML.createElement("lalt"))
			objXMLv.appendChild(objXML.createElement("ralt"))
			objXMLv.appendChild(objXML.createElement("lurl"))
			objXMLv.appendChild(objXML.createElement("rurl"))
			objXMLv.appendChild(objXML.createElement("startdate"))
			objXMLv.appendChild(objXML.createElement("enddate"))
			objXMLv.appendChild(objXML.createElement("bgalt"))
			objXMLv.appendChild(objXML.createElement("bgurl"))

			objXMLv.childNodes(0).text = staticImgUrl & "/mobile/tpobanner" + db2Html(rsget("bgimg"))
			objXMLv.childNodes(1).text = staticImgUrl & "/mobile/tpobanner" + db2Html(rsget("limg"))
			objXMLv.childNodes(2).text = staticImgUrl & "/mobile/tpobanner" + db2Html(rsget("rimg"))
			objXMLv.childNodes(3).text = db2Html(rsget("lalt"))
			objXMLv.childNodes(4).text = db2Html(rsget("ralt"))
			objXMLv.childNodes(5).text = Replace(db2Html(rsget("lurl")),"&","%26")
			objXMLv.childNodes(6).text = Replace(db2Html(rsget("rurl")),"&","%26")
			objXMLv.childNodes(7).text = Replace(Left(rsget("startdate"),10),"-",",")
			objXMLv.childNodes(8).text = Replace(Left(rsget("enddate"),10),"-",",")
			objXMLv.childNodes(9).text = Replace(db2Html(rsget("bgalt")),"&","%26")
			objXMLv.childNodes(10).text = Replace(db2Html(rsget("bgurl")),"&","%26")

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
	sqlStr = "Update [db_sitemaster].[dbo].tbl_mobile_main_tpobanner " &_
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