<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2019-10-01"
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
	If vEventID = "102798" Then '// 01
		vStartNo = "0"
	ElseIf vEventID = "103349" Then '// 02
		vStartNo = "0"
	ElseIf vEventID = "104468" Then '// 03
		vStartNo = "0"
	ElseIf vEventID = "105200" Then '// 04
		vStartNo = "1"
	ElseIf vEventID = "00000" Then '// 05
		vStartNo = "2"
	End If
%>
<style type="text/css">
.navigator {position:relative; height:16.5vw; padding:0 5.73vw; background:#fff;}
.navigator .swiper-slide {width:33.33333%; text-align:center;}
.navigator .swiper-slide span,
.navigator .swiper-slide a {display:flex; align-items:center; justify-content:center; height:16.5vw; padding-top:.4rem; color:#999; font:normal 3.8vw/1.3 'CoreSansCMedium','NotoSansKRMedium'; letter-spacing:-.03rem;}
.navigator .swiper-slide.current a {color:#444;}
.navigator button {position:absolute; top:0; width:5.73vw; height:100%; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/eventIMG/2020/103349/btn_nav.png) 100% 50% no-repeat; background-size:1.46vw auto;}
.navigator .btn-prev {left:0;}
.navigator .btn-next {right:0; transform:scaleX(-1);}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		prevButton:"#navigator .btn-prev",
		nextButton:"#navigator .btn-next"
	});
    $(".navigator .coming").on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});
});
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
            <li class="swiper-slide open<%=CHKIIF(vEventID="102798"," current","")%>">
                <a href="/event/eventmain.asp?eventid=102798" target="_top">01<br>빌리엔젤</a>
            </li>

            <% if currentdate < "2020-06-15" then %>
            <li class="swiper-slide coming"><span>02<br>Coming Soon</span>
            <% Else %>
            <li class="swiper-slide open<%=CHKIIF(vEventID="103349"," current","")%>">
                <a href="/event/eventmain.asp?eventid=103349" target="_top">02<br>프루터리</a>
            <% End If %>
            </li>

            <% if currentdate < "2020-07-21" then %>
            <li class="swiper-slide coming"><span>03<br>Coming Soon</span>
            <% Else %>
            <li class="swiper-slide open<%=CHKIIF(vEventID="104468"," current","")%>">
                <a href="/event/eventmain.asp?eventid=104468" target="_top">03<br>tml</a>
            <% End If %>
			</li>
			
			<% if currentdate < "2020-08-19" then %>
            <li class="swiper-slide coming"><span>04<br>Coming Soon</span>
            <% Else %>
            <li class="swiper-slide open<%=CHKIIF(vEventID="105200"," current","")%>">
                <a href="/event/eventmain.asp?eventid=105200" target="_top">04<br>평화다방</a>
            <% End If %>
            </li>

		</ul>
	</div>
	<button type="button" class="btn-prev">이전</button>
	<button type="button" class="btn-next">다음</button>
</div>