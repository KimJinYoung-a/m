<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'########################################################
' PLAY #22 BOTTLE 4주차 
' 2015-07-24 원승현 작성
'########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->

<%
Dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64839
	eCodedisp = 64839
Else
	eCode   =  65081
	eCodedisp = 65081
End If


dim userid, i, vreload
	userid = getloginuserid()

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt, sqlstr
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호


IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 6	'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6	'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if


'// sns데이터 총 카운팅 가져옴
	sqlstr = "select count(*) "
	sqlstr = sqlstr & " from [db_Appwish].[dbo].[tbl_snsSelectData]"
	rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
		iCTotCnt = rsCTget(0)
	rsCTget.close


iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.mPlay20150727 {}
.topic {padding-bottom:12%; background-color:#fff;}
.topic .btngo {width:73.6%; margin:0 auto;}

/* swiper */
.swiper {position:relative; overflow:hidden;}
.swiper .swiper-container {width:100%;}
.swiper .swiper-wrapper {}
.swiper .swiper-slide {position:relative;}

.rolling1 .swiper .swiper-slide p {position:absolute; top:14%; left:13.9%; width:43.9%;}
.rolling1 .swiper .pagination {position:absolute; bottom:6%; left:0; z-index:10; width:100%;}
.rolling1 .pagination .swiper-pagination-switch {width:8px; height:8px; margin:0 3px; background-color:#898989; cursor:pointer;}
.rolling1 .pagination .swiper-active-switch {background-color:#0b75df;}

.rolling2 .swiper .pagination2 {position:absolute; bottom:7%; left:0; z-index:10; width:100%; padding-top:0; text-align:center;}
.rolling2 .swiper .pagination2 .swiper-pagination-switch {display:inline-block; width:8px; height:8px; margin:0 4px; border:2px solid #fff; border-radius:50%; background-color:transparent; cursor:pointer; opacity:0.5;}
.rolling2 .swiper .pagination2 .swiper-active-switch {background-color:#fff;}
.rolling2 .swiper button {position:absolute; bottom:7%; z-index:150; width:8px; background:transparent;}
.rolling2 .swiper .prev {left:32%;}
.rolling2 .swiper .next {right:32%;}

.sticker {padding-bottom:17%; background-color:#fff;}
.sticker .btnmore {width:73.6%; margin:10% auto 0;}

.consolation p {visibility:hidden; width:0; height:0;}

.instagram {padding-bottom:10%; background:#d9eef1 url(http://webimage.10x10.co.kr/playmo/ground/20150727/bg_comb_pattern.png) repeat 0 0; background-size:5px auto;}
.instagramList {overflow:hidden; margin:11% 3.8% 7%;}
.instagramList li {float:left; width:50%;}
.instagramList li figure {margin:3%; padding:3%; background-color:#fff; box-shadow:0px 0px 6px -1px rgba(172,202,206,0.95);}
.instagramList li figure img {width:100%;}

@media all and (min-width:360px){
	.rolling2 .swiper .pagination2 .swiper-pagination-switch {width:10px; height:10px;}
}

@media all and (min-width:480px){
	.swiper .pagination {height:auto;}
	.swiper .pagination .swiper-pagination-switch {width:16px; height:16px; margin:0 6px;}
	.rolling2 .swiper button {width:12px;}
	.rolling2 .swiper .pagination2 .swiper-pagination-switch {width:16px; height:16px; margin:0 10px;}
}

@media all and (min-width:678px){
	.swiper .pagination .swiper-pagination-switch {width:20px; height:20px; margin:0 10px;}
}

</style>
<script type="text/javascript">

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}


</script>
</head>
<body>


<!-- #4 -->
<div class="mPlay20150727">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/tit_age_nine.jpg" alt="쿨 썸머 쿨 헬퍼" /></h2>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/txt_topic.gif" alt="기획자는 스물아홉 &apos;아홉수&apos; 입니다. 아홉수에는 괜히 운이 좋지 않다고 느껴집니다. 하지만 긍정적으로 생각하고, 가볍게 웃어 넘겨보면 어떨까요! 여러분을 응원하기 위해 아홉이 새겨진 아홉수 보틀을 준비했습니다. 소소한 재미를 이 보틀에 담아 마시며 여름을 시원하게 즐겨 보세요!" /></p>
		<div class="btngo">
			<a href="#instagram"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/btn_go.gif" alt="인스타그램 태그하고 보틀 받기!" /></a>
		</div>
	</div>

	<div class="rolling1">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/txt_water_01.png" alt="하는 일마다 잘 안 되는 것 같지만, 알고 보면 다 마음을 어떻게 먹느냐에 따라 다르다. 시원한 냉수 한잔 마시고 깨달음을 얻어보자!" /></p>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20150727/img_swiper_01.jpg" alt="원효대사 해골물" />
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/txt_water_02.png" alt="봉이 김선달이 대동강 물을 팔아낸 것 같은 두둑한 배짱과 용기로 가득 찬 하루를 위하여, 지화자!" /></p>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20150727/img_swiper_02.jpg" alt="봉이김선달 대동강물" />
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/txt_water_03.png" alt="새벽에 눈 비비고 일어난 토끼와 같은 토끼띠 스물아홉! 성실함과 부지런함을 재충전해보자!" /></p>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20150727/img_swiper_03.jpg" alt="깊은산속 옹달샘물" />
					</div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
	</div>

	<div class="sticker">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/txt_sticker.jpg" alt="아홉수에 맛을 더하는 3종 스키터 원효대사 해골물, 봉이김선달 대동강물, 깊은산속 옹달샘물" /></p>
		<div class="btnmore">
			<a href="http://www.10x10.co.kr/play/playGround.asp?gidx=22&amp;gcidx=93" target="_blank" title="텐바이텐 피씨버전 새창에서 열림"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/btn_more.gif" alt="3종 스티커 부탁 방법 더보기" /></a>
		</div>
	</div>

	<div class="rolling2">
		<div class="swiper">
			<div class="swiper-container swiper2">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/img_slide_01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/img_slide_03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/img_slide_04.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/img_slide_05.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination2"></div>
			<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/btn_prev_v1.png" alt="이전" /></button>
			<button type="button" class="next"><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/btn_next_v1.png" alt="다음" /></button>
		</div>
	</div>

	<div id="instagram" class="consolation">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/txt_consolation.png" alt="아홉수 화이팅! 나에게 힘이 되어 주는 것들!" /></h3>
		<p>인스타그램에  #텐바이텐아홉수  해시태그와 함께 여러분에게 힘이 되는 것들을 업로드 해주세요. 총 30분에게 아홉수 보틀 &amp; 3종 스티커 세트를 선물로 드립니다! 신청기간은 7월 27일부터 8월 10일까지며 당첨자 발표는 8월 11일입니다.</p>
		<p>계정이 비공개인 경우, 집계가 되지 않습니다. 이벤트 기간 동안 &apos;#텐바이텐아홉수&apos; 해시태그로 업로드 한 사진은 이벤트 참여를 의미하며, 텐바이텐 플레이 페이지 노출에 동의하는 것으로 간주합니다.</p>
	</div>

	<%' instagram %>
	<div class="instagram">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150727/txt_instagram.png" alt="텐바이텐 인스타그램 계정 (@your10x10) 을 팔로우 하고 텐바이텐 계정을 해당 사진에 함께한 친구로 태그하면 당첨 확률이 높아집니다!" /></p>

		<%' for dev msg : 인스타그램 %>
		<ul class="instagramList">
		<%
			sqlstr = "Select * From "
			sqlstr = sqlstr & " ( "
			sqlstr = sqlstr & " Select row_Number() over (order by idx desc) as rownum, snsid, link, img_low, img_thum, img_stand, text, snsuserid, snsusername, regdate "
			sqlstr = sqlstr & " From db_AppWish.dbo.tbl_snsSelectData "
			sqlstr = sqlstr & " ) as T "
			sqlstr = sqlstr & " Where RowNum between "&(iCCurrpage*iCPageSize)-5&" And "&iCCurrpage*iCPageSize&" "
			rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
			If Not(rsCTget.bof Or rsCTget.eof) Then
				Do Until rsCTget.eof
		%>
			<li>
				<% If IsApp="1" Then %>
					<a href="" onclick="openbrowser('<%=rsCTget("link")%>');return false;" target="_blank">
				<% Else %>
					<a href="<%=rsCTget("link")%>"  target="_blank">
				<% End If %>
					<figure>
						<img src="<%=rsCTget("img_low")%>" alt="" />
					</figure>
				</a>
			</li>
		<%
				rsCTget.movenext
				Loop
		%>
		</ul>
		<%' paging %>
		<div class="paging">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
		<%
			End If
			rsCTget.close
		%>
	</div>
	<%' //instagram %>
</div>
<!-- //#4 -->
	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="iCC" value="1">
	<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	</form>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.next',
		prevButton:'.prev',
		onSlideChangeStart: function(swiper){
			$(".swiper-slide").find("p").delay(500).animate({"top":"16%", "opacity":"0"},300);
			$(".swiper-slide-active").find("p").delay(50).animate({"top":"14%", "opacity":"1"},800);
		}
	});

	mySwiper = new Swiper('.swiper2',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3500,
		speed:2000,
		pagination:".pagination2",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.next',
		prevButton:'.prev'
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	/* move */
	$(".topic .btngo a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 1200);
	});


	<% if Request("iCC")<>"" or Request("eCC")<>"" then %>
		window.parent.$('html,body').animate({scrollTop:$("#instagram").offset().top}, 0);
	<% end if %>
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
<!-- #include virtual="/lib/db/dbCTclose.asp" -->