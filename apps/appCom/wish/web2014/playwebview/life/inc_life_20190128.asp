<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 탐구생활 가성비
' History : 2019-01-24 최종원
'####################################################
'gnb 구분자
dim gnbFlag
dim nowUrl

nowUrl = request.servervariables("HTTP_url")

dim oItem
dim currenttime
	currenttime =  now()

dim returnUrl

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  89172
Else
	eCode   = 92225  
End If

dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vPIdx = request("pidx")

if InStr(nowUrl,"/apps/appcom/wish/web2014/playwebview/detail.asp") > 0 then
	returnUrl = appUrlPath & "/playwebview/detail.asp?pidx=" & vPIdx & "&pagereload=ON"
else 
	returnUrl = appUrlPath & "/subgnb/life/?pagereload=ON"
end if


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

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 5		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 6		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
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
<style>
.life-702 h2 {position:relative;}
.life-702 h2 i {display:inline-block; position:absolute; left:0; bottom:23.83%; width:100%; height:16.51%; opacity:0; background-size:contain; transition:all 1s;}
.life-702 h2 i.animation {bottom:27.83%; opacity:1;}

.life-702 .intro {position:relative;}
.life-702 .intro span {position:absolute; top:26.5%; left:0; animation:scale 500 1s 1s;}
.life-702 .intro span.t2 {animation-delay:.5s;}

.life-702 .section .swiper-slide {position:relative;}
.life-702 .section .pagination {position:absolute; bottom:0; left:0; z-index:10; width:100%; height:auto; padding:0; text-align:center;}
.life-702 .section .pagination .swiper-pagination-switch {width:.7rem; height:.7rem; margin:0 .55rem; background-color:#d7d7d7; }
.life-702 .section .pagination .swiper-pagination-switch.swiper-active-switch {width:1.32rem;background-color:#f5f5f5; border-radius:.3rem;}
.life-702 .section {position:relative;}
.life-702 .section1 {background-color:#7a77f6;}
.life-702 .section2 {background-color:#ffa42d;}
.life-702 .section3 {background-color:#4aba94;}
.life-702 .section4 {background-color:#ea5d56;}

.life-702 .section .swiper-slide a,
.more-item a {display:inline-block; position:absolute; top:0; left:0; width:100%; height:100%;}
.more-item {position:relative;}

.cmt-area { background-color:#ffd144; text-align:center;}
.cmt-area .input-box {position:relative; width:32rem; margin:0 auto 3.84rem;}
.cmt-area .input-box .submit {display:inline-block; position:absolute; top:0; right:5.47%; width:26.5%;}
.cmt-area .input-box .textarea-wrap {position:absolute; top:20%; left:15.6%; width:42%; height:51.49%;}
.cmt-area .input-box textarea {overflow:hidden;width:100%; height:100%; padding:0; border:0; background-color:transparent; color:#000; font-size:1.39rem; line-height:2.56rem; font-weight:600; text-align:left;}
.cmt-area .input-box textarea::-webkit-input-placeholder {color:#d6d6d6;}
.cmt-area .input-box textarea::-moz-placeholder {color:#d6d6d6;}
.cmt-area .input-box textarea:-ms-input-placeholder {color:#d6d6d6;}
.cmt-area .input-box textarea:-moz-placeholder {color:#d6d6d6;}
.cmt-area .submit {width:32rem;}
.cmt-area .cmt-list ul {padding:2.99rem 6.6% 0;background-color:#f76347;}
.cmt-area .cmt-list ul li {display:table; position:relative; width:100%; margin-top:1.28rem; padding:1.15rem 0; background-color:#fff;}
.cmt-area .cmt-list ul li p {display:table-cell; vertical-align:middle;}
.cmt-area .cmt-list ul .num {width:22%; font-size:.75rem; font-weight:500;}
.cmt-area .cmt-list ul .writer {width:32%; padding-right:6.15%; color:#c75742; font-size:.95rem; text-align:right;}
.cmt-area .cmt-list ul .conts {margin-top:1.62rem; font-size:1.37rem; line-height:1.33; font-weight:bold; word-wrap:break-word; word-break:break-all; text-align:left;}
.cmt-area .cmt-list .delete {display:inline-block; position:absolute; top:-.43rem; right:-.43rem; width:1.66rem; height:1.66rem; background:url(//webimage.10x10.co.kr/fixevent/play/life/702/btn_close.png) no-repeat 50% 50%; background-size:contain; text-indent:-999em}
.cmt-area .pagingV15a {margin-top:0rem; padding-top:2.99rem; padding-bottom:3.62rem; background-color:#f76347;}
.cmt-area .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#fff; font-size:1.28rem; line-height:2.9rem; font-weight:600;}
.cmt-area .pagingV15a a {padding-top:0;}
.cmt-area .pagingV15a .current {color:#f76347; background:#fff192; border-radius:50%;}
.cmt-area .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(//webimage.10x10.co.kr/fixevent/play/life/702/btn_next.png) 0 0 no-repeat; background-size:100% 100%;}

@keyframes scale {0%,100% {transform:scale(1);} 50% {transform:scale(.9);}}
</style>
<script type="text/javascript">
    $(function(){
		var position = $('.life-702').offset(); // 위치값
		<% if InStr(nowUrl,"/apps/appcom/wish/web2014/playwebview/detail.asp") > 0 then %>
		$('html,body').animate({ scrollTop :position.top },300); // 이동
		<% end if %>

        $(".life-702 h2 i").addClass("animation");

		Swiper(".section1 .swiper-container",{
            loop:true,
            autoplay:2800,
            speed:800,
            pagination:".section1 .pagination",
            paginationClickable:true,
            effect:'fade'
        });
		Swiper(".section2 .swiper-container",{
            loop:true,
            autoplay:2800,
            speed:800,
            pagination:".section2 .pagination",
            paginationClickable:true,
            effect:'fade'
        });
		Swiper(".section3 .swiper-container",{
            loop:true,
            autoplay:2800,
            speed:800,
            pagination:".section3 .pagination",
            paginationClickable:true,
            effect:'fade'
        });
		Swiper(".section4 .swiper-container",{
            loop:true,
            autoplay:2800,
            speed:800,
            pagination:".section4 .pagination",
            paginationClickable:true,
            effect:'fade'
        });
    });
</script>
<script type="text/javascript">
    <% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>        
function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('<%=returnUrl%>&iCC=' + iP);
}

function jsSubmitComment(frm){		
	<% If IsUserLoginOK() Then %>	
		<% if date() >="2019-01-24" and date() <= "2019-02-28" then %>
			<% if commentcount>4 and userid <> "cjw0515" then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("텍스트를 입력해주세요.");					
					frm.txtcomm.focus();
					return false;
				}				
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
			jsChklogin_mobile('','<%=returnUrl%>');
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
			jsChklogin_mobile('','<%=returnUrl%>');
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
function setStar(rate){    
    var frm = document.frmcom;
    frm.spoint.value=rate;    
}
function pickCategory(categoryIdx){
    var frm = document.frmcom;
    frm.com_egC.value=categoryIdx;    
}
function displayCategory(){
    var objs = $(".bestCategory");
    // console.log(objs)
    objs.each(function(idx, value){        
        var cateIdx = $(this).text();
        var mycateObj = $(".mycate li span")[cateIdx];
        var txt = mycateObj.innerHTML.replace("amp;","");    
        $(this).text(txt);        
    })
}
</script>
            <!-- 탐구생활 702 -->
            <div class="life-702">
                <h2><img src="//webimage.10x10.co.kr/fixevent/play/life/702/tit_life.jpg" alt="#가행비 #가잼비 프로젝트"><i><img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_smile.png" alt=""></i></h2>
                <div><img src="//webimage.10x10.co.kr/fixevent/play/life/702/txt_happy_list.jpg" alt="행복 찾아 삼만리 여러분은 어떤 것으로 행복을 찾나요? "></div>
                <div class="intro">
                    <img src="//webimage.10x10.co.kr/fixevent/play/life/702/txt_intro.jpg" alt="가격보다 행복과 재미를 찾아서 소비하는 사람들이 많아진 요즘,  이러한 정보를 바탕으로 소소하지만 확실한  #가행비 #가잼비 아이템을 찾아드립니다!">
                    <span class="t1"><img src=" //webimage.10x10.co.kr/fixevent/play/life/702/txt_happy.png" alt="행복"></span>
                    <span class="t2"><img src=" //webimage.10x10.co.kr/fixevent/play/life/702/txt_fun.png" alt="재미"></span>
                </div>

                <!-- 상품목록 -->
                <div class="section section1">
                    <p><img src="//webimage.10x10.co.kr/fixevent/play/life/702/tit_happy_1.png" alt="1. 멀리 떠나는 여행 대신" /></p>
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_1_1.jpg" alt="#부루마블">
                                <a href="/category/category_itemprd.asp?itemid=1781151&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('1781151&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_1_2.jpg" alt="#에어프레임">
                                <a href="/category/category_itemprd.asp?itemid=591337&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('591337&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_1_3.jpg" alt="#여행 책">
                                <a href="/category/category_itemprd.asp?itemid=1233664&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('1233664&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_1_4.jpg" alt="#스크래치 페이퍼">
                                <a href="/category/category_itemprd.asp?itemid=1323283&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('1323283&pEtr=702');" class="mApp"></a>
                            </div>
                        </div>
                        <div class="pagination"></div>
                    </div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/play/life/702/txt_happy_1.jpg" alt="연휴에 미리 계획 못해서 못 떠난 분들, 멀리 떠나는 대신에 집에서 보드게임 부루마블로 세계 일주 다녀오면 어때요? 비행기 타고 훌쩍 떠나고 싶은데, 비행기 표 값에 엄두 못 냈다면 비행기 프레임 액자를 집에 걸어두는 것만으로도 행복해질 거예요."></div>
                </div>

                <div class="section section2">
                    <p><img src="//webimage.10x10.co.kr/fixevent/play/life/702/tit_happy_2.png" alt="2. 쓸모없지만 재미있는 선물" /></p>
                    <div class="swiper-container">
                            <div class="swiper-wrapper">
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_2_1.jpg" alt="#개구리 안대">
                                        <a href="/category/category_itemprd.asp?itemid=2121620&pEtr=702" class="mWeb"></a>
                                        <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2121620&pEtr=702');" class="mApp"></a>
                                    </div>
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_2_2.jpg" alt="#생선 슬리퍼">
                                        <a href="/category/category_itemprd.asp?itemid=2108983&pEtr=702" class="mWeb"></a>
                                        <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2108983&pEtr=702');" class="mApp"></a>
                                    </div>
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_2_3.jpg" alt="#두루마리 냅킨">
                                        <a href="/category/category_itemprd.asp?itemid=2222941&pEtr=702" class="mWeb"></a>
                                        <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2222941&pEtr=702');" class="mApp"></a>
                                    </div>
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_2_4.jpg" alt="#코스프레">
                                        <a href="/category/category_itemprd.asp?itemid=2175797&pEtr=702" class="mWeb"></a>
                                        <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2175797&pEtr=702');" class="mApp"></a>
                                    </div>
                                </div>
                        <div class="pagination"></div>
                    </div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/play/life/702/txt_happy_2.jpg" alt="오랜만에 만난 친척, 가족들과 쓸모없지만 재미있는 선물을 교환해보면 어때요? 가벼운 마음으로, 재미있는 추억을 주고받을 수 있을 거예요."></div>
                </div>

                <div class="section section3">
                    <p><img src="//webimage.10x10.co.kr/fixevent/play/life/702/tit_happy_3.png" alt="3. 가격대비 꿀템" /></p>
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_3_1.jpg" alt="#쾌변 발판">
                                <a href="/category/category_itemprd.asp?itemid=2214555&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2214555&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_3_2.jpg" alt="#우산 신발">
                                <a href="/category/category_itemprd.asp?itemid=1680292&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('1680292&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_3_3.jpg" alt="#드링킹 모자">
                                <a href="/category/category_itemprd.asp?itemid=2105600&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2105600&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_3_4.jpg" alt="#LED 소주잔">
                                <a href="/category/category_itemprd.asp?itemid=1414862&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('1414862&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_3_5.jpg" alt="#게임 롤휴지">
                                <a href="/category/category_itemprd.asp?itemid=655518&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('655518&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_3_6.jpg" alt="#보풀 제거기">
                                <a href="/category/category_itemprd.asp?itemid=2130738&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2130738&pEtr=702');" class="mApp"></a>
                            </div>
                        </div>
                        <div class="pagination"></div>
                    </div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/play/life/702/txt_happy_3.jpg" alt="이 아이템들은 없으면 몰라요. 있으면 정말 든든할 거예요. 행복은 멀리 있지 않아요.가까운 곳에서 불편했던 걸 찾아서 더 편하게 해준다면 그것만으로도 행복이죠."></div>
                </div>

                <div class="section section4">
                    <p><img src="//webimage.10x10.co.kr/fixevent/play/life/702/tit_happy_4.png" alt="4. 내 취미는 뭘까?" /></p>
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_4_1.jpg" alt="#그림 그리기">
                                <a href="/category/category_itemprd.asp?itemid=2029018&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2029018&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_4_2.jpg" alt="#가죽 공예">
                                <a href="/category/category_itemprd.asp?itemid=2209796&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2209796&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_4_3.jpg" alt="#가구 만들기">
                                <a href="/category/category_itemprd.asp?itemid=2207546&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2207546&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_4_4.jpg" alt="#요리하기">
                                <a href="/category/category_itemprd.asp?itemid=1912728&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('1912728&pEtr=702');" class="mApp"></a>
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_happy_4_5.jpg" alt="#요리하기">
                                <a href="/category/category_itemprd.asp?itemid=2133812&pEtr=702" class="mWeb"></a>
                                <a href="javascript:void(0)"  onclick="fnAPPpopupProduct('2133812&pEtr=702');" class="mApp"></a>
                            </div>
                        </div>
                        <div class="pagination"></div>
                    </div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/play/life/702/txt_happy_4.jpg" alt="요즘은 취미 하나씩은 다 가지고 있다고 하잖아요. 나만의 취향이 확고해진 요즘. 나만의 또렷한 취미로 소소한 행복을 즐겨보면 어떨까요? 더 보람찬 하루하루를 보낼 수 있을 거예요."></div>
                </div>

                <!-- 아이템 더보러 가기 -->
                <div class="more-item">
                    <img src="//webimage.10x10.co.kr/fixevent/play/life/702/img_bnr_more.jpg" alt="가잼비 아이템 더 보러 가기">
                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=92225');return false;" class="mApp"></a>
                    <a href="/event/eventmain.asp?eventid=92225" class="mWeb"></a>
                </div>

                <!-- 코멘트영역 -->
                <div class="cmt-area" id="comment">
                    <h4><img src="//webimage.10x10.co.kr/fixevent/play/life/702/txt_cmt_evt.jpg" alt="여러분은 어떤 것으로 행복을 찾나요? 5분에게 추첨을 통해 기프트카드 5,000원 권을 드립니다."></h4>

                    <!-- 유저 입력창 -->
                    <div class="input-box">
						<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
						<input type="hidden" name="mode" value="add">
						<input type="hidden" name="pagereload" value="ON">
						<input type="hidden" name="iCC" value="1">
						<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="linkevt" value="<%= eCode %>">
						<input type="hidden" name="blnB" value="">
						<input type="hidden" name="returnurl" value="<%=returnUrl%>">
						<input type="hidden" name="isApp" value="<%= isApp %>">	
						<input type="hidden" name="com_egC">	                
						<input type="hidden" name="spoint"/>					
                        <div class="textarea-wrap">
                            <textarea id="txtcomm" name="txtcomm" placeholder="20자 이내로 입력" maxlength="20" onClick="jsCheckLimit();"></textarea>
                        </div>
                        <button class="submit" onclick="jsSubmitComment(document.frmcom);return false;"><img src="//webimage.10x10.co.kr/fixevent/play/life/702/btn_submit.png" alt="등록"></button>							
                        <img src="//webimage.10x10.co.kr/fixevent/play/life/702/bg_txt_area.png" alt="">
						</form>
						<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
						<input type="hidden" name="mode" value="del">
						<input type="hidden" name="pagereload" value="ON">
						<input type="hidden" name="Cidx" value="">
						<input type="hidden" name="returnurl" value="<%=returnUrl%>">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="linkevt" value="<%= eCode %>">
						<input type="hidden" name="isApp" value="<%= isApp %>">
						</form>                 						
                    </div>

                    <!-- 코멘트리스트 6개씩 노출-->
                    <div class="cmt-list">
					<% If isArray(arrCList) Then %>				                    
                        <ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
                            <li>
                                <p class="num">No. <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                                <p class="conts"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
                                <p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</p>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                                <button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button>
								<% End If %>
                            </li>
							<% Next %>
                        </ul>
					<% End If %>	                            	
                    </div>
                    <% If isArray(arrCList) Then %>
                    <div class="paging pagingV15a">
                        <%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
                    </div>
                    <% end if %>					
                </div>

			</div>
			<!--// 컨텐츠 영역 -->