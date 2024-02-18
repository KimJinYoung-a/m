<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : 웨딩 기획전 MA
' History : 2017-10-10 유태욱 생성
'#############################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/util/htmllib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/event72792Cls.asp" -->
<%
	Dim eCode, oItem, intI, cEventItem, iTotCnt
	dim userid, i, UserAppearChk, nowdate
	dim grcode1,  grcode2, grcode3, grcode4

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  67442
		grcode1 = 137221
		grcode2 = 137222
		grcode3 = 137223
		grcode4 = 137224
	Else
		eCode   =  80616
		grcode1 = 221411	'주방
		grcode2 = 221412	'거실
		grcode3 = 221413	'드레스룸
		grcode4 = 221414	'침구
	End If

	userid = GetEncLoginUserID()
	nowdate = Left(Now(), 10)
'																							nowdate = "2017-09-20"
%>
<style type="text/css">
img {vertical-align:top;}
.evtHeadV15 {display:none;}
.bigSale {position:relative;text-align:center;}
.bigSale .swiper-container {position:relative; padding-bottom:4.95rem;  background:#fed4c1 url(http://webimage.10x10.co.kr/eventIMG/2017/80616/m/bg_rolling.jpg) no-repeat 0 0 !important; background-size:100% !important;}
.bigSale .swiper-slide {position:relative; width:56%;}
.bigSale .swiper-slide .pic {overflow:hidden; border-radius:50%;}
.bigSale .swiper-slide .pic img {border:0.4rem solid #fff; border-radius:50%;}
.bigSale .swiper-slide .itemInfo p {position:relative; overflow:hidden; padding:2.56rem 0 1.11rem; font-size:1.2rem; font-weight:bold; text-overflow:ellipsis; white-space:nowrap; color:#333333;}
.bigSale .swiper-slide .itemInfo strong {font-size:1.2rem; color:#fe7261;}
.bigSale .swiper-slide .itemInfo strong span {display:inline-block; position:absolute; top:1.19rem; right:0; width:3.84rem; height:3.84rem; padding-top:1.35rem; background-color:#fe4b38; color:#fff; border-radius:50%;}
.bigSale .swiper-slide .itemInfo s {font-size:1.1rem; color:#7b7c65; font-weight:normal;}
.bigSale .slideNav {position:absolute; top:9.8rem; width:8.2%; background-color:transparent; z-index:50;}
.bigSale .slideNav.btnPrev {left:.5rem;}
.bigSale .slideNav.btnNext {right:.5rem;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper1 = new Swiper('.bigSale .swiper-container',{
		loop:true,
		autoplay:false,
		speed:500,
		slidesPerView:'auto',
		centeredSlides:true,
		spaceBetween:"8%",
		pagination:false,
		nextButton:'.bigSale .btnNext',
		prevButton:'.bigSale .btnPrev'
	});
});

function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
//		parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}
</script>

	<!-- 웨딩 기획전 (모바일 메인) -->
	<div class="mEvt80616">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/tit_newly_day_v2.jpg" alt="신혼 하루" /></h2>
		<!-- BIG SALE -->
		<div class="bigSale">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/tit_big_sale.jpg" alt="매주 달라지는 특가! BIG SALE" /></h3>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<%
						Dim arritem , lp

						IF application("Svr_Info") = "Dev" THEN
							arritem = array(1163356,1163067,1169131,1171602,1172281)
						Else
							if date() < "2017-10-19" then
								arritem = array(1562806,1757631,1260092,1557519,1715454)
							elseif date() >= "2017-10-19" and date() < "2017-10-26" then
								arritem = array(1665813,1787590,1603439,1311289,1722666)
							elseif date() >= "2017-10-26" and date() < "2017-11-02" then
								arritem = array(1400713,1562807,1812399,1782462,256712)
							else
								arritem = array(1562806,1757631,1260092,1557519,1715454)
							end if
						End If
						
						For lp = 0 To 4

						set oItem = new CatePrdCls
							oItem.GetItemData arritem(lp)
					%>
					<div class="swiper-slide">
						<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=80616'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=80616">
						<% End If %>

							<div class="pic">
								<img src="<%= oItem.Prd.FImageBasic %>" alt="" />
							</div>
							<div class="itemInfo">
								<p><%= oItem.Prd.Fitemname %></p>
								<%'' 세일일때 아닐떄 체크 수정 %>
								<% if oItem.Prd.getSalePro <> "0%" then %>
									<strong><s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s> <%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %><span><%= oItem.Prd.getSalePro %></span></strong>
								<% else %>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								<% end if %>
							</div>
						</a>
					</div>
					<%
						Set oItem = Nothing
						Next
					%>

					<!-- 마지막 슬라이드는 하단 더보기 버튼 들어갑니다 -->
					<div class="swiper-slide">
						<a href="" onclick="goEventLink('80618'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_1week_sale.png" alt="단 일주일의 특가 상품 더 보러가기" />
						</a>
					</div>
				</div>
			</div>
			<button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_next.png" alt="다음" /></button>
		</div>
		<!--// BIG SALE -->

		<div class="sm-wd"><a href=""  onclick="goEventLink('80617'); return false;"  class="bnr-sm-wed"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/bnr_sm_wd.jpg" alt="스몰웨딩 기획전 바로가기" /></a></div>

		<!-- 이벤트1, 2  -->
		<div class="evt1">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/txt_evt1.jpg" alt="Wedding Membership 결혼을 앞 둔 두 사람은 어떻게 만났나요? 두 분의 이야기를 코멘트로 남겨주세요. 추첨을 통해 20분을 추첨하여 연희동 사진관 흑백사진 촬영권을 선물로 드립니다.  이벤트 기간 : 10.12 ~ 11.01 당첨자 발표 : 11.03 (월)" /></p>
			<a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_cmt_evt.jpg" alt="코멘트 작성하러 가기" /></a>
		</div>
		<div class="evt2">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/txt_evt2.jpg" alt="어느 좋은 날에 결혼하시나요? 두 분의 청첩장을 등록해주세요. 텐바이텐에서 준비한 특별한 웨딩쿠폰 세트를 선물로 드립니다. 이벤트 기간 : 10.12 ~ 11.01" /></p>
			<a href="" onclick="goEventLink('80833'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_enroll.jpg" alt="청첩장 등록하기" /></a>
		</div>
		<!--// 이벤트1, 2  -->

		<!-- 신혼하루 -->
		<div class="newly-day">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/txt_newly.jpg" alt="신혼하루" /></h3>
			<div class="items type-grid">
				<!-- 주방 -->
				<!-- for dev msg 
					- 상품 10개씩 노출 부탁드립니다 (md전달 예정)
					- 하단 4개 기차에도 동일하게 적용 부탁드립니다.
				-->
				<h4><a href="" onclick="goEventLink('80615&eGc=219245'); return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_go1.jpg" alt="주방" /></a></h4>
				<ul>
				<%
				dim rstArrItemid: rstArrItemid=""
				dim iLp, vWishArr
				intI = 0

				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				cEventItem.FEGCode 	= grcode1
				cEventItem.FEPGsize 	= 10
'				cEventItem.Frectminnum= 11
'				cEventItem.Frectmaxnum= 20
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt

				'// 검색결과 내위시 표시정보 접수
				if IsUserLoginOK then
					'// 검색결과 상품목록 작성
					IF iTotCnt >= 0 then
						For iLp=0 To iTotCnt -1
							rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & cEventItem.FCategoryPrdList(intI).FItemID
						Next
					End if
					'// 위시결과 상품목록 작성
					if rstArrItemid<>"" then
			'			response.write getLoginUserid() &"//"& rstArrItemid &"//"&vWishArr
			'			response.end
						Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
					end if
				end if
				
				%>
				<% IF (iTotCnt >= 0) THEN %>
					<% For intI =0 To iTotCnt %>
						<li id="item">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=80616'); return false;">
								<div class="thumbnail"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="" />
									<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
										<b class="soldout">일시 품절</b>
									<% end if %>
								</div>
								<div class="desc">
									<span class="brand"><%= cEventItem.FCategoryPrdList(intI).FBrandName %></span>
									<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
									<div class="price">
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<div class="unit"><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><span class="won">원</span></b> <b class="discount color-red"><% = cEventItem.FCategoryPrdList(intI).getSalePro %></b></div>
									<% End IF %>
									
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<div class="unit"><%' if eItemListType <> "1" then %><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %><span class="won">원</span></b> <%' end if %><b class="discount color-green"><% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %><small>쿠폰</small></b></div>
									<% End IF %>
									
								<% Else %>
									<div class="unit"><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><span class="won"><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %>원<% end  if %></span></b></div>
								<% End if %>
									</div>
								</div>
							</a>
							<div class="etc">
								<% if cEventItem.FCategoryPrdList(intI).FEvalcnt > 0 then %>
									<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(cEventItem.FCategoryPrdList(intI).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(cEventItem.FCategoryPrdList(intI).FEvalcnt>999,"999+",cEventItem.FCategoryPrdList(intI).FEvalcnt)%></span></div>
								<% end if %>
								<button class="tag wish btn-wish" onclick="goWishPop('<%=cEventItem.FCategoryPrdList(intI).FItemid%>','<%=eCode%>');">
								<%
								If cEventItem.FCategoryPrdList(intI).FFavCount > 0 Then
									If fnIsMyFavItem(vWishArr,cEventItem.FCategoryPrdList(intI).FItemID) Then
										Response.Write "<span class=""icon icon-wish on"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
										Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
									Else
										Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
										Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
									End If
								Else
									Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&"""></span>"
								End If
								%>
								</button>
								<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem AND cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr = "무료배송" Then %>
									<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
								<% End If %>
							</div>
						</li>
					<% next %>
				<% end if %>
				<% set cEventItem = nothing %>
				</ul>
				<!--// 주방 -->

				<!-- 거실 -->
				<h4><a href="" onclick="goEventLink('80615&eGc=219253'); return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_go2.jpg" alt="거실" /></a></h4>
				<ul>
				<%
				intI = 0
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				cEventItem.FEGCode 	= grcode2
				cEventItem.FEPGsize 	= 10
'				cEventItem.Frectminnum= 11
'				cEventItem.Frectmaxnum= 20
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				'// 검색결과 내위시 표시정보 접수
				if IsUserLoginOK then
					'// 검색결과 상품목록 작성
					IF iTotCnt >= 0 then
						For iLp=0 To iTotCnt -1
							rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & cEventItem.FCategoryPrdList(intI).FItemID
						Next
					End if
					'// 위시결과 상품목록 작성
					if rstArrItemid<>"" then
			'			response.write getLoginUserid() &"//"& rstArrItemid &"//"&vWishArr
			'			response.end
						Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
					end if
				end if
				
				%>
				<% IF (iTotCnt >= 0) THEN %>
					<% For intI =0 To iTotCnt %>
						<li id="item">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=80616'); return false;">
								<div class="thumbnail"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="" />
									<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
										<b class="soldout">일시 품절</b>
									<% end if %>
								</div>
								<div class="desc">
									<span class="brand"><%= cEventItem.FCategoryPrdList(intI).FBrandName %></span>
									<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
									<div class="price">
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<div class="unit"><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><span class="won">원</span></b> <b class="discount color-red"><% = cEventItem.FCategoryPrdList(intI).getSalePro %></b></div>
									<% End IF %>
									
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<div class="unit"><%' if eItemListType <> "1" then %><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %><span class="won">원</span></b> <%' end if %><b class="discount color-green"><% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %><small>쿠폰</small></b></div>
									<% End IF %>
									
								<% Else %>
									<div class="unit"><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><span class="won"><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %>원<% end  if %></span></b></div>
								<% End if %>
									</div>
								</div>
							</a>
							<div class="etc">
								<% if cEventItem.FCategoryPrdList(intI).FEvalcnt > 0 then %>
									<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(cEventItem.FCategoryPrdList(intI).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(cEventItem.FCategoryPrdList(intI).FEvalcnt>999,"999+",cEventItem.FCategoryPrdList(intI).FEvalcnt)%></span></div>
								<% end if %>
								<button class="tag wish btn-wish" onclick="goWishPop('<%=cEventItem.FCategoryPrdList(intI).FItemid%>','<%=eCode%>');">
								<%
								If cEventItem.FCategoryPrdList(intI).FFavCount > 0 Then
									If fnIsMyFavItem(vWishArr,cEventItem.FCategoryPrdList(intI).FItemID) Then
										Response.Write "<span class=""icon icon-wish on"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
										Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
									Else
										Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
										Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
									End If
								Else
									Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&"""></span>"
								End If
								%>
								</button>
								<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem AND cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr = "무료배송" Then %>
									<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
								<% End If %>
							</div>
						</li>
					<% next %>
				<% end if %>
				<% set cEventItem = nothing %>
				</ul>
				<!--// 거실 -->
				<!-- 드레스룸 -->
				<h4><a href="" onclick="goEventLink('80615&eGc=219254'); return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_go3.jpg" alt="드레스룸" /></a></h4>
				<ul>
				<%
				intI = 0
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				cEventItem.FEGCode 	= grcode3
				cEventItem.FEPGsize 	= 10
'				cEventItem.Frectminnum= 11
'				cEventItem.Frectmaxnum= 20
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				'// 검색결과 내위시 표시정보 접수
				if IsUserLoginOK then
					'// 검색결과 상품목록 작성
					IF iTotCnt >= 0 then
						For iLp=0 To iTotCnt -1
							rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & cEventItem.FCategoryPrdList(intI).FItemID
						Next
					End if
					'// 위시결과 상품목록 작성
					if rstArrItemid<>"" then
			'			response.write getLoginUserid() &"//"& rstArrItemid &"//"&vWishArr
			'			response.end
						Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
					end if
				end if
				
				%>
				<% IF (iTotCnt >= 0) THEN %>
					<% For intI =0 To iTotCnt %>
						<li id="item">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=80616'); return false;">
								<div class="thumbnail"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="" />
									<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
										<b class="soldout">일시 품절</b>
									<% end if %>
								</div>
								<div class="desc">
									<span class="brand"><%= cEventItem.FCategoryPrdList(intI).FBrandName %></span>
									<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
									<div class="price">
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<div class="unit"><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><span class="won">원</span></b> <b class="discount color-red"><% = cEventItem.FCategoryPrdList(intI).getSalePro %></b></div>
									<% End IF %>
									
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<div class="unit"><%' if eItemListType <> "1" then %><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %><span class="won">원</span></b> <%' end if %><b class="discount color-green"><% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %><small>쿠폰</small></b></div>
									<% End IF %>
									
								<% Else %>
									<div class="unit"><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><span class="won"><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %>원<% end  if %></span></b></div>
								<% End if %>
									</div>
								</div>
							</a>
							<div class="etc">
								<% if cEventItem.FCategoryPrdList(intI).FEvalcnt > 0 then %>
									<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(cEventItem.FCategoryPrdList(intI).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(cEventItem.FCategoryPrdList(intI).FEvalcnt>999,"999+",cEventItem.FCategoryPrdList(intI).FEvalcnt)%></span></div>
								<% end if %>
								<button class="tag wish btn-wish" onclick="goWishPop('<%=cEventItem.FCategoryPrdList(intI).FItemid%>','<%=eCode%>');">
								<%
								If cEventItem.FCategoryPrdList(intI).FFavCount > 0 Then
									If fnIsMyFavItem(vWishArr,cEventItem.FCategoryPrdList(intI).FItemID) Then
										Response.Write "<span class=""icon icon-wish on"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
										Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
									Else
										Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
										Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
									End If
								Else
									Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&"""></span>"
								End If
								%>
								</button>
								<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem AND cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr = "무료배송" Then %>
									<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
								<% End If %>
							</div>
						</li>
					<% next %>
				<% end if %>
				<% set cEventItem = nothing %>
				</ul>
				<!--// 드레스룸 -->
				<!-- 침실 -->
				<h4><a href="" onclick="goEventLink('80615&eGc=219255'); return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2017/80616/m/btn_go4.jpg" alt="침실" /></a></h4>
				<ul>
				<%
				intI = 0
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				cEventItem.FEGCode 	= grcode4
				cEventItem.FEPGsize 	= 10
'				cEventItem.Frectminnum= 11
'				cEventItem.Frectmaxnum= 20
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				'// 검색결과 내위시 표시정보 접수
				if IsUserLoginOK then
					'// 검색결과 상품목록 작성
					IF iTotCnt >= 0 then
						For iLp=0 To iTotCnt -1
							rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & cEventItem.FCategoryPrdList(intI).FItemID
						Next
					End if
					'// 위시결과 상품목록 작성
					if rstArrItemid<>"" then
			'			response.write getLoginUserid() &"//"& rstArrItemid &"//"&vWishArr
			'			response.end
						Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
					end if
				end if
				
				%>
				<% IF (iTotCnt >= 0) THEN %>
					<% For intI =0 To iTotCnt %>
						<li id="item">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=80616'); return false;">
								<div class="thumbnail"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="" />
									<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
										<b class="soldout">일시 품절</b>
									<% end if %>
								</div>
								<div class="desc">
									<span class="brand"><%= cEventItem.FCategoryPrdList(intI).FBrandName %></span>
									<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
									<div class="price">
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<div class="unit"><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><span class="won">원</span></b> <b class="discount color-red"><% = cEventItem.FCategoryPrdList(intI).getSalePro %></b></div>
									<% End IF %>
									
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<div class="unit"><%' if eItemListType <> "1" then %><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %><span class="won">원</span></b> <%' end if %><b class="discount color-green"><% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %><small>쿠폰</small></b></div>
									<% End IF %>
									
								<% Else %>
									<div class="unit"><b class="sum"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><span class="won"><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %>원<% end  if %></span></b></div>
								<% End if %>
									</div>
								</div>
							</a>
							<div class="etc">
								<% if cEventItem.FCategoryPrdList(intI).FEvalcnt > 0 then %>
									<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(cEventItem.FCategoryPrdList(intI).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(cEventItem.FCategoryPrdList(intI).FEvalcnt>999,"999+",cEventItem.FCategoryPrdList(intI).FEvalcnt)%></span></div>
								<% end if %>
								<button class="tag wish btn-wish" onclick="goWishPop('<%=cEventItem.FCategoryPrdList(intI).FItemid%>','<%=eCode%>');">
								<%
								If cEventItem.FCategoryPrdList(intI).FFavCount > 0 Then
									If fnIsMyFavItem(vWishArr,cEventItem.FCategoryPrdList(intI).FItemID) Then
										Response.Write "<span class=""icon icon-wish on"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
										Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
									Else
										Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
										Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
									End If
								Else
									Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&"""></span>"
								End If
								%>
								</button>
								<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem AND cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr = "무료배송" Then %>
									<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
								<% End If %>
							</div>
						</li>
					<% next %>
				<% end if %>
				<% set cEventItem = nothing %>
				</ul>
				<!-- //침실 -->
			</div>
		</div>
		<!--// 신혼하루 -->
	</div>
	<!--// 웨딩 기획전 (스몰웨딩) -->
<!-- #include virtual="/lib/db/dbclose.asp" -->