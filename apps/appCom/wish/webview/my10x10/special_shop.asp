<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual ="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual ="/lib/classes/shopping/specialshopitemcls.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
'####### 회원등급 재조정 #######
Call getDBUserLevel2Cookie()
'####### 회원등급 재조정 #######

Dim iTotCnt
Dim iPageSize, iCurrpage ,iDelCnt
Dim iStartPage, iEndPage, iTotalPage, iPerCnt
Dim i,j, ix, userlevel, userLevelUnder, ospecialshop, iCols, iRows, vTitle, vSDate, vEDate

	iCurrpage = NullFillWith(requestCheckVar(Request("iC"),10),1)	'현재 페이지 번호
	iPageSize = 10		'한 페이지의 보여지는 열의 수
	iPerCnt   = 3		'보여지는 페이지 간격

	userlevel = GetLoginUserLevel
	'### 레벨이 없거나, 오렌지(5)거나, 옐로우(0), 그린(1) 일때 0으로 지정. 블루(2),VIP(3),Staff(7),Mania(4),Friends(8)
	If userlevel = "" OR userlevel = 5 OR userlevel = 0 OR userlevel = 1 Then
		userlevel = 0
	End If

	set ospecialshop = new CSpecialShop
	If userlevel > 0 Then
		ospecialshop.FNowDate = date()
		ospecialshop.GetSpecialShopInfo
		vTitle = ospecialshop.Ftitle
		vSDate = ospecialshop.Fsdate
		vEDate = ospecialshop.Fedate
		
		ospecialshop.FCurrPage = iCurrpage
		ospecialshop.FPageSize = iPageSize
		ospecialshop.FRectUserLevelUnder = userlevel
		ospecialshop.GetSpecialItemList
		iTotCnt = ospecialshop.FTotalCount

		iCols=1
		iRows = CLng(ospecialshop.FResultCount / iCols)

		iTotalPage =   int((iTotCnt-1)/iPageSize) +1
	End If
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
	function goPage(page){
		frm.iC.value=page;
		frm.submit();
	}
</script>
</head>
<body class="event">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #content -->
		<form name="frm" method="get" action="">
		<input type="hidden" name="iC" value="">
		</form>
        <div id="content">
        	<% If IsSpecialShopUser() AND vTitle <> "" Then %>
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">우수회원샵</span></h1>
                </div>
                <div class="diff"></div>
                <% If IsSpecialShopUser() AND vTitle <> "" Then
                	Dim vCSS
                	SELECT Case userlevel
                		Case 2 : vCSS = "blue2"
                		Case 3 : vCSS = "silver"
                		Case 4 : vCSS = "gold"
                		Case 7 : vCSS = "red"
                		Case 8 : vCSS = "family"
                	End SELECT
                %>
                <div class="t-c"><strong><%=GetLoginUserID()%></strong>님은 <strong class="<%=vCSS%>"><%=GetUserLevelStr(userlevel)%></strong> 회원입니다.</div>
                <div class="diff"></div>
                <% End If %>
            </div>
            <div class="well type-b type-tb">
                <ul class="txt-list blt-red">
                    <li><strong>이번주 테마 -</strong> <span class="blue3">[<%=vTitle%>]</span></li>
                    <li><strong>할인기간 -</strong> <%=Replace(vSDate,"-",".")%> ~ <%=Right(Replace(vEDate,"-","."),5)%></li>
                </ul>
            </div>
			<% End If %>
            <div class="inner">
            	<% If userlevel > 0 Then %>
            		<% if iTotCnt = 0 then %>
            			<div class="no-data">판매중인 우수회원 상품이 없습니다.</div>
					<% else %>
						<ul class="product-list list-type-2">
						<% for j=0 to iRows-1 %>
		                    <li>
		                    	<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%= ospecialshop.FItemList(j).FItemID %>">
		                        <div class="product">
		                            <div class="product-img">
		                                <img src="<%=getThumbImgFromURL(ospecialshop.FItemList(j).FImageIcon2,"132","132","true","false")%>" alt="<%=Replace(ospecialshop.FItemList(j).FItemName,chr(34),"")%>" width="132" height="132">
		                            </div>
		                            <div class="product-spec">
		                                <div class="product-brand"><%= ospecialshop.FItemList(j).FBrandName %></div>
		                                <div class="product-name"><%= ospecialshop.FItemList(j).FItemName %></div>
		                                <div class="product-price">
		                                	<strong><%=FormatNumber(ospecialshop.FItemList(j).getRealPrice,0)%></strong>원 <span class="discount"><%=ospecialshop.FItemList(j).getSalePro%>↓</span>
		                                </div>
		                                <div class="featured">
											<% IF ospecialshop.FItemList(j).IsSoldOut Then %>
												<span class="only">품절</span>
											<% Else %>
												<% if ospecialshop.FItemList(j).isCouponItem Then %><span class="coupon">쿠폰</span><% End If %>
												<% IF ospecialshop.FItemList(j).isLimitItem Then %><span class="limited">한정</span><% End If %>
												<% IF ospecialshop.FItemList(j).isNewItem Then %><span class="new">NEW</span><% End If %>
												<% IF ospecialshop.FItemList(j).IsSaleItem THEN %><span class="sale">SALE</span><% End If %>
												<% IF ospecialshop.FItemList(j).IsSoldOut Then %><span class="only">품절</span><% End If %>
											<% End if %>
		                                </div>
		                                <div class="product-meta">
		                                    <span class="comment"><%=ospecialshop.FItemList(i).FEvalCnt%></span>
		                                    <span class="love"><%=ospecialshop.FItemList(i).FFavCount%></span>
		                                </div>
		                            </div>
		                            <div class="clear"></div>
		                        </div>
		                        </a>
		                    </li>
						<% next %>
						</ul><!-- product-list -->
					<% end if %>
				<% Else %>
					<div class="no-data">죄송합니다.<br />우수회원샵의 혜택은 <strong class="blue2">블루회원</strong>부터 적용됩니다.</div>
				<% End If %>
				
				<% IF iTotCnt > 0 THEN %>
                <%=fnDisplayPaging_New(iCurrpage,iTotCnt,iPageSize,"10","goPage")%>
                <% End If %>
                <div class="diff"></div>
            </div>
            <br>
        </div>
        <!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer>
        <!-- #footer -->
        
    </div>
    <!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
	set ospecialshop = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->