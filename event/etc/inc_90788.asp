<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 12월 1주차
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
	eCode = "90788"
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
		var viewval = 17
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4545);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90788/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90788/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>snowman</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>코끝이 시린 계절이 오면<br>생각나는 친구가 있어요.<br>동그랗게 웃는 모습이 따뜻한 눈사람.<br>핸드폰에도 책상 위에도 방 한쪽에도<br>귀여운 눈사람과 함께<br>외롭지 않은 겨울 되세요!</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2151692&pEtr=90788" onclick="TnGotoProduct('2151692');return false;"><img src="http://webimage.10x10.co.kr/image/basic/215/B002151692.jpg" alt="눈사람카드 (눈사람모빌카드)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1850610&pEtr=90788" onclick="TnGotoProduct('1850610');return false;"><img src="http://webimage.10x10.co.kr/image/basic/185/B001850610.jpg" alt="눈사람 오너먼트 니들펠트 DIY 패키지" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2004612&pEtr=90788" onclick="TnGotoProduct('2004612');return false;"><img src="http://webimage.10x10.co.kr/image/basic/200/B002004612.jpg" alt="눈사람 핀버튼 배지/마그넷" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1632869&pEtr=90788" onclick="TnGotoProduct('1632869');return false;"><img src="http://webimage.10x10.co.kr/image/basic/163/B001632869.jpg" alt="피규어 프레임 - 06 스노우맨" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->