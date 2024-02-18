<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 27 기억을 닮다, 향기를 담다.M
' History : 2016.02.17 유태욱 생성
'####################################################
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
	eCode   =  66033
Else
	eCode   =  69279
End If

dim userid, i, vreload
	userid = getloginuserid()
	vreload	= requestCheckVar(Request("reload"),2)

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
sqlstr = sqlstr & " Where evt_code="& eCode &""

'response.write sqlstr & "<br>"
rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
	iCTotCnt = rsCTget(0)
rsCTget.close

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.app {display:none;}
.hidden {visibility:hidden; width:0; height:0;}

.topic {position:relative;}
.topic h2 {position:absolute; top:11%; left:50%; width:75.625%; margin-left:-37.8125%;}
.topic h2 img {transform:scale(0.8); transition:1.5s ease-in-out; -webkit-transform:scale(0.8); -wekit-transition:1.5s ease-in-out;}
.topic h2.scale img {transform:scale(1); -webkit-transform:scale(1);}

.topic .btnevent {position:absolute; bottom:12.5%; left:12.5%; width:31.25%;}

.scent {position:relative;}
.item li {position:absolute; width:50%; height:13%;}
.item li.item01 {top:56%; right:0;}
.item li.item02 {top:68%; left:0;}
.item li a {display:block; width:100%; height:100%; font-size:12px; color:transparent; text-align:center; background-color:black; opacity:0; filter:alpha(opacity=0);}
.scent .btnSkip {position:absolute; left:3.125%; bottom:4%; width:18.75%;}

.scent01 .item li.item01 {top:60%;}
.scent01 .item li.item02 {top:74%;}
.scent02 .item li.item01 {top:59%;}
.scent03 .item li.item01 {top:59%;}
.scent03 .item li.item02 {top:70%;}
.scent04 .item li.item01 {top:62%;}
.scent04 .item li.item02 {top:80%;}

.rolling {position:relative;}
.rolling h3 {position:absolute; bottom:10%; left:0; z-index:10; width:100%;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper button {position:absolute; top:42%; z-index:10; width:4.84%; background:transparent;}
.rolling .swiper .btn-prev {left:14.375%;}
.rolling .swiper .btn-next {right:14.375%;}

.instagram {padding-bottom:12%; background-color:#f8f0eb;}
.instagramList {overflow:hidden; margin-top:6.5%; padding:0 4%;}
.instagramList li {float:left; width:50%;}
.instagramList li a {display:block; margin:0 5% 12%; padding:7%; background-color:#fff; box-shadow:0px 0px 6px -1px rgba(000,000,000,0.15);}
.instagramList li .article {overflow:hidden; height:5rem; display: -webkit-box; text-overflow:ellipsis; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-wrap:break-word; color:#404040; font-size:1.1rem;}
.instagramList li .article p {line-height:1.375em;}
.instagramList li .id {display:block; margin:5% 0 1%; color:#396991; font-weight:bold; font-size:1.2rem;}

.paging span {border-color:#afb1b1;}
.paging span.arrow {border-color:#afb1b1; background-color:#afb1b1;}
.paging span.current {background-color:transparent;}
</style>
<script type="text/javascript">
function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
</script>
<div class="mPlay20160222">
	<article>
		<div id="animation" class="topic">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/tit_memory_v1.png" alt="" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_memory_v1.jpg" alt="길을 걷다가 낯설지 않은 향기에 돌아본 찰나 잔뜩 가라앉은 비 냄새를 맞고 하늘을 올려다 본 아침 어느 집 된장찌개 냄새를 맡고 엄마 생각난 순간 향기는 우리가 모르게 기억을 담게 됩니다. 기억을 닮은 향기, 그 날의 감성을 텐바이텐이 선물합니다." /></p>
			<a href="#instagram" id="btnevent" class="btnevent"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_event.png" alt="이벤트 참여하기" /></a>
		</div>

		<div id="scent01" class="scent scent01">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_scent_01_v1.jpg" alt="잠이 솔솔 엄마의 따뜻한 향기" /></p>
			<ul class="item mo">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1235472&amp;pEtr=69279">Precious Baby 어린 시절 엄마에게 안기던 따스하고 포근한 기억</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189621&amp;pEtr=69279">Laundromat 엄마가 날 기다리는 따뜻하고 푸근한 집의 기억</a></li>
			</ul>
			<ul class="item app">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1235472&amp;pEtr=69279" onclick="fnAPPpopupProduct('1235472&amp;pEtr=69279');return false;">Precious Baby 어린 시절 엄마에게 안기던 따스하고 포근한 기억</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189621&amp;pEtr=69279" onclick="fnAPPpopupProduct('189621&amp;pEtr=69279');return false;">Laundromat 엄마가 날 기다리는 따뜻하고 푸근한 집의 기억</a></li>
			</ul>
			<a href="#scent02" class="btnSkip"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_skip.png" alt="NEXT" /></a>
		</div>
		<div id="scent02" class="scent scent02">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_scent_02_v2.jpg" alt="두근 두근 설렘 가득한 고백의 향기" /></p>
			<ul class="item mo">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=247001&amp;pEtr=69279">Juicy shampoo 수줍은 고백의 기억</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=741201&amp;pEtr=69279">Fuzzy Navel 달콤한 향기로 가득했던 첫사랑의 기억</a></li>
			</ul>
			<ul class="item app">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=247001&amp;pEtr=69279" onclick="fnAPPpopupProduct('247001&amp;pEtr=69279');return false;">Juicy shampoo 수줍은 고백의 기억</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=741201&amp;pEtr=69279" onclick="fnAPPpopupProduct('741201&amp;pEtr=69279');return false;">Fuzzy Navel 달콤한 향기로 가득했던 첫사랑의 기억</a></li>
			</ul>
			<a href="#scent03" class="btnSkip"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_skip.png" alt="NEXT" /></a>
		</div>
		<div id="scent03" class="scent scent03">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_scent_03_v1.jpg" alt="코 끝이 얼어도 좋아 겨울 바다 향기" /></p>
			<ul class="item mo">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=922838&amp;pEtr=69279">Ocean breeze 시원한 바다의 기억</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189630&amp;pEtr=69279">Snow 눈 오는 날의 기억</a></li>
			</ul>
			<ul class="item app">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=922838&amp;pEtr=69279" onclick="fnAPPpopupProduct('922838&amp;pEtr=69279');return false;">Ocean breeze 시원한 바다의 기억</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189630&amp;pEtr=69279" onclick="fnAPPpopupProduct('189630&amp;pEtr=69279');return false;">Snow 눈 오는 날의 기억</a></li>
			</ul>
			<a href="#scent04" class="btnSkip"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_skip.png" alt="NEXT" /></a>
		</div>
		<div id="scent04" class="scent scent04">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_scent_04_v1.jpg" alt="아침 산책길에 나선 파릇파릇 향기" /></p>
			<ul class="item mo">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=436141&amp;pEtr=69279">Wet garden 새벽 숲 산책 길에 나선 기억</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189630&amp;pEtr=69279">aisy 햇살 가득 품은 초록 잔디밭의 기억</a></li>
			</ul>
			<ul class="item app">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=436141&amp;pEtr=69279" onclick="fnAPPpopupProduct('436141&amp;pEtr=69279');return false;">Wet garden 새벽 숲 산책 길에 나선 기억</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=672041&amp;pEtr=69279" onclick="fnAPPpopupProduct('672041&amp;pEtr=69279');return false;">aisy 햇살 가득 품은 초록 잔디밭의 기억</a></li>
			</ul>
		</div>

		<div class="collabo">
			<p class="mo"><a href="/street/street_brand.asp?makerid=demeter" title="데메테르 브랜드 바로가기"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_collabo_v1.png" alt="텐바이텐 플레이 27번째 주제 Scent와 기억 속 향기 안내자 데메테르가 사람들의 기억속에 있던 추억을 향기로 만드는 프로젝트를 시도했습니다." /></a></p>
			<p class="app"><a href="" onclick="fnAPPpopupBrand('demeter'); return false;" title="데메테르 브랜드 바로가기"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_collabo_v1.png" alt="텐바이텐 플레이 27번째 주제 Scent와 기억 속 향기 안내자 데메테르가 사람들의 기억속에 있던 추억을 향기로 만드는 프로젝트를 시도했습니다." /></a></p>
		</div>

		<section class="rolling">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/tit_like_v1.png" alt="당신이 간직하고 싶은 기억을 담아주세요 응모하신 사진으로 향수병의 라벨로 만들어 드립니다." /></h3>
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_04.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_05.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_06.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_07.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_08.jpg" alt="" /></div>
					</div>
				</div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_next.png" alt="다음" /></button>
			</div>
		</section>

		<section class="event">
			<h3 class="hidden">나만의 향기 만들기 이벤트 참여 방법</h3>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_event_v2.png" alt="응모하신 분들 중 추첨을 통해 20분에게 나만의 기억을 담은 향기를 만들 수 있는 데메테르 향기 만들기 체험권을 드립니다 응모기간은 2016년 2월 22일부터 3월 6일까지며 당첨자 발표는 2016년 3월 8일입니다. 향수로 남기고 싶은 기억의 사진을 인스타그램에 #텐바이텐향기 해시태그와 함께 업로드 해주세요! 사진과 함께 짧은 사연도 꼭 남겨주세요." /></p>
			<h4><a href="#more"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/tit_way.png" alt="데메테르 퍼퓸 스튜디오 이용 방법 더 자세히 보기" /></a></h4>
			<p id="more"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_way_v2.png" alt="이벤트 당첨이 되면 향수공병과 티켓이 배송됩니다. 향수공병과 티켓을 가지고 청담에 위치한 데메테르 매장을 방문합니다. 나의 스타일과 기억을 담아 시트지를 작성합니다. 조향사와 함께 나만의 기억을 담은 향기를 만들어 기억을 간직하세요!" /></p>
			<p><a href="https://www.instagram.com/your10x10/" target="_blank" title="텐바이텐 인스타그램 보기 새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_note.png" alt="텐바이텐 인스타그램 계정 @your10x10을 팔로우하면 당첨확률이 UP! 인스타그램 계정이 비공개인 경우 집계가 되지 않습니다. #텐바이텐향기 해시태그를 남긴 사진은 이벤트 참여를 의미하며, 플레이 페이지에 자동 노출될 수 있습니다." /></a></p>
		</section>


		<section id="instagram" class="instagram">
			<h3 id="instagramevent"><a href="https://www.instagram.com/your10x10/" target="_blank" title="텐바이텐 인스타그램 보기 새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/tit_instagram_v1.png" alt="기억을 담은 사진들" /></a></h3>
			<%
			sqlstr = "Select * From "
			sqlstr = sqlstr & " ( "
			sqlstr = sqlstr & " 	Select row_Number() over (order by idx desc) as rownum, snsid, link, img_low, img_thum, img_stand, text, snsuserid, snsusername, regdate "
			sqlstr = sqlstr & " 	From db_AppWish.dbo.tbl_snsSelectData "
			sqlstr = sqlstr & " 	Where evt_code="& eCode &""
			sqlstr = sqlstr & " ) as T "
			sqlstr = sqlstr & " Where RowNum between "&(iCCurrpage*iCPageSize)-5&" And "&iCCurrpage*iCPageSize&" "
			
			'response.write sqlstr & "<br>"
			rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
			If Not(rsCTget.bof Or rsCTget.eof) Then
			%>
			<ul class="instagramList">
				<%
				Do Until rsCTget.eof
				%>
				<% '6개 뿌리기 %>
				<li>
					<% If IsApp="1" Then %>
						<a href="" onclick="openbrowser('<%=rsCTget("link")%>'); return false;" target="_blank">
					<% Else %>
						<a href="<%=rsCTget("link")%>"  target="_blank">
					<% End If %>
						<div class="figure"><img src="<%=rsCTget("img_stand")%>" onerror="this.src='http://webimage.10x10.co.kr/playmo/ground/20160222/img_not_found.jpg'" alt="" /></div>
						<div class="article"><span class="id"><%= printUserId(rsCTget("snsusername"),2,"*") %></span> <p><%=chrbyte(stripHTML(rsCTget("text")),27,"Y")%></p></div>
					</a>
				</li>
				<%
				rsCTget.movenext
				Loop
				%>
			</ul>
			<%
			End If
			rsCTget.close
			%>
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</section>
	</article>
<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
<input type="hidden" name="iCC" value="1">
<input type="hidden" name="reload" value="ON">
<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
</form>
</div>
<script type="text/javascript">
$(function(){
	/* skip to contents */
	$("#btnevent").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

	$(".scent .btnSkip").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

	$(".event #more").hide();
	$(".event h4 a").click(function(event){
		$(".event #more").slideDown();
		return false;
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".mPlay20160222 .app").show();
			$(".mPlay20160222 .mo").hide();
	}else{
			$(".mPlay20160222 .app").hide();
			$(".mPlay20160222 .mo").show();
	}

	/* animation */
	function animation() {
		$("#animation h2").addClass("scale");
	}
	animation();

	/* swipe js */
	mySwiper1 = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:2500,
		speed:800,
		autoplayDisableOnInteraction:false,
		nextButton:'.rolling .btn-next',
		prevButton:'.rolling .btn-prev',
		effect:"fade"
	});

	<% if vreload<>"" then %>
		$('html,body').animate({scrollTop: $("#instagramevent").offset().top},0);
	<% end if %>

});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<!-- #include virtual="/lib/db/dbCTclose.asp" -->