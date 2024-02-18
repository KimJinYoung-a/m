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
	If vEventID = "100859" Then '// 01
		vStartNo = "0"
	ElseIf vEventID = "101557" Then '// 02
		vStartNo = "0"
	ElseIf vEventID = "102311" Then '// 03
		vStartNo = "0"
	ElseIf vEventID = "103794" Then '// 04
		vStartNo = "1"
	ElseIf vEventID = "104599" Then '// 05
		vStartNo = "2"
	ElseIf vEventID = "106897" Then '// 06
		vStartNo = "3"
	ElseIf vEventID = "111652" Then '// 07
		vStartNo = "4"
	ElseIf vEventID = "111975" Then '// 08
		vStartNo = "5"
	ElseIf vEventID = "112554" Then '// 09
		vStartNo = "6"
	ElseIf vEventID = "113118" Then '// 10
		vStartNo = "7"
	ElseIf vEventID = "00000" Then '// 11
		vStartNo = "8"
	End If
%>
<style type="text/css">
.navigator {position:relative; height:15vw; padding:0 8vw; background:#fff;}
.navigator .swiper-slide {width:25.3vw; height:8.7vw; margin-top:6.3vw;}
.navigator .swiper-slide.current {width:33.3vw; height:10.7vw; margin-top:4.3vw;}
.navigator .swiper-slide a {display:flex; align-items:center; justify-content:center; height:100%; text-align:center; font-family:'CoreSansCMedium'; font-size:3vw; color:#fff; background:#c4c4c4; border-radius:2.7vw 2.7vw 0 0;}
.navigator .swiper-slide.current a {font-family:'CoreSansCBold'; font-size:4vw; background:#222;}
.navigator button {position:absolute; top:0; width:8vw; height:100%; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100859/m/nav_arrow.png) 50% no-repeat; background-size:100%;}
.navigator .btn-prev {left:0; transform:scaleX(-1);}
.navigator .btn-next {right:0;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		prevButton:"#navigator .btn-prev",
		nextButton:"#navigator .btn-next"
	});
	$('.swiper-slide .coming').on('click', function(e){
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

			<li class="swiper-slide<% if vEventID = "100859" then %> current<% end if %>">
			<% If currentdate >= "2020-02-25" Then %>
				<a href="" onclick="goEventLink('100859'); return false;">01. Plande</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "101557" then %> current<% end if %>">
			<% If currentdate >= "2020-03-25" Then %>
				<a href="" onclick="goEventLink('101557'); return false;">02. OURS</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "102311" then %> current<% end if %>">
			<% If currentdate >= "2020-04-27" Then %>
				<a href="" onclick="goEventLink('102311'); return false;">03. 푸르름</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "103794" then %> current<% end if %>">
			<% If currentdate >= "2020-06-24" Then %>
				<a href="" onclick="goEventLink('103794'); return false;">04. 퍼디</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "104599" then %> current<% end if %>">
			<% If currentdate >= "2020-07-28" Then %>
				<a href="" onclick="goEventLink('104599'); return false;">05. 영이의 숲</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "106897" then %> current<% end if %>">
			<% If currentdate >= "2020-10-26" Then %>
				<a href="" onclick="goEventLink('106897'); return false;">06. 프롬하오팅</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "111652" then %> current<% end if %>">
			<% If currentdate >= "2021-06-02" Then %>
				<a href="" onclick="goEventLink('111652'); return false;">07. 어리틀페퍼</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "111975" then %> current<% end if %>">
			<% If currentdate >= "2021-06-18" Then %>
				<a href="" onclick="goEventLink('111975'); return false;">08. 레터에잇</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "112554" then %> current<% end if %>">
			<% If currentdate >= "2021-07-07" Then %>
				<a href="" onclick="goEventLink('112554'); return false;">09. 에구구</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide<% if vEventID = "113118" then %> current<% end if %>">
			<% If currentdate >= "2021-08-10" Then %>
				<a href="" onclick="goEventLink('113118'); return false;">10. 눈고</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">Coming<br>Soon</a>
			<% End If %>
			</li>

		</ul>
	</div>
	<button type="button" class="btn-prev">이전</button>
	<button type="button" class="btn-next">다음</button>
</div>