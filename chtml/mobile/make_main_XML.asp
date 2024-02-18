<%@ codepage="65001" language="VBScript" %>
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
<!-- #include virtual="/lib/classes/main/main_contents_managecls.asp" -->

<%
'' 관리자 확정시 Data 작성. 

dim i, j
dim poscode, rstMsg
dim savePath, FileName, refip

poscode = requestCheckVar(Request("poscode"),32)

'// 생성파일 경로 및 파일명 선언
savePath = server.mappath("/chtml/main/xml/main_banner/") + "\"
FileName = "main_" & CStr(poscode) & ".xml"

'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")

if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
    response.end
end if

if (Len(poscode)<1) then
	response.write "not valid cd"
	response.end
end if


dim ocontents, ocontentsCode
dim vTerm, vTerm2, prevDate, sqlDate, vTotalCount
dim sqlStr

vTerm = requestCheckVar(Request("term"),3)
vTerm2 = vTerm
If vTerm2 = "" Then vTerm2 = 1
If vTerm <> "" Then
	vTerm = DateAdd("d",date(),vTerm-1)
End IF
sqlDate = ""

'// 적용코드 확인
set ocontentsCode = new CMainContentsCode
ocontentsCode.FRectPoscode = poscode
ocontentsCode.GetOneContentsCode

if (ocontentsCode.FResultCount<1) then
    response.write "<script language=javascript>alert('not poscode');self.close();</script>"
	response.end
end if

If ocontentsCode.FOneItem.Ffixtype <> "R" Then
	'// 최소 제한수 검사
	for j=1 to cInt(vTerm2)
		'해당 날짜 접수
		prevDate = dateadd("d",(j-1),date)
		sqlDate = sqlDate & "('" & prevDate & "' between startdate and enddate)"
		if j<cInt(vTerm2) then sqlDate = sqlDate & " or "

		set ocontents = New CMainContents
		ocontents.FRectPoscode = poscode
		ocontents.FPageSize = ocontentsCode.FOneItem.FuseSet
		ocontents.frectorderidx = "main"
		ocontents.FRectSelDate = prevDate
		ocontents.GetMainContentsValidList

		if (ocontents.FResultCount<1) then
			response.write "<script language=javascript>alert('[" & prevDate & "]일의 적용할 데이터가 없습니다.');self.close();</script>"
			response.end
		elseif (ocontents.FResultCount<(ocontentsCode.FOneItem.FuseSet)) then
			response.write "<script language=javascript>alert('[" & prevDate & "]일 적용에 필요한 데이터가 부족합니다.\n\n(※ 최소 " & (ocontentsCode.FOneItem.FuseSet) & "건 필요. 현재 " & ocontents.FResultCount & "건 등록됨)');self.close();</script>"
			response.end
		end if

		set ocontents = Nothing
	Next
End If 

'// 메인 데이터 접수
If ocontentsCode.FOneItem.Ffixtype = "D" Then	'### 일별등록
	sqlStr = "select * from [db_sitemaster].[dbo].tbl_mobile_mainCont"
	sqlStr = sqlStr & " where poscode = " & poscode & " and isusing = 'Y' and isnull(imageurl,'') <> '' "
	sqlStr = sqlStr & "		and (" & sqlDate & ") "
	sqlStr = sqlStr & " order by orderidx asc, idx desc "
Else
	If ocontentsCode.FOneItem.Ffixtype = "R" Then '###실시간
		sqlStr = "select * from [db_sitemaster].[dbo].tbl_mobile_mainCont"
		sqlStr = sqlStr & " where poscode = " & poscode & " and isusing = 'Y' and isnull(imageurl,'') <> '' "
		sqlStr = sqlStr & " and enddate >= getdate() "
		sqlStr = sqlStr & " order by orderidx asc , idx desc "
	Else
		sqlStr = "select top " & ocontentsCode.FOneItem.FuseSet & " * from [db_sitemaster].[dbo].tbl_mobile_mainCont"
		sqlStr = sqlStr & " where poscode = " & poscode & " and isusing = 'Y' and isnull(imageurl,'') <> '' "
		sqlStr = sqlStr & " order by startdate desc, idx desc "
	End If 
End If

'Response.write sqlStr
'Response.end

rsget.Open SqlStr, dbget, 1
vTotalCount = rsget.RecordCount

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

		objXMLv.appendChild(objXML.createElement("img"))
		objXMLv.appendChild(objXML.createElement("link"))
		objXMLv.appendChild(objXML.createElement("startdate"))
		objXMLv.appendChild(objXML.createElement("enddate"))
		objXMLv.appendChild(objXML.createElement("altname"))
		objXMLv.appendChild(objXML.createElement("idx"))

		'CData 타입정의
		objXMLv.childNodes(1).appendChild(objXML.createCDATASection("link_Cdata"))

		objXMLv.childNodes(0).text = staticImgUrl & "/mobile/" + db2Html(rsget("imageurl"))
		objXMLv.childNodes(1).childNodes(0).text = db2Html(rsget("linkUrl"))
		If ocontentsCode.FOneItem.Ffixtype = "R" Then 
			objXMLv.childNodes(2).text = rsget("startdate")
			objXMLv.childNodes(3).text = rsget("enddate")
		Else 
			objXMLv.childNodes(2).text = Replace(Left(rsget("startdate"),10),"-",",")
			objXMLv.childNodes(3).text = Replace(Left(rsget("enddate"),10),"-",",")
		End If 
		objXMLv.childNodes(4).text = db2Html(rsget("altname"))
		objXMLv.childNodes(5).text = db2Html(rsget("idx"))

		objXML.documentElement.appendChild(objXMLv.cloneNode(True))
		Set objXMLv = Nothing
		rsget.MoveNext
	Loop
	 '-----파일 저장
	  objXML.save(savePath & FileName)
		rstMsg = rstMsg & "- 파일 [" & FileName & "] 생성 완료\n"
	 
	 '-----객체 해제
	 Set objXML = Nothing

end if

rsget.Close
set ocontentsCode = Nothing
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
