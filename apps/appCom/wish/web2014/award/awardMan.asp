<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim flag, atype, vDisp, chkCnt
vDisp = RequestCheckVar(request("disp"),3)
flag = RequestCheckVar(request("flag"),1)
atype = RequestCheckVar(request("atype"),1)
dim CurrPage : CurrPage = getNumeric(request("cpg"))
if CurrPage="" then CurrPage=1
'If atype = "" Then atype = "n"  'n 기본값
If atype = "" Then atype = "f"  'n 기본값
dim minPrice: minPrice=4500		'검색 최저가

Dim oaward, i, iLp, sNo, eNo, tPg

set oaward = new CAWard
	oaward.FPageSize = 10
    oaward.FCurrPage 		= 1
	oaward.GetManItemList

If (oaward.FResultCount < 3) Then
	''oaward.FRectCDL = vDisp  ''??
	''oaward.GetNormalItemList5down
	
	set oaward = Nothing
	set oaward = new SearchItemCls
		oaward.FListDiv 			= "bestlist"
		oaward.FRectSortMethod	    = "be"
		''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
		oaward.FPageSize 			= 50
		oaward.FCurrPage 			= 1
		oaward.FSellScope			= "Y"
		oaward.FScrollCount 		= 1
		oaward.FRectSearchItemDiv   ="D"
		oaward.FRectCateCode		= vDisp
		oaward.FminPrice	= minPrice
		oaward.getSearchList
End if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type='text/javascript'>

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavoritePrd(iitemid){
	<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1)%>
	   fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=4",'','wishfolder');
	<% Else %>
		calllogin();
		return false;
	<% End If %>
}

// Wish Cnt 증가
function FnPlusWishCnt(iid) {
	var vCnt = $("#wish"+iid).html();
	if(vCnt=="") vCnt=0;
	vCnt++;
	$("#wish"+iid).html(vCnt);
}


var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())*0.85){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_awardMan.asp?atype=<%=trim(atype)%>&disp=<%=vDisp%>&cpg="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrBestList").append(message);
							if (vPg>=5)
							{
								$("#PrBest15").show();
							}
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});

	//급상승 상품
	$(".bestUpV15 .ranking").append("<em>급상승</em>");
	// Top버튼 위치 이동
	$(".goTop").addClass("topHigh");

});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container" style="background-color:#e7eaea;">
		<!-- content area -->
		<div class="content" id="contentArea">
			<ul class="commonTabV16a">
				<li class="" name="tab01" style="width:25%;" onclick="location.replace('awardVIP.asp');return false;">VIP</li>
				<li class="current" name="tab02" style="width:25%;" onclick="location.replace('awardMan.asp');return false;">MAN</li>
				<li class="" name="tab03" style="width:25%;" onclick="location.replace('awardBrand.asp');return false;">BRAND</li>
				<li class="" name="tab04" style="width:25%;" onclick="location.replace('awardSteady.asp');return false;">STEADY</li>
			</ul>
			<!-- MAN BEST -->
			<div class="manBestV15">
				<div class="bestListV15 inner5">
					<ul id="lyrBestList">
						<%' for dev msg : 1위~3위까지 클래스 topRankV15/ 급상승 상품은 클래스 bestUpV15 붙여주세요 %>
						<%
						if CurrPage=1 then
							sNo=0
							eNo=9
						else
							sNo=(CurrPage-1) * 10
							eNo=(CurrPage * 10)-1
						end if

						if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

						tPg = (oaward.FResultCount\10)
						if (tPg<>(oaward.FResultCount/10)) then tPg = tPg +1

						If oaward.FResultCount > sNo Then
					  		If oaward.FResultCount Then
						%>

						<% For i=sNo to eNo %>
						<li class="<%=CHKIIF(oaward.FItemList(i).IsSoldOut,"soldOut","")%> <%=chkIIF((i+1)<4,"topRankV15","")%> <% If oaward.FItemList(i).GetLevelUpCount > "29" then response.write " bestUpV15" %>">
							<div class="pPhoto" onclick="fnAPPpopupProduct('<%=oaward.FItemList(i).FItemID%>');"><p><span><em>품절</em></span></p><img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="<%=oaward.FItemList(i).FItemName %>" /></div>
							<div class="pdtCont">
								<p class="ranking"><span><%= i+1 %></span></p>
								<p class="pBrand"><%=oaward.FItemList(i).FBrandName %></p>
								<p class="pName" onclick="fnAPPpopupProduct('<%=oaward.FItemList(i).FItemID%>');"><%=oaward.FItemList(i).FItemName %></p>
								<% IF oaward.FItemList(i).IsSaleItem or oaward.FItemList(i).isCouponItem Then %>
									<% IF oaward.FItemList(i).IsSaleItem Then %>
										<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = oaward.FItemList(i).getSalePro %>]</span></p>
									<% End IF %>
									<% IF oaward.FItemList(i).IsCouponItem Then %>
										<% IF Not(oaward.FItemList(i).IsFreeBeasongCoupon() or oaward.FItemList(i).IsSaleItem) then %>
										<% End IF %>
										<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oaward.FItemList(i).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).getRealPrice,0) %><% if oaward.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
								<p class="pShare">
									<span class="cmtView"><%=FormatNumber(oaward.FItemList(i).FEvalcnt,0)%></span>
									<span class="wishView" id="wish<%=oaward.FItemList(i).FItemID%>" onclick="TnAddFavoritePrd('<%=oaward.FItemList(i).FItemID%>');"><%=FormatNumber(oaward.FItemList(i).FFavCount,0)%></span>
								</p>
							</div>
						</li>
						<% Next %>
						<%
							End If
						End If
						%>
					</ul>
				<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
				</div>
			</div>
			<!--// MAN BEST -->
		<!-- //content area -->
	</div>
</div>
<span id="gotop" class="goTop">TOP</span>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-16971867-10', 'auto');
  ga('require','displayfeatures');
  ga('require', 'linkid', 'linkid.js');
  ga('send', 'pageview');

</script>
</body>
</html>
<%
set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->