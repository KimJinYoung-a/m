<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/playing/playingCls.asp" -->
<%
	Dim cPl, i, vIsAdmin, vStartDate, vState, vDIdx, vIsMine
	vStartDate = "getdate()"
	vState = "7"
	
	vIsAdmin = RequestCheckVar(request("isadmin"),1)
	If vIsAdmin = "o" Then
		vStartDate = "''" & RequestCheckVar(request("sdate"),10) & "''"
		vState = RequestCheckVar(request("state"),1)
	End If
	
	vDIdx = RequestCheckVar(request("didx"),10)
	
	If vDIdx = "" Then
		Response.Write "<script>alert('잘못된 경로입니다.');top.location.href='/playing/';</script>"
		dbget.close()
		Response.End
	Else
		If Not isNumeric(vDidx) Then
			Response.Write "<script>alert('잘못된 경로입니다.');top.location.href='/playing/';</script>"
			dbget.close()
			Response.End
		End If
	End If
	
	SET cPl = New CPlay
	cPl.FRectDIdx			= vDIdx
	cPl.FRectStartdate 	= vStartDate
	cPl.FRectState 		= vState
	cPl.sbPlayCornerDetail()
	
	If cPl.FResultCount < 1 Then
		Response.Write "<script>alert('없는 코너 번호입니다.');top.location.href='/playing/';</script>"
		dbget.close()
		Response.End
	End If
	
	Dim vCate, vCateName, vTitle, vSubCopy, vContents, vIsExec, vExecFile, vBGColor, vImageList, vItemList, vSquareImg, vRectangleImg, vTitleStyle
	Dim vViewCntW, vViewCntM, vViewCntA, vTagAnnounce, vTagSDate, vTagEDate
	vCate 		= cPl.FOneItem.Fcate
	'vCateName 	= cPl.FOneItem.Fcatename
	vTitle 	= cPl.FOneItem.Ftitle
	vTitleStyle= cPl.FOneItem.Ftitlestyle
	vSubCopy	= cPl.FOneItem.Fsubcopy
	vStartDate	= cPl.FOneItem.Fstartdate
	vContents	= cPl.FOneItem.Fcontents
	vIsExec	= cPl.FOneItem.FisExec
	vExecFile	= cPl.FOneItem.Fexecfile
	vBGColor	= cPl.FOneItem.Fbgcolor
	vViewCntW	= cPl.FOneItem.FViewCnt_W
	vViewCntM	= cPl.FOneItem.FViewCnt_M
	vViewCntA	= cPl.FOneItem.FViewCnt_A
	vTagSDate	= cPl.FOneItem.FtagSDate
	vTagEDate	= cPl.FOneItem.FtagEDate
	vTagAnnounce = cPl.FOneItem.Ftag_announcedate

	vImageList 	= cPl.FImgArr
	vSquareImg		= fnPlayImageSelect(vImageList,vCate,"11","i")
	vRectangleImg	= fnPlayImageSelect(vImageList,vCate,"1","i")
	
	
	'### 뷰 카운트 w,m,a. 미리보기 체크 X.
	If vIsAdmin <> "o" Then
		If cPl.FOneItem.Fstartdate <= date() Then
			Call fnPlayViewCount(vDIdx,"m")
		End If
	End If
	SET cPl = Nothing
	
	strOGMeta = strOGMeta & "<meta property=""og:title"" content=""" & replace(vTitle,"""","") & """>" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/playing/view.asp?didx=" & vDIdx & """ />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:image"" content=""" & vSquareImg & """>" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:description"" content=""" & "[텐바이텐] PLAY - " & replace(vTitle,"""","") & """>" & vbCrLf

	strPageKeyword = "PLAYing, " & replace(vTitle,"""","")

	'### SNS 변수선언
	Dim snpTitle, snpLink, snpPre, snpTag,  snpImg, kakaotitle, kakaoimage, kakaoimg_width, kakaoimg_height, kakaolink_url 
	snpTitle	= vTitle
	snpLink		= "http://10x10.co.kr/playing/view.asp?didx="&vDIdx&""
	snpPre		= "10x10 PLAYing"
	snpTag 		= "텐바이텐 " & Replace(vTitle," ","")
	snpImg = vSquareImg

	
	'### 다른 코너 보기 변수선언
	Dim clistmore, vListMoreArr, limo
	
	strHeadTitleName = "PLAYing"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: PLAYing - <%=vTitle%></title>
<!-- #include file="./inc_cssscript.asp" -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
<!-- #include virtual="/common/LayerShare.asp" -->
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- //content area -->
			<div class="content playV16" id="contentArea">
			<% If vCate = "1" Then	'### playlist %>
				<!-- #include file="./playlist.asp" -->
			<% ElseIf vCate = "21" OR vCate = "22" Then	'### inspiration design 과 style 같이 사용 %>
				<!-- #include file="./inspiration_design.asp" -->
			<% ElseIf vCate = "3" Then	'### azit %>
				<!-- #include file="./azit.asp" -->
			<%'// 2017.06.01 원승현 azit comma 스타일 추가%>
			<% ElseIf vCate = "31" Then	'### azitCOMMA %>
				<!-- #include file="./azitcomma.asp" -->
			<% ElseIf vCate = "41" Then	'### THING thing %>
				<!-- #include file="./thing.asp" -->
			<% ElseIf vCate = "42" Then	'### THING thingthing %>
				<!-- #include file="./thingthing.asp" -->
			<% ElseIf vCate = "43" Then	'### THING 배경화면 %>
				<!-- #include file="./wallpaper.asp" -->
			<% ElseIf vCate = "5" Then	'### COMMA %>
				<!-- #include file="./comma.asp" -->
			<% ElseIf vCate = "6" Then	'### HOWHOW %>
				<!-- #include file="./howhow.asp" -->
			<% End If %>
			</div>
			<!-- //content area -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->