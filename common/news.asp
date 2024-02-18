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
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/BoardNoticecls.asp" -->

<%
'해더 타이틀
strHeadTitleName = "공지사항"

dim oBoardNotice, noticeFix, ntype, iPg, page, ibb, iTotCnt
	page = requestCheckVar(request("page"),9)
	ntype = requestCheckVar(request("type"),2)			'(A: 전체, E:당첨안내, 01:전체공지,02:상품공지,03:이벤트공지,04:배송공지,05:당첨자공지,06:CultureStation)

if page = "" then page=1
if ntype="" then ntype="A"

'// 공지사항 목록
set oBoardNotice = New cBoardNotice
	oBoardNotice.FRectNoticeOrder =7
	oBoardNotice.FPageSize = 8
	oBoardNotice.FCurrPage = page
	oBoardNotice.FRectNoticetype = ntype
	oBoardNotice.FScrollCount = 5
	oBoardNotice.getNoticsList

	iTotCnt = oBoardNotice.FTotalCount
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%=chkIIF(ntype="E","이벤트 당첨자","공지사항")%></title>
<script type="text/javascript">

function goPage(page){
	location.href = "/common/news.asp?page="+page+"&type=<%=ntype%>";
}
</script>
</head>
<body>
<div class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<div class="">
			<div class="tab01 noMove">
				<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
					<ul class="grid2">
						<li><a href="/common/news.asp?type=A" <% if ntype="A" then response.write " class='on'" %>>공지사항<span></span></a></li>
						<li><a href="/common/news.asp?type=E" <% if ntype="E" then response.write " class='on'" %>>이벤트 당첨자<span></span></a></li>
					</ul>
				</div>
				<% if oBoardNotice.FResultCount > 0 then %>
				<div>
					<div class="categoryListup bMar20">
						<ul class="noticeList">
							<% for ibb=0 to oBoardNotice.FResultCount -1 %>
							<li>
								<a href="/common/news_view.asp?type=<%=ntype%>&idx=<%= oBoardNotice.FItemList(ibb).Fid %>"><%= chrbyte(oBoardNotice.FItemList(ibb).Ftitle,60,"Y") %>
								<% IF oBoardNotice.FItemList(ibb).IsNewNotics THEN %>
									<img src="http://fiximage.10x10.co.kr/m/2013/common/ico_new_red.png" width="13" height="13" alt="NEW" style="width:13px; height:13px;" />
								<% end if %>
								</a>
							</li>
							<% next %>
						</ul>
	
						<%=fnDisplayPaging_New(page,iTotCnt,8,4,"goPage")%>
					</div>
				</div>
				<% Else %>
				<div class="nodata nodata-default">
					<p><b>해당되는 내용이 없습니다.</b></p>
				</div>
				<% end if %>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->