<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' PageName : make_main_rollchk.asp
' Discription : 사이트 메인 롤링 순서 변경
' History : 2015-05-07 이종화 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	'// 유입경로 확인
	dim refip , mna
	refip = request.ServerVariables("HTTP_REFERER")
	mna = requestCheckVar(Request("mna"),1)
	if (InStr(refip,"10x10.co.kr")<1) then
		'response.end
	end If

	'// 변수 선언
	Dim savePath, FileName , rstMsg 
	Dim fso, delFile , CreateFile , txt

	'// 생성파일 경로 및 파일명 선언
	savePath = server.mappath("/chtml/main/xml/main_banner/") + "\"
	If mna = "m" then
		FileName = "main_rollchk.txt"
	Else
		FileName = "app_main_rollchk.txt"
	End If 
	
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	'// 파일이 있을 경우 수정
	if fso.FileExists(savePath & FileName) Then
		Set CreateFile = fso.OpenTextFile(savePath & FileName,2,false,false)
			txt = "initialSlide:7,"
			CreateFile.Write(txt)
			CreateFile.Close
		set CreateFile = Nothing
		rstMsg = rstMsg & "롤링배너 마케팅배너 우선순위 변경 완료"
	Else
		Set CreateFile = fso.CreateTextFile(savePath & FileName,true,false)
			txt = "initialSlide:7,"
			CreateFile.Write(txt)
			CreateFile.Close
		set CreateFile = Nothing	
		rstMsg = rstMsg & "롤링배너 마케팅배너 우선순위 변경 완료"
	End If
	set fso = Nothing
	
	If rstMsg = "" then
		rstMsg = rstMsg & "파일생성 오류! 관리자에게 문의"
	End If 
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