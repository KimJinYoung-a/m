<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 69220-시리즈
' History : 2016-02-19 유태욱 생성
'####################################################
Dim appevturl

If isapp = "1" Then
	appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
Else
	appevturl = "/event/eventmain.asp?"
End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}
});
</script>
<style type="text/css">
img {vertical-align:top;}
.earlyBirdTab {overflow:hidden; position:absolute; left:0; top:0; width:100%; height:108px; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69220/m/bg_tab.png) 0 0 no-repeat; background-size:100% 100%;}
.earlyBirdTab .swiper {position:absolute; left:0; top:0; width:100%; height:100%;}
.earlyBirdTab .swiper1 {left:-8px; width:276px;}
.earlyBirdTab .swiper-slide a {position:relative; display:block;}
.earlyBirdTab .swiper-slide span {display:none;}
.earlyBirdTab .swiper-slide.current span {display:block; position:absolute; left:0; top:0; width:100%; height:100%; background-repeat:no-repeat; background-position:0 0; background-size:100% 100%;}
.earlyBirdTab .day0222 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0222_on.png);}
.earlyBirdTab .day0223 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0223_on.png);}
.earlyBirdTab .day0224 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0224_on.png);}
.earlyBirdTab .day0225 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0225_on.png);}
.earlyBirdTab .day0226 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0226_on.png);}
.earlyBirdTab .day0227 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0227_on.png);}
.earlyBirdTab .day0228 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0228_on.png);}
.earlyBirdTab .swiper button {position:absolute; top:46%; z-index:20; width:20px; background:transparent;}
.earlyBirdTab .swiper .prev {left:5px;}
.earlyBirdTab .swiper .next {right:5px;}

@media all and (min-width:480px){
	.earlyBirdTab {height:163px;}
	.earlyBirdTab .swiper1 {width:420px;}
	.earlyBirdTab .swiper button {width:38px;}
}
</style>
<script type="text/javascript">
$(function(){
	/* swipe */
	showSwiper= new Swiper('.swiper1',{
		<% If Date() < "2016-02-25" then %>
			initialSlide:1, // 24일까지
		<% elseif Date() >= "2016-02-25" and Date() < "2016-02-28" then %>
			initialSlide:3, // 25~27일
		<% else %>
			initialSlide:4, // 28일
		<% end if %>
		slidesPerView:3,
		pagination:false,
		speed:300,
		nextButton:'.next',
		prevButton:'.prev'
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			showSwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});
});
</script>
<div class="earlyBirdTab">
	<div class="swiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<% If Date() >="2016-02-22" then %>
					<div class="swiper-slide day0222 <%=chkiif(Date()="2016-02-22","current","")%>"><a href="<%=appevturl%>eventid=69220" target="_top"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0222.png" alt="2월 22일(월)-DAILY LOOK" /></a></div>
				<% else %>
					<div class="swiper-slide day0222"><a href="javascript:;"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0222.png" alt="2월 22일(월)-DAILY LOOK" /></a></div>
				<% end if %>
				
				<% If Date() >="2016-02-23" then %>
					<div class="swiper-slide day0223 <%=chkiif(Date()="2016-02-23","current","")%>"><a href="<%=appevturl%>eventid=69281" target="_top"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0223.png" alt="2월 23일(화)-S/S INTERIOR" /></a></div>
				<% else %>
					<div class="swiper-slide day0223"><a href="javascript:;"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0223.png" alt="2월 23일(화)-S/S INTERIOR" /></a></div>
				<% end if %>

				<% If Date() >="2016-02-24" then %>
					<div class="swiper-slide day0224 <%=chkiif(Date()="2016-02-24","current","")%>"><a href="<%=appevturl%>eventid=69282" target="_top"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0224.png" alt="2월 24일(수)-GO OUT" /></a></div>
				<% else %>
					<div class="swiper-slide day0224"><a href="javascript:;"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0224.png" alt="2월 24일(수)-GO OUT" /></a></div>
				<% end if %>

				<% If Date() >="2016-02-25" then %>
					<div class="swiper-slide day0225 <%=chkiif(Date()="2016-02-25","current","")%>"><a href="<%=appevturl%>eventid=69283" target="_top"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0225.png" alt="2월 25일(목)-CLEAN HOME" /></a></div>
				<% else %>
					<div class="swiper-slide day0225"><a href="javascript:;"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0225.png" alt="2월 25일(목)-CLEAN HOME" /></a></div>
				<% end if %>

				<% If Date() >="2016-02-26" then %>
					<div class="swiper-slide day0226 <%=chkiif(Date()="2016-02-26","current","")%>"><a href="<%=appevturl%>eventid=69284" target="_top"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0226.png" alt="2월 26일(금)-NEW START" /></a></div>
				<% else %>
					<div class="swiper-slide day0226"><a href="javascript:;"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0226.png" alt="2월 26일(금)-NEW START" /></a></div>
				<% end if %>

				<% If Date() >="2016-02-27" then %>
					<div class="swiper-slide day0227 <%=chkiif(Date()="2016-02-27","current","")%>"><a href="<%=appevturl%>eventid=69285" target="_top"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0227.png" alt="2월 27일(토)-GARDENING" /></a></div>
				<% else %>
					<div class="swiper-slide day0227"><a href="javascript:;"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0227.png" alt="2월 27일(토)-GARDENING" /></a></div>
				<% end if %>

				<% If Date() >="2016-02-28" then %>
					<div class="swiper-slide day0228 <%=chkiif(Date()="2016-02-28","current","")%>"><a href="<%=appevturl%>eventid=69286" target="_top"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0228.png" alt="2월 28일(일)-BEAUTY" /></a></div>
				<% else %>
					<div class="swiper-slide day0228"><a href="javascript:;"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/tab_0228.png" alt="2월 28일(일)-BEAUTY" /></a></div>
				<% end if %>

			</div>
		</div>
		<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69220/m/btn_next.png" alt="다음" /></button>
	</div>
</div>
