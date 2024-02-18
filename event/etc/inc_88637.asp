<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  아리따움 10주년 이벤트
' History : 2018-08-30 최종원 
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<style type="text/css">
.rolling {position:relative;}
.rolling .slideNav {position:absolute; top:50%; z-index:3; width:8.4%; margin-top:-1.37rem; background-color:transparent;}
.rolling .btnPrev {left:0;}
.rolling .btnNext {right:0;}
.special-item .txt {position:relative; background-color:#ffe0e7;}
.special-item .txt .btn-go {position:absolute; bottom:22.73%; padding:0 18.7%;  animation:bounce .8s 100; }
.special-item ul {overflow:hidden;}
.special-item ul li {float:left; width:50%;}
.noti {padding:4.13rem 0 3.7rem; background:#532d75;}
.noti h3 {width:6.36rem; margin:0 auto 1.37rem;}
.noti ul {padding:0 10%;}
.noti li {position:relative; padding-left:.51rem; margin-bottom:.47rem; color:#fff; font-size:1.05rem; line-height:1.54; text-indent:-.51rem; word-break:keep-all;}
.noti li em {color:#ff99b1;}
@keyframes bounce {
	from to {transform:translateX(12px); animation-timing-function:ease-out;}
	50% {transform:translateX(-12px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function(){
	itemSlide = new Swiper('.swiper .swiper-container',{
		loop:true,
		effect:'fade',
		autoplay:1800,
		autoplayDisableOnInteraction:false,
		speed:800,
		paginationClickable:true,
		prevButton:'#rolling .btnPrev',
		nextButton:'#rolling .btnNext'
	});
});
</script>
<div class="mEvt88637">
				<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/tit_aritaum.jpg" alt="아리따움 10주년 기념" /></h2>
                <div class="swiper rolling" id="rolling">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_slide_1.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_slide_2.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_slide_3.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_slide_4.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_slide_5.jpg" alt="" /></div>
                        </div>
                    </div>
					<button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/btn_next.png" alt="다음" /></button>
                </div>
				<div class="special-item">
					<div class="txt">
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/tit_special_gift.png" alt="아리따움 스페셜 에디션 구매하면 프로모션 상품이 1,000원!" />
						<a href="#group257052" class="btn-go"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/btn_go.png" alt="스페셜 에디션 구경하기" /></a>
					</div>
					<% If isApp="1" or isApp="2" Then %>					
					<ul>					
						<li>
							<a href="" onclick="TnGotoProduct('2074432');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_item_1.jpg" alt="파우치" /></a>
						</li>
						<li>
							<a href="" onclick="TnGotoProduct('2074445');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_item_2.jpg" alt="티슈케이스" /></a>
						</li>
						<li>
							<a href="" onclick="TnGotoProduct('2074465');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_item_3.jpg" alt="노트3종 키트" /></a>
						</li>
						<li>
							<a href="" onclick="TnGotoProduct('2074453');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_item_4.jpg" alt="하드케이스 노트" /></a>
						</li>
					</ul>
					<% else %>
					<ul>					
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2074432&pEtr=88637" ><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_item_1.jpg" alt="파우치" /></a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2074445&pEtr=88637" ><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_item_2.jpg" alt="티슈케이스" /></a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2074465&pEtr=88637" ><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_item_3.jpg" alt="노트3종 키트" /></a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2074453&pEtr=88637" ><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_item_4.jpg" alt="하드케이스 노트" /></a>
						</li>
					</ul>					
					<% end if %>
				</div>
				<div class="way">
					<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/tit_way.png" alt="프로모션 상품 1,000원에 구매하는 방법" /></p>
					<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/txt_way.jpg" alt="아리따움 스페셜 에디션 구매 / 구매 완료 후 쿠폰 발급 팝업 확인 / 쿠폰 적용 후 1,000원으로 구매!" />
				</div>
				<div class="noti">
					<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/tit_noti.png" alt="유의사항" /></h3>
					<ul>
						<li>· 본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
						<li>· 아리따움 10주년 스페셜 에디션을 구매하신 분에 한하여, 프로모션 상품 할인 쿠폰이 지급됩니다.</li>
						<li>· 프로모션 상품은 할인 쿠폰을 사용하여 1,000원에 구매할 수 있습니다.</li>
						<li>· 프로모션 상품은 할인 쿠폰 없이 5,000원에 구매 가능합니다.</li>
						<li><em>· 이벤트는 상품 품절 시 조기 마감될 수 있습니다.</em></li>
					</ul>
				</div>
			</div>					
<!-- #include virtual="/lib/db/dbclose.asp" -->