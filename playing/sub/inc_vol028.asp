<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description : PLAYing 장바구니 탐구생활_이별편
' History : 2017-11-23 이종화 생성
'#################################################################
%>
<%

dim oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vDIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66277
Else
	eCode   =  82164
End If

dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vDIdx = request("didx")

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

iCPerCnt = 6		'보여지는 페이지 간격
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
<style type="text/css">
.topic {position:relative;}
.topic p {position:absolute; left:0; width:100%; opacity:0; animation:move 1s forwards;}
.topic .label {top:10.8%;}
.topic .title1 {top:21.65%;  animation-delay:.3s;}
.topic .title2 {top:35%;  animation-delay:.5s;}
.comment-write {padding:0 4.6% 4.27rem; background-color:#333;}
.comment-write textarea {display:block; width:100%; height:19rem; padding:1.7rem; border:0; font-size:1.1rem; color:#252525;}
.comment-write .btn-share {display:block; width:100%;}
.comment-list {padding:3rem 0; background-color:#d9d9d9;}
.comment-list ul {padding:0 4.6%;}
.comment-list li {position:relative; margin-bottom:2.05rem; padding:1.3rem 0 2.56rem; background-color:#fff;}
.comment-list li .writer {padding:0 1.1rem 1.45rem; font-size:1rem; font-weight:600; color:#000;}
.comment-list li .writer .num {padding-right:0.7rem; color:#ff7f4d;}
.comment-list li .writer .date {padding-left:0.7rem;  color:#b2b2b2;}
.comment-list li .txt {padding:0 2.05rem; color:#333; font-size:1.2rem; line-height:1.3;}
.comment-list li .delete {position:absolute; right:0; top:0; z-index:10; width:10.5%;}
.comment-list .pagingV15a span,.comment-list .pagingV15a .current {font-weight:600; color:#000;}
.comment-list .pagingV15a .current a {background-color:#ff7f4d; border-radius:50%;}
.comment-list .pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
@keyframes move {
	from {transform:translateY(10px); opacity:0;}
	to {transform:translateY(0); opacity:1;}
}
</style>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('/playing/view.asp?didx=<%=vDIdx%>&iCC=' + iP);
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2017-11-23" and date() <= "2017-12-04" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("여러분의 이별 극복 아이템을 공유해주세요!");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 1000){
					alert("제한길이를 초과하였습니다. 500자 까지 작성 가능합니다.");
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
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
<div class="thingVol028 farewell">
	<div class="section topic">
		<p class="label"><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_label.png" alt="장바구니 탐구생활 _ 이별편" /></p>
		<p class="title1"><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/tit_farewell_1.png" alt="얼마 전 이별했다는 A씨 앞으로" /></p>
		<p class="title2"><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/tit_farewell_2.png" alt="계속해서 택배가 왔다." /></p>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/bg_topic.jpg" alt="" /></div>
	</div>

	<div class="section story">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_farewell.jpg" alt="계속 배송되는 A씨의 택배. 알고 보니 그녀의 쇼핑 전리품. 이별의 상처를 쇼핑으로 극복하는 걸까? A씨의  택배상자 속 물건들을 몰래 훔쳐보았다. 상자를 열어보니 이런 물건들이 있었다. 요가매트, 트레이닝복, 줄넘기.. 등등 운동으로 이별을 극복한다는 A씨의 이유를 듣고 모두 자신의 이별 극복 아이템을 꺼내놓았다." /></p>
		<ul>
			<li><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_story_1.jpg" alt="운동으로 이별을 극복한 A씨" /></li>
			<li><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_story_2.jpg" alt="문화생활로 이별을 극복한 N씨" /></li>
			<li><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_story_3.jpg" alt="청소, 정리로 이별을 극복한 B씨" /></li>
			<li><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_story_4.jpg" alt="일기로 이별을 극복하는 H씨" /></li>
		</ul>
	</div>
	<div class="section conclusion">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_conclusion.png" alt="Conclusion 힘들었던 이별을 극복한 사람들의 경험담, 이별한 지 얼마 되지 않아 마음 아파하고 있다면 이별 극복 아이템으로 마음을 추스러 보는 건 어떨까?" /></p>
		<a href="/event/eventmain.asp?eventid=82164" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/btn_more.jpg" alt="더 많은 이별 극복 아이템 보러 가기" /></a>
		<a href="" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=82164');" target="_blank" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/btn_more.jpg" alt="더 많은 이별 극복 아이템 보러 가기" /></a>
	</div>
	
	<div class="section comment">
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="iCC" value="1">
		<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="blnB" value="">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
		<input type="hidden" name="isApp" value="<%= isApp %>">	
		<input type="hidden" name="spoint"/>
		<div class="comment-write">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_comment.png" alt="여러분의 이별 극복 아이템을 공유해주세요! 극복 사례를 공유해주신 분들 중 추첨을 통해 10명에게 이별극복아이템(랜덤)을 드립니다." /></h3>
			<textarea cols="30" rows="5" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" placeholder="500자 이내로 입력(1인 5회)"></textarea>
			<button class="btn-share" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/btn_share.png" alt="공유하기" /></button>
		</div>
		</form>
		<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="isApp" value="<%= isApp %>">
		</form>
		<% If isArray(arrCList) Then %>
		<div class="comment-list">
			<ul>
				<%'!-- for dev msg : 코멘트 6개씩 노출 --%>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<p class="writer">
						<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
						<%=printUserId(arrCList(2,intCLoop),4,"*")%>님
						<span class="date"><%=formatdate(arrCList(4,intCLoop),"0000.00.00")%></span>
					</p>
					<div class="txt">
						<%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%>
					</div>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="delete"><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/btn_delete.png" alt="삭제" /></a>
					<% End If %>
				</li>
				<% Next %>
			</ul>
			<div class="pagingV15a">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
			</div>
		</div>
		<% End If %>
	</div>

	<div class="section epilogue">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol028/m/txt_epilogue.jpg?v=1" alt="텐바이텐 플레잉 계정[10x10playing]을 팔로우해주세요! 같이 이야기 하고 싶은 주제나 하고 싶은 이야기가 있다면 언제든 메시지 주세요. 우리 함께 소통해요!" /></p>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->