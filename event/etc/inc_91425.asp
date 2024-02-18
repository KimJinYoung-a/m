<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 12월 4주차
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
	eCode = "91425"
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
		var viewval = 20
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4550);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91425/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91425/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>야옹이의 선물</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>사랑스러운 야옹이 친구들!<br>말은 못 하지만 자기 줄 건 귀신같이<br>알아본다죠? 집에서 당신만을<br>기다릴 귀여운 털 뭉치들에게도<br>올 한 해 수고했다고 따뜻한<br>선물 하나 둘러줍시다!</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
            <li>
                <a href="/category/category_itemPrd.asp?itemid=2174631&pEtr=91425" onclick="TnGotoProduct('2174631');return false;"><img src="http://webimage.10x10.co.kr/image/basic/217/B002174631.jpg" alt="크리스마스카드 냥트리오의 합창" /></a>
            </li>
            <li>
                <a href="/category/category_itemPrd.asp?itemid=1841467&pEtr=91425" onclick="TnGotoProduct('1841467');return false;"><img src="http://webimage.10x10.co.kr/image/basic/184/B001841467.jpg" alt="방울목도리" /></a>
            </li>
            <li>
                <a href="/category/category_itemPrd.asp?itemid=1621862&pEtr=91425" onclick="TnGotoProduct('1621862');return false;"><img src="http://webimage.10x10.co.kr/image/basic/162/B001621862.jpg" alt="요정모자-강아지고양이겸용" /></a>
            </li>
            <li>
                <a href="/category/category_itemPrd.asp?itemid=2174904&pEtr=91425" onclick="TnGotoProduct('2174904');return false;"><img src="http://webimage.10x10.co.kr/image/basic/217/B002174904.jpg" alt="크리스마스의 기쁨 슬라이드카드" /></a>
            </li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->