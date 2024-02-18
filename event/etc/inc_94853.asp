<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 토이스토리4 이벤트 
' History : 2019-06-07 원승현 생성
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

evtStartDate = Cdate("2019-06-07")
evtEndDate = Cdate("2019-06-30")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90310
Else
	eCode   =  94853
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

'// 전체 유저 참여수(unique user)
Dim strSql, uniqueUserCnt
strSql = " SELECT COUNT(DISTINCT userid) as userCnt FROM db_event.dbo.tbl_event_comment WITH(NOLOCK) WHERE evtcom_using='Y' AND evt_code='"&eCode&"' "
rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
uniqueUserCnt = rsget("userCnt")
rsget.close
%>
<style type="text/css">
<% If (Now() > #06/19/2019 00:00:00# AND Now() < #06/26/2019 00:00:00#) Then %>
    .mEvt94853 {position: relative; background-color: #12418f; overflow: hidden;}
    .mEvt94853 > div {position: relative; z-index: 8;}
    .mEvt94853 .posr {position: relative;}
    .mEvt94853 .pos {position: absolute; left: 0; width: 100%;}
    .mEvt94853 .inner {width:32rem; margin:0 auto;}
    .mEvt94853 .clearFix:after {content: ''; display: block; clear: both;}
    .mEvt94853 .clearFix li {float: left;}
    .topic span img {transform: scale(1.2); transform-origin: 50% bottom;     transition-timing-function: ease-out; transition-duration: .3s}
    .topic.on span img {transform: scale(1)}
    .topic h2 {bottom: 3rem; animation:topicani 2.5s  forwards ease-out }
    .vod-area {background-color:#57beff}
    .vod-area .vod-wrap {width: 28.42rem; margin:0 auto}
    .vod-area li {width: 50%;}
    .mEvt94853 .info > p:before {content: ''; display: block; height: 12.46rem; width: auto; text-indent: -999rem; background: url(http://webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_snss.jpg)   repeat-x  0 0 ; background-size: cover;animation: emoticon 180s infinite linear;}
    .frd {margin-top: -.1rem; background-color: #fff17a;}
    .frd .btn-arrow {position: absolute; top: 33%; width: 1.4rem; fill:#f3ecb2; z-index: 999; background-color: transparent;}
    .frd .btn-arrow.prev {left: 5rem; transform: rotateY(180deg);}
    .frd .btn-arrow.next{right: 5rem;}
    .frd .pagination {top: 0; z-index: 999; left: 50%; margin-left: -13.9rem;}
    .frd .pagination:after {content: ''; display: block; clear: both;}
    .frd .pagination .swiper-pagination-switch {float: left; width: 5.55rem; height: 3rem; margin: 0; background-color: transparent; border-radius: 0}
    .evt1 {background-color: #9867ff;}
    .evt1 .bounce {position: absolute; top: 1.2rem; right: 3.8rem; display: block; width: 10%;}
    .evt1 .guide {position: relative;}
    .evt1 .guide:before,
    .evt1 .guide:after {animation: leftgo .7s infinite; position: absolute; top: 25%; left: 48%; content: ''; display: block; width: .72rem; height: 1.75rem; background: url(//webimage.10x10.co.kr/fixevent/event/2019/94853/m/ico_tri.png) no-repeat; background-size: contain;}
    .evt1 .guide:after {top: 62%}
    .evt1 .soldout {display:none; position:absolute; top:2%; left:0; z-index:10;}

    .evt2 {background-color: #641ef0;}
    .mEvt94853 .info div ul li {width: 32rem;}
    .cmt-write .inner > div {top: 0;}
    .cmt-write {background-color:#793df5;}
    .cmt-write .radio-area {width:89%; margin:auto;}
    .cmt-write .radio-area:after {content: ''; display: block; clear: both;}
    .cmt-write .radio-area span {float: left; display: block; width: 33.33%;}
    .cmt-write .radio-area span:nth-child(4) {margin-left:17%;}
    .cmt-write .radio-area input {position: absolute;left: -999rem;}
    .cmt-write .radio-area label{position: relative; display: block; cursor: pointer; width: 100%; padding-bottom: 138%; text-indent:-9999px;}
    .cmt-write .radio-area label:before {content: ''; position: absolute; left: 50%; top: .1rem; display: block; width: 1.68rem;height: 1.34rem; margin-left:-.84rem; background-color: transparent; background-repeat: no-repeat; background-size: contain;}
    .cmt-write .radio-area input:checked+label:before {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/94853/m/ico_chk.png);}
    .cmt-write textarea {width: 26rem; height: 5.5rem; margin: 2.5rem 0 0 3rem; font-family: 'AppleSDGothicNeo-Regular'; font-size: 1.28rem; background-color: transparent; border: 0; color: #444;}
    .cmt-write textarea::-webkit-input-placeholder {color: #999;}
    .cmt-write textarea:focus::placeholder  {opacity: 0;} 
    .cmt-write .now-txt {position: absolute; bottom: 5rem; right: 3rem; color:#999; font-size:0.98rem; background-color: #fff;}
    .cmt-write form button {width: 100%; height: 5rem; background-color: transparent; text-indent: -999rem;}
    .cmt-write > button {margin-top: -.1rem;}
    .cmt-list {padding-bottom: .1rem; background-color:#6722f3}
    .cmt-list ul {padding-top:8.5rem;}
    .cmt-list ul li {position:relative; width: 27.95rem; height: 15rem; margin: 0 auto 8rem; padding:5rem 3.11rem 1.7rem; text-align:left;}
    .cmt-list li.toy-01 {background-color:#ffe9da;}
    .cmt-list li.toy-02 {background-color:#f3d9ff;}
    .cmt-list li.toy-04 {background-color:#ffdcdc;}
    .cmt-list li.toy-03 {background-color:#d6f7ff;}
    .cmt-list li.toy-05 {background-color:#d9ffe0;}
    .cmt-list li:before {content:''; position:absolute; top: 0; left:50%;  display:block; width:10.45rem; height:10.45rem; margin-left:-5.22rem; margin-top: -5.5rem; background-size: 10.45rem;}
    .cmt-list li.toy-01:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_01.png); }
    .cmt-list li.toy-02:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_02.png); }
    .cmt-list li.toy-03:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_03.png); }
    .cmt-list li.toy-04:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_04.png); }
    .cmt-list li.toy-05:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_05.png); }
    .cmt-list ul li .desc {margin-bottom: 1.3rem;}
    .cmt-list ul li .desc:after {content: ''; display: block; clear: both;}
    .cmt-list ul li .desc .num {float:left; font-size:1.3rem; font-weight:bold;}
    .cmt-list ul li .desc .writer {float:right; font-size:1.11rem;}
    .cmt-list ul li .conts {font-family: 'AppleSDGothicNeo-Regular'; font-size:1.15rem; line-height:1.67; word-wrap:break-word; word-break: break-all;}
    .cmt-list ul li .conts span {display: block; margin: 1.28rem 0 1.5rem;}
    .cmt-list ul li .conts p {line-height: 1.4;}
    .cmt-list .delete {position:absolute; top:1rem; right:1rem; padding: .7rem .8rem; background: #6722f3; color: #fff; border-radius: 2rem; }
    .pagingV15a {margin-top:-7rem; padding-top:2.13rem; padding-bottom:4.27rem; background-color:#6722f3;}
    .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#aabdfc; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
    .pagingV15a a {padding-top:0;}
    .pagingV15a .current {color:#fff; background:#30f454; border-radius:50%;}
    .pagingV15a .arrows a {display: block; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/m/btn_next.png); background-size: contain; text-indent: -999rem;}
    .pagingV15a .arrows.prevBtn a {transform: rotateY(180deg);}
    .mEvt94853 .notice {padding-bottom: 3rem; background-color: #1ab6e9; color: #fff;}
    .mEvt94853 .notice ul {margin: 0 3rem 0 3.7rem;}
    .mEvt94853 .notice li {text-indent: -.7rem; line-height: 2; word-break: keep-all;}
    .mEvt94853 .bounce{animation:bounce .7s infinite;}
    @keyframes bounce {
        from, to {transform:translateY(-.3rem); animation-timing-function:ease-out;}
        50% {transform:translateY(.3rem);  animation-timing-function:ease-in;}
    }
    @keyframes topicani {
        0% {transform:translateY(-1000px); animation-timing-function: ease-in}
        18%,42%,70%,100% {transform:translateY(0); animation-timing-function: ease-out}
        29%{transform:translateY(-110px); animation-timing-function: ease-in}
        55% {transform:translateY(-60px); animation-timing-function: ease-in}
        85% {transform:translateY(-30px); animation-timing-function: ease-in}
    }
    @keyframes emoticon {
        from {background-position: 0 50%}
        to {background-position: -1000rem 50% }
    }
    @keyframes leftgo {
        from {transform: translateX(-1rem); animation-timing-function:ease-out;}
        50%{opacity: 1;}
        to {transform: translateX(1rem);  animation-timing-function:ease-in; opacity: 0;}
    }
<% Else %>
    .mEvt94853 {position: relative; background-color: #12418f; overflow: hidden;}
    .mEvt94853 > div {position: relative; z-index: 8;}
    .mEvt94853 .posr {position: relative;}
    .mEvt94853 .pos {position: absolute; left: 0; width: 100%;}
    .mEvt94853 .inner {width:32rem; margin:0 auto;}
    .mEvt94853 .clearFix:after {content: ''; display: block; clear: both;}
    .mEvt94853 .clearFix li {float: left;}
    .topic span img {transform: scale(1.2); transform-origin: 50% bottom;     transition-timing-function: ease-out; transition-duration: .3s}
    .topic.on span img {transform: scale(1)}
    .topic h2 {bottom: 3rem; animation:topicani 2.5s  forwards ease-out }
    .vod-area {background-color:#57beff}
    .vod-area .vod-wrap {width: 28.42rem; margin:0 auto}
    .vod-area li {width: 50%;}
    .mEvt94853 .info > p:before {content: ''; display: block; height: 12.46rem; width: auto; text-indent: -999rem; background: url(http://webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_snss.jpg)   repeat-x  0 0 ; background-size: cover;animation: emoticon 180s infinite linear;}
    .frd {margin-top: -.1rem; background-color: #fff17a;}
    .frd .btn-arrow {position: absolute; top: 33%; width: 1.4rem; fill:#f3ecb2; z-index: 999; background-color: transparent;}
    .frd .btn-arrow.prev {left: 5rem; transform: rotateY(180deg);}
    .frd .btn-arrow.next{right: 5rem;}
    .frd .pagination {top: 0; z-index: 999; left: 50%; margin-left: -13.9rem;}
    .frd .pagination:after {content: ''; display: block; clear: both;}
    .frd .pagination .swiper-pagination-switch {float: left; width: 5.55rem; height: 3rem; margin: 0; background-color: transparent; border-radius: 0}
    .evt1 {background-color: #9867ff;}
    .evt1 .bounce {position: absolute; top: 1rem; right: 3.8rem; display: block; width: 10%;}
    .evt1 .guide {position: relative;}
    .evt1 .guide:before,
    .evt1 .guide:after {animation: leftgo .7s infinite; position: absolute; top: 25%; left: 48%; content: ''; display: block; width: .72rem; height: 1.75rem; background: url(//webimage.10x10.co.kr/fixevent/event/2019/94853/m/ico_tri.png) no-repeat; background-size: contain;}
    .evt1 .guide:after {top: 62%}
    .evt2 {background-color: #641ef0;}
    .mEvt94853 .info div ul li {width: 32rem;}
    .cmt-write .inner > div {top: 0;}
    .cmt-write {background-color:#793df5;}
    .cmt-write .radio-area {width:89%; margin:auto;}
    .cmt-write .radio-area:after {content: ''; display: block; clear: both;}
    .cmt-write .radio-area span {float: left; display: block; width: 33.33%;}
    .cmt-write .radio-area span:nth-child(4) {margin-left:17%;}
    .cmt-write .radio-area input {position: absolute;left: -999rem;}
    .cmt-write .radio-area label{position: relative; display: block; cursor: pointer; width: 100%; padding-bottom: 138%; text-indent:-9999px;}
    .cmt-write .radio-area label:before {content: ''; position: absolute; left: 50%; top: .1rem; display: block; width: 1.68rem;height: 1.34rem; margin-left:-.84rem; background-color: transparent; background-repeat: no-repeat; background-size: contain;}
    .cmt-write .radio-area input:checked+label:before {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/94853/m/ico_chk.png);}
    .cmt-write textarea {width: 26rem; height: 5.5rem; margin: 2.5rem 0 0 3rem; font-family: 'AppleSDGothicNeo-Regular'; font-size: 1.28rem; background-color: transparent; border: 0; color: #444;}
    .cmt-write textarea::-webkit-input-placeholder {color: #999;}
    .cmt-write textarea:focus::placeholder {opacity: 0;} 
    .cmt-write .now-txt {position: absolute; bottom: 5rem; right: 3rem; color:#999; font-size:0.98rem; background-color: #fff;}
    .cmt-write form button {width: 100%; height: 5rem; background-color: transparent; text-indent: -999rem;}
    .cmt-write > button {margin-top: -.1rem;}
    .cmt-list {padding-bottom: .1rem; background-color:#6722f3}
    .cmt-list ul {padding-top:8.5rem;}
    .cmt-list ul li {position:relative; width: 27.95rem; height: 15rem; margin: 0 auto 8rem; padding:5rem 3.11rem 1.7rem; text-align:left;}
    .cmt-list li.toy-01 {background-color:#ffe9da;}
    .cmt-list li.toy-02 {background-color:#f3d9ff;}
    .cmt-list li.toy-03 {background-color:#d6f7ff;}
    .cmt-list li.toy-04 {background-color:#ffdcdc;}
    .cmt-list li.toy-05 {background-color:#d9ffe0;}
    .cmt-list li:before {content:''; position:absolute; top: 0; left:50%;  display:block; width:10.45rem; height:10.45rem; margin-left:-5.22rem; margin-top: -5.5rem; background-size: 10.45rem;}
    .cmt-list li.toy-01:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_01.png); }
    .cmt-list li.toy-02:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_02.png); }
    .cmt-list li.toy-03:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_03.png?v=1.00); }
    .cmt-list li.toy-04:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_04.png?v=1.00); }
    .cmt-list li.toy-05:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/img_cmt_05.png); }
    .cmt-list ul li .desc {margin-bottom: 1.3rem;}
    .cmt-list ul li .desc:after {content: ''; display: block; clear: both;}
    .cmt-list ul li .desc .num {float:left; font-size:1.3rem; font-weight:bold;}
    .cmt-list ul li .desc .writer {float:right; font-size:1.11rem;}
    .cmt-list ul li .conts {font-family: 'AppleSDGothicNeo-Regular'; font-size:1.15rem; line-height:1.67; word-wrap:break-word; word-break: break-all;}
    .cmt-list ul li .conts span {display: block; margin: 1.28rem 0 1.5rem;}
    .cmt-list ul li .conts p {line-height: 1.4;}
    .cmt-list .delete {position:absolute; top:1rem; right:1rem; padding: .7rem .8rem; background: #6722f3; color: #fff; border-radius: 2rem; }
    .pagingV15a {margin-top:-7rem; padding-top:2.13rem; padding-bottom:4.27rem; background-color:#6722f3;}
    .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#aabdfc; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
    .pagingV15a a {padding-top:0;}
    .pagingV15a .current {color:#fff; background:#30f454; border-radius:50%;}
    .pagingV15a .arrows a {display: block; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94853/m/btn_next.png); background-size: contain; text-indent: -999rem;}
    .pagingV15a .arrows.prevBtn a {transform: rotateY(180deg);}
    .mEvt94853 .notice {padding-bottom: 3rem; background-color: #1ab6e9; color: #fff;}
    .mEvt94853 .notice ul {margin: 0 3rem 0 3.7rem;}
    .mEvt94853 .notice li {text-indent: -.7rem; line-height: 2;}
    .mEvt94853 .bounce{animation:bounce .7s infinite;}
    @keyframes bounce {
        from to {transform:translateY(-.5rem); animation-timing-function:ease-out;}
        50% {transform:translateY(.5rem);  animation-timing-function:ease-in;}
    }
    @keyframes topicani {
        0% {transform:translateY(-1000px); animation-timing-function: ease-in}
        18%,42%,70%,100% {transform:translateY(0); animation-timing-function: ease-out}
        29%{transform:translateY(-110px); animation-timing-function: ease-in}
        55% {transform:translateY(-60px); animation-timing-function: ease-in}
        85% {transform:translateY(-30px); animation-timing-function: ease-in}
    }
    @keyframes emoticon {
        from {background-position: 0 50%}
        to {background-position: -1000rem 50% }
    }
    @keyframes leftgo {
        from {transform: translateX(-1rem); animation-timing-function:ease-out;}
        50%{opacity: 1;}
        to {transform: translateX(1rem);  animation-timing-function:ease-in; opacity: 0;}
    }
<% End If %>
</style>
<script type="text/javascript">
$(function(){
    $('.topic').addClass('on');
    swiper = new Swiper('.slide1', {
        loop: true,
        effect:'fade',
        speed:200,
        pagination:'.slide1 .pagination',	
        paginationClickable:true,			
        nextButton:'.slide1 .btn-arrow.next',
        prevButton:'.slide1 .btn-arrow.prev'	
    });
    $('.slide1 .btn-arrow').html('<svg xmlns="http://www.w3.org/2000/svg" width="100%" viewBox="0 0 25.969 47"><path id="_" data-name="&gt;"  class="btnArrow" d="M661.533,5242.8l23.807-23.48,2.174,2.15-23.808,23.48Zm0-42.67,2.173-2.15,23.808,23.49-2.174,2.15Z" transform="translate(-661.531 -5197.97)"/></svg>')
    //
    $('input[name=toy-img]').click(function(){	        
        $("#spoint").val($(this).val())
    })   
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
            if(frm.txtcomm1.value == ""){
                alert('내용을 넣어주세요')
                frm.txtcomm1.focus()
                return false;
            }            
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
function fnChkByte(obj) {
    var maxByte = 100; //최대 입력 바이트 수
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


            <%' 94853 토이스토리 %>
            <div class="mEvt94853">
                <div class="topic">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/bg_top.jpg?v=1.01" alt="" /></span>
                    <h2 class="pos"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/tit.png" alt="토이스토리" /></h2>
                </div>
                <div class="vod-area">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/tit_vod.jpg?v=1.01" alt="우리의 여행은 아직끝나지 않았다" /></h3>
                    <div class="vod-wrap shape-rtgl">
                        <div class="vod">
                            <iframe src="https://www.youtube.com/embed/yO7RbAq9uV4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                        </div>
                    </div>
                    <div class="clearFix">
                        <ul>
                            <li><a href="#evt1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/btn_evt1.jpg" alt="" /></a></li>
                            <li><a href="#eventitemlist"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/btn_goods.jpg" alt="" /></a></li>
                        </ul>
                    </div>
                </div>
                <div class="info">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_info.jpg" alt="movie info" /></span>
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/txt_info.jpg" alt="우리의 여행은 아직 끝나지 않았다" /></p>
                </div>
                <div class="frd">
                    <div class="inner posr">
                        <div class="slide1">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_frd_01.jpg" alt="" /></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_frd_02.jpg" alt="" /></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_frd_03.jpg" alt="" /></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_frd_04.jpg" alt="" /></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_frd_05.jpg" alt="" /></div>
                            </div>
                            <div class="pagination pos"></div>
                            <button class="btn-arrow prev">이전</button>
                            <button class="btn-arrow next">다음</button>
                        </div>
                    </div>
                </div>

                <% If (Now() > #06/19/2019 00:00:00# AND Now() < #06/26/2019 00:00:00#) Then %>
                    <div class="evt1" id="evt1">
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/tit_evt1_v1.jpg" alt="event"></div>
                        <div class="posr">
                            <a href="/category/category_itemPrd.asp?itemid=2332627&pEtr=94853" onclick="TnGotoProduct('2332627');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_evt1_v1.jpg" alt="트럼프카드"></a>
                            <span class="bounce"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/ico_plus.png" alt=""></span>
                        </div>
                        <div class="guide">
                            <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/txt_evt1.jpg?v=1.01" alt="이벤트 참여방법"></div>
                            <%' for msg : 품절시 레이어 (적용은 추후 요청) %>
                            <div class="soldout" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/txt_soldout.png" alt="품절"></div>
                        </div>
                        <div>
                            <a href="/event/eventmain.asp?eventid=89269" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/btn_tenship.jpg" alt="텐바이텐 배송상품 구경하기"></a>
                            <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89269');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/btn_tenship.jpg" alt="텐바이텐 배송상품 구경하기"></a>
                        </div>
                        <%' for dev msg : 19.06.19 00시부터 25일까지 숨김 (26일 이후에는 히스토리 확인 위해 오픈) %>
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_evt1_bot.jpg" alt=""></div>
                    </div>
                <% Else %>
                    <div class="evt1" id="evt1">
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/tit_evt1.jpg" alt="event1"></span>
                        <div class="posr">
                            <a href="/category/category_itemPrd.asp?itemid=2332627&pEtr=94853" onclick="TnGotoProduct('2332627');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_evt1.jpg?v=1.2" alt="트럼프카드"></a>
                            <span class="bounce"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/ico_plus.png" alt=""></span>
                        </div>
                        <div class="guide">
                            <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/txt_evt1.jpg?v=1.01" alt="이벤트 참여방법"></span>
                        </div>
                        <div>
                            <a href="/event/eventmain.asp?eventid=89269" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/btn_tenship.jpg" alt="텐바이텐 배송상품 구경하기"></a>
                            <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89269');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/btn_tenship.jpg" alt="텐바이텐 배송상품 구경하기"></a>
                        </div>
                    </div>
                    <div class="evt2">
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_evt2.jpg" alt="event2"></span>
                    </div>
                    <%' 코멘트 영역 %>
                    <div class="cmt-area">
                        <%' 쓰기 %>
                        <div class="cmt-write posr">
                            <div class="inner posr">
                                <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/img_slt.jpg" alt="" /></span>
                                <div class="pos">
                                    <div class="radio-area">
                                        <span>
                                            <input type="radio" name="toy-img" value="1" checked="checked" id="toy-01">
                                            <label for="toy-01">우디</label>
                                        </span>
                                        <span>
                                            <input type="radio" name="toy-img" value="2"  id="toy-02"> 
                                            <label for="toy-02">버즈</label>
                                        </span>
                                        <span>
                                            <input type="radio" name="toy-img" value="3"  id="toy-03"> 
                                            <label for="toy-03">보핍</label>
                                        </span>
                                        <span>
                                            <input type="radio" name="toy-img" value="4"  id="toy-04"> 
                                            <label for="toy-04">포키</label>
                                        </span>
                                        <span>
                                            <input type="radio" name="toy-img" value="5"  id="toy-05"> 
                                            <label for="toy-05">더키&버니</label>
                                        </span>
                                    </div>
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
                                        <%' for dev msg : 50자 이내  %> 
                                        <textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="fnChkByte(this);" maxlength="50" placeholder="띄어쓰기 포함 50자 이내 작성 " ></textarea>
                                        <!-- 글자수 보여주는 영역 --> <p class="now-txt"><span id="byteInfo">0</span> / 50자</p>
                                        <button type="button" onclick="jsSubmitComment(document.frmcom);">포토 카드 만들기</button>
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
                        <!-- 리스트 -->
                        <div class="cmt-list">
                            <% IF isArray(arrCList) THEN %>
                            <ul>
                                <% 
                                    dim tmpImgCode
                                    For intCLoop = 0 To UBound(arrCList,2) 

                                    tmpImgCode = Format00(2, arrCList(3,intCLoop))
                                %>                          
                                        <li class="toy-<%=tmpImgCode%>">
                                            <div class="desc">
                                                <p class="num">NO. <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                                                <p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
                                            </div>
                                            <div class="conts">
                                                <p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
                                            </div>
                                            <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                                                <a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="delete">X</a>
                                            <% End If %>
                                        </li>
                                <%
                                    next
                                %>
                            </ul>
                            <% End If %>
                        </div>
                        <% If isArray(arrCList) Then %>
                        <%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
                        <% End If %>
                    </div>
                <% End If %>
                <%' // 코멘트 영역 %>
                <div class="notice">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/94853/m/tit_notice.jpg" alt="유의사항"></h3>
                    <ul>
                        <li>- 당첨자와 수령자는 동일해야 하며, 양도는 불가합니다.</li>
                        <li>- 정확한 발표를 위해 마이텐바이텐의 개인정보를 업데이트해주세요.</li>
                        <li>- 이벤트 경품은 내부 사정에 의해 변경될 수 있습니다.</li>
                        <% If Now() > #06/19/2019 00:00:00# Then %>
                            <li>- 텐바이텐 배송 박스에 &lt;토이 스토리 4&gt; 친구들이!? 이벤트 당첨 발표 : 2019년 6월 26일 수요일 (텐바이텐 공지사항 및 인스타그램 DM)</li>
                            <li>- 나만의 최애 &lt;토이 스토리 4&gt; 캐릭터는? 이벤트 당첨 발표 : 2019년 6월 19일 수요일 (텐바이텐 공지사항 기재)</li>
                        <% Else %>
                            <li>- 당첨자 발표는 2019년 6월 19일 수요일 공지사항을 통해 진행됩니다.</li>
                        <% End If %>
                    </ul>
                </div>
            </div>
            <%'// 94853 토이스토리 %>
            <% if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="thensi7" Then %>
            <div>
                참여자수(유니크) : <%=formatnumber(uniqueUserCnt,0)%>명
            </div>
            <% End If %>            

<!-- #include virtual="/lib/db/dbclose.asp" -->