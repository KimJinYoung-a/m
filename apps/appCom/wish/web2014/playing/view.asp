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
			Call fnPlayViewCount(vDIdx,"a")
		End If
	End If
	SET cPl = Nothing

	'### SNS 변수선언
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg, kakaotitle, kakaoimage, kakaoimg_width, kakaoimg_height, kakaolink_url 
	
	'### 다른 코너 보기 변수선언
	Dim clistmore, vListMoreArr, limo
	
	strHeadTitleName = "PLAYing"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: PLAYing - <%=vTitle%></title>
<!-- #include file="./inc_cssscript.asp" -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
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
<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->