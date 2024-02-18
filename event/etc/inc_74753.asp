<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 월드비전 sns MA
' History : 2016.12.02 유태욱
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode

IF application("Svr_Info") = "Dev" THEN
	eCode = "66249"
Else
	eCode = "74753"
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 월드비전과 함께하는 2017 캘린더!")
snpLink		= Server.URLEncode("http://10x10.co.kr/event/" & ecode)
snpPre		= Server.URLEncode("10x10")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 월드비전과 함께하는 2017 캘린더 오픈\n\n월드비전 캘린더와 함께\n작은 기적을 함께 해주세요!\n\n모든 판매 수익금은\n캄보디아 지역 주민들의\n식수사업을 위해 쓰입니다!\n\n지금 바로 텐바이텐에서\n확인하세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/74753/m/kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
End If
%>
<style type="text/css">
img {vertical-align:top;}
.swiper-container {position:relative;}
.slideTemplateV15 .pagination{position:absolute; bottom:4.6%; z-index:10; left:0;}
.slideTemplateV15 .slideNav {position:absolute; top:46.85%; z-index:10; width:5.46%; height:9.12%;background-color:transparent; text-indent:-999em; background-size:100%;}
.slideTemplateV15 .btnPrev {left:2.34%;}
.slideTemplateV15 .btnNext {right:2.34%;}

.snsShare {position:relative;}
.snsShare ul {position:absolute; top:0; right:0; width:50%; height:8.4rem;}
.snsShare ul li a {position:absolute; top:0; display:block; width:50%; height:100%; text-indent:-999em;}
.snsShare ul li a.fb {right:50%;}
.snsShare ul li a.kakao {right:0;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt74753").offset().top}, 0);
});

$(function(){
    slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
        loop:true,
        autoplay:3000,
        autoplayDisableOnInteraction:false,
        speed:800,
        pagination:".slideTemplateV15 .pagination",
        paginationClickable:true,
        nextButton:'.slideTemplateV15 .btnNext',
        prevButton:'.slideTemplateV15 .btnPrev',
        effect:'fade'
    });
});

function snschk(snsnum) {
	if(snsnum == "tw") {
		popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
	}else if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
	<div class="mEvt74753">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/tit_happy.jpg" alt="HAPPY ANDING 월드비전과 함께하는 2017 캘린더 작은 기적을 함께 해주세요!" /></h3>
		<div class="slideTemplateV15">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/img_slide_01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/img_slide_03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/img_slide_04.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="slideNav btnPrev">이전</button>
			<button type="button" class="slideNav btnNext">다음</button>
		</div>
		<div class="item">
			<a href="/category/category_itemPrd.asp?itemid=1612172&pEtr=74753"class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/img_item.jpg" alt="텐바이텐 X 월드비전 HAPPY ANDing 2017 달력 우리의 작은 나눔으로 이 세상 모든 어린이가 행복한 삶을 누릴 수 있어요 지구촌 모든 어린이가 불행한 끝을 맺지 않기를 바랍니다" /></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1612172&pEtr=74753" onclick="fnAPPpopupProduct('1612172&pEtr=74753');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/img_item.jpg" alt="텐바이텐 X 월드비전 HAPPY ANDing 2017 달력 우리의 작은 나눔으로 이 세상 모든 어린이가 행복한 삶을 누릴 수 있어요 지구촌 모든 어린이가 불행한 끝을 맺지 않기를 바랍니다" /></a>
		</div>
		<div class="where"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/txt_where_v2.jpg" alt="2017 캘린더 판매 수익금은 어디에 쓰이나요? 판매 수익금 중 일부는 13,262명의 캄보디아 프레비히아 지역 주민들에게 깨끗한 물과 새로운삶을 선물할 식수 위생 사업을 지원합니다." /></div>
		<div class="hope">
		<!-- <img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/txt_hope.jpg" alt="끝이 아닌 함께 만드는 새로운 시작, 우리의 매일 매일이 진정한 해피앤딩이 되기를 바랍니다" /> -->
		<!-- 기획자 요청시 아래 이미지로 교체 / URL삽입(모바일 앱버전 유의) (12/06(화) 예정) -->
		<a href="https://goo.gl/SpsNHJ"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/txt_hope_v2.jpg" alt="끝이 아닌 함께 만드는 새로운 시작, 우리의 매일 매일이 진정한 해피앤딩이 되기를 바랍니다" /></a>
		</div>
		<div class="benefits"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/txt_benefits_v2.jpg" alt="월드비전과 함께하면 무엇을 도와줄 수 있나요? 건강 식수 교육 참여 정서" /></div>
		<div class="snsShare">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74753/m/img_sns.jpg" alt="월드비전 2017 캠페인을 친구에게 소문 내 주세요" /></p>
			<ul>
				<li><a href="" onclick="snschk('fb');return false;" class="fb">페이스북</a></li>
				<li><a href="" onclick="snschk('ka');return false;" class="kakao">카카오톡</a></li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->