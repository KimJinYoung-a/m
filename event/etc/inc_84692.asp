<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : hey, something project 시리즈 99
' 미키와 미니의 양말셋트
' History : 2017-12-12 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
dim currenttime
	currenttime =  now()
'	currenttime = #11/10/2017 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67510
Else
	eCode   =  84692
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if userid = "greenteenz" or userid = "baboytwtest1" or userid = "baboytw55" or userid = "baboytw56" or userid = "baboytw1" or userid = "chaem35" or userid = "answjd248" or userid = "corpse2" or userid = "jinyeonmi" or userid = "jj999a" then
	currenttime = #02/26/2018 00:00:00#
end if

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page	= getNumeric(requestCheckVar(Request("page"),10))	'헤이썸띵 메뉴용 페이지 번호

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
	iCPageSize = 3		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 3		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if
'iCPageSize = 1

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
.topic {position:relative;}
.topic h2 span {display:inline-block; position:absolute; top:8.5%; left:13.3%; width:21.3%;}
.topic h2 span.t2 {top:13.08%; width:39.2%;}
.topic .intro {position:absolute; width:41.86%; top:32.88%; right:8%;}

.rolling .swiper {position:relative; width:84%; padding-bottom:8.53rem; margin:0 auto; background:#f2f2f2;}
.rolling .swiper .pagination {position:absolute; bottom:4.69rem; left:50%; z-index:30; width:100%; height:auto; margin-left:-50%; text-align:center;}
.rolling .swiper .pagination span {display:inline-block; width:1.62rem; height:1.62rem; margin:0 0.8rem; background-color:#f2f2f2; border:solid .09rem #898989; color:#898989; font-size:.88rem; line-height:1.63rem; font-weight:600; transition:all 0.4s ease; box-shadow:0; border-radius:0;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#898989; color:#f2f2f2; border-radius:0;}
.rolling .btnNav {position:absolute; bottom:4.63rem; z-index:30; width:8.27%; background-color:transparent;}
.rolling .btnPrev {left:17%;}
.rolling .btnNext {right:17%;}
.rolling .swiper .pagination span:nth-child(1):before { content: "1"; }
.rolling .swiper .pagination span:nth-child(2):before { content: "2"; }
.rolling .swiper .pagination span:nth-child(3):before { content: "3"; }
.rolling .swiper .pagination span:nth-child(4):before { content: "4"; }

.rolling2 {background:#fff; padding-bottom:4.69rem;}
.rolling2 .swiper .swiper-slide {width:38%; padding:0 5%;}

.cosmetic-evt { background-color:#e0e788;}
.cosmetic-evt .inner{padding:0 9.1%;}
.cosmetic-evt .select-cosmetic {width:100%; height:5.12rem; background-color:#ac3fcf;}
.cosmetic-evt .select-cosmetic select {width:100%; height:5.12rem; padding:0 3.33rem 0 2.05rem;color:#fff; font-size:1.28rem; font-weight:600; background:url(http://webimage.10x10.co.kr/eventIMG/2018/84692/m/btn_arrow.png) no-repeat 100% 100%; background-size:3.32rem auto; direction:ltr;}
.cosmetic-evt .select-cosmetic option {color:#000;}
.cosmetic-evt .reason-box textarea{width:100%; height:14.98rem; padding:2rem 2.12rem; color:#a4a4a4; font-size:1.28rem; font-weight:600; border-radius:0; border:solid 1px #fff;}
.cosmetic-evt .submit {padding:0 3.84rem; margin-top:1.92rem; background-color:transparent;}

.comment-list {background-color:#e0e788; padding:0 9.1%;}
.comment-list li {position:relative; width:100%; padding:2.13rem 1.79rem; margin-bottom:3.02rem; background-color:#b9c800; color:#fff; vertical-align:middle; text-align:left;}
.comment-list li .num {display:inline-block; font-size:1rem; line-height:1; color:#fffc00; font-weight:bold;}
.comment-list li .cosmetic {color:#7c2698; font-size:1.37rem; line-height:1; padding-top:1.02rem; font-weight:bold;}
.comment-list li .conts {width:100%; height:12.52rem; margin-top:1.1rem; font-size:1.1rem; line-height:1.71rem; font-weight:600; word-break:break-all;}
.comment-list li .writer {position:absolute; right:1.28rem; bottom:1.5rem; color:#5d6500; font-size:1rem;}
.comment-list li .delete {position:absolute; right:0; top:0; width:1.85rem; height:1.85rem;}

.eggplant .pageWrapV15 {padding:0 9.1% 5.29rem; background-color:#e0e788;}
.eggplant .pagingV15a {position:relative; height:100%; margin:0;}
.eggplant .pagingV15a span {display:inline-block; height:2.6rem; margin:0; padding:0 1.01rem; border:0; color:#7c2698; font-weight:bold; font-size:1.2rem; line-height:2.6rem;}
.eggplant .pagingV15a .current {background-color:#7c2698; border-radius:50%; color:#fff;}
.eggplant .pagingV15a span.arrow {display:inline-block; position:absolute; top:0; min-width:1.32rem; height:2.31rem; padding:0;}
.eggplant .pagingV15a span.arrow.prevBtn {left:0;}
.eggplant .pagingV15a span.arrow.nextBtn {right:0;}
.eggplant .pagingV15a span.arrow a {width:100%; background-size:100% 100%;}
.eggplant .pagingV15a span.arrow a:after {display:none;}
.eggplant .pagingV15a span.arrow.prevBtn a{background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/84692/m/btn_prev.png);}
.eggplant .pagingV15a span.arrow.nextBtn a{background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/84692/m/btn_next.png);}
</style>
<script type="text/javascript">
$(function () {
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% end if %>

	/*var position = $('.eggplant').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동*/

	titleAnimation();
	$(".topic .t1").css({"margin-top":"10px","opacity":"0"});
	$(".topic .t2").css({"margin-top":"10px","opacity":"0"});
	$(".topic .intro").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic .t1").delay(100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
		$(".topic .t2").delay(400).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
		$(".topic .intro").delay(800).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}

	mySwiper = new Swiper(".rolling .swiper-container",{
		loop:true,
		autoplay:2000,
		speed:600,
		pagination:".rolling .pagination",
		prevButton:'.rolling .btnPrev',
		nextButton:'.rolling .btnNext',
		paginationClickable:true,
		effect:"slide"
	});

	mySwiper = new Swiper(".rolling2 .swiper-container",{
		loop:true,
		autoplay:1600,
		speed:600,
		pagination:false,
		prevButton:false,
		nextButton:false,
		effect:"slide",
		slidesPerView:'auto'
	});
});

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#comment-evt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2018-02-26" and left(currenttime,10)<"2018-03-05" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>
				alert("본 이벤트는 ID당 1회만 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('화장품을 골라보세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 300){
					alert("코맨트를 남겨주세요.\n150자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}
				frm.txtcomm.value = frm.gubunval.value + '!@#' + frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}

	//if (frmcom.txtcomm.value == ''){
	//	frmcom.txtcomm.value = '';
	//}
}
</script>
			<div class="mEvt84692 eggplant">
				<div class="topic">
					<h2>
						<span class="t1"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/txt_object.png" alt="object1" /></span>
						<span class="t2"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/tit_eggplant.png" alt="가지" /></span>
					</h2>
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_topic.jpg" alt="아래로" />
					<p class="intro"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/txt_intro.png" alt="" /></p>
				</div>
				<div class="goodthings"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/txt_good.jpg" alt="예쁜 색깔만큼 피부미용에도 좋다는 점 아시나요? 여드름 완화 피부진정, 잡티예방 수분보충 노화방지" /></div>
				<div class="about-brand">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/tit_brand.jpg" alt="다양한 효과가 가득한 가지성분 화장품" /></h3>
					<div class="rolling">
						<div class="swiper">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_slide_1.jpg?v=1.0" alt="자연에서 주는 선물을 피부에 양보하다" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_slide_2.jpg?v=1.0" alt="90% 원료비용으로 트러블에 좋은 성분 가득!" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_slide_3.jpg?v=1.0" alt="자연 유래 성분이라 ‘비자극’피부자극지수 0.00" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_slide_4.jpg?v=1.0" alt="자연유래 성분 화장품 유리스킨" /></div>
								</div>
							</div>
							<div class="pagination"></div>
							<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/btn_brand_prev.png" alt="이전" /></button>
							<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/btn_brand_next.png" alt="다음" /></button>
						</div>
					</div>
				</div>
				<div class="about-brand">
					<h4><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/tit_ure_skin.png" alt="유리스킨은 ‘내가 쓰고 싶은 화장품’을 만들고자 합니다" /></h3>
					<div class="rolling2">
						<div class="swiper">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1879750&pEtr=84692" onclick="TnGotoProduct('1879750');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_1.png" alt="트리플 클렌저 필링젤" />
										</a>
									</div>
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1877481&pEtr=84692" onclick="TnGotoProduct('1877481');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_2.png" alt="립앤아이 리무버 120ml" />
										</a>
									</div>
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1877480&pEtr=84692" onclick="TnGotoProduct('1877480');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_3.png?v=1.0" alt="마스터 크림 50g" />
										</a>
									</div>
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1879754&pEtr=84692" onclick="TnGotoProduct('1879754');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_4.png" alt="산뜻 클렌징 오일/클렌저" />
										</a>
									</div>
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1879753&pEtr=84692" onclick="TnGotoProduct('1879753');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_5.png" alt="투명 클렌징 워터 300ml" />
										</a>
									</div>
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1879752&pEtr=84692" onclick="TnGotoProduct('1879752');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_6.png?v=1.0" alt="스킨케어 클리어패드" />
										</a>
									</div>
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1879755&pEtr=84692" onclick="TnGotoProduct('1879755');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_7.png" alt="바이오셀 에센스 50ml" />
										</a>
									</div>
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1877479&pEtr=84692" onclick="TnGotoProduct('1877479');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_8.png?v=1.0" alt="몽글몽글 버블클렌저" />
										</a>
									</div>
									<div class="swiper-slide">
										<a href="/category/category_itemPrd.asp?itemid=1879751&pEtr=84692" onclick="TnGotoProduct('1879751');return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/img_item_9.png" alt="올인원 토너 180ml" />
										</a>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!--- 화장품 응모 이벤트 -->
				<div class="cosmetic-evt" id="comment-evt">
					<h5><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/txt_evt.png" alt="직접 사용해보지 않고선 잘 몰라요! 원하는 화장품을 선택 후, 이유를 적어주신 900분을 추첨하여 <유리스킨> 화장품을 드립니다" /></h5>
					<div class="inner">
						<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
						<input type="hidden" name="mode" value="add">
						<input type="hidden" name="pagereload" value="ON">
						<input type="hidden" name="iCC" value="1">
						<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="linkevt" value="<%= eCode %>">
						<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
						<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
						<input type="hidden" name="txtcomm">
						<input type="hidden" name="isApp" value="<%= isApp %>">
						<div class="select-cosmetic styled-selectbox styled-selectbox-default">
							<select class="select" title="화장품 선택옵션" name="gubunval">
								<option value="1">바이오셀 에센스 50ml</option>
								<option value="2">투명 클렌징 워터 300ml</option>
								<option value="3">스킨케어 클리어 패드</option>
								<option value="4">올인원 토너 180ml</option>
								<option value="5">트리플 클렌저 필링젤</option>
								<option value="6">립앤아이 리무버 12ml</option>
								<option value="7">마스터 크림 50g</option>
								<option value="8">몽글몽글 버블클렌저</option>
							</select>
						</div>
						<div class="reason-box">
							<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> placeholder="갖고 싶은 이유 150자 이내로 적어주세요!"></textarea>
							<button class="submit" onclick="jsSubmitComment(document.frmcom); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/btn_submit.jpg" alt="코멘트 쓰기" /></button>
						</div>
						</form>
						<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
						<input type="hidden" name="mode" value="del">
						<input type="hidden" name="pagereload" value="ON">
						<input type="hidden" name="Cidx" value="">
						<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="linkevt" value="<%= eCode %>">
						<input type="hidden" name="isApp" value="<%= isApp %>">
						</form>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/txt_noti.png" alt="* 통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.* 한 ID 당 1번 참여 가능합니다. " /></p>

					<!-- 응모 참여 리스트 3개씩 노출 -->
					<div class="comment-listwrap">
						<% IF isArray(arrCList) THEN %>
						<ul class="comment-list">
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<span class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
								<p class="cosmetic">
									<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
									<% if split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
									바이오셀 에센스 50ml
									<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
									투명 클렌징 워터 300ml
									<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
									스킨케어 클리어 패드
									<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
									올인원 토너 180ml
									<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="5" Then %>
									트리플 클렌저 필링젤
									<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="6" Then %>
									립앤아이 리무버 120ml
									<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="7" Then %>
									마스터 크림 50g
									<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="8" Then %>
									몽글몽글 버블클렌저
									<% Else %>
									바이오셀 에센스 50ml
									<% End If %>
									<% end if %>
								</p>
								<div class="conts">
									<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
										<% if ubound(split(arrCList(1,intCLoop),"!@#")) > 0 then %>
											<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"!@#")(1) ))%>
										<% end if %>
									<% end if %>
								</div>
								<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84692/m/btn_delete.png" alt="삭제" /></button>
								<% end if %>
							</li>
							<% next %>
						</ul>
						<% End If %>
						<div class="pageWrapV15">
							<div class="paging pagingV15a">
							<% If isArray(arrCList) Then %>
							<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
							<% End If %>
							</div>
						</div>
						<!--// 페이지네이션 -->
					</div>
					<!-- 응모 참여 리스트-->
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->