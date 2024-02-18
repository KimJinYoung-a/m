<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 11월 2주차
' History : 2018-11-08 임보라
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
	eCode = "90391"
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
		var viewval = 14
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4511);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90391/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90391/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>별 헤는 밤</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>텐바이텐의 감성매거진 &lt;히치하이커&gt;의<br>월페이퍼를 만나보세요. 히치하이커는 우리 주변의 평범한 이야기와 일상의 풍경을 담아냅니다. 당신에게 소소한 즐거움, 작은 위로가 될 수 있길 바랍니다.</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2087691&pEtr=90391" onclick="TnGotoProduct('2087691');return false;"><img src="http://webimage.10x10.co.kr/image/basic/208/B002087691-2.jpg" alt="2019 별별일상 트윙클 에디션" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1243424&pEtr=90391" onclick="TnGotoProduct('1243424');return false;"><img src="http://webimage.10x10.co.kr/image/basic/124/B001243424.jpg" alt="하드케이스 찬H GP-15175 (알프스의 밤하늘을 너에게)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1998195&pEtr=90391" onclick="TnGotoProduct('1998195');return false;"><img src="http://webimage.10x10.co.kr/image/basic/199/B001998195.jpg" alt="별빛전구" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=985859&pEtr=90391" onclick="TnGotoProduct('985859');return false;"><img src="http://webimage.10x10.co.kr/image/basic/98/B000985859.jpg" alt="MASTE MULTI 우주-MST-MKT11" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->