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
	eCode   =  103730
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.mEvt103730 {background:#eb7487;}
.mEvt103730 .tabContainer {margin-top:-0.05rem;}
.mEvt103730 .tabNav {position:absolute; left:0; top:0; width:100%; height:6.4rem;}
.mEvt103730 .tabNav li {width:50%; height:100%;}
.mEvt103730 .tabNav a {display:block; height:100%; text-indent:-999em;}
.mEvt103730 .inner {position:relative;}
.mEvt103730 .inner .pen {position:absolute; left:0; top:9.8rem; z-index:20; width:17.46%}
.mEvt103730 li {position:relative;}
.mEvt103730 li > a {display:block;}
.mEvt103730 li .price {position:absolute; left:41%; top:62%; padding:.5vw 0 0 10.67vw; color:#000; background:url(//webimage.10x10.co.kr/fixevent/event/2020/103730/m/txt_price.png) no-repeat 0 50% / 8.67vw 3.73vw; font:normal 3.74vw/1.1 'CoreSansCBold';}
.mEvt103730 li .price s {display:none;}
.mEvt103730 li .price span {display:inline-block; height:4.53vw; margin:-.5vw 0 0 1.6vw; padding:0 1.33vw; color:#fff; font-size:3.3vw; line-height:5.1vw; background:#15032b; vertical-align:middle;}
.mEvt103730 li:first-child .price {top:58%;}
.mEvt103730 .total {position:relative;}
.mEvt103730 .total span {position:absolute; left:40%; top:30%; font-family:'NotoSansKRMedium'; font-size:6.6vw; color:#000;}
.mEvt103730 .total b {font-family:'CoreSansCBold'; font-size:7.2vw;}
.mEvt103730 .btn-group {position:relative;}
.mEvt103730 .btn-group a {display:block; position:absolute; left:2%; top:15%; width:47%; height:70%; text-indent:-999em;}
.mEvt103730 .btn-group a:last-child {left:50.5%;}
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
		items:"1654161,2956066,2865205,1231688,2232979,2841681,1654118,1370223,1891212,2655010,1996706,2595057",
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
						if(this.itemid==2232979)
						{
							$("#totalprice1").empty().html(numberFormat(isTotalPrice)+"원");
							isTotalPrice=0;
						}
						else if(this.itemid==2595057)
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
			<div class="mEvt103730">
				<div class="inner">
					<div class="pen"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/img_pen.png" alt="" /></div>
					<ul class="tabNav">
						<li><a href="#furniture">텐텐 가구점</a></li>
						<li><a href="#props">텐텐 소품점</a></li>
					</ul>
					<div class="tabContainer">
						<!-- 가구점 -->
						<div id="furniture" class="tabContent">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tab_furniture.jpg" alt="" /></div>
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tit_furniture.jpg" alt="텐텐 가구점" /></h3>
							<ul>
								<li class="item1654161">
									<a href="/category/category_itemPrd.asp?itemid=1654161&pEtr=103730" onclick="TnGotoProduct('1654161');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_furniture_1.jpg" alt="로디 일체형 침대" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item2956066">
									<a href="/category/category_itemPrd.asp?itemid=2956066&pEtr=103730" onclick="TnGotoProduct('2956066');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_furniture_2.jpg" alt="OLLSON 책상 + FIHA 서랍장 6단 세트" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item2865205">
									<a href="/category/category_itemPrd.asp?itemid=2865205&pEtr=103730" onclick="TnGotoProduct('2865205');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_furniture_3.jpg" alt="컴퓨터 책상 학생 의자 709 BLACK FRAME" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1231688">
									<a href="/category/category_itemPrd.asp?itemid=1231688&pEtr=103730" onclick="TnGotoProduct('1231688');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_furniture_4.jpg" alt="화이트 2단행거" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item2232979">
									<a href="/category/category_itemPrd.asp?itemid=2232979&pEtr=103730" onclick="TnGotoProduct('2232979');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_furniture_5.jpg" alt="팔각 골드 대형전신거울" /></div>
										<p class="price">가격</p>
									</a>
								</li>
							</ul>
							<div class="total">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/txt_total_1.png" alt="총액" /></p>
								<span id="totalprice1">300,000원</span>
							</div>
						</div>
						<!-- 소품점 -->
						<div id="props" class="tabContent">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tab_props.jpg" alt="" /></div>
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tit_props.jpg" alt="텐텐 소품점" /></h3>
							<ul>
								<li class="item2841681">
									<a href="/category/category_itemPrd.asp?itemid=2841681&pEtr=103730" onclick="TnGotoProduct('2841681');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_props_1.jpg" alt="시어서커 여름 차렵침구" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1654118">
									<a href="/category/category_itemPrd.asp?itemid=1654118&pEtr=103730" onclick="TnGotoProduct('1654118');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_props_2.jpg" alt="프리즘 충전식 무선 LED 스탠드" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1370223">
									<a href="/category/category_itemPrd.asp?itemid=1370223&pEtr=103730" onclick="TnGotoProduct('1370223');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_props_3.jpg" alt="노르딕솔리드 작은창 암막커튼" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1891212">
									<a href="/category/category_itemPrd.asp?itemid=1891212&pEtr=103730" onclick="TnGotoProduct('1891212');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_props_4.jpg" alt="매일리 디퓨져" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item2655010">
									<a href="/category/category_itemPrd.asp?itemid=2655010&pEtr=103730" onclick="TnGotoProduct('2655010');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_props_5.jpg" alt="라이프썸 LED 거울" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1996706">
									<a href="/category/category_itemPrd.asp?itemid=1996706&pEtr=103730" onclick="TnGotoProduct('1996706');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_props_6.jpg" alt="메모리얼 드로잉 패브릭 포스터 / 가리개커튼" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item2595057">
									<a href="/category/category_itemPrd.asp?itemid=2595057&pEtr=103730" onclick="TnGotoProduct('2595057');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103730/m/img_props_7.jpg" alt="사계절 심플 단모 거실 침실 원형 러그" /></div>
										<p class="price">가격</p>
									</a>
								</li>
							</ul>
							<div class="total">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/txt_total_2.png" alt="총액" /></p>
								<span id="totalprice2">300,000원</span>
							</div>
						</div>
					</div>
					<div class="btn-group">
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/btn_more.png" alt="" /></div>
						<a href="#group330878">가구 더 보러가기</a>
						<a href="#group330879">소품 더 보러가기</a>
					</div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->