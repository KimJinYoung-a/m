<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/play/playCls.asp" -->
<%
	Response.Redirect "/playing/"
	dbget.close
	Response.End
	
	Dim cPl, i, vArr, vPage, vType, vIsMine, vSort, vResultCount, vTotalCount, vTotalPage, chgtype
	vPage = RequestCheckVar(request("page"),3)
	vType = RequestCheckVar(request("type"),1)
	vIsMine = RequestCheckVar(request("ismine"),1)
	vSort = RequestCheckVar(request("sort"),2)
	If vPage = "" Then vPage = "1" End If
	If vSort = "" Then vSort = "ne" End If

	'// 정렬방법 통일로 인한 코드 변환
	Select Case vSort
		Case "ne": chgtype = "1"		'신상순
		Case "be": chgtype = "2"		'인기순
		Case Else: chgtype = "1"		'기본값(인기순)
	End Select
	
	If vIsMine = "o" AND IsUserLoginOK() = False Then
		Response.Redirect "/play/"
		dbget.close()
		Response.End
	End If
	
	
	SET cPl = New CPlay
	cPl.FPageSize		= 10
	cPl.FCurrPage		= vPage
	cPl.FRectType		= vType
	cPl.FRectSort		= chgtype
	
	If vIsMine = "o" Then
		cPl.FRectIsMine		= "_Mine"
		cPl.FRectUserID		= GetLoginUserID()
	End If
	vArr = cPl.GetPlayList()
	
	vResultCount = cPl.FResultCount
	vTotalCount = cPl.FTotalCount
	vTotalPage = cPl.FTotalPage
%>
<title>10x10: PLAY</title>
<script type="text/javascript">
function jsGoPage(iP){
	document.frmSC.page.value = iP;
	document.frmSC.submit();
}

function jsChangeType(t){
	document.frmSC.page.value = "1";
	document.frmSC.type.value = t;
	document.frmSC.submit();
}

function jsSorting(s){
	document.frmSC.page.value = "1";
	document.frmSC.sort.value = s;
	document.frmSC.ismine.value = "";
	document.frmSC.submit();
}

function jsIsMine(m){
<% If IsUserLoginOK() Then %>
	document.frmSC.type.value = "";
	document.frmSC.page.value = "1";
	document.frmSC.ismine.value = m;
	document.frmSC.sort.value = "";
	document.frmSC.submit();
<% Else %>
	alert("로그인을 하셔야합니다.");
	top.location.href = "/login/login.asp?backpath=/play/";
<% End If %>
}

$(function() {
	//content area height calculate
	function contHCalc() {
		var contH = $('.content').outerHeight();
		$('.contBlankCover').css('height',contH+'px');
	}

	//Open option Nani control
	$(".viewSortV16a button").click(function(){
		if($(this).parent('.sortGrp').hasClass('current')){
			$(".sortGrp").removeClass('current');
			$("#contBlankCover").fadeOut();
		} else {
			$(".sortGrp").removeClass('current');
			$(this).parent('.sortGrp').addClass('current');
			$("#contBlankCover").fadeIn();
			contHCalc();
		}
	});

	//Close option Nani control
	$(".contBlankCover").click(function(){
		$(".contBlankCover").fadeOut();
		$(".viewSortV16a div").removeClass('current');
	});

	$('html, body').animate({ scrollTop: $(".playList").offset().top }, 0)
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content playMain" id="contentArea">
				<div class="viewSortV16a playSortV16a">
					<div class="sortV16a">
						<div class="sortGrp category">
						<%
							'분류상자 호출; sType:분류, sCallback:콜백함수명 (via playCls.asp)
							Call fnTypeSelectBoxV16(vType,"jsChangeType")
						%>
						</div>
						<div class="sortGrp array">
						<%
							'정렬상자 호출; sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntSortNaviV16(vSort,"ab", "jsSorting")
						%>
						</div>
					</div>
					<div id="contBlankCover" class="contBlankCover"></div>
				</div>

				<div class="playList inner10">
					<ul>
					<%
					If (cPl.FResultCount < 1) Then
					Else
						For i = 0 To cPl.FResultCount-1
					%>
						<li>
							<a href="<%=fnPlayLinkMoWeb(cPl.FItemList(i).Ftype)%>?idx=<%=cPl.FItemList(i).Fidx%>&contentsidx=<%=cPl.FItemList(i).Fcontents_idx%>&type=<%=cPl.FItemList(i).Ftype%>"><img src="<%=getThumbImgFromURL(cPl.FItemList(i).Flistimg,400,"","true","false")%>" alt="<%=Replace(cPl.FItemList(i).Ftitle,chr(34),"")%>" /></a>
							<div class="playCont">
								<span class="type"><a href="" onClick="jsChangeType('<%=cPl.FItemList(i).Ftype%>'); return false;"><%=cPl.FItemList(i).Ftypename%></a></span>
								<p class="tit"><strong><% If cPl.FItemList(i).Ftype = "1" Then %><%=cPl.FItemList(i).Fviewno%>&nbsp;<%=cPl.FItemList(i).Fviewnotxt%><% Else %><%=cPl.FItemList(i).Ftitle%><% End If %></strong></p>
								<% If cPl.FItemList(i).Fsubcopy <> "" Then %>
								<p class="subTit"><%=chrbyte(cPl.FItemList(i).Fsubcopy,"120","Y")%></p>
								<!--<a href="<%=fnPlayLinkMoWeb(cPl.FItemList(i).Ftype)%>?idx=<%=cPl.FItemList(i).Fidx%>&contentsidx=<%=cPl.FItemList(i).Fcontents_idx%>&type=<%=cPl.FItemList(i).Ftype%>" class="more">더보기</a></p>//-->
								<% End If %>
								<!--
								<p id="wish<%=i%>" class="circleBox wishView" onClick="alert('로그인을 하셔야 합니다.');"><span>찜하기</span></p>
								//-->
							</div>
						</li>
					<%
						Next
					End If
					%>
					</ul>
				</div>
				
				<%= fnDisplayPaging_New(vPage, vTotalCount, 10, 4,"jsGoPage") %>
				<form name="frmSC" method="get" style="margin:0px;">
				<input type="hidden" name="page" >
				<input type="hidden" name="type" value="<%=vType%>">
				<input type="hidden" name="ismine" value="<%=vIsMine%>">
				<input type="hidden" name="sort" value="<%=vSort%>">
				</form>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% SET cPl = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->