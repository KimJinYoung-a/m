<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 2주차
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
	eCode = "88367"
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
		var viewval = 2
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(4464);
			}			
		}).responseText;					
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88367/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88367/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong>오늘의 날씨</strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		<p>여름아...분위기 좀 읽자^^<br />텐바이텐과 산돌커뮤니케이션이 함께 만드는<br />유쾌한 모바일 배경화면을 만나보세요.<br />이 달의 폰트 : 산돌격동굴림체</p>
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1971903&pEtr=88367" onclick="TnGotoProduct('1971903');return false;"><img src="http://webimage.10x10.co.kr/image/basic/197/B001971903.jpg" alt="오난코리아 루메나 N9-FAN PRO 휴대용 서큘레이터" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1743824&pEtr=88367" onclick="TnGotoProduct('1743824');return false;"><img src="http://webimage.10x10.co.kr/image/basic/174/B001743824.jpg" alt="아이스러버 쿨팩 100개 (붙이는 쿨패치, 터트리는 쿨팩)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1937256&pEtr=88367" onclick="TnGotoProduct('1937256');return false;"><img src="http://webimage.10x10.co.kr/image/basic/193/B001937256.jpg" alt="파스텔 실리콘 아이스몰드 다이아 24구 (4color)_(1159735)" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=2030735&pEtr=88367" onclick="TnGotoProduct('2030735');return false;"><img src="http://webimage.10x10.co.kr/image/basic/203/B002030735.jpg" alt="가이타이너(GEITAHINER) 미니 냉풍기 GT-ZAC99-TA" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->