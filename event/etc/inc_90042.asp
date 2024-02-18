<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 10월 4주차
' History : 2018-10-24 임보라
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
	eCode = "90042"
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
		var viewval = 12
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4509);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90042/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90042/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>따끈해서 좋아</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>추워진 날씨에 따끈따끈한 간식<br>생각나지 않으세요? 출출한 배를<br>채워주는 먹을 수 있는 손난로, 붕어빵!<br>오늘도 길거리를 걷다<br>마주치길 기대해봅니다.</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=432835&pEtr=90042" onclick="TnGotoProduct('432835');return false;"><img src="http://webimage.10x10.co.kr/image/basic/43/B000432835.jpg" alt="메모지-붕어빵좋아" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2109771&pEtr=90042" onclick="TnGotoProduct('2109771');return false;"><img src="http://webimage.10x10.co.kr/image/basic/210/B002109771-2.jpg" alt="붕어빵 만들기 팬" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=968472&pEtr=90042" onclick="TnGotoProduct('968472');return false;"><img src="http://webimage.10x10.co.kr/image/basic/96/B000968472.jpg" alt="붕어빵과 국화빵" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1472223&pEtr=90042" onclick="TnGotoProduct('1472223');return false;"><img src="http://webimage.10x10.co.kr/image/basic/147/B001472223.jpg" alt="MASTE Masking tape Multi 붕어빵-MST-MKT155-F" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->