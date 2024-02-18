<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 10월 3주차
' History : 2018-10-18 임보라
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
	eCode = "89996"
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
		var viewval = 11
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4506);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89996/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89996/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>대충사자</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>대충사자...어차피 또 살거...<br>텐바이텐과 산돌커뮤니케이션이 함께 만드는<br>유쾌한 모바일 배경화면을 만나보세요.<br>이 달의 폰트 : 산돌박효진</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1812571&pEtr=89996" onclick="TnGotoProduct('1812571');return false;"><img src="http://webimage.10x10.co.kr/image/basic/181/B001812571-5.jpg" alt="모나미 플러스펜-36색 세트" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1786291&pEtr=89996" onclick="TnGotoProduct('1786291');return false;"><img src="http://webimage.10x10.co.kr/image/basic/178/B001786291-3.jpg" alt="매일리 오리우산 (2단 우산)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2096460&pEtr=89996" onclick="TnGotoProduct('2096460');return false;"><img src="http://webimage.10x10.co.kr/image/basic/209/B002096460.jpg" alt="Formal 4SET" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1839982&pEtr=89996" onclick="TnGotoProduct('1839982');return false;"><img src="http://webimage.10x10.co.kr/image/basic/183/B001839982.jpg" alt="(신규옵션 추가) 데일리 뱃지 [1~30번]" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->