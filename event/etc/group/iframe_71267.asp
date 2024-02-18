<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim evt_code : evt_code = request("eventid")
Dim styleSTR, currentDate, i

IF application("Svr_Info") = "Dev" THEN	'	테섭이벤트코드
	currentDate =  date()+1
Else
	currentDate =  date()
End If

Dim vEventID, vStartNo, appevturl
vEventID = requestCheckVar(Request("eventid"),6)

Select Case vEventID
	Case "71267"		vStartNo = 0
	Case "71315"		vStartNo = 1
	Case "71304"		vStartNo = 2
	Case "71333"		vStartNo = 3
	Case "71335"		vStartNo = 4
	Case "71317"		vStartNo = 5
	Case "71322"		vStartNo = 6
	Case "71318"		vStartNo = 7
	Case "71320"		vStartNo = 8
	Case "71312"		vStartNo = 9
	Case "71336"		vStartNo = 10
	Case "71337"		vStartNo = 11
	Case "71334"		vStartNo = 12
	Case "71313"		vStartNo = 13
	Case "71319"		vStartNo = 14
	Case "71316"		vStartNo = 15
	Case Else			vStartNo = 0
End Select

If isapp = "1" Then
	appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
Else
	appevturl = "/event/eventmain.asp?"
End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mEvt71267 .navigator {position:relative; margin:0 auto; padding:8px 0; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/bg_brand_tab.png) repeat-y 0 0; background-size:100% auto;}
.mEvt71267 .navigator button {overflow:hidden; display:block; position:absolute; top:0; left:50%; z-index:150; width:25px; height:100%; background-position:50% 50%; background-repeat:no-repeat; background-color:transparent; text-indent:-999em;}
.mEvt71267 .navigator .prev {margin-left:-160px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/btn_prev.png); background-size:10px auto;}
.mEvt71267 .navigator .next {margin-left:135px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/btn_next.png); background-size:10px auto;}
.mEvt71267 .navigator .swiper1 {width:276px; height:92px; margin:0 auto;}
.mEvt71267 .swiper1 .swiper-slide {width:92px; height:92px; padding:0 2px;}
.mEvt71267 .swiper1 .swiper-slide span {display:block; position:relative; background-repeat:no-repeat; background-position:0 0; background-size:100% 300%;}
.mEvt71267 .swiper1 .swiper-slide span a {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:transparent; text-indent:-999em;}
.mEvt71267 .swiper-slide.date0615 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0615.png);}
.mEvt71267 .swiper-slide.date0616 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0616.png);}
.mEvt71267 .swiper-slide.date0617 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0617.png);}
.mEvt71267 .swiper-slide.date0618 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0618.png);}
.mEvt71267 .swiper-slide.date0619 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0619.png);}
.mEvt71267 .swiper-slide.date0620 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0620.png);}
.mEvt71267 .swiper-slide.date0621 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0621.png);}
.mEvt71267 .swiper-slide.date0622 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0622.png);}
.mEvt71267 .swiper-slide.date0623 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0623.png);}
.mEvt71267 .swiper-slide.date0624 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0624.png);}
.mEvt71267 .swiper-slide.date0625 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0625.png);}
.mEvt71267 .swiper-slide.date0626 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0626.png);}
.mEvt71267 .swiper-slide.date0627 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0627.png);}
.mEvt71267 .swiper-slide.date0628 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0628.png);}
.mEvt71267 .swiper-slide.date0629 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0629.png);}
.mEvt71267 .swiper-slide.date0630 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/71267/m/tab_0630.png);}
.mEvt71267 .swiper1 .swiper-slide.current span {background-position:0 50%;}
.mEvt71267 .swiper1 .swiper-slide.finish span {background-position:0 100%;}
.mEvt71267 .swiper1 .swiper-slide.finish span a,
.mEvt71267 .swiper1 .swiper-slide.current span a {display:block;}

@media all and (min-width:480px){
.mEvt71267 .navigator {height:160px; padding:12px 0;}
.mEvt71267 .navigator button {width:37px;}
.mEvt71267 .navigator .prev {margin-left:-250px; background-size:15px auto;}
.mEvt71267 .navigator .next {margin-left:212px; background-size:15px auto;}
.mEvt71267 .navigator .swiper1 {width:435px; height:139px;}
.mEvt71267 .swiper1 .swiper-slide {width:139px; height:139px; padding:0 3px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		//loop:true,
		initialSlide:<%=vStartNo%>,
		slidesPerView:3,
		resizeReInit:true,
		calculateHeight:true,
		speed:500,
		pagination:false,
		autoplayDisableOnInteraction:false,
		nextButton:'.next',
		prevButton:'.prev'
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".app").show();
			$(".mo").hide();
	}else{
			$(".app").hide();
			$(".mo").show();
	}
});
</script>
</head>
<body>
<div class="mEvt71267">
	<div class="navigator">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
		<%
		For i = 15 to 30 
			If i = day(currentDate) Then
				styleSTR = " current"
			ElseIf i > day(currentDate) Then
				styleSTR = ""
			Else
				styleSTR = " finish"
			End If
			Select Case i
				Case "15"		evt_code = "71267"
				Case "16"		evt_code = "71315"
				Case "17"		evt_code = "71304"
				Case "18"		evt_code = "71333"
				Case "19"		evt_code = "71335"
				Case "20"		evt_code = "71317"
				Case "21"		evt_code = "71322"
				Case "22"		evt_code = "71318"
				Case "23"		evt_code = "71320"
				Case "24"		evt_code = "71312"
				Case "25"		evt_code = "71336"
				Case "26"		evt_code = "71337"
				Case "27"		evt_code = "71334"
				Case "28"		evt_code = "71313"
				Case "29"		evt_code = "71319"
				Case "30"		evt_code = "71316"
			End Select
		%>
				<div class="swiper-slide date06<%= i %> <%= styleSTR %>"><span><img src="http://webimage.10x10.co.kr/eventIMG/2015/68119/m/bg_date.png" alt="" /><a href="<%=appevturl%>eventid=<%=evt_code%>" target="_top">6월 <%= i %>일</a></span></div><!-- 해당 날짜일때 current-->
		<% Next %>
			</div>
		</div>
		<button type="button" class="prev">이전</button>
		<button type="button" class="next">다음</button>
	</div>
</div>
</body>
</html>