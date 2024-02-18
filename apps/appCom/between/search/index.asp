<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<%
	Dim chkMyKeyword : chkMyKeyword = True '나의 검색어
	Dim arrMyKwd, mykeywordloop
	Dim retUrl
	retUrl = request.ServerVariables("HTTP_REFERER")
	'// 나의 검색어
	If chkMyKeyword Then
		arrMyKwd = split(session("mySearchKey"),",")
	End If
%>
<script type="text/javascript">
function fnTopSearch(){
	var frm = document.searchForm;
	var rect = frm.rect.value;
	frm.cpg.value=1;

	if (rect.trim().length<=0){
		alert('검색어를 입력하세요');
		frm.rect.value="";
		frm.rect.focus();
		return false;
	} else {
		return true;
	}
}
// 선택 검색기록 삭제
function delMyKeyword(str) {
	$.ajax({
		url: "/apps/appCom/between/search/act_mySearchKey.asp?mode=del&kwd="+str,
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

// 최근 검색기록 삭제
function delMyKeywordAll() {
	$.ajax({
		url: "/apps/appCom/between/search/act_mySearchKey.asp?mode=all",
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
<div class="wrapper" id="btwMypage">
	<div id="content">
		<div class="cont">
			<div class="search">
				<div class="finder">
					<form action="/apps/appCom/between/search/result.asp" onSubmit="return fnTopSearch();" name="searchForm" method="get">
					<input type="hidden" name="cpg" value="1">
						<fieldset>
						<legend>검색</legend>
							<input type="search" id="rect" name="rect" title="검색어 입력" required placeholder="검색어를 입력하세요" />
							<button type="button" class="btnReset">검색어 초기화</button>
							<button type="button" class="btnClose" onclick="history.back(-1);">취소</button>
						</fieldset>
					</form>
				</div>
				<div class="keyword">
					<div class="recommend">
						<strong class="txtTopGry">추천 검색어</strong>
						<ul>
							<% server.Execute("/apps/appCom/between/chtml/loader/searchlikeword.asp") %>
						</ul>
					</div>

					<div id="recent" class="mine">
						<strong class="txtTopGry">나의 검색어</strong>
					<%
						If chkMyKeyword Then
							If Ubound(arrMyKwd) > 0 Then
					%>
						<ul>
					<%			For mykeywordloop = 0 To Ubound(arrMyKwd) %>
							<li><a href="/apps/appCom/between/search/result.asp?rect=<%=server.URLEncode(arrMyKwd(mykeywordloop))%>&exkw=1"><%=arrMyKwd(mykeywordloop)%></a> <button type="button" class="btnDel" onclick="delMyKeyword('<%=arrMyKwd(mykeywordloop)%>');return false;">삭제</button></li>
					<%
									If mykeywordloop >= 9 Then Exit For
								Next
					%>
						</ul>
						<button type="button" class="btnAll" onclick="delMyKeywordAll();return false;">나의 검색어 전체삭제</button>
					<%		Else %>
						<p class="noKeyword">최근 검색내역이 없습니다</p>
					<%
							End If
						End If
					%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->