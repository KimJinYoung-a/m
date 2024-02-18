<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2018-08-20"
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
	If vEventID = "88272" Then ' // vol.01
		vStartNo = "0"
	ElseIf vEventID = "88538" Then '// vol.02
		vStartNo = "0"
	ElseIf vEventID = "88664" Then '// vol.03
		vStartNo = "0"
	ElseIf vEventID = "88789" Then '// vol.04
		vStartNo = "1"
	ElseIf vEventID = "88948" Then '// vol.05
		vStartNo = "2"
	ElseIf vEventID = "88949" Then '// vol.06
		vStartNo = "3"
	ElseIf vEventID = "88950" Then '// vol.07
		vStartNo = "4"
	ElseIf vEventID = "89466" Then '// vol.08
		vStartNo = "5"
	ElseIf vEventID = "89467" Then '// vol.09
		vStartNo = "6"
	ElseIf vEventID = "89874" Then '// vol.10
		vStartNo = "7"
	ElseIf vEventID = "90123" Then '// vol.11
		vStartNo = "8"
	ElseIf vEventID = "90311" Then '// vol.12
		vStartNo = "9"
	ElseIf vEventID = "90312" Then '// vol.13
		vStartNo = "10"
	ElseIf vEventID = "91087" Then '// vol.14
		vStartNo = "11"
	ElseIf vEventID = "91587" Then '// vol.15
		vStartNo = "12"
	ElseIf vEventID = "91912" Then '// vol.16
		vStartNo = "13"
	ElseIf vEventID = "92279" Then '// vol.17
		vStartNo = "14"
	ElseIf vEventID = "92841" Then '// vol.18
		vStartNo = "15"
	ElseIf vEventID = "93135" Then '// vol.19
		vStartNo = "16"
	ElseIf vEventID = "93391" Then '// vol.20
		vStartNo = "16"
	ElseIf vEventID = "94003" Then '// vol.21
		vStartNo = "17"
	ElseIf vEventID = "94324" Then '// vol.22
		vStartNo = "18"
	End If
%>
<style type="text/css">
.navigator {padding:1rem 7%; background-color:#fff;}
.navigator .swiper-container {padding:0 5%;}
.navigator .swiper-slide {width:25%; text-align:center; font:1.32rem/4rem 'RobotoRegular', 'Noto Sans', sans-serif; color:#737373;}
.navigator .swiper-slide a {display:block; width:90%; height:100%; margin:0 auto; color:#222;}
.navigator .swiper-slide .current {font-weight:600; color:#f87d7d;}
.navigator .swiper-slide .current:after {content:''; position:absolute; top:11%; left:50%; transform:translateX(-50%); width:0.3rem; height:0.3rem; background-color:#ff7575; border-radius:100%;}
.navigator button {position:absolute; top:50%; transform:translateY(-50%); z-index:100; width:4%; padding:0.2%; background-color:transparent; font-size:0;}
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
		nextButton:"#navigator .btnNext"
	});
	$('.swiper-slide.next').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다.");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide"><a href="eventmain.asp?eventid=88272" <%=CHKIIF(vEventID="88272"," class='current'","")%>>vol.01</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=88538" <%=CHKIIF(vEventID="88538"," class='current'","")%>>vol.02</a></li>

			<% if currentdate < "2018-08-21" then %>
			<li class="swiper-slide next">vol.03</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=88664" <%=CHKIIF(vEventID="88664"," class='current'","")%>>vol.03</a></li>
			<% End If %>

			<% if currentdate < "2018-08-27" then %>
			<li class="swiper-slide next">vol.04</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=88789" <%=CHKIIF(vEventID="88789"," class='current'","")%>>vol.04</a></li>
			<% End If %>

			<% if currentdate < "2018-09-04" then %>
			<li class="swiper-slide next">vol.05</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=88948" <%=CHKIIF(vEventID="88948"," class='current'","")%>>vol.05</a></li>
			<% End If %>

			<% if currentdate < "2018-09-11" then %>
			<li class="swiper-slide next">vol.06</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=88949" <%=CHKIIF(vEventID="88949"," class='current'","")%>>vol.06</a></li>
			<% End If %>

			<% if currentdate < "2018-09-18" then %>
			<li class="swiper-slide next">vol.07</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=88950" <%=CHKIIF(vEventID="88950"," class='current'","")%>>vol.07</a></li>
			<% End If %>

			<% if currentdate < "2018-09-25" then %>
			<li class="swiper-slide next">vol.08</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=89466" <%=CHKIIF(vEventID="89466"," class='current'","")%>>vol.08</a></li>
			<% End If %>
			
			<% if currentdate < "2018-10-02" then %>
			<li class="swiper-slide next">vol.09</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=89467" <%=CHKIIF(vEventID="89467"," class='current'","")%>>vol.09</a></li>
			<% End If %>

			<% if currentdate < "2018-10-16" then %>
			<li class="swiper-slide next">vol.10</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=89874" <%=CHKIIF(vEventID="89874"," class='current'","")%>>vol.10</a></li>
			<% End If %>

			<% if currentdate < "2018-10-30" then %>
			<li class="swiper-slide next">vol.11</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=90123" <%=CHKIIF(vEventID="90123"," class='current'","")%>>vol.11</a></li>
			<% End If %>

			<% if currentdate < "2018-11-13" then %>
			<li class="swiper-slide next">vol.12</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=90311" <%=CHKIIF(vEventID="90311"," class='current'","")%>>vol.12</a></li>
			<% End If %>

			<% if currentdate < "2018-11-27" then %>
			<li class="swiper-slide next">vol.13</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=90312" <%=CHKIIF(vEventID="90312"," class='current'","")%>>vol.13</a></li>
			<% End If %>

			<% if currentdate < "2018-12-11" then %>
			<li class="swiper-slide next">vol.14</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91087" <%=CHKIIF(vEventID="91087"," class='current'","")%>>vol.14</a></li>
			<% End If %>

			<% if currentdate < "2019-01-08" then %>
			<li class="swiper-slide next">vol.15</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91587" <%=CHKIIF(vEventID="91587"," class='current'","")%>>vol.15</a></li>
			<% End If %>

			<% if currentdate < "2019-01-22" then %>
			<li class="swiper-slide next">vol.16</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91912" <%=CHKIIF(vEventID="91912"," class='current'","")%>>vol.16</a></li>
			<% End If %>

			<% if currentdate < "2019-02-12" then %>
			<li class="swiper-slide next">vol.17</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=92279" <%=CHKIIF(vEventID="92279"," class='current'","")%>>vol.17</a></li>
			<% End If %>

			<% if currentdate < "2019-02-26" then %>
			<li class="swiper-slide next">vol.18</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=92841" <%=CHKIIF(vEventID="92841"," class='current'","")%>>vol.18</a></li>
			<% End If %>

			<% if currentdate < "2019-03-12" then %>
			<li class="swiper-slide next">vol.19</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=93135" <%=CHKIIF(vEventID="93135"," class='current'","")%>>vol.19</a></li>
			<% End If %>

			<% if currentdate < "2019-04-09" then %>
			<li class="swiper-slide next">vol.20</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=93391" <%=CHKIIF(vEventID="93391"," class='current'","")%>>vol.20</a></li>
			<% End If %>

			<% if currentdate < "2019-04-23" then %>
			<li class="swiper-slide next">vol.21</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=94003" <%=CHKIIF(vEventID="94003"," class='current'","")%>>vol.21</a></li>
			<% End If %>

			<% if currentdate < "2019-05-08" then %>
			<li class="swiper-slide next">vol.22</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=94324" <%=CHKIIF(vEventID="94324"," class='current'","")%>>vol.22</a></li>
			<% End If %>
		</ul>
		<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88664/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88664/m/btn_next.png" alt="다음" /></button>
	</div>
</div>