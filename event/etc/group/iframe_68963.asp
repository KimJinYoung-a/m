<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo , appevturl
	vEventID = requestCheckVar(Request("eventid"),6)
	If vEventID = "68970" Then
		vStartNo = "5"
	ElseIf vEventID = "68983" Then
		vStartNo = "4"
	ElseIf vEventID = "68967" Then
		vStartNo = "3"
	ElseIf vEventID = "68935" Then
		vStartNo = "2"
	ElseIf vEventID = "68985" Then
		vStartNo = "1"
	ElseIf vEventID = "68963" Then
		vStartNo = "0"
	Else 
		vStartNo = "0"
	End If

	If isapp = "1" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If 


%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.rolling {padding-top:15px;}
.swiper {position:relative; padding:0 40px; height:80px;}
.swiper .swiper-slide {text-align:center;}

.swiper button {position:absolute; top:50%; z-index:20; width:11px; height:80px; margin-top:-40px; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2016/68963/m/btn_nav.png) no-repeat 0 50%; background-size:22px 20px; text-indent:-9999em;}
.swiper .btn-prev {left:15px;}
.swiper .btn-next {right:15px; background-position:100% 50%;}

.swiper .swiper-slide a,
.swiper .swiper-slide span {overflow:hidden; display:block; position:relative; width:80px; height:80px; line-height:80px; color:#737373; font-size:13px;}
.swiper .swiper-slide a i,
.swiper .swiper-slide span i {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68963/m/bg_nav_01.png) no-repeat 50% -20px; background-size:80px 300px;}
.swiper .swiper-slide a i {background-position:50% -115px;}
.swiper .swiper-slide a.today i {background-position:50% -210px;}

.swiper .nav2 a i, .swiper .nav2 span i {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68963/m/bg_nav_02.png);}
.swiper .nav3 a i, .swiper .nav3 span i {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68963/m/bg_nav_03_v1.png);}
.swiper .nav4 a i, .swiper .nav4 span i {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68963/m/bg_nav_04_v1.png);}
.swiper .nav5 a i, .swiper .nav5 span i {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68963/m/bg_nav_05_v1.png);}
.swiper .nav6 a i, .swiper .nav6 span i {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68963/m/bg_nav_06_v1.png);}

@media all and (min-width:360px){
	.rolling {padding-top:20px;}
	.swiper .swiper-slide a,
	.swiper .swiper-slide span {width:90px; height:90px; line-height:90px;}
	.swiper .swiper-slide a i, .swiper .swiper-slide span i {background-position:50% -22px; background-size:90px 338px;}
	.swiper .swiper-slide a i {background-position:50% -129px;}
	.swiper .swiper-slide a.today i {background-position:50% -236px;}
}

@media all and (min-width:480px){
	.rolling {padding-top:30px;}
	.swiper button {top:50px;}
	.swiper .swiper-slide a,
	.swiper .swiper-slide span {width:120px; height:120px; line-height:120px;}
	.swiper .swiper-slide a i, .swiper .swiper-slide span i {background-position:50% -30px; background-size:120px 450px;}
	.swiper .swiper-slide a i {background-position:50% -172px;}
	.swiper .swiper-slide a.today i {background-position:50% -315px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		<% if vEventID = "68935" or vEventID = "68967" or vEventID = "68983" then '3~5일차%>
		centeredSlides:false,
		<% end if %>
		initialSlide:<%=vStartNo%>,
		slidesPerView:"3",
		nextButton:'.btn-next',
		prevButton:'.btn-prev',
	});

	$(".swiper .swiper-slide span").click(function(){
		alert("오픈 예정입니다.");
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
		}, 500);
	});
});
</script>
</head>
<body>
<% 
'		68963 #1일차 디자인문구
'		68985 #2일차 여행/취미
'		68935 #3일차 패션
'		68967 #4일차 디지털
'		68983 #5일차 뷰티
'		68970 #6일차 패브릭/수납
%>
	<div class="rolling">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<ul class="swiper-wrapper">

					<li class="swiper-slide nav1"><a href="<%=appevturl%>eventid=68963" class="<%=chkiif(Date()="2016-02-05","today","")%>" target="_top"><i></i>02.05 (금)</a></li>

					<% If Date() >="2016-02-06" then %>
					<li class="swiper-slide nav2"><a href="<%=appevturl%>eventid=68985" class="<%=chkiif(Date()="2016-02-06","today","")%>" target="_top"><i></i>02.06 (토)</a></li>
					<% Else %>
					<li class="swiper-slide nav2"><span><i></i>02.06 (토)</span></li>
					<% End If %>

					<% If Date() >="2016-02-07" then %>
					<li class="swiper-slide nav3"><a href="<%=appevturl%>eventid=68935" class="<%=chkiif(Date()="2016-02-07","today","")%>" target="_top"><i></i>02.07 (일)</a></li>
					<% Else %>
					<li class="swiper-slide nav3"><span><i></i>02.07 (일)</span></li>
					<% End If %>

					<% If Date() >="2016-02-08" then %>
					<li class="swiper-slide nav4"><a href="<%=appevturl%>eventid=68967" class="<%=chkiif(Date()="2016-02-08","today","")%>" target="_top"><i></i>02.08 (월)</a></li>
					<% Else %>
					<li class="swiper-slide nav4"><span><i></i>02.08 (월)</span></li>
					<% End If %>

					<% If Date() >="2016-02-09" then %>
					<li class="swiper-slide nav5"><a href="<%=appevturl%>eventid=68983" class="<%=chkiif(Date()="2016-02-09","today","")%>" target="_top"><i></i>02.09 (화)</a></li>
					<% Else %>
					<li class="swiper-slide nav5"><span><i></i>02.09 (화)</span></li>
					<% End If %>

					<% If Date() >="2016-02-10" then %>
					<li class="swiper-slide nav6"><a href="<%=appevturl%>eventid=68970" class="<%=chkiif(Date()="2016-02-10","today","")%>" target="_top"><i></i>02.10 (수)</a></li>
					<% Else %>
					<li class="swiper-slide nav6"><span><i></i>02.10 (수)</span></li>
					<% End If %>
				</ul>
			</div>
			<button type="button" class="btn-prev">이전</button>
		<button type="button" class="btn-next">다음</button>
		</div>
	</div>
</body>
</html>