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
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/searchCls.asp" -->
<%
Dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
dim page 		: page = request("cpg")
dim SortMet		: SortMet = request("srm")
dim dispCate 	: dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
dim lp, i

'// 실제 타자로 입력된 검색어인지(2013-08-02 13:08:50 적용)
Dim IsRealTypedKeyword : IsRealTypedKeyword = True
If requestCheckVar(request("exkw"),1) = "1" Then
	IsRealTypedKeyword = False
End If

Dim tmpPrevSearchKeyword , tmpCurrSearchKeyword 
If page = "" Then page = 1
If SortMet = "" Then SortMet = 1

SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\s]","")
ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\s]","")

tmpCurrSearchKeyword = SearchText

If IsRealTypedKeyword Then
	Call procMySearchKeyword(tmpCurrSearchKeyword)
End If 

'// 상품검색
Dim oDoc,iLp
set oDoc = new CSearchItemCls
	oDoc.FCurrPage 			= page
	oDoc.FPageSize 			= 6
	oDoc.FRectSearchTxt		= SearchText
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectCateCode		= dispCate
	oDoc.getSearchList
%>
<script type="text/javascript">
var ppage = 1;
    
function paging_ajax(){
	var chkItem = 0;
    // 1페이지일경우 2페이지로 변경
    if( $("#searchForm input[name='cpg']").val()=="1" ){
    	$("#searchForm input[name='cpg']").val(2);
    }
	//페이지가 같은경우 리턴시킴.. 이중클릭방지
    if ( ppage==$("#searchForm input[name='cpg']").val() ) {
    	return;
    }
	if ( $("#searchForm input[name='cpg']").val() > <%= oDoc.FtotalPage %>){
		alert('페이지의 끝입니다');
		return;
	}

	var str = $.ajax({
			type: "GET",
	        url: "/apps/appCom/between/search/result_ajax.asp",
	        data: {"cpg":$("#searchForm input[name='cpg']").val(), "rect":"<%=SearchText%>", "srm":"<%=SortMet%>", "dispCate":"<%= dispCate %>"},
	        dataType: "text",
	        async: false
	}).responseText;
	if(str!="") {
		$('#lySearchResult').append(str);
		ppage=$("#searchForm input[name='cpg']").val();
		//현재 페이지와 총페이지가 같다면 버튼 숨긴다.
		if ( ppage == <%= oDoc.FtotalPage %>){
			$('.listAddBtn').hide();
		}
		//다음 열릴 페이지 셋팅
		var pg = $("#searchForm input[name='cpg']").val();
		pg++;
		$("#searchForm input[name='cpg']").val(pg);
    }
}
function goSelectPage(s1){
	document.location.replace('result.asp?cpg=1&rect=<%=SearchText%>&srm='+s1+'&dispCate=<%=dispCate%>');
}
function goSelectPage2(s2){
	document.location.replace('result.asp?cpg=1&rect=<%=SearchText%>&srm=<%=SortMet%>&dispCate='+s2+'');
}
</script>
</head>
<body>
<div class="wrapper" id="">
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="searchResult">
				&apos;<strong><%=SearchText%></strong>&apos; (검색결과 <em class="txtBtw"><%= oDoc.FTotalCount %></em>)
			</div>
			<form action="/apps/appCom/between/search/result.asp" name="searchForm" id="searchForm" method="get">
			<input type="hidden" name="cpg" value=1>
			<input type="hidden" name="rect" value="<%= SearchText %>">
			<div class="sorting">
				<div class="option">
					<%= fnBetweenSelectBox("1", "", "dispCate", dispCate, "onchange=goSelectPage2(this.value);") %>
				</div>
				<div class="option">
					<select name="srm" title="상품별 정렬" onchange="goSelectPage(this.value);")>
						<option value="1" <%= Chkiif(SortMet="1", "selected", "") %>>인기상품순</option>
						<option value="2" <%= Chkiif(SortMet="2", "selected", "") %>>신상품순</option>
						<option value="3" <%= Chkiif(SortMet="3", "selected", "") %>>가격높은순</option>
						<option value="4" <%= Chkiif(SortMet="4", "selected", "") %>>가격낮은순</option>
						<option value="5" <%= Chkiif(SortMet="5", "selected", "") %>>높은할인율순</option>
					</select>
				</div>
			</div>
			</form>

		<% If oDoc.FResultCount > 0 Then %>
			<div class="pdtListWrap">
				<ul class="pdtList list03" id="lySearchResult">
				<% For i = 0 To oDoc.FResultCount - 1 %>
					<li>
						<div <% If oDoc.FItemlist(i).IsSoldOut Then %> class="soldout" <% Else %><% IF oDoc.FItemlist(i).isSaleItem then %> class="sale"<% End If %><% End If %> >
							<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oDoc.FItemlist(i).FItemID%>&dispCate=<%=dispCate%>">
								<p class="pdtPic"><img src="<% = oDoc.FItemlist(i).FImageList %>" alt="<% = oDoc.FItemlist(i).FItemName %>" /></p>
								<p class="pdtName"><% = oDoc.FItemlist(i).FItemName %></p>
								<p class="price">
								<%
									If oDoc.FItemlist(i).IsSaleItem Then
										IF oDoc.FItemlist(i).IsSaleItem Then
											Response.Write FormatNumber(oDoc.FItemlist(i).getRealPrice,0) & "원"
										End IF
									Else
										Response.Write FormatNumber(oDoc.FItemlist(i).getRealPrice,0) & "원"
									End If
								%>
								</p>
							<% If oDoc.FItemlist(i).isSaleItem Then %>
								<p class="pdtTag saleRed"><%=oDoc.FItemlist(i).getSalePro%></p>
							<% End If %>
							<% If oDoc.FItemlist(i).IsSoldOut Then %>
								<p class="pdtTag soldOut">품절</p>
							<% End If %>
							</a>
						</div>
					</li>
				<% Next %>
				</ul>
			<% If oDoc.FTotalpage > 1 Then  %>
				<div class="listAddBtn">
					<a href="" onclick="paging_ajax(); return false;">상품 더 보기</a>
				</div>
			<% End If %>
			</div>
		<% Else %>
			<div class="searchNoresult">
				<p><strong class="txtBtwDk">검색결과가 없습니다.</strong></p>
				<p>해당상품이 품절 되었을 경우 검색이 되지 않습니다.</p>
			</div>
		<% End If %>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<% SET oDoc = Nothing %>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->