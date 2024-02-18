<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description :  PLAY #27.SCENT_순정한 향기 
' History : 2016-02-12 유태욱 작성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim oItem, pagereload, classboxcol, cmtYN
dim currenttime
	currenttime =  now()
	'currenttime = #02/15/2016 09:00:00#

	cmtYN = "Y"
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66028
Else
	eCode   =  69163
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, ecc
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),10)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.hidden {visibility:hidden; width:0; height:0;}

.topic {position:relative;}
.topic .btnevent {position:absolute; bottom:33%; left:17.8125%; width:31.25%;}

.story1st, .story2nd {position:relative;}
.rolling {position:absolute; top:43%; left:50%; width:90.62%; margin-left:-45.31%;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper button {position:absolute; top:42%; z-index:150; width:4.31%; background:transparent;}
.rolling .swiper .btn-prev {left:4%;}
.rolling .swiper .btn-next {right:4%;}

.itemwrap {position:relative;}
.itemwrap .item {position:absolute; width:100%;}
.itemwrap .lyPerfume {position:absolute; top:45.8%; left:13.5%; z-index:10; width:57.343%;}
.itemwrap .lyPerfume p {cursor:pointer;}

.story2nd .rolling {top:35%;}
.story1st {top:0; left:0; }
.story2nd .itemwrap .item {position:absolute; bottom:0; left:0; width:100%;}
.story2nd .itemwrap .lyPerfume {position:absolute; top:51.45%; left:6%;}

.video {position:relative;}
.video .youtubewrap {position:absolute; top:15%; left:50%; width:68.75%; margin-left:-34.375%; box-shadow: 16px 20px 50px -5px rgba(197,170,161,1);}
.video .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.video .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.commentevt {padding-bottom:10%; background:#ebbfac url(http://webimage.10x10.co.kr/playmo/ground/20160215/bg_paper_pink.jpg) repeat-y 50% 50%; background-size:100% auto;}

.form {position:relative;}
.form legend {visibility:hidden; width:0; height:0;}
.form ul {overflow:hidden;}
.form ul li {float:left; position:relative; width:50%;}
.form ul li input {position:absolute; bottom:5%; left:34%; border-radius:50%;}
.form ul li:first-child input {left:58%;}
.form ul li input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}

.form .itext {overflow:hidden; display:block; position:absolute; bottom:18.6%; left:19.843%; z-index:20; width:52.5%; height:0; padding-bottom:8.8%;}
.form .itext input {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; background-color:#fce2db; color:#cb9384; font-size:2rem; font-weight:bold; line-height:1.5em; text-align:left;}

.form .btnsubmit {position:absolute; bottom:9%; left:50%; width:43.75%; margin-left:-21.875%;}
.form .btnsubmit input {width:100%;}
::-webkit-input-placeholder {color:#fff;}
::-moz-placeholder {color:#fff;} /* firefox 19+ */
:-ms-input-placeholder {color:#fff;} /* ie */
input:-moz-placeholder {color:#fff;}

.commentlist {padding:0 1.7rem;}
.total {padding-bottom:0.5rem; border-bottom:2px solid #e6b49f; color:#92796d; font-size:1.1rem; text-align:right;}
.commentlist ul {margin-top:1rem;}
.commentlist ul li {position:relative; width:28.6rem; height:9.3rem; margin:0.5rem auto 0; padding:2.7rem 2rem 0; background:url(http://webimage.10x10.co.kr/playmo/ground/20160215/bg_box.png) no-repeat 50% 0; background-size:100% auto;}
.commentlist ul li p {color:#545454; font-size:1.3rem; letter-spacing:-0.05em;}
.commentlist ul li p b {font-weight:bold;}
.commentlist ul li p span {color:#f46d52;}
.commentlist ul li .id {display:block; margin-top:1.6rem; font-size:1rem; letter-spacing:-0.03em; text-align:right;}
.commentlist ul li .id img {width:0.6rem;}
.commentlist .btndel {position:absolute; top:0.8rem; right:1.5rem; width:1.3rem; background-color:transparent;}

.paging span {border-color:#afb1b1;}
.paging span.arrow {border-color:#afb1b1; background-color:#afb1b1;}
.paging span.current {background-color:transparent;}
</style>
<script type="text/javascript">
$(function(){
	$("#btnevent").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

	$("#synopsys p").hide();
	$("#synopsys h4 a").click(function(){
		$("#synopsys p").slideDown();
	});

	$(".lyPerfume").hide();
	$(".itemwrap .item").click(function(){
		$(this).next().show();
		return false;
	});

	$(".itemwrap p").click(function(){
		$(".lyPerfume").hide();
	});

	mySwiper1 = new Swiper('.rolling1 .swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:2500,
		speed:800,
		autoplayDisableOnInteraction:false,
		nextButton:'.rolling1 .btn-next',
		prevButton:'.rolling1 .btn-prev',
		effect:"fade"
	});

	mySwiper2 = new Swiper('.rolling2 .swiper2',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:2500,
		speed:800,
		autoplayDisableOnInteraction:false,
		nextButton:'.rolling2 .btn-next',
		prevButton:'.rolling2 .btn-prev',
		effect:"fade"
	});
});
function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-02-15" and left(currenttime,10)<"2016-02-22" ) Then %>				//날짜 확인!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>																						//숫자 확인!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				alert("한 ID당 한번만 참여할 수 있습니다.");
				return false;
			<% else %>
				var tmpdateval='';
				for (var i=0; i < frm.txtcomm1.length; i++){
					if (frm.txtcomm1[i].checked){
						tmpdateval = frm.txtcomm1[i].value;
					}
				}
				if (tmpdateval==''){
					alert('첫사랑과 어울리는 향기를\n선택해 주세요.');
					return false;
				}

				if (frm.txtcomm2.value == '' || GetByteLength(frm.txtcomm2.value) > 20 || frm.txtcomm2.value == '10자 내로 입력'){
					alert("띄어쓰기 포함\n최대 한글 10자 이내로 적어주세요.");
					frm.txtcomm2.focus();
					return false;
				}

				frm.spoint.value = tmpdateval
				frm.txtcomm.value = frm.txtcomm2.value
				frm.action = "/play/groundcnt/doEventSubscript69163.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}

	if (frmcom.txtcomm2.value == '10자 내로 입력'){
		frmcom.txtcomm2.value = '';
	}
}
</script>
	<div class="mPlay20160215">
		<article>
			<div class="topic">
				<h2 class="hidden">순정한 향기</h2>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_scent.jpg" alt="기억을 가장 불러 일으키기 쉬운 매개체 향기와 흘러나오는 라디오 속 목소리에 첫사랑을 느끼는 영화 순정 오늘, 텐바이텐 플레이는 두 매개체를 통해, 순정영화처럼 라디오 속 목소리로 추억여행 합니다." /></p>
				<a href="#commentevt" id="btnevent" class="btnevent"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_event.png" alt="이벤트 참여하기" /></a>
			</div>

			<section class="story">
				<h3 class="hidden">DJ 텐텐의 볼륨을 올려요</h3>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_intro.jpg" alt="네, DJ텐바이텐의 볼륨을 올려요입니다. 오늘은 첫사랑의 향수가 담긴 사연들이 많이 올라왔네요. 대부분의 사람에게 첫사랑은 행복한 기억보단 미련으로 더 많이 남는 것 같아요. 사연을 들으며 그때 그 시절 아련한 추억 속으로 여행을 떠나볼까요?" /></p>

				<div class="story1st">
					<h4 class="hidden">첫번째 사연, 범실의 이야기</h4>
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_story_01.jpg" alt="안녕하세요. 저는 범실이라고 합니다. 제 첫사랑은 너무 떨려 말도 못 건넸지만, 그 아이에게 모든 것을 다 내어주고 싶을 만큼 서로를 순수하게 좋아할 수 있던 아이, 수옥이었습니다. 그때 그 시절이 그립네요... " /></p>
					<div class="rolling rolling1">
						<div class="swiper">
							<div class="swiper-container swiper1">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_01_01.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_01_02.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_01_03.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_01_04.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_01_05.jpg" alt="" /></div>
								</div>
							</div>
							<div class="pagination"></div>
							<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_prev.png" alt="이전" /></button>
							<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_next.png" alt="다음" /></button>
						</div>
					</div>
					<div class="itemwrap">
						<a href="" class="item"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_plus_01.png" alt="나가 옆에서 지켜줄거여 평생 향수" /></a>
						<div id="lyPerfume01" class="lyPerfume">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_perfume_01_v1.png" alt="독특한 마일드 플로럴 아침 햇살을 머금은 프리지아 천연감! 르플랑은 국내외 유명 아티스트들과 함께 협업하여 진행하는 향기 프로젝트 브랜드입니다." /></p>
						</div>
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_story_01_02.jpg" alt="" />
					</div>
				</div>

				<div class="story2nd">
					<h4 class="hidden">두번째 사연, 수옥의 이야기</h4>
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_story_02.jpg" alt="안녕하세요 DJ 텐바이텐님! 저는 수옥이라고 합니다. 저에게 첫사랑은 아쉬움이에요. 그 고마움과 그 그리움을.. 사랑이란 말로 전하지 못했을 때, 평생 아쉬움으로 남거든요. 23년 전 그 사람이 아직도 떠올라요. 한 번 만이라도 그 마음을 전할 수 있다면 얼마나 좋을 까요? " /></p>
					<div class="rolling rolling2">
						<div class="swiper">
							<div class="swiper-container swiper2">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_02_01.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_02_02.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_02_03.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_02_04.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/img_slide_02_05.jpg" alt="" /></div>
								</div>
							</div>
							<div class="pagination"></div>
							<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_prev.png" alt="이전" /></button>
							<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_next.png" alt="다음" /></button>
						</div>
					</div>
					<div class="itemwrap">
						<a href="" class="item"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_plus_02.png" alt="나가 옆에서 지켜줄거여 평생 향수" /></a>
						<div id="lyPerfume01" class="lyPerfume">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_perfume_02_v1.png" alt="첫향은 상쾌하고시원한 눈꽃 결정 그리고 설레임, 잔향은 바닐라의 달콤함! 르플랑은 국내외 유명 아티스트들과 함께 협업하여 진행하는 향기 프로젝트 브랜드입니다." /></p>
						</div>
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_story_02_02.jpg" alt="" />
					</div>
				</div>
			</section>

			<section class="moive">
				<h3 class="hidden">영화 순정</h3>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_moive_v2.jpg" alt="두 분의 사연을 듣고 나니, 딱 어울리는 영화 한편이 생각 나네요. 오늘 소개할 영화는 바로 두 분의 마음과 닮은 영화 순정 입니다!" /></p>
				<div id="synopsys" class="synopsys">
					<h4><a href="#synopsysInfo"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_click.jpg" alt="SYNOPSYS" /></a></h4>
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_synopsys_v2.jpg" alt="" /></p>
				</div>
				<div class="video">
					<div class="youtubewrap">
						<div class="youtube">
							<iframe src="http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=799FF694743CD144128F56CCFFDC8184EB86&outKey=V122c219c12c63c465192062e833f97b7da2e5d408f06cb50b1af062e833f97b7da2e&controlBarMovable=true&jsCallable=true&skinName=default" frameborder="0" title="영화 순정 예고편" allowfullscreen></iframe>
						</div>
					</div>
					<img src="http://webimage.10x10.co.kr/playmo/ground/20160215/bg_video_v1.jpg" alt="" />
				</div>
			</section>

			<div id="commentevt" class="commentevt">
				<div class="form">
					<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
					<input type="hidden" name="mode" value="add">
					<input type="hidden" name="pagereload" value="ON">
					<input type="hidden" name="iCC" value="1">
					<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
					<input type="hidden" name="eventid" value="<%= eCode %>">
					<input type="hidden" name="linkevt" value="<%= eCode %>">
					<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
					<input type="hidden" name="returnurl" value="<%= appUrlPath %>/play/">
					<input type="hidden" name="txtcomm">
					<input type="hidden" name="spoint" value="0">
					<input type="hidden" name="gubunval">
					<input type="hidden" name="isApp" value="<%= isApp %>">	
						<fieldset>
							<legend>당신의 첫사랑과 어울리는 향기를 선택하고 느낌 적기</legend>
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_comment.jpg" alt="당신의 첫사랑과 어울리는 향기를 고르고 느낌을 공유해주세요. 추첨을 통해 150분에게 영화 순정 전용 예매권과 순정한 향기가 담긴 향수를 선물로 드립니다." /></p>
							<ul>
								<li>
									<label for="perfume01"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_label_01.jpg" alt="범실의 이야기가 담긴 향기" /></label>
									<input type="radio" id="perfume01" name="txtcomm1" value="1" />
								</li>
								<li>
									<label for="perfume02"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_label_02.jpg" alt="수옥과 범실의 추억이 담긴 향기" /></label>
									<input type="radio" id="perfume02" name="txtcomm1" value="2" />
								</li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/txt_my_first_love_v1.jpg" alt="나에게 첫사랑은" /></p>
							<div class="itext">
								<input type="text" title="나의 첫사랑에 대한 느낌 적기" name="txtcomm2" id="txtcomm2" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<%IF NOT IsUserLoginOK THEN%>10자 내로 입력<% else %>10자 내로 입력<%END IF%>" />
							</div>
							<div class="btnsubmit">
								<input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_submit.png" onclick="jsSubmitComment(document.frmcom); return false;" alt="응모하기" />
							</div>
						</fieldset>
					</form>
					<form name="frmdelcom" method="post" action="/play/groundcnt/doEventSubscript69163.asp" style="margin:0px;">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="pagereload" value="ON">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="returnurl" value="<%= appUrlPath %>/play/">
					<input type="hidden" name="eventid" value="<%= eCode %>">
					<input type="hidden" name="linkevt" value="<%= eCode %>">
					<input type="hidden" name="isApp" value="<%= isApp %>">
					</form>
				</div>

				<% if cmtYN = "Y" then %>
					<% IF isArray(arrCList) THEN %>
						<div class="commentlist" id="commentlist">
							<p class="total"><b>Total</b> <%= iCTotCnt %></p>
							<ul>
								<% For intCLoop = 0 To UBound(arrCList,2) %>
									<li>
										<p>나에게 <b>첫사랑은 <span><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></span>다.</b></p>
										<span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 
										<% If arrCList(8,intCLoop) = "M"  then%>
											<img src="http://webimage.10x10.co.kr/playmo/ground/20160215/ico_mobile.png" alt="모바일에서 작성된 글" /></span>
										<% end if %>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
											<button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="btndel"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_del.png" alt="삭제" /></button>
										<% end if %>
									</li>
								<% next %>
							</ul>
						</div>
						<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
					<% end if %>
				<% end if %>
			</div>
		</article>
	</div>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		$('html,body').animate({scrollTop: $("#commentlist").offset().top}, 0);
	<% end if %>
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->