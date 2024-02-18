<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 9월 4주차
' History : 2018-09-21 최종원
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
	eCode = "88373"
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
		var viewval = 8
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4503);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88373/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88373/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>놀고 싶은 가을</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>선선해진 가을 하늘의 <br />몽글몽글 구름을 올려다보니 <br />바쁘다는 핑계로 한동안 보지 못했던 <br />친구의 얼굴이 떠오르는 것 같아요.<br />전화기를 꾹 노르고 불러볼까요?<br />친구야 나와! 놀자!</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1366158&pEtr=88373" onclick="TnGotoProduct('1366158');return false;"><img src="http://webimage.10x10.co.kr/image/basic/136/B001366158.jpg" alt="굴리굴리폰케이스 / No.28" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1384012&pEtr=88373" onclick="TnGotoProduct('1384012');return false;"><img src="http://webimage.10x10.co.kr/image/basic/138/B001384012-1.jpg" alt="[굴리굴리 X 텐바이텐] STICKERS 2SET" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1365793&pEtr=88373" onclick="TnGotoProduct('1365793');return false;"><img src="http://webimage.10x10.co.kr/image/basic/136/B001365793.jpg" alt="굴리굴리폰케이스 / No.27" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1475408&pEtr=88373" onclick="TnGotoProduct('1475408');return false;"><img src="http://webimage.10x10.co.kr/image/basic/147/B001475408.jpg" alt="Mini Sticker Pack-08 Village (굴리굴리)" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->