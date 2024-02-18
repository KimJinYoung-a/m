<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 링커(20주년) 포럼
' History : 2021-09-24 이전도 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim gnbflag , testmode, defaultAPIURL
gnbflag = RequestCheckVar(request("gnbflag"),1)
If gnbflag <> "" Then '//gnb 숨김 여부
    gnbflag = true
Else
    gnbflag = False
    strHeadTitleName = "헤더"
End if

Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = "저 텐바이텐이 드디어 스무 살이 되었거든요!"
snpLink = wwwUrl & "/linker/forum.asp?idx=1"
snpPre = "10x10 20th"

'기본 태그
snpTag = "저 텐바이텐이 드디어 스무 살이 되었거든요!"
snpTag2 = "#10x10"
snpImg = "http://fiximage.10x10.co.kr/web2021/anniv2021/m/sharing.jpg"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "저 텐바이텐이 드디어 스무 살이 되었거든요! - 텐텐이들의 칭찬과 축하에 감사하며 다양한 이벤트와 이야기를 준비했어요"
Dim kakaoimage : kakaoimage = "http://fiximage.10x10.co.kr/web2021/anniv2021/m/sharing.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url

If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/linker/forum.asp?idx=1"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/linker/forum.asp?idx=1"
end if
%>
<meta property="og:image" content="http://fiximage.10x10.co.kr/web2021/anniv2021/m/sharing.jpg"/>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
    <% server.Execute("/linker/exc_forum.asp") %>
</body>
</html>