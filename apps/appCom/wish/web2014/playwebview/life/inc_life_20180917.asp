<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 장바구니탐구생활_에어팟편
' History : 2018-09-14 최종원
'####################################################
dim oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  68520
Else
	eCode   =  89358
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
.life-523 .topic {position:relative;}
.life-523 .topic h2 {position:absolute; left:0; top:11.5%; width:100%;}
.comment-head {position:relative;}
.comment-write {position:absolute; left:5%; bottom:14%; width:90%;}
.comment-write div {overflow:hidden; position:relative; width:100%; height:4.69rem; margin:0 auto; padding:0 9.5rem 0 1rem; background:#fff;}
.comment-write input {width:100%; height:4.69rem; font-size:1.62rem; font-weight:600; text-align:center; color:#666; border:0;}
.comment-write input::-webkit-input-placeholder {color:#d6d6d6;}
.comment-write input::-moz-placeholder {color:#d6d6d6;} /* firefox 19+ */
.comment-write input:-ms-input-placeholder {color:#d6d6d6;} /* ie */
.comment-write input:-moz-placeholder {color:#d6d6d6;}
.comment-write .btn-recommend {position:absolute; right:0; top:0; width:8.53rem; height:4.69rem; vertical-align:top;}
.comment-list {padding:3.4rem 0 2.47rem; background:#5979c8;}
.comment-list ul {padding:0 6.66%;}
.comment-list li {position:relative; margin-top:1.28rem;}
.comment-list li:first-child {margin-top:0;}
.comment-list li .cmt-area {overflow:hidden; height:4.18rem; padding:0 1.7rem; font-size:0.9rem; line-height:4.18rem; letter-spacing:-0.03rem; background:#d3d6f3;}
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
</style>
<script type="text/javascript">

$(function(){
	var position = $('.life-523').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	titleAnimation();
	$(".topic h2").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").delay(100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}	

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>	
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('<%=appUrlPath%>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=on&iCC=' + iP);
}

function jsSubmitComment(frm){	
	<% If IsUserLoginOK() Then %>	
		<% if date() >="2018-09-14" and date() <= "2018-10-01" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("다음 주제를 입력해주세요.");
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
			<div class="life-523">
				<div class="topic">
					<h2><img src="http://webimage.10x10.co.kr/fixevent/play/life/523/m/tit_airpod_1.png" alt="에어팟 도대체 그들은 왜?" /></h2>
					<p><img src="http://webimage.10x10.co.kr/fixevent/play/life/523/m/bg_topic.jpg" alt="" /></p>
				</div>
				<div class="section graph">
					<img src="http://webimage.10x10.co.kr/fixevent/play/life/523/m/img_graph.jpg" alt="그들의 장바구니에 가장 많이 담겨있던 물건은 뭘까?" />
				</div>
				<div class="section question">
					<img src="http://webimage.10x10.co.kr/fixevent/play/life/523/m/img_question.jpg" alt="왜 에어팟과 함께 이 상품들을 주문했을까??" />
				</div>
				<div class="section conclusion">
					<a href="/event/eventmain.asp?eventid=89358" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/play/life/523/m/img_conclusion.jpg" alt="에어팟 산 그들의 또 다른 선택 - 에어팟과 함께 사기 좋은 아이템" /></a>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89358" onclick="fnAPPpopupEvent('89358'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/play/life/523/m/img_conclusion.jpg" alt="에어팟 산 그들의 또 다른 선택 - 에어팟과 함께 사기 좋은 아이템" /></a>
				</div>
				<!-- comment -->
				<%'//코멘트%>
				<div class="comment">
					<div class="comment-head">
						<h3><img src="http://webimage.10x10.co.kr/fixevent/play/life/523/m/tit_comment.jpg" alt="여러분의 관심사는 무엇인가요?" /></h3>
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
								<button type="button" class="btn-recommend" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/fixevent/play/life/523/m/btn_recommend.gif" alt="추천" /></button>
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
								<div class="cmt-area"
									<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
									<p class="txt"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
									<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</p>
								</div>	
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<button type="button" class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/play/life/btn_cmt_delete.png" alt="코멘트 삭제" /></button>
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
				<!--// comment -->
			</div>
			<!--// 컨텐츠 영역 -->	
		</div>
	</div>
	<%'<!-- //contents -->%>