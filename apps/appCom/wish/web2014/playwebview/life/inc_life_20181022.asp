<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 착하게 소비하는법
' History : 2018-10-19 최종원
'####################################################


dim oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  68520
Else
	eCode   =  90015
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
.comment-head {position:relative;}
.comment-write {position:absolute; left:5%; bottom:11.3%; width:90%;}
.comment-write div {overflow:hidden; position:relative; width:100%; height:4.69rem; margin:0 auto; padding:0 9.5rem 0 1.7rem; }
.comment-write input {width:100%; height:4.69rem; line-height:4.69rem; font-size:1.62rem; font-weight:600; text-align:center; color:#666; border:0; background-color: transparent;}
.comment-write input::-webkit-input-placeholder {color:#d6d6d6;}
.comment-write input::-moz-placeholder {color:#d6d6d6;} /* firefox 19+ */
.comment-write input:-ms-input-placeholder {color:#d6d6d6;} /* ie */
.comment-write input:-moz-placeholder {color:#d6d6d6;}
.comment-write .btn-recommend {position:absolute; right:0; top:0; width:8.9rem; height:4.69rem; vertical-align:top; background: none; text-indent: -9999px}
.comment-list {padding:3.4rem 0 2.47rem; background:#159f4f;}
.comment-list ul {padding:0 6.66%;}
.comment-list li {position:relative; margin-top:1.28rem;}
.comment-list li:first-child {margin-top:0;}
.comment-list li .cmt-area {overflow:hidden; height:4.18rem; padding:0 1.7rem; font-size:0.9rem; line-height:4.18rem; letter-spacing:-0.03rem; background:#fff;}
.comment-list li .btn-delete {position:absolute; right:-3.5rem; top:-3.5rem; width:7.66rem; padding:3rem;}
.comment-list li p {display:inline-block; float:left; height:100%;}
.comment-list li .num {width:4.2rem; color:#333;}
.comment-list li .txt {font-size:1.45rem; font-weight:600; color:#000;}
.comment-list li .writer {position:absolute; top:0; right:1.7rem; color:#2a4b9f;}
.comment-list .pagingV15a {margin-top:2.65rem;}
.comment-list .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#333; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.comment-list .pagingV15a a {padding-top:0;}
.comment-list .pagingV15a .current {color:#ffef85; background:#333; border-radius:50%;}
.comment-list .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(http://webimage.10x10.co.kr/play/life/btn_paging_next.png) 0 0 no-repeat; background-size:100% 100%;}

.life-577 {min-width: 330px}
.life-577 .topic {position:relative; background-color: #fff474;}
.life-577 .topic h2 {position:absolute; left:0; top:8.05%; width:100%; text-align:center;}
.life-577 .topic h2 img{width:70%;}
.life-577 .topic p{position: absolute; bottom: 0; width: 40%; left: 29.5%;}
.life-577 .checklist {background-color: #fff474;}
.life-577 .checklist ul{position: absolute; top: 56.39%; height: 30.8%; width: 100%;}
.life-577 .checklist li{height:20%;}
.life-577 .checklist li a{display:block; text-indent:-9999px; background:url('http://webimage.10x10.co.kr/fixevent/play/life/577/m/ico_check.png') 12% 72% /7.5% auto no-repeat; height:100%; }
.life-577 .checklist li.on a{background-position-y: -18%; }
.life-577 .section{position: relative;}
.life-577 .conclusion a {position:absolute; text-indent:-9999px; display:block; width:100%;}
.life-577 .conclusion.lashose {background-color: #83deff;}
.life-577 .conclusion.lashose .alink577{top:51.55%; height:14.1%;}
.life-577 .conclusion.lashose a.blink577 {bottom:5.1%; height:5.63%;}
.life-577 .conclusion.briosin {background-color: #ffb574;}
.life-577 .conclusion.briosin .alink577{top:29.65%; height:24.65%;}
.life-577 .conclusion.briosin a.blink577 {bottom:5.96%; height:6.57%;}
.life-577 .conclusion.lagom .alink577{top:26.76%; height:24.7%;}
.life-577 .conclusion.lagom a.blink577 {bottom:5.97%; height:6.58%;}
.life-577 a.clink{display: block; background-color: #6fcaeb;}
.life-577 .comment{background-color: #ff7651;}
.life-577 input:focus::-webkit-input-placeholder,textarea:focus::-webkit-input-placeholder {opacity: 0;}

</style>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>	
	var position = $('.life-577').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	titleAnimation();
	$(".topic h2").css({"margin-top":"-200px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").delay(100).animate({"margin-top":"5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}

	$('.checklist li').click(function(e){
		$(this).toggleClass('on')
		e.preventDefault();
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
		<% if date() >="2018-10-19" and date() <= "2018-11-05" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("여러분의 요즘 관심사를 입력해주세요.");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 20){
					alert("제한길이를 초과하였습니다. 10자 까지 작성 가능합니다.");
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
<body class="default-font body-sub playV18 detail-play">
	<%'<!-- contents -->%>
	<div id="content" class="content">
		<div class="detail-cont">
			<!-- 컨텐츠 영역 -->
            <div class="life-577">
                <div class="topic">
                    <span class="bg_img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/bg_evt577.png" alt="" /></span>
                    <h2><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/tit_evt577.png" alt="착하게 소비하는 방법" /></h2>
                    <p><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/img_evt577.gif" alt="" /></p>
                </div>
                <div class="section checklist">
                    <p class="bg_img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/img_checklist.png" alt="매일 소비하는 생활 속에서 여러분은 어떻게 소비하고 있나요?" /></p>
                    <ul>
                        <li><a href="#">카페 갈 땐 일회용 컵 대신 머그컵/텀블러로!</a></li>
                        <li><a href="#">비닐 봉투 대신 에코백으로!</a></li>
                        <li><a href="#">손 씻고 티슈대신 손수건으로!</a></li>
                        <li><a href="#">동물 실험을 하지 않은 상품으로!</a></li>
                        <li><a href="#">천연성분이 든 세제와 샴푸로!</a></li>
                    </ul>
                </div>
                <div class="section conclusion lashose">
                    <p class="bg_img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/img_solution_01.png" alt="불필요하게 버려진 것을 재생해서 사용해요." /></p>
                    <a href="/event/eventmain.asp?eventid=89059" class="mWeb alink577">라슈즈</a>
                    <a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89059" onclick="fnAPPpopupEvent('89059'); return false;" class="mApp alink577">라슈즈</a>
                    <a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90015#group261913');return false;" class="mApp blink577">리사이클/재활용 상품 더 보러 가기</a>
                    <a href="#group261913" class="mWeb blink577">리사이클/재활용 상품 더 보러 가기</a>
                </div>
                <div class="section conclusion briosin">
                    <p class="bg_img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/img_solution_02.png" alt="환경 오염을 시키지 않아요." /></p>
                    <a href="/category/category_itemprd.asp?itemid=1378730&pEtr=90015" class="mWeb alink577">브리오신</a>
                    <a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1378730&pEtr=90015"  onclick="fnAPPpopupProduct('1378730&pEtr=90015');" class="mApp alink577">브리오신</a>
                    <a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90015#group261914');return false;" class="mApp blink577">환경 오염시키지 않는 상품 더 보러 가기</a>
                    <a href="#group261914" class="mWeb blink577">환경 오염시키지 않는 상품 더 보러 가기</a>
                </div>
                <div class="section conclusion lagom">
                    <p class="bg_img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/img_solution_03.png" alt="동물 실험을 하지 않아요." /></p>
                    <a href="/category/category_itemprd.asp?itemid=1407169&pEtr=90015" class="mWeb alink577">라곰</a>
                    <a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1407169&pEtr=90015"  onclick="fnAPPpopupProduct('1407169&pEtr=90015');" class="mApp alink577">라곰</a>
                    <a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90015#group261915');return false;" class="mApp blink577">동물 실험을 하지 않는 상품 더 보러 가기</a>
                    <a href="#group261915" class="mWeb blink577">동물 실험을 하지 않는 상품 더 보러 가기</a>
                </div>
                <a href="/event/eventmain.asp?eventid=90015" class="mWeb clink"><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/btn_goitem.png" alt="착한 소비 아이템 보러가기" /></a>
                <a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90015" onclick="fnAPPpopupEvent('90015'); return false;" class="mApp  clink"><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/btn_goitem.png" alt="착한 소비 아이템 보러가기" /></a>
				<%'//코멘트%>
				<div class="comment">
					<div class="comment-head">
						<h3><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/img_comment.png" alt="여러분의 관심사는 무엇인가요?" /></h3>
						<%'<!-- 코멘트 작성 -->%>
						<div class="comment-write">
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
							<div>
								<input type="text" id="txtcomm" name="txtcomm" maxlength="10" onClick="jsCheckLimit();" placeholder="10자 이내로 입력" />
								<button type="button" class="btn-recommend" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_recommend.png" alt="추천" /></button>
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
						</div>
					</div>
					<%'<!-- 코멘트 목록(6개씩 노출) -->%>
					<div class="comment-list" id="comment">
						<% If isArray(arrCList) Then %>
						<ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<div class="cmt-area">
									<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
									<p class="txt"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
									<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</p>
								</div>	
									<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
									<button type="button" class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/btn_delete.png" alt="코멘트 삭제" /></button>
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
				<%'//코멘트%>
			</div>
			<!--// 컨텐츠 영역 -->			
		</div>
	</div>
	<%'<!-- //contents -->%>