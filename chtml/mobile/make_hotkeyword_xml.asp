<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<%
'#######################################################
' PageName : make_hotkeyword_xml.asp
' Discription : 사이트 메인 페이지용 XML생성 (모바일)
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/main/hotkeyword.asp" -->
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
dim oHotkeyword
dim vTerm, vTerm2, prevDate, sqlDate, vTotalCount , lprevDate , sumDate
dim sqlStr

vTerm = requestCheckVar(Request("term"),3)
vTerm2 = vTerm
If vTerm2 = "" Then vTerm2 = 1
If vTerm <> "" Then
	vTerm = DateAdd("d",date(),vTerm-1)
End IF
sqlDate = ""

''// 최소 제한수 검사
'for j=1 to cInt(vTerm2)
'	'해당 날짜 접수
'	prevDate = dateadd("d",(j-1),date)
'	sqlDate = sqlDate & "('" & prevDate & "' between startdate and enddate)"
'	if j<cInt(vTerm2) then sqlDate = sqlDate & " or "
'
'	set oHotkeyword = New CMainbanner
'	oHotkeyword.FPageSize		= 20
'	oHotkeyword.FCurrPage		= 1
'	oHotkeyword.Fsdt			= prevDate
'	oHotkeyword.GetContentsList()
'
'	if (oHotkeyword.FResultCount<1) then
'	    response.write "<script>alert('[" & prevDate & "]일의 적용할 데이터가 없습니다.');self.close();</script>"
'		response.End
'	elseif (oHotkeyword.FResultCount<(3)) then
'		response.write "<script>alert('[" & prevDate & "]일 적용에 필요한 데이터가 부족합니다.\n\n(※ 최소 3 건 필요. 현재 " & oHotkeyword.FResultCount & "건 등록됨)');self.close();</script>"
'		response.end
'	end if
'
'	
'	set oHotkeyword = Nothing
'Next

For j=1 to cInt(vTerm2)
	'// 메인 데이터 접수
	sqlStr = "select top 20 t.* , i.itemname , i.basicimage "
	sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_today_hotkeyword as t "
	sqlStr = sqlStr + " left outer join db_item.dbo.tbl_item as i on t.itemid = i.itemid and i.itemid <> 0 "
	sqlStr = sqlStr & " where t.isusing = 'Y' "
	sqlStr = sqlStr & "		and t.enddate >= getdate() "
	sqlStr = sqlStr & " order by t.startdate asc , t.sortnum asc "

	rsget.Open SqlStr, dbget, 1
	vTotalCount = rsget.RecordCount

	'// 생성파일 경로 및 파일명 선언
	savePath = server.mappath("/chtml/main/xml/main_banner/") + "\"
	FileName = "main_hotkeyword.xml"

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

			objXMLv.appendChild(objXML.createElement("kwimg"))
			objXMLv.appendChild(objXML.createElement("kword"))
			objXMLv.appendChild(objXML.createElement("ktitle"))
			objXMLv.appendChild(objXML.createElement("kcontents"))
			objXMLv.appendChild(objXML.createElement("kurl_mo"))
			objXMLv.appendChild(objXML.createElement("kurl_app"))
			objXMLv.appendChild(objXML.createElement("appdiv"))
			objXMLv.appendChild(objXML.createElement("appcate"))
			objXMLv.appendChild(objXML.createElement("startdate"))
			objXMLv.appendChild(objXML.createElement("enddate"))
			objXMLv.appendChild(objXML.createElement("itemid"))
			objXMLv.appendChild(objXML.createElement("itemname"))
			objXMLv.appendChild(objXML.createElement("basicimage"))



			objXMLv.childNodes(0).text = staticImgUrl & "/mobile/hotkeyword" + db2Html(rsget("kwimg"))
			objXMLv.childNodes(1).text = db2Html(rsget("kword"))
			objXMLv.childNodes(2).text = db2Html(rsget("ktitle"))
			objXMLv.childNodes(3).text = db2Html(rsget("kcontents"))
			objXMLv.childNodes(4).text = db2Html(rsget("kurl_mo"))
			objXMLv.childNodes(5).text = db2Html(rsget("kurl_app"))
			objXMLv.childNodes(6).text = db2Html(rsget("appdiv"))
			objXMLv.childNodes(7).text = db2Html(rsget("appcate"))
			objXMLv.childNodes(8).text = rsget("startdate")
			objXMLv.childNodes(9).text = rsget("enddate")
			objXMLv.childNodes(10).text = db2Html(rsget("itemid"))
			objXMLv.childNodes(11).text = db2Html(rsget("itemname"))
			objXMLv.childNodes(12).text = webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(rsget("itemid"))) + "/" + db2Html(rsget("basicimage"))


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
	sqlStr = "Update [db_sitemaster].[dbo].tbl_mobile_main_today_hotkeyword " &_
				" Set xmlregdate =getdate()" &_
				" Where isusing = 'Y' and enddate >= getdate() "
	'response.write sqlStr
	'response.end
	dbget.Execute(sqlStr)
Next 

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