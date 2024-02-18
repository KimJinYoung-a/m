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
	eCode = 109374
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.mEvt109374 {background:#eb7487;}
.mEvt109374 .tabContainer {margin-top:-0.05rem;}
.mEvt109374 .tabNav {position:absolute; left:0; top:0; width:100%; height:6.4rem;}
.mEvt109374 .tabNav li {width:50%; height:100%;}
.mEvt109374 .tabNav a {display:block; height:100%; text-indent:-999em;}
.mEvt109374 .inner {position:relative;}
.mEvt109374 .inner .pen {position:absolute; left:0; top:9.8rem; z-index:20; width:17.46%}
.mEvt109374 li {position:relative;}
.mEvt109374 li > a {display:block;}
.mEvt109374 li .price {position:absolute; left:41%; top:62%; padding:.5vw 0 0 10.67vw; color:#000; background:url(//webimage.10x10.co.kr/fixevent/event/2020/103730/m/txt_price.png) no-repeat 0 50% / 8.67vw 3.73vw; font:normal 3.74vw/1.1 'CoreSansCBold';}
.mEvt109374 li .price s {display:none;}
.mEvt109374 li .price span {display:inline-block; height:4.53vw; margin:-.5vw 0 0 1.6vw; padding:0 1.33vw; color:#fff; font-size:3.3vw; line-height:5.1vw; background:#15032b; vertical-align:middle;}
.mEvt109374 li:first-child .price {top:58%;}
.mEvt109374 .total {position:relative;}
.mEvt109374 .total span {position:absolute; left:40%; top:30%; font-family:'NotoSansKRMedium'; font-size:6.6vw; color:#000;}
.mEvt109374 .total b {font-family:'CoreSansCBold'; font-size:7.2vw;}
.mEvt109374 .btn-group {position:relative;}
.mEvt109374 .btn-group a {display:block; position:absolute; left:2%; top:15%; width:47%; height:70%; text-indent:-999em;}
.mEvt109374 .btn-group a:last-child {left:50.5%;}
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
		items:"1943407,3424811,3497491,1897983,3525290,1786635,3312585,1510751,672273,1490116,3140163,3279723",
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
						if(this.itemid==3525290)
						{
							$("#totalprice1").empty().html(numberFormat(isTotalPrice)+"원");
							isTotalPrice=0;
						}
						else if(this.itemid==3279723)
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
<div class="mEvt109374">
    <div><img src="http://webimage.10x10.co.kr/eventIMG/2020/107161/main_mo20201104121630.JPEG"></div>
    <div class="inner">
        <div class="pen"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/img_pen.png" alt=""></div>
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
                        <a href="/category/category_itemPrd.asp?itemid=1943407&pEtr=109374" onclick="TnGotoProduct('1943407');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107161/m/img_funiture_1.jpg" alt="하이엔 무소음 메모리폼 침대 S"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item3424811">
                        <a href="/category/category_itemPrd.asp?itemid=3424811&pEtr=109374" onclick="TnGotoProduct('3424811');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_funiture_2.jpg" alt="싱글 코너 컴퓨터 책상 테이블"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item3497491">
                        <a href="/category/category_itemPrd.asp?itemid=3497491&pEtr=109374" onclick="TnGotoProduct('3497491');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_funiture_3.jpg" alt="호텔패브릭원단 silly 좌식의자"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item1897983">
                        <a href="/category/category_itemPrd.asp?itemid=1897983&pEtr=109374" onclick="TnGotoProduct('1897983');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_funiture_4.jpg" alt="gruet 트롤리 2단"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item3525290">
                        <a href="/category/category_itemPrd.asp?itemid=3525290&pEtr=109374" onclick="TnGotoProduct('3525290');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_funiture_5.jpg" alt="매거진랙 3단 북선반"></div>
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
                    <li class="item1786635">
                        <a href="/category/category_itemPrd.asp?itemid=1786635&pEtr=109374" onclick="TnGotoProduct('1786635');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_props_1.jpg" alt="허그미 프리미엄 차렵이불"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item3312585">
                        <a href="/category/category_itemPrd.asp?itemid=3312585&pEtr=109374" onclick="TnGotoProduct('3312585');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_props_2.jpg" alt="kolony 캔들워머 전구증정"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item1510751">
                        <a href="/category/category_itemPrd.asp?itemid=1510751&pEtr=109374" onclick="TnGotoProduct('1510751');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_props_3.jpg" alt="알로카시아 블랙 pot (50cm)"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item672273">
                        <a href="/category/category_itemPrd.asp?itemid=672273&pEtr=109374" onclick="TnGotoProduct('672273');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_props_4.jpg" alt="호텔식 화이트 쉬폰 커튼"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item1490116">
                        <a href="/category/category_itemPrd.asp?itemid=1490116&pEtr=109374" onclick="TnGotoProduct('1490116');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_props_5.jpg" alt="숲속의 향기 디퓨저 6종"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item3140163">
                        <a href="/category/category_itemPrd.asp?itemid=3140163&pEtr=109374" onclick="TnGotoProduct('3140163');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_props_6.jpg" alt="루밍 LED 메이크업 조명거울"></div>
                            <p class="price"><s>200,000won</s> 145,000won<span>28%</span></p>
                        </a>
                    </li>
                    <li class="item3279723">
                        <a href="/category/category_itemPrd.asp?itemid=3279723&pEtr=109374" onclick="TnGotoProduct('3279723');return false;">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109374/m/img_props_7.jpg" alt="명화 빈티지 전시회 포스터"></div>
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
            <div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84318/m/v2/btn_more.png" alt=""></div>
            <a href="#group356784">가구 더 보러가기</a>
            <a href="#group356785">소품 더 보러가기</a>
        </div>
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->