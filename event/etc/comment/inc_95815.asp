<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 대림미술관 이벤트 
' History : 2019-07-08
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
    evtStartDate = Cdate("2019-07-09")
    evtEndDate = Cdate("2019-07-23")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90333
Else
	eCode   =  95815
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
.mEvt95815 {position: relative; overflow: hidden;}
.mEvt95815 button {background-color: transparent; border: 0;}
.mEvt95815 .pos {position: absolute; top: 0; left: 0; width: 100%;}
.mEvt95815 .posr {position: relative;}
.mEvt95815 input:focus::-webkit-input-placeholder {opacity: 0;} 

.intro .rolling {position:relative;}
.intro .rolling {position: relative;}
.intro .rolling .btn-area {position: absolute; bottom: 0; right: 2.5rem; z-index: 66;}
.intro .rolling .btn-area button {width: 4.1rem; height: 2.5rem; text-indent: -999rem;}
.vod-wrap .vod {height: auto; left: 6%; top: 37%; width: 88%; padding-bottom: 50%;}
.cmt-area {margin-top: -.08rem; text-align:center; background-color: #f49a7a;}
.cmt-input > button {position: relative; display: block;}
.cmt-area .cmt-input {background-color:#ef835c;}
.cmt-area .cmt-input .inner {width: 32rem; margin: 0 auto;}
.cmt-area .cmt-input .input-wrap {position:absolute; top:32rem; left:0; width: 100%; }
.cmt-area .cmt-input .input-wrap .now-txt {position: absolute; bottom: .5rem; right: 6rem; color:#999; font-size:1.02rem;}
.cmt-area .cmt-input input {overflow:hidden; width:20.69rem; height:3.67rem; padding: 0; border:0; background-color:transparent; color:#444; font-size:1.45rem; font-weight:600; text-align: center; box-sizing: border-box;}
.cmt-area .cmt-input input::-webkit-input-placeholder {color:#999;}
.cmt-area .cmt-input input::-moz-placeholder {color:#999;}
.cmt-area .cmt-input input:-ms-input-placeholder {color:#999;}
.cmt-area .cmt-input input:-moz-placeholder {color:#999;}
.cmt-area .cmt-input input:focus::-webkit-input-placeholder {opacity: 0;} 
.cmt-area .cmt-list {padding-top: 3rem;}
.cmt-area .cmt-list ul {width:32rem; margin:0 auto;}
.cmt-area .cmt-list li {position:relative; width: 27.73rem; margin:0 auto 1.28rem; padding: 1.49rem 2.77rem; text-align:left; background-color: #fff5f2; border-radius: .7rem}
.cmt-area .cmt-list li:nth-child(2n) {background-color: #f2f3ff; }
.cmt-area .cmt-list li .num {margin-bottom: 1rem; font-size:1.11rem; color: #444;}
.cmt-area .cmt-list li .conts {margin-bottom: .6rem; font-size:1.32rem; line-height:1.6; word-wrap:break-word; word-break:break-all; color: #999; text-align: center; font-weight: 500;}
.cmt-area .cmt-list li .conts span {color: #ea490f;}
.cmt-area .cmt-list li:nth-child(2n) .conts span {color: #3543e3;}
.cmt-area .cmt-list li .writer {font-size:1.11rem; color: #aaa; text-align: right;}
.cmt-area .cmt-list li button.delete {position: absolute; top: .7rem; right: 1rem; color: #aaa; font-size: 2rem;}
.cmt-area .pagingV15a {padding: .5rem 0 2.8rem;}
.cmt-area .pagingV15a span {min-width: 2.8rem; height: 2.8rem; margin: 0 .2rem; line-height: 2.8rem; font-size: 1.28rem; font-weight: 500; color: #ffdccf; border-radius: 50%}
.cmt-area .pagingV15a span.current {font-weight: normal; color: #fff; background-color: #3543e3; }
.pagingV15a .arrow a {width: 2.77rem; background: none; background: url(//webimage.10x10.co.kr/fixevent/event/2019/95815/m/btn_arrow.png) 0 -.1rem /3.2rem;}
.pagingV15a .arrow.nextBtn a {transform: rotateY(180deg)}
.pagingV15a .arrow a:after {content: unset;}
</style>
<script type="text/javascript" src="/lib/js/TweenMax.min.js"></script>
<script type="text/javascript">
$(function(){
    (function(){
        rolling1 = new Swiper(".rolling .swiper-container",{
            effect:'fade',
            autoplay:3500,
            speed:800,
            nextButton:'.rolling .btnNext',
            prevButton:'.rolling .btnPrev'
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
<div class="mEvt95815">
    <div class="topic ">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_top.jpg" alt=""></p>
        <div class="pos">
            <p class=""><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/tit_1.png" alt="텐바이텐x대림미술관"></p>
            <p class="delay1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/tit_2.png" alt="7월의 문화생활"></p>
            <p class="delay2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/tit_3.png" alt="대림미술관 ≪하이메 아욘≫ 전시에 텐바이텐 고객  500분을 초대합니다."></p>
        </div>
    </div>
    <div class="intro">
        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_intro.jpg" alt="JAJU 리버스 윈드 써큘레이터 선풍기란?"></span>
        <div class="rolling">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_slide_1.jpg" alt="" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_slide_2.jpg" alt="" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_slide_3.jpg" alt="" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_slide_4.jpg" alt="" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_slide_5.jpg" alt="" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_slide_6.jpg" alt="" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_slide_7.jpg" alt="" /></div>
                </div>
            </div>
            <div class="btn-area">
                <button class="btn-arrow btnPrev">이전</button>
                <button class="btn-arrow btnNext">다음</button>
            </div>
        </div>
    </div>
    <div class="vod-wrap shape-rtgl posr">
        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/bg_vod.jpg" alt=""></span>
        <div class="vod pos">
            <iframe src="https://www.youtube.com/embed/ST21xe-QjU8?list=PLf5kadn9tolzbcZUiD_yvhHNXyLrEwcDJ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </div>
    </div>
    <div class="cmt-area">
        <div class="cmt-input">
            <div class="inner">
                <div class="input-box posr">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_cmt.jpg?v=1.01" alt="quiz event"></span>
                    <div class="input-wrap">
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

                            <input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" title="검색어 입력" placeholder="정답을 입력해주세요!" maxlength="5" onkeyup="chkword(this,10);"/>
                            <p class="now-txt"><span id="nowtxt">0</span>/5</p>
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
                </div>
            </div>
            <button type="button" onclick="jsSubmitComment(document.frmcom);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/btn_cmt.jpg?v=1.01" alt="등록하기"></button>
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
                        정답은 <span><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></span>입니다!
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
        <a href="/culturestation/" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>')" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/bnr.png" alt="다양한 문화생활 즐기러 가기"></a>
        <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>', function(bool){if(bool) {fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appcom/wish/web2014/culturestation/');}});return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/bnr.png" alt="다양한 문화생활 즐기러 가기"></a>
    </div>
    <div class="noti">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/95815/m/img_notice.jpg" alt="유의사항">
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->