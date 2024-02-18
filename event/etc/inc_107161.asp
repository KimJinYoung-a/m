<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 50만원으로 내 방 꾸미기
' History : 2020-06-29 조경애
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67507
Else
	eCode   =  107161
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.mEvt107161 {background:#eb7487;}
.mEvt107161 .tabContainer {margin-top:-0.05rem;}
.mEvt107161 .tabNav {position:absolute; left:0; top:0; width:100%; height:6.4rem;}
.mEvt107161 .tabNav li {width:50%; height:100%;}
.mEvt107161 .tabNav a {display:block; height:100%; text-indent:-999em;}
.mEvt107161 .inner {position:relative;}
.mEvt107161 .inner .pen {position:absolute; left:0; top:9.8rem; z-index:20; width:17.46%}
.mEvt107161 li {position:relative;}
.mEvt107161 li > a {display:block;}
.mEvt107161 li .price {position:absolute; left:41%; top:62%; padding:.5vw 0 0 10.67vw; color:#000; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107161/m/txt_price.png) no-repeat 0 50% / 8.67vw 3.73vw; font:normal 3.74vw/1.1 'CoreSansCBold';}
.mEvt107161 li .price s {display:none;}
.mEvt107161 li .price span {display:inline-block; height:4.53vw; margin:-.5vw 0 0 1.6vw; padding:0 1.33vw; color:#fff; font-size:3.3vw; line-height:5.1vw; background:#15032b; vertical-align:middle;}
.mEvt107161 li:first-child .price {top:58%;}
.mEvt107161 .total {position:relative;}
.mEvt107161 .total span {position:absolute; left:40%; top:30%; font-family:'NotoSansKRMedium'; font-size:6.6vw; color:#000;}
.mEvt107161 .total b {font-family:'CoreSansCBold'; font-size:7.2vw;}
.mEvt107161 .btn-group {position:relative;}
.mEvt107161 .btn-group a {display:block; position:absolute; left:2%; top:15%; width:47%; height:70%; text-indent:-999em;}
.mEvt107161 .btn-group a:last-child {left:50.5%;}
</style>
<script src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function() {
	$(".tabContent").hide();
	$(".tabContainer").find(".tabContent:first").show();
	 
	$(".tabNav li").click(function() {
		$(this).siblings("li").removeClass("current");
		$(this).addClass("current");
		$(this).closest(".tabNav").nextAll(".tabContainer:first").find(".tabContent").hide();
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});

	fnApplyItemInfoEach({
		items:"1943407,1752332,3059421,1835660,2602528,1858724,1729117,1510751,672273,1490116,3127447,3279723,3155557,1660717",
		target:"item",
		fields:["price","sale"],
		unit:"ew",
		saleBracket:false
	});
});
// 개별 상품 정보 업데이트
function fnApplyItemInfoEach(opts) {
	// 필터 정의
	var isImg=false, isNm=false, isPrc=false, isSale=false, isSld=false, isLmt=false, isTotalPrice=0;
	$(opts.fields).each(function(){
		switch(this.toString()){
			case "image" : isImg=true; break;
			case "name" : isNm=true; break;
			case "price" : isPrc=true; break;
			case "sale" : isSale=true; break;
			case "soldout" : isSld=true; break;
			case "limit" : isLmt=true; break;
		}
	});

	$.ajax({
		type: "get",
		url: "/event/etc/json/act_getItemInfo2.asp",
		data: "arriid="+opts.items+"&unit="+opts.unit,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(typeof(message.items)=="object") {
					var i=0;
					$(message.items).each(function(){
						// 상품 이미지 출력
						if(isImg){
							$("."+opts.target+this.itemid+" .thumbnail img").attr("src",this.imgurl);
						}
						// 상품명 출력
						if(isNm){
							$("."+opts.target+this.itemid+" .name").html(this.itemname);
						}
						
						// 판매가 출력
						if(isPrc){
							if(isSale){
								//할인율 표시
								if(this.saleper!="") {
									if(opts.saleBracket) {
										$("."+opts.target+this.itemid+" .price").html("<s>"+this.orgprice+"</s> "+this.sellprice+"<span>["+this.saleper+"]</span>");
									} else {
										$("."+opts.target+this.itemid+" .price").html("<s>"+this.orgprice+"</s> "+this.sellprice+"<span>"+this.saleper+"</span>");
									}
								
								} else {
									$("."+opts.target+this.itemid+" .price").html(this.sellprice);
								}
							}else{
								// 판매가 표시
								$("."+opts.target+this.itemid+" .price").html(this.sellprice);
							}
						}

						// 품절상품 표시
						if(isSld){
							if(this.soldout=="true") {
								$("."+opts.target+this.itemid).addClass("soldout");
							}
						}

						// 한정 남은갯수 표시
						if(isLmt){
							if(this.limityn=="Y") {
								$("#"+opts.target+" li .limit span").html(this.limitRemain);
							} else {
								$("#"+opts.target+" li .limit").hide();
							}
						}

						isTotalPrice += this.sellprice2;
						//alert(this.itemid + " / " + this.sellprice2 + " / " + isTotalPrice);
						if(this.itemid==2602528)
						{
							$("#totalprice1").empty().html(numberFormat(isTotalPrice)+"원");
							isTotalPrice=0;
						}
						else if(this.itemid==1660717)
						{
							$("#totalprice2").empty().html(numberFormat(isTotalPrice)+"원");
							isTotalPrice=0;
						}
						i++;
					});
				}
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
}


function numberFormat(num){
	num = num.toString();
	return num.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
}
</script>
			<div class="mEvt107161">
				<div class="inner">
					<div class="pen"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/img_pen.png" alt="" /></div>
					<ul class="tabNav">
						<li><a href="#furniture">텐텐 가구점</a></li>
						<li><a href="#props">텐텐 소품점</a></li>
					</ul>
					<div class="tabContainer">
						<!-- 가구점 -->
						<div id="furniture" class="tabContent">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tab_furniture.jpg" alt=""></div>
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tit_furniture.jpg" alt="텐텐 가구점"></h3>
							<ul>
								<li class="item1943407">
									<a href="/category/category_itemPrd.asp?itemid=1943407&pEtr=107161" onclick="TnGotoProduct('1943407');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_funiture_1.jpg" alt="두닷모노 하이엔 무소음 메모리폼 침대"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item1752332">
									<a href="/category/category_itemPrd.asp?itemid=1752332&pEtr=107161" onclick="TnGotoProduct('1752332');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_funiture_2.jpg" alt="마켓비 OLLSON 책상"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item3059421">
									<a href="/category/category_itemPrd.asp?itemid=3059421&pEtr=107161" onclick="TnGotoProduct('3059421');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_funiture_3.jpg" alt="BC체어 사무용 메쉬의자"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item1835660">
									<a href="/category/category_itemPrd.asp?itemid=1835660&pEtr=107161" onclick="TnGotoProduct('1835660');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_funiture_4.jpg" alt="왕자행거 GOTHEM (순수원목) 수납공간박스"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item2602528">
									<a href="/category/category_itemPrd.asp?itemid=2602528&pEtr=107161" onclick="TnGotoProduct('2602528');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_funiture_5.jpg" alt="어썸프레임 바인 루밍 행거 랙"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
							</ul>
							<div class="total">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/txt_total_1.png" alt="총액"></p>
								<span><b id="totalprice1"></b></span>
							</div>
						</div>
						<!-- 소품점 -->
						<div id="props" class="tabContent">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tab_props.jpg" alt=""></div>
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tit_props.jpg" alt="텐텐 소품점"></h3>
							<ul>
								<li class="item1858724">
									<a href="/category/category_itemPrd.asp?itemid=1858724&pEtr=107161" onclick="TnGotoProduct('1858724');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_1.jpg" alt="아이르 큐브 차렵이불"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item1729117">
									<a href="/category/category_itemPrd.asp?itemid=1729117&pEtr=107161" onclick="TnGotoProduct('1729117');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_2.jpg" alt="프리즘 RUSTA 장스탠드"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item1510751">
									<a href="/category/category_itemPrd.asp?itemid=1510751&pEtr=107161" onclick="TnGotoProduct('1510751');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_3.jpg" alt="까르데코 알로카시아 블랙 pot (50cm)"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item672273">
									<a href="/category/category_itemPrd.asp?itemid=672273&pEtr=107161" onclick="TnGotoProduct('672273');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_4.jpg" alt="매일리 호텔식 화이트 쉬폰 커튼"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item1490116">
									<a href="/category/category_itemPrd.asp?itemid=1490116&pEtr=107161" onclick="TnGotoProduct('1490116');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_5.jpg" alt="스마일리지 숲속의 향기 디퓨저 6종"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item3127447">
									<a href="/category/category_itemPrd.asp?itemid=3127447&pEtr=107161" onclick="TnGotoProduct('3127447');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_6.jpg" alt="어반던스 LED 조명 탁상거울"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item3279723">
									<a href="/category/category_itemPrd.asp?itemid=3279723&pEtr=107161" onclick="TnGotoProduct('3279723');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_7.jpg" alt="더프리그 명화 빈티지 전시회 포스터"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item3155557">
									<a href="/category/category_itemPrd.asp?itemid=3155557&pEtr=107161" onclick="TnGotoProduct('3155557');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_8.jpg" alt="피너츠 스누피 원형러그 1200"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								<li class="item1660717">
									<a href="/category/category_itemPrd.asp?itemid=1660717&pEtr=107161" onclick="TnGotoProduct('1660717');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_props_9.jpg" alt="데일리라이크 와이어 레터링 6종"></div>
										<p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
									</a>
								</li>
								
							</ul>
							<div class="total">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/txt_total_2.png" alt="총액"></p>
								<span><b id="totalprice2"></b></span>
							</div>
						</div>
					</div>
					<div class="btn-group">
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/btn_more.png" alt="" /></div>
						<a href="#group346522">가구 더 보러가기</a>
						<a href="#group346523">소품 더 보러가기</a>
					</div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->