<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 4주차
' History : 2018-08-28 최종원
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
	eCode = "88370"
End If

vUserID = getEncLoginUserID
%>
<script type="text/javascript">
$(function(){
	//@media (min-width:480px) .cmtDesc .txt {padding:23px 27px;}
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
		var viewval = 5
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4469);
			}			
		}).responseText;					
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88370/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88370/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>다람쥐의 간식</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>금방 밥을 먹었는데도 입이 심심한가요?<br>도토리 점심만으로는 부족한<br>가을이 오고 있어요.<br>먹고 또 먹어도 부담스럽지 않은<br>다이어트 간식을 준비해 봤습니다.</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1921110&pEtr=88370" onclick="TnGotoProduct('1921110');return false;"><img src="http://webimage.10x10.co.kr/image/basic/192/B001921110.jpg" alt="" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2009003&pEtr=88370" onclick="TnGotoProduct('2009003');return false;"><img src="http://webimage.10x10.co.kr/image/basic/200/B002009003.jpg" alt="" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1948944&pEtr=88370" onclick="TnGotoProduct('1948944');return false;"><img src="http://webimage.10x10.co.kr/image/basic/194/B001948944-1.jpg" alt="" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1608388&pEtr=88370" onclick="TnGotoProduct('1608388');return false;"><img src="http://webimage.10x10.co.kr/image/basic/160/B001608388.jpg" alt="" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->