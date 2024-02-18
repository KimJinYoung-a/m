<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2015-03-09"
	
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
	If vEventID = "58894" Then
		vStartNo = "0"
	ElseIf vEventID = "59507" Then
		vStartNo = "1"
	ElseIf vEventID = "65318" Then
		vStartNo = "2"
	ElseIf vEventID = "61764" Then
		vStartNo = "3"
	ElseIf vEventID = "62769" Then
		vStartNo = "4"
	ElseIf vEventID = "63721" Then
		vStartNo = "5"
	ElseIf vEventID = "65128" Then
		vStartNo = "6"
	ElseIf vEventID = "65362" Then
		vStartNo = "7"
	ElseIf vEventID = "66270" Then
		vStartNo = "8"
	ElseIf vEventID = "66930" Then
		vStartNo = "9"
	ElseIf vEventID = "67355" Then
		vStartNo = "10"
	ElseIf vEventID = "68253" Then
		vStartNo = "11"
	ElseIf vEventID = "68775" Then
		vStartNo = "12"
	ElseIf vEventID = "69162" Then
		vStartNo = "13"
		ElseIf vEventID = "69681" Then
		vStartNo = "14"
	ElseIf vEventID = "69988" Then
		vStartNo = "15"
	ElseIf vEventID = "70547" Then
		vStartNo = "16"
	ElseIf vEventID = "71022" Then
		vStartNo = "17"
	ElseIf vEventID = "71877" Then
		vStartNo = "18"
	ElseIf vEventID = "72648" Then
		vStartNo = "19"
	ElseIf vEventID = "73120" Then
		vStartNo = "20"
	ElseIf vEventID = "73853" Then
		vStartNo = "21"
	ElseIf vEventID = "74031" Then
		vStartNo = "22"
	ElseIf vEventID = "74342" Then
		vStartNo = "23"
	ElseIf vEventID = "75401" Then
		vStartNo = "24"
	ElseIf vEventID = "78006" Then
		vStartNo = "25"
	ElseIf vEventID = "78457" Then
		vStartNo = "26"
	ElseIf vEventID = "79200" Then
		vStartNo = "27"
	ElseIf vEventID = "79652" Then
		vStartNo = "28"
	ElseIf vEventID = "80424" Then
		vStartNo = "29"
	ElseIf vEventID = "81419" Then
		vStartNo = "30"
	End IF
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.swiper {position:relative; height:58px;}
.swiper .swiper-slide {text-align:center;}
.swiper .swiper-slide a,
.swiper .swiper-slide span {display:block; width:70px; height:58px; padding:10px 0 34px; color:#737373; font-size:13px;}
.swiper .swiper-slide span {color:#ccc;}
.swiper .swiper-slide a.on {background:url(http://webimage.10x10.co.kr/eventIMG/2016/book/m/bg_nav_on.png) no-repeat 0 0; background-size:70px auto; color:#fed33d;}

@media all and (min-width:360px){
	.swiper .swiper-slide a,
	.swiper .swiper-slide span {font-size:14px;}
}

@media all and (min-width:480px){
	.swiper .swiper-slide a,
	.swiper .swiper-slide span {width:105px; height:87px; padding:15px 0 51px; font-size:19px;}
	.swiper .swiper-slide a.on {background-size:105px auto;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		centeredSlides:true,
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		spaceBetween:"2%"
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

// 이벤트 이동
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
	<div class="rolling">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<ul class="swiper-wrapper">
					<li class="swiper-slide swiper-slide-01">
						<a href="" onclick="goEventLink('58894');return false;" target="_top" <%=CHKIIF(vEventID="58894"," class='on'","")%>>1월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-02">
						<a href="" onclick="goEventLink('59507'); return false;" target="_top" <%=CHKIIF(vEventID="59507"," class='on'","")%>>2월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-03">
						<a href="" onclick="goEventLink('65318'); return false;" target="_top" <%=CHKIIF(vEventID="65318"," class='on'","")%>>3월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-04">
						<a href="" onclick="goEventLink('61764'); return false;" target="_top" <%=CHKIIF(vEventID="61764"," class='on'","")%>>4월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-05">
						<a href="" onclick="goEventLink('62769'); return false;" target="_top" <%=CHKIIF(vEventID="62769"," class='on'","")%>>5월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-06">
						<a href="" onclick="goEventLink('63721'); return false;" target="_top" <%=CHKIIF(vEventID="63721"," class='on'","")%>>6월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-07">
						<a href="" onclick="goEventLink('65128'); return false;" target="_top" <%=CHKIIF(vEventID="65128"," class='on'","")%>>7월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-08">
						<a href="" onclick="goEventLink('65362'); return false;" target="_top" <%=CHKIIF(vEventID="65362"," class='on'","")%>>8월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-09">
						<a href="" onclick="goEventLink('66270'); return false;" target="_top" <%=CHKIIF(vEventID="66270"," class='on'","")%>>9월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-10">
						<a href="" onclick="goEventLink('66930'); return false;" target="_top" <%=CHKIIF(vEventID="66930"," class='on'","")%>>10월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-11">
						<a href="" onclick="goEventLink('67355'); return false;" target="_top" <%=CHKIIF(vEventID="67355"," class='on'","")%>>11월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-12">
						<a href="" onclick="goEventLink('68253'); return false;" target="_top" <%=CHKIIF(vEventID="68253"," class='on'","")%>>12월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-13">
						<a href="" onclick="goEventLink('68775'); return false;" target="_top" <%=CHKIIF(vEventID="68775"," class='on'","")%>>1월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-14">
						<a href="" onclick="goEventLink('69162'); return false;" target="_top" <%=CHKIIF(vEventID="69162"," class='on'","")%>>2월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-15">
						<a href="" onclick="goEventLink('69681'); return false;" target="_top" <%=CHKIIF(vEventID="69681"," class='on'","")%>>3월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-16">
						<a href="" onclick="goEventLink('69988'); return false;" target="_top" <%=CHKIIF(vEventID="69988"," class='on'","")%>>4월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-17">
						<a href="" onclick="goEventLink('70547'); return false;" target="_top" <%=CHKIIF(vEventID="70547"," class='on'","")%> title="바닷마을 다이어리">5월의 책</a>
					</li>
					<li class="swiper-slide swiper-slide-18">
						<a href="" onclick="goEventLink('71022'); return false;" target="_top" <%=CHKIIF(vEventID="71022"," class='on'","")%> title="치킨의 50가지 그림자">6월의 책</a>
					</li>
					
					<% if currentdate < "2016-07-20" then %>
					<li class="swiper-slide swiper-slide-19">
						<span>7월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-19">
						<a href="" onclick="goEventLink('71877'); return false;" target="_top" <%=CHKIIF(vEventID="71877"," class='on'","")%> title="쓰담쓰담">7월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-08-31" then %>
					<li class="swiper-slide swiper-slide-20">
						<span>8월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-20">
						<a href="" onclick="goEventLink('72648'); return false;" target="_top" <%=CHKIIF(vEventID="72648"," class='on'","")%> title="라이언 맥긴리">8월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-09-21" then %>
					<li class="swiper-slide swiper-slide-21">
						<span>9월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-20">
						<a href="" onclick="goEventLink('73120'); return false;" target="_top" <%=CHKIIF(vEventID="73120"," class='on'","")%> title="너의 속이 궁금해">9월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-10-26" then %>
					<li class="swiper-slide swiper-slide-22">
						<span>10월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-22">
						<a href="" onclick="goEventLink('73853'); return false;" target="_top" <%=CHKIIF(vEventID="73853"," class='on'","")%> title="어바웃 해피니스">10월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-11-09" then %>
					<li class="swiper-slide swiper-slide-23">
						<span>11월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-23">
						<a href="" onclick="goEventLink('74031'); return false;" target="_top" <%=CHKIIF(vEventID="74031"," class='on'","")%> title="구름 껴도 맑음">11월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-12-01" then %>
					<li class="swiper-slide swiper-slide-24">
						<span>12월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-24">
						<a href="" onclick="goEventLink('74342'); return false;" target="_top" <%=CHKIIF(vEventID="74342"," class='on'","")%> title="VOICE">12월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-01-11" then %>
					<li class="swiper-slide swiper-slide-25">
						<span>1월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-25">
						<a href="" onclick="goEventLink('75401'); return false;" target="_top" <%=CHKIIF(vEventID="75401"," class='on'","")%> title="실어증입니다, 일하기싫어증">1월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-05-24" then %>
					<li class="swiper-slide swiper-slide-26">
						<span>1월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-26">
						<a href="" onclick="goEventLink('78006'); return false;" target="_top" <%=CHKIIF(vEventID="78006"," class='on'","")%> title="당신이 사랑하는 순간">5월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-06-21" then %>
					<li class="swiper-slide swiper-slide-27">
						<span>6월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-27">
						<a href="" onclick="goEventLink('78457'); return false;" target="_top" <%=CHKIIF(vEventID="78457"," class='on'","")%> title="편하고 사랑스럽고 그래">6월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-07-26" then %>
					<li class="swiper-slide swiper-slide-28">
						<span>7월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-28">
						<a href="" onclick="goEventLink('79200'); return false;" target="_top" <%=CHKIIF(vEventID="79200"," class='on'","")%> title="프리다칼로">7월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-08-09" then %>
					<li class="swiper-slide swiper-slide-29">
						<span>8월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-29">
						<a href="" onclick="goEventLink('79652'); return false;" target="_top" <%=CHKIIF(vEventID="79652"," class='on'","")%> title="시바견곤이야기">8월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-09-12" then %>
					<li class="swiper-slide swiper-slide-30">
						<span>9월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-30">
						<a href="" onclick="goEventLink('80424'); return false;" target="_top" <%=CHKIIF(vEventID="80424"," class='on'","")%> title="책바게트">9월의 책</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-10-26" then %>
					<li class="swiper-slide swiper-slide-314">
						<span>10월의 책</span>
					</li>
					<% Else %>
					<li class="swiper-slide swiper-slide-31">
						<a href="" onclick="goEventLink('81419'); return false;" target="_top" <%=CHKIIF(vEventID="81419"," class='on'","")%> title="머무르는 말들">10월의 책</a>
					</li>
					<% End If %>

					<li class="swiper-slide swiper-slide-32">
						<span>11월의 책</span>
					</li>

					<li class="swiper-slide swiper-slide-33">
						<span>12월의 책</span>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>