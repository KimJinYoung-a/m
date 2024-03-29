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
<!-- #include virtual="/lib/classes/piece/piececls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	'####################################################
	' Description :  피스 리스트
	' History : 2017-11-17 이종화
	'####################################################

	Dim SearchText, CurrPage, PageSize, i, t, p, oPi, vTotalCount, vWishArr, vListGubun, vAdminID
	Dim vLinkItemID, vItemID, vBasicImage, vP_NickName , piecepop , P_iam , focusout , oPie
	Dim tagSearchYN

	SearchText	 	= requestCheckVar(request("rect"),100)
	CurrPage		= getNumeric(requestCheckVar(request("cpg"),8))
	PageSize		= requestCheckVar(request("psz"),5)
	vAdminID		= requestCheckVar(request("adminid"),50)
	piecepop		= requestCheckVar(request("piecepop"),2)
	focusout		= requestCheckVar(request("focusout"),1)
	tagSearchYN		= requestCheckVar(request("tagSearchYN"),1)

	SearchText = RepWord(SearchText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%\-\_\s]","")

	'SearchText = "내용"
	if CurrPage="" then CurrPage="1"
    if PageSize="" then PageSize="5"

    '## list 일때는 gubun이 모두 나오나, allsearch와 tagsearch 는 (배너,베스트키워드,파이를제외한조각검색결과만노출) 라고 기획서에 표기되있음.
    If SearchText = "" Then
    	vListGubun = "list"
    Else
		vListGubun = "allsearch"
		'// 검색어가 있을경우 카운팅 추가
		Call fnTagCountUpdate(SearchText)
	End If

	If vAdminID <> "" Then
		vListGubun = "allsearch"
	End If

	'// 검색결과 내위시 표시정보 접수
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		vWishArr = fnGetMyPieceWishItem()
	end If

	'// A/B 테스트용
	Dim RvSelPiece : RvSelPiece=Session.SessionID Mod 2
%>
<title>10x10: PIECE</title>
<script type="text/javascript">
$(function(){
	<%' amplitude 이벤트 로깅 %>
		//tagScriptSend('', 'pieceMain', '', 'amplitude');
	<%'// amplitude 이벤트 로깅 %>

	<% if tagSearchYN = "Y" then %>
		//tagScriptSend('', 'piece_tag_search', '', 'amplitude');
	<% end if %>

	$("#searchpiece.focusout input").on("focus", function(){
		if (!$('#rect').val() && $("#searchpiece").hasClass("focusout")){
			document.body.scrollTop = $(this).offset().top;
			$("#searchpiece").addClass("ani");
		}
	});

	$("#searchpiece input").on("keyup", function(){
		$("#searchpiece").addClass("focus");
	});

	$('#btnSearchPiece').hide();
	$(window).scroll(function(){
		if($('#gotop').css("display")=="none"){
			$('#btnSearchPiece').hide();
		} else {
			$('#btnSearchPiece').fadeIn();
		}
	});

	$('.pie img').load(function(){
		$('.pie .swiper-slide .thumbnail img').each(function(){
			var pieImgH = $(this).height();
			$(this).css('margin-top', -pieImgH/2+'px');
		});
	});
});
</script>
</head>
<body class="default-font <%=chkiif(piecepop="on","body-sub","body-main")%> piece bg-black">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- #include virtual="/piece/tutoriallayer.asp" -->
	<% If piecepop = "" Then %>
	<a href="/piece/search_list.asp?piecepop=on&focusout=Y&rect=" id="btnSearchPiece" class="btn-search-piece">검색</a>
	<% End If %>

	<div id="content" class="content bg-black">
		<% If vAdminID = "" Then %>
			<% If piecepop = "on" Then %>
			<div class="searchbar searchbar-piece-new" id="searchpiece">
				<legend class="hidden">PIECE 검색 폼</legend>
				<div class="textfield">
					<input type="search" name="rect" id="rect" value="<%=SearchText%>" title="검색어 입력" placeholder="검색어를 입력하세요" onkeypress="if(event.keyCode==13){jsPieceSearch($('#rect').val());$('#rect').blur();return false;}" autocomplete="off" onkeyup="$('#rect').focus();"/>
					<button type="button" class="btn-search" onclick="jsPieceSearch($('#rect').val());">검색</button>
				</div>
			</div>
			<% End If %>
		<% End If %>

		<% If vListGubun = "list" AND vAdminID = "" Then %>
		<!-- #include file="./index_opening.asp" -->
		<% End If %>
		<div id="piecemore">
		<%
		'// 검색결과
		set oPi = new SearchPieceCls
		oPi.FRectSearchTxt = SearchText
		oPi.FCurrPage = CurrPage
		oPi.FPageSize = PageSize
		oPi.FRectSearchGubun = vListGubun
		oPi.FRectAdminID = vAdminID
		oPi.FRectIsOpening = ""
		oPi.FScrollCount = 10
		oPi.getPieceList2017

		vTotalCount = oPi.FTotalCount

		If oPi.FResultCount>0 Then
		%>
			<% If vAdminID <> "" Then '// 조각모음%>
			<div class="hgroup-piece">
				<div class="writer"><span class="iam" id="p_iam"></span> <span class="nickname" id="p_nickname"></span></div>
				<ul class="counting-list">
					<li><em id="p_totalcount"></em>개의 조각들</li>
					<li><em><%=pieceMySNSCnt(vAdminID)%></em>명이 공유</li>
				</ul>
			</div>
			<% End If %>
		<%
			For i = 0 To oPi.FResultCount-1

			vP_NickName = oPi.FItemList(i).Fnickname
			P_iam	=	oPi.FItemList(i).Foccupation

			If oPi.FItemList(i).Fpitem <> "" Then
				vLinkItemID = Split(Split(oPi.FItemList(i).Fpitem,",")(0),"$$")(0)
			End If
		%>
			<% If CStr(Replace(date(),"-","")) <> CStr(Left(oPi.FItemList(i).Fstartdate,8)) Then %>
			<!--<div class="time"><span class="icon icon-moon"></span><%=fnDayCheckText(oPi.FItemList(i).Fstartdate)%></div>-->
			<% End If %>

			<% If oPi.FItemList(i).Fgubun = "1" Then	'### 조각 %>
				<!-- #include file="./inc_piece.asp" -->
			<% ElseIf oPi.FItemList(i).Fgubun = "4" Then	'### 배너 %>
				<% If oPi.FItemList(i).Fbannergubun = "1" Then	'### 텍스트 %>
				<div class="bnr bnr-piece-ad type-text">
					<a href="<%=oPi.FItemList(i).Fetclink%>"><%=oPi.FItemList(i).Flisttitle%></a>
				</div>
				<% ElseIf oPi.FItemList(i).Fbannergubun = "2" Then	'### 이미지 %>
				<div class="bnr bnr-piece-ad type-img">
					<a href="<%=oPi.FItemList(i).Fetclink%>"><div class="thumbnail"><img src="<%=oPi.FItemList(i).Flistimg%>" alt=""></div></a>
				</div>
				<% End If %>
			<% ElseIf oPi.FItemList(i).Fgubun = "2" Then	'### 파이 %>
				<!-- #include file="./inc_pie.asp" -->
			<% End If %>
			<%'!-- best keyword 들어갈 자리 나중에.--%>
		<%
				vLinkItemID = ""
			Next
		Else
		%>
		<div class='nodata nodata-piece'>
			<p>검색하신 조각이 없습니다.</p>
		</div>
		<%
		End If
		%>
		</div>
	</div>
	<script>
	<% If vP_NickName <> "" Then %>
	$("#p_iam").text("<%=P_iam%>");
	$("#p_nickname").text("<%=vP_NickName%>");
	$("#p_totalcount").text("<%=FormatNumber(vTotalCount,0)%>");
	<% End If %>
	<% if vAdminid <> "" then %>
	$("#HeadTitleName").text("조각모음");
	<% end if%>
	<!-- #include file="./index_javascript.asp" -->
	</script>
	<%
		strHeadTitleName = "PIECE" '// 푸터방지용
	%>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
	set oPi = nothing
	Set oPie = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->