<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 11월 1주차
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
	eCode = "90254"
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
		var viewval = 13
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4510);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90254/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90254/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>PLAN</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>올해, 계획했던 일을 아직 못하셨나요?<br>그렇다면 내년의 나에게 맡겨보면 어떨까요?<br>계획이 반이라는 말도 있잖아요.<br>오늘 일은 내일로 미루고<br>신나게 계획을 세워보아요 : )</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2110862&pEtr=90254" onclick="TnGotoProduct('2110862');return false;"><img src="http://webimage.10x10.co.kr/image/basic/211/B002110862.jpg" alt="Planner 2019 L" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2085679&pEtr=90254" onclick="TnGotoProduct('2085679');return false;"><img src="http://webimage.10x10.co.kr/image/basic/208/B002085679.jpg" alt="2019 Wish diary ver.4" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1860178&pEtr=90254" onclick="TnGotoProduct('1860178');return false;"><img src="http://webimage.10x10.co.kr/image/basic/186/B001860178-1.jpg" alt="TOMORROW LARGE V.12" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2103425&pEtr=90254" onclick="TnGotoProduct('2103425');return false;"><img src="http://webimage.10x10.co.kr/image/basic/210/B002103425.jpg" alt="[A5] 6공 TWINKLE MOONLIGHT DIARY" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->