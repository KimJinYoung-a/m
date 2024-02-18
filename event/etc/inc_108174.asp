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
	eCode = 67507
Else
	eCode = 108174
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.mEvt108174 {position:relative; overflow:hidden;}
.mEvt108174 .tabContainer {margin-top:-0.05rem;}
.mEvt108174 .tabNav {position:absolute; left:0; top:0; width:100%; height:6.4rem;}
.mEvt108174 .tabNav li {width:50%; height:100%;}
.mEvt108174 .tabNav a {display:block; height:100%; text-indent:-999em;}
.mEvt108174 .inner {position:relative;}
.mEvt108174 li {position:relative;}
.mEvt108174 li > a {display:block;}
.mEvt108174 li .price {position:absolute; left:41%; top:62%; padding:.5vw 0 0 14vw; font:normal 3.74vw/1.1 'CoreSansCBold'; color:#000; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108174/m/txt_price.png) no-repeat left center / auto 3.73vw;}
.mEvt108174 li .price s {display:none;}
.mEvt108174 li .price span {display:inline-block; height:4.53vw; margin:-.5vw 0 0 1.6vw; padding:0 1.33vw; color:#fff; font-size:3.3vw; line-height:5.1vw; background:#15032b; vertical-align:middle;}
.mEvt108174 .total {position:relative;}
.mEvt108174 .total span {position:absolute; left:40%; top:29%; font-family:'NotoSansKRMedium'; font-size:6.6vw; color:#000;}
.mEvt108174 .total b {font-family:'CoreSansCBold'; font-size:7.2vw;}
.mEvt108174 .btn-group {position:relative;}
.mEvt108174 .btn-group a {display:block; position:absolute; left:2%; top:15%; width:47%; height:70%; text-indent:-999em;}
.mEvt108174 .btn-group a:last-child {left:50.5%;}
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
		items:"774875,1819313,1440122,2228458,2289960,2584292,3358084,3477037,3371157,3180003,2686885,1791011",
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
						if(this.itemid==2289960)
						{
							$("#totalprice1").empty().html(numberFormat(isTotalPrice)+"원");
							isTotalPrice=0;
						}
						else if(this.itemid==1791011)
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
			<div class="mEvt108174">
				<div class="inner">
					<ul class="tabNav">
						<li><a href="#furniture">텐텐 가구점</a></li>
						<li><a href="#props">텐텐 소품점</a></li>
					</ul>
					<div class="tabContainer">
						<!-- 가구점 -->
						<div id="furniture" class="tabContent">
							<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/tab_furniture.jpg" alt=""></div>
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/tit_furniture.jpg" alt="텐텐 가구점"></h3>
							<ul>
								<li class="item774875">
									<a href="/category/category_itemPrd.asp?itemid=774875&pEtr=108174" onclick="TnGotoProduct('774875');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_furniture_1.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item1819313">
									<a href="/category/category_itemPrd.asp?itemid=1819313&pEtr=108174" onclick="TnGotoProduct('1819313');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_furniture_2.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item1440122">
									<a href="/category/category_itemPrd.asp?itemid=1440122&pEtr=108174" onclick="TnGotoProduct('1440122');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_furniture_3.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item2228458">
									<a href="/category/category_itemPrd.asp?itemid=2228458&pEtr=108174" onclick="TnGotoProduct('2228458');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_furniture_4.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item2289960">
									<a href="/category/category_itemPrd.asp?itemid=2289960&pEtr=108174" onclick="TnGotoProduct('2289960');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_furniture_5.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
							</ul>
							<div class="total">
								<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/txt_furniture.jpg" alt="총액"></p>
								<span><b id="totalprice1"></b></span>
							</div>
							<div class="btn-group">
								<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/btn_furniture.jpg" alt=""></div>
								<a href="#group350983">가구 더 보러가기</a>
								<a href="#group350984">소품 더 보러가기</a>
							</div>
						</div>
						<!-- 소품점 -->
						<div id="props" class="tabContent">
							<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/tab_props.jpg" alt=""></div>
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/tit_props.jpg" alt="텐텐 소품점"></h3>
							<ul>
								<li class="item2584292">
									<a href="/category/category_itemPrd.asp?itemid=2584292&pEtr=108174" onclick="TnGotoProduct('2584292');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_props_1.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item3358084">
									<a href="/category/category_itemPrd.asp?itemid=3358084&pEtr=108174" onclick="TnGotoProduct('3358084');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_props_2.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item3477037">
									<a href="/category/category_itemPrd.asp?itemid=3477037&pEtr=108174" onclick="TnGotoProduct('3477037');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_props_3.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item3371157">
									<a href="/category/category_itemPrd.asp?itemid=3371157&pEtr=108174" onclick="TnGotoProduct('3371157');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_props_4.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item3180003">
									<a href="/category/category_itemPrd.asp?itemid=3180003&pEtr=108174" onclick="TnGotoProduct('3180003');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_props_5.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item2686885">
									<a href="/category/category_itemPrd.asp?itemid=2686885&pEtr=108174" onclick="TnGotoProduct('2686885');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_props_6.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>
								<li class="item1791011">
									<a href="/category/category_itemPrd.asp?itemid=1791011&pEtr=108174" onclick="TnGotoProduct('1791011');return false;">
										<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/img_props_7.jpg" alt=""></div>
										<p class="price"></p>
									</a>
								</li>								
							</ul>
							<div class="total">
								<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/txt_props.jpg" alt="총액"></p>
								<span><b id="totalprice2"></b></span>
							</div>
							<div class="btn-group">
								<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108174/m/btn_props.jpg" alt=""></div>
								<a href="#group350983">가구 더 보러가기</a>
								<a href="#group350984">소품 더 보러가기</a>
							</div>
						</div>
					</div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->