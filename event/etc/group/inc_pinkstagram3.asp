<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 핑크스타그램3
' History : 2019-01-22 김송이 생성
'####################################################
%><%
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
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)
	If vEventID = "91577" Then '// 1
		vStartNo = "0"
	ElseIf vEventID = "91599" Then '// 2
		vStartNo = "0"
	ElseIf vEventID = "92119" Then '// 3
		vStartNo = "1"
	ElseIf vEventID = "92264" Then '// 4
		vStartNo = "2"
	ElseIf vEventID = "92278" Then '// 5
		vStartNo = "3"
	ElseIf vEventID = "93294" Then '// 6
		vStartNo = "4"
	ElseIf vEventID = "93859" Then '// 7
		vStartNo = "5"
	ElseIf vEventID = "94060" Then '// 8
		vStartNo = "6"
	ElseIf vEventID = "94242" Then '// 9
		vStartNo = "7"
	ElseIf vEventID = "94257" Then '// 10
		vStartNo = "8"
	ElseIf vEventID = "94260" Then '// 11
		vStartNo = "9"
	ElseIf vEventID = "97760" Then '// 12
		vStartNo = "10"
	ElseIf vEventID = "98582" Then '// 13
		vStartNo = "11"
	ElseIf vEventID = "99547" Then '// 14
		vStartNo = "12"
	ElseIf vEventID = "99548" Then '// 15
		vStartNo = "13"
	ElseIf vEventID = "100079" Then '// 16
		vStartNo = "14"
	ElseIf vEventID = "101003" Then '// 17
		vStartNo = "15"
	ElseIf vEventID = "101457" Then '// 18
		vStartNo = "16"
	ElseIf vEventID = "101459" Then '// 19
		vStartNo = "17"
	ElseIf vEventID = "101776" Then '// 20
		vStartNo = "18"
	ElseIf vEventID = "105766" Then '// 21
		vStartNo = "19"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.pink-series {position:relative; margin:0 auto; text-align:center; background-color:#e13874;}
.pink-series li.swiper-slide {display:table; width:17.33%; height:4.3rem; color:#ed9aba;}
.pink-series li.swiper-slide:after, .pink-series li.swiper-slide:last-child:before {content:''; display:inline-block; position:absolute; top:50%; width:1.5px; height:1.8rem; margin-top:-0.9rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79789/m/bg_line.jpg) 0 50% no-repeat; background-size:100%;}
.pink-series li.swiper-slide:after {left:0;}
.pink-series li.swiper-slide:last-child:before {right:0;}
.pink-series li.swiper-slide a {display:table-cell; width:100%; height:100%; font-size:1.3rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; vertical-align:middle;}
.pink-series li.swiper-slide a span {display:none;}
.pink-series li.swiper-slide.on {width:60%; color:#fff;}
.pink-series li.swiper-slide.on a span {display:inline-block; margin-left:.85rem; font-size:1.2rem;}
</style>
</head>
<body>
<script type="text/javascript">
$(function(){
	pinkSwiper = new Swiper('.pink-series .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:'auto',
		speed:300
	});
	$('.pink-series .coming').on('click', function(e){
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
	<!-- nav -->
	<div class="pink-series">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<ul class="swiper-wrapper">
					<li class="swiper-slide<% if vEventID = "91577" then %> on<% end if %>">
						<a href="" onclick="goEventLink('91577'); return false;">01<span>로즈쿼츠 마사지기</span></a>
					</li>

					<li class="swiper-slide <% if vEventID = "91599" then %> on<% end if %>">
						<% If currentdate >= "2019-01-22" Then %>
							<a href="" onclick="goEventLink('91599'); return false;">02<span>핑크펜 시즌 2</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">02<span>핑크펜 시즌 2</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "92119" then %> on<% end if %>">
						<% If currentdate >= "2019-01-23" Then %>
							<a href="" onclick="goEventLink('92119'); return false;">03<span>마법진 고속 충전기</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">03<span>마법진 고속 충전기</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "92264" then %> on<% end if %>">
						<% If currentdate >= "2019-01-28" Then %>
							<a href="" onclick="goEventLink('92264'); return false;">04<span>메이드인 노스코리아 조선</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">04<span>메이드인 노스코리아 조선</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "92278" then %> on<% end if %>">
						<% If currentdate >= "2019-01-31" Then %>
							<a href="" onclick="goEventLink('92278'); return false;">05<span>핑크골드 쥬얼리보관함</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">05<span>핑크골드 쥬얼리보관함</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "93294" then %> on<% end if %>">
						<% If currentdate >= "2019-04-10" Then %>
							<a href="" onclick="goEventLink('93294'); return false;">06<span>핑크 티컵</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">06<span>핑크 티컵</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "93859" then %> on<% end if %>">
						<% If currentdate >= "2019-04-12" Then %>
							<a href="" onclick="goEventLink('93859'); return false;">07<span>핑크 박스파우치</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">07<span>핑크 박스파우치</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "94060" then %> on<% end if %>">
						<% If currentdate >= "2019-04-25" Then %>
							<a href="" onclick="goEventLink('94060'); return false;">08<span>핑크 커터</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">08<span>핑크 커터</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "94242" then %> on<% end if %>">
						<% If currentdate >= "2019-05-02" Then %>
							<a href="" onclick="goEventLink('94242'); return false;">09<span>핑크 몰랑 미니램프 방향제</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">09<span>핑크 몰랑 미니램프 방향제</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "94257" then %> on<% end if %>">
						<% If currentdate >= "2019-05-17" Then %>
							<a href="" onclick="goEventLink('94257'); return false;">10<span>Pink drink &amp; tea</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">10<span>Pink drink &amp; tea</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "94260" then %> on<% end if %>">
						<% If currentdate >= "2019-06-16" Then %>
							<a href="" onclick="goEventLink('94260'); return false;">11<span>핑크 조각 스티커</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">11<span>핑크 조각 스티커</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "97760" then %> on<% end if %>">
						<% If currentdate >= "2019-10-30" Then %>
							<a href="" onclick="goEventLink('97760'); return false;">12<span>핑크파레트</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">12<span>핑크파레트</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "98582" then %> on<% end if %>">
						<% If currentdate >= "2019-11-21" Then %>
							<a href="" onclick="goEventLink('98582'); return false;">13<span>핑크 수납 달력</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">13<span>핑크 수납 달력</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "99547" then %> on<% end if %>">
						<% If currentdate >= "2019-12-18" Then %>
							<a href="" onclick="goEventLink('99547'); return false;">14<span>핑크 양모 슬리퍼</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">14<span>핑크 양모 슬리퍼</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "99548" then %> on<% end if %>">
						<% If currentdate >= "2020-01-07" Then %>
							<a href="" onclick="goEventLink('99548'); return false;">15<span>핑크 씰</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">15<span>핑크 씰</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "100079" then %> on<% end if %>">
						<% If currentdate >= "2020-01-20" Then %>
							<a href="" onclick="goEventLink('100079'); return false;">16<span>디붐 DITOO 핑크</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">16<span>디붐 DITOO 핑크</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "101003" then %> on<% end if %>">
						<% If currentdate >= "2020-03-02" Then %>
							<a href="" onclick="goEventLink('101003'); return false;">17<span>핑크 클린 베어</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">17<span>핑크 클린 베어</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "101457" then %> on<% end if %>">
						<% If currentdate >= "2020-03-19" Then %>
							<a href="" onclick="goEventLink('101457'); return false;">18<span>수련 무릎마사지기</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">18<span>수련 무릎마사지기</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "101459" then %> on<% end if %>">
						<% If currentdate >= "2020-04-03" Then %>
							<a href="" onclick="goEventLink('101459'); return false;">19<span>핑크 핀셋</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">19<span>핑크 핀셋</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "101776" then %> on<% end if %>">
						<% If currentdate >= "2020-04-09" Then %>
							<a href="" onclick="goEventLink('101776'); return false;">20<span>에어팟 충전기</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">20<span>에어팟 충전기</span></a>
						<% end if %>
					</li>

					<li class="swiper-slide <% if vEventID = "105766" then %> on<% end if %>">
						<% If currentdate >= "2020-09-18" Then %>
							<a href="" onclick="goEventLink('105766'); return false;">21<span>슬라이드 지우개</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">21<span>슬라이드 지우개</span></a>
						<% end if %>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>