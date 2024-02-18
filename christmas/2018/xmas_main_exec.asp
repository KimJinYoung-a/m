<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 크리스마스 기획전
' History : 2018-11-12 최종원 생성
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
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- <base href="http://m.10x10.co.kr/"> -->
<%
dim vGaparam, gnbflag
dim strGaParam, strGnbStr
Dim oExhibition
dim mastercode, detailcode
dim i
dim vAdrVer
'10 : 조명
'20 : 트리/리스
'30 : 오너먼트
'40 : 캔들/디퓨저
'50 : 선물
'60 : 카드
mastercode = requestCheckvar(request("mastercode"),10)
detailcode = requestCheckvar(request("detailcode"),10)
vGaparam = request("gaparam")
gnbflag = RequestCheckVar(request("gnbflag"),1)

if vGaparam <> "" then strGaParam = "&gaparam=" & vGaparam
if gnbflag <> "" then strGnbStr = "&gnbflag=1"

vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0

mastercode = 1
detailcode = 20

SET oExhibition = new ExhibitionCls
	oExhibition.FrectMasterCode = mastercode
	oExhibition.FrectDetailCode = detailcode
	oExhibition.getExhibitionBestItemList
%>
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
$(function() {
	// tag
	var tagSwiper = new Swiper (".xmas-insta .tag .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});

	// 상품 목록형 호출
	fnApplyItemInfoList({
		items:"1835482,1835481,2133943",
		target:"item-list12",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"1592309,1836968,1853438",
		target:"item-list11",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"2131750,2131756,1835684",
		target:"item-list10",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"2138564,2138565",
		target:"item-list09",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"1850308,2133949,1825976",
		target:"item-list08",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"2084744,2027509,2118946",
		target:"item-list07",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"1552103,1553649,1862657",
		target:"item-list06",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"2131751,2131757,2131753",
		target:"item-list05",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"1898768,1616744,2133969",
		target:"item-list04",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"1867552,1963286,1963285",
		target:"item-list03",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"2145656,1380085,1594881",
		target:"item-list02",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	fnApplyItemInfoList({
		items:"2130089,2124595,1603439",
		target:"item-list01",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:true
	});
});
</script>
	<!-- contents -->
	<div id="content" class="content xmas2018">
		<h2><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/tit_xmas.gif" alt="Christmas Record - 찰칵, 당신의 크리스마스를 담아요" /></h2>
		<div class="xmas-tab">
			<img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/tab_xmas_01.jpg" alt="" />
			<span class="txt-pick"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt-pick.png" alt="PICK" /></span>
			<ul>
				<li class="on"><a href="./index.asp?link=1&gnbflag=1<%=strGaParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_tab','tabname','한컷크리스마스');">한 컷 크리스마스</a></li>
				<li><a href="./index.asp?link=2&gnbflag=1<%=strGaParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_tab','tabname','추천상품');">추천 상품</a></li>
			</ul>
		</div>
		<!-- 피드 -->
		<div class="xmas-insta">
			<!-- no.10 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=2131750" onclick="TnGotoProduct('2131750');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_10.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_10.png" alt="no.10" /></b>
					<p>인플루언서의 크리스마스가<br>그림의 떡이라는 생각은 오산.<br>`텐바이텐 지침서`를 따라본다.<br>바스켓 속에 무심한 듯 담긴 트리,<br>그 옆에 자리한 캔들과 솔방울,<br>자연스럽게 걸쳐진 전구까지 -<br><br>그림의 떡이었던 그 피드는<br>오늘부터 누워서 떡 먹기.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide go-evt"><a href= "/event/eventmain.asp?eventid=90632" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90632');return false;">토크어바웃</a></li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=생화트리" class="mWeb">#생화트리</a>
								<a href="javascript:fnSearchEventText('생화트리');" class="mApp">#생화트리</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=크리스마스" class="mWeb">#크리스마스</a>
								<a href="javascript:fnSearchEventText('크리스마스');" class="mApp">#크리스마스</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=캔들" class="mWeb">#캔들</a>
								<a href="javascript:fnSearchEventText('캔들');" class="mApp">#캔들</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list10">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2131750" onclick="fnAPPpopupProduct('2131750');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2131756" onclick="fnAPPpopupProduct('2131756');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1835684" onclick="fnAPPpopupProduct('1835684');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- 기획전 띠배너 -->
			<a href= "/event/eventmain.asp?eventid=90516" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90516'); return false;" class="bnr-mid"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_90516.jpg" alt="Small, but good thing - 진심을 담은 크리스마스 카드 한 장" /></a>

			<!-- no.09 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=2138564" onclick="TnGotoProduct('2138564');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_09.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_09.png" alt="no.9" /></b>
					<p>누군가의 겨울이 따뜻하길 바라는<br>마음을 담아 모자 뜨기를 시작했다.<br>코 뜨기부터 배우는 초보 뜨개러지만,<br>나의 서툰 솜씨가 다른 이에겐<br>서툴지 않은 도움이 될 수 있기를.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide go-evt"><a href= "/event/eventmain.asp?eventid=90361" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90361');return false;">세이브더칠드런</a></li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=뜨개질" class="mWeb">#뜨개질</a>
								<a href="javascript:fnSearchEventText('뜨개질');" class="mApp">#뜨개질</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=모자뜨기" class="mWeb">#모자뜨기</a>
								<a href="javascript:fnSearchEventText('모자뜨기');" class="mApp">#모자뜨기</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list09">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2138564" onclick="fnAPPpopupProduct('2138564');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2138565" onclick="fnAPPpopupProduct('2138565');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- no.08 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=1850308" onclick="TnGotoProduct('1850308');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_08.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_08.png" alt="no.8" /></b>
					<p>멀리서 구경만 하던 벽트리를<br>올해 처음으로 주문해봤다.<br>생각보다 많은 오너먼트에<br>`언제 다 걸지` 걱정도 잠시 뿐.<br>어느덧 장인 정신으로 트리를<br>장식하고 있는 나를 발견했다.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide go-evt"><a href= "/event/eventmain.asp?eventid=90486" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90486');return false;">더플라워마켓</a></li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=벽트리" class="mWeb">#벽트리</a>
								<a href="javascript:fnSearchEventText('벽트리');" class="mApp">#벽트리</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=행잉트리" class="mWeb">#행잉트리</a>
								<a href="javascript:fnSearchEventText('행잉트리');" class="mApp">#행잉트리</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=오너먼트" class="mWeb">#오너먼트</a>
								<a href="javascript:fnSearchEventText('오너먼트');" class="mApp">#오너먼트</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list08">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1850308" onclick="fnAPPpopupProduct('1850308');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2133949" onclick="fnAPPpopupProduct('2133949');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1825976" onclick="fnAPPpopupProduct('1825976');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- no.07 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=2084744" onclick="TnGotoProduct('2084744');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_07.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_07.png" alt="no.7" /></b>
					<p>뜨끈한 국물이 생각나는 계절.<br>고기, 버섯, 배추 등 각종 재료를<br>듬뿍 넣고 끓어오르길 기다린다.<br>보글보글 소리는 애피타이저,<br>맛보기 국물 한 숟갈과 함께<br>저녁 식사의 서막이 오른다.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=밀푀유나베" class="mWeb">#밀푀유나베</a>
								<a href="javascript:fnSearchEventText('밀푀유나베');" class="mApp">#밀푀유나베</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=국물요리" class="mWeb">#국물요리</a>
								<a href="javascript:fnSearchEventText('국물요리');" class="mApp">#국물요리</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=주물냄비" class="mWeb">#주물냄비</a>
								<a href="javascript:fnSearchEventText('주물냄비');" class="mApp">#주물냄비</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list07">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2084744" onclick="fnAPPpopupProduct('2084744');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2027509" onclick="fnAPPpopupProduct('2027509');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2118946" onclick="fnAPPpopupProduct('2118946');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- no.06 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=1552103" onclick="TnGotoProduct('1552103');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_06.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_06.png" alt="no.6" /></b>
					<p>잠깐, 중요한 걸 잊을 뻔했다.<br>국물 요리에 빠지면 서운한 `그것`<br>시원한 나베 국물 한 모금에<br>달 한 잔, 두 잔 곁들인다면<br>음식이 더 맛있어지는 건 안 비밀 -</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=술잔" class="mWeb">#술잔</a>
								<a href="javascript:fnSearchEventText('술잔');" class="mApp">#술잔</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=주병선물세트" class="mWeb">#주병선물세트</a>
								<a href="javascript:fnSearchEventText('주병선물세트');" class="mApp">#주병선물세트</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=소주잔" class="mWeb">#소주잔</a>
								<a href="javascript:fnSearchEventText('소주잔');" class="mApp">#소주잔</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list06">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1552103" onclick="fnAPPpopupProduct('1552103');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1553649" onclick="fnAPPpopupProduct('1553649');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1862657" onclick="fnAPPpopupProduct('1862657');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- no.05 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=2131751" onclick="TnGotoProduct('2131751');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_05.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_05.png" alt="no.5" /></b>
					<p>자칭 미니멀리스트인 나에게<br>가랜드는 매우 바람직한 소품이다.<br>최소한의 공간을 차지하면서도,<br>최대한의 느낌을 채워주니 말이다.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide go-evt"><a href= "/event/eventmain.asp?eventid=90632" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90632');return false;">토크어바웃</a></li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=가랜드" class="mWeb">#가랜드</a>
								<a href="javascript:fnSearchEventText('가랜드');" class="mApp">#가랜드</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=행잉테리어" class="mWeb">#행잉테리어</a>
								<a href="javascript:fnSearchEventText('행잉테리어');" class="mApp">#행잉테리어</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=단독상품" class="mWeb">#단독상품</a>
								<a href="javascript:fnSearchEventText('단독상품');" class="mApp">#단독상품</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list05">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2131751" onclick="fnAPPpopupProduct('2131751');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2131757" onclick="fnAPPpopupProduct('2131757');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2131753" onclick="fnAPPpopupProduct('2131753');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- 기획전 띠배너 -->
			<a href= "/event/eventmain.asp?eventid=90518" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90518');return false;" class="bnr-mid"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_90518.jpg" alt="Just Two of us - 오직 둘만의 이유있는 커플 아이템" /></a>

			<!-- no.04 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=1898768" onclick="TnGotoProduct('1898768');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_04.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_04.png" alt="no.4" /></b>
					<p>`핑크`라면 눈이 반짝이는<br>혜민이를 위한 크리스마스랄까.<br>어쩌면 그녀는 사진 속 상품들을<br>벌써 장바구니에 담았을 지도 모른다.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide go-evt"><a href= "/event/eventmain.asp?eventid=90560" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90560');return false;">오이뮤선향</a></li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=캔들" class="mWeb">#캔들</a>
								<a href="javascript:fnSearchEventText('캔들');" class="mApp">#캔들</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=캔들홀더" class="mWeb">#캔들홀더</a>
								<a href="javascript:fnSearchEventText('캔들홀더');" class="mApp">#캔들홀더</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=허니플라밍고" class="mWeb">#허니플라밍고</a>
								<a href="javascript:fnSearchEventText('허니플라밍고');" class="mApp">#허니플라밍고</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list04">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1898768" onclick="fnAPPpopupProduct('1898768');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1616744" onclick="fnAPPpopupProduct('1616744');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2133969" onclick="fnAPPpopupProduct('2133969');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- no.03 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=1867552" onclick="TnGotoProduct('1867552');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_03.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_03.png" alt="no.3" /></b>
					<p>편한 사람들과 편안한 모습으로<br>소소하게 즐기는 오후의 티타임.<br>준비물은 생각보다 간단하다.<br>무엇을 올려놓아도 느낌 있는<br>우드 플레이트와 다쿠아즈 두 조각 -<br>어느 카페가 부럽지 않을걸.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=디저트" class="mWeb">#디저트</a>
								<a href="javascript:fnSearchEventText('디저트');" class="mApp">#디저트</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=다쿠아즈" class="mWeb">#다쿠아즈</a>
								<a href="javascript:fnSearchEventText('다쿠아즈');" class="mApp">#다쿠아즈</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=우드플레이트" class="mWeb">#우드플레이트</a>
								<a href="javascript:fnSearchEventText('우드플레이트');" class="mApp">#우드플레이트</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=홈파티" class="mWeb">#홈파티</a>
								<a href="javascript:fnSearchEventText('홈파티');" class="mApp">#홈파티</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list03">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1867552" onclick="fnAPPpopupProduct('1867552');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1963286" onclick="fnAPPpopupProduct('1963286');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1963285" onclick="fnAPPpopupProduct('1963285');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- 기획전 띠배너 -->
			<a href= "/event/eventmain.asp?eventid=90432" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90432');return false;" class="bnr-mid"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_90432.jpg" alt="가장 달콤한 크리스마스 - 특별한 사람과 함께하는 특별한 음식" /></a>

			<!-- no.02 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=2145656" onclick="TnGotoProduct('2145656');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_02.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_02.png" alt="no.2" /></b>
					<p>새까맣고 기나긴 겨울밤을<br>노오란 빛으로 채워본다.<br>별게 아니라고 생각했던<br>작은 조명 하나가 방 안을<br>온통 크리스마스로 만들었다.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide go-evt"><a href= "/event/eventmain.asp?eventid=90489" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90489');return false;">블루밍앤미</a></li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=무드등" class="mWeb">#무드등</a>
								<a href="javascript:fnSearchEventText('무드등');" class="mApp">#무드등</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=크리스마스조명" class="mWeb">#크리스마스조명</a>
								<a href="javascript:fnSearchEventText('크리스마스조명');" class="mApp">#크리스마스조명</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list02">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2145656" onclick="fnAPPpopupProduct('2145656');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1380085" onclick="fnAPPpopupProduct('1380085');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1594881" onclick="fnAPPpopupProduct('1594881');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- no.01 -->
			<div class="post">
				<div class="img"><a href="/category/category_itemPrd.asp?itemid=2130089" onclick="TnGotoProduct('2130089');return false;"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_feed_01.jpg" alt="" /></a></div>
				<div class="txt">
					<b class="num"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_insta_no_01.png" alt="no.1" /></b>
					<p>소나무 위 소담히 내려앉은 눈처럼<br>몽글몽글 목화와 솔잎이 조화롭다.<br>은은한 일랑일랑 향을 더한다면<br>그것은 나의 인생 디퓨저.</p>
				</div>
				<div class="tag">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide go-evt"><a href= "/event/eventmain.asp?eventid=90489" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90489');return false;">블루밍앤미</a></li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=목화" class="mWeb">#목화</a>
								<a href="javascript:fnSearchEventText('목화');" class="mApp">#목화</a>
							</li>
							<li class="swiper-slide">
								<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=디퓨저" class="mWeb">#디퓨저</a>
								<a href="javascript:fnSearchEventText('디퓨저');" class="mApp">#디퓨저</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="item-list">
					<ul id="item-list01">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2130089" onclick="fnAPPpopupProduct('2130089');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_01.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2124595" onclick="fnAPPpopupProduct('2124595');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_02.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1603439" onclick="fnAPPpopupProduct('1603439');return false;">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_insta_item_03.jpg" alt="" /></div>
								<div class="desc">
									<p class="name">캔들 기프트 패키지</p>
									<div class="price"><s>57,300원</s> 39,600원<span>[31%]</span></div>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<!-- 하단 배너 -->
		<a href="/category/category_list.asp?disp=122113" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_bottom_category','','');" class="mWeb"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_xmas.jpg" alt="크리스마스 아이템 모두 보기" /></a>
		<!--<a href="" onclick="fnAPPpopupCategory('122113');return false;" class="mApp"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_xmas.jpg" alt="크리스마스 아이템 모두 보기" /></a>-->
		<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2018christmas_bottom_category','',''
		 ,function(bool){if(bool) {fnAPPpopupCategory('122113'); return false;}});" class="mApp">
			<img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_xmas.jpg" alt="크리스마스 아이템 모두 보기" />
		</a>		
		<a href="./index.asp?link=2&gnbflag=1<%=strGaParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_bottom_tab','tabname','추천아이템');"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_pick.jpg" alt="추천 상품 보기" /></a>
	</div>
	<!-- //contents -->