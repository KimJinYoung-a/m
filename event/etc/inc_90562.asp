<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 11월 3주차
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
	eCode = "90562"
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
		var viewval = 15
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4512);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90562/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90562/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>아무것도 안했는데</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>아무것도 안했는데 벌써;;<br>텐바이텐과 산돌커뮤니케이션이 함께 만드는<br>유쾌한 모바일 배경화면을 만나보세요.<br>이 달의 폰트 : 산돌청류</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1626746&pEtr=90562" onclick="TnGotoProduct('1626746');return false;"><img src="http://webimage.10x10.co.kr/image/basic/162/B001626746.jpg" alt="Thinker study project planner 띵커 스터디플래너" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1916895&pEtr=90562" onclick="TnGotoProduct('1916895');return false;"><img src="http://webimage.10x10.co.kr/image/basic/191/B001916895-2.jpg" alt="네모생활 오늘뭐하지" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2061686&pEtr=90562" onclick="TnGotoProduct('2061686');return false;"><img src="http://webimage.10x10.co.kr/image/basic/206/B002061686-2.jpg" alt="Iciel The weekly life (L) 스터디 플래너(30분공부)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1470564&pEtr=90562" onclick="TnGotoProduct('1470564');return false;"><img src="http://webimage.10x10.co.kr/image/basic/147/B001470564.jpg" alt="양면 체크리스트 데일리 스케줄러 패드" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->