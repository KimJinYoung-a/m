<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 크리스마스 이벤트 참여2탄(코멘트)
' History : 2015-12-04 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim oItem, pagereload
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  65969
Else
	eCode   =  67489
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, ecc
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),10)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
img {vertical-align:top;}
.mEvt67489 {background:#fff;}
.write {position:relative; overflow:hidden; width:90%; margin:0 auto 20px;}
.write textarea {position:absolute; left:0; top:0; width:69%; height:100%; padding:10px; color:#909090; font-weight:bold; border:3px solid #eee1d3; background:#f5ece1; border-radius:0;}
.write .btnWrite {float:right; width:30.5%;}
.planList {padding:24px 5% 40px; font-size:11px; background:#ddd6ca url(http://webimage.10x10.co.kr/eventIMG/2015/67489/m/bg_gradation.png) 0 0 no-repeat; background-size:100% auto;}
.planList li {margin-bottom:15px; box-shadow:0 2px 4px 1px rgba(185,179,169,.7);}
.planList li .myPlan {padding:20px 6.2% 40px; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/67489/m/bg_mountain.png) 0 100% no-repeat; background-size:100% auto;}
.planList li .txtInfo {height:18px; border-bottom:1.5px solid #e9e2dd;}
.planList li .txtInfo:after {content:" "; display:block; clear:both;}
.planList li .writer {float:left; color:#b58d5b; font-weight:bold;}
.planList li .writer .mob {width:7px; vertical-align:middle; margin:-3px 0 0 2px;}
.planList li .writer .btnDel {display:inline-block; width:45px; vertical-align:middle; margin-top:-5px;}
.planList li .num {float:right; color:#888;}
.planList li .story {min-height:45px; padding-top:6px; line-height:1.3;}
.planList .paging span {border:1px solid #c3b9a8;}
.planList .paging span.arrow {background-color:#c3b9a8; border:1px solid #c3b9a8;}
.planList .paging span a {color:#948365;}
@media all and (min-width:480px){
	.write {margin-bottom:20px;}
	.write textarea {padding:10px;}
	.planList {padding:36px 5% 60px; font-size:17px;}
	.planList li {margin-bottom:23px;}
	.planList li .myPlan {padding:30px 6.2% 60px;}
	.planList li .txtInfo {height:27px; border-bottom:2px solid #e9e2dd;}
	.planList li .writer .mob {width:11px; margin:-4px 0 0 3px;}
	.planList li .writer .btnDel {width:68px; margin-top:-7px;}
	.planList li .story {min-height:68px; padding-top:9px;}
}
</style>
<script type="text/javascript">

$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",300);
	<% else %>
		setTimeout("pagup()",300);
	<% end if %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt67489").offset().top}, 0);
}

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

$(function(){
	$('.planList li.plan01 .pic').append('<img src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/bg_cmt_01.jpg" alt="" />');
	$('.planList li.plan02 .pic').append('<img src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/bg_cmt_02.jpg" alt="" />');
	$('.planList li.plan03 .pic').append('<img src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/bg_cmt_03.jpg" alt="" />');
	$('.planList li.plan04 .pic').append('<img src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/bg_cmt_04.jpg" alt="" />');
	$('.planList li.plan05 .pic').append('<img src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/bg_cmt_05.jpg" alt="" />');
});

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-12-07" and left(currenttime,10)<"2015-12-14" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>
				alert("이미 작성하셨습니다.");
				return false;
			<% else %>
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400){
					alert("코멘트를 남겨주세요.\n최대 한글 200자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}
				frm.txtcomm.value = frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}
}
</script>
<%''-- 2015 크리스마스 ENJOY TOGETHER(참여2) %>
<div class="mEvt67489">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/tit_christmas_with_tenten.jpg" alt="텐바이텐과 함께 하는 2015크리스마스" /></h2>
	<%''-- 코멘트 쓰기 %>
	<div class="write">
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
	<input type="hidden" name="gubunval">
	<input type="hidden" name="isApp" value="<%= isApp %>">	
		<textarea cols="20" rows="5" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
		<input type="image" onclick="jsSubmitComment(document.frmcom); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/btn_plan.png" alt="내가 꿈꾸는 파티 남기기" class="btnWrite" />
	</form>
	<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="isApp" value="<%= isApp %>">
	</form>
	</div>
	<%''--// 코멘트 쓰기 %>

	<%'' 코멘트 리스트 %>
	<% IF isArray(arrCList) THEN %>
		<div class="planList" id="commentevt">
			<ul>
			<% 
			Dim renloop
			For intCLoop = 0 To UBound(arrCList,2)
			randomize
			renloop=int(Rnd*5)+1
			%>
				<%''// 랜덤으로 클래스 plan01~05 붙여주세요/6개씩 노출 %>
				<li class="plan0<%= renloop %>">
					<div class="pic"></div>
					<div class="myPlan">
						<div class="txtInfo">
							<p class="writer">
								from.<%=printUserId(arrCList(2,intCLoop),2,"*")%>
								<% If arrCList(8,i) <> "W" Then %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/ico_m.png" alt="모바일에서 작성" class="mob" />
								<% end if %>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
									<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="btnDel"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67489/m/btn_del.png" alt="삭제" /></a>
								<% end if %>
							</p>
							<p class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></p>
						</div>
						<p class="story"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
					</div>
				</li>
			<% next %>
			</ul>
			<div class="paging">
				<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
			</div>
		</div>
	<% end if %>
		<%''// 코멘트 리스트 %>
</div>
<%''--// 2015 크리스마스 ENJOY TOGETHER(참여2) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->