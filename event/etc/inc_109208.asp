<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 서촌도감01 - 오프투얼론
' History : 2021.02.10 정태훈 생성
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
dim currentDate, eventStartDate, eventEndDate
	currentDate =  now()
'	currenttime = #11/10/2017 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  104316
Else
	eCode   =  109208
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if userId="ley330" or userId="greenteenz" or userId="rnldusgpfla" or userId="cjw0515" or userId="thensi7" or userId = "motions" or userId = "jj999a" or userId = "phsman1" or userId = "jjia94" or userId = "seojb1983" or userId = "kny9480" or userId = "bestksy0527" or userId = "mame234" or userid = "corpse2" then
	currentDate = #02/15/2021 09:00:00#
end if

eventStartDate  = cdate("2021-02-15")		'이벤트 시작일
eventEndDate 	= cdate("2021-02-28")		'이벤트 종료일
%>
<style>
.mEvt109208 .topic {position:relative;}
.mEvt109208 .topic .icon-arrow {width:1.08rem; position:absolute; left:50%; top:78%; transform: translate(-50%,0); animation: updown .7s ease-in-out alternate infinite;}
.mEvt109208 .section-01 .swiper-slide,
.mEvt109208 .section-02 .swiper-slide,
.mEvt109208 .section-06 .swiper-slide {width:100%;}

.mEvt109208 .section-01 {position:relative;}
.mEvt109208 .section-02 {position:relative;}
.mEvt109208 .section-02 .tit {opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt109208 .section-02 .tit.on {opacity:1; transform:translateY(0);}
.mEvt109208 .section-02 .img {opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt109208 .section-02 .img.on {opacity:1; transform:translateY(0);}
.mEvt109208 .section-02 .tit-03 button {width:100%; height:20%; position:absolute; left:50%; top:35%; transform:translate(-50%,0); background:transparent;}
.mEvt109208 .section-04 {padding-bottom:3rem; background:#da5745;}
.mEvt109208 .section-05 {position:relative; background:#e79a48;}
.mEvt109208 .section-05 .tit {position:relative;}
.mEvt109208 .section-05 .tit .btn-gift {width:100%; height:10%; position:absolute; left:0; top:66%; background:transparent;}
.mEvt109208 .section-06 {position:relative;}
.mEvt109208 .section-06 .btn-set {width:100%; height:10%; position:absolute; left:0; top:71%; background:transparent;}
.mEvt109208 .section-07 a, 
.mEvt109208 .section-08 a {display:inline-block;}

.mEvt109208 .event-dot-area {position:relative;}
.mEvt109208 .event-dot-area button {position:relative; display:inline-block; width:1.31rem; height:1.31rem; background:rgba(255,255,255,0.3); border-radius:100%; animation:wide 1s alternate infinite;}
.mEvt109208 .event-dot-area button span {position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); display:inline-block; width:0.60rem; height:0.60rem; background:#fff; border-radius:100%;}
.mEvt109208 .event-dot-area .dot {display:flex; align-items:center; justify-content:center; width:15vw; height:7vh; cursor:pointer;}
.mEvt109208 .event-dot-area .item-01 {position:absolute; left:31%; top:16%;}
.mEvt109208 .event-dot-area .item-02 {position:absolute; left:19%; top:31%;}
.mEvt109208 .event-dot-area .item-03 {position:absolute; left:64%; top:31%;}
.mEvt109208 .event-dot-area .item-04 {position:absolute; left:14%; top:46%;}
.mEvt109208 .event-dot-area .item-05 {position:absolute; left:61%; top:48%;}
.mEvt109208 .event-dot-area .item-06 {position:absolute; left:22%; top:81%;}
.mEvt109208 .event-check-book {position:relative;}
.mEvt109208 .event-check-book .item-books {display:flex; align-items:flex-start; justify-content:center; flex-wrap:wrap; height:80%; position:absolute; left:0; top:20%;}
.mEvt109208 .event-check-book .item-books li {height:44%; margin:0 1%;}
.mEvt109208 .event-check-book .item-books li button {position:relative; width:30vw; height:100%; background:transparent;}
.mEvt109208 .event-check-book .item-books li button:before {content:""; display:inline-block; width:5.6vw; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109208/m/icon_check.png) no-repeat 0 0; background-size:100%; opacity:0;}
.mEvt109208 .event-check-book .item-books li .btn-checks.on:before {opacity:1;} 
.mEvt109208 .event-check-book .item-books li:nth-child(1) button:before {position:absolute; left:62%; top:1%;}
.mEvt109208 .event-check-book .item-books li:nth-child(2) button:before {position:absolute; left:49%; top:1%;}
.mEvt109208 .event-check-book .item-books li:nth-child(3) button:before {position:absolute; left:28%; top:1%;}
.mEvt109208 .event-check-book .item-books li:nth-child(4) button:before {position:absolute; left:39%; top:-5%;}
.mEvt109208 .event-check-book .item-books li:nth-child(5) button:before {position:absolute; left:25%; top:-5%;}
.mEvt109208 .event-check-book .item-books li:nth-child(6) button:before {position:absolute; left:25%; top:-5%;}

.mEvt109208 .event-comment-book {padding:0 1.73rem; background:#e69947;}
.mEvt109208 .event-comment-book .top {width:100%; height:100%; padding:7% 0; background:#ffd3ae; border-radius:10px 10px 0 0; text-align:center;}
.mEvt109208 .event-comment-book .top div {margin:0 auto;}
.mEvt109208 .event-comment-book .top .item-book-01 {width:61.19vw;}
.mEvt109208 .event-comment-book .top .item-book-01.ch-01 {width:61.19vw;}
.mEvt109208 .event-comment-book .top .item-book-01.ch-02 {width:62.26vw;}
.mEvt109208 .event-comment-book .top .item-book-01.ch-03 {width:43.6vw;}
.mEvt109208 .event-comment-book .top .item-book-01.ch-04 {width:35.06vw;}
.mEvt109208 .event-comment-book .top .item-book-01.ch-05 {width:42.93vw;}
.mEvt109208 .event-comment-book .top .item-book-01.ch-06 {width:42vw;}
.mEvt109208 .event-comment-book .content {position:relative; padding-bottom:3rem; background:#fff; border-radius:0 0 10px 10px;}
.mEvt109208 .event-comment-book .content textarea {width:100%; height:36vh; min-height:24rem; padding:2.17rem 1.73rem 4rem; resize:none; border:0; border-radius:0 0 10px 10px; font-size:4.26vw; color:#333; line-height:1.2;}
.mEvt109208 .event-comment-book .content textarea::placeholder {font-size:4.26vw; color:#999;}
.mEvt109208 .event-comment-book .content button {width:56.93vw; position:absolute; left:50%; bottom:10%; transform:translate(-50%,0); background:transparent;}
.mEvt109208 .comment-list-wrap {margin:0 1.73rem; padding-bottom:2rem;}
/* 2020-02-10 수정 */
.mEvt109208 .event-comment-area {position:relative; padding:1.73rem; margin-top:2.17rem; background:#906230; border-radius:10px;}
.mEvt109208 .event-comment-area:first-child {margin-top:0;}
.mEvt109208 .event-comment-area .num {font-size:4vw; color:#e79a48; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt109208 .event-comment-area .id {padding-top:1rem; font-size:4vw; color:#ffc484;}
.mEvt109208 .event-comment-area .txt {height:55vw; padding-top:1.5rem; font-size:4.26vw; color:#fff; line-height:1.3; overflow:hidden;}
.mEvt109208 .event-comment-area .img {text-align:center;}
.mEvt109208 .event-comment-area .character-01 {width:23.73vw;}
.mEvt109208 .event-comment-area .character-02 {width:20.93vw;}
.mEvt109208 .event-comment-area .character-03 {width:18.66vw;}
.mEvt109208 .event-comment-area .character-04 {width:18.53vw;}
.mEvt109208 .event-comment-area .character-05 {width:23.33vw;}
.mEvt109208 .event-comment-area .character-06 {width:29.33vw;}
.mEvt109208 .event-comment-area .comment-close {position:absolute; right:1.5rem; top:1.5rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_close.png) no-repeat 0 0; background-size:100%;}
/* // */
.mEvt109208 .pagination-wrap {display:flex; align-items:center; justify-content:center; margin-top:1.5rem;}
.mEvt109208 .pagination-wrap li a {display:inline-block; padding:1.5rem; font-size:4.26vw; color:#5c2b01; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt109208 .pagination-wrap li a img {width:2vw;}

.mEvt109208 .pagination {position:absolute; right:2rem; bottom:6%; z-index:100;}
.mEvt109208 .pagination .swiper-pagination-switch.swiper-active-switch {background-color:#ec4a18;}
.mEvt109208 .pagination .swiper-pagination-switch {margin:0 0.5rem; background-color:#ededed;}

.mEvt109208 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt109208 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt109208 .pop-container .pop-inner a {display:inline-block;}
.mEvt109208 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt109208 .pop-container .pop-inner .btn-close02 {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109208/m/btn_close02.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt109208 .pop-container .pop-inner .btn-review {width:100%; height:60%; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt109208 .books .pop-contents {padding:10% 0 30%; background:#f7e2d1; opacity:0.7; text-align:center;}
.mEvt109208 .books .pop-contents.info01 img {width:66.13vw; height:auto;}
.mEvt109208 .books .pop-contents.info02 img {width:81.46vw; height:auto;}
.mEvt109208 .books .pop-contents.info03 img {width:71.46vw; height:auto;}
.mEvt109208 .books .pop-contents.info04 img {width:58.66vw; height:auto;}
.mEvt109208 .books .pop-contents.info05 img {width:72.13vw; height:auto;}
.mEvt109208 .books .pop-contents.info06 img {width:55.2vw; height:auto;}

@keyframes updown {
    0% {top:77%;}
    100% {top:79%;}
}
@keyframes wide {
    0% { transform: scale(0) }
    100% { transform: scale(1) }
}
</style>
<script>
$(function(){
    //팝업
    /* '리소 인쇄물과 진 설명보기' 팝업 */
    $('.mEvt109208 .btn-detail').click(function(){
        $('.pop-container.detail').fadeIn();
    })
    /* 선물보기 팝업 */
    $('.mEvt109208 .btn-set').click(function(){
        $('.pop-container.set').fadeIn();
    })
    /* 책 선물보기 팝업 */
    $('.mEvt109208 .btn-gift').click(function(){
        $('.pop-container.gift').fadeIn();
    })
    /* 책내용 미리보기 팝업 */
    $('.mEvt109208 .item-01.dot').click(function(){
        $('.pop-container.book01').fadeIn();
    })
    $('.mEvt109208 .item-02.dot').click(function(){
        $('.pop-container.book02').fadeIn();
    })
    $('.mEvt109208 .item-03.dot').click(function(){
        $('.pop-container.book03').fadeIn();
    })
    $('.mEvt109208 .item-04.dot').click(function(){
        $('.pop-container.book04').fadeIn();
    })
    $('.mEvt109208 .item-05.dot').click(function(){
        $('.pop-container.book05').fadeIn();
    })
    $('.mEvt109208 .item-06.dot').click(function(){
        $('.pop-container.book06').fadeIn();
    })
    /* 팝업 닫기 */
    $('.mEvt109208 .btn-close,.mEvt109208 .btn-close02').click(function(){
        $(".pop-container").fadeOut();
    })
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.section-02 .tit,.section-02 .img').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });
    /* slide */
    var swiper = new Swiper(".section-01 .swiper-container", {
        autoplay: 1,
        speed: 2000,
        slidesPerView:'auto',
        pagination:".section-01 .pagination",
        loop:true
    });
    var swiper = new Swiper(".section-02 .swiper-container", {
        autoplay: 1,
        speed: 2000,
        slidesPerView:'auto',
        pagination:".section-02 .pagination",
        loop:true
    });
    /* event check */
    $(".item-books li").on("click",function(){
        $(this).children(".btn-checks").toggleClass("on");
        $(this).siblings().find(".btn-checks").removeClass("on");
        if($(this).hasClass("item-checks-01")) {
            $(".item-book-01").addClass("ch-01");
        } else {
            $(".item-book-01").removeClass("ch-01");
        }
        if($(this).hasClass("item-checks-02")) {
            $(".item-book-01").addClass("ch-02");
        } else {
            $(".item-book-01").removeClass("ch-02");
        }
        if($(this).hasClass("item-checks-03")) {
            $(".item-book-01").addClass("ch-03");
        } else {
            $(".item-book-01").removeClass("ch-03");
        }
        if($(this).hasClass("item-checks-04")) {
            $(".item-book-01").addClass("ch-04");
        } else {
            $(".item-book-01").removeClass("ch-04");
        }
        if($(this).hasClass("item-checks-05")) {
            $(".item-book-01").addClass("ch-05");
        } else {
            $(".item-book-01").removeClass("ch-05");
        }
        if($(this).hasClass("item-checks-06")) {
            $(".item-book-01").addClass("ch-06");
        } else {
            $(".item-book-01").removeClass("ch-06");
        }    
    });
    jsGoComPage(1);
});

function fnSelectBook(booknum){
    $(".item-book-01").empty().append("<img src='//webimage.10x10.co.kr/fixevent/event/2021/109208/m/item_book0" + booknum + ".png' alt='books title'>");
    $("#booknum").val(booknum);
}

function eventTry(){
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If Not(IsUserLoginOK) Then %>
        calllogin();
        return false;
    <% else %>
            if(!$("#booknum").val()){
                alert("읽고 싶은 도서를 선택해주세요!");
                return false;
            }

            if(!$("#txtComm").val()){
                alert("도서를 읽고 싶은 이유를 적어주세요!");
                return false;
            }

            if (GetByteLength($("#txtComm").val()) > 400){
                alert("띄어쓰기 포함 200자 이내로 작성해주세요!");
                return false;
            }
            var makehtml="";
            var returnCode, itemid, data
            var data={
                mode: "add",
                booknum: $("#booknum").val(),
                txtcomm: $("#txtComm").val()
            }
            $.ajax({
                type:"POST",
                url:"/event/etc/doeventsubscript/doEventSubscript109208.asp",
                data: data,
                dataType: "JSON",
                success : function(res){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + $("#booknum").val());
                        if(res!="") {
                            // console.log(res)
                            if(res.response == "ok"){
                                $('.pop-container.apply').fadeIn();
                                $('#txtComm').val("");
								jsGoComPage(1);
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
    <% End If %>
}

function fndelComment(idx){
    <% If Not(IsUserLoginOK) Then %>
        calllogin();
        return false;
    <% else %>
        if (confirm("삭제 하시겠습니까?")){

        }
        else{
            return false;
        }
        var makehtml="";
        var returnCode, itemid, data
        var data={
            mode: "del",
            Cidx: idx
        }
        $.ajax({
            type:"POST",
            url:"/event/etc/doeventsubscript/doEventSubscript109208.asp",
            data: data,
            dataType: "JSON",
            success : function(res){
                    if(res!="") {
                        // console.log(res)
                        if(res.response == "ok"){
                            jsGoComPage(1);
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
    <% End If %>
}

function jsGoComPage(vpage){
    $.ajax({
        type: "POST",
        url: "/event/etc/list_109208.asp",
        data: {
            iCC: vpage
        },
        success: function(Data){
            $("#diarylist").html(Data);
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            //$("#listContainer").empty();
        }
    })
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
}
</script>
			<div class="mEvt109208">
                <style type="text/css">
                #tab-hobby {display:block; width:100%; height:5.43rem;}
                </style>
                <div class="mhobby">
                    <iframe id="tab-hobby" src="/event/etc/group/iframe_favorites.asp?eventid=109208" frameborder="0" scrolling="no" title="서촌도감"></iframe>
                </div>
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_tit.jpg" alt="즐겨찾길 서촌01 텐바이텐 x off to alone"></h2>
                    <div class="icon-arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_arrow.png" alt="arrow"></div>
                </div>
                <div class="section-01">
                    <!-- 롤링 영역 -->
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_slide1_01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_slide1_02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_slide1_03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>
                </div>
                <div class="section-02">
                    <div class="tit tit-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub_txt01.jpg" alt="서촌 통인시장을 걷다 입구에서 왼쪽 두 번째 골목에서 골목 속 숨겨진 ‘off to ALONE(오프투얼론)’을 만나볼 수 있어요. ‘오프투얼론’의 외관은 한옥을 개조해 서촌 골목에 운치를 더해주고, 이 골목에서 6년동안 자리를 지키고 있답니다."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub01.jpg" alt="img01"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub02.jpg" alt="img02"></div>
                    <div class="tit tit-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub_txt02.jpg" alt="실내에는 한옥의 요소들과 감각적인 일러스트레이션 오브제가 조화를 이뤄 색다른 공간을 연출하고 있어요."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub03.jpg" alt="img03"></div>
                    <!-- 롤링 영역 -->
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_slide2_01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_slide2_02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_slide2_03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>

                    <div class="tit tit-03">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub_txt03.jpg" alt="디자인과 일러스트레이션 중심의 독립 출판물부터 리소 인쇄물과 진,포스터, 엽서 그리고 귀여운 굿즈까지 이 작은 공간에 가득 담겨있어요.">
                        <button type="button" class="btn-detail"></button>
                        <!-- 상세설명 보기 버튼 -->
                    </div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub05.jpg" alt="img05"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub06.jpg" alt="img06"></div>
                    <div class="tit tit-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub_txt04.jpg" alt="여러분도 '오프투얼론'을 직접 방문하고 책방지기의 취향을 경험해보세요!"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sub07.jpg" alt="img07"></div>
                </div>
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_story.jpg" alt="off to alone Q & A">
                </div>
                <div class="section-04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_benefit_02.jpg" alt="이벤트 혜택">
                </div>
                <div class="section-05">
                    <div class="tit">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_tit_event.jpg" alt="off to alone in tenbyten">
                        <button type="button" class="btn-gift"></button>
                        <!-- 선물보기 버튼 -->
                    </div>
                    <!-- 이벤트 영역 -->
                    <div class="event-dot-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_dot.jpg" alt="event">
                        <div class="item-01 dot">
                            <button type="button"><span></span></button>
                        </div>
                        <div class="item-02 dot">
                            <button type="button"><span></span></button>
                        </div>
                        <div class="item-03 dot">
                            <button type="button"><span></span></button>
                        </div>
                        <div class="item-04 dot">
                            <button type="button"><span></span></button>
                        </div>
                        <div class="item-05 dot">
                            <button type="button"><span></span></button>
                        </div>
                        <div class="item-06 dot">
                            <button type="button"><span></span></button>
                        </div>
                    </div>
                    <!-- 읽고싶은 책 선택 영역 -->
                    <div class="event-check-book">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_click.jpg" alt="event">
                        <ul class="item-books">
                            <li class="item-checks-01"><button type="button" class="btn-checks" onclick="fnSelectBook(1);"></button></li>
                            <li class="item-checks-02"><button type="button" class="btn-checks" onclick="fnSelectBook(2);"></button></li>
                            <li class="item-checks-03"><button type="button" class="btn-checks" onclick="fnSelectBook(3);"></button></li>
                            <li class="item-checks-04"><button type="button" class="btn-checks" onclick="fnSelectBook(4);"></button></li>
                            <li class="item-checks-05"><button type="button" class="btn-checks" onclick="fnSelectBook(5);"></button></li>
                            <li class="item-checks-06"><button type="button" class="btn-checks" onclick="fnSelectBook(6);"></button></li>
                        </ul>
                    </div>
                    <!-- 선택이유 작성 영역 -->
                    <div class="event-comment-book">
                        <div class="top">
                            <div class="item-book-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/item_book01.png" alt="books title"></div><input type="hidden" id="booknum">
                        </div>
                        <div class="content">
                            <textarea placeholder="띄어쓰기 포함 200자 이내 작성 가능합니다." name="txtComm" id="txtComm" maxlength="200" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>></textarea>
                            <!-- 작성평 등록하기 버튼 -->
                            <button type="button" class="btn-apply" onclick="eventTry(); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/btn_apply.png" alt="등록하기"></button>
                        </div>
                    </div>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_tit01.jpg" alt="텐바이텐 고객님이 고른 오프투얼론의 도서 list">
                    <!-- comment List 영역 -->
                    <div class="comment-list-wrap" id="diarylist"></div>
                </div>
                <div class="section-06">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_sns_02.jpg" alt="sns 이벤트">
                    <button type="button" class="btn-set"></button>
                </div>
                <div class="section-07">
                    <!-- 인스타그램으로 이동 -->
                    <a href="https://www.instagram.com/off_to_alone" onclick="fnAmplitudeEventMultiPropertiesAction('landing_instagram','evtcode|option1','<%=eCode%>|')" class="mWeb">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_insta.jpg" alt="off to alone 구경하로 가기">
					</a>
                    <a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/off_to_alone'); return false;" class="mApp">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_insta.jpg" alt="off to alone 구경하로 가기">
					</a>
                </div>
                <div class="section-08">
                    <!-- 즐겨찾길 메인으로 이동 -->
                    <a href="/event/eventmain.asp?eventid=108102" onclick="jsEventlinkURL(108102);fnAmplitudeEventMultiPropertiesAction('landing_bookmark_seochon','evtcode|option1','<%=eCode%>|');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_main.jpg" alt="즐겨찾길 메인으로 이동">
                    </a>
                </div>

                <!-- 팝업 - '리소 인쇄물과 진' 자세히 보기 -->
                <div class="pop-container detail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/pop_detail.jpg" alt="리소 인쇄물과 진">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 선물보기 -->
                <div class="pop-container set">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/pop_set.png" alt="텐바이텐 x 오프투얼론 엽서 set">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 책 선물보기 -->
                <div class="pop-container gift">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/pop_gift.png" alt="추첨을 통해 선물을 드립니다.">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 이벤트 등록 후 -->
                <div class="pop-container apply">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/pop_done.png" alt="이벤트에 참여해주셔서 감사드리며 당첨자 발표일을 기다려주세요!">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 책내용 미리보기 01 -->
                <div class="pop-container book01 books">
                    <div class="pop-inner">
                        <div class="pop-contents info01">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_info01.png" alt="bolpool the mysterious bath">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 책내용 미리보기 02 -->
                <div class="pop-container book02 books">
                    <div class="pop-inner">
                        <div class="pop-contents info02">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_info02.png" alt="나는 당신이 생각하는 것보다 예민한 사람입니다만..">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 책내용 미리보기 03 -->
                <div class="pop-container book03 books">
                    <div class="pop-inner">
                        <div class="pop-contents info03">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_info03.png" alt="은지의 하루만화">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 책내용 미리보기 04 -->
                <div class="pop-container book04 books">
                    <div class="pop-inner">
                        <div class="pop-contents info04">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_info04.png" alt="제주">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 책내용 미리보기 05 -->
                <div class="pop-container book05 books">
                    <div class="pop-inner">
                        <div class="pop-contents info05">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_info05.png" alt="in front of me">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 책내용 미리보기 06 -->
                <div class="pop-container book06 books">
                    <div class="pop-inner">
                        <div class="pop-contents info06">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109208/m/img_event_info06.png" alt="동쪽 소식">
                        </div>
                        <button type="button" class="btn-close02">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->