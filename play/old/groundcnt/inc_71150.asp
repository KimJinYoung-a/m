<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 31-1 M/A 찰떡식물
' History : 2016-06-03 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid , strSql , pagereload , totcnt, suncnt, sansecnt, hubcnt, maricnt
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66145
Else
	eCode   =  71150
End If

	'// 총 참여수를 가져온다.
	strSql = "select "
	strSql = strSql & " count(*) "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
	strSql = strSql & "	where evt_code = '"& eCode &"' " 
	rsget.Open strSql,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()

	'// 각 항목별 참여수를 가져온다.
	'// 1-선인장, 2-산세베리아, 3-허브, 4-마리모
	strSql = "select "
	strSql = strSql & " count(*) "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
	strSql = strSql & "	where evt_code = '"& eCode &"' And sub_opt2=1 " 
	rsget.Open strSql,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		suncnt = rsget(0)
	End IF
	rsget.close()

	strSql = "select "
	strSql = strSql & " count(*) "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
	strSql = strSql & "	where evt_code = '"& eCode &"' And sub_opt2=2 " 
	rsget.Open strSql,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		sansecnt = rsget(0)
	End IF
	rsget.close()

	strSql = "select "
	strSql = strSql & " count(*) "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
	strSql = strSql & "	where evt_code = '"& eCode &"' And sub_opt2=3 " 
	rsget.Open strSql,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		hubcnt = rsget(0)
	End IF
	rsget.close()

	strSql = "select "
	strSql = strSql & " count(*) "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
	strSql = strSql & "	where evt_code = '"& eCode &"' And sub_opt2=4 " 
	rsget.Open strSql,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		maricnt = rsget(0)
	End IF
	rsget.close()

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐]식물에 물 주고 찰떡 식물 알아보기!")
snpLink = Server.URLEncode("http://m.10x10.co.kr/play/playGround.asp?idx=1399&contentsidx=126")
snpPre = Server.URLEncode("텐바이텐")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#텐바이텐 #10x10 #찰떡식물")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐]너와 나의 찰떡 식물!\n\n식물에 물주고 찰떡 식물 알아보기!\n식물에게도 찰떡궁합이 있다는 걸 아시나요?\n\n나의 하루의 이야기로 한 방울씩\n물을 조합하세요.\n그에 어울리는 식물을 찾아드립니다.\n\n나의 찰떡식물을 찾고 물을 주세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/71150/71150kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1399&contentsidx=126"
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1399&contentsidx=126"
	end If
	
%>
<style type="text/css">
img {vertical-align:top;}
.mPlay20160606 {-webkit-text-size-adjust:none;}
.intro {position:relative;}
.intro h2 {position:absolute; left:34.0625%; top:15.14%; width:31.5625%; height:22.6125%;}
.intro h2 span {display:inline-block; position:absolute; width:50%; height:50%;}
.intro h2 .letter01 {left:0; top:0;}
.intro h2 .letter02 {right:0; top:0;}
.intro h2 .letter03 {left:0; bottom:0;}
.intro h2 .letter04 {right:0; bottom:0;}
.intro .deco {position:absolute; left:50%; top:42.6%; width:3.75%; margin-left:-1.875%;}
.intro .feat {position:absolute;  left:50%; top:50%; width:21.56%; margin-left:-10.78%;}
.drink {position:relative; text-align:center; font-size:1.7rem; line-height:1.1; color:#fff;}
.drink .typing {position:absolute; left:0; width:100%;}
.drink .typing.t01 {top:33.6%;}
.drink .typing.t02 {top:53.18%;}
.purpose {position:relative;}
.purpose .btnFind {overflow:hidden; position:absolute; left:50%; bottom:5.3%; width:26%; margin-left:-13%; border-radius:50%;}
.purpose .btnFind img {border-radius:50%;}
.othersPlant {text-align:center; background:#fff;}
.othersPlant h3 {position:relative;}
.othersPlant h3:after {content:''; display:inline-block; position:absolute; left:50%; bottom:-0.8rem; z-index:30; width:1.2rem; height:0.8rem; margin-left:-0.6rem; background:url(http://webimage.10x10.co.kr/playmo/ground/20160606/bg_triangle.png) no-repeat 0 0; background-size:100% 100%;}
.othersPlant ul {overflow:hidden;}
.othersPlant li {position:relative; float:left; width:50%; color:#ec5439;}
.othersPlant li:nth-child(2),
.othersPlant li:nth-child(3) {color:#60782b;}
.othersPlant li p {position:absolute; left:0; top:16%; width:100%; font-size:1.2rem; font-weight:600;}
.othersPlant li p em {display:block; padding-bottom:0.6rem; font-size:1.4rem; font-weight:bold;}
.othersPlant .total {padding:2rem 0 1.8rem; color:#fff; font-size:1.2rem; font-weight:600; background:#4b4b4b;}
.othersPlant .total strong {font-size:1.3rem;}
.shareSns {position:relative;}
.shareSns a {display:block; position:absolute; top:20%; width:18%; height:62%; text-indent:-9999em;}
.shareSns a.btnFacebook {right:27.5%;}
.shareSns a.btnKakaotalk {right:7.5%;}
.findMyPlant .section {position:relative; display:none;}
.findMyPlant .question01 {display:block;}
.question .txt {position:absolute; left:0; top:50%; width:100%;}
.question .waterdrop {position:absolute; left:50%; top:65%; width:82%; height:23%; padding-top:2rem; margin-left:-41%; text-align:center; background:rgba(255,255,255,.7); box-shadow:0.5rem 0.5rem 0.8rem 0.3rem rgba(49,41,41,.05);}
.question .waterdrop .number {padding-bottom:1.8rem; font-size:1.5rem; font-weight:600; color:#797877;}
.question .waterdrop .number span {color:#2ed5c8;}
.question .waterdrop .selectDrop {position:relative; overflow:hidden; width:21rem; height:3rem; margin:0 auto;}
.question .waterdrop .selectDrop span {display:inline-block; float:left; width:2.2rem; height:3rem; margin:0 1rem; cursor:pointer; background:url(http://webimage.10x10.co.kr/playmo/ground/20160606/bg_water_off.png) no-repeat 0 0; background-size:2.17rem auto;} 
.question .waterdrop .selectDrop span.on {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160606/bg_water_on.png);}
.question .btnNext {overflow:hidden; position:absolute; left:50%; top:83%; width:16%; margin-left:-8%; background:transparent;}
.question .btnNext img {border-radius:50%;}
.question01 .selectWrap {position:relative; width:21rem; margin:0 auto;}
.question01 .deco {position:absolute; left:0; top:0; width:100%; height:3rem; background:#fdfdfe url(http://webimage.10x10.co.kr/playmo/ground/20160606/img_drop_off.png) no-repeat 0 0; background-size:100% auto;}
.question01 .deco span {display:block; position:absolute; left:0; top:0; width:0; height:3em; background:url(http://webimage.10x10.co.kr/playmo/ground/20160606/img_drop_on.png) no-repeat 0 0; background-size:21rem auto;}
.question03 .btnNext {top:82%; width:22%; margin-left:-11%;}
.result > div {position:relative;}
.result > div a {display:block; position:absolute; width:58%; height:43%; background:transparent; text-indent:-999em;}
.result .result01 a {left:5.6%; top:41%;}
.result .result02 a {left:20%; top:34%; height:51%;}
.result .result03 a {left:34%; top:33%;}
.result .result04 a {left:21%; top:38%; width:62%;}
.result .btnAgain {position:absolute; left:4.68%; bottom:4%; z-index:30; width:16%;}
.play span {animation-name:flex; animation-iteration-count:1; animation-duration:1.7s; -webkit-animation-name:flex; -webkit-animation-iteration-count:1; -webkit-animation-duration:1.7s; }
@-webkit-keyframes flex {
	0% {width:0;}
	50% {width:21rem;}
	100% {width:0;}
}
</style>
<script type="text/javascript">
$(function(){
	// waterdrop
	$('.question01 .selectDrop span').each(function(index){
		$(this).on('click', function(){
			<% if Not(IsUserLoginOK) then %>
				<% if isApp=1 then %>
					calllogin();
					return false;
				<% else %>
					parent.jsevtlogin();
					return false;
				<% end if %>
				return false;
			<% end if %>
			<% if not(left(now(), 10)>="2016-06-03" And left(now(), 10) < "2016-09-01") then %>
				alert("응모 기간이 아닙니다.");
				return false;
			<% end if %>
			$('.question01 .selectDrop span').addClass('on');
			$('.question01 .selectDrop span:gt('+index+')').removeClass('on');
			var rate1 = index+1; //클릭한 물방울 갯수
			$(".question01 .number strong").text(rate1)
			return false;
		});
	});
	$('.question02 .selectDrop span').each(function(index){
		$(this).on('click', function(){
			<% if Not(IsUserLoginOK) then %>
				<% if isApp=1 then %>
					calllogin();
					return false;
				<% else %>
					parent.jsevtlogin();
					return false;
				<% end if %>
				return false;
			<% end if %>
			<% if not(left(now(), 10)>="2016-06-03" And left(now(), 10) < "2016-09-01") then %>
				alert("응모 기간이 아닙니다.");
				return false;
			<% end if %>
			$('.question02 .selectDrop span').addClass('on');
			$('.question02 .selectDrop span:gt('+index+')').removeClass('on');
			var rate2 = index+1; //클릭한 물방울 갯수
			$(".question02 .number strong").text(rate2)
			return false;
		});
	});
	$('.question03 .selectDrop span').each(function(index){
		$(this).on('click', function(){
			<% if Not(IsUserLoginOK) then %>
				<% if isApp=1 then %>
					calllogin();
					return false;
				<% else %>
					parent.jsevtlogin();
					return false;
				<% end if %>
				return false;
			<% end if %>
			<% if not(left(now(), 10)>="2016-06-03" And left(now(), 10) < "2016-09-01") then %>
				alert("응모 기간이 아닙니다.");
				return false;
			<% end if %>
			$('.question03 .selectDrop span').addClass('on');
			$('.question03 .selectDrop span:gt('+index+')').removeClass('on');
			var rate3 = index+1; //클릭한 물방울 갯수
			$(".question03 .number strong").text(rate3)
			$("#qAnswer").val(rate3);
			return false;
		});
	});

	$(".intro h2 .letter01").css({"margin-top":"-10px","margin-left":"-10px","opacity":"0"});
	$(".intro h2 .letter02").css({"margin-top":"-10px","margin-right":"-10px","opacity":"0"});
	$(".intro h2 .letter03").css({"margin-bottom":"-10px","margin-left":"-10px","opacity":"0"});
	$(".intro h2 .letter04").css({"margin-bottom":"-10px","margin-right":"-10px","opacity":"0"});
	$(".intro .deco").css({"margin-top":"-10px","opacity":"0"});
	$(".intro .feat").css({"opacity":"0"});
	function titleAnimation() {
		$(".intro h2 span").delay(100).animate({"margin-left":"0","margin-right":"0","margin-top":"0","opacity":"1"},800);
		$(".intro .deco").delay(700).animate({"margin-top":"5px","opacity":"1"},600).animate({"margin-top":"0"},300);
		$(".intro .feat").delay(700).animate({"opacity":"1"},600);
	}

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".ma").show();
			$(".mw").hide();
	}else{
			$(".ma").hide();
			$(".mw").show();
	}

	$(".findMyPlant .section").hide();
	$(".findMyPlant .section:first").show();
	$(".question .btnNext").click(function(){
		<% if Not(IsUserLoginOK) then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				parent.jsevtlogin();
				return false;
			<% end if %>
			return false;
		<% end if %>
		<% if not(left(now(), 10)>="2016-06-03" And left(now(), 10) < "2016-09-01") then %>
			alert("응모 기간이 아닙니다.");
			return false;
		<% end if %>
		$(".findMyPlant .section").hide();
		$(this).parent(".section").next().show();
	});

	$(".result .btnAgain").click(function(){
		$(".findMyPlant .section").hide();
		$(".findMyPlant .section:first").show();
		$(".selectDrop span").removeClass("on");
		$(".selectDrop span:first-child").addClass("on");
		$(".question .number strong").text("1");
		$(".result01").hide();
		$(".result02").hide();
		$(".result03").hide();
		$(".result04").hide();
		$("#qAnswer").val('1');
	});

	$(".btnFind").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(".findMyPlant").offset().top},500);
	});
	titleAnimation()
	var conChk = 0;
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 300 ) {
			if (conChk==0){ 
				drinkTyping()
			}
		}
		if (scrollTop > 1300 ) {
			$('.question01 .deco').addClass("play").delay(1700).fadeOut(2);
		}
	});

	//drink
	function changeText(cont1,cont2,speed){
		var Otext=cont1.text();
		var Ocontent=Otext.split("");
		var i=0;
		function show(){
			if(i<Ocontent.length){
				cont2.append(Ocontent[i]);
				i=i+1;
			};
		};
		var typing=setInterval(show,speed);
	};
	function drinkTyping() {
		conChk = 1;
		changeText($(".t01 p"),$(".t01 .copy"),120);
		setTimeout(function(){
			changeText($(".t02 p"),$(".t02 .copy"),120);
		},1000);
		clearInterval(typing);
		return false;
	}
});

function goPlants()
{
	<% if Not(IsUserLoginOK) then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			parent.jsevtlogin();
			return false;
		<% end if %>
		return false;
	<% end if %>
	<% if not(left(now(), 10)>="2016-06-03" And left(now(), 10) < "2016-09-01") then %>
		alert("응모 기간이 아닙니다.");
		return false;
	<% end if %>
	

	$.ajax({
		type:"GET",
		url:"/play/groundcnt/doEventSubscript71150.asp",
		data: $("#frmSbS").serialize(),
		dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
			if (jqXHR.readyState == 4) {
				if (jqXHR.status == 200) {
					if(Data!="") {
						var str;
						for(var i in Data)
						{
							 if(Data.hasOwnProperty(i))
							{
								str += Data[i];
							}
						}
						str = str.replace("undefined","");
						res = str.split("|");
						if (res[0]=="OK")
						{
							$('.result0'+res[1]).show();
							$("#sun").empty().html(res[2]);
							$("#sanse").empty().html(res[3]);
							$("#hub").empty().html(res[4]);
							$("#mari").empty().html(res[5]);
							$("#totalcnt").empty().html(res[6]);
							window.parent.$('html,body').animate({scrollTop:$(".findMyPlant").offset().top},500);
						}
						else
						{
							errorMsg = res[1].replace(">?n", "\n");
							alert(errorMsg );
							parent.location.reload();
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						parent.location.reload();
						return false;
					}
				}
			}
		},
		error:function(jqXHR, textStatus, errorThrown){
			alert("잘못된 접근 입니다.");
			var str;
			for(var i in jqXHR)
			{
				 if(jqXHR.hasOwnProperty(i))
				{
					str += jqXHR[i];
				}
			}
			alert(str);
			parent.location.reload();
			return false;
		}
	});
}

</script>
<div class="mPlay20160606">
	<article>
		<div class="intro">
			<h2>
				<span class="letter01"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/tit_plant_01.png" alt="찰" /></span>
				<span class="letter02"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/tit_plant_02.png" alt="떡" /></span>
				<span class="letter03"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/tit_plant_03.png" alt="식" /></span>
				<span class="letter04"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/tit_plant_04.png" alt="물" /></span>
			</h2>
			<span class="deco"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/bg_drop.png" alt="" /></span>
			<p class="feat"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/txt_feat.png" alt="feat.water" /></p>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_intro.jpg" alt="" /></div>
		</div>
		<div class="drink">
			<div class="typing t01">
				<p style="display:none;">여러분은 물을</p>
				<p class="copy"></p>
			</div>
			<div class="typing t02">
				<p style="display:none;">얼마나 마시나요?</p>
				<p class="copy"></p>
			</div>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/bg_drink.png" alt="" /></div>
		</div>
		<div class="purpose">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/txt_purpose.jpg" alt="WATER &amp; PLANT - 우리에게 일상의 휴식과 같은 물은 식물에게는 따뜻한 관심이자 전부이기도 합니다. 이번주 PLAY에서는 서로 없어서는 안될 존재, 물과 식물에 대해 이야기하려고 합니다. 나의 하루의 이야기로 한 방울씩 물을 조합하세요, 그에 어울리는 식물을 찾아드립니다!" /></p>
			<button type="button" class="btnFind btnGo"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/btn_find.gif" alt="찰떡식물 찾아보기" /></button>
		</div>

		<%' 나에게 맞는 식물찾기 %>
		<div id="findMyPlant" class="findMyPlant">
			
			<%' q1 %>
			<div class="section question question01">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/txt_question_01.png" alt="01.오늘 하루, 바쁜 일상 속 하늘을 몇 번이나 올려다 보았나요?" /></p>
				<div class="waterdrop">
					<p class="number">아침 햇살 <span><strong>1</strong>방울</span></p>
					<div class="selectWrap">
						<div class="selectDrop">
							<span class="on"></span>
							<span></span>
							<span></span>
							<span></span>
							<span></span>
						</div>
						<div class="deco"><span></span></div>
					</div>
				</div>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/btn_next.gif" alt="다음" /></button>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/bg_question_01.jpg" alt="" /></div>
			</div>

			<%' q2 %>
			<div class="section question question02">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/txt_question_02.png" alt="02.오늘 하루, 만났던 사람들에게 따뜻한 한마디를 얼마나 건넸나요?" /></p>
				<div class="waterdrop">
					<p class="number">다정한 관심 <span><strong>1</strong>방울</span></p>
					<div class="selectDrop">
						<span class="on"></span>
						<span></span>
						<span></span>
						<span></span>
						<span></span>
					</div>
				</div>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/btn_next.gif" alt="다음" /></button>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/bg_question_02.jpg" alt="" /></div>
			</div>

			<%' q3 %>
			<div class="section question question03">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/txt_question_03.png" alt="" /></p>
				<div class="waterdrop">
					<p class="number">시원한 물 <span><strong>1</strong>방울</span></p>
					<div class="selectDrop">
						<span class="on"></span>
						<span></span>
						<span></span>
						<span></span>
						<span></span>
					</div>
				</div>
				<button type="button" class="btnNext btnGo" onclick="goPlants();return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/btn_result.png" alt="결과보기" /></button>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/bg_question_03.jpg" alt="" /></div>
			</div>

			<%' 결과 %>
			<div class="section result">
				<%' 선인장 %>
				<div class="result01" style="display:none">
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_result_cactus.jpg" alt="나의 찰떡식물 선인장" /></div>
					<a href="/event/eventmain.asp?eventid=71150#group180737" class="mw">선인장 상품 더보기</a>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71150#group180737" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71150#group180737');" class="ma">선인장 상품 더보기</a>
				</div>

				<%' 산세베리아 %>
				<div class="result02" style="display:none">
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_result_sansevieria.jpg" alt="나의 찰떡식물 산세베리아" /></div>
					<a href="/event/eventmain.asp?eventid=71150#group180738" class="mw">산세베리아 상품 더보기</a>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71150#group180738" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71150#group180738');" class="ma">산세베리아 상품 더보기</a>
				</div>

				<%' 마리모 %>
				<div class="result03" style="display:none">
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_result_marimo.jpg" alt="나의 찰떡식물 마리모" /></div>
					<a href="/event/eventmain.asp?eventid=71150#group180738" class="mw">마리모 상품 더보기</a>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71150#group180739" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71150#group180739');" class="ma">마리모 상품 더보기</a>
				</div>

				<%' 허브 %>
				<div class="result04" style="display:none">
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_result_herb.jpg" alt="나의 찰떡식물 허브" /></div>
					<a href="/event/eventmain.asp?eventid=71150#group180740" class="mw">허브 상품 더보기</a>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71150#group180740" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71150#group180740');" class="ma">허브 상품 더보기</a>
				</div>

				<a href="#findMyPlant" class="btnAgain btnGo"><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/btn_again.png" alt="다시하기" /></a>
			</div>
		</div>
		<%'// 나에게 맞는 식물찾기 %>

		<%' 다른사람 찰떡식물 %>
		<div class="othersPlant">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/tit_others_plant.jpg" alt="다른 사람들의 찰떡식물은?" /></h3>
			<ul>
				<li>
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_others_cactus.jpg" alt="선인장" /></div>
					<p><em>선인장</em><span id="sun"><%=FormatNumber(suncnt, 0)%></span>명</p>
				</li>
				<li>
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_others_sansevieria.jpg" alt="산세베리아" /></div>
					<p><em>산세베리아</em><span id="sanse"><%=FormatNumber(sansecnt, 0)%></span>명</p>
				</li>
				<li>
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_others_marimo.jpg" alt="마리모" /></div>
					<p><em>마리모</em><span id="mari"><%=FormatNumber(maricnt, 0)%></span>명</p>
				</li>
				<li>
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/img_others_herb.jpg" alt="허브" /></div>
					<p><em>허브</em><span id="hub"><%=FormatNumber(hubcnt, 0)%></span>명</p>
				</li>
			</ul>
			<div class="shareSns">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160606/txt_share.png" alt="마리모" /></p>
				<a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;" class="btnFacebook">페이스북</a>
				<a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;" class="btnKakaotalk">카카오톡</a>
			</div>
			<p class="total">총 <strong><span id="totalcnt"><%=FormatNumber(totcnt, 0)%></span></strong>명이 찰떡 식물 테스트에 참여했습니다.</p>
		</div>
		<%'// 다른사람 찰떡식물 %>
	</article>
</div>
<form method="post" name="frmSbS" id="frmSbS">
	<input type="hidden" name="qAnswer" id="qAnswer" value="1">
	<input type="hidden" name="mode" value="add">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->