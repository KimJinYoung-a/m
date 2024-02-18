<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.charset = "utf-8"
%>
<%
'####################################################
' Description :  공지사항
' History : 2019-04-17 최종원 생성
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
	ntype = requestCheckVar(request("type"),2)

if page = "" then page=1

'// 공지사항 목록
set oBoardNotice = New cBoardNotice
	oBoardNotice.FRectNoticeOrder =7
	oBoardNotice.FPageSize = 10
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
	location.href = "index.asp?page="+page+"&type=<%=ntype%>";
}
function handleSelect(type){    
    location.href = "index.asp?type="+type;
}
</script>
</head>
<body>
<div class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
        <h2 class="hidden">공지사항 리스트</h2>
		<div  class="news-list">
            <div class="sortingbar ">
                <div class="option-left">
                    <p class="total">총<b><%=FormatNumber(oBoardNotice.FTotalCount, 0)%></b>건</p>
                </div>
				<div class="option-right">
                    <div class="styled-selectbox styled-selectbox-default">
						<select name="type" class="select" title="카테고리 선택옵션" onchange="handleSelect(this.value)">
							<option <%=chkIIF(ntype="", "selected=""selected""", "")%>  value="">전체</option><!-- 디폴트 : 전체 -->
                            <option <%=chkIIF(ntype="02", "selected=""selected""", "")%> value="02">안내</option>
                            <option <%=chkIIF(ntype="04", "selected=""selected""", "")%> value="04">배송</option>
                            <option <%=chkIIF(ntype="05", "selected=""selected""", "")%> value="05">당첨자</option>
                            <option <%=chkIIF(ntype="03", "selected=""selected""", "")%> value="03">이벤트</option>
                            <option <%=chkIIF(ntype="06", "selected=""selected""", "")%> value="06">컬쳐스테이션</option>                            
                        </select>
                    </div>
                </div>
            </div>
            <% if oBoardNotice.FResultCount > 0 then %>            
            <ul>
                <!-- 리스트 10개씩 노출 -->
                <% for ibb=0 to oBoardNotice.FResultCount -1 %>
                <li>
                    <a href="news_view.asp?type=<%=ntype%>&idx=<%= oBoardNotice.FItemList(ibb).Fid %>&page=<%=page%>"><p><%= chrbyte(oBoardNotice.FItemList(ibb).Ftitle,60,"Y") %></p>
                        <span><%=FormatDate(oBoardNotice.FItemList(ibb).Fyuhyostart,"0000.00.00")%></span>
                    </a>
                </li>       
                <% next %>       
            </ul>            
            <%=fnDisplayPaging_New(page,iTotCnt,10,4,"goPage")%>            
            <% end if %>            
        </div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->