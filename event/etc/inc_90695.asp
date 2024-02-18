<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 11월 4주차
' History : 2018-11-16 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID

IF application("Svr_Info") = "Dev" THEN
	eCode = "68520"
Else
	eCode = "90695"
End If

vUserID = getEncLoginUserID
%>
<script type="text/javascript">
$(function(){
	var itemSwiper = new Swiper(".wallpaper-swiper .swiper-container", {
			loop:true,
			speed:1000,
			autoplay:2000,
			pagination:".wallpaper-swiper .pagination-dot",
			paginationClickable:true
	});	
});
function loginCheckDownLoad() {	
	if ("<%=IsUserLoginOK%>"=="False") {		
		<% If isApp="1" or isApp="2" Then %>
			alert('로그인을 하셔야 다운받으실 수 있습니다.');
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>	
	}else{
		var viewval = 16
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4544);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90695/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90695/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>미리크리스마스</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>킁킁... 어디서 <br>크리스마스 냄새 안 나요?<br>한 달 남은 크리스마스를<br>준비하며 이번엔 스스로에게<br>산타가 되어보아요!<br>마음속에 품고 있는 위시리스트를<br>살며시 꺼내 고생한 나 자신에게<br>선물을 안겨주는 건 어떨까요?</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1472304&pEtr=90695" onclick="TnGotoProduct('1472304');return false;"><img src="http://webimage.10x10.co.kr/image/basic/147/B001472304.jpg" alt="조개캔들 x 투명성냥 SET - cream grey" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2106485&pEtr=90695" onclick="TnGotoProduct('2106485');return false;"><img src="http://webimage.10x10.co.kr/image/basic/210/B002106485.jpg" alt="Sticky Monster Lab - BABY LAMP 01" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1898768&pEtr=90695" onclick="TnGotoProduct('1898768');return false;"><img src="http://webimage.10x10.co.kr/image/basic/189/B001898768-1.jpg" alt="Lyon scented candle (5colors)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2144429&pEtr=90695" onclick="TnGotoProduct('2144429');return false;"><img src="http://webimage.10x10.co.kr/image/basic/214/B002144429.jpg" alt="Pucky Christmas 2018 (푸키-크리스마스시리즈 2018)_랜덤" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->