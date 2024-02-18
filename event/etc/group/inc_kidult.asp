<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2017-09-05"
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
	If vEventID = "83094" Then '//12월
		vStartNo = "0"
	ElseIf vEventID = "83921" Then '// 1월
		vStartNo = "0"
	ElseIf vEventID = "84640" Then '// 2월
		vStartNo = "1"
	ElseIf vEventID = "85326" Then '// 3월
		vStartNo = "2"
	ElseIf vEventID = "86090" Then '// 4월
		vStartNo = "3"
	ElseIf vEventID = "86105" Then '// 5월
		vStartNo = "3"
	ElseIf vEventID = "88362" Then '// 8월
		vStartNo = "5"
	ElseIf vEventID = "89263" Then '// 9월
		vStartNo = "6"
	ElseIf vEventID = "90101" Then '// 10월
		vStartNo = "7"
	ElseIf vEventID = "90556" Then '// 11월
		vStartNo = "9"
	ElseIf vEventID = "90909" Then '// 12월
		vStartNo = "9"
	End If
%>
<style type="text/css">
.navigator {padding:0 3.2%; background-color:#fff;}
.navigator .swiper-slide {height:2rem; position:relative; width:33.333%; text-align:center; color:#999; font:600 1.2rem 'AvenirNext-Regular', 'AppleSDGothicNeo-Regular', 'RobotoRegular', 'Noto Sans', sans-serif;}
.navigator .swiper-slide.swiper-slide-next:before,
.navigator .swiper-slide.swiper-slide-next:after {content:' '; position:absolute; top:50%; width:1px; height:1.8rem; margin-top:-.9rem; background-color:#dcdcdc;}
.navigator .swiper-slide.swiper-slide-next:before{left:0;}
.navigator .swiper-slide.swiper-slide-next:after{right:0;}
.navigator .swiper-slide a {display:block; width:42.7%; height:100%; margin:0 auto; }
.navigator .swiper-slide a.current {color:#3a3a3a; border-bottom:0.15rem solid #ffc600;}
.navigator button {position:absolute; top:0; width:2.5%; background-color:transparent; z-index:10; cursor:pointer;}
.navigator button img {width:100%; height:100%;}
.navigator .btnPrev {left:0}
.navigator .btnNext {right:0}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		prevButton:"#navigator .btnPrev",
		nextButton:"#navigator .btnNext",
	});
	$('.swiper-slide.coming').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다.");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide"><a href="eventmain.asp?eventid=83094" <%=CHKIIF(vEventID="83094"," class='current'","")%>>12월호</a></li>

			<% if currentdate < "2018-01-24" then %>
			<li class="swiper-slide coming">1월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=83921" <%=CHKIIF(vEventID="83921"," class='current'","")%>>1월호</a></li>
			<% End If %>

			<% if currentdate < "2018-02-21" then %>
			<li class="swiper-slide coming">2월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=84640" <%=CHKIIF(vEventID="84640"," class='current'","")%>>2월호</a></li>
			<% End If %>

			<% if currentdate < "2018-03-24" then %>
			<li class="swiper-slide coming">3월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=85326" <%=CHKIIF(vEventID="85326"," class='current'","")%>>3월호</a></li>
			<% End If %>

			<% if currentdate < "2018-04-25" then %>
			<li class="swiper-slide coming">4월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=86090" <%=CHKIIF(vEventID="86090"," class='current'","")%>>4월호</a></li>
			<% End If %>

			<% if currentdate < "2018-05-01" then %>
			<li class="swiper-slide coming">5월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=86105" <%=CHKIIF(vEventID="86105"," class='current'","")%>>5월호</a></li>
			<% End If %>

			<% if currentdate < "2018-08-06" then %>
			<li class="swiper-slide coming">8월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=88362" <%=CHKIIF(vEventID="88362"," class='current'","")%>>8월호</a></li>
			<% End If %>

			<% if currentdate < "2018-09-18" then %>
			<li class="swiper-slide coming">9월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=89263" <%=CHKIIF(vEventID="89263"," class='current'","")%>>9월호</a></li>
			<% End If %>

			<% if currentdate < "2018-10-30" then %>
			<li class="swiper-slide">10월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=90101" <%=CHKIIF(vEventID="90101"," class='current'","")%>>10월호</a></li>
			<% End If %>

			<% if currentdate < "2018-11-26" then %>
			<li class="swiper-slide coming">11월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=90556" <%=CHKIIF(vEventID="90556"," class='current'","")%>>11월호</a></li>
			<% End If %>

			<% if currentdate < "2018-12-05" then %>
			<li class="swiper-slide coming">12월호</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=90909" <%=CHKIIF(vEventID="90909"," class='current'","")%>>12월호</a></li>
			<% End If %>
		</ul>
		<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83094/m/btn_prev.png" alt="다음" /></button>
		<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83094/m/btn_next.png" alt="이전" /></button>
	</div>
</div>