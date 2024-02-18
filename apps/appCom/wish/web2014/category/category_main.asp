<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/specialbrand/SpecialBrandCls.asp" -->
<%
	dim sb, brandList, i
	set sb = new SpecialBrandCls
	brandList = sb.getSpecialBrandInfo("A", 500, "")
%>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script type="text/javascript">
$(function() {
	/* favorite menu */
	$("#favoriteMenu .btn-close").on("click", function(){
		$("#favoriteMenu").fadeOut(300, function(){ $(this).remove();});
	});
	// special brand rolling
	var brandStreetRolling = new Swiper(".special-brand-rolling.swiper-container", {
		speed:1000,
		slidesPerView:'auto'
	});		
});

// 가장 최근 링커(텐텐토크) 포럼 일련번호 가져오기
let linkerForumIndex = 1;
function getRecentlyLinkerForumIndex() {
	const success = function(data) {
		const forums = data.forums;
		if( forums == null || forums.length === 0 )
			return;
		
		linkerForumIndex = forums[0].forumIdx;
	}
	getFrontApiDataV2('GET', '/linker/forums', null, success);
}
// getRecentlyLinkerForumIndex();

function goLinkerForum() {
	// fnAPPpopupBrowserRenewal('push', '😘💬', '<%=M_SSLUrl%>/apps/appCom/wish/web2014/linker/forum.asp?gaparam=category_tab&idx=' + linkerForumIndex);return false;
	fnAPPpopupBrowserRenewal('push', '😘💬', '<%=M_SSLUrl%>/apps/appCom/wish/web2014/linker/forums.asp');return false;
}
</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
	<div id="content" class="content">
		<% If (now() > #01/15/2018 00:00:00# And now() <= #01/16/2018 23:59:59#) then %>
		<!-- 레드 썬데이 2018-01-12 -->
		<div class="bnr">
			<a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=83578&gaparam=category_banner_redsunday');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/bnr_detail_m.png" alt="단 2일! 레드 썬! 데이 기획전 바로가기"></a>
		</div>
		<% end if %>

		<% If Trim(fnGetImportantNotice) <> "" Then %>
			<%
				Dim importantNoticeSplit
				importantNoticeSplit = split(fnGetImportantNotice,"|||||")
			%>
			<%' 190102 모바일 중요공지 %>
			<section class="category-notice">
				<dl>
					<dt><a href="" onclick="fnAPPpopupBrowserURL('공지사항','<%=wwwUrl%>/apps/appcom/wish/web2014/common/news/index.asp?','right','','sc');return false;">NOTICE</a></dt>
					<dd>
						<a href="" onclick="fnAPPpopupBrowserURL('공지사항','<%=wwwUrl%>/apps/appcom/wish/web2014/common/news/news_view.asp?idx=<%=importantNoticeSplit(0)%>&direct=1','right','','sc');return false;">
							<%=importantNoticeSplit(1)%>
						</a>
					</dd>
				</dl>
			</section>
			<%' // 190102 모바일 중요공지 %>
		<% End If %>

		<!-- category menu -->
		<section class="category-menu">
			<nav>
				<ul>
					<li>
						<%'!-- for dev smg : 신규로 카테고리가 추가되었을 때 클래스 on 붙여주세요. --%>
						<%'!-- for dev smg : 이미지 사이즈는 140 x 132 입니다. 어드민에서 이미지 썸네일 관리 --%>
						<a href="" onclick="fnAPPpopupCategory('101','ne');return false;" class="on">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2021/category/img_cate_stationary.jpg" alt=""></div>
							<span class="name">디자인문구</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('102','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2020/category/img_cate_digital_v2.jpg" alt=""></div>
							<span class="name">디지털/핸드폰</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('124','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2021/category/img_cate_designelectronic.jpg" alt=""></div>
							<span class="name">디자인가전</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('121','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2020/category/img_cate_furniturestorage_v2.jpg" alt=""></div>
							<span class="name">가구/수납</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('122','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2020/category/img_cate_decolights_v2.jpg" alt=""></div>
							<span class="name">데코/조명</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('120','be');return false;" class="on">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2020/category/img_cate_fabricliving_v2.jpg" alt=""></div>
							<span class="name">패브릭/생활</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('112','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2020/category/img_cate_kitchen_v2.jpg" alt=""></div>
							<span class="name">키친</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('119','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2020/category/img_cate_food_v2.jpg" alt=""></div>
							<span class="name">푸드</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('117','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2021/category/img_cate_fashion.jpg" alt=""></div>
							<span class="name">패션의류</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('116','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2021/category/img_cate_acc.jpg" alt=""></div>
							<span class="name">패션잡화</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('125','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2020/category/img_cate_jewelrywatch_v2.jpg" alt=""></div>
							<span class="name">주얼리/시계</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('118','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2020/category/img_cate_beauty_v2.jpg" alt=""></div>
							<span class="name">뷰티</span>
						</a>
					</li>
					<li>
						<a href="" onclick="fnAPPpopupCategory('104','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2021/category/img_cate_toy.jpg" alt=""></div>
							<span class="name">토이/취미</span>
						</a>
					</li>
					<!--<li>
						<a href="" onclick="fnAPPpopupCategory('115','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2021/category/img_cate_baby.jpg" alt=""></div>
							<span class="name">베이비/키즈</span>
						</a>
					</li>-->
					<li>
						<a href="" onclick="fnAPPpopupCategory('110','be');return false;">
							<div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2021/category/img_cate_catndog.jpg" alt=""></div>
							<span class="name">캣앤독</span>
						</a>
					</li>
					<li>
                        <a href="" onclick="fnAPPpopupCategory('103','be');return false;">
                            <div class="thumbnail"><img src="//fiximage.10x10.co.kr/m/2018/category/img_category_camping.jpg" alt=""></div>
                            <span class="name">캠핑</span>
                        </a>
                    </li>
				</ul>
			</nav>
		</section>

		<div class="category-onlybrand">
			<div class="btn-brand-street">
				<a href="" onclick="fnAPPpopupBrend_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/street/index.asp');return false;">
					<span class="icon icon-brand"></span>
					<span class="name">BRAND STREET</span>
					<p>브랜드가 한 자리에</p>
				</a>
			</div>
			<div class="btn-brand-street btn-special-brand">
				<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], 'Special Brand', [BtnType.SEARCH, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/brand/')">
					<span class="icon icon-special-brand"></span>
					<span class="name">스페셜 브랜드</span>
					<p>특별한 브랜드가 한 자리에</p>
				</a>
				<%'노출 순서 기준 상위 20개 브랜드 순차 노출%>
				<%
					if isArray(brandList) then
				%>
				<div class="special-brand-rolling swiper-container">
					<div class="swiper-wrapper">
				<%
						for i=0 to Ubound(brandList) - 1
				%>
						<div class="swiper-slide">
							<a href="" onclick="fnAPPpopupBrand('<%=brandList(i).FBrandid%>'); return false;">
								<img src="<%=brandList(i).Fbrand_icon%>" alt=""><span><%=brandList(i).Fsocname_kor%></span>
							</a>
						</div>
				<%
						next
				%>
					</div>
				</div>
				<%
					end if
				%>
			</div>
		</div>

		<% If Date() >= "2020-10-05" And Date() <= "2020-10-29" Then %>
		<% '주년배너 %>
		<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '19주년', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/19th/index.asp')" style="display:block; margin-bottom:calc(-1.71rem + 1px)">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/bnr_ctgr_anni.png" alt="19주년 이벤트">
		</a>
		<% End If %>

		<% 'diarystory 배너 %>
		<!-- <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리 스토리', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2022/index.asp?gaparam=category_tab')" class="bnr_ctgr_dr mApp">
			<img src="http://fiximage.10x10.co.kr/m/2021/diarystory2022/bnr_ctgr.jpg" alt="텐텐문구점 메인으로 이동">
		</a> -->

		<!-- quick menu 1 -->
		<div class="category-quickmenu category-quickmenu-1">
			<ul>
				<li class="ctg-talk new">
					<a onclick="goLinkerForum()">
						<span class="icon icon-talk"></span>
						<span class="name">텐텐토크</span>
						<p>텐바이텐과 도란도란<br>이야기 나눠요</p>
                        <span class="new"></span>
					</a>
				</li>
				<!-- 다이어리 배너 -->
                <li class="ctg-diary new">
					<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐문구점', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2022/index.asp?gaparam=category_tab')" class="bnr_ctgr_dr mApp">
						<img src="http://fiximage.10x10.co.kr/m/2021/diarystory2022/bnr_tenten.png" alt="텐텐문구점 메인으로 이동">
					</a>
                    <!-- <span class="new"></span> -->
				</li>
				<li class="ctg-exhibit">
					<a href="" onclick="fnAPPpopupEventMain_S(1);return false;">
						<span class="icon icon-exhibition"></span>
						<span class="name">기획전</span>
						<p>정성스럽게 준비한<br>추천 상품</p>
					</a>
				</li>
				<li class="ctg-event">
					<a href="" onclick="fnAPPpopupEventMain_S(2);return false;">
						<span class="icon icon-event"></span>
						<span class="name">이벤트</span>
						<p>선물과 함께 찾아<br>오는 일상의 즐거움</p>
					</a>
				</li>
				<li class="ctg-tenfluencer">
					<a href="" onclick="fnAPPpopupTransparent('tenfluencer','http://fiximage.10x10.co.kr/m/2019/platform/tenfluencer.png','/tenfluencer/','right','sc','titleimage');return false;">
						<span class="icon icon-tenfluencer"></span>
						<span class="name">텐플루언서</span>
						<p>텐텐 x 인플루언서의<br>콜라보 컨텐츠</p>
					</a>
				</li>
				<li class="ctg-wallpaper">
					<a href="" onclick="fnAPPpopupBrowserURL('월페이퍼','<%=wwwUrl%>/apps/appCom/wish/web2014/wallpaper/','right','','sc');return false;">
						<span class="icon icon-wallpaper"></span>
						<span class="name">月페이퍼</span>
						<p>매달 업데이트 되는<br>모바일 배경화면</p>
					</a>
				</li>
				<li class="ctg-culture">
					<a href="" onclick="fnAPPpopupCulture_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/culturestation/index.asp');return false;">
						<span class="icon icon-culture"></span>
						<span class="name">컬쳐스테이션</span>
						<p>새롭게 만나는<br>문화정거장</p>
					</a>
				</li>
				<li class="ctg-hitchhiker">
					<a href="" onclick="fnAPPpopupBrowserRenewal('push', '히치하이커', '<%=wwwUrl%>/apps/appcom/wish/web2014/hitchhiker/index2020.asp?hflag=1&ap=cm','hitchhiker','blank');return false;">
						<span class="icon icon-hitchhiker"></span>
						<span class="name">히치하이커</span>
						<p>격월간 발행되는<br>감성 매거진</p>
					</a>
				</li>
				<li class="ctg-gift">
					<a href="" onclick="fnAPPpopupBrowserURL('기프트','<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/index.asp','right','','sc');return false;">
						<span class="icon icon-gift"></span>
						<span class="name">선물의 참견</span>
						<p>어떤 선물이 좋을까<br>고민중이라면?</p>
					</a>
				</li>
				<li class="ctg-giftcard"><a href="" onclick="fnAPPpopupBrowserURL('기프트카드','<%=wwwUrl%>/apps/appCom/wish/web2014/giftcard/index.asp','right','','sc'); return false;"><span class="icon icon-giftcard"></span><span class="name">기프트카드</span></a></li>
				<li class="ctg-membership"><a href="" onclick="fnAPPpopupBrowserURL('카드등록','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/cardregister.asp','right','','sc'); return false;"><span class="icon icon-membership-card"></span><span class="name">멤버십카드</span></a></li>
				<li class="ctg-wish col-2">
					<a href="" onclick="fnAPPpopupWish_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/wish/index.asp');return false;">
						<span class="icon icon-wish"></span>
						<span class="name">WISH</span>
						<p>다른 사람들의 위시를 실시간으로 만나보세요!</p>
					</a>
				</li>
			</ul>
		</div>

		<!-- quick menu 2 -->
		<div class="category-quickmenu category-quickmenu-2">
			<ul>
				<li><a href="" onclick="fnAPPpopupBrowserRenewal('push', 'NEW', '<%=wwwUrl%>/apps/appcom/wish/web2014/list/new/new_summary2020.asp');return false;"><span class="icon icon-new"></span><span class="name">NEW</span></a></li>
				<li><a href="" onclick="fnPopupBest('<%=wwwUrl%>/apps/appcom/wish/web2014/list/best/best_summary2020.asp');return false;"><span class="icon icon-best"></span><span class="name">BEST</span></a></li>
				<li><a href="" onclick="fnAPPpopupBrowserRenewal('push', 'SALE', '<%=wwwUrl%>/apps/appcom/wish/web2014/list/sale/sale_summary2020.asp');return false;"><span class="icon icon-sale"></span><span class="name">SALE</span></a></li>
				<li><a href="" onclick="fnAPPpopupBrowserRenewal('push', 'CLEARANCE', '<%=wwwUrl%>/apps/appcom/wish/web2014/list/clearance/clearance_summary2020.asp');return false;"><span class="icon icon-clearance"></span><span class="name">CLEARANCE</span></a></li>
			</ul>
		</div>

		<div class="category-info-center">
            <!-- quick menu 3 (offshop enterance) -->
            <div class="btn-brand-street bg-white">
                <a href="" onclick="fnAPPpopupBrowserURL('매장안내','<%=wwwUrl%>/apps/appcom/wish/web2014/offshop/','right','','sc');return false;">
                    <span class="icon icon-offstore"></span>
                    <span class="name">텐바이텐 매장안내</span>
                </a>
            </div>
            <!-- 고객센터 -->
            <div class="customs-center">
                <a href="" onclick="fnAPPpopupBrowserURL('고객센터','http://m.10x10.co.kr/apps/appCom/wish/web2014/cscenter/');return false;">
                    <div class="tit arrow">
                        <span class="icon"></span>
                        <span class="name">고객센터</span>
                    </div>
                    <div class="info-open">
                        <div class="info-time">
                            <div class="time">
                                <p class="txt">운영시간</p>
                                <p class="num">10:00 ~ 17:00 <span class="day-off">(주말, 공휴일 휴무)</span></p>
                            </div>
                            <div class="time type02">
                                <p class="txt">점심시간</p>
                                <p class="num02">12:30 ~ 13:30</p>
                            </div>
                        </div>
                    </div>
                </a>
            </div>
        </div>
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->