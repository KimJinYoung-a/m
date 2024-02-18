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

	dim strRefer : strRefer = Request.ServerVariables("HTTP_REFERER") 
	dim eventUrl

	if instr(strRefer,"/subgnb/") > 1 then
		eventUrl = "/subgnb/gnbeventmain.asp?gnbflag=1&eventid"
	ELSEIF instr(strRefer,"/event/gnbeventmain.asp") > 1 then
		eventUrl = "gnbeventmain.asp?gnbflag=1&eventid"
	ELSE
		eventUrl = "eventmain.asp?eventid"
	END IF
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
	If vEventID = "114141" Then '// 7월
		vStartNo = "0"
	ElseIf vEventID = "114410" Then '// 8월
		vStartNo = "1"
	ElseIf vEventID = "114913" Then '// 9월
		vStartNo = "2"
	ElseIf vEventID = "115165" Then '// 10월
		vStartNo = "3"
	ElseIf vEventID = "115330" Then '// 11월
		vStartNo = "4"
	ElseIf vEventID = "115725" Then '// 12월
		vStartNo = "5"
	ElseIf vEventID = "115993" Then '// 1월
		vStartNo = "6"
	ElseIf vEventID = "116532" Then '// 2월
		vStartNo = "7"
	ElseIf vEventID = "" Then '// 3월
		vStartNo = "8"
	ElseIf vEventID = "" Then '// 4월
		vStartNo = "9"
	ElseIf vEventID = "" Then '// 5월
		vStartNo = "10"
	End If
%>
<style type="text/css">
.wrap-bg { position:relative;}
.navigator {position:absolute; bottom:0; left:0; width:100%;}
.navigator .swiper-container {padding:0 8%;}
.navigator .swiper-slide {width:33.3%; height:4.78rem; color:#999; font-size:1.3rem;}
.navigator .swiper-slide span,
.navigator .swiper-slide a {display:flex; justify-content:center; align-items:center; width:100%; height:100%;}
.navigator .swiper-slide a {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.navigator button {position:absolute; bottom:1.2rem; z-index:100; width:4.5rem; height:50%; background: #222 url(//webimage.10x10.co.kr/fixevent/event/2021/113103/m/btn_prev.png) no-repeat center; font-size:0; color:transparent; background-size:1.6vw;}
.navigator .swiper-slide.current a{color:#fff;}
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
	$('.swiper-slide span').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});
});
</script>
<div class="wrap-bg">
    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113103/m/bg_newmovie.jpg" alt="">
    <div id="navigator" class="navigator">
        <div class="swiper-container">
            <ul class="swiper-wrapper">
                <% if currentdate < "2021-10-07" then %>
                <li class="swiper-slide"><span>Green</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="114141"," current","")%>"><a href="<%=eventUrl%>=114141">Green</a>
                <% End If %>
                </li>

                <% if currentdate < "2021-10-21" then %>
                <li class="swiper-slide"><span>Blue</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="114410"," current","")%>"><a href="<%=eventUrl%>=114410">Blue</a>
                <% End If %>
                </li>

                <% if currentdate < "2021-11-04" then %>
                <li class="swiper-slide"><span>Orange</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="114913"," current","")%>"><a href="<%=eventUrl%>=114913">Orange</a>
                <% End If %>
                </li>

				<% if currentdate < "2021-11-18" then %>
                <li class="swiper-slide"><span>Purple</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="115165"," current","")%>"><a href="<%=eventUrl%>=115165">Purple</a>
                <% End If %>
                </li>

				<% if currentdate < "2021-12-02" then %>
                <li class="swiper-slide"><span>Black</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="115330"," current","")%>"><a href="<%=eventUrl%>=115330">Black</a>
                <% End If %>
                </li>

				<% if currentdate < "2021-12-16" then %>
                <li class="swiper-slide"><span>Red</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="115725"," current","")%>"><a href="<%=eventUrl%>=115725">Red</a>
                <% End If %>
                </li>

				<% if currentdate < "2022-01-05" then %>
                <li class="swiper-slide"><span>Pink</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="115993"," current","")%>"><a href="<%=eventUrl%>=115993">Pink</a>
                <% End If %>
                </li>

				<% if currentdate < "2022-02-08" then %>
                <li class="swiper-slide"><span>White</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="116532"," current","")%>"><a href="<%=eventUrl%>=116532">White</a>
                <% End If %>
                </li>

            </ul>
        </div>
        <button type="button" class="btn-prev">이전</button>
        <button type="button" class="btn-next">다음</button>
    </div>
</div>