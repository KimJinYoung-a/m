<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 핑크스타그램
' History : 2016-10-07 김진영 작성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim currentDate, eCode, currTabNum, i
currentDate = Date()
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66217
Else
	eCode   =  73370
End If

If currentDate <= "2016-10-10" Then
	currTabNum = 0
ElseIf currentDate = "2016-10-11" Then
	currTabNum = 1
ElseIf currentDate = "2016-10-12" Then
	currTabNum = 2
ElseIf currentDate = "2016-10-13" Then
	currTabNum = 3
ElseIf (currentDate = "2016-10-14") OR (currentDate = "2016-10-15") OR (currentDate = "2016-10-16") Then
	currTabNum = 4
ElseIf currentDate = "2016-10-17" Then
	currTabNum = 5
ElseIf currentDate = "2016-10-18" Then
	currTabNum = 6
ElseIf currentDate = "2016-10-19" Then
	currTabNum = 7
ElseIf currentDate = "2016-10-20" Then
	currTabNum = 8
ElseIf (currentDate = "2016-10-21") OR (currentDate = "2016-10-22") OR (currentDate = "2016-10-23") Then
	currTabNum = 9
ElseIf currentDate >= "2016-10-24" Then
	currTabNum = 10
End If
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt73370 {background-color:#feacc0;}
.mEvt73370 .slideTemplateV15 .swiper-container .swiper-slide {position:relative; float:left;}
.mEvt73370 .slideTemplateV15 .swiper-container .swiper-slide i {overflow:hidden; display:none; position:absolute; right:3.125%; top:0; width:14.53125%; height:15%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_today.png) no-repeat 50% 0; background-size: 100% auto; text-indent:-999em; z-index:10;}
.mEvt73370 .slideTemplateV15 .swiper-container .swiper-slide .itemLink1 {overflow:hidden; display:block; position:absolute; left:0px; top:0; width:50%; height:56%; background-color:rgba(255,255,255,0); text-indent:-999em; z-index:15;}
.mEvt73370 .slideTemplateV15 .swiper-container .swiper-slide .itemLink2 {overflow:hidden; display:block; position:absolute; right:0; top:0; width:50%; height:56%; background-color:rgba(255,255,255,0); text-indent:-999em; z-index:15;}
.mEvt73370 .slideTemplateV15 .swiper-container div.today i {display:block;}
.mEvt73370 .slideTemplateV15 .pagination {overflow:hidden; width:27rem; height:1.4rem; left:50%; top:60%; padding:0 0.585rem; margin-left:-13.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/73370/m/bg_slide_nav.png) no-repeat 50% 50%; background-size:27rem auto;}
.mEvt73370 .slideTemplateV15 .pagination span {display:block; float:left; width:1.7rem; height:1.4rem; margin:0 0.225rem; border-radius:0; box-shadow:none; border:0; background-color:transparent;}
.mEvt73370 .slideTemplateV15 .pagination span.swiper-active-switch {background:url(http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide_nav.png) no-repeat 50% 0; background-size:100% auto;}
.mEvt73370 .slideTemplateV15 .slideNav {display:block; top:0; height:56%;}
.mEvt73370 .slideTemplateV15 .btnPrev {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/73370/m/btn_slide_prev.png); background-size:0.9rem auto;}
.mEvt73370 .slideTemplateV15 .btnNext {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/73370/m/btn_slide_next.png); background-size:0.9rem auto;}
.mEvt73370 .slideTemplateV15 .pagination span {transition:none;}
.mEvt73370 .moviewrap {padding:0 3.125% 10% 3.125%;}
.mEvt73370 .movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:100%; background:#000;}
.mEvt73370 .movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
</style>
<script type="text/javascript">
$(function(){
	slideTemplate = new Swiper('.mEvt73370 .slideTemplateV15 .swiper-container',{
		initialSlide:<%= currTabNum %>,
		loop:true,
		autoplay:3000,
		speed:800,
		pagination:'.mEvt73370 .slideTemplateV15 .pagination',
		paginationClickable:true,
		nextButton:'.mEvt73370 .slideTemplateV15 .btnNext',
		prevButton:'.mEvt73370 .slideTemplateV15 .btnPrev',
		effect:'fade'
	});
});
</script>
<div class="mEvt73370">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/tit_pinkstargram.png" alt="Pinkstagram X Ten by Ten" /></h2>
	<p class="mWeb"><a href="https://www.instagram.com/pink.stargram/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_pinkstargram.png" alt="PINK.STARGRAM" /></a></p>
	<p class="mApp"><a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/pink.stargram/');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_pinkstargram.png" alt="PINK.STARGRAM" /></a></p>

	<div class="slideTemplateV15">
		<div class="swiper-container mApp">
			<div class="swiper-wrapper">
			<% If currentDate >= "2016-10-07" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="0", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1568983&amp;pEtr=73370" onclick="fnAPPpopupProduct('1568983&amp;pEtr=73370');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide01.jpg" alt="샌드위치 시계 230N pinklemonade edition" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-11" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="1", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1574245&amp;pEtr=73370" onclick="fnAPPpopupProduct('1574245&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide02.jpg" alt="Valentine pink_5cm" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-12" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="2", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1575176&amp;pEtr=73370" onclick="fnAPPpopupProduct('1575176&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide03.jpg" alt="Special limited-e" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-13" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="3", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1571817&amp;pEtr=73370" onclick="fnAPPpopupProduct('1571817&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide04.jpg" alt="과자전 Love&Thanks 순이 인형" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-14" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="4", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1575177&amp;pEtr=73370" onclick="fnAPPpopupProduct('1575177&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide05.jpg" alt="Kafka called crow boy for Phonecase" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-17" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="5", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1548822&amp;pEtr=73370" onclick="fnAPPpopupProduct('1548822&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide06_v1.jpg" alt="groovy 80's pink" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-18" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="6", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1575179&amp;pEtr=73370" onclick="fnAPPpopupProduct('1575179&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide07_v1.jpg" alt="DAY MAKE-UP POUCH 핑크 에디션" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-19" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="7", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1575178&amp;pEtr=73370" onclick="fnAPPpopupProduct('1575178&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide08.jpg" alt="헤이로즈 -리얼 코튼 백" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-20" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="8", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1573879&amp;pEtr=73370" onclick="fnAPPpopupProduct('1573879&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide09.jpg" alt="3560 클로젯 메탈행거 4단 핑크" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-21" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="9", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1574052&amp;pEtr=73370" onclick="fnAPPpopupProduct('1574052&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide10.jpg" alt="미래식사 밀스 핑크에디션 1.0 보틀형" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-24" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="10", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1568068&amp;pEtr=73370" onclick="fnAPPpopupProduct('1568068&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide11.jpg" alt="slow and steady - 6달 스터디 플래너" /></a></div>
				<div class="swiper-slide<%= Chkiif(currTabNum="10", " today", "") %>"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1577612&amp;pEtr=73370" onclick="fnAPPpopupProduct('1577612&amp;pEtr=73370');return false;"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide12.jpg" alt="[Disney]Alice_Pink memo pad" /></a></div>
			<% End If %>
			</div>
		</div>
		<div class="swiper-container mWeb">
			<div class="swiper-wrapper">
			<% If currentDate >= "2016-10-07" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="0", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1568983&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide01.jpg" alt="샌드위치 시계 230N pinklemonade edition" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-11" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="1", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1574245&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide02.jpg" alt="Valentine pink_5cm" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-12" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="2", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1575176&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide03.jpg" alt="Special limited-e" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-13" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="3", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1571817&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide04.jpg" alt="과자전 Love&Thanks 순이 인형" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-14" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="4", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1575177&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide05.jpg" alt="Kafka called crow boy for Phonecase" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-17" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="5", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1548822&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide06.jpg" alt="groovy 80's pink" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-18" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="6", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1575179&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide07_v1.jpg" alt="DAY MAKE-UP POUCH 핑크 에디션" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-19" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="7", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1575178&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide08.jpg" alt="헤이로즈 -리얼 코튼 백" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-20" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="8", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1573879&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide09.jpg" alt="3560 클로젯 메탈행거 4단 핑크" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-21" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="9", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1574052&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide10.jpg" alt="미래식사 밀스 핑크에디션 1.0 보틀형" /></a></div>
			<% End If %>
			<% If currentDate >= "2016-10-24" Then %>
				<div class="swiper-slide<%= Chkiif(currTabNum="10", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1568068&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide11.jpg" alt="slow and steady - 6달 스터디 플래너" /></a></div>
				<div class="swiper-slide<%= Chkiif(currTabNum="10", " today", "") %>"><a href="/category/category_itemPrd.asp?itemid=1577612&amp;pEtr=73370"><i>Today pink</i><img src="http://webimage.10x10.co.kr/eventIMG/2016/73370/m/img_slide12.jpg" alt="[Disney]Alice_Pink memo pad" /></a></div>
			<% End If %>
			</div>
		</div>
		<div class="pagination"></div>
		<button type="button" class="slideNav btnPrev">이전</button>
		<button type="button" class="slideNav btnNext">다음</button>
	</div>
	<div class="moviewrap">
		<div class="movie">
			<div class="youtube">
				<iframe src="https://player.vimeo.com/video/185909275" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
			</div>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->