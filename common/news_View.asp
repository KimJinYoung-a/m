<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.charset = "utf-8"
%>
<%
'####################################################
' Description :  공지사항 & 당첨자발표
' History : 2013.12.13 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/BoardNoticecls.asp" -->

<%
'해더 타이틀
strHeadTitleName = "공지사항"

dim oBoardNotice, noticeFix ,idx, ntype, iPg, page, ibb, iTotCnt
	idx = requestCheckVar(request("idx"),9)
	page = requestCheckVar(request("page"),9)
	ntype = requestCheckVar(request("type"),2)			'(A: 전체, E:당첨안내, 01:전체공지,02:상품공지,03:이벤트공지,04:배송공지,05:당첨자공지,06:CultureStation)

if page = "" then page=1
if ntype="" then ntype="A"

IF (idx<>"") and (Not IsNumeric(idx)) then response.end

'// 공지사항 한개
dim readnotice
set readnotice = New cBoardNotice
	if idx <> "" then
	    readnotice.FRectid = idx
	    readnotice.getOneNotics()
	end if
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%=chkIIF(ntype="E","이벤트 당첨자","공지사항")%></title>
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<script>
// 내용내 팝업 링크(web용-모달창)
function fnOpenPopupLink(tit,url) {
	fnOpenModal(url);
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<% if readnotice.FResultCount > 0 then %>
					<div class="noticeView">
						<%
						'// 유효기간이 지난 글은 브라인드 처리 (2008-01-17;허진원 추가)
						if readnotice.FOneItem.Fyuhyostart<=cStr(date()) and readnotice.FOneItem.Fyuhyoend>=cStr(date()) or GetLoginUserLevel=7 then
						%>				
							<h3>
								<%= readnotice.FOneItem.Ftitle %>
	
								<% IF readnotice.FOneItem.IsNewNotics THEN %>
									<img src="http://fiximage.10x10.co.kr/m/2013/common/ico_new_red.png" width="13" height="13" alt="NEW" style="width:13px; height:13px;" />
								<% end if %>
							</h3>
							<div class="substance">
								<%= nl2br(readnotice.FOneItem.Fcontents) %>
							</div>
						<% else %>
							<h3>공지기간이 아직 안되었거나 이미 지난 글입니다.</h3>
							<div class="substance">
							</div>
						<% end if %>
					</div>
				<% end if %>

				<div class="btnList">
					<a href="/common/news.asp?type=<%= ntype%>">목록보기</a>
				</div>
			</div>
			<!-- //content area -->

			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->