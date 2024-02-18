<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 가정의달 기획전
' History : 2019-04-11 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'gnb관련변수
	dim vGaParam, gaStr
	vGaParam = request("gaparam")

	if vGaParam <> "" then
		gaStr = "&gaparam=" & vGaParam
	end if
'gnb관련변수
dim vAdrVer

vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>
<style>
.family2019 {position: relative;}
.topic {position: relative; background-color: #ffcecf;}
.topic h2 {position: absolute; top: 0; width: 100%;} 
.tab-area {position:relative; margin-top: -2rem;}
.tab-area ul {overflow:hidden; position: absolute; top:0; left:0; width:100%; height:100%;}
.tab-area ul li {float:left; height:100%; width: 50%;}
.tab-area ul li a {display:block; width:100%; height:100%; text-indent:-999em;}
.section .img {position:relative;}
.section .img a {display:block;}
.section .txt {padding:1.24rem 2.69rem 1.75rem;}
.section .txt .num {display:block;}
.section .txt .num img {width:inherit; height:2.22rem;}
.section .txt p {margin-top:0.98rem; font-size:1.19rem; line-height:1.71; color:#000; word-break:keep-all;}
.section .tag1 {margin:0 5.33% 1.7rem;}
.section .tag1 .swiper-slide {margin-right: .85rem;}
.section .tag1 .swiper-slide:last-child {margin-right: 0;}
.section .tag1 .swiper-slide a span {display: block; height:2.56rem; padding:0 0.85rem; font-size:1.15rem; line-height:2.56rem; background-color: #fff479; color:#242424; border-radius:.5rem;}
.section .tag1 .swiper-slide a span:before {content: '#'; display: inline-block; width: .9rem;}
.section2 .tag1 .swiper-slide a span, .section5 .tag1 .swiper-slide a span {background-color: #bbdcb0;}
.section3 .tag1 .swiper-slide a span, .section6 .tag1 .swiper-slide a span {background-color: #c8daff;}
.section .tag1 .swiper-slide a[href*="earch"] span {background-color: #f0f0f0; }
.section ul {margin: 0 5.33%; border-top: .09rem solid #eee;}
.section li {padding: 0.85rem 0; border-bottom: .09rem solid #eee;}
.section li a {display: flex; width:100%; overflow:hidden; align-items: center;}
.section .thumbnail {overflow:hidden; position:relative; display:table-cell; width:6.4rem; height:6.4rem; margin-right: 0.85rem; vertical-align:middle; background-color:#fff;}
.section .thumbnail img {position:relative; z-index:2;}
.section .thumbnail:before {content:' '; position:absolute; top:50%; left:50%; width:3rem; height:3rem; margin:-1.5rem 0 0 -1.5rem; background:url(http://fiximage.10x10.co.kr/m/2017/common/bg_img_loading.png) 50% 0 no-repeat; background-size:100% auto;}
.section .desc {height: 5.55rem; width: calc(100% - 6.5rem); padding:.2rem 0 0 1.27rem; border-left: .09rem solid #eee;}
.section .desc .brand {font: italic 500 1.1rem 'Times New Roman', Times, serif; text-transform: uppercase;}
.section .desc .name {display:inline-block; overflow:hidden; width: 18rem; height: 1.8rem; margin-top: 0.5rem; font-size: 1.19rem; white-space:nowrap; text-overflow:ellipsis;}
.section .desc .price {margin-top:0.2rem; font-family:'Verdana'; font-size: 1.19rem; font-weight: 600;}
.section .desc .price s {display:none;}
.section .desc .price span {margin-left:0.3rem; color:#ff4800;}
.section .desc .price span.cp-sale {color:#00b160;}
.bnr-area {*zoom:1} 
.bnr-area:after {display:block; clear:both; content:'';} 
.bnr-area a {float: left; width: 50%;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
function fnSearchEventText(stext){
	<% If flgDevice="A" Then %>
		fnAPPpopupSearch(stext);
	<% Else %>
		<% If vAdrVer>="2.24" Then %>
			fnAPPpopupSearchOnNormal(stext);
		<% Else %>
			fnAPPpopupSearch(stext);
		<% End If %>
	<% End If %>
}
$(function(){
	// 더보기
	$('.btn-more').click(function(e) {
		$(this).hide()
		$(this).prev('.more-area').slideDown()
		e.preventDefault();
	});
	//slide1
	mySwiper = new Swiper(".tag1",{
		slidesPerView:"auto",
		freeMode:true,
	});
	//가격
	fnApplyItemInfoList ({
		items:"2243850,2100115,1640748",	
		target:"itemList1",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2278182,1037852",	
		target:"itemList2",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2148688,2029211,2020653",	
		target:"itemList3",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2318512,1939640",	
		target:"itemList4",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2197604,1752800,2073519",	
		target:"itemList5",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2308534,1939859,2070918",	
		target:"itemList6",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
})
</script>
	<!-- 가정의 달 -->
    <div id="content" class="content family2019">
        <!-- 상단 -->
        <div class="topic">
			<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_top.jpg" alt="종합선물세트">
            <div class="tab-area">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_tab.png?v=1.02" alt="">
                <ul>
                    <li><a href="./index.asp?link=1&gnbflag=1<%=gaStr%>">이달의 선물</a></li>
                    <li class="on"><a href="./index.asp?link=2&gnbflag=1<%=gaStr%>">추천선물</a></li>
                </ul>
            </div>
		</div>
		<div class="items">
			<!-- No.1 -->
			<div class="section section1">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_01.jpg?v=1.01" alt="" />
				<div class="slide1 tag1">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<a href="/street/street_brand.asp?makerid=goonieslab" class="mWeb"><span>스마트팔레트</span></a>
							<a href="" onclick="fnAPPpopupBrand('goonieslab'); return false;" class="mApp"><span>스마트팔레트</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=색연필" class="mWeb"><span>색연필</span></a>
							<a href="javascript:fnSearchEventText('색연필');" class="mApp"><span>색연필</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/street/street_brand.asp?makerid=ddangkongpress" class="mWeb"><span>구버</span></a>
							<a href="" onclick="fnAPPpopupBrand('ddangkongpress'); return false;" class="mApp"><span>구버</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/street/street_brand.asp?makerid=hans8282" class="mWeb"><span>드림아트</span></a>
							<a href="" onclick="fnAPPpopupBrand('hans8282'); return false;" class="mApp"><span>드림아트</span></a>
						</div>
					</div>
				</div>
				<ul id="itemList1">
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2243850" onclick="TnGotoProduct('2243850');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP</p>
								<p class="name">구버크레용_블럭_자동차2(set) 구성</p>
								<p class="price"><s>99,999원</s>99,999원<span class="discount">99%</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2100115" onclick="TnGotoProduct('2100115');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1640748" onclick="TnGotoProduct('1640748');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
				</ul>
			</div>
			<!-- No.2 -->
			<div class="section  section2">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_02.jpg" alt="" />
				<div class="slide1 tag1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><a href= "/event/eventmain.asp?eventid=93663" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93663');return false;"><span>집에서놀까?</span></a></div>
						<div class="swiper-slide">
							<a href="/street/street_brand.asp?makerid=toynstore" class="mWeb"><span>하페</span></a>
							<a href="" onclick="fnAPPpopupBrand('toynstore'); return false;" class="mApp"><span>하페</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=역할놀이" class="mWeb"><span>역할놀이</span></a>
							<a href="javascript:fnSearchEventText('역할놀이');" class="mApp"><span>역할놀이</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=어린이날" class="mWeb"><span>어린이날</span></a>
							<a href="javascript:fnSearchEventText('어린이날');" class="mApp"><span>어린이날</span></a>
						</div>
					</div>
				</div>
				<ul id="itemList2"><!-- itemList -->
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2278182" onclick="TnGotoProduct('2278182');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1037852" onclick="TnGotoProduct('1037852');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
				</ul>
			</div>
			<!-- 배너 -->
			<div class="bnr-area">
				<a href="/category/category_itemPrd.asp?itemid=2321791" onclick="TnGotoProduct('2321791');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_prd2242621.jpg" alt="상품 바로가기">
				</a>
				<a href="/category/category_itemPrd.asp?itemid=2286426" onclick="TnGotoProduct('2286426');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_prd2286426.jpg" alt="상품 바로가기">
				</a>
			</div>
			<!-- No.3 -->
			<div class="section  section3">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_03.jpg" alt="" />
				<div class="slide1 tag1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><a href= "/event/eventmain.asp?eventid=93729" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93729');return false;"><span>뭐이런걸다</span></a></div>
						<div class="swiper-slide">
							<a href="/street/street_brand.asp?makerid=prida1" class="mWeb"><span>프리다밀랍초</span></a>
							<a href="" onclick="fnAPPpopupBrand('prida1'); return false;" class="mApp"><span>프리다밀랍초</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=밀랍초" class="mWeb"><span>밀랍초</span></a>
							<a href="javascript:fnSearchEventText('밀랍초');" class="mApp"><span>밀랍초</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=캔들" class="mWeb"><span>캔들</span></a>
							<a href="javascript:fnSearchEventText('캔들');" class="mApp"><span>캔들</span></a>
						</div>
					</div>
				</div>
				<ul id="itemList3"><!-- itemList -->
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2148688" onclick="TnGotoProduct('2148688');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2029211" onclick="TnGotoProduct('2029211');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2020653" onclick="TnGotoProduct('2020653');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
				</ul>
			</div>
			<!-- 기획전 바로가기 -->
			<a href="/event/eventmain.asp?eventid=93722" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93722');return false;">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_evt93722.jpg" alt="기획전 바로가기" />
			</a>
			<!-- No.4 -->
			<div class="section section4">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_04.jpg" alt="" />
				<div class="slide1 tag1">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<a href="/street/street_brand.asp?makerid=arenazz" class="mWeb"><span>블루밍앤미</span></a>
							<a href="" onclick="fnAPPpopupBrand('arenazz'); return false;" class="mApp"><span>블루밍앤미</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=플라워박스" class="mWeb"><span>플라워박스</span></a>
							<a href="javascript:fnSearchEventText('플라워박스');" class="mApp"><span>플라워박스</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=용돈박스" class="mWeb"><span>용돈박스</span></a>
							<a href="javascript:fnSearchEventText('용돈박스');" class="mApp"><span>용돈박스</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=어버이날" class="mWeb"><span>어버이날</span></a>
							<a href="javascript:fnSearchEventText('어버이날');" class="mApp"><span>어버이날</span></a>
						</div>
					</div>
				</div>
				<ul id="itemList4"><!-- itemList -->
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2318512" onclick="TnGotoProduct('2318512');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1939640" onclick="TnGotoProduct('1939640');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
				</ul>
			</div>
			<!-- 배너 -->
			<div class="bnr-area">
				<a href="/category/category_itemPrd.asp?itemid=2308431" onclick="TnGotoProduct('2308431');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_prd2308431.jpg" alt="상품 바로가기">
				</a>
				<a href="/category/category_itemPrd.asp?itemid=2278205" onclick="TnGotoProduct('2278205');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_prd2278205.jpg" alt="상품 바로가기">
				</a>
			</div>
			<!-- No.5 -->
			<div class="section section5">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_05.jpg" alt="" />
				<div class="slide1 tag1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><a href= "/event/eventmain.asp?eventid=93738" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93738');return false;"><span>살룻</span></a></div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=과일주" class="mWeb"><span>과일주</span></a>
							<a href="javascript:fnSearchEventText('과일주');" class="mApp"><span>과일주</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=담금주키트" class="mWeb"><span>담금주키트</span></a>
							<a href="javascript:fnSearchEventText('담금주키트');" class="mApp"><span>담금주키트</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=선물세트" class="mWeb"><span>선물세트</span></a>
							<a href="javascript:fnSearchEventText('선물세트');" class="mApp"><span>선물세트</span></a>
						</div>
					</div>
				</div>
				<ul id="itemList5"><!-- itemList -->
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2197604" onclick="TnGotoProduct('2197604');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1752800" onclick="TnGotoProduct('1752800');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2073519" onclick="TnGotoProduct('2073519');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
				</ul>
			</div>
			<!-- 기획전 바로가기 -->
			<a href="/event/eventmain.asp?eventid=93721" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93721');return false;">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_evt93721.jpg" alt="기획전 바로가기" />
			</a>
			<!-- No.6 -->
			<div class="section section6">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_06.jpg" alt="" />
				<div class="slide1 tag1">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<a href="/street/street_brand.asp?makerid=chaeon" class="mWeb"><span>채온</span></a>
							<a href="" onclick="fnAPPpopupBrand('chaeon'); return false;" class="mApp"><span>채온</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=꽃차" class="mWeb"><span>꽃차</span></a>
							<a href="javascript:fnSearchEventText('꽃차');" class="mApp"><span>꽃차</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=플라워" class="mWeb"><span>플라워</span></a>
							<a href="javascript:fnSearchEventText('플라워');" class="mApp"><span>플라워</span></a>
						</div>
						<div class="swiper-slide">
							<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=스승의날" class="mWeb"><span>스승의날</span></a>
							<a href="javascript:fnSearchEventText('스승의날');" class="mApp"><span>스승의날</span></a>
						</div>
					</div>
				</div>
				<ul id="itemList6"><!-- itemList -->
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2308534" onclick="TnGotoProduct('2308534');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1939859" onclick="TnGotoProduct('1939859');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=2070918" onclick="TnGotoProduct('2070918');return false;">
							<div class="thumbnail"><img src="" alt="" /></div>
							<div class="desc">
								<p class="brand">BRANDSHOP </p>
								<p class="name">상품명</p>
								<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
							</div>
						</a>
					</li>
				</ul>
			</div>
			<a href="./index.asp?link=2&gnbflag=1<%=gaStr%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_push.jpg" alt="추천선물 더보기" /></a>
		</div>

	</div>
	<!-- // 가정의 달 -->