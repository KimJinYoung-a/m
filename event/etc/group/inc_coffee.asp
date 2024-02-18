<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2020-03-26"
	'response.write currentdate
%>
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo
	vEventID = requestCheckVar(Request("eventid"),9)
	If vEventID = "101918" Then '//4월
		vStartNo = "0"
	ElseIf vEventID = "102974" Then '// 5월
		vStartNo = "0"
	ElseIf vEventID = "00000" Then '// 6월
		vStartNo = "0"
	ElseIf vEventID = "00000" Then '// 7월
		vStartNo = "1"
	End If
%>
<style type="text/css">
.navigator {position:relative; padding-bottom:1.47vw; background-color:#fff;}
.navigator .swiper-container {padding:0 9.87%;}
.navigator .swiper-slide {width:21.5%; height:15.2vw; text-align:center; color:#c3c3c3; font-size:4vw; line-height:16vw; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.navigator .swiper-slide em {display:none;}
.navigator .swiper-slide.current {width:57%; color:#393939;}
.navigator .swiper-slide.current p {display:inline; border-bottom:.4vw solid #585858;}
.navigator .swiper-slide.current em {display:inline-block; padding-left:2vw; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular';}
.navigator .swiper-slide a {display:block; width:100%; height:100%;}
.navigator button {position:absolute; top:0; z-index:100; width:9.87%; height:100%; background:#fff url(//webimage.10x10.co.kr/eventIMG/2020/102974/btn_nav_m.png) 50%/100% no-repeat; font-size:0;}
.navigator .btn-prev {left:0;}
.navigator .btn-next {right:0; transform:rotate(180deg);}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		prevButton:"#navigator .btn-prev",
		nextButton:"#navigator .btn-next"
	});
	$('.swiper-slide span').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide <%=CHKIIF(vEventID="101918"," current","")%>"><a href="eventmain.asp?eventid=101918"><p>4월호<em>프릳츠</em></p></a></li>
			<li class="swiper-slide <%=CHKIIF(vEventID="102974"," current","")%>"><a href="eventmain.asp?eventid=102974"><p>5월호<em>프레이저커피</em></p></a></li>

			<% if currentdate < "2021-02-19" then %>
			<li class="swiper-slide"><span>6월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="eventmain.asp?eventid=101918"><p>6월호<em></em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-03-26" then %>
			<li class="swiper-slide"><span>7월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="eventmain.asp?eventid=000000"><p>7월호<em></em></p></a>
			<% End If %>
			</li>

		</ul>
		<button type="button" class="btn-prev">이전</button>
  		<button type="button" class="btn-next">다음</button>
	</div>
</div>