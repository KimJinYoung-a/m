<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 봄마중 브랜드
' History : 2017.02.17 유태욱 생성
'####################################################
%>
<%
dim currentDate, i
	currentDate =  date()
'	currentDate="2017-02-21"

	Dim vEventID, vStartNo
	vEventID = requestCheckVar(Request("eventid"),9)
'		initialSlide:vStartNo, 
	If vEventID = "76316" Then '// 2017-
		vStartNo = "0"

	ElseIf vEventID = "76316" Then '// 2017-
		vStartNo = "0"

	ElseIf vEventID = "76316" Then '// 2017-
		vStartNo = "0"

	ElseIf vEventID = "76316" Then '// 2017-
		vStartNo = "0"

	ElseIf vEventID = "76316" Then '// 2017-
		vStartNo = "0"

	ElseIf vEventID = "76316" Then '// 2017-
		vStartNo = "0"

	ElseIf vEventID = "76316" Then '// 2017-
		vStartNo = "0"

	ElseIf vEventID = "76316" Then '// 2017-
		vStartNo = "0"

	else
		vStartNo = "0"
	End IF
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.evntDateWrap {background-color:#f0db69;}
.evntDate {width:32rem; height:6.5rem;}
.evntDate .swiper-container {height:6.5rem;}
.evntDate .swiper-wrapper {height:6.5rem;}
.evntDate .swiper-slide {position:relative; float:left; width:13.1rem !important;}
.evntDate .swiper-slide img {vertical-align:top;}

@media all and (min-width:360px){
	.evntDate {width:36rem;}
}
@media all and (min-width:375px){
	.evntDate {width:37.5rem;}
}
@media all and (min-width:600px){
	.evntDate {width:60rem;}
}
@media all and (min-width:800px){
	.evntDate {width:80rem;}
}
</style>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.evntDate .swiper-container',{
		slidesPerView:"auto",
		speed:300,
		nextButton:'.evntDate .btnNext',
		prevButton:'.evntDate .btnPrev'
	});
});
</script>
</head>
<body>
	<%'' for dev msg  evntDate 클래스 iframe 으로 해주세요 %>
	<div class="evntDateWrap">
		<div class="evntDate">
			<div class="swiper-container">
				<ul class="swiper-wrapper">
					<%'' for dev msg 오픈예정: tab_오픈일.png / 오픈날짜: tab_오픈일_on.png / 지난날짜: tab_오픈일_end.png  %>
					
					<% if currentDate="2017-02-20" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0220_on.png" alt="02.20 (월) 조셉앤스테이시" /></li>
					<% elseif currentDate>"2017-02-20" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0220_end.png" alt="02.20 (월) 조셉앤스테이시" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0220_on.png" alt="02.20 (월) 조셉앤스테이시" /></li>
					<% end if %>

					<% if currentDate="2017-02-21" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0221_on.png" alt="02.21 (화) 마메종" /></li>
					<% elseif currentDate>"2017-02-21" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0221_end.png" alt="02.21 (화) 마메종" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0221.png" alt="02.21 (화) 마메종" /></li>
					<% end if %>

					<% if currentDate="2017-02-22" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0222_on.png" alt="02.22 (수)" /></li>
					<% elseif currentDate>"2017-02-22" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0222_end.png" alt="02.22 (수)" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0222.png" alt="02.22 (수)" /></li>
					<% end if %>

					<% if currentDate="2017-02-23" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0223_on.png" alt="02.23 (목)" /></li>
					<% elseif currentDate>"2017-02-23" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0223_end.png" alt="02.23 (목)" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0223.png" alt="02.23 (목)" /></li>
					<% end if %>

					<% if currentDate="2017-02-24" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0224_on.png" alt="02.24 (금)" /></li>
					<% elseif currentDate>"2017-02-24" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0224_end.png" alt="02.24 (금)" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0224.png" alt="02.24 (금)" /></li>
					<% end if %>

					<% if currentDate="2017-02-25" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0225_on.png" alt="02.25 (토)" /></li>
					<% elseif currentDate>"2017-02-25" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0225_end.png" alt="02.25 (토)" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0225.png" alt="02.25 (토)" /></li>
					<% end if %>

					<% if currentDate="2017-02-26" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0226_on.png" alt="02.26 (일)" /></li>
					<% elseif currentDate>"2017-02-26" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0226_end.png" alt="02.26 (일)" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0226.png" alt="02.26 (일)" /></li>
					<% end if %>

					<% if currentDate="2017-02-27" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0227_on.png" alt="02.27 (월)" /></li>
					<% elseif currentDate>"2017-02-27" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0227_end.png" alt="02.27 (월)" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0227.png" alt="02.27 (월)" /></li>
					<% end if %>

					<% if currentDate="2017-02-28" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0228_on.png" alt="02.28 (화)" /></li>
					<% elseif currentDate>"2017-02-28" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0228_end.png" alt="02.28 (화)" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0228.png" alt="02.28 (화)" /></li>
					<% end if %>

					<% if currentDate="2017-03-01" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0301_on.png" alt="03.01 (수)" /></li>
					<% elseif currentDate>"2017-03-01" then %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0301_end.png" alt="03.01 (수)" /></li>
					<% else %>
						<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76316/m/tab_0301.png" alt="03.01 (수)" /></li>
					<% end if %>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>