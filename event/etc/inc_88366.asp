<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  월페이퍼 1주차
' History : 2018-08-08 최종원
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
	eCode = "88366"
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
		var viewval = 1
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4463);
			}			
		}).responseText;			
		
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88366/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88366/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>SURFING DOG</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
			<p>찌는 듯한 더위.<br />시원한 파도에 몸을 맡기는 상상을 해 보아요.<br />상쾌한 바닷바람과 새하얀 물보라가<br />마음의 온도를 낮춰줄 거예요.</p>
	</div>
	<div class="wallpaper-related">
			<h2><span>바탕화면과</span> 관련된 상품</h2>
			<ul>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1699932&pEtr=88366" onclick="TnGotoProduct('1699932');return false;"><img src="http://webimage.10x10.co.kr/image/basic/169/B001699932.jpg" alt="SURF BOARD table&stool_red" /></a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1523832&pEtr=88366" onclick="TnGotoProduct('1523832');return false;"><img src="http://webimage.10x10.co.kr/image/basic/152/B001523832-1.jpg" alt="[Disney]Dory_Beach Towel" /></a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1691747&pEtr=88366" onclick="TnGotoProduct('1691747');return false;"><img src="http://webimage.10x10.co.kr/image/basic/169/B001691747.jpg" alt="스네프 스마트 스노클링마스크 SMC-3001 블루_(701246641)" /></a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1742889&pEtr=88366" onclick="TnGotoProduct('1742889');return false;"><img src="http://webimage.10x10.co.kr/image/basic/174/B001742889.jpg" alt="수박 튜브 (BMPF-WA)" /></a>
				</li>
			</ul>
			<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
			<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->