<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 가정의달 기획전
' History : 2019-04-11 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim vAdrVer

vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>

<%
Dim oExhibition 
dim mastercode,  detailcode, bestItemList, detailGroupList, listType, tmpItemList
dim couponPrice, couponPer, tempPrice, salePer, saleStr, couponStr
dim tmpImgCode, disOption
dim i, j, tmpIdx
dim numOfItems

numOfItems = 12
j = 0

listType = "A"

IF application("Svr_Info") = "Dev" THEN
	mastercode = 7
Else
	mastercode = 6	
End If

SET oExhibition = new ExhibitionCls

    bestItemList = oExhibition.getItemsListProc( listType, 100, mastercode, "", "1", "" )     '리스트타입, row개수, 마스터코드, 디테일코드, best아이템 구분, 카테고리 정렬 구분     
	detailGroupList = oExhibition.getDetailGroupList(mastercode)		    

function format(ByVal szString, ByVal Expression)
	if len(szString) < len(Expression) then
	format = left(expression, len(szString)) & szString
	else
	format = szString
	end if
end function
%>
<style>
.family2019 {position: relative; background-color: #fff; padding-bottom: 4.27rem !important;}  
.topic {position: relative; background-size: cover; animation:full_change 4.5s 20; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/bg_top_01.jpg)}
.topic > img {opacity: 0;}
.topic div {position: absolute; top: 0; width: 100%; } 
.topic h2 {opacity: 0; transition:1.4s; transform: translateY(-.7rem)}
.topic p {width: 100%;opacity: 0; transition:1s .4s; transform: translateY(-.7rem)}
.topic.on h2,
.topic.on p {opacity: 1; transform: translateY(0)}
.section .img {position:relative;}
.section .img a {display:block;}
.section .txt {padding:1.24rem 2.69rem 1.75rem;}
.section .txt .num {display:block;}
.section .txt .num img {width:inherit; height:2.22rem;}
.section .txt p {margin-top:0.98rem; font-size:1.19rem; line-height:1.71; color:#000; word-break:keep-all;}
.section .tag1 {margin:1.7rem 5.33%;}
.section .tag1 li {display: inline-block; margin-right: .6rem;}
.section .tag1 li:last-child {margin-right: 0;}
.section .tag1 li a span {display: block; height:2.56rem; padding:0 0.85rem; font-size:1.15rem; line-height:2.56rem; background-color: #49d1c3; color: #fff; border-radius:.5rem;}
.section.parent .tag1 li a span {background-color: #ff7791;}
.section .tag1 li a span:before {content: '#'; display: inline-block; width: .9rem;}
.section .tag1 li a[href*="earch"] span {background-color: #f0f0f0; color:#242424;}
.section .slide1 {position: relative;}
.section .slide1 .pagination {position: absolute; top: 44%; left: 0; z-index: 99; width: 100%; text-align: center;}
.section .pagination .swiper-pagination-switch {background-color: #fff; opacity: .5;}
.section .pagination .swiper-active-switch {background-color: #fff; opacity: 1;}
.section .items ul {margin: 0 5.33%; border-top: .09rem solid #eee;}
.section .items li {padding: 0.85rem 0; border-bottom: .09rem solid #eee;}
.section .items li a {display: flex; width:100%; overflow:hidden; align-items: center;}
.section .items .thumbnail {overflow:hidden; position:relative; display:table-cell; width:6.4rem; height:6.4rem; margin-right: 0.85rem; vertical-align:middle; background-color:#fff;}
.section .items .thumbnail img {position:relative; z-index:2;}
.section .items .thumbnail:before {content:' '; position:absolute; top:50%; left:50%; width:3rem; height:3rem; margin:-1.5rem 0 0 -1.5rem; background:url(http://fiximage.10x10.co.kr/m/2017/common/bg_img_loading.png) 50% 0 no-repeat; background-size:100% auto;}
.section .items .desc {height: 5.55rem; width: calc(100% - 6.5rem); padding:.2rem 0 0 1.27rem; border-left: .09rem solid #eee;}
.section .items .desc .brand {font: italic 500 1.1rem 'Times New Roman', Times, serif; text-transform: uppercase;}
.section .items .desc .name {display:inline-block; overflow:hidden; width: 18rem; height: 1.8rem; margin-top: 0.5rem; font-size: 1.19rem; white-space:nowrap; text-overflow:ellipsis;}
.section .items .desc .price {margin-top:0.2rem; font-family:'Verdana'; font-size: 1.19rem; font-weight: 600;}
.section .items .desc .price s {display:none;}
.section .items .desc .price span {margin-left:0.3rem; color:#ff4800;}
.section .items .desc .price span.cp-sale {color:#00b160;}
.bnr-area {*zoom:1} 
.bnr-area:after {display:block; clear:both; content:'';} 
.bnr-area a {float: left; width: 50%;}
.evt-slide {margin-top: 5.12rem;}
.evt-slide {position: relative;}
.evt-slide .pagination {position: absolute; bottom: 1.2rem; z-index: 999; width: 100%;}
.evt-slide .pagination .swiper-pagination-switch {background-color: #fff; opacity: .5;}
.evt-slide .pagination .swiper-pagination-switch.swiper-active-switch {opacity: 1;}
.type-grid .section ul {padding: 0 .85rem; border: none;}
.type-grid .section li {padding: 0 .85rem; margin-bottom:  1.7rem; }
.type-grid .section li a {display: block; border-radius: 1.4rem}
.type-grid .section li a .thumbnail {width: 13.43rem; height: 13.43rem;}
.type-grid .section li a .desc {height: 7.04rem; padding:0.4rem 1rem 0; background-color: #f7f7f7;}
.type-grid .section li a .name {color: #666;}
.type-grid .section li a .price {display: block; overflow: hidden; width: 100%; margin-top: .5rem; white-space: nowrap; text-overflow: ellipsis;}
.type-grid .section li a .price b {margin-right: .2rem; font-family:'Verdana'; font-size: 1.19rem; font-weight: 600;}
.btn-more {background: transparent;}
.more-area {display: none;}
@keyframes full_change {
    50% {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/bg_top_02.jpg)}
}
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
	$('.topic').addClass('on')
	//slide
	mySwiper = new Swiper(".child .slide1",{
		pagination:'.child .pagination'
	});
	mySwiper = new Swiper(".parent .slide1",{
		pagination:'.parent .pagination'
	});
	mySwiper = new Swiper(".evt-slide",{
		pagination:'.evt-slide .pagination',
		loop: true,
	});
	//가격
	// fnApplyItemInfoList ({
	// 	items:"2100115,2243850,1640748",	
	// 	target:"itemList1",
	// 	fields:["image","name","sale","price","brand"], 
	// 	unit:"hw",
	// 	saleBracket:false 
	// });
	// fnApplyItemInfoList ({
	// 	items:"2278182,1037852,2041167",	
	// 	target:"itemList2",
	// 	fields:["image","name","sale","price","brand"], 
	// 	unit:"hw",
	// 	saleBracket:false 
	// });
	// fnApplyItemInfoList ({
	// 	items:"1840947,2236524,2265207",	
	// 	target:"itemList3",
	// 	fields:["image","name","sale","price","brand"], 
	// 	unit:"hw",
	// 	saleBracket:false 
	// });
	fnApplyItemInfoList ({
		items:"2148688,2029211,2020653",	
		target:"itemList4",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2318512,1939640,2319475",	
		target:"itemList5",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"1752800,2197604,2073519",	
		target:"itemList6",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2308535,2308534,2098650",	
		target:"itemList7",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});

	//스승의날추가
	fnApplyItemInfoList ({
		items:"1471304,1471303,2319199",	
		target:"itemList8",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2313734,2334898,2313735",	
		target:"itemList9",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"1948702,1781962,1943802",	
		target:"itemList10",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
	fnApplyItemInfoList ({
		items:"2272796,2272804,2272805",	
		target:"itemList11",
		fields:["image","name","sale","price","brand"], 
		unit:"hw",
		saleBracket:false 
	});
})
</script>
<script type="text/javascript">
$(function() {
// ======더보기
    $(".itemsection").each(function(idx){
        if(idx == 0 || idx == 1){
            $("ul li:gt(5)" ,$(this)).css('display','none')
        }else{
            $("ul li:gt(3)" ,$(this)).css('display','none')
        }        
    });	
	$('.btn-more').click(function(e) { 
        var btnIdx = $(".btn-more").index($(this));        
        $(".itemsection").each(function(idx){
            if(idx == btnIdx){
                $("ul li",$(this)).slideDown()                
            }      
        });
        $(this).hide();      
    });
// ======더보기    
	// skip to gift event
	$(".valen-head a").click(function(event){
	event.preventDefault();
	window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
    });
});
</script>
	<!-- 가정의 달 -->
    <div id="content" class="content family2019">
        <!-- 상단 -->
        <div class="topic">
			<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/bg_top_01.jpg" alt="">
			<div>
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_family.png?v=1.01" alt="5월의 선물"></h2>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_sub.png" alt="엄선한 가정의 달 선물 모음"></p>
			</div>
		</div>
		<!-- 어린이날 -->
		<!--div class="section child">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_child.jpg" alt="어린이날"></h3>
			<div class="slide1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_child_01.jpg?v=1.01" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/street/street_brand.asp?makerid=goonieslab" class="mWeb"><span>스마트팔레트</span></a>
									<a href="" onclick="fnAPPpopupBrand('goonieslab'); return false;" class="mApp"><span>스마트팔레트</span></a>
								</li>
								<li>
									<a href="/street/street_brand.asp?makerid=ddangkongpress" class="mWeb"><span>구버</span></a>
									<a href="" onclick="fnAPPpopupBrand('ddangkongpress'); return false;" class="mApp"><span>구버</span></a>
								</li>
								<li>
									<a href="/street/street_brand.asp?makerid=hans8282" class="mWeb"><span>드림아트</span></a>
									<a href="" onclick="fnAPPpopupBrand('hans8282'); return false;" class="mApp"><span>드림아트</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList1">
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
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_child_02.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/event/eventmain.asp?eventid=93727" class="mWeb"><span>어린이날</span></a>
									<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '어린이날', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93727')" class="mApp"><span>어린이날</span></a>									
								</li>
								<li>
									<a href="/event/eventmain.asp?eventid=93751" class="mWeb"><span>하페</span></a>
									<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '하페', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93751')" class="mApp"><span>하페</span></a>									
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=역할놀이" class="mWeb"><span>역할놀이</span></a>
									<a href="javascript:fnSearchEventText('역할놀이');" class="mApp"><span>역할놀이</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList2">
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
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2041167" onclick="TnGotoProduct('2041167');return false;">
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
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_child_03.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=공룡" class="mWeb"><span>공룡</span></a>
									<a href="javascript:fnSearchEventText('공룡');" class="mApp"><span>공룡</span></a>
								</li>
								<li>
									<a href="/street/street_brand.asp?makerid=dinosoles1" class="mWeb"><span>다이노솔즈</span></a>
									<a href="" onclick="fnAPPpopupBrand('dinosoles1'); return false;" class="mApp"><span>다이노솔즈</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=플레이도우" class="mWeb"><span>플레이도우</span></a>
									<a href="javascript:fnSearchEventText('플레이도우');" class="mApp"><span>플레이도우</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList3">
								<li>
									<a href="/category/category_itemPrd.asp?itemid=1840947" onclick="TnGotoProduct('1840947');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2236524" onclick="TnGotoProduct('2236524');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2265207" onclick="TnGotoProduct('2265207');return false;">
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
					</div>
				</div>
				<div class="pagination"></div>
			</div>
		</div-->
		
		
		<!-- 어버이날 -->
		<!--
		<div class="section parent">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_parent.jpg" alt="어버이날"></h3>
			<div class="slide1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_parent_01.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/event/eventmain.asp?eventid=93729" class="mWeb"><span>뭐이런걸다</span></a>									
									<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '뭐이런걸다', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93729')" class="mApp"><span>뭐이런걸다</span></a>																							
								</li>
								<li>
									<a href="/street/street_brand.asp?makerid=prida1" class="mWeb"><span>프리다밀랍초</span></a>
									<a href="" onclick="fnAPPpopupBrand('prida1'); return false;" class="mApp"><span>프리다밀랍초</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=캔들" class="mWeb"><span>캔들</span></a>
									<a href="javascript:fnSearchEventText('캔들');" class="mApp"><span>캔들</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList4">
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
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_parent_02.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/street/street_brand.asp?makerid=arenazz" class="mWeb"><span>블루밍앤미</span></a>
									<a href="" onclick="fnAPPpopupBrand('arenazz'); return false;" class="mApp"><span>블루밍앤미</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=플라워박스" class="mWeb"><span>플라워박스</span></a>
									<a href="javascript:fnSearchEventText('플라워박스');" class="mApp"><span>플라워박스</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=용돈박스" class="mWeb"><span>용돈박스</span></a>
									<a href="javascript:fnSearchEventText('용돈박스');" class="mApp"><span>용돈박스</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList5">
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
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2319475" onclick="TnGotoProduct('2319475');return false;">
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
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_parent_03.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/street/street_brand.asp?makerid=salud" class="mWeb"><span>살룻</span></a>
									<a href="" onclick="fnAPPpopupBrand('salud'); return false;" class="mApp"><span>살룻</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=담금주키트" class="mWeb"><span>담금주키트</span></a>
									<a href="javascript:fnSearchEventText('담금주키트');" class="mApp"><span>담금주키트</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=선물세트" class="mWeb"><span>선물세트</span></a>
									<a href="javascript:fnSearchEventText('선물세트');" class="mApp"><span>선물세트</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList6">
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
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_parent_04.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/street/street_brand.asp?makerid=chaeon" class="mWeb"><span>채온</span></a>
									<a href="" onclick="fnAPPpopupBrand('chaeon'); return false;" class="mApp"><span>채온</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=꽃차" class="mWeb"><span>꽃차</span></a>
									<a href="javascript:fnSearchEventText('꽃차');" class="mApp"><span>꽃차</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=카네이션꽃차" class="mWeb"><span>카네이션꽃차</span></a>
									<a href="javascript:fnSearchEventText('카네이션꽃차');" class="mApp"><span>카네이션꽃차</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList7">
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2308535" onclick="TnGotoProduct('2308535');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
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
									<a href="/category/category_itemPrd.asp?itemid=2098650" onclick="TnGotoProduct('2098650');return false;">
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
					</div>
				</div>
				<div class="pagination"></div>
			</div>
		</div>	
		<div class="bnr-area">
			<a href="/category/category_itemPrd.asp?itemid=2321791" onclick="TnGotoProduct('2321791');return false;">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_prd2242621.jpg?v=1.01" alt="어머님은 돈다발이 좋다고 하셨어">
			</a>
			<a href="/category/category_itemPrd.asp?itemid=2286426" onclick="TnGotoProduct('2286426');return false;">
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_prd2286426.jpg?v=1.01" alt="잘 쓴 카드 하나, 열 깨톡 안 부럽다">
			</a>
		</div>
-->		
		<!-- 스승의날 -->
		<div class="section child">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_teacher.jpg" alt="스승의날"></h3>
			<div class="slide1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_teacher_01.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=카네이션" class="mWeb"><span>카네이션</span></a>
									<a href="javascript:fnSearchEventText('카네이션');" class="mApp"><span>카네이션</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=커피선물" class="mWeb"><span>커피선물</span></a>
									<a href="javascript:fnSearchEventText('커피선물');" class="mApp"><span>커피선물</span></a>
								</li>
								<li>
									<a href="/street/street_brand.asp?makerid=mybeans10" class="mWeb"><span>마이빈스</span></a>
									<a href="" onclick="fnAPPpopupBrand('mybeans10'); return false;" class="mApp"><span>마이빈스</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList8"><!-- itemList -->
								<li>
									<a href="/category/category_itemPrd.asp?itemid=1471304" onclick="TnGotoProduct('1471304');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=1471303" onclick="TnGotoProduct('1471303');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2319199" onclick="TnGotoProduct('2319199');return false;">
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
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_teacher_02.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=카네이션" class="mWeb"><span>카네이션</span></a>
									<a href="javascript:fnSearchEventText('카네이션');" class="mApp"><span>카네이션</span></a>
								</li>
								<li>
									<a href="/street/street_brand.asp?makerid=talkabout" class="mWeb"><span>토크어바웃</span></a>
									<a href="" onclick="fnAPPpopupBrand('talkabout'); return false;" class="mApp"><span>토크어바웃</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=꽃다발" class="mWeb"><span>꽃다발</span></a>
									<a href="javascript:fnSearchEventText('꽃다발');" class="mApp"><span>꽃다발</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList9"><!-- itemList -->
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2313734" onclick="TnGotoProduct('2313734');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2334898" onclick="TnGotoProduct('2334898');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2313735" onclick="TnGotoProduct('2313735');return false;">
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
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_teacher_03.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=카네이션" class="mWeb"><span>카네이션</span></a>
									<a href="javascript:fnSearchEventText('카네이션');" class="mApp"><span>카네이션</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=화과자" class="mWeb"><span>화과자</span></a>
									<a href="javascript:fnSearchEventText('화과자');" class="mApp"><span>화과자</span></a>
								</li>
								<li>
									<a href="/street/street_brand.asp?makerid=chungmidang" class="mWeb"><span>청미당</span></a>
									<a href="" onclick="fnAPPpopupBrand('chungmidang'); return false;" class="mApp"><span>청미당</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList10"><!-- itemList -->
								<li>
									<a href="/category/category_itemPrd.asp?itemid=1948702" onclick="TnGotoProduct('1948702');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=1781962" onclick="TnGotoProduct('1781962');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=1943802" onclick="TnGotoProduct('1943802');return false;">
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
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_teacher_04.jpg" alt="" />
						<div class="tag1">
							<ul>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=디퓨저" class="mWeb"><span>디퓨저</span></a>
									<a href="javascript:fnSearchEventText('디퓨저');" class="mApp"><span>디퓨저</span></a>
								</li>
								<li>
									<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=선물세트" class="mWeb"><span>선물세트</span></a>
									<a href="javascript:fnSearchEventText('선물세트');" class="mApp"><span>선물세트</span></a>
								</li>
								<li>
									<a href="/street/street_brand.asp?makerid=rinm2351" class="mWeb"><span>데일리콤마</span></a>
									<a href="" onclick="fnAPPpopupBrand('rinm2351'); return false;" class="mApp"><span>데일리콤마</span></a>
								</li>
							</ul>
						</div>
						<div class="items">
							<ul id="itemList11"><!-- itemList -->
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2272796" onclick="TnGotoProduct('2272796');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2272804" onclick="TnGotoProduct('2272804');return false;">
										<div class="thumbnail"><img src="" alt="" /></div>
										<div class="desc">
											<p class="brand">BRANDSHOP </p>
											<p class="name">상품명</p>
											<p class="price"><s>원가</s>할인가<span class="discount">할인율</span></p>
										</div>
									</a>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=2272805" onclick="TnGotoProduct('2272805');return false;">
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
					</div>
				</div>
				<div class="pagination"></div>
			</div>
		</div>



		<!-- 기획전 -->
		<div class="slide1 evt-slide">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
				<% if isapp then %>									
				<!--<a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=');">-->
				<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93729')">								
				<% else %>
				<a href="/event/eventmain.asp?eventid=93729">
				<% end if %>					
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_01.jpg" alt="">
					</a>
				</div>
				<div class="swiper-slide">
				<% if isapp then %>									
				<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93725');">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93725">
				<% end if %>	
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_02.jpg" alt="">
					</a>
				</div>
				<div class="swiper-slide">
				<% if isapp then %>													
				<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93721');">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93721">
				<% end if %>	
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_03.jpg" alt="">
					</a>
				</div>
				<div class="swiper-slide">
				<% if isapp then %>									
				<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93724');">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93724">
				<% end if %>	
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_04.jpg" alt="">
					</a>
				</div>
				<div class="swiper-slide">
				<% if isapp then %>									
				<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93723');">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93723">
				<% end if %>	
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_05.jpg" alt="">
					</a>
				</div>
				<div class="swiper-slide">
				<% if isapp then %>									
				<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93727');">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93727">
				<% end if %>	
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_06.jpg" alt="">
					</a>
				</div>
				<div class="swiper-slide">
				<% if isapp then %>									
				<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93726');">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93726">
				<% end if %>	
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_07.jpg" alt="">
					</a>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
		<!-- 상품목록및배너 -->
		<div class="items type-grid">			
            <% 
            if Ubound(bestItemList) > 0 then
                for i = 0 to 1 '2섹션
                    if i = 0 then
                        disOption = 0
                    else
                        disOption = 51
                    end if
                    tmpIdx = 0
            %>
			<div class="section itemsection">
				<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_0<%=i+1%>.jpg" alt="" /></h3>
				<ul>
					<%'<!-- 상품 6 노출 더보기 버튼 누르면 +4 총 10 노출 -->%>
                    <%
                    for j = 0 to Ubound(bestItemList) - 1
                        if tmpIdx = numOfItems then exit for '10개 상품만 노출                        
                        couponPer = oExhibition.GetCouponDiscountStr(bestItemList(j).Fitemcoupontype, bestItemList(j).Fitemcouponvalue)
                        couponPrice = oExhibition.GetCouponDiscountPrice(bestItemList(j).Fitemcoupontype, bestItemList(j).Fitemcouponvalue, bestItemList(j).Fsellcash)                    
                        salePer     = CLng((bestItemList(j).Forgprice-bestItemList(j).Fsellcash)/bestItemList(j).FOrgPrice*100)
                        if bestItemList(j).Fsailyn = "Y" and bestItemList(j).Fitemcouponyn = "Y" then '세일
                            tempPrice = bestItemList(j).Fsellcash - couponPrice
                            saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                            couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                        elseif bestItemList(j).Fitemcouponyn = "Y" then
                            tempPrice = bestItemList(j).Fsellcash - couponPrice
                            saleStr = ""
                            couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                        elseif bestItemList(j).Fsailyn = "Y" then
                            tempPrice = bestItemList(j).Fsellcash
                            saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                            couponStr = ""                                              
                        else
                            tempPrice = bestItemList(j).Fsellcash
                            saleStr = ""
                            couponStr = ""                                              
                        end if                    
                    %>
                    <%                            
                        if bestItemList(j).Fpicksorting >= disOption  then                                                                    
                    %>                    
					<li>
                        <% if isapp = 1 then %>    
                        <a href="javascript:void(0)" onclick="fnAPPpopupProduct('<%=bestItemList(j).Fitemid%>');" >	
                        <% else %>
                        <a href="/category/category_itemPrd.asp?itemid=<%=bestItemList(j).Fitemid%>" >
                        <% end if %>	
							<div class="thumbnail">
								<img src="<%=bestItemList(j).FImageList%>" alt="" />
                                <% if bestItemList(j).FsellYn = "N" then %>
                                <b class="soldout">일시 품절</b>
                                <% end if %>
							</div>
							<div class="desc">
								<p class="name"><%=bestItemList(j).Fitemname%></p>
								<div class="price">
									<div class="unit">
                                        <b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b>
                                        <% response.write saleStr%>
                                        <% response.write couponStr%>
                                    </div>
								</div>
							</div>
						</a>
					</li>
                    <% 
                        tmpIdx = tmpIdx + 1 'index값 
                        else
                        end if
                    next 
                    %>
				</ul>                
				<button class="btn-more" style="display:<%=chkIIF(tmpIdx > 6, "","none")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_more.jpg" alt="더보기"></button>                
            </div>            
			<% if i = 0 then %>
			<div>
				<a href="/category/category_itemPrd.asp?itemid=2300712" onclick="TnGotoProduct('2300712');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_prd2300712.jpg" alt="당신을 향한 나의 사랑에 취해">
				</a>
			</div>
			<% else %>
			<div>
				<a href="/category/category_itemPrd.asp?itemid=2308431" onclick="TnGotoProduct('2308431');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_prd2308431.jpg?v=1.01" alt="딸기와 생크림의 조화는 언제나 옳다">
				</a>
			</div>	
			<% end if %>					    
            <% 
                next
            end if
            %>   			
			
            <% 
            if Ubound(detailGroupList) > 0 then 
                for i = 0 to Ubound(detailGroupList) - 1 
                tmpItemList = oExhibition.getItemsListProc( listType, 12, mastercode, detailGroupList(i).Fdetailcode, "", "")'리스트타입, 아이템수, 마스터코드, 디테일코드, 픽아이템, 카테고리sort            
                tmpImgCode = format(detailGroupList(i).Fdetailcode / 10 + 2, "00")                    
            %>			
			<div class="section itemsection">
				<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_<%=tmpImgCode%>.jpg" alt="<%=detailGroupList(i).Ftitle%>" /></h3>
                <% if Ubound(tmpItemList) > 0 then %>					
				<ul>
					<%'<!-- 상품 4 노출 더보기 버튼 누르면 +8 총 12 노출 -->%>
                    <%                      
                    for j = 0 to Ubound(tmpItemList) - 1                     
                    couponPer = oExhibition.GetCouponDiscountStr(tmpItemList(j).Fitemcoupontype, tmpItemList(j).Fitemcouponvalue)
                    couponPrice = oExhibition.GetCouponDiscountPrice(tmpItemList(j).Fitemcoupontype, tmpItemList(j).Fitemcouponvalue, tmpItemList(j).Fsellcash)                    
                    salePer     = CLng((tmpItemList(j).Forgprice-tmpItemList(j).Fsellcash)/tmpItemList(j).FOrgPrice*100)
                    if tmpItemList(j).Fsailyn = "Y" and tmpItemList(j).Fitemcouponyn = "Y" then '세일
                        tempPrice = tmpItemList(j).Fsellcash - couponPrice
                        saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                        couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                    elseif tmpItemList(j).Fitemcouponyn = "Y" then
                        tempPrice = tmpItemList(j).Fsellcash - couponPrice
                        saleStr = ""
                        couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                    elseif tmpItemList(j).Fsailyn = "Y" then
                        tempPrice = tmpItemList(j).Fsellcash
                        saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                        couponStr = ""                                              
                    else
                        tempPrice = tmpItemList(j).Fsellcash
                        saleStr = ""
                        couponStr = ""                                              
                    end if
                    %>                    
					<li>
                        <% if isapp = 1 then %>             
							<a href="javascript:fnAPPpopupProduct('<%=tmpItemList(j).Fitemid%>')" >							                                  	 	
                        <% else %>
                        	<a href="/category/category_itemPrd.asp?itemid=<%=tmpItemList(j).Fitemid%>">
                        <% end if %>
							<div class="thumbnail">
								<img src="<%=tmpItemList(j).FImageList%>" alt="" />
                                <% if tmpItemList(j).FsellYn = "N" then %>
                                <b class="soldout">일시 품절</b>
                                <% end if %>							
							</div>
							<div class="desc">
								<p class="name"><%=tmpItemList(j).Fitemname%></p>
								<div class="price">
                                    <b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b>
                                    <% response.write saleStr%>
                                    <% response.write couponStr%>
								</div>
							</div>
						</a>
					</li>
                    <% next %>
				</ul>                      
				<button class="btn-more" style="display:<%=chkIIF(Ubound(tmpItemList) > 4, "","none")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_more.jpg" alt="더보기"></button>
                <% end if %>
			</div>
            <%
                next
            end if 
            %>
        </div>
	</div>
	<!-- // 가정의 달 -->