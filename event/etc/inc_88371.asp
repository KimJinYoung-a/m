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
	eCode = "88371"
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
		var viewval = 6
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4470);
			}			
		}).responseText;							
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88371/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88371/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>DON&apos;T TOUCH!</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>나는 아직 배고프다...<br>텐바이텐과 산돌커뮤니케이션이 함께 만드는<br>유쾌한 모바일 배경화면을 만나보세요.<br>이 달의 폰트 : 산돌마들렌</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1913547&pEtr=88371" onclick="TnGotoProduct('1913547');return false;"><img src="http://webimage.10x10.co.kr/image/basic/191/B001913547-1.jpg" alt="라비퀸 떡볶이 오리지널맛 세트" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1214155&pEtr=88371" onclick="TnGotoProduct('1214155');return false;"><img src="http://webimage.10x10.co.kr/image/basic/121/B001214155-1.jpg" alt="쟌슨빌 빅 핫도그" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2074959&pEtr=88371" onclick="TnGotoProduct('2074959');return false;"><img src="http://webimage.10x10.co.kr/image/basic/207/B002074959.jpg" alt="팔킨 프리미엄 라면 6종 묶음(라면티백 제외)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2008981&pEtr=88371" onclick="TnGotoProduct('2008981');return false;"><img src="http://webimage.10x10.co.kr/image/basic/200/B002008981.jpg" alt="소떡소떡750g x 2봉+1봉 총3봉 떡볶이소스 1개증정" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->