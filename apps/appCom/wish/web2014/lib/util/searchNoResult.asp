<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
dim lp

dim filter : filter = request("filter")
dim oJsonResult

Dim vDisp : vDisp =  getNumeric(request("disp"))
Dim makerid : makerid = requestCheckVar(request("brandid"),32)
dim DocSearchText : DocSearchText = requestCheckVar(request("rect"),32)
Dim minPrice : minPrice = getNumeric(requestCheckVar(request("minPrc"),8))
Dim maxPrice : maxPrice = getNumeric(requestCheckVar(request("maxPrc"),8))
Dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
Dim deliType : deliType = requestCheckVar(request("deliType"),2)

Dim ReSearchText : ReSearchText = requestCheckVar(request("rstxt"),2)
dim sortMtd
    
Dim isFilterExists : isFilterExists=false
if (filter<>"") then
    On Error Resume Next  ''2015/10/13 추가
    set oJsonResult = JSON.parse(filter)
    ''call getParseFilterPop(oJsonResult, minPrice, maxPrice, colorCD, deliType)
    call getParseFilterV3(oJsonResult,sortMtd, minPrice, maxPrice, colorCD, vDisp, DocSearchText, makerid, deliType, ReSearchText)
	set oJsonResult = Nothing
	On Error Goto 0
	
	isFilterExists = (minPrice>0) or (maxPrice>0) or (colorCD<>"") or (deliType<>"") or (ReSearchText<>"")
end if



%>
<style type="text/css">
.resultNoMsgV15 {padding:84px 0 90px 0; text-align:center;}
.resultNoMsgV15 .msgFaceV15 {margin:0 auto; width:105px; height:105px; border-radius:50%; border:5px solid #282222; background:url(http://fiximage.10x10.co.kr/m/2015/common/ico_face.png) 50% 50% no-repeat; background-size:50%;}
.noMsgTxt1V15 {margin-top:18px; font-size:18px; color:#000;}
.noMsgTxt2V15 {margin-top:9px; font-size:12px; color:#999; line-height:1.2;}
.howPdtV15 {padding:10px 10px 35px 10px;}
.howPdtV15 .tit01 {font-size:14px;}
.howPdtV15 .pdtListWrap {margin-top:-12px;}
.howPdtV15 .pdtList {background:none;}
.bestsellerV15 {padding:10px 10px 70px 10px;}
.bestsellerV15 h2 {font-size:14px; font-weight:bold;}
.bestsellerV15 .pdtListWrap {margin-top:8px; border-top:2px solid #000;}
.bestsellerV15 .pdtList li {display:table; overflow:hidden; position:relative; float:none; width:100%; padding:9px 18px 10px 43px;}
.bestsellerV15 .pdtList li strong {position:absolute; left:12px; top:50%; width:20px; height:16px; margin-top:-8px; font-size:20px; font-family:helveticaNeue, helvetica, sans-serif !important; font-weight:normal; color:#676767;}
.bestsellerV15 .pdtList li .pPhoto {display:table-cell; width:60px; height:60px; border-radius:50%;}
.bestsellerV15 .pdtList li .pPhoto img {border-radius:50%;}
.bestsellerV15 .pdtList li .pdtCont {display:table-cell; padding-left:9px; vertical-align:middle;}
.bestsellerV15 .pdtList li .pdtCont .pName {-webkit-line-clamp:1; height:14px; padding-top:0; line-height:1.2;}

@media all and (min-width:480px){
	.resultNoMsgV15 {padding:126px 0 135px 0;}
	.resultNoMsgV15 .msgFaceV15 {width:157px; height:157px; border:7px solid #282222;}
	.noMsgTxt1V15 {margin-top:27px; font-size:27px;}
	.noMsgTxt2V15 {margin-top:13px; font-size:18px;}
	.howPdtV15 {padding:15px 15px 52px 15px;}
	.howPdtV15 .tit01 {font-size:21px;}
	.howPdtV15 .pdtListWrap {margin-top:-18px;}
	.bestsellerV15 {padding:15px 15px 115px 15px;}
	.bestsellerV15 h2 {font-size:21px;}
	.bestsellerV15 .pdtListWrap {margin-top:12px; border-top:3px solid #000;}
	.bestsellerV15 .pdtList li {padding:13px 27px 15px 64px;}
	.bestsellerV15 .pdtList li strong {left:18px; width:30px; height:24px; margin-top:-12px; font-size:30px;}
	.bestsellerV15 .pdtList li .pPhoto {width:90px; height:90px;}
	.bestsellerV15 .pdtList li .pdtCont {padding-left:13px;}
	.bestsellerV15 .pdtList li .pdtCont .pName {height:21px;}
}
</style>
<script type='text/javascript'>
function researchApp(irect){
    location.href='tenwishapp://App_search?rect='+encodeURIComponent(irect);
    //location.href='tenwishapp://App_search?rect='+(irect);
}
</script>
</head>
<body>
<div class="heightGrid bgGry" style="height:auto !important;">
	<div class="container popWin searchV15 schResultV15">
		

		<!-- content area -->
		<div class="content" id="contentArea">
		<!-- 검색 결과 -->
			
		<div class="resultNoMsgV15">
			<div class="msgFaceV15"></div>
			<p class="noMsgTxt1V15"><strong>흠… <span class="cRd1">검색결과</span>가 없습니다.</strong></p>
			<p class="noMsgTxt2V15">해당 상품이 품절 되었을 경우<br />검색이 되지 않습니다.</p>
			
			<% if (isFilterExists) then %>
    			<% if (DocSearchText<>"") or (vDisp<>"") or (makerid<>"") then %>
    			<p>
    			<% if (DocSearchText<>"") then %>
    			<!--
    			<span class="button btM1 btRed cWh1 w90p tMar30" onClick="location.href='tenwishapp://App_search?rect=<%=DocSearchText%>'"><a>상세검색 설정 초기화</a></span>
    			-->
    			<span class="button btM1 btRed cWh1 w90p tMar30" onClick="researchApp('<%=DocSearchText%>');"><a>상세검색 설정 초기화</a></span>
    			
    			<% elseif (makerid<>"") then  %>
    			<span class="button btM1 btRed cWh1 w90p tMar30" onClick="location.href='tenwishapp://App_brand?brandid=<%=makerid%>'"><a>상세검색 설정 초기화</a></span>    
    			<% else %>
    			<span class="button btM1 btRed cWh1 w90p tMar30" onClick="location.href='tenwishapp://App_category?categoryid=<%=vDisp%>'"><a>상세검색 설정 초기화</a></span>
    		    <% end if %>
    		    <% end if %>
    		<% end if %>
		</div>

		<%
        '#######################################################
        '	History	:  2015.06.15 허진원 생성
        '	Description : 베스트셀러
        '                 검색결과가 없을때 BEST순(itemscroe) 상품 목록
        '#######################################################
        
        	'// 베스트 상품 접수
        	Dim oKDoc
        	set oKDoc = new SearchItemCls
        	oKDoc.FRectSortMethod	= "be"			'Best순
        	oKDoc.FRectSearchCateDep = "T"
        	oKDoc.FRectSearchItemDiv = "y"
        	oKDoc.FCurrPage = 1
        	oKDoc.FPageSize = 10
        	oKDoc.FScrollCount = 0
        	oKDoc.FListDiv = "bestlist"
        	oKDoc.FSellScope="Y"
        	oKDoc.FRectSearchFlag = "n"
        	'oKDoc.FminPrice	= "6000"			'최소 금액제한
        
        	oKDoc.getSearchList
        
        	if oKDoc.FResultCount>0 then
        %>
        <div class="bestsellerV15">
        	<h2>텐바이텐 <span class="cRd1">베스트셀러</span></h2>
        	<div class="pdtListWrap">
        		<ul class="pdtList">
        		<% For lp=0 To (oKDoc.FResultCount-1) %>
        			<li onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=oKDoc.FItemList(lp).FItemid%>');">
        				<strong <%=chkIIF(lp<3,"class=""cRd1""","")%>><%=Num2Str(lp+1,2,"0","R")%></strong>
        				<div class="pPhoto"><img src="<%= getThumbImgFromURL(oKDoc.FItemList(lp).FImageBasic,286,286,"true","false") %>" alt="<% = oKDoc.FItemList(lp).FItemName %>" /></div>
        				<div class="pdtCont">
        					<p class="pName"><%=oKDoc.FItemList(lp).FItemName%></p>
        					<p class="pPrice"><%=FormatNumber(oKDoc.FItemList(lp).GetCouponAssignPrice,0)%>원
        						<% if oKDoc.FItemList(lp).IsSaleItem or oKDoc.FItemList(lp).isCouponItem Then %>
        							<% IF oKDoc.FItemList(lp).IsSaleItem then %>
        							<span class="cRd1">[<%=oKDoc.FItemList(lp).getSalePro%>]</span>
        							<% End If %>
        							<% IF oKDoc.FItemList(lp).IsCouponItem Then %>
        							<span class="cGr1">[<%=oKDoc.FItemList(lp).GetCouponDiscountStr%>]</span>
        							<% End If %>
        						<% End If %>
        					</p>
        				</div>
        			</li>
        		<% Next %>
        		</ul>
        	</div>
        	<div class="btnWrap tPad20">
        		<div class="ct" onClick="fnAPPpopupBest_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/award/awarditem.asp');return false;"><span class="button btB1 btRed cWh1 w90p"><a>더보기</a></span></div>
        	</div>
        </div>
        <%
        	End if
        
        	set oKDoc = Nothing
        %>
    <!-- //content area -->
	</div>
</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->