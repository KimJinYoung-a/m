<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 탐구생활 장바구니
' History : 2019-03-22 최종원
'####################################################
'gnb 구분자
dim gnbFlag
dim nowUrl, eventStartDate, eventEndDate

nowUrl = request.servervariables("HTTP_url")

eventStartDate = Cdate("2019-03-22")
eventEndDate = Cdate("2019-04-07")
dim oItem
dim currenttime
	currenttime =  now()

dim returnUrl

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  89172
Else
	eCode   =  93430 
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
	returnUrl = appUrlPath & "/play/detail.asp?pidx="& vPIdx &"&pagereload=ON"
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
.topic {position:relative;}
.topic span {display:block; position:absolute; bottom:0; left:0; width:100%;}
.topic .bag {-webkit-animation:bounce 2s 20; animation:bounce 1.8s 20;}
@-webkit-keyframes bounce {
	from, to {-webkit-transform:translateY(0); transform:translateY(0);}
	50% {-webkit-transform:translateY(-1.2rem); transform:translateY(-1.2rem); animation-timing-function:ease-in;}
}
@keyframes bounce {
	from, to {-webkit-transform:translateY(0); transform:translateY(0);}
	50% {-webkit-transform:translateY(-1.2rem); transform:translateY(-1.2rem); animation-timing-function:ease-in;}
}
.topic .shadow {-webkit-animation:scale 1.8s 20; animation:scale 1.8s 20;}
@-webkit-keyframes scale {
	from, to {-webkit-transform:scale(1); transform:scale(1);}
	50% {-webkit-transform:scale(0.8); transform:scale(0.8); animation-timing-function:ease-in;}
}
@keyframes scale {
	from, to {-webkit-transform:scale(1); transform:scale(1);}
	50% {-webkit-transform:scale(0.8); transform:scale(0.8); animation-timing-function:ease-in;}
}
.qna {position:relative;}
.qna span {display:block; position:absolute; bottom:0; left:0; width:100%; opacity:0; transform:translateY(1.5rem); transition:all 1s ease-in-out;}
.qna.fadeUp span {opacity:1; transform:translateY(0);}
.slider {position:relative;}
.slider .swiper-pagination {position:absolute; top:0; left:5%; width:90%; z-index:2; -webkit-tap-highlight-color:rgba(0, 0, 0, 0);}
.slider .swiper-pagination-switch {display:inline-block; float:left; width:20%; height:6rem;}
.cmt-area {background-color:#ff7da2;}
.input-box {width:27rem; margin:0 auto 4rem;}
.input-box .textarea-wrap {position:relative;}
.input-box .textarea-wrap textarea {position:absolute; overflow:hidden; top:0; left:0; width:100%; height:100%; padding:2rem 3rem; border:0; background-color:transparent; color:#000; font-size:1.61rem; line-height:2.64rem; font-weight:600; text-align:left;}
.input-box .textarea-wrap textarea:focus::-webkit-input-placeholder {opacity:0;}
.input-box .textarea-wrap textarea::-webkit-input-placeholder {color:#ccc;}
.input-box .textarea-wrap textarea::-moz-input-placeholder {color:#ccc;}
.input-box .textarea-wrap textarea:-moz-placeholder {color:#ccc;}
.input-box .textarea-wrap textarea:-ms-input-placeholder {color:#ccc;}
.cmt-area .cmt-list {background-color:#ff4f81;}
.cmt-area .cmt-list ul {padding:2.99rem 6.6% 0;}
.cmt-area .cmt-list ul li {position:relative; display:table; width:100%; margin-top:1.28rem; padding:1.9rem; background-color:#fff;}
.cmt-area .cmt-list ul .num {position:absolute; top:2rem; right:1.58rem; font-size:.75rem; font-weight:500; text-align:right; color:#333;}
.cmt-area .cmt-list ul .writer {display: block; padding-bottom: 1rem; color: #553832; font-size:.95rem; }
.cmt-area .cmt-list ul .writer em {color:#c75742;}
.cmt-area .cmt-list ul .conts {padding-top:1rem; font-size:1.37rem; line-height:1.7; font-weight:bold; word-wrap:break-word; word-break:break-all; text-align:left; border-top:1px solid #f0f0f8; color:#000;}
.cmt-area .cmt-list .btn-del {display:inline-block; position:absolute; top:-1.2rem; right:-1.2rem; width:3.2rem; height:3.2rem; background:url(//webimage.10x10.co.kr/fixevent/play/life/702/btn_close.png) 50% 50% no-repeat; background-size:1.7rem; text-indent:-999em;}
.cmt-area .pagingV15a {margin-top:0; padding:2.18rem 0 3.11rem; background-color:#ff4f81;}
.cmt-area .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#fff; font-size:1.28rem; line-height:2.9rem; font-weight:600;}
.cmt-area .pagingV15a a {padding-top:0;}
.cmt-area .pagingV15a .current {color:#f76347; background:#fff192; border-radius:50%;}
.cmt-area .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(//webimage.10x10.co.kr/fixevent/play/life/702/btn_next.png) 0 0 no-repeat; background-size:100%;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper(".slider .swiper-container",{
		loop:true,
		effect:'fade',
		pagination:".slider .swiper-pagination",
		paginationClickable:true
	});
	$(window).scroll(function(){
		var scrl = $(this).scrollTop() + $(window).height() / 2;
		var qna = $('.section1 .qna');
		qna.each(function(){
			if( scrl > $(this).offset().top ) {
				$(this).addClass('fadeUp');
			}
		});
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
		<% if date() >= eventStartDate and date() <= eventEndDate then %>
			<% if commentcount > 4 and userid <> "cjw0515" then %>
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

			<!-- PLAY 탐구생활 760 -->
			<div class="life-760">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/play/life/760/bg_topic.jpg" alt="장바구니 탐구생활"></h2>
					<span class="shadow"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/img_shadow.png" alt=""></span>
					<span class="bag"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/img_bag.png" alt=""></span>
				</div>
				<p><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_topic.jpg" alt=""></p>
				<section class="section1">
					<div class="qna">
						<p><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_q1.jpg" alt=""></p>
						<span><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_a1.png" alt=""></span>
					</div>
					<div class="qna">
						<p><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_q2.jpg" alt=""></p>
						<span><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_a2.png" alt=""></span>
					</div>
					<div class="qna">
						<p><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_q3.jpg" alt=""></p>
						<span><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_a3.png" alt=""></span>
					</div>
				</section>
				<section class="section2">
					<h3><img src="//webimage.10x10.co.kr/fixevent/play/life/760/tit_qna.jpg" alt="Q&amp;A 장바구니 이렇게 활용하세요."></h3>
					<div class="slider">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_slide_01.jpg" alt=""></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_slide_02.jpg" alt=""></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_slide_03.jpg" alt=""></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_slide_04.jpg" alt=""></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_slide_05.jpg" alt=""></div>
							</div>
							<div class="swiper-pagination"></div>
						</div>
					</div>
                <% if isApp = 1 then %>
                    <a href="javascript:void(0)" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93430');"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/bnr_evt.jpg" alt="장바구니 활용 TIP"></a>
                <% else %>
                    <a href="/event/eventmain.asp?eventid=93430" ><img src="//webimage.10x10.co.kr/fixevent/play/life/760/bnr_evt.jpg" alt="장바구니 활용 TIP"></a>
                <% end if %>					
				</section>

				<!-- 코멘트영역 -->
				<div class="cmt-area">
					<p><img src="//webimage.10x10.co.kr/fixevent/play/life/760/txt_cmt.jpg" alt=""></p>
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
                            <p><img src="//webimage.10x10.co.kr/fixevent/play/life/760/bg_textarea.png" alt=""></p>
                            <textarea name="txtcomm" id="txtcomm" placeholder="50자 이내로 입력" maxlength="50" onClick="jsCheckLimit();"></textarea>
                        </div>
                        <button class="submit" onclick="jsSubmitComment(document.frmcom);return false;"><img src="//webimage.10x10.co.kr/fixevent/play/life/760/btn_submit.png" alt="등록"></button>
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
                    <div class="cmt-list" id="comment">
					<% If isArray(arrCList) Then %>				                    
                        <ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
                            <li>
                                <p class="writer"><em><%=printUserId(arrCList(2,intCLoop),2,"*")%></em>님의 장바구니 활용법</p>
                                <p class="num">No. <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                                <p class="conts"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
                                
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                                <button class="btn-del" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button>
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
