<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : JAJU 써큘레이터 이벤트
' History : 2019-05-22 최종원 생성
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

evtStartDate = Cdate("2019-05-22")
evtEndDate = Cdate("2019-06-02")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  89172
Else
	eCode   =  94534
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
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
.mEvt94534 {position: relative; background-color: #e1f4fb;}
.mEvt94534 button {background-color: transparent; border: 0;}
.mEvt94534 .pos {position: absolute; top: 0; left: 0; width: 100%;}
.mEvt94534 .posr {position: relative;}
.mEvt94534 textarea:focus::-webkit-input-placeholder {opacity: 0;} 

.topic {position: relative; overflow: hidden;}
.topic.on {transform: scale(1.1); transition-duration: .5s}
.topic.on span {transition-duration: .4s}
.topic div span {display: block; transform:skewX(-10deg); transition-duration: 1.6s}
.topic div.on span {transform:skewX(0)}
.topic div span.delay2 {transition-delay: .5s}
.topic div span.delay3 {transition-delay: .8s}
.topic > p {transition-duration: 1.2s; transition-timing-function:cubic-bezier(0.68,-0.1, 1, 1);transform-origin:center top;}
.topic > p.on {transform: scale(1.15)}

.info .rolling {position:relative;}
.info .rolling {position: relative;}
.info .rolling .swiper-scrollbar {position:absolute; top: 7%; right: 0; z-index:50; width:89%; height:0.1rem; text-align:center; background-color:#e2e6ef; border-radius:0; opacity: 1 !important;}
.info .rolling .swiper-scrollbar-drag {top: -0.09rem; height: .18rem; background-color:#00aeff; border-radius:0; }
.info .rolling .pagination {overflow:hidden; position:absolute; top:0; right:0;; z-index:10; height:11%; width: 90%;  padding: 0}
.info .rolling .pagination:after {content: ''; display: block; clear: both;}
.info .rolling .pagination .swiper-pagination-switch {float:left; display: block; width:25%; height:100%; margin: 0; text-indent:-999em; border-radius: 0; opacity: .4; background-color: transparent;}
.info .rolling .btn-area {position: absolute; bottom: 2.13rem; right: 1.28rem; z-index: 66;}
.info .rolling .btn-area > div {display: inline-block; width: 2.13rem; height: 2.13rem; background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/94534/m/btn_prev.jpg); background-size: cover; text-indent: -999rem;}
.info .rolling .btn-area > div.btnNext {transform: rotateY(180deg)}

.cmt-evt {background-color:#e8fefb;}
.cmt-evt .inner {width: 32rem; margin: 0 auto; }
.cmt-evt .imgbx-area:after {content: ''; display: block; clear: both;}
.cmt-evt .imgbx-area > p {z-index: 9999;}
.cmt-evt .imgbx-area > div {position: relative; float: left; width: 50%; height: 29.27rem;}
.cmt-area {margin-top: -.08rem; text-align:center; background-color:#e8fefb;}
.cmt-area .cmt-input > div, .cmt-input > button {position: relative; display: block; width:32rem; margin:0 auto;}
.cmt-area .cmt-input .textarea-wrap {position:absolute; top:0; left:0; width:100%; height:100%; padding:1rem 3rem 2.7rem;}
.cmt-area .cmt-input .textarea-wrap .now-txt {position: absolute; bottom: 1rem; right: 3rem; color:#999; font-size:1.02rem;}
.cmt-area .cmt-input textarea {overflow:hidden;width:100%; height:100%; padding:0; border:0; background-color:transparent; color:#666; font-size:1.11rem; line-height:1.7; font-weight:600; text-align:left;}
.cmt-area .cmt-input textarea::-webkit-input-placeholder {color:#999;}
.cmt-area .cmt-input textarea::-moz-placeholder {color:#999;}
.cmt-area .cmt-input textarea:-ms-input-placeholder {color:#999;}
.cmt-area .cmt-input textarea:-moz-placeholder {color:#999;}
.cmt-area .cmt-list {background-color:#e8f0f1; padding-top: 2.13rem;}
.cmt-area .cmt-list ul {width:32rem; margin:0 auto;}
.cmt-area .cmt-list li {position:relative; width: 27.73rem; margin:0 auto 1.28rem; padding: 1.49rem; text-align:left; background-color: #fff;}
.cmt-area .cmt-list li:last-child {margin-bottom: 0;}
.cmt-area .cmt-list li .num {margin-bottom: 1rem; font-size:1.11rem; font-weight:bold; color: #4cc6ff;}
.cmt-area .cmt-list li .conts {margin-bottom: .6rem; font-size:1.15rem; line-height:1.6; word-wrap:break-word; word-break:break-all;}
.cmt-area .cmt-list li .writer {margin-bottom: .7rem; font-size:1.11rem; color: #aaa;}
.cmt-area .cmt-list li .btn-area {margin-top: 1.2rem;}
.cmt-area .cmt-list li button {width: 4.69rem; height: 2.35rem; color: #35455f; margin-right: .5rem; font-size: 1.02rem; background-color: #bfebff;}
.cmt-area .cmt-list li button.delete {background-color: #dadfe9;}
.cmt-area .pagingV15a {padding-bottom: 1.8rem; padding-top: .5rem; margin-top: 0; background-color: #e8f0f1;}
.cmt-area .pagingV15a .arrow {opacity: .5;}
.cmt-area .pagingV15a span {min-width: 1.28rem; margin: 0 .8rem; color: #abb4c5;}
.cmt-area .pagingV15a span.current {font-weight: normal; color: #4cc6ff; border-bottom: 0.23rem solid #4cc6ff; }
.cmt-area .pagingV15a span.current a{transform: skewX(-10deg)}
.noti {padding:3.2rem 6.67% ; background-color:#c1cbe1; color: #202c46; }
.noti h5 {margin-bottom: 1rem; font-weight: bold; font-size: 1.21rem;}
.noti li {margin:.68rem 0; padding-left:.77rem; font-size:1.02rem; line-height:1.6; text-indent:-.7rem;}
</style>
<script>
$(function(){
    $('.topic div').addClass('on');
    $(window).scroll(function(){
        $('.topic > p').addClass('on');
        if($(window).scrollTop()<1){
            $('.topic > p').removeClass('on')
        }
    });
    rolling1 = new Swiper(".rolling .swiper-container",{
        effect:'fade',
        autoplay:2000,
        speed:800,
        pagination:".rolling .pagination",
        paginationClickable:true,
		scrollbar:'.swiper-scrollbar',
        nextButton:'.rolling .btnNext',
	    prevButton:'.rolling .btnPrev'
    });
    //구성품
    swiper = new Swiper('.imgbx1', {
        autoplay:2400,
        loop: true,
        effect:'fade',
        speed:900,
    });
    swiper = new Swiper('.imgbx2', {
        autoplay:1600,
        loop: true,
        effect:'fade',
        speed:900,
    });
});
</script>
<script type="text/javascript">
$(function () {
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
    <% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".cmt-list").offset().top}, 0);
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
			<% if commentcount>0 then %>
				alert("한 ID당 1회만 참여 가능합니다.");
				return false;
            <% else %>
                if(frm.txtcomm1.value == ""){
                    alert('내용을 넣어주세요.')
                    frm.txtcomm1.focus()
                    return false;
                }                   
				frm.txtcomm.value = frm.txtcomm1.value
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
}

function fnChkByte(obj) {
    var maxByte = 300; //최대 입력 바이트 수
    var str = obj.value;
    var str_len = str.length;
 
    var rbyte = 0;
    var rlen = 0;
    var one_char = "";
    var str2 = "";
 
    for (var i = 0; i < str_len; i++) {
        one_char = str.charAt(i);
 
        if (escape(one_char).length > 4) {
            rbyte += 2; //한글2Byte
        } else {
            rbyte++; //영문 등 나머지 1Byte
        }
 
        if (rbyte <= maxByte) {
            rlen = i + 1; //return할 문자열 갯수
        }
    }    
 
    if (rbyte > maxByte) {
        alert("한글 "+ (maxByte / 2) +"자 이내로 작성 가능합니다.");
        str2 = str.substr(0, rlen); //문자열 자르기
        obj.value = str2;
        fnChkByte(obj, maxByte);
    } else {
        document.getElementById('byteInfo').innerText = Math.ceil(rbyte / 2);
    }
}
</script>
			<div class="mEvt94534">
                <div class="topic ">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/bg_top.jpg?v=1.07" alt=""></p>
                    <div class="pos">
                        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_top_01.png" alt="ten by ten x jaju"></p>
                        <span class="delay1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_top_02.png?v=1.01" alt="쾌적하고 향기로운"></span>
                        <span class="delay2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_top_03.png" alt="여름날의 바람 선물!"></span>
                        <span class="delay3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_top_04.png" alt="jaju 써큘레이터 선풍기 알아보고 이벤트 참여해서 바람선물 받아가세요!"></span>
                    </div>
                </div>
                <div class="info">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_info.jpg" alt="JAJU 리버스 윈드 써큘레이터 선풍기란?"></span>
                    <div class="rolling">
                        <div class="swiper-container">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_slide_01.jpg?v=1.01" alt="" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_slide_02.jpg?v=1.01" alt="" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_slide_03.jpg?v=1.01" alt="" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_slide_04.jpg?v=1.01" alt="" /></div>
                            </div>
                        </div>
				        <div class="swiper-scrollbar"></div>
                        <div class="pagination"></div>
                        <div class="btn-area">
                            <div class="btn-arrow btnPrev">이전</div>
                            <div class="btn-arrow btnNext">다음</div>
                        </div>
                    </div>
                    <a href="/category/category_itemPrd.asp?itemid=2365180&pEtr=94534" onclick="TnGotoProduct('2365180');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/btn_more.jpg" alt="자세히 알아보기">
                    </a>
                </div>
                <div class="cmt-evt">
                    <div class="inner">
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_evt.jpg?v=1.01" alt="여름을 시원하게 보내는 당신만의 방법을 알려주세요!"></span>
                        <div class="imgbx-area posr">
                            <p class="pos"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/txt_prd.png" alt="구성품"></p>
                            <div class="imgbx1">
                                <ul class="swiper-wrapper">
                                    <li class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_prd1_01.jpg?v=1.03" alt="" /></li>
                                    <li class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_prd1_02.jpg?v=1.03" alt="" /></li>
                                    <li class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_prd1_03.jpg?v=1.03" alt="" /></li>
                                </ul>
                            </div>
                            <div class="imgbx2">
                                <ul class="swiper-wrapper">
                                    <li class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_prd2_01.jpg?v=1.03" alt="" /></li>
                                    <li class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_prd2_02.jpg?v=1.03" alt="" /></li>
                                    <li class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_prd2_03.jpg?v=1.03" alt="" /></li>
                                    <li class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_prd2_04.jpg?v=1.03" alt="" /></li>
                                    <li class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94534/m/img_prd2_05.jpg?v=1.03" alt="" /></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="cmt-area">
                    <div class="cmt-input">
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
                            <div class="input-box posr">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/bg_textarea.jpg?v=1.05" alt="">                            
                                <div class="textarea-wrap">
                                    <textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="fnChkByte(this);" maxlength="150" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> placeholder="띄어쓰기 포함 150자 이내로 적어주세요!"></textarea>
                                    <p class="now-txt"><span id="byteInfo">0</span> / 150자</p>
                                </div>                            
                            </div>
                            <button type="button" onclick="jsSubmitComment(document.frmcom); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/btn_enter.jpg" alt="등록하기"></button>
                            <button type="button" onclick="location.href='http://www.sivillage.com/jaju/shop/initJaJuNShop.siv?disp_ctg_no=1905008085&partnerNm=jaju_10x10'"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94534/m/btn_jaju.jpg" alt="jaju에도 이벤트 참여하러 가기"></button>
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
                    <% IF isArray(arrCList) THEN %>       
                    <div class="cmt-list">                        
                        <ul>
                        <% For intCLoop = 0 To UBound(arrCList,2) %>                
                            <li>
                                <p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                                <div class="conts">
                                    <%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%>
                                </div>
                                <p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
                                <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>                                
                                <div class="btn-area">                                    
                                    <button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button>                                    
                                </div>
                                <% end if %>                                
                            </li>    
                        <% Next %>                       
                        </ul>    
                    </div>
                    <% End If %>                    
                    <div class="paging pagingV15a">
                        <% If isArray(arrCList) Then %>
                        <%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
                        <% End If %>
                    </div>                    
                </div>
                <!-- 유의사항 -->
                <div class="noti">
                    <h5>이벤트 유의사항</h5>                    
                    <ul>
                        <li>- 해당 이벤트는 로그인 후, 한 ID당 1회만 참여할 수 있습니다.</li>
                        <li>- 입력 완료된 댓글 내용은 수정이 불가합니다.</li>
                        <li>- 통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</li>
                        <li>- 이벤트 당첨자는 2019년 6월 7일 금요일 텐바이텐 공지사항에 기재 및 개별연락 드릴 예정입니다.</li>
                        <li>- 당첨된 고객께는 세무신고를 위해 개인정보를 요청 할 수 있습니다.  제세공과금은 자주 부담입니다.</li>
                        <li>- 당첨된 [바람 선물] 구성품은 상품별로 각각 배송될 예정입니다.</li>
                        <li>- 자주X텐바이텐 이벤트 당첨 고객의 최소한의 개인정보는 경품 배송을 위해 양사에 제공될 수 있습니다. 배송된 후 개인정보는 즉시 파기 될 예정입니다.</li>
                    </ul>                    
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->