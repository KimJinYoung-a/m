<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/search/search43cls.asp" -->
<title>10x10: 상품 검색</title>
<%
	dim chkMyKeyword : chkMyKeyword=True '나의 검색어
	dim arrMyKwd, mykeywordloop
	dim retUrl
	retUrl = request.ServerVariables("HTTP_REFERER")

	'// 나의 검색어
	if chkMyKeyword then
		arrMyKwd = split(session("myKeyword"),",")
	end if

	'// 인기검색어
	DIM oPpkDoc, arrPpk, arrTg
	SET oPpkDoc = New SearchItemCls
		oPpkDoc.FPageSize = 10
		'arrPpk = oPpkDoc.getPopularKeyWords()			'일반형태
		oPpkDoc.getPopularKeyWords2 arrPpk,arrTg		'순위정보 포함
	SET oPpkDoc = NOTHING 
%>
<script type="text/javascript" src="/lib/js/SearchAutoComplete.js?v=1.1"></script>
<script type="text/javascript">
$(function(){
	/* iphone, ipad, ipod */
	var userAgent = navigator.userAgent.toLowerCase();
	function iSearch(){
		if(userAgent.match("ipad") || userAgent.match("iphone") || userAgent.match("ipod")) {
			$(".search input").focus(function() {
				$(".search").css("position", "absolute");
				$(".keyword .tab").css("position", "absolute");
			});
		}
	}
	iSearch();

	/* tab menu */
	$(".tabCont").hide();
	$(".tab").find("li:first a").addClass("on");
	$(".tabContainer").find(".tabCont:first").show();

	$(".tab li").click(function() {
		$(this).siblings("li").find("a").removeClass("on");
		$(this).find("a").addClass("on");
		$(this).closest(".tab").nextAll(".tabContainer:first").find(".tabCont").hide();
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});

	// 레코픽 추가 (0127)
	var mySwiper1;

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper1.reInit();
				clearInterval(oTm);
			}, 500);
	});

});

// 최근 검색기록 전체 삭제
function delMyKeywordAll() {
	$.ajax({
		url: "/search/act_mySearchKeyword.asp?mode=all",
		cache: false,
		async: false,
		success: function(message) {
			if(message!="") {
				$("#recent").empty().html(message);	
			}
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

//최근 검색어 선택 삭제
function delMyKeyword(kwd) {
	$.ajax({
		url: "/search/act_mySearchKeyword.asp?mode=del&kwd="+kwd,
		cache: false,
		async: false,
		success: function(message) {
			if(message!="") {
				$("#recent").empty().html(message);	
		    }
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<h1 class="hide">검색</h1>
			<!-- search  -->
			<div class="search">
				<form action="<%=wwwUrl%>/search/search_item.asp" onSubmit="return fnTopSearch();" name="searchForm" method="get">
				<input type="hidden" name="cpg" value="1">
				<input type="hidden" name="burl" value="<%=retUrl%>">
					<fieldset>
						<input type="search" name="rect" title="검색어 입력" required placeholder="검색어를 입력하세요." onkeyup="fnKeyInput();" autocomplete="off" />
						<input type="submit" value="검색" class="btnSch" />
						<button type="button" class="btnCancel" onclick="goBack('<%=wwwUrl%>/'); return false;">취소</button>
					</fieldset>
				</form>
			</div>
			<!-- //search -->

			<!-- 자동완성 -->
			<div id="lyrAutoComp" class="autoComplete" style="display:none;">
				<div class="schKwd">
					<div id="atl"></div>
					<p class="schFoot"><button type="button" class="closeKwd" onclick="fnSACLayerOnOff(false)">닫기</button></p>
				</div>
				<div class="bg"></div>
			</div>
			<!-- 자동완성 -->

			<!-- keyword -->
			<div class="keyword">
				<ul class="tab">
					<li><a href="#interest">인기 검색어</a></li>
					<% if chkMyKeyword then %><li><a href="#recent">최근 검색어</a></li><% end if %>
				</ul>
				<div class="tabContainer">
					<div id="interest" class="tabCont interest">
						<h2 class="hide">인기 검색어</h2>
						<ul>
						<%
							If isArray(arrPpk)  THEN
								If Ubound(arrPpk)>0 then
									For mykeywordloop=0 To UBOUND(arrPpk)
										if trim(arrPpk(mykeywordloop))<>"" then
						%>
							<li>
								<a href="/search/search_item.asp?rect=<%=Server.URLEncode(arrPpk(mykeywordloop)) %>&burl=<%=Server.URLEncode(retUrl)%>"><%=(mykeywordloop+1) & ". " & arrPpk(mykeywordloop) %>
									<% if arrTg(mykeywordloop)="new" then %>
									<span class="new">NEW</span></a>
									<% elseif arrTg(mykeywordloop)="0" or arrTg(mykeywordloop)="" then %>
									<span class="no"></span></a>
									<% else %>
									<span class="<%=chkIIF(arrTg(mykeywordloop)>0,"up","down")%>"><%=Replace(arrTg(mykeywordloop),"-","")%></span></a>
									<% end if %>
							</li>
						<%
										end if
									Next
								End If
							End If
						%>
						</ul>
					</div>

					<div id="recent" class="tabCont recent">
						<h2 class="hide">최근 검색어</h2>
					<%
						if chkMyKeyword then
							if ubound(arrMyKwd)>0 then
					%>
						<ul>
						<%
								For mykeywordloop=0 to ubound(arrMyKwd)
						%>
							<li><a href="/search/search_item.asp?rect=<%=server.URLEncode(arrMyKwd(mykeywordloop))%>&exkw=1&burl=<%=Server.URLEncode(retUrl)%>"><%=arrMyKwd(mykeywordloop)%>
								<span onclick="delMyKeyword('<%=server.URLEncode(arrMyKwd(mykeywordloop))%>');return false;">&times;</span></a></li>
						<%
									If mykeywordloop>=4 then Exit For
								next
						%>
						</ul>
						<button type="button" class="btnDel" onclick="delMyKeywordAll();return false;">검색기록 삭제</button>
					<%		else %>
						<p class="noData">최근 검색기록이 없습니다.</p>
					<%
							end if
						end if
					%>
					</div>
				</div>
			</div>
			<!-- //keyword -->

			<%'레코픽 추가 %>
			<script type="text/javascript">
				var vIId='1112322', vDisp='';
			</script>
			<script type="text/javascript" src="./inc_happyTogether.js"></script>
			<div class="schPick">
				<div class="recopick inner5">
					<h2 class="tit04 cRd1">인기 급상승 아이템!</h2>
					<div id="lyrHPTgr"></div>
				</div>
			</div>
			<%'// 레코픽 추가 %>

		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<!-- RecoPick -->
<script type="text/javascript">
  (function(w,d,n,s,e,o) {
    w[n]=w[n]||function(){(w[n].q=w[n].q||[]).push(arguments)};
    e=d.createElement(s);e.async=1;e.charset='utf-8';e.src='//static.recopick.com/dist/production.min.js';
    o=d.getElementsByTagName(s)[0];o.parentNode.insertBefore(e,o);
  })(window, document, 'recoPick', 'script');
  recoPick('site', 'm.10x10.co.kr');
<%
	if (RecoPickSCRIPT<>"") then
		Response.Write RecoPickSCRIPT
	else
		Response.Write "recoPick('page','search');"
	end if
%>
</script>