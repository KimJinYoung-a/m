<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description : 다이어리 스토리 오픈 이벤트 
' History : 2020-09-09 정태훈
'#################################################################
%>
<%
Dim userid, currentDate, eventStartDate, eventEndDate, evtdiv
currentDate =  now()
userid = GetEncLoginUserID()
eventStartDate  = cdate("2020-09-14")		'이벤트 시작일
eventEndDate 	= cdate("2020-10-04")		'이벤트 종료일
evtdiv = requestcheckvar(request("evtdiv"),5)
if evtdiv="" then evtdiv="evt1"

if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" then
	currentDate = #09/14/2020 09:00:00#
end if

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  102223
Else
	eCode   =  105778
End If

dim commentcount, i, subscriptcount
	

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
Else
	commentcount = 0
End If

dim cEComment, cdl, com_egCode, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	isMyComm	= requestCheckVar(request("isMC"),1)

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
iCPageSize = 4		'메뉴가 있으면 10개		'/수기이벤트 둘다 강제 12고정

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt      '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt            '리스트 총 갯수
set cEComment = nothing

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("원하는 다이어리를 골라봐!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "원하는 다이어리를 골라봐!"
Dim kakaodescription : kakaodescription = "당신이 내년에 쓰고 싶은 다이어리는? 5,000원 할인 쿠폰을 드립니다."
Dim kakaooldver : kakaooldver = "당신이 내년에 쓰고 싶은 다이어리는? 5,000원 할인 쿠폰을 드립니다."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.not-scroll {position:fixed; overflow:hidden; width:100%; height:auto;}
.body-sub .content, .body-popup .content {padding-bottom:0;}
.mEvt105778 {background-color:#fff;}
.mEvt105778 button {width:100%; background-color:transparent;}
.mEvt105778 .tab-nav {width:100%; height:14.63vw;}
.mEvt105778 .tab-nav ul {display:flex; overflow:hidden; width:100%; height:14.63vw; background-color:#fff;}
.mEvt105778 .tab-nav li {flex:1; height:100%;}
.mEvt105778 .tab-nav li a {display:block; width:100%; height:100%; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/tab1.png); background-position:0 0; background-repeat:no-repeat; background-size:100vw 100%; text-indent:-999em; border-radius:0 1.71rem 0 0; transition:all .3s;}
.mEvt105778 .tab-nav li:last-child a {background-position-x:100%; border-radius:1.71rem 0 0 0;}
.mEvt105778 .tab-nav .tab-nav2 li a {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/tab2.png);}
.mEvt105778 .tab-nav .tab2 a {background-position-x:-33.25vw; border-radius:1.71rem 1.71rem 0 0;}
.mEvt105778 .tab-nav.fixed ul {position:fixed; top:0; left:0; z-index:30;}
.mEvt105778 .tab-nav.fixed ul li a {border-radius:0;}

.mEvt105778 .btn-group button {display:inline-block; width:2.56rem; height:2.56rem; padding-top:.2rem; text-indent:-999em; background-color:#ededed; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/btn_modify.png); background-repeat:no-repeat; background-size:cover; background-position:50% 50%; border-radius:50%;}
.mEvt105778 .btn-group .btn-delete {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/btn_delete.png);}
.mEvt105778 .btn-group .btn-submit {display:none; font-size:1.11rem; color:#444; background-image:none; text-indent:0;}

.mEvt105778 .pagingV15a {position:relative; height:100%; margin:0;}
.mEvt105778 .pagingV15a span {display:inline-block; height:2.6rem; margin:0; padding:0 1.01rem; border:0; color:#ccc; font-weight:bold; font-size:1.2rem; line-height:2.6rem;}
.mEvt105778 .pagingV15a span.arrow {display:inline-block; position:absolute; top:50%; min-width:1.43rem; height:1.68rem; padding:0; transform:translateY(-50%)}
.mEvt105778 .pagingV15a span.arrow.prevBtn {left:16%;}
.mEvt105778 .pagingV15a span.arrow.nextBtn {right:16%;}
.mEvt105778 .pagingV15a span.arrow a {width:100%; background:url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='10px' height='16px'%3e %3cpath fill-rule='evenodd' fill='rgb(34%2c 34%2c 34)' d='M10.005%2c13.587 L7.607%2c16.005 L0.093%2c8.427 L0.555%2c7.961 L-0.004%2c7.397 L7.322%2c0.010 L9.660%2c2.367 L4.268%2c7.803 L10.005%2c13.587 Z'/%3e %3c/svg%3e") no-repeat 50% 50%/.43rem .68rem;}
.mEvt105778 .pagingV15a span.arrow a:after {display:none;}
.mEvt105778 .pagingV15a span.arrow.nextBtn a {transform:rotate(180deg);}
.mEvt105778 .pagingV15a .current {color:#222; border-radius:50%;}

.cont1 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt_list1.png); background-position:50% 50%; background-repeat:repeat-y; background-size:100%;}
.cont1 .cmt-evt {position:relative;}
.cont1 .write-cmt {display:flex; position:absolute; top:0; left:0; width:100%; height:100%;padding:0 5.3%;}
.cont1 .write-cmt input {flex:1; width:74.93%; height:100%; padding:0 2.13rem; border:none; font-size:1.62rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; color:#444;}
.cont1 .write-cmt input::-webkit-input-placeholder {color:#999;}
.cont1 .write-cmt input::-moz-placeholder {color:#999;}
.cont1 .write-cmt input:-ms-input-placeholder {color:#999;}
.cont1 .write-cmt input:-moz-placeholder {color:#999;}
.cont1 .write-cmt .btn-submit {width:25.07%; color:transparent;}
.cont1 .cmt-list ul {padding:0 1.71rem;}
.cont1 .cmt-list .cmt-wrap {display:flex; flex-direction:column; justify-content:center; position:relative; width:20.48rem; height:9.05rem; margin-top:0; background-position:50% 50%; background-repeat:repeat-y; background-size:100%; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.cont1 .cmt-list .cmt-wrap .num {position:absolute; top:1.05rem; left:1.1rem; font-size:.85rem; color:#666;}
.cont1 .cmt-list .cmt-wrap .btn-group {position:absolute; top:-.85rem; right:-.85rem; z-index:10;}
.cont1 .cmt-list .cmt-wrap .btn-group button {background-color:#fffff8;}
.cont1 .cmt-list .cmt-wrap .cmt-cont {position:relative; margin-bottom:.45rem; font-size:1.45rem; text-align:center;}
.cont1 .cmt-list .cmt-wrap .cmt-cont input[type=text] {position:absolute; top:-.4rem; left:0; width:100%; height:1.8rem; padding:0; border:0; border-radius:0; background-color:transparent; font-size:1.45rem; line-height:1; text-align:center;}
.cont1 .cmt-list .cmt-wrap .user-info {margin-bottom:.9rem; font-size:1.28rem; color:#888; text-align:center;}
.cont1 .cmt-list .cmt-wrap.modifying .btn-modify {display:none;}
.cont1 .cmt-list .cmt-wrap.modifying .btn-submit {display:inline-block;}
.cont1 .cmt-list .cmt-wrap.modifying .cmt-cont > div {color:transparent;}
.cont1 .cmt-list li:nth-child(2n) .cmt-wrap {margin-left:auto;}
.cont1 .cmt-list li:nth-child(2n) .cmt-wrap .num {top:1.28rem;}
.cont1 .cmt-list li:nth-child(8n-7) .cmt-wrap {z-index:13; margin-top:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt1.png); }
.cont1 .cmt-list li:nth-child(8n-6) .cmt-wrap {z-index:12; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt2.png);}
.cont1 .cmt-list li:nth-child(8n-5) .cmt-wrap {z-index:11; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt3.png);}
.cont1 .cmt-list li:nth-child(8n-4) .cmt-wrap {z-index:9; height:11.67rem;  background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt4.png);}
.cont1 .cmt-list li:nth-child(8n-3) .cmt-wrap {z-index:8; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt5.png);}
.cont1 .cmt-list li:nth-child(8n-2) .cmt-wrap {z-index:7; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt6.png);}
.cont1 .cmt-list li:nth-child(8n-1) .cmt-wrap {z-index:6; height:11.67rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt7.png);}
.cont1 .cmt-list li:nth-child(8n) .cmt-wrap {z-index:5; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt8.png);}
.cont1 .cmt-list li:nth-child(8n-6) .cmt-wrap .num,
.cont1 .cmt-list li:nth-child(8n-3) .cmt-wrap .num,
.cont1 .cmt-list li:nth-child(8n) .cmt-wrap .num {left:2.6rem;}
.cont1 .cmt-list li:nth-child(8n-6) .cmt-wrap .btn-group,
.cont1 .cmt-list li:nth-child(8n-3) .cmt-wrap .btn-group,
.cont1 .cmt-list li:nth-child(8n) .cmt-wrap .btn-group {top:-.3rem; right:.3rem;}
.cont1 .btn-go {display:block; width:50.93%; padding:3.41rem 1.71rem 5.12rem 0; margin-left:auto;}
.mEvt105778 .cont1 .pagingV15a {margin-top:2rem;}

.cont2 .cmt-evt {background-color:#5ba1ff;}
.cont2 .selct-dr {position:relative; height:53.2vw;}
.cont2 .selct-dr .thumbnail {display:flex; align-items:center; justify-content:center; position:absolute; top:50%; left:50%; width:53.2vw; height:100%; transform:translate(-50%,-50%); border-radius:2vw; background-color:#fff;}
.cont2 .selct-dr .thumbnail img {width:48vw; height:48vw; border-radius:1.71vw;}
.cont2 .selct-dr .thumbnail .btn-delete {position:absolute; top:-.8rem; right:-.8rem; z-index:10;  width:2.56rem; height:2.56rem; text-indent:-999em; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/btn_delete.png) no-repeat 50% 50%/100%; border-radius:50%;}
.cont2 .write-cmt {position:relative;}
.cont2 .write-cmt textarea {position:absolute; bottom:0; left:50%; width:80%; height:91.19%; padding:1.61rem; transform:translateX(-50%); border:0; color:#444; font-size:1.28rem; line-height:1.87;}
.cont2 .write-cmt textarea::placeholder {font-size:1.28rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; color:#999;}
.cont2 .cmt-list {padding-bottom:4.27rem; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_cmt_list2.png) repeat-y 0 -15%/100% auto;}
.cont2 .cmt-list h4 {padding:3.41rem 0 2.35rem;}
.cont2 .cmt-list ul {padding:0 1.71rem; color:#444;}
.cont2 .cmt-list ul li {width:21.33rem; margin-bottom:3.41rem;}
.cont2 .cmt-list ul li:nth-child(2n) {margin-left:auto;}
.cont2 .cmt-list .thumbnail {overflow:hidden; position:relative; width:100%; height:21.33rem; border-radius:.64rem;}
.cont2 .cmt-list .thumbnail .num {position:absolute; top:.85rem; left:.85rem; z-index:10; height:1.71rem; padding:0 0.85rem; background-color:#fff; font-size:1.19rem; line-height:1.96rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; color:#666; border-radius:.85rem;}
.cont2 .cmt-list .user-info {display:flex; align-items:center; margin-top:.85rem;}
.cont2 .cmt-list .user-grade {display:inline-block; width:2.81rem; height:2.81rem; margin-right:.55rem; background-repeat:no-repeat; background-size:cover; background-position:50% 50%;}
.cont2 .cmt-list .user-id {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.41rem;}
.cont2 .cmt-list .white {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_white.png)}
.cont2 .cmt-list .red {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_red.png)}
.cont2 .cmt-list .vip {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_vip.png)}
.cont2 .cmt-list .vvip {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_vvip.png)}
.cont2 .cmt-list .vvipgold {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_vvipgold.png)}
.cont2 .cmt-list .btn-group {margin-left:auto;}
.cont2 .cmt-list .btn-modify {margin-right:.34rem;}
.cont2 .cmt-cont {position:relative; margin-top:.51rem; font-size:1.28rem; line-height:1.33;}
.cont2 .cmt-cont textarea {position:absolute; top:0; left:0; width:100%; height:100%; padding:0; border-radius:0; border:0; background-color:transparent; font-size:1.28rem; line-height:1.33; color:#444;}
.cont2 .cmt-wrap.modifying .cmt-cont > div {color:transparent;}
.cont2 .cmt-wrap.modifying .btn-delete {display:none;}
.cont2 .cmt-wrap.modifying .btn-submit {display:inline-block; }
.cont2 .lyr {position:fixed; top:0; left:0; z-index:30; width:100vw; height:100vh; padding:3.84rem 0 7.68rem;}
.cont2 .lyr .inner {position:relative; margin:0 1.71rem;}
.cont2 .lyr .btn-close {position:absolute; top:0; right:0; width:14vw; height:14vw; text-indent:-999em;}
.lyr-dr {overflow:scroll; background-color:rgba(208, 208, 208, .9);}
.lyr-dr .inner {background-color:#fff;}
.lyr-dr ul {display:flex; flex-wrap:wrap; justify-content:space-between; padding:0 1.71rem;}
.lyr-dr ul li {width:12.16rem; margin-bottom:1.92rem;}
.lyr-dr ul li .prd-name {overflow:hidden; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; margin-top:.43rem; font-size:1.19rem; line-height:1.44; text-overflow:ellipsis; word-break:break-all;}
.lyr-cmp {background-color:rgba(255,255,255,.9);}
.lyr-cmp .btn-share {position:absolute; top:48%; left:0; width:100%; height:20%; text-indent:-999em;}
</style>
<script>
var _selectedPdt=0;
var _selectedPdtIMG="";
$(function(){
	// tab
<% if evtdiv="evt1" then %>
	$(".tabContent").hide();
	$("#cont1").show();
<% elseif evtdiv="evt2" then %>
	$(".tabContent").hide();
	$("#cont2").show();
<% elseif evtdiv="evt3" then %>
	$(".tabContent").hide();
	$("#cont3").show();
<% end if %>

	$(".tab-nav li a").click(function(){
		console.log('ooo');
		var thisCont = $(this).attr("href");
		$(".tabContent").hide();
		$(thisCont).show();
		return false;
	});

	// tab fixed
	var nav = $(".tab-nav"),
		navY = nav.offset().top;
	$(window).on('scroll', function () {
		var st = $(this).scrollTop();
		if(st > navY) {
			nav.addClass("fixed");			
		} else {
			nav.removeClass("fixed");
		}        
	});



	// EVT1 코멘트 수정
    $('.cont1 .btn-modify').click(function (e) {		
		var cmt_wrap = $(this).parents('.cmt-wrap'),
			cmt_cont = cmt_wrap.children('.cmt-cont'),
			cmt_txt = cmt_cont.children('div').text(),
			cmt_textarea;

		cmt_wrap.addClass('modifying');
		cmt_cont.append('<input type="text" name="etxtcomm2" id="etxtcomm2">');
		cmt_textarea = cmt_cont.children('input');
		cmt_textarea.val(cmt_txt).focus();

		$('.btn-submit').click(function (e) {
			cmt_wrap.removeClass('modifying');
			cmt_txt = cmt_textarea.val();
			cmt_cont.children('div').text(cmt_txt);
			cmt_textarea.remove();
		});
    });

	// EVT2 레이어: 다이어리 선택 노출
	$('.cont2 .btn-selct').click(function (e) { 
		$('.lyr-dr').show();
		toggleScrolling();
		e.preventDefault();
	});

	// EVT2 레이어 닫기
	$('.cont2 .btn-close').click(function () { 
        $('.lyr').hide();
        toggleScrolling();
	});

	// EVT2 코멘트 수정
    $('.cont2 .btn-modify').click(function (e) {		
		var cmt_wrap = $(this).parents('.cmt-wrap'),
			cmt_cont = $(this).parents('.user-info').siblings('.cmt-cont'),
			cmt_txt = cmt_cont.children('div').text(),
			cmt_textarea;

		cmt_wrap.addClass('modifying');
		cmt_cont.append('<textarea name="etxtcomm" id="etxtcomm" cols="30" rows="10"></textarea>');
		cmt_textarea = cmt_cont.children('textarea');
		cmt_textarea.val(cmt_txt).focus();

		$('.btn-submit').click(function (e) {
			cmt_wrap.removeClass('modifying');
			cmt_txt = cmt_textarea.val();
			cmt_cont.children('div').text(cmt_txt);
			cmt_textarea.remove();
		});
	});

	$("#txtcomm2").keyup(function (event) {
		regexp = /[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g;
		v = $(this).val();
		if (regexp.test(v)) {
			alert("한글만 입력가능 합니다.");
			$(this).val(v.replace(regexp, ''));
		}
	});

	$("#etxtcomm2").keyup(function (event) {
		regexp = /[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g;
		v = $(this).val();
		if (regexp.test(v)) {
			alert("한글만 입력가능 합니다.");
			$(this).val(v.replace(regexp, ''));
		}
	});

    getDiaryItems(1);
	jsGoComPage(1);
	jsGoComPage2(1);
});

// 모달 호출될 때, 부모창 스크롤 방지
function toggleScrolling() {
    if ($('.lyr-dr').is(':visible')) {
        CurrentY = $(window).scrollTop();
        $('html, body').addClass('not-scroll');
    } else {
        $('html, body').removeClass('not-scroll');
        $('html, body').animate({scrollTop :CurrentY}, 0);
    }
}

function sharesns(snsnum) {		
	$.ajax({
		type: "GET",
		url:"/event/lib/doEventCommentProc.asp",
		data: "mode=snschk&snsnum="+snsnum,
		dataType: "JSON",			
		success: function(res){
			isShared = "True"
			if(snsnum=="fb"){
				<% if isapp then %>
				fnAPPShareSNS('fb','<%=appfblink%>');
				return false;
				<% else %>
				popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
				<% end if %>
			}else{
				<% if isapp then %>
					fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
					return false;
				<% else %>
					event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
				<% end if %>
			}					
		},
		error: function(err){
			alert('잘못된 접근입니다.')
		}
	})
}

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
			if(!$("#txtcomm2").val()){
				alert("코멘트를 적어주세요!");
				return false;
			}

			if (GetByteLength($("#txtcomm2").val()) < 12 || GetByteLength($("#txtcomm2").val()) > 12){
				alert("6글자로 채워주세요");
				return false;
			}
			var makehtml="";
			var returnCode, itemid, data
			var data={
				mode: "addcomment",
				txtcomm: $("#txtcomm2").val()
			}
			$.ajax({
				type:"POST",
				url:"/event/lib/doEventCommentProc.asp",
				data: data,
				dataType: "JSON",
				success : function(res){
					fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|tap1')
						if(res!="") {
							// console.log(res)
							if(res.response == "ok"){
								makehtml = '\
								<li id="list_' + res.cidx + '">\
									<div class="cmt-wrap">\
										<div class="btn-group">\
											<button class="btn-modify" onclick="fnMyCommentEdit2(' + res.cidx + ')">수정하기</button>\
											<button class="btn-submit" onclick="fnEditComment2(' + res.cidx + ');">확인</button>\
										</div>\
										<div class="cmt-cont">\
											<div>' + $("#txtcomm2").val() + '</div>\
										</div>\
										<div class="user-info"><%=userid%>님</div>\
									</div>\
								</li>\
								'
								$("#clist2").prepend(makehtml);
								$("#txtcomm2").val("");
								alert(res.returnstr);
								return false;
							}else{
								alert(res.faildesc);
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.1");
							document.location.reload();
							return false;
						}
				},
				error:function(err){
					console.log(err)
					alert("잘못된 접근 입니다2.");
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function event2Try(){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
            <% if commentcount>=1 then %>
                alert("이벤트는 1회 참여 가능 합니다.");
				return false;
            <% else %>
                if (_selectedPdt==0){
					alert("다이어리를 선택해주세요.");
					return false;
				}

                if(!$("#txtcomm").val()){
					alert("코멘트를 적어주세요!");
					return false;
				}

				if (GetByteLength($("#txtcomm").val()) < 20){
					alert("최소 10자 이상 입력해주세요.");
					return false;
				}
                var makehtml="";
                var returnCode, itemid, data
                var data={
                    mode: "add",
                    selectedPdt: _selectedPdt,
                    selectedPdtIMG: _selectedPdtIMG,
                    txtcomm: $("#txtcomm").val()
                }
                $.ajax({
                    type:"POST",
                    url:"/event/lib/doEventCommentProc.asp",
                    data: data,
                    dataType: "JSON",
                    success : function(res){
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + _selectedPdt)
                            if(res!="") {
                                // console.log(res)
                                if(res.response == "ok"){
                                    makehtml = '\
                                    <li id="list' + res.cidx + '">\
                                        <div class="thumbnail">\
                                        <a href="" onclick="fnAPPpopupBrowserURL(\'상품정보\',\'http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=' + _selectedPdt + '&pEtr=<%=eCode%>\');return false;" class="mApp"><img src="' + _selectedPdtIMG + '" alt=""></a>\
                                        <a href="http://m.10x10.co.kr/category/category_itemprd.asp?itemid=' + _selectedPdt + '&pEtr=<%=eCode%>" class="mWeb"><img src="' + _selectedPdtIMG + '" alt=""></a>\
                                        </div>\
                                        <div class="cmt-wrap">\
                                            <div class="user-info">\
                                                <em class="user-grade vip"></em><span class="user-id"><%=userid%>님</span>\
                                                <div class="btn-group">\
                                                    <button class="btn-modify" onclick="fnMyCommentEdit(' + res.cidx + ')">수정하기</button>\
                                                    <button class="btn-delete" onclick="fnDelComment(' + res.cidx + ');">삭제하기</button>\
                                                    <button class="btn-submit" onclick="fnEditComment(' + res.cidx + ');">확인</button>\
                                                </div>\
                                            </div>\
                                            <div class="cmt-cont">\
												<div>' + $("#txtcomm").val() + '</div>\
                                            </div>\
                                        </div>\
                                    </li>\
                                    '
                                    $("#resultpop").show();
                                    _selectedPdt=0;
                                    _selectedPdtIMG="";
                                    $('#selectitem').hide();
                                    $("#clist").prepend(makehtml);
									$("#txtcomm").val("");
                                    return false;
                                }else{
                                    alert(res.faildesc);
                                    return false;
                                }
                            } else {
                                alert("잘못된 접근 입니다.1");
                                document.location.reload();
                                return false;
                            }
                    },
                    error:function(err){
                        console.log(err)
                        alert("잘못된 접근 입니다2.");
                        return false;
                    }
                });
            <% end if %>
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function getDiaryItems(vpage){
    var deliType   = "";
    var giftdiv     = "";
    var pageSize    = 200;
    var SubShopCd   = 100;

    $.ajax({
        type: "POST",
        url: "/diarystory2021/api/diaryItems.asp",
        data: {
            srm: "bs",
            cpg: vpage,
            pageSize: pageSize,
            SubShopCd: SubShopCd,
            deliType: deliType,
            giftdiv: giftdiv,
            attribCd: '',
            colorCd: '',
            subShopGroupCode : '100101',
            cateCode : '',
        },
        dataType: "json",
        success: function(Data){
            items = Data.items
            renderItemList(items)
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            //$("#listContainer").empty();
        }
    })
}

function renderItemList(itemList){
	var $rootEl = $("#itemList")
	var itemEle = tmpEl = ""
    $rootEl.empty();
    <%'// 오픈 리스트 %>
	if(itemList.length > 0){
        var newArr = itemList
		newArr.forEach(function(item){

            tmpEl = '\
                <li onclick="fnselectItem('+ item.itemid + ',\'' + item.itemImg +'\')" style="cursor:pointer">\
                    <div class="thumbnail"><img src="' + item.itemImg + '" alt=""></div>\
                    <div class="prd-name">' + item.itemName + '</div>\
                </li>\
            '
		    itemEle += tmpEl        
        });
	}
	<%'// 대기 리스트 %>
	$rootEl.append(itemEle)
}

function jsGoComPage(vpage){
    $.ajax({
        type: "POST",
        url: "/event/etc/inc_105778list.asp",
        data: {
            iCC: vpage
        },
        success: function(Data){
            $("#commentlist").html(Data);
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            //$("#listContainer").empty();
        }
    })
}

function jsGoComPage2(vpage){
    $.ajax({
        type: "POST",
        url: "/event/etc/inc_105778list2.asp",
        data: {
            iCC: vpage
        },
        success: function(Data){
            $("#commentlist2").html(Data);
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            //$("#listContainer").empty();
        }
    })
}

function fnselectItem(itemid,itemimg){
    _selectedPdt=itemid;
    _selectedPdtIMG=itemimg;
    itemimg = itemimg.replace("w=240","w=360");
    itemimg = itemimg.replace("h=240","h=360")
    $('#selectitem').show();
    $('#itemimg').attr('src',itemimg);
    $('.lyr').hide();
    toggleScrolling();
}

function fnDeleteDiary(){
    _selectedPdt=0;
    _selectedPdtIMG="";
    $('#selectitem').hide();
}

function fnDelComment(Cindex){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
        if(confirm("삭제 하시겠습니까?")){
			var returnCode, itemid, data
			var data={
				mode: "del",
				Cidx: Cindex
			}
			$.ajax({
				type:"POST",
				url:"/event/lib/doEventCommentProc.asp",
				data: data,
				dataType: "JSON",
				success : function(res){
					if(res!=""){
						if(res.response == "ok"){
							$("#list"+Cindex).hide();
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					}else {
						alert("잘못된 접근 입니다.");
						document.location.reload();
						return false;
					}
				},
				error:function(err){
					console.log(err)
					alert("잘못된 접근 입니다.");
					return false;
				}
			});
		}
    <% end if %>
}

function fnEditComment(Cindex){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
            var _txtcomm = $("#etxtcomm").val();
            if(!$("#etxtcomm").val()){
                alert("코멘트를 적어주세요!");
                return false;
            }

            if (GetByteLength($("#etxtcomm").val()) < 20){
                alert("최소 10자 이상 입력해주세요.");
                return false;
            }
            var returnCode, itemid, data
            var data={
                mode: "edit",
                Cidx: Cindex,
                txtcomm: $("#etxtcomm").val()
            }
            $.ajax({
                type:"POST",
                url:"/event/lib/doEventCommentProc.asp",
                data: data,
                dataType: "JSON",
                success : function(res){
                    if(res!="") {
                        // console.log(res)
                        if(res.response == "ok"){
							var cmt_wrap = $("#list"+Cindex).children(".cmt-wrap"),
								cmt_cont = cmt_wrap.children('.cmt-cont'),
								cmt_txt = cmt_cont.children('div').text(),
								cmt_textarea;
							cmt_wrap.removeClass('modifying');
							cmt_textarea = cmt_cont.children('textarea');
							cmt_txt = cmt_textarea.val();
							cmt_cont.children('div').text(_txtcomm);
							cmt_textarea.remove();
                            return false;
                        }else{
                            alert(res.faildesc);
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다.");
                        document.location.reload();
                        return false;
                    }
                },
                error:function(err){
                    console.log(err)
                    alert("잘못된 접근 입니다.");
                    return false;
                }
            });
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function fnEditComment2(Cindex){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
            var _txtcomm2 = $("#etxtcomm2").val();
            if(!$("#etxtcomm2").val()){
                alert("코멘트를 적어주세요!");
                return false;
			}
            if (GetByteLength($("#etxtcomm2").val()) < 12 || GetByteLength($("#etxtcomm2").val()) > 12){
				alert("6글자로 채워주세요");
				return false;
			}
            var returnCode, itemid, data
            var data={
                mode: "editcomment",
                Cidx: Cindex,
                txtcomm: $("#etxtcomm2").val()
            }
            $.ajax({
                type:"POST",
                url:"/event/lib/doEventCommentProc.asp",
                data: data,
                dataType: "JSON",
                success : function(res){
                    if(res!="") {
                        // console.log(res)
                        if(res.response == "ok"){
							var cmt_wrap = $("#list_"+Cindex).children(".cmt-wrap"),
								cmt_cont = cmt_wrap.children('.cmt-cont'),
								cmt_txt = cmt_cont.children('div').text(),
								cmt_textarea;
							cmt_wrap.removeClass('modifying');
							cmt_textarea = cmt_cont.children('input');
							cmt_txt = cmt_textarea.val();
							cmt_cont.children('div').text(_txtcomm2);
							cmt_textarea.remove();
                            return false;
                        }else{
                            alert(res.faildesc);
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다.");
                        document.location.reload();
                        return false;
                    }
                },
                error:function(err){
                    console.log(err)
                    alert("잘못된 접근 입니다.");
                    return false;
                }
            });
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	}
}

function fnMyCommentEdit(idx){
	var cmt_wrap = $("#list"+idx).children(".cmt-wrap"),
		cmt_cont = cmt_wrap.children('.cmt-cont'),
		cmt_txt = cmt_cont.children('div').text(),
		cmt_textarea;
	cmt_wrap.addClass('modifying');
	cmt_cont.append('<textarea name="etxtcomm" id="etxtcomm" cols="30" rows="10"></textarea>');
	cmt_textarea = cmt_cont.children('textarea');
	cmt_textarea.val(cmt_txt).focus();
}

function fnMyCommentEdit2(idx){
	var cmt_wrap = $("#list_"+idx).children(".cmt-wrap"),
		cmt_cont = cmt_wrap.children('.cmt-cont'),
		cmt_txt = cmt_cont.children('div').text(),
		cmt_textarea;
	cmt_wrap.addClass('modifying');
	cmt_cont.append('<input type="text" name="etxtcomm2" id="etxtcomm2">');
	cmt_textarea = cmt_cont.children('input');
	cmt_textarea.val(cmt_txt).focus();
}

</script>

			<div class="mEvt105778">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/tit_dr.png" alt="깜짝이벤트"></h2>
                <div class="tab-nav">
					<%'<!-- for dev msg 오픈일 ~ 9/27 노출 -->%>
					<% If (currentDate >= eventStartDate And currentDate < "2020-09-28") Then %>
					<ul class="tab-nav1">
						<li class="tab1"><a href="#cont1">EVENT1</a></li>
						<li class="tab2"><a href="#cont2">EVENT2</a></li>
						<li class="tab3"><a href="#cont3">EVENT3</a></li>
					</ul>
					<% else %>
					<%'<!-- for dev msg 9/28 부터 노출%>
					<ul class="tab-nav2">
						<li class="tab1"><a href="#cont1">EVENT1</a></li>
						<li class="tab2"><a href="#cont2">EVENT2</a></li>
					</ul>
					<% end if %>
				</div>
                <div class="tab-container">
					<!-- EVT1 -->
					<div id="cont1" class="tabContent cont1">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_evt1.png" alt="6글자로 말해요!"></h3>
						<div class="cmt-evt">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/btn_submit1.png" alt="">
							<div class="write-cmt">
								<input type="text" name="txtcomm2" id="txtcomm2" vcheck="kr" placeholder="<%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>6글자로 적어주세요<%END IF%>" onClick="jsCheckLimit();"<%IF NOT(IsUserLoginOK) THEN%> readonly<%END IF%>>
								<button class="btn-submit" onclick="eventTry(); return false;">입력</button>
							</div>
						</div>
						<div class="cmt-list" id="commentlist2"></div>
						<a href="/diarystory2021/" class="btn-go mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_dr21.png" alt="다이어리스토리 바로가기"></a>
						<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '2021 다이어리', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/index.asp')" class="btn-go mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_dr21.png" alt="다이어리스토리 바로가기"></a>
					</div>

					<!-- EVT2 -->
					<div id="cont2" class="tabContent cont2">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_evt2.png" alt="다이어리를 골라봐"></h3>
						<div class="cmt-evt">
							<div class="selct-dr">
								<button class="btn-selct" id="selectdiary"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/btn_selct.png" alt="클릭하여 다이어리를 골라주세요."></button>
								<div class="thumbnail" id="selectitem" style="display:none"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic/300/B003006219-2.jpg" id="itemimg"><button class="btn-delete" onclick="fnDeleteDiary();">삭제하기</button></div>
							</div>
							<div class="write-cmt">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/bg_textarea.png" alt="">
								<textarea name="txtcomm" id="txtcomm" cols="30" rows="10" onClick="jsCheckLimit();" placeholder="이유를 100자 이내로 작성해주세요."></textarea>
							</div>
							<button class="btn-submit" onclick="event2Try();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/btn_submit2.png" alt="입력"></button>
							<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_noti.png" alt="당첨자 발표일 :10월 14일 * 공지사항 기재 및 개별 연락 예정"></p>
						</div>
						<button onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_share2.png" alt="친구에게 공유하면 당첨 확률 UP!"></button>
                        <div class="cmt-list" id="commentlist"></div>
						<!-- 레이어: 다이어리 선택 -->
						<div class="lyr lyr-dr" style="display:none;">
							<div class="inner">
								<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_pop1.png" alt="원하는 다이어리를 골라보세요!"></p>
								<ul id="itemList"></ul>
								<button class="btn-close">닫기</button>
							</div>
						</div>

						<!-- 레이어: 응모완료 -->
						<div class="lyr lyr-cmp" id="resultpop" style="display:none;">
							<div class="inner">
								<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_pop2.png" alt="입력이 완료되었습니다!"></p>
								<button class="btn-share" onclick="sharesns('ka')">카카오공유</button>
								<button class="btn-close">닫기</button>
							</div>
						</div>
					</div>

					<!-- EVT3 -->
					<div id="cont3" class="tabContent">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/txt_evt3.png" alt="포토후기를 남겨요"></h3>
						<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank" class="mApp">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/btn_review.png" alt="후기 작성하러 가기">
						</a>
						<a href="/my10x10/goodsusing.asp" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/btn_review.png" alt="후기 작성하러 가기"></a>
					</div>
				</div>
			</div>