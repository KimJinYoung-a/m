<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : play 스물다섯 번째 이야기 TOY
' History : 2015.10.15 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #10/24/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64932
Else
	eCode   =  66802
End If

dim userid, i
	userid = GetEncLoginUserID()

dim subscriptexistscount, totsubscriptexistscount1, totsubscriptexistscount2, totsubscriptexistscount3, totsubscriptexistscount4, totsubscriptexistscount5
	subscriptexistscount=0
	totsubscriptexistscount1=0
	totsubscriptexistscount2=0
	totsubscriptexistscount3=0
	totsubscriptexistscount4=0
	totsubscriptexistscount5=0

if userid<>"" then
	subscriptexistscount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

totsubscriptexistscount1 = getevent_subscripttotalcount(eCode, "", "1", "")
totsubscriptexistscount2 = getevent_subscripttotalcount(eCode, "", "2", "")
totsubscriptexistscount3 = getevent_subscripttotalcount(eCode, "", "3", "")
totsubscriptexistscount4 = getevent_subscripttotalcount(eCode, "", "4", "")
totsubscriptexistscount5 = getevent_subscripttotalcount(eCode, "", "5", "")
%>

<link rel="stylesheet" type="text/css" href="/lib/css/preVst/section.css" />
<link rel="stylesheet" type="text/css" href="/lib/css/sectionV15.css" />
<style type="text/css">
img {vertical-align:top;}
.playEvent {background:#f0efe7 url(http://webimage.10x10.co.kr/playmo/ground/20151019/bg_gray.gif) 0 100% no-repeat; background-size:100% auto;}
.playEvent .toyCont {padding:0 4% 9%;}
.selectDoll ul {overflow:hidden; padding-bottom:10px;}
.selectDoll li {position:relative; float:left; width:33.33333%; margin-bottom:15px; text-align:center; font-size:11px; letter-spacing:-0.045em; color:#888;}
.selectDoll li:nth-child(4) {margin-left:16.5%;}
.selectDoll li input {position:absolute; left:50%; top:73.6%; border-radius:50%; width:10px; height:10px; margin-left:-5px;}
.selectDoll li:last-child input {top:74.6%;}
.selectDoll li .count {line-height:1.2;}
.selectDoll li .count strong {position:relative; top:1px; font-size:13px; color:#000; padding-right:2px;}
.selectDoll .btnCheer {display:block; width:45%; margin:0 auto;}
.navWrap {position:relative;}
.article {position:relative;}
.article a {display:inline-block; position:absolute; left:0; top:0; width:100%; height:50%; background:rgba(0,0,0,0);}
.bPagination {overflow:hidden; position:absolute; left:10%; top:8%; width:80%; }
.bPagination li {float:left; width:50%;cursor:pointer; }
.bPagination li a {display:block; width:100%; height:100%; background-position:0 0; background-repeat:no-repeat; background-size:200% auto;}
.bPagination li a.on {background-position:100% 0;}
.bPagination li:nth-child(1) {margin-left:50%; }
.bPagination li:nth-child(1) a {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151019/img_no1.jpg);}
.bPagination li:nth-child(2) a {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151019/img_no2.jpg);}
.bPagination li:nth-child(3) a {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151019/img_no3.jpg);}
.bPagination li:nth-child(4) a {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151019/img_no4.jpg);}
.bPagination li:nth-child(5) a {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151019/img_no5.jpg);}
.movieWrap {padding:0 15%; background:url(http://webimage.10x10.co.kr/playmo/ground/20151019/bg_movie.png) 0 0 no-repeat; background-size:100% 100%;}
.movie {overflow:hidden; position:relative; z-index:5; height:0; padding-bottom:56.25%;}
.movie iframe {position:absolute; top:0; left:0; width:100%; height:100%; vertical-align:top;}
</style>
<script type="text/javascript">
$(function(){
	$(".article").hide();
	$("#cont1").show();
	$("#navigator li a").click(function(){
		$("#navigator li a").removeClass('on');
		$(this).addClass('on');
		var thisCont = $(this).attr("href");
		$("#contview").find(".article").hide();
		$("#contview").find(thisCont).show();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
	});
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}
});

function gojoin(){
	<% If IsUserLoginOK Then %>
		<% if not( left(currenttime,10)>="2015-10-19" and left(currenttime,10)<"2015-10-29" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptexistscount > 4 then %>
				alert('이벤트는 5회까지 참여 가능 합니다.');
				return false;
			<% else %>
				var tmpgubunval ='';
				for(var i=0; i < frmcom.gubunval.length; i++){
					if (frmcom.gubunval[i].checked){
						tmpgubunval = frmcom.gubunval[i].value;
					}
				}
				if (tmpgubunval==''){
					alert('원하는 것을 선택해 주세요.');
					return false;
				}
				gubunval=tmpgubunval;

				var rstStr = $.ajax({
					type: "POST",
					url: "/play/groundcnt/doEventSubscript66802.asp",
					data: "mode=add&isApp=<%=isApp%>&gubunval="+gubunval,
					dataType: "text",
					async: false
				}).responseText;
				//alert(rstStr);
				if (rstStr == "SUCCESS"){
					alert('감사합니다. 참여가 완료 되었습니다!');
					location.reload();
					return false;
				}else if (rstStr == "USERNOT"){
					alert('로그인을 해주세요.');
					return false;
				}else if (rstStr == "DATENOT"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else if (rstStr == "END"){
					alert('이벤트는 5회까지 참여 가능 합니다.');
					return false;
				}else if (rstStr == "NOTVAL"){
					alert('원하는 것을 선택해 주세요.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			calllogin();
			return;
		<% else %>
			jsevtlogin();
			return;
		<% End If %>
	<% end if %>
}
</script>
<div class="mPlay20151019">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/tit_dolldolldoll.jpg" alt="돌돌DOLL" /></h2>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/txt_purpose.gif" alt="텐바이텐배 토이 레이스!" /></p>
	<div class="navWrap">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/tit_introduce.png" alt="선수소개" /></p>
		<ul id="navigator" class="bPagination">
			<li><a href="#cont1"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/bg_blank.png" alt="" /></a></li>
			<li><a href="#cont2"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/bg_blank.png" alt="" /></a></li>
			<li><a href="#cont3"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/bg_blank.png" alt="" /></a></li>
			<li><a href="#cont4"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/bg_blank.png" alt="" /></a></li>
			<li><a href="#cont5"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/bg_blank.png" alt="" /></a></li>
		</ul>
	</div>
	<div id="contview" class="contview">
		<div id="cont1" class="article">
			<a href="/category/category_itemprd.asp?itemid=1283470" class="mw"></a>
			<a href="#" onclick="fnAPPpopupProduct('1283470'); return false;" class="ma"></a>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy01.jpg" alt="" />
		</div>
		<div id="cont2" class="article">
			<a href="/category/category_itemprd.asp?itemid=1283472" class="mw"></a>
			<a href="#"  onclick="fnAPPpopupProduct('1283472'); return false;" class="ma"></a>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy02.jpg" alt="" />
		</div>
		<div id="cont3" class="article">
			<a href="/category/category_itemprd.asp?itemid=1283469" class="mw"></a>
			<a href="#"  onclick="fnAPPpopupProduct('1283469'); return false;" class="ma"></a>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy03.jpg" alt="" />
		</div>
		<div id="cont4" class="article">
			<a href="/category/category_itemprd.asp?itemid=1283464" class="mw"></a>
			<a href="#"  onclick="fnAPPpopupProduct('1283464'); return false;" class="ma"></a>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy04.jpg" alt="" />
		</div>
		<div id="cont5" class="article">
			<a href="/category/category_itemprd.asp?itemid=1283473" class="mw"></a>
			<a href="#"  onclick="fnAPPpopupProduct('1283473'); return false;" class="ma"></a>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy05.jpg" alt="" />
		</div>
	</div>
	<div class="swiperWrap" style="display:none">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_player.jpg" alt="" /></p>
		<div class="bPagination"></div>
		<div class="swiper" id="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<% If isapp = "1" Then %>
						<a href="#" onclick="fnAPPpopupProduct('1283470'); return false;" class="ma"></a>
						<% Else %>
						<a href="/category/category_itemprd.asp?itemid=1283470" class="mw"></a>
						<% End If %>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy01.jpg" alt="" />
					</div>
					<div class="swiper-slide">
						<% If isapp = "1" Then %>
						<a href="#"  onclick="fnAPPpopupProduct('1283472'); return false;" class="ma"></a>
						<% Else %>
						<a href="/category/category_itemprd.asp?itemid=1283472" class="mw"></a>
						<% End If %>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy02.jpg" alt="" />
					</div>
					<div class="swiper-slide">
						<% If isapp = "1" Then %>
						<a href="#"  onclick="fnAPPpopupProduct('1283469'); return false;" class="ma"></a>
						<% Else %>
						<a href="/category/category_itemprd.asp?itemid=1283469" class="mw"></a>
						<% End If %>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy03.jpg" alt="" />
					</div>
					<div class="swiper-slide">
						<% If isapp = "1" Then %>
						<a href="#"  onclick="fnAPPpopupProduct('1283464'); return false;" class="ma"></a>
						<% Else %>
						<a href="/category/category_itemprd.asp?itemid=1283464" class="mw"></a>
						<% End If %>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy04.jpg" alt="" />
					</div>
					<div class="swiper-slide">
						<% If isapp = "1" Then %>
						<a href="#"  onclick="fnAPPpopupProduct('1283473'); return false;" class="ma"></a>
						<% Else %>
						<a href="/category/category_itemprd.asp?itemid=1283473" class="mw"></a>
						<% End If %>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_toy05.jpg" alt="" />
					</div>
				</div>
			</div>
		</div>
	</div>
	<form name="frmcom" method="get" onSubmit="return false;" style="margin:0px;">
	<div class="playEvent">
		<h4><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/txt_event_v2.gif" alt="누가 누가 이길까! 1등을 예상해보세요!!" /></h4>
		<div class="package"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_doll_set.jpg" alt="" /></div>
		<div class="toyCont">
			<div class="selectDoll">
				<ul>
					<li>
						<label for="player01"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_player01.jpg" alt="선수1:설리" /></label>
						<input type="radio" name="gubunval" value="1" id="player01" />
						<p class="count"><strong><%= totsubscriptexistscount1 %></strong>명이<br /> 응원 중입니다</p>
					</li>
					<li>
						<label for="player02"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_player02.jpg" alt="선수2:마이크" /></label>
						<input type="radio" name="gubunval" value="2" id="player02" />
						<p class="count"><strong><%= totsubscriptexistscount2 %></strong>명이<br /> 응원 중입니다</p>
					</li>
					<li>
						<label for="player03"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_player03.jpg" alt="선수3:라이트닝맥퀸" /></label>
						<input type="radio" name="gubunval" value="3" id="player03" />
						<p class="count"><strong><%= totsubscriptexistscount3 %></strong>명이<br /> 응원 중입니다</p>
					</li>
					<li>
						<label for="player04"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_player04.jpg" alt="선수4:우디" /></label>
						<input type="radio" name="gubunval" value="4" id="player04" />
						<p class="count"><strong><%= totsubscriptexistscount4 %></strong>명이<br /> 응원 중입니다</p>
					</li>
					<li>
						<label for="player05"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/img_player05.jpg" alt="선수5:니모" /></label>
						<input type="radio" name="gubunval" value="5" id="player05" />
						<p class="count"><strong><%= totsubscriptexistscount5 %></strong>명이<br /> 응원 중입니다</p>
					</li>
				</ul>
				<input type="image" onclick="gojoin(); return false;" src="http://webimage.10x10.co.kr/playmo/ground/20151019/btn_cheer.png" alt="응원하기" class="btnCheer" />
			</div>
		</div>
	</div>
	</form>

	<% if left(currenttime,10) > "2015-10-23" then %>
		<% '<!-- 24일부터 커밍순대신 이걸로↓ --> %>
		<div class="raceResult">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/tit_winner.png" alt="텐바이텐배 태엽토이 레이스 우승자를 공개합니다!" /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/tit_movie.png" alt="우승영상보기" /></p>
			<div class="movieWrap">
				<div class="movie">
					<iframe src="//player.vimeo.com/video/143346064?loop=1;" frameborder="0" title="" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>
				</div>
			</div>
			<div class="winnerIs"><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/winner.gif" alt="라이트닝 맥퀸" /></div>
		</div>
	<% else %>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151019/txt_coming_soon_v2.gif" alt="레이스 결과를 기대해주세요!! 10월 30일, 플레이 페이지에서 발표됩니다." /></p>
	<% end if %>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->