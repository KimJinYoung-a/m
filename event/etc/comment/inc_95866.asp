<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : k현대미술관 이벤트
' History : 2019-07-23
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim evtStartDate, evtEndDate, currentDate
	currentDate =  date()
    evtStartDate = Cdate("2019-07-23")
    evtEndDate = Cdate("2019-08-06")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90353
Else
	eCode   =  95866
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

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

	page	= getNumeric(requestCheckVar(Request("page"),10))

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
.mEvt95866 {position: relative; overflow: hidden;}
.mEvt95866 button {background-color: transparent; border: 0;}
.mEvt95866 .pos {position: absolute; top: 0; left: 0; width: 100%;}
.mEvt95866 .posr {position: relative;}
.mEvt95866 input:focus::-webkit-input-placeholder {opacity: 0;} 
.topic p {transform: translate3d(0,7rem,0); opacity: 0; transition-duration: .7s}
.topic.on p {transform: translate3d(0,0,0); opacity: 1;}
.topic.on p.delay1 {transition-delay: .3s}
.topic.on p.delay2 {transition-delay: .6s}
.intro .rolling {position:relative;}
.intro .rolling {position: relative;}
.intro .rolling .btn-area {position: absolute; bottom: 7rem; right: 2.5rem; z-index: 66;}
.intro .rolling .btn-area button {width: 4rem; height: 3rem; text-indent: -999rem;}
.cmt-area {margin-top: -.08rem; text-align:center; background-color: #5e86fa;}
.cmt-input {background-color:#7b9dff;}
.cmt-input .inner {position: relative; width: 32rem; margin: 0 auto;}
.cmt-input .input-box {position:absolute; top:29rem; left:4.5rem; width: 10rem; }
.cmt-input .input-box .now-txt {position: absolute; bottom: .5rem; right:.4rem; color:#999; font-size:0.9rem;}
.cmt-input .input-box input {overflow:hidden; width:100%; height:3.67rem; padding: 0; border:0; background-color:transparent; color:#444; font-size:1.45rem; font-weight:600; text-align: center; box-sizing: border-box;} 
.cmt-input .input-box input::-webkit-input-placeholder {color:#999;}
.cmt-input .input-box input:focus::-webkit-input-placeholder {opacity: 0;} 
.cmt-input .btn-submit {width: 100%;}
.cmt-list {padding-top: 3rem;}
.cmt-list li {position:relative; width: 27.73rem; height: 8.1rem; margin:0 auto 1.28rem; padding: 1.49rem 2.77rem; text-align:left; background-color: #fff; border-radius: .7rem; background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/95866/m/bg_cmt.jpg); background-size: 27.22rem; box-sizing: border-box;}
.cmt-list li .num {margin-bottom: .65rem; font-size:1.11rem; font-weight: 600; color: #444;}
.cmt-list li .conts {margin-bottom: .6rem; font-size:1.32rem; line-height:1.6; word-wrap:break-word; word-break:break-all; color: #666; text-align: center; font-weight: 500;}
.cmt-list li .conts span {color: #ea490f;font-weight: bold; text-transform: uppercase;}
.cmt-list li .writer {font-size:1.11rem; color: #999; text-align: right;}
.cmt-list li .delete {position: absolute; top: .7rem; right: 1rem; color: #aaa; font-size: 2rem;}
.cmt-list li:nth-child(5n-3) {background-position: 0 -18.25rem;}
.cmt-list li:nth-child(5n-3) span {color: #ff53e9 ;}
.cmt-list li:nth-child(5n-2) {background-position: 0 -36.7rem;}
.cmt-list li:nth-child(5n-2) span {color: #ac53ff  ;}
.cmt-list li:nth-child(5n-1) {background-position: 0 -54.05rem;}
.cmt-list li:nth-child(5n-1) span {color: #5353ff  ;}
.cmt-list li:nth-child(5n) {background-position: 0 -72.4rem;}
.cmt-list li:nth-child(5n) span {color: #ffae00 ;}
.pagingV15a {padding: .5rem 0 2.8rem;}
.pagingV15a span {min-width: 2.8rem; height: 2.8rem; margin: 0 .2rem; line-height: 2.8rem; font-size: 1.28rem; font-weight: 500; color: #ffdccf; border-radius: 50%}
.pagingV15a span.current {font-weight: normal; color: #fff; background-color: #3543e3; }
.pagingV15a .arrow a {width: 2.77rem; background: none; background: url(//webimage.10x10.co.kr/fixevent/event/2019/95866/m/btn_arrow.png) 0 -.1rem /3.2rem;}
.pagingV15a .arrow.nextBtn a {transform: rotateY(180deg)}
.pagingV15a .arrow a:after {content: unset;}
.noti {padding:3.2rem 6.67% ; background-color:#3d3d3d; color: #202c46; }
.noti h5 {margin-bottom: 1.55rem; font-weight: bold; font-size: 1.55rem; text-align: center; color: #cbd8fd;}
.noti li {margin:.68rem 0; padding-left:.77rem; font-size:1.11rem; line-height:1.6; text-indent:-.7rem; color: #fff;}
</style>
<script type="text/javascript" src="/lib/js/TweenMax.min.js"></script>
<script>
$(function(){
    (function(){
        $('.topic').addClass('on');
        rolling1 = new Swiper(".rolling .swiper-container",{
            effect:'fade',
            autoplay:3700,
            loop: true,
            speed:400,
            nextButton:'.rolling .btnNext',
            prevButton:'.rolling .btnPrev'
        });
    })();
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
    <% end if %>
});
</script>
<script type="text/javascript">
function pagedown(){
	window.$('html,body').animate({scrollTop:$(".cmt-area").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( currentDate >= evtStartDate and currentDate <= evtEndDate ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
            if(frm.txtcomm1.value == ""){
                alert('내용을 넣어주세요')
                frm.txtcomm1.focus()
                return false;
            }
            
            fnAmplitudeEventMultiPropertiesAction("click_comment_in_event","eventcode","<%=eCode%>");
            
            frm.txtcomm.value = frm.txtcomm1.value
            frm.action = "/event/lib/doEventComment.asp";
            frm.submit();
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
}

function chkWord(obj, maxLength){
    var currentLengh = obj.value.length < maxLength ? obj.value.length : maxLength
    obj.value = obj.value.substr(0, maxLength)
    $("#nowtxt").text(parseInt(currentLengh));
}
</script>
    <!-- MKT_95866_텐바이텐xk현대미술관 -->
    <div class="mEvt95866">
        <div class="topic ">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/img_top.jpg" alt="">
            <div class="pos">
                <p class=""><img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/tit_01.png" alt="텐바이텐 X K현대미술관"></p>
                <p class="delay1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/tit_02.png?v=1.01" alt="8월의 문화생활"></p>
                <p class="delay2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/tit_03.png" alt="K현대미술관 ≪KISS : LOVE MOMENTS≫ 전시에 텐바이텐 고객  100분을 초대합니다."></p>
            </div>
        </div>
        <div class="intro">
            <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/txt_intro.jpg" alt=""></span>
            <div class="rolling">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95866/m/img_slide_1.jpg" alt="" /></div>
                        <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95866/m/img_slide_2.jpg" alt="" /></div>
                        <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95866/m/img_slide_3.jpg" alt="" /></div>
                        <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95866/m/img_slide_4.jpg" alt="" /></div>
                        <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95866/m/img_slide_5.jpg" alt="" /></div>
                    </div>
                </div>
                <div class="btn-area">
                    <button class="btn-arrow btnPrev">이전</button>
                    <button class="btn-arrow btnNext">다음</button>
                </div>
            </div>
        </div>
        <!-- 코멘트 -->
        <div class="cmt-area">
            <div class="cmt-input">
                <div class="inner">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/img_cmt.jpg" alt="quiz event">
                    <div class="input-box">
                        <form name="frmcom" method="post" onSubmit="return false;">
                            <input type="hidden" name="mode" value="add">
                            <input type="hidden" name="pagereload" value="ON">
                            <input type="hidden" name="iCC" value="1">
                            <input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
                            <input type="hidden" name="eventid" value="<%= eCode %>">
                            <input type="hidden" name="linkevt" value="<%= eCode %>">
                            <input type="hidden" name="blnB" value="<%= blnBlogURL %>">
                            <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
                            <input type="hidden" id="spoint" name="spoint" value="1">
                            <input type="hidden" name="txtcomm">
                            <input type="hidden" name="isApp" value="<%= isApp %>">

                            <input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" title="정답 입력" placeholder="정답 입력" maxlength="4" onkeyup="chkWord(this,4);"/>
                            <p class="now-txt" name="입력한 글자 수"><span id="nowtxt">0</span>/4</p>
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
                    <button type="button" class="btn-submit" onclick="jsSubmitComment(document.frmcom);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/btn_cmt.jpg" alt="등록하기"></button>
                </div>
            </div>
            <div class="cmt-list">
                <% IF isArray(arrCList) THEN %>        
                <ul>
                    <% 
                    For intCLoop = 0 To UBound(arrCList,2) 
                    %>                
                    <li>
                        <p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                        <div class="conts">
                            ≪<span><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></span> : LOVE MOMENTS≫                         
                        </div>
                        <p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
                        <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                        <button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">&#10005;</button>
                        <% end if %>                                
                    </li>
                    <% Next %>
                </ul>
                <% end if %>
                <% If isArray(arrCList) Then %>
                <%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
                <% End If %>                    
            </div>
        </div>
        <div>
            <a href="/culturestation/" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>')" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/bnr.jpg" alt="다양한 문화생활 즐기러 가기"></a>
            <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>', function(bool){if(bool) {fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appcom/wish/web2014/culturestation/');}});return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95866/m/bnr.jpg" alt="다양한 문화생활 즐기러 가기"></a>
        </div>
        <div class="noti">
            <h5>유의사항</h5>                    
            <ul>
                <li>- 해당 이벤트는 로그인 후 참여 가능합니다.</li>
                <li>- ≪KISS : LOVE MOMENTS≫ 전시는 타인에게 양도가 불가합니다.</li>
                <li>- 텐바이텐 X K현대미술관 7월의 문화생활 당첨자 발표는 8월 7일 텐바이텐 공지사항에 게시됩니다.</li>
                <li>- ≪KISS : LOVE MOMENTS≫ 전시 관람일은 8월 8일 ~ 9월 8일까지 관람 가능합니다.</li>
                <li>- 미술관 방문 시 본인 확인을 위하여, 신분증을 지참해주셔야 합니다.</li>
            </ul>                    
        </div>

    </div>            
<!-- #include virtual="/lib/db/dbclose.asp" -->