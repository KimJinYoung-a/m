<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : K현대미술관 - 8월 - 뮤지엄 테라피 : 디어브레인
' History : 2019-08-05
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
    evtStartDate = Cdate("2019-08-05")
    evtEndDate = Cdate("2019-08-20")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90333
Else
	eCode   =  96220
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
<style>
.mEvt96220 {position: relative; overflow: hidden;}
.mEvt96220 button {background-color: transparent; border: 0;}
.mEvt96220 .pos {position: absolute; top: 0; left: 0; width: 100%;}
.mEvt96220 .posr {position: relative;}
.mEvt96220 input:focus::-webkit-input-placeholder {opacity: 0;} 
.topic p {transform: translate3d(0,6rem,0); opacity: 0; transition-duration: 1.5s}
.topic.on p {transform: translate3d(0,0,0); opacity: 1;}
.topic.on p.delay1 {transition-delay: .5s}
.topic.on p.delay2 {transition-delay: 1.3s}
.intro .slide1 {position: relative;}
.intro .slide1 .btn-area {position: absolute; bottom: 4.5%; right: 6%; width: 27%; z-index: 66;}
.intro .slide1 .btn-area button {display: inline-block; width: 45%; height: 3rem; text-indent: -999rem;}
.pagination {position: absolute; top: 0; left: 0; width: 100%; height: 7.5%; z-index: 999;}
.pagination:after {content: ''; display: block; clear: both; }
.pagination .swiper-pagination-switch {display: block; float: left; width: 33.33%; height: 100%; margin: 0; border-radius: 0; background: none;}
.cmt-area {margin-top: -.08rem; text-align:center; background-color: #9e6af2;}
.cmt-input {background-color:#9e6af2;}
.cmt-input .inner {position: relative; width: 32rem; margin: 0 auto;}
.cmt-input .input-box {position:absolute; top:32.3rem; left:15.4rem; width: 10.6rem; }
.cmt-input .input-box .now-txt {position: absolute; bottom: .5rem; right:.5rem; color:#999; font-size:0.9rem;}
.cmt-input .input-box input {overflow:hidden; width:100%; height:3.67rem; padding: 0; border:0; background-color:transparent; color:#444; font-size:1.45rem; font-weight:600; text-align: center; box-sizing: border-box;} 
.cmt-input .input-box input::-webkit-input-placeholder {color:#999;}
.cmt-input .input-box input:focus::-webkit-input-placeholder {opacity: 0;} 
.cmt-input .btn-submit {width: 100%;}
.cmt-list {padding-top: 3rem; background-color: #8f4ff8;}
.cmt-list li {position:relative; width: 32rem; height: 9.17rem; margin:0 auto 1.28rem; padding: 1.2rem 4rem; text-align:left; background-color: #fff; border-radius: .7rem; background: url(//webimage.10x10.co.kr/fixevent/event/2019/96220/m/bg_cmt.jpg) center 0 /100% 100%; box-sizing: border-box;}
.cmt-list li .num {margin-bottom: .65rem; font-size:1.11rem; font-weight: 600; color: #444;}
.cmt-list li .conts {margin-bottom: .8rem; font-size:1.32rem; line-height:1.6; word-wrap:break-word; word-break:break-all; color: #666; text-align: center; font-weight: 500;}
.cmt-list li .conts span {color: #8134ff ;font-weight: bold; text-transform: uppercase;}
.cmt-list li .writer {font-size:1.11rem; color: #999; text-align: right;}
.cmt-list li .delete {position: absolute; top: .4rem; right: 4rem; color: #aaa; font-size: 2rem;}
.cmt-list li:nth-child(5n-3) span {color: #ff3690  ;}
.cmt-list li:nth-child(5n-2) span {color: #05c85c   ;}
.cmt-list li:nth-child(5n-1) span {color: #ff8a34   ;}
.cmt-list li:nth-child(5n) span {color: #3657ff ;}
.pagingV15a {padding: .5rem 0 2.8rem;}
.pagingV15a span {min-width: 2.8rem; height: 2.8rem; margin: 0 .2rem; line-height: 2.8rem; font-size: 1.28rem; font-weight: 500; color: #dac3ff; border-radius: 50%}
.pagingV15a span.current {font-weight: normal; color: #fff; background-color: #09d0a8; }
.pagingV15a .arrow a {width: 2.77rem; background: none; background: url(//webimage.10x10.co.kr/fixevent/event/2019/96220/m/btn_arrow.png) 0 -.1rem /3.2rem;}
.pagingV15a .arrow.nextBtn a {transform: rotateY(180deg)}
.pagingV15a .arrow a:after {content: unset;}
.noti {padding:3.2rem 6.67% ; background-color:#3d3d3d; color: #202c46; }
.noti h5 {margin-bottom: 1.55rem; font-weight: bold; font-size: 1.55rem; text-align: center; color: #cbd8fd;}
.noti li {margin:.68rem 0; padding-left:.77rem; font-size:1.11rem; line-height:1.6; text-indent:-.7rem; color: #fff; word-break: keep-all}
.noti li:before {content: '-'; display: inline-block;}
</style>
<script type="text/javascript">
$(function(){
    (function(){
        $('.topic').addClass('on');
        rolling1 = new Swiper(".slide1 .swiper-container",{
            effect:'fade',
            autoplay:4200,
            loop: true,
            speed:200,
            pagination:'.slide1 .pagination',
            paginationClickable:true,
            nextButton:'.slide1 .btnNext',
            prevButton:'.slide1 .btnPrev'
        });
    })();

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
    <% end if %>
});

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

function chkword(obj, maxByte) {
 	var strValue = obj.value;
	var strLen = strValue.length;
	var totalByte = 0;
	var len = 0;
	var oneChar = "";
	var str2 = "";

	for (var i = 0; i < strLen; i++) {
		oneChar = strValue.charAt(i);
		if (escape(oneChar).length > 4) {
			totalByte += 2;
		} else {
			totalByte++;
		}

		// 입력한 문자 길이보다 넘치면 잘라내기 위해 저장
		if (totalByte <= maxByte) {
			len = i + 1;
		}
	}

    $("#nowtxt").text(parseInt(totalByte/2));

	// 넘어가는 글자는 자른다.
	if (totalByte > maxByte) {
		alert("띄어쓰기 포함 "+ maxByte/2 + "자를 초과 입력 할 수 없습니다.");
		str2 = strValue.substr(0, len);
		obj.value = str2;
		chkword(obj, 4000);
	}
}
</script>

<div class="mEvt96220">
    <div class="topic ">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/img_top.jpg" alt="">
        <div class="pos">
            <p class=""><img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/tit_1.png?v=1.01" alt="텐바이텐 X K현대미술관"></p>
            <p class="delay1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/tit_2.png?v=1.01" alt="8월의 문화생활"></p>
            <p class="delay2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/tit_3.png" alt="K현대미술관 ≪뮤지엄 테라피 : 디어 브레인≫ 전시에 텐바이텐 고객  100분을 초대합니다."></p>
        </div>
    </div>
    <div class="intro">
        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/img_intro.jpg" alt=""></span>
        <div class="slide1">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/96220/m/img_slide_1.jpg" alt="" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/96220/m/img_slide_2.jpg" alt="" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/96220/m/img_slide_3.jpg" alt="" /></div>
                </div>
            </div>
            <div class="btn-area">
                <button class="btn-arrow btnPrev">이전</button>
                <button class="btn-arrow btnNext">다음</button>
            </div>
            <div class="pagination"></div>
        </div>
    </div>

    <div class="cmt-area">
        <div class="cmt-input">
            <div class="inner">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/img_cmt.jpg" alt="quiz event">
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
                <div class="input-box">
                    <input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" title="검색어 입력" placeholder="정답 입력" maxlength="5" onkeyup="chkword(this,10);"/>
                    <p class="now-txt" name="입력한 글자 수"><span id="nowtxt">0</span>/5</p>
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
                <button type="button" class="btn-submit" onclick="jsSubmitComment(document.frmcom);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/btn_cmt.jpg?v=1.03" alt="등록하기"></button>
            </div>
        </div>
        <div class="cmt-list">
            <% IF isArray(arrCList) THEN %>
            <ul class="inner">
                <% 
                For intCLoop = 0 To UBound(arrCList,2) 
                %>  
                <li>
                    <p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                    <div class="conts">≪뮤지엄 테라피 : <span><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></span>≫</div>
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
        <a href="/culturestation/" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>')" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/bnr.png" alt="다양한 문화생활 즐기러 가기"></a>
        <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>', function(bool){if(bool) {fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appcom/wish/web2014/culturestation/');}});return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96220/m/bnr.png" alt="다양한 문화생활 즐기러 가기"></a>
    </div>
    <div class="noti">
        <h5>유의사항</h5>                    
        <ul>
            <li>해당 이벤트는 로그인 후 참여 가능합니다.</li>
            <li>≪뮤지엄 테라피 : 디어 브레인≫ 전시는 타인에게 양도가 불가합니다.</li>
            <li>텐바이텐 X K현대미술관 8월의 문화생활 당첨자 발표는 8월 21일 텐바이텐 공지사항에 게시됩니다.</li>
            <li>≪뮤지엄 테라피 : 디어 브레인≫ 전시 관람일은 8월 22일 ~ 9월 1일까지 관람 가능합니다.</li>
            <li>미술관 방문 시 본인 확인을 위하여, 신분증을 지참해주셔야 합니다.</li>
        </ul>                    
    </div>
</div>