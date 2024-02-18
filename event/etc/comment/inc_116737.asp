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
' Description : 박스테이프 공모전
' History : 2022.01.19 정태훈
'#################################################################
%>
<%
dim currentDate, mktTest, eventStartDate, eventEndDate
Dim eCode , userid , pagereload , vDIdx, newAdd
IF application("Svr_Info") = "Dev" THEN
	eCode = "109449"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "116737"
    mktTest = True
Else
	eCode = "116737"
    mktTest = False
End If

eventStartDate  = cdate("2022-01-24")		'이벤트 시작일
eventEndDate 	= cdate("2022-02-06")		'이벤트 종료일

if mktTest then
    currentDate = cdate("2022-01-24")
else
    currentDate = date()
end if


dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If

vDIdx = request("didx")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)
    newAdd	= requestCheckVar(request("newAdd"),2)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 6		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 6		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6		'메뉴가 있으면 10개		'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt      '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt            '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

dim sqlstr, evtcom_txt
if newAdd="ON" then
	sqlstr = "select top 1 "
	sqlstr = sqlstr & " c.evtcom_txt"
	sqlstr = sqlstr & " from db_event.dbo.tbl_event_comment c"
	sqlstr = sqlstr & " where c.evt_code="& eCode &""
    sqlstr = sqlstr & " and c.userid='"& userid &"'"
    sqlstr = sqlstr & " order by evtcom_idx desc"
    rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		evtcom_txt = rsget("evtcom_txt")
	END IF
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("텐바이텐 박스테이프 카피 공모전")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "텐바이텐 박스테이프 카피 공모전"
Dim kakaodescription : kakaodescription = "10초 만에 참여할 수 있는 공모전이 있다? 즉시 도전해보세요!"
Dim kakaooldver : kakaooldver = "10초 만에 참여할 수 있는 공모전이 있다? 즉시 도전해보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
@font-face {font-family:'10x10'; src:url('//fiximage.10x10.co.kr/webfont/10x10.woff') format('woff'), url('//fiximage.10x10.co.kr/webfont/10x10.woff2') format('woff2'); font-style:normal; font-weight:normal;}
.box-tape {background-color:#f2d6bf;}
.box-tape h2 {position:relative;}
.box-tape h2 .tit {position:absolute; left:50%; top:25%; width:65.33vw; margin-left:-32.5vw; opacity:0; transform:translateY(5%); transition:all 1s;}
.box-tape h2 .txt {position:absolute; left:50%; top:38%; width:64.26vw; margin-left:-32vw; opacity:0; transform:translateY(5%); transition:all 1s .3s;}
.box-tape h2 .txt.on,
.box-tape h2 .tit.on {opacity:1; transform:translateY(0);}
.box-tape .section-01 {position:relative;}
.box-tape .section-01 .txt01 {position:absolute; left:50%; top:14%; width:59.86vw; margin-left:-29.93vw;}
.box-tape .section-01 .txt02 {position:absolute; left:50%; top:50%; width:47.6vw; margin-left:-23.8vw;}
.box-tape .section-01 .txt03 {position:absolute; left:50%; top:75%; width:63.33vw; margin-left:-31.66vw;}
.box-tape .btn-detail {position:relative;width:100%;}
.box-tape .btn-detail .icon {width:0.93rem; height:0.59rem; position:absolute; left:50%; top:63%; margin-left:15vw;}
.box-tape .noti {display:none;}
.box-tape .noti.on {display:block;}
.box-tape .icon.on {transform: rotate(180deg);top:60%;}
.box-tape .icon {transform: rotate(0);}
.box-tape .apply-area {position:relative;}
.box-tape .apply-area .btn-apply {width:100%; height:10rem; position:absolute; left:0; bottom:30%; background:transparent;}
.box-tape .apply-input {position:relative;}
.box-tape .apply-input input {position:absolute; left:50%; top:41%; transform:translate(-50%,0); margin:0 auto; padding:0; border:0; background:transparent; text-align:center; font-size:1.49rem; color:#fff; width:calc(100% - 6.82rem); height:2.98rem;}
.box-tape .apply-input input::placeholder {opacity:0.45; color:#fff;}
.box-tape .section-04 {padding-bottom:8.32rem; background:#c6a378;}
.box-tape .section-04 .tit {position:relative;}
.box-tape .section-04 .tit .icon {width:5.33vw; position:absolute; right:7%; bottom:4%; animation: wing 1s alternate infinite;}
.box-tape .section-04 .copy-list {position:relative;}
.box-tape .section-04 .copy-list.copy-pd {padding-top:4.35rem;}
.box-tape .section-04 .copy-list .num-th {width:19.07vw; position:absolute; left:5%; bottom:15%;}
.box-tape .section-04 .copy-list .list {display:flex; align-items:center; overflow-x: scroll; width:100%; height:4.90rem; padding-left:8.10rem; background:#f70d0d;}
.box-tape .section-04 .copy-list .list img {margin-right:2.56rem;}
.box-tape .section-04 .copy-list .list01 .txt01 img {width:62.40vw;}
.box-tape .section-04 .copy-list .list01 .txt02 img {width:64.20vw;}
.box-tape .section-04 .copy-list .list01 .txt03 img {width:40.53vw;}
.box-tape .section-04 .copy-list .list01 .txt04 img {width:34.13vw;}
.box-tape .section-04 .copy-list .list01 .txt05 img {width:55.87vw;}

.box-tape .section-04 .copy-list .list02 .txt01 img {width:50.67vw;}
.box-tape .section-04 .copy-list .list02 .txt02 img {width:44.27vw;}
.box-tape .section-04 .copy-list .list02 .txt03 img {width:53.33vw;}
.box-tape .section-04 .copy-list .list02 .txt04 img {width:37.60vw;}
.box-tape .section-04 .copy-list .list02 .txt05 img {width:61.87vw;}

.box-tape .section-04 .copy-list .list03 .txt01 img {width:55.87vw;}
.box-tape .section-04 .copy-list .list03 .txt02 img {width:32.40vw;}
.box-tape .section-04 .copy-list .list03 .txt03 img {width:39.87vw;}
.box-tape .section-04 .copy-list .list03 .txt04 img {width:41.60vw;}
.box-tape .section-04 .copy-list .list03 .txt05 img {width:41.07vw;}

.box-tape .section-04 .copy-list .list04 .txt01 img {width:49.47vw;}
.box-tape .section-04 .copy-list .list04 .txt02 img {width:59.60vw;}
.box-tape .section-04 .copy-list .list04 .txt03 img {width:54.53vw;}
.box-tape .section-04 .copy-list .list04 .txt04 img {width:48.27vw;}
.box-tape .section-04 .copy-list .list04 .txt05 img {width:63.33vw;}

.box-tape .section-04 .copy-list .list05 .txt01 img {width:56.13vw;}
.box-tape .section-04 .copy-list .list05 .txt02 img {width:59.07vw;}
.box-tape .section-04 .copy-list .list05 .txt03 img {width:45.33vw;}
.box-tape .section-04 .copy-list .list05 .txt04 img {width:62.00vw;}
.box-tape .section-04 .copy-list .list05 .txt05 img {width:53.33vw;}

.box-tape .section-04 .copy-list .list06 .txt01 img {width:63.33vw;}
.box-tape .section-04 .copy-list .list06 .txt02 img {width:39.2vw;}
.box-tape .section-04 .copy-list .list06 .txt03 img {width:74.93vw;}
.box-tape .section-04 .copy-list .list06 .txt04 img {width:56.7vw;}
.box-tape .section-04 .copy-list .list06 .txt05 img {width:40.4vw;}

.box-tape button {background-color:transparent;}
.box-tape .box-font {position:relative;}
.box-tape .box-font a {display:block; position:absolute; top:0; left:0; width:100%; height:100%; text-indent:-999em;}
.box-tape .contest {position:relative;}
.box-tape .contest .tab-nav {overflow:hidden; position:absolute; left:6.66%; top:2.26%; width:86.34%; height:22.67%;}
.box-tape .contest .tab-nav li {float:left; width:33.33333%; height:100%; text-indent:-999em; cursor:pointer;}
.box-tape .cmt-section .input-wrap {position:relative;}
.box-tape .cmt-section .input-wrap input {position:absolute; top:0; left:0; width:100%; height:100%; padding:0 41.33% 0 12%; font-size:1.28rem; background-color:transparent; border-color:transparent;}
.box-tape .cmt-section .input-wrap input::placeholder {color:#b6b6b6;}
.box-tape .cmt-section .input-wrap .btn-submit {position:absolute; top:0; right:8.53%; width:28.8%; height:100%;}
.box-tape .cmt-section .cmt-wrap {background:#f5e0c6;}
.box-tape .cmt-section .cmt-list {padding:0 8%;}
.box-tape .cmt-section .cmt-list li {position:relative; margin-bottom:1.45rem; padding:1.28rem 1.92rem; background-color:#f70d0d;}
.box-tape .cmt-section .cmt-list li:nth-child(even) {background-color:#ff7272;}
.box-tape .cmt-section .cmt-list .info {display:flex; justify-content:space-between; color:#ffe87f; font-size:.64rem;}
.box-tape .cmt-section .cmt-list .info .writer {color:#ffe2cd;}
.box-tape .cmt-section .cmt-list .copy {margin-top:1.02rem; color:#fff; font-size:1.28rem; font-family:'10x10';}
.box-tape .cmt-section .cmt-list .btn-delete {position:absolute; top:0; right:0; width:1.58rem; height:1.58rem; background-image:url(//webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_cmt_del.png); background-size:100%; text-indent:-999em;}
.box-tape .pageWrapV15 {padding:1.2rem 0 5.65rem;}
.box-tape .pagingV15a {position:relative; height:100%; margin:0;}
.box-tape .pagingV15a span {display:inline-block; height:2.6rem; margin:0; padding:0 1.49rem; border:0; color:#f33f27; font-weight:bold; font-size:1.28rem; line-height:2.6rem; border:1px red;}
.box-tape .pagingV15a span.arrow {display:inline-block; position:absolute; top:50%; transform:translateY(-50%); width:2.31rem; height:2.31rem; padding:0;}
.box-tape .pagingV15a span.arrow.prevBtn {left:8.4%;}
.box-tape .pagingV15a span.arrow.nextBtn {right:8.4%;}
.box-tape .pagingV15a span.arrow a {width:100%; background-size:100% 100%;}
.box-tape .pagingV15a span.arrow a:after {display:none;}
.box-tape .pagingV15a span.arrow.prevBtn a{background-image:url(//webimage.10x10.co.kr/fixevent/event/2022/116737/m/icon_arrow_left.png);}
.box-tape .pagingV15a span.arrow.nextBtn a{background-image:url(//webimage.10x10.co.kr/fixevent/event/2022/116737/m/icon_arrow_right02.png);}
.box-tape .pagingV15a .current {padding:0 1.01rem; background-color:#f33f27; color:#fff; border-radius:50%;}
.box-tape .rolling {position:relative; background:#f4e5d5;}
.box-tape .rolling .pagination {position:absolute; bottom:8.18%; z-index:30; width:100%; height:1rem; padding:0; text-align:center;}
.box-tape .rolling .pagination span {display:inline-block; width:0.75rem; height:0.75rem; margin:0 0.43rem; border:0.128rem solid #b70000; background-color:transparent; transition:all 0.4s ease;}
.box-tape .rolling .pagination .swiper-active-switch {width:0.75rem; height:0.75rem; border:0.128rem solid #b70000; background-color:#b70000;}
.box-tape .animate {opacity:0; transform:translateY(10%); transition:all 1s;}
.box-tape .animate.on {opacity:1; transform:translateY(0);}
.box-tape .pop-container {position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.741); z-index:150;}
.box-tape .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.box-tape .pop-container .pop-inner a {display:inline-block;}
.box-tape .pop-container .pop-inner .btn-close {position:absolute; right:4vw; top:4.2vw; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2022/116737/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.box-tape .pop-container .pop-contents {position:relative;top:50%; left:50%; transform:translate(-50%,-50%); max-width:32rem;}
.box-tape .pop-container .pop-contents .copy {position:absolute; left:50%; top:25%; transform:translate(-50%,0); overflow:hidden; margin:0 auto; padding:0; border:0; background:transparent; text-align:center; font-size:1.23rem; color:#fff; width:calc(100% - 6.82rem); height:2.98rem; line-height:3rem;font-family:'10x10';}
.box-tape .pop-container .pop-contents .inner-txt {width:100%; position:absolute; left:50%; top:52%; transform:translate(-50%,0); text-align:center;}
.box-tape .pop-container .pop-contents .inner-txt p {padding-bottom:.7rem; color:#111; font-size:1.36rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.box-tape .pop-container .pop-contents .inner-txt p:nth-child(2) {padding-bottom:2rem;}
.box-tape .pop-container .pop-contents .inner-txt .id span {text-decoration:underline; text-decoration-color:#111;}
.box-tape .pop-container .pop-contents .inner-txt .day {font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.box-tape .pop-container .pop-contents .btn-share {width:100%; height:10rem; position:absolute; left:0; bottom:0; background:transparent;}
@keyframes wing {
    0% {transform: translateX(-.5rem);}
    100% {transform: translateX(.5rem);}
}
</style>
<script>
$(function(){
	swiper = new Swiper(".rolling .swiper-container",{
		loop:true,
		autoplay:false,
		speed:600,
		pagination:".rolling .pagination",
		effect:"fade"
	});
    $(".contest .tab-content").hide();
    $(".contest .tab-container").find(".tab-content:first").show();
    $(".contest .tab-nav li").click(function() {
        $(this).siblings("li").removeClass("current"); 
        $(this).addClass("current");
        $(this).closest(".contest .tab-nav").nextAll(".contest .tab-container:first").find(".tab-content").hide();
        var activeTab = $(this).attr("name");
        $(".tab-content[id|='"+ activeTab +"']").show();
    });
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.animate').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });
    $('h2 .tit, h2 .txt').addClass('on');
    // btn more
	$('.mEvt116737 .btn-detail').click(function (e) { 
		$(this).next().toggleClass('on');
        $(this).find('.icon').toggleClass('on');
	});
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".cmt-section").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if currentDate >= eventStartDate and currentDate <= eventEndDate then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("택배 받는 순간을 즐겁게 해줄 카피를 적어주세요!");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 36){
					alert("제한길이를 초과하였습니다. 18자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}
                frm.newAdd.value="on";
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
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

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function snschk(snsnum) {		
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
}

// 카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
    Kakao.Link.sendDefault({
        objectType: 'feed',
        content: {
            title: label,
            description : description,
            imageUrl: imageurl,
            link: {
            mobileWebUrl: linkurl
            }
        },
        buttons: [
            {
            title: '웹으로 보기',
            link: {
                mobileWebUrl: linkurl
            }
            }
        ]
    });
}

function fnClosePop(){
    location.href="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON";
}
</script>
			<div class="mEvt116737 box-tape">
				<h2>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_main.jpg" alt="텐바이텐 박스테이프 카피 공모전" />
                    <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/tit_num.png" alt="제6회" /></div>
                    <div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/tit_main.png" alt="박스테이프 카피 공모전" /></div>
                </h2>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_sub01.jpg" alt="" />
                    <div class="txt01 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_sub01.png" alt=""></div>
                    <div class="txt02 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_box.png" alt=""></div>
                    <div class="txt03 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_sub02.png" alt=""></div>
                </div>
                <div class="section-02"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_sub02.jpg" alt="" /></div>
				<div class="contest">
					<ul class="tab-nav">
						<li name="info1">주제</li>
						<li name="info2">일정</li>
						<li name="info3">시상</li>
					</ul>
					<div class="tab-container">
						<div id="info1" class="tab-content"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_tab01.jpg" alt="응모기간 : 01-24 / 02-06" /></div>
						<div id="info2" class="tab-content"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_tab02.jpg" alt="상금" /></div>
						<div id="info3" class="tab-content"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_tab03.jpg" alt="선정방식" /></div>
					</div>
				</div>
                <div>
                    <button type="button" class="btn-detail">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/btn_noti.jpg" alt="유의사항 자세히 보기">
                        <span class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/icon_arrow_down.png" alt=""></span>
                    </button>
                    <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_noti.jpg" alt=""></div>
                </div>
                <div class="section-03">
                <form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
                <input type="hidden" name="mode" value="add">
                <input type="hidden" name="pagereload" value="ON">
                <input type="hidden" name="newAdd">
                <input type="hidden" name="iCC" value="1">
                <input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
                <input type="hidden" name="eventid" value="<%= eCode %>">
                <input type="hidden" name="linkevt" value="<%= eCode %>">
                <input type="hidden" name="blnB" value="">
                <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON&newAdd=ON">
                <input type="hidden" name="isApp" value="<%= isApp %>">
                <input type="hidden" name="spoint"/>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_sub03.jpg" alt="카피를 작성하고 응모해주세요." />
                    <div class="apply-input">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_input.jpg" alt="" />
                        <input type="text" placeholder="여기에 작성해주세요!" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" maxlength="18">
                    </div>
                    <div class="apply-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_sub04.jpg" alt="응모하기" />
                        <!-- 응모하기 버튼 -->
                        <button type="button" onclick="jsSubmitComment(document.frmcom);" class="btn-apply"></button>
                    </div>
                </form>
                </div>
                <div class="section-04">
                    <div class="tit">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_sub05.jpg" alt="박스테이프 카피" />
                        <div class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/icon_arrow_right01.png" alt=""></div>
                    </div>
                    <div class="copy-list">
                        <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_01th.png" alt="제 1회"></div>
                        <div class="list list01">
                            <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve_tit01.png" alt=""></div>
                            <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve_tit02.png" alt=""></div>
                            <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve_tit03.png" alt=""></div>
                            <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve_tit04.png" alt=""></div>
                            <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve_tit05.png" alt=""></div>
                        </div>
                    </div>
                    <div class="copy-list copy-pd">
                        <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_02th.png" alt="제 2회"></div>
                        <div class="list list02">
                            <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve02_tit01.png" alt=""></div>
                            <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve02_tit02.png" alt=""></div>
                            <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve02_tit03.png" alt=""></div>
                            <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve02_tit04.png" alt=""></div>
                            <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve02_tit05.png" alt=""></div>
                        </div>
                    </div>
                    <div class="copy-list copy-pd">
                        <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_03th.png" alt="제 3회"></div>
                        <div class="list list03">
                            <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve03_tit01.png" alt=""></div>
                            <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve03_tit02.png" alt=""></div>
                            <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve03_tit03.png" alt=""></div>
                            <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve03_tit04.png" alt=""></div>
                            <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve03_tit05.png" alt=""></div>
                        </div>
                    </div>
                    <div class="copy-list copy-pd">
                        <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_04th.png" alt="제 4회"></div>
                        <div class="list list04">
                            <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve04_tit01.png" alt=""></div>
                            <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve04_tit02.png" alt=""></div>
                            <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve04_tit03.png" alt=""></div>
                            <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve04_tit04.png" alt=""></div>
                            <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve04_tit05.png" alt=""></div>
                        </div>
                    </div>
                    <div class="copy-list copy-pd">
                        <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_05th.png" alt="제 5회"></div>
                        <div class="list list05">
                            <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve05_tit01.png" alt=""></div>
                            <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve05_tit02.png" alt=""></div>
                            <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve05_tit03.png" alt=""></div>
                            <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve05_tit04.png" alt=""></div>
                            <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve05_tit05.png" alt=""></div>
                        </div>
                    </div>
                    <div class="copy-list copy-pd">
                        <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_06th.png" alt="제 6회"></div>
                        <div class="list list06">
                            <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve06_tit01.png" alt=""></div>
                            <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve06_tit02.png" alt=""></div>
                            <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve06_tit03.png" alt=""></div>
                            <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve06_tit04.png" alt=""></div>
                            <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/txt_eve06_tit05.png" alt=""></div>
                        </div>
                    </div>
                </div>
                <div id="comments"></div>
				<div class="box-font">
					<img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_font.jpg" alt="제6회 박스테이프 글꼴은?" />
					<a href="http://company.10x10.co.kr/" class="mWeb" target="_blank">텐바이텐의 ‘10x10’폰트</a>
					<a href="" class="mApp" onclick="fnAPPpopupExternalBrowser('http://company.10x10.co.kr/'); return false;">텐바이텐의 ‘10x10’폰트</a>
				</div>
				<% if newAdd = "ON" then %>
                <div class="pop-container done">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/pop_done.png" alt="참여완료">
                            <!-- 카피 문구 노출 -->
                            <div class="copy">
                                <%=evtcom_txt%>
                            </div>
                            <div class="inner-txt">
                                <p class="id"><span><%=userid%></span>님,</p>
                                <p>참여가 완료되었습니다!</p>
                                <p class="day">후보작 발표일은 3월 9일입니다.</p>
                            </div>
                            <button type="button" class="btn-share" onclick="snschk('ka');"></button>
                            <button type="button" class="btn-close" onclick="fnClosePop();">닫기</button>
                        </div>
                    </div>
                </div>
                <% end if %>
			</div>
<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="isApp" value="<%= isApp %>">
</form>

<script src="/vue/event/etc/116737/comment.js?v=1.00"></script>

<!-- #include virtual="/lib/db/dbclose.asp" -->