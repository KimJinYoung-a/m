<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 탐구생활 연말정산
' History : 2018-12-13 이종화
'####################################################
dim oItem
dim currenttime
	currenttime =  now()

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  89172
Else
	eCode   =  90601
End If

dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vPIdx = request("pidx")

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
.life-621{background-color:#eee;}
.life-621 .top {position:relative;}
.life-621 .section {position:relative;}
.life-621 .section .bg-img img,
.life-621 .comment-head h3 img,
.life-621 span a img {margin-top: -1px;}
.life-621 .top {position: relative;}
.life-621 .top > div span {position: absolute; animation: titAni .8s ease-in forwards; opacity: 0;}
.life-621 .top > div span.txt-01 {top:5.72rem}
.life-621 .top > div span.txt-02 {top:11.35rem; animation-delay: .5s;}
.life-621 .top > div span.txt-03 {top:24.75rem; animation-delay: .8s;}
.life-621 .top > div span.txt-04 {top:33.45rem; animation-delay: 1.2s;}
.comment-head {position:relative;}
.comment-write {position:absolute; top:50.9%;}
.comment-write input {width:19.2rem; height:2.99rem; line-height:2.99rem; margin-left:3.41rem; font-size:1.62rem; font-weight:600; text-align:center; color:#666; border:0; background-color: transparent;}
.comment-write input::-webkit-input-placeholder {color:#8e8d87;}
.comment-write input::-moz-placeholder {color:#8e8d87;} 
.comment-write input:-ms-input-placeholder {color:#8e8d87;} 
.comment-write input:-moz-placeholder {color:#8e8d87;}
.comment-write textarea {position: relative; width: 22.8rem; height: 12.8rem; line-height:3.67rem; margin: 3.6rem 0 0 4rem; box-sizing:unset;  background-color: transparent; font-family:appleGothic, 'helvetica Neue', helveticaNeue, helvetica, malgungothic, '맑은고딕', sans-serif !important; font-size: 1.19rem; font-weight: 600; text-align:left; color:#666; border:0; overflow: hidden; z-index:14; }
.comment-write textarea::-webkit-input-placeholder {color:#8e8d87;}
.comment-write textarea::-moz-placeholder {color:#8e8d87;}
.comment-write textarea:-ms-input-placeholder {color:#8e8d87;}
.comment-write textarea:-moz-placeholder {color:#8e8d87;}
.comment-write button {display:block; margin-top: 3rem;}
.comment-list {padding:3.4rem 0 2.47rem; background:#be9b7b;}
.comment-list ul {padding:0 2.13em;}
.comment-list li {position:relative; margin-top:1.28rem;}
.comment-list li:first-child {margin-top:0;}
.comment-list li .cmt-area {padding:1.9rem; font-size:0.9rem; line-height:4.18rem; letter-spacing:-0.03rem; background:#fff;}
.comment-list li .btn-delete {position:absolute; right:-3.5rem; top:-3.5rem; width:7.66rem; padding:3rem;}
.comment-list li p {line-height:normal; padding: 0 .5rem;}
.comment-list li .writer {float:left; font-size:1rem; color:#666; }
.comment-list li .num {float:right; font-size:1rem; color:#d82125;}
.comment-list li .tit {clear:both; padding-top: .4rem; padding-bottom: .9rem; font-size:1.45rem; font-weight:600; color:#222; border-bottom:1px solid #242424;}
.comment-list li .txt {max-height:7.5rem; overflow:auto; padding-top:.9rem; font-size:1.19rem; font-weight:600; line-height:1.9rem; color:#333;}
.comment-list li .txt::-webkit-scrollbar { width:5px; height:5px; } 
.comment-list li .txt::-webkit-scrollbar-track { background:#fff; -webkit-box-shadow: inset 0 0 6px rgba(221,221,221,0); } 
.comment-list li .txt::-webkit-scrollbar-thumb { background:#ddd; border-radius: 5px; -webkit-box-shadow: inset 0 0 6px rgba(255,255,255,0); } 
.comment-list li .writer em {font-weight:bold;}
.comment-list .pagingV15a {margin-top:2.65rem;}
.comment-list .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#333; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.comment-list .pagingV15a a {padding-top:0;}
.comment-list .pagingV15a .current {color:#fff; background:#333; border-radius:50%;}
.comment-list .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(http://webimage.10x10.co.kr/play/life/btn_paging_next.png) 0 0 no-repeat; background-size:100% 100%;}
@keyframes titAni {
        from {transform:translateY(100px);}
        to {opacity:1;}}
</style>
<script type="text/javascript">
$(function(){
    <% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
    var position = $('.life-621').offset(); // 위치값
    $('html,body').animate({ scrollTop : position.top },300); // 이동

    titleAnimation();
    $(".top h2 img").css({"margin-left":"-100px","opacity":"0"});
    function titleAnimation() {
        $(".top h2 img").delay(100).animate({"margin-left":"0px","opacity":"1"},800)
    }
    Swiper(".swiper01 .swiper-container",{
        loop:true,
        autoplay:2500, //181101
        speed:800,
        pagination:".swiper01 .pagination",
        paginationClickable:true,
        prevButton:'.swiper01 .btnPrev',
        nextButton:'.swiper01 .btnNext',
        effect:'fade'
    });

    $("a.alink01").click(function(event){
        $('html,body').animate({'scrollTop':$(this.hash).offset().top + 'px'},1000);
    })
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('<%=appUrlPath%>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=on&iCC=' + iP);
}

function jsSubmitComment(frm){	
	<% If IsUserLoginOK() Then %>	
		<% if date() >="2018-11-16" and date() <= "2018-12-03" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
                if(!frm.txtcommURL.value){
					alert("추억의 아이템 이름을 입력 해주세요.");
					document.frmcom.txtcommURL.value="";
					frm.txtcommURL.focus();
					return false;
				}

                if (GetByteLength(frm.txtcommURL.value) > 20){
					alert("제한길이를 초과하였습니다. 10자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}

				if(!frm.txtcomm.value){
					alert("추억을 소환 해주세요.");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 200){
					alert("제한길이를 초과하였습니다. 100자 까지 작성 가능합니다.");
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playwebview/detail.asp?pidx="&vPIdx&"")%>');
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playwebview/detail.asp?pidx="&vPIdx&"")%>');
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
</script>
<div class="life-621">
    <div class="top">
        <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/tit_bg.png" alt="이거 알면 옛날 사람" /></p>
        <div>
            <span class="txt-01"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/top_01.png" alt="그 시절 우리가 좋아했던 것들" /></span>
            <span class="txt-02"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/top_02.png?v=1.01" alt="이거알면 옛날사람" /></span>
            <span class="txt-03"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/top_03.png" alt="추억의 아이템을 소환해 보아요" /></span>
            <span class="txt-04"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/top_04.png" alt="2018년도 두 달 밖에 남지 않았어요" /></span>
        </div>
    </div>
    <div class="section">
        <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/img_01.png?v=1.02" alt="스킬자수" /></p>
    </div>
    <div class="section">
        <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/img_02.png?v=1.02" alt="공기놀이" /></p>
    </div>
    <div class="section">
        <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/img_03.png?v=1.02" alt="종이인형" /></p>
    </div>
    <div class="section">
        <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/img_04.png?v=1.02" alt="다마고치" /></p>
    </div>
    <div class="section">
        <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/img_05.png?v=1.02" alt="빵스티커" /></p>
    </div>
    <span>
        <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90601#group264664');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/btn_go.png?v=1.02" alt="추억템 만나러 가기" /></a>
        <a href="/event/eventmain.asp?eventid=90601#group264664" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/btn_go.png?v=1.02" alt="추억템 만나러 가기" /></a>
    </span>
    <div class="comment">
        <form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
        <input type="hidden" name="mode" value="add">
        <input type="hidden" name="pagereload" value="ON">
        <input type="hidden" name="iCC" value="1">
        <input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
        <input type="hidden" name="eventid" value="<%= eCode %>">
        <input type="hidden" name="linkevt" value="<%= eCode %>">
        <input type="hidden" name="blnB" value="">
        <input type="hidden" name="returnurl" value="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=ON">
        <input type="hidden" name="isApp" value="<%= isApp %>">	
        <input type="hidden" name="spoint"/>			
        <div class="comment-head">
            <h3><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/bg_comment.png" alt="여러분은 어떤 추억의 아이템이 그립나요?"></h3>
            <div class="comment-write">
                <input type="text" title="나의 추억의 아이템은" id="txtcommURL" name="txtcommURL" placeholder="10자 이내로 입력"  maxlength="10"  onClick="jsCheckLimit();"/>
                <textarea placeholder="100자 이내로 입력" id="txtcomm" name="txtcomm" maxlength="100" onClick="jsCheckLimit();"></textarea>
                <button onclick="jsSubmitComment(document.frmcom);"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/btn_cmt_write.png" alt="추억 소환하기"></button>
            </div>
        </div>
        </form>
        <form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
        <input type="hidden" name="mode" value="del">
        <input type="hidden" name="pagereload" value="ON">
        <input type="hidden" name="Cidx" value="">
        <input type="hidden" name="returnurl" value="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=ON">
        <input type="hidden" name="eventid" value="<%= eCode %>">
        <input type="hidden" name="linkevt" value="<%= eCode %>">
        <input type="hidden" name="isApp" value="<%= isApp %>">
        </form>
        <%'!-- 코멘트 목록(6개씩 노출) --%>
        <div class="comment-list" id="comment">
            <% If isArray(arrCList) Then %>
            <ul>
                <% For intCLoop = 0 To UBound(arrCList,2) %>
                <li>
                    <div class="cmt-area">
                        <p class="writer"><em><%=printUserId(arrCList(2,intCLoop),2,"*")%></em>님의 추억의 아이템</p>
                        <p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                        <p class="tit">#<%=db2html(arrCList(7,intCLoop))%></p>
                        <p class="txt"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
                    </div>	
                    <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                        <button type="button" class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/btn_cmt_delete.png" alt="코멘트 삭제" /></button>
                    <% End If %>								
                </li>
                <% Next %>
            </ul>
            <% End If %>					
            <% If isArray(arrCList) Then %>
            <div class="paging pagingV15a">
                <%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
            </div>
            <% end if %>
        </div>
    </div>
</div>