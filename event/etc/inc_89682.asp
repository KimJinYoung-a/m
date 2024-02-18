<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 10월 1주차
' History : 2018-10-04 임보라
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
	eCode = "89682"
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
		var viewval = 9
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4504);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89682/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89682/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>가을준비</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>아침저녁으로 코끝이 추워지는<br>날씨가 되었어요.<br>포근한 계절을 보내기 위한 준비를<br>차근차근해 보아요.</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2102045&pEtr=89682" onclick="TnGotoProduct('2102045');return false;"><img src="http://webimage.10x10.co.kr/image/basic/210/B002102045.jpg" alt="long band 3pack set" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2076270&pEtr=89682" onclick="TnGotoProduct('2076270');return false;"><img src="http://webimage.10x10.co.kr/image/basic/207/B002076270.jpg" alt="인리나스 플로렌스 블랭킷/담요" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2024031&pEtr=89682" onclick="TnGotoProduct('2024031');return false;"><img src="http://webimage.10x10.co.kr/image/basic/202/B002024031.jpg" alt="[보울보울] 레트로라인 머그(5color)_(1257677)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2063206&pEtr=89682" onclick="TnGotoProduct('2063206');return false;"><img src="http://webimage.10x10.co.kr/image/basic/206/B002063206.jpg" alt="스위스미스 핫초코 마시멜로우 코코아 x 60개 (한박스)_(1193294)" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->