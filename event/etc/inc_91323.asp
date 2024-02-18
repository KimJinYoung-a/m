<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 12월 3주차
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
	eCode = "91323"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">.finish-event {display:none;}</style>
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
		var viewval = 19
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4547);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91323/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91323/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>홈얼론</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>크리스마스는 역시 케빈과 함께!<br>텐바이텐과 산돌커뮤니케이션이 함께 만드는<br>유쾌한 모바일 배경화면을 만나보세요.<br>이 달의 폰트 : 산돌단팥빵</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2179797&pEtr=91323" onclick="TnGotoProduct('2179797');return false;"><img src="http://webimage.10x10.co.kr/image/basic/217/B002179797-3.jpg" alt="꽃을 든 눈사람무드등 -7종 모음" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1862422&pEtr=91323" onclick="TnGotoProduct('1862422');return false;"><img src="http://webimage.10x10.co.kr/image/basic/186/B001862422-2.jpg" alt="[겨울한정] 살룻 뱅쇼키트(850ml)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1850030&pEtr=91323" onclick="TnGotoProduct('1850030');return false;"><img src="http://webimage.10x10.co.kr/image/basic/185/B001850030.jpg" alt="[12/19 출고 예정] [한정수량 선착순 판매] 홀리케익 케익볼" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2128998&pEtr=91323" onclick="TnGotoProduct('2128998');return false;"><img src="http://webimage.10x10.co.kr/image/basic/212/B002128998.jpg" alt="데꼴 2018 크리스마스 피규어 한정판" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->