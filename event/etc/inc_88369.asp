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
	eCode = "88369"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">.finish-event {display:none;}</style>
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
		var viewval = 4
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4468);
			}			
		}).responseText;					
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88369/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88369/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>무뚝뚝한 내 친구</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>힘내라는 한마디의 말 보다 <br />때로는 묵묵히 나의 말을 들어주는 친구 하나 <br />옆에 있다면 그 어느 때 보다 든든할 거에요. <br />보고만 있어도 기분이 좋아지는 <br />스티키 몬스터랩 친구들!</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1576373&pEtr=88369" onclick="TnGotoProduct('1576373');return false;"><img src="http://webimage.10x10.co.kr/image/basic/157/B001576373-1.jpg" alt="스티키 몬스터랩 옐로우몬 인형(S)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1576368&pEtr=88369" onclick="TnGotoProduct('1576368');return false;"><img src="http://webimage.10x10.co.kr/image/basic/157/B001576368-1.jpg" alt="스티키 몬스터랩 빅몬 인형(S)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1576365&pEtr=88369" onclick="TnGotoProduct('1576365');return false;"><img src="http://webimage.10x10.co.kr/image/basic/157/B001576365-1.jpg" alt="스티키 몬스터랩 버드몬 인형(S)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1506304&pEtr=88369" onclick="TnGotoProduct('1506304');return false;"><img src="http://webimage.10x10.co.kr/image/basic/150/B001506304-1.jpg" alt="STICKY MONSTER LAB REDMON 인형(S)" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->