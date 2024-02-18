<%
Dim fc2, vCate2Img(5), vInspiImgCd, vInspiImgBody
If vCate = "21" Then
	vInspiImgCd = "4"
ElseIf vCate = "22" Then
	vInspiImgCd = "5"
End If

For fc2=1 To 5
	vCate2Img(fc2) = fnPlayImageSelectSortNo(vImageList,vCate,vInspiImgCd,"i","0",fc2)
Next

For fc2=1 To 5
	If vCate2Img(fc2) <> "" Then
		vInspiImgBody = vInspiImgBody & "<div class=""swiper-slide""><img src=""" & vCate2Img(fc2) & """ alt="""" /></div>" & vbCrLf
	End If
Next
%>
<article class="playDetailV16 inspiration">
	<div class="hgroup">
		<div>
			<a href="list.asp?cate=inspi" class="corner">!NSPIRATION</a>
			<h2><%=vTitle%></h2>
		</div>
	</div>
	<div class="cont">
		<div class="detail">
			<div id="rolling" class="swiperFull">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<%=vInspiImgBody%>
					</div>
					<button type="button" class="btnNav btnPrev">이전</button>
					<button type="button" class="btnNav btnNext">다음</button>
				</div>
				<div class="paginationDot"></div>
			</div>
			<% If vInspiImgBody <> "" Then %>
			<script type="text/javascript">
				$(function(){
					/* swiper js */
					if ($("#rolling .swiper-container .swiper-slide").length > 1) {
							var swiper1 = new Swiper("#rolling .swiper-container", {
							pagination:"#rolling .paginationDot",
							paginationClickable:true,
							autoplay:3000,
							loop:true,
							speed:1500,
							effect:"fade",
							nextButton:"#rolling .btnNext",
							prevButton:"#rolling .btnPrev",
							onSlideChangeStart: function () {
								$("#rolling .btnNext").show();
								$("#rolling .btnPrev").show();
							}
						});
					} else {
						$("#rolling .btnNext").hide();
						$("#rolling .btnPrev").hide();
						$("#rolling .paginationDot").hide();
						var swiper1 = new Swiper("#rolling .swiper-container", {
							pagination:false,
							noSwipingClass:".noswiping",
							noSwiping:true
						});
					}
				});
			</script>
			<% End If %>
			<div class="textarea">
				<p><%=Replace(vSubCopy,vbCrLf,"<br>")%></p>
				<p class="pageview"><b><%=FormatNumber(vViewCntW+vViewCntM+vViewCntA,0)%>명</b>이 이 페이지를 보았습니다.</p>
			</div>
		</div>
		<%
		Dim cCa2item
		SET cCa2item = New CPlay
		cCa2item.FRectDIdx = vDIdx
		cCa2item.fnPlayItemList
		
		If cCa2item.FResultCount > 0 Then
		%>
		<div class="listItemV16">
			<h3>관련 상품 보기</h3>
			<ul>
				<% For fc2 = 0 To cCa2item.FResultCount - 1 %>
				<li>
					<a href="javascript:fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=cCa2item.FItemList(fc2).FItemID%>&gaparam=playing_<%=vCate%>_<%=vDIdx%>');">
						<div class="pPhoto"><img src="<%=cCa2item.FItemList(fc2).FIcon2Image %>" alt="" /></div>
						<div class="pdtCont">
							<p class="pBrand"><%=cCa2item.FItemList(fc2).FBrandName%></p>
							<p class="pName"><%=cCa2item.FItemList(fc2).FItemName%></p>
							<div class="pPrice"><% = FormatNumber(cCa2item.FItemList(fc2).getRealPrice,0) %>원 <%=CHKIIF(cCa2item.FItemList(fc2).IsSaleItem,"["&cCa2item.FItemList(fc2).getSalePro&"]","")%></div>
						</div>
					</a>
				</li>
				<% Next %>
			</ul>
		</div>
		<%
		End If
		SET cCa2item = Nothing %>
		<!-- #include file="./inc_sns.asp" -->
		<div class="listMore">
			<div class="more">
				<h2>다른 !NSPIRATION 보기</h2>
				<a href="list.asp?cate=inspi">more</a>
			</div>
			<!-- #include file="./inc_listmore.asp" -->
		</div>
	</div>
</article>