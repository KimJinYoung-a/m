<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
dim flgDevice: flgDevice="W"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/main/main_contents_managecls.asp" -->
<%
'' 관리자 확정시 Data 작성. 

dim i, rstMsg
dim poscode
dim savePath, FileName, refip

poscode = requestCheckVar(Request("poscode"),32)

'// 생성파일 경로 및 파일명 선언
savePath = server.mappath("/chtml/main/js/") + "\"
FileName = "main_" + CStr(poscode) + ".js"

'모바일 경로로 변환
IF application("Svr_Info")="Dev" THEN
	'테스트서버
	savePath = Replace(savePath,"2012www","m")
Else
	'실서버
	savePath = Replace(savePath,"2012www","mobile")
End If


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

'// 적용코드 확인
set ocontentsCode = new CMainContentsCode
ocontentsCode.FRectPoscode = poscode
ocontentsCode.GetOneContentsCode

if (ocontentsCode.FResultCount<1) then
    response.write "not valid cd value"
	response.end
end if

'// 메인 데이터 접수
set ocontents = New CMainContents
ocontents.FRectPoscode= poscode
ocontents.FPageSize=7
ocontents.GetMainContentsValidList

if (ocontents.FResultCount<1) then
    response.write "no valid data Exists"
	response.end
end if



dim fso, tFile, BufStr
dim VarName, DoubleQuat, VarTodayStr
VarName = ocontentsCode.FOneItem.FposVarname
DoubleQuat = Chr(34)
VarTodayStr = "V_CURRENTYYYYMM"


if ocontents.FResultCount>0 then
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set tFile = fso.CreateTextFile(savePath & FileName )
	BufStr = ""
	BufStr = "var " + VarName + ";" + VbCrlf
	BufStr = BufStr + VarName + " = " + DoubleQuat + DoubleQuat + ";" + VbCrlf

	If (poscode = "2023") Then
		BufStr = BufStr + VarName + "+=" + DoubleQuat + "<div class='mainChannel' style='background-image:url("& staticImgUrl & "/mobile/" & ocontents.FItemList(0).Fimageurl &");'>" + DoubleQuat + VbCrlf
	ElseIf (poscode="2027") or (poscode="2028") or (poscode="2029") or (poscode="2030") or (poscode="2031") or (poscode="2032") or (poscode="2033") or (poscode="2034") or (poscode="2035") or (poscode="2036") Then
		BufStr = BufStr + VarName + "+=" + DoubleQuat + "<a href='"& ocontents.FItemList(0).Flinkurl &"'><img src='"& staticImgUrl & "/mobile/" & ocontents.FItemList(0).Fimageurl &"' alt='"& ocontents.FItemList(0).Faltname &"' /></a>" + DoubleQuat + VbCrlf
	End If
    BufStr = BufStr + "document.write(" + VarName + ");" + VbCrlf
    
    tFile.Write BufStr
    tFile.Close
    
    Set tFile = Nothing
    Set fso = Nothing
	rstMsg = rstMsg & "- 파일 [" & FileName & "] 생성 완료\n"
end if

	set ocontentsCode = Nothing
	set ocontents = Nothing
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