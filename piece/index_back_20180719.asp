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
	' Description :  �ǽ� ����Ʈ
	' History : 2017-11-17 ����ȭ
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

	SearchText = RepWord(SearchText,"[^��-����-�Ӱ�-�Ra-zA-Z0-9.&%\-\_\s]","")

	'SearchText = "����"
	if CurrPage="" then CurrPage="1"
    if PageSize="" then PageSize="5"

    '## list �϶��� gubun�� ��� ������, allsearch�� tagsearch �� (���,����ƮŰ����,���̸������������˻����������) ��� ��ȹ���� ǥ�������.
    If SearchText = "" Then
    	vListGubun = "list"
    Else
		vListGubun = "allsearch"
		'// �˻�� ������� ī���� �߰�
		Call fnTagCountUpdate(SearchText)
	End If

	If vAdminID <> "" Then
		vListGubun = "allsearch"
	End If

	'// �˻���� ������ ǥ������ ����
	if IsUserLoginOK then
		'// �˻���� ��ǰ��� �ۼ�
		vWishArr = fnGetMyPieceWishItem()
	end If

	'// A/B �׽�Ʈ��
	Dim RvSelPiece : RvSelPiece=Session.SessionID Mod 2
%>
<title>10x10: PIECE</title>
<script type="text/javascript">
$(function(){
	<%' amplitude �̺�Ʈ �α� %>
		//tagScriptSend('', 'pieceMain', '', 'amplitude');
	<%'// amplitude �̺�Ʈ �α� %>

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
	<a href="/piece/search_list.asp?piecepop=on&focusout=Y&rect=" id="btnSearchPiece" class="btn-search-piece">�˻�</a>
	<% End If %>

	<div id="content" class="content bg-black">
		<% If vAdminID = "" Then %>
			<% If piecepop = "on" Then %>
			<div class="searchbar searchbar-piece-new" id="searchpiece">
				<legend class="hidden">PIECE �˻� ��</legend>
				<div class="textfield">
					<input type="search" name="rect" id="rect" value="<%=SearchText%>" title="�˻��� �Է�" placeholder="�˻�� �Է��ϼ���" onkeypress="if(event.keyCode==13){jsPieceSearch($('#rect').val());$('#rect').blur();return false;}" autocomplete="off" onkeyup="$('#rect').focus();"/>
					<button type="button" class="btn-search" onclick="jsPieceSearch($('#rect').val());">�˻�</button>
				</div>
			</div>
			<% End If %>
		<% End If %>

		<% If vListGubun = "list" AND vAdminID = "" Then %>
		<!-- #include file="./index_opening.asp" -->
		<% End If %>
		<div id="piecemore">
		<%
		'// �˻����
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
			<% If vAdminID <> "" Then '// ��������%>
			<div class="hgroup-piece">
				<div class="writer"><span class="iam" id="p_iam"></span> <span class="nickname" id="p_nickname"></span></div>
				<ul class="counting-list">
					<li><em id="p_totalcount"></em>���� ������</li>
					<li><em><%=pieceMySNSCnt(vAdminID)%></em>���� ����</li>
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

			<% If oPi.FItemList(i).Fgubun = "1" Then	'### ���� %>
				<!-- #include file="./inc_piece.asp" -->
			<% ElseIf oPi.FItemList(i).Fgubun = "4" Then	'### ��� %>
				<% If oPi.FItemList(i).Fbannergubun = "1" Then	'### �ؽ�Ʈ %>
				<div class="bnr bnr-piece-ad type-text">
					<a href="<%=oPi.FItemList(i).Fetclink%>"><%=oPi.FItemList(i).Flisttitle%></a>
				</div>
				<% ElseIf oPi.FItemList(i).Fbannergubun = "2" Then	'### �̹��� %>
				<div class="bnr bnr-piece-ad type-img">
					<a href="<%=oPi.FItemList(i).Fetclink%>"><div class="thumbnail"><img src="<%=oPi.FItemList(i).Flistimg%>" alt=""></div></a>
				</div>
				<% End If %>
			<% ElseIf oPi.FItemList(i).Fgubun = "2" Then	'### ���� %>
				<!-- #include file="./inc_pie.asp" -->
			<% End If %>
			<%'!-- best keyword �� �ڸ� ���߿�.--%>
		<%
				vLinkItemID = ""
			Next
		Else
		%>
		<div class='nodata nodata-piece'>
			<p>�˻��Ͻ� ������ �����ϴ�.</p>
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
	$("#HeadTitleName").text("��������");
	<% end if%>
	<!-- #include file="./index_javascript.asp" -->
	</script>
	<%
		strHeadTitleName = "PIECE" '// Ǫ�͹�����
	%>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
	set oPi = nothing
	Set oPie = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->