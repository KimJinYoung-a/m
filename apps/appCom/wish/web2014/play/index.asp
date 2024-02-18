<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/play/playCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
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
		Response.Redirect "/apps/appCom/wish/web2014/play/"
		dbget.close()
		Response.End
	End If
	
	
	SET cPl = New CPlay
	cPl.FPageSize		= 5
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
	calllogin();
	return false;
<% End If %>
}

var vPg=1, vScrl=true;
$(function(){
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

	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_index.asp?type=<%=vType%>&sort=<%=vSort%>&ismine=<%=vIsMine%>&page="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrDFList").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
	
	$('html, body').animate({ scrollTop: $(".playList").offset().top }, 0)
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
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
				<ul id="lyrDFList">
				<%
				If (cPl.FResultCount < 1) Then
				Else
					For i = 0 To cPl.FResultCount-1
				%>
					<li>
						<a href="" onClick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appCom/wish/web2014<%=fnPlayLinkMoWeb(cPl.FItemList(i).Ftype)%>?idx=<%=cPl.FItemList(i).Fidx%>&contentsidx=<%=cPl.FItemList(i).Fcontents_idx%>&type=<%=cPl.FItemList(i).Ftype%>'); return false;"><img src="<%=getThumbImgFromURL(cPl.FItemList(i).Flistimg,400,"","true","false")%>" alt="<%=Replace(cPl.FItemList(i).Ftitle,chr(34),"")%>" /></a>
						<div class="playCont">
							<span class="type"><a href="" onClick="jsChangeType('<%=cPl.FItemList(i).Ftype%>'); return false;"><%=cPl.FItemList(i).Ftypename%></a></span>
							<p class="tit"><strong><% If cPl.FItemList(i).Ftype = "1" Then %><%=cPl.FItemList(i).Fviewno%>&nbsp;<%=cPl.FItemList(i).Fviewnotxt%><% Else %><%=cPl.FItemList(i).Ftitle%><% End If %></strong></p>
							<% If cPl.FItemList(i).Fsubcopy <> "" Then %>
							<p class="subTit"><%=chrbyte(cPl.FItemList(i).Fsubcopy,"120","Y")%></p>
							<!--<a href="" onClick="fnAPPpopupBrowserURL('PLAY','<%=wwwUrl%>/apps/appCom/wish/web2014<%=fnPlayLinkMoWeb(cPl.FItemList(i).Ftype)%>?idx=<%=cPl.FItemList(i).Fidx%>&contentsidx=<%=cPl.FItemList(i).Fcontents_idx%>&type=<%=cPl.FItemList(i).Ftype%>','right');return false;" class="more">더보기</a></p>//-->
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
			<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
			<form name="frmSC" method="get" action="/apps/appcom/wish/web2014/play/index.asp" style="margin:0px;">
			<input type="hidden" name="page" >
			<input type="hidden" name="type" value="<%=vType%>">
			<input type="hidden" name="ismine" value="<%=vIsMine%>">
			<input type="hidden" name="sort" value="<%=vSort%>">
			</form>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->