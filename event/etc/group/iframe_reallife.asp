<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    dim currentdate
	currentdate = date()

'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo
	vEventID = requestCheckVar(Request("eventid"),9)
	If vEventID = "115007" Then '//7월
		vStartNo = "0"
	ElseIf vEventID = "116559" Then '// 8월
		vStartNo = "1"
	ElseIf vEventID = "" Then '// 9월
		vStartNo = "2"
	ElseIf vEventID = "" Then '// 10월
		vStartNo = "3"
	ElseIf vEventID = "" Then '// 11월
		vStartNo = "4"
	ElseIf vEventID = "" Then '// 10월
		vStartNo = "5"
	ElseIf vEventID = "" Then '// 10월
		vStartNo = "6"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; background-color:#fff;}
.swiper-button-next, .swiper-button-prev{margin-top:0;color:none;}
.swiper-button-next:after, .swiper-rtl .swiper-button-prev:after{content:none;}
.swiper-button-prev:after, .swiper-rtl .swiper-button-next:after{content:none;}
.swiper-button-next.swiper-button-disabled, .swiper-button-prev.swiper-button-disabled{opacity:1;}
.monthTab {position:relative; padding-bottom:1.47vw; background:url(//webimage.10x10.co.kr/fixevent/event/2021/115007/m/title.jpg)no-repeat 0 0;background-size:100%;overflow:hidden;}
.monthTab .swiper-container{width:40%;float:right;padding:0 5%;overflow:hidden;margin-right:3vw;margin-top:1vw;}
.monthTab .swiper-slide {width:33.3%; height:4.78rem; color:#000; font-size:1.3rem;}
.monthTab .swiper-slide .img{display:none;}
.monthTab .swiper-slide span,
.monthTab .swiper-slide a {display:flex;position:relative; justify-content:center; align-items:center; width:100%; height:100%;font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.monthTab .swiper-slide em{display:none;}
.monthTab .swiper-slide.current {color:#000;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.monthTab .button {position:absolute; top:0; z-index:100; width:6vw;height:100%; background:#fff url(//fiximage.10x10.co.kr/m/2021/common/arrow_b.png) no-repeat center;background-size:40%; font-size:0;}
.monthTab .swiper-button-prev {left:-1vw;}
.monthTab .swiper-button-next {right:-1vw; transform:scaleX(-1);}
.monthTab .swiper-pagination{display:none;}
</style>
<script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.monthTab .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"1",
		speed:300,
		navigation: {
          nextEl: ".swiper-button-next",
          prevEl: ".swiper-button-prev",
        },
	});
	$('.swiper-slide.coming').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다.");
	});
});

function goEventLink(evt) {
	<% if isApp then %>
		parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}

</script>
</head>
<body>
<div class="monthTab">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<% if currentdate < "2022-01-03" then %>
			<li class="swiper-slide"><span>hobby</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="115007"," current","")%>"><a href="javascript:void(0)" onclick="goEventLink(115007)"><p>hobby</p></a>
			<% End If %>
			</li>

			<% if currentdate < "2022-02-07" then %>
			<li class="swiper-slide"><span>attachment</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="116559"," current","")%>"><a href="javascript:void(0)" onclick="goEventLink(116559)"><p>attachment</p></a>
			<% End If %>
			</li>
		</ul>
		<div class="button black swiper-button-next"></div>
      	<div class="button black swiper-button-prev"></div>
	</div>
</div>
</body>
</html>