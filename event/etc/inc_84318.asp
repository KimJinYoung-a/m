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
' History : 2018-02-13 정태훈
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67507
Else
	eCode   =  84318
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.mEvt84318 {background:#eb7487;}
.mEvt84318 .tabContainer {margin-top:-0.05rem;}
.mEvt84318 .tabNav {position:absolute; left:0; top:0; width:100%; height:6.4rem;}
.mEvt84318 .tabNav li {width:50%; height:100%;}
.mEvt84318 .tabNav a {display:block; height:100%; text-indent:-999em;}
.mEvt84318 .inner {position:relative;}
.mEvt84318 .inner .pen {position:absolute; left:0; top:9.8rem; z-index:20; width:17.46%}
.mEvt84318 .inner li {position:relative;}
.mEvt84318 .inner li > a {display:block;}
.mEvt84318 .inner li .price {position:absolute; left:52%; top:62.8%; font-size:1.2rem; line-height:1; font-weight:600; color:#000;}
.mEvt84318 .inner li .price s {display:none;}
.mEvt84318 .inner li .price span {display:inline-block; position:relative; top:-1px; height:1.45rem; margin-left:5px; padding:0 0.34rem; color:#fff; font-size:1.1rem; line-height:1.6rem; background:#000;}
.mEvt84318 .inner li:first-child .price {top:58%;}
.mEvt84318 .total {position:relative;}
.mEvt84318 .total span {position:absolute; left:40%; top:30%; font-size:2.3rem; line-height:1; font-weight:bold; color:#000;}
.mEvt84318 .btn-group {position:relative;}
.mEvt84318 .btn-group a {display:block; position:absolute; left:2%; top:15%; width:47%; height:70%; text-indent:-999em;}
.mEvt84318 .btn-group a:last-child {left:50.5%;}
.video {position:relative; padding-bottom:56%;}
.video iframe {position:absolute; left:0; top:0; width:100%; height:100%;}
</style>
<script src="/lib/js/jquery.tinyscrollbar.js"></script>
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
		items:"1702350,1752332,1764193,1835660,1899244,1858724,1729117,1510751,672273,1490116,1883108,1852627,281012,1660717",
		target:"item",
		fields:["price","sale"],
		unit:"hw",
		saleBracket:false
	});
	$('.scrollbarwrap').tinyscrollbar();
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
						if(this.itemid==1899244)
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
			<div class="mEvt84318">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/tit_room.jpg" alt="50만원으로 내 방 꾸미기" /></h2>
				<div class="video">
					<iframe src="https://www.youtube.com/embed/bk7WAurAHIw" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>
				</div>
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
								<li class="item1702350">
									<a href="/category/category_itemPrd.asp?itemid=1702350&pEtr=84318" onclick="TnGotoProduct('1702350');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_furniture_1.jpg?v=1.1" alt="로디 일체형 침대 S (높은다릿발)" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1752332">
									<a href="/category/category_itemPrd.asp?itemid=1752332&pEtr=84318" onclick="TnGotoProduct('1752332');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_furniture_2.jpg?v=1.1" alt="OLLSON 책상" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1764193">
									<a href="/category/category_itemPrd.asp?itemid=1764193&pEtr=84318" onclick="TnGotoProduct('1764193');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_furniture_3.jpg?v=1.1" alt="RAMIRA 의자" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1835660">
									<a href="/category/category_itemPrd.asp?itemid=1835660&pEtr=84318" onclick="TnGotoProduct('1835660');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_furniture_4.jpg?v=1.1" alt="GOTHEM (순수원목) 수납공간박스" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1899244">
									<a href="/category/category_itemPrd.asp?itemid=1899244&pEtr=84318" onclick="TnGotoProduct('1899244');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_furniture_5.jpg?v=1.1" alt="아크 코트 랙 내추럴" /></div>
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
								<li class="item1858724">
									<a href="/category/category_itemPrd.asp?itemid=1858724&pEtr=84318" onclick="TnGotoProduct('1858724');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_1.jpg?v=1.1" alt="큐브 차렵이불 (SQ)" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1729117">
									<a href="/category/category_itemPrd.asp?itemid=1729117&pEtr=84318" onclick="TnGotoProduct('1729117');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_2.jpg?v=1.1" alt="RUSTA 장스탠드" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1510751">
									<a href="/category/category_itemPrd.asp?itemid=1510751&pEtr=84318" onclick="TnGotoProduct('1510751');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_3.jpg?v=1.1" alt="알로카시아 블랙 pot (50cm)" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item672273">
									<a href="/category/category_itemPrd.asp?itemid=672273&pEtr=84318" onclick="TnGotoProduct('672273');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_4.jpg?v=1" alt="호텔식 화이트 시폰 커튼" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1490116">
									<a href="/category/category_itemPrd.asp?itemid=1490116&pEtr=84318" onclick="TnGotoProduct('1490116');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_5.jpg?v=1.3" alt="숲속의 향기 디퓨저 6종" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1883108">
									<a href="/category/category_itemPrd.asp?itemid=1883108&pEtr=84318" onclick="TnGotoProduct('1883108');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_6.jpg?v=1.1" alt="프리미엄 LED 조명 탁상거울" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1852627">
									<a href="/category/category_itemPrd.asp?itemid=1852627&pEtr=84318" onclick="TnGotoProduct('1852627');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_7.jpg?v=1.1" alt="패브릭 포스터 열대 나뭇잎" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item281012">
									<a href="/category/category_itemPrd.asp?itemid=281012&pEtr=84318" onclick="TnGotoProduct('281012');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_8.jpg?v=1.1" alt="한일카페트 터치미 러그" /></div>
										<p class="price">가격</p>
									</a>
								</li>
								<li class="item1660717">
									<a href="/category/category_itemPrd.asp?itemid=1660717&pEtr=84318" onclick="TnGotoProduct('1660717');return false;">
										<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/img_props_9.jpg?v=1.1" alt="와이어 레터링 6종" /></div>
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
						<a href="#group236658">가구 더 보러가기</a>
						<a href="#group236659">소품 더 보러가기</a>
					</div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->