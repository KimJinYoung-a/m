<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/instagrameventCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : [SNS] #파티에서 가장 반짝이는 당신!
' History : 2017-12-08 정태훈
'####################################################
Dim eCode, userid, pagereload, i
dim iCCurrpage, iCTotCnt, eCC, iCPageSize, iCTotalPage
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67488
Else
	eCode   =  82873
End If

iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	
IF iCCurrpage = "" THEN iCCurrpage = 1
IF iCTotCnt = "" THEN iCTotCnt = -1

eCC = requestCheckVar(Request("eCC"), 1)
pagereload	= requestCheckVar(request("pagereload"),2)
userid		= GetEncLoginUserID()

iCPageSize = 4		'한 페이지의 보여지는 열의 수

dim oinstagramevent
set oinstagramevent = new Cinstagrameventlist
	oinstagramevent.FPageSize	= iCPageSize
	oinstagramevent.FCurrPage	= iCCurrpage
	oinstagramevent.FTotalCount		= iCTotCnt  '전체 레코드 수
	oinstagramevent.FrectIsusing = "Y"
	oinstagramevent.FrectEcode = eCode
	oinstagramevent.fnGetinstagrameventList

	iCTotCnt = oinstagramevent.FTotalCount '리스트 총 갯수
	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>
<style type="text/css">
.mWeb {display:none;}
.bon-appetit {background-color:#fff;}
.item-rolling .btn-nav {position:absolute; top:22.5%; z-index:10; width:9.4%; height:17%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:66% auto; text-indent:-999em;}
.item-rolling .btn-prev {left:0; background-image:url(http://fiximage.10x10.co.kr/m/2015/event/btn_slide_prev.png);}
.item-rolling .btn-next {right:0; background-image:url(http://fiximage.10x10.co.kr/m/2015/event/btn_slide_next.png);}
.item-rolling .pagination {position:absolute; bottom:3%; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.item-rolling .pagination .swiper-pagination-switch {display:inline-block; width:8px; height:8px; margin:0 8px; border:2px solid #fff; border-radius:8px; background-color:rgba(0, 0 ,0, 0.1); box-shadow:0 0 0.43rem 0 rgba(0 ,0, 0, 0.25); cursor:pointer; transition:width 0.3s;}
.item-rolling .pagination .swiper-active-switch {width:20px; border:0; background-color:#fff;}

.instagram {padding-bottom:2.65rem; background-color:#fff;}
.instagram ul {overflow:hidden; width:29.86rem; margin:0 auto;}
.instagram li {float:left; width:13.65rem; margin:2.39rem 0.64rem 0;}
.instagram .thumbnail {width:13.65rem; height:13.65rem;}
.instagram .id {display:block; margin-top:1.02rem; padding:0 0.5rem; color:#767676; font-size:1.28rem; line-height:1.54em; text-align:center;}
.instagram  .id span {overflow:hidden; display:inline-block; max-width:40%; text-overflow:ellipsis; white-space:nowrap; color:#ffa200; vertical-align:top;}
.pagingV15a .current {color:#f49500;}

.noti {padding:2.5rem 2.43rem 2.4rem; background-color:#eee; text-align:center;}
.noti h3 {display:inline-block; position:relative; padding-bottom:0.5rem; color:#ba7600; font-size:1.54rem; font-weight:bold; line-height:1em;}
.noti h3:after {content:' '; display:block; position:absolute; top:100%; left:0; width:100%; height:0.13rem; background-color:currentColor;}
.noti ul {margin-top:2.13rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#333; font-size:1.19rem; line-height:1.5em; text-align:left;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:currentColor;}
</style>
<script type="text/javascript">
$(function(){
	rolling1 = new Swiper("#rolling .swiper-container",{
		loop:true,
		autoplay:2000,
		speed:800,
		nextButton:"#rolling .btn-next",
		prevButton:"#rolling .btn-prev",
		pagination:"#rolling .pagination",
		paginationClickable:true,
	});
});

$(function(){
	<% if Request("eCC")<>"" then %>
		setTimeout("pagedown()",300);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#instagramlist").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
</script>
			<div class="mEvt82873 bon-appetit">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/tit_you.jpg" alt="파티에서 가장 반짝이는 당신! 당신의 파티룩 완성을 위한 선물을 드립니다." /></h2>
				<div id="rolling" class="item-rolling">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1851141&pEtr=82873" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_01.jpg" alt="gold pearl drop 반짝이는 나를 위한" /></a>
								<a href="" onclick="fnAPPpopupProduct('1851141&amp;pEtr=82873');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_01.jpg" alt="gold pearl drop 반짝이는 나를 위한" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1851140&pEtr=82873" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_02.jpg" alt="shell flower 자개와 진주의 아름다운 조화" /></a>
								<a href="" onclick="fnAPPpopupProduct('1851140&amp;pEtr=82873');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_02.jpg" alt="shell flower 자개와 진주의 아름다운 조화" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1851131&pEtr=82873" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_03.jpg" alt="green stone drop 독특한 원석으로 더욱 빛나게" /></a>
								<a href="" onclick="fnAPPpopupProduct('1851131&amp;pEtr=82873');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_03.jpg" alt="green stone drop 독특한 원석으로 더욱 빛나게" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1851124&pEtr=82873" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_04.jpg" alt="blue pearl 모두를 주목시키는" /></a>
								<a href="" onclick="fnAPPpopupProduct('1851124&amp;pEtr=82873');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_04.jpg" alt="blue pearl 모두를 주목시키는" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1851110&pEtr=82873" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_05.jpg" alt="twinkle onyx 연말엔 더욱 과감하게" /></a>
								<a href="" onclick="fnAPPpopupProduct('1851110&amp;pEtr=82873');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/img_item_05.jpg" alt="twinkle onyx 연말엔 더욱 과감하게" /></a>
							</div>
						</div>
						<div class="pagination"></div>
						<button type="button" class="btn-nav btn-prev">이전</button>
						<button type="button" class="btn-nav btn-next">다음</button>
					</div>
				</div>

				<div class="gift">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/txt_gift.jpg" alt="당신을 위한 GIFT 본아베띠 주얼리를 인스타그램에 자랑해주세요! 추첨을 통해 당신의 패션을 완성해줄 패션 아이템을 드립니다. LEATHER SATCHEL Small Pixie 5명, BREDA 브레다 정품시계 5명" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/txt_event.gif" alt="이벤트 참여 방법 본아베띠 쥬얼리 구매하기, 본아베띠 쥬얼리 사진찍기, 필수 해시태그 포함하여 인스타그램에 업로드하기 필수 해시태그 #본아베띠 #쥬얼리 #귀걸이 #파티룩 #선물" /></p>
				</div>

				<!-- instagram -->
				<% if oinstagramevent.fresultcount > 0 then %>
				<div class="instagram" id="instagramlist">
					<h3>
						<a href="https://www.instagram.com/your10x10/" target="_blank"  title="텐바이텐 공식 인스타그램계정으로 이동" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/tit_bon_appetit.gif" alt="텐바이텐에 도착한 #본아베띠" /></a>
						<a href="https://www.instagram.com/your10x10/" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10/'); return false;" title="텐바이텐 공식 인스타그램계정으로 이동" target="_blank" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82873/m/tit_bon_appetit.gif" alt="텐바이텐에 도착한 #본아베띠" /></a>
					</h3>
					<ul>
						<% for i = 0 to oinstagramevent.fresultcount-1 %>
						<li>
							<div class="thumbnail"><img src="<%= oinstagramevent.FItemList(i).Fimgurl %>" alt="" /></div>
							<span class="id"><span><%=printUserId(left(oinstagramevent.FItemList(i).Fuserid,10),2,"*")%></span>님의<br /> 본아베띠</span>
						</li>
						<% next %>
					</ul>
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,5,"jsGoComPage")%>
				</div>
				<% end if %>
				<div class="noti">
					<h3>이벤트 유의사항</h3>
					<ul>
						<li>인스타그램 계정이 비공개 일 경우 이벤트 참여에 제외됩니다.</li>
						<li>이벤트에 참여한 인증샷은 고객 동의 없이 이벤트 페이지 내에 노출될 수 있습니다.</li>
						<li>이벤트 페이지 내에 노출되는 SNS인증샷은 실시간 적용되지 않습니다.</li>
						<li>SNS 이벤트에 참여하였더라도 이벤트 페이지 내에 노출되지 않을 수 있습니다.</li>
						<li>이벤트 페이지 내에 SNS인증샷 노출여부는 이벤트 당첨 여부와 무관합니다.</li>
						<li>이벤트 일정 및 당첨 상품 등은 당사 사정에 따라 부득이하게 변경 될 수 있습니다.</li>
						<li>제세공과금은 텐바이텐 부담이며, 세무신고를 위해 개인정보를 취합한 뒤에 경품이 증정됩니다.</li>
					</ul>
				</div>
			</div>
<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
<input type="hidden" name="iCTot" value=""/>
<input type="hidden" name="eCC" value="1">
</form>
<% set oinstagramevent = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->