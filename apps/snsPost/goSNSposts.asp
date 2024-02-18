<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'#######################################################
'	History	:  2010.07.21 허진원 생성
'	Description : 쇼셜 네트워크 서비스로 글보내기
'               - 내용은 반드시 UTF8로 전송해야 됨.
'#######################################################
%>
<html> 
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>SNS Post Trans</title>
</head>
<body>
<%
	'변수선언
	Dim StDiv, strLink, strTitle, strPre, strTags
	StDiv = Request("svc")
	strLink = Server.URLEncode(Request("link"))
	strTitle = Server.URLEncode(Request("tit"))
	strPre = Server.URLEncode(Request("pre"))
	strTags = Server.URLEncode(Request("tag"))

	if strLink="" or strTitle="" then
		Response.Write "<script language='javascript'>" & vbCrLf &_
			"alert('보낼 내용이 없습니다.');" & vbCrLf &_
			"self.close();" & vbCrLf &_
			"</script>"
		Response.End
	end if

	Select Case StDiv
		Case "tw"
			'# 트위터
			Response.Redirect("https://twitter.com/intent/tweet?text=%5B" & strPre & "%5D+" & strTitle & "+" & strLink & "+" & strTags)
		Case "fb"
			'# 페이스북
			Response.Redirect("http://m.facebook.com/sharer.php?u=" & strLink & "&t=" & strPre & "+" & strTitle)
		Case "ln"
			'# 네이버 라인
			Response.Redirect("http://line.me/R/msg/text/?" & strTitle & "%0D%0A" & strLink)		'라인 인스톨 버전
			'Response.Redirect("line://msg/text/" & "[텐바이텐]" & trim(Request("tit")) & vbCrLf & trim(Request("link"))) ''모바일 웹일경우 오류
			'Response.Redirect("http://m.10x10.co.kr/apps/link/goline.asp?tit=" & trim(Request("tit")) & "&link=" & trim(Request("link"))) '//통합 신버전
		Case "tg"
			'# 텔레그램
			Response.Redirect("tg://msg?text=" & "[텐바이텐]" & trim(Request("tit")) & vbCrLf & trim(Request("link")))
		Case Else
			Response.Write "<script language='javascript'>" & vbCrLf &_
				"alert('잘못된 접근입니다.');" & vbCrLf &_
				"self.close();" & vbCrLf &_
				"</script>"
	end Select
%>
</body>
</html>