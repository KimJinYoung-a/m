<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	'####################################################
	' Description :  피스 검색 리스트
	' History : 2017-12-27 이종화
	'####################################################
	
	Dim SearchText, i, t, p, oPi, vTotalCount, vWishArr, vListGubun, vAdminID
	Dim vLinkItemID, vItemID, vBasicImage, vP_NickName , piecepop , P_iam , focusout

	SearchText	 	= requestCheckVar(request("rect"),100)
	vAdminID		= requestCheckVar(request("adminid"),50)
	piecepop		= requestCheckVar(request("piecepop"),2)
	focusout		= requestCheckVar(request("focusout"),1)
%>
<title>10x10: PIECE</title>
<script type="text/javascript">
$(function(){
	<%' amplitude 이벤트 로깅 // 피스 검색%>
		tagScriptSend('', 'piece_search', '', 'amplitude');
	<%'// amplitude 이벤트 로깅 %>
	
	$("#searchpiece input").on("keyup", function(){
		$("#searchpiece").addClass("focus");
		if (!$('#rect').val()){
			$("#searchpiece").removeClass("focus");
		}
	});
});

function jsPieceSearchList(v){
	document.location.replace('/piece/index.asp?piecepop=on&rect='+v);
	return;
}
</script>
</head>
<body class="default-font <%=chkiif(piecepop="on","body-sub","body-main")%> piece bg-black">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<% If piecepop = "" Then %>
	<a href="/piece/?piecepop=on&focusout=Y&rect=" id="btnSearchPiece" class="btn-search-piece">검색</a>
	<% End If %>

	<div id="content" class="content bg-black">
		<% If vAdminID = "" Then %>
			<% If piecepop = "on" Then %>
			<div class="searchbar searchbar-piece-new" id="searchpiece">
				<legend class="hidden">PIECE 검색 폼</legend>
				<div class="textfield">
					<input type="search" name="rect" id="rect" value="<%=SearchText%>" title="검색어 입력" placeholder="검색어를 입력하세요" onkeypress="if(event.keyCode==13){jsPieceSearchList($('#rect').val());$('#rect').blur();return false;}" autocomplete="off" onkeyup="$('#rect').focus();"/>
					<button type="button" class="btn-search" onclick="jsPieceSearchList($('#rect').val());">검색</button>
				</div>
			</div>
			<% End If %>
		<% End If %>
		<div class="search-msg">
			<span class="icon"></span>
			<p>찾고 싶은 조각의<br />태그 또는 내용을 입력해주세요.</p>
		</div>
	</div>
	<script>
	<% if vAdminid <> "" then %>
	$("#HeadTitleName").text("조각모음");
	<% end if%>
	</script>
	<%
		strHeadTitleName = "PIECE" '// 푸터방지용
	%>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<% set oPi = nothing %>