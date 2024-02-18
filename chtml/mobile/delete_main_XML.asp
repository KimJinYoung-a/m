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
'// xml 삭제
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

dim objXML, objXMLv, blnFileExist

'// 기존 파일 삭제
Dim fso, delFile
Set fso = CreateObject("Scripting.FileSystemObject")
if fso.FileExists(savePath & FileName) then
	Set delFile = fso.GetFile(savePath & FileName)
	delFile.Delete 
	set delFile = Nothing
end if
set fso = Nothing

rstMsg = rstMsg & "- 파일 [" & FileName & "] 삭제 완료\n"
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
