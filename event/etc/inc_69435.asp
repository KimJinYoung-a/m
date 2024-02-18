<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 기프트
' History : 2016-03-04 유태욱 생성
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
dim oItem, pagereload, classboxcol, cmtYN
dim currenttime
	currenttime =  now()
'															currenttime = #03/07/2016 09:00:00#
	cmtYN = "Y"
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66055
Else
	eCode   =  69435
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
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.hidden {visibility:hidden; width:0; height:0;}

.mEvt69435 {background-color:#fff;}

.rolling {}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.swiper .pagination {position:absolute; bottom:5.5%; left:0; width:100%; height:auto; z-index:100; padding-top:0; text-align:center;}
.swiper .pagination .swiper-pagination-switch {display:inline-block; width:8px; height:8px; margin:0 4px; border-radius:50%; background-color:#fde9be; cursor:pointer; transition:background-color 1s ease;}
.swiper .pagination .swiper-active-switch {background-color:#d50c0c;}

@media all and (min-width:480px){
	.swiper .pagination .swiper-pagination-switch {width:12px; height:12px; margin:0 6px;}
	.swiper button {width:16px;}
}

/* comment */
.commentevt {padding-bottom:12%;}
.form legend {visibility:hidden; width:0; height:0;}
.form .inner {padding:0 6.25%;}
.form .field {position:relative; padding-right:5.5rem;}
.form .field textarea {width:100%; height:5.5rem; border:0; border-radius:0; background-color:#f4f4f4; color:#333; font-size:1.2rem;}
.form .field input {position:absolute; top:0; right:0; width:5.5rem; height:5.5rem; background-color:#333; color:#fff; font-size:1rem;}

.commentlist .total {margin-top:5%; padding:0 6.25%; color:#999; font-size:1.1rem; text-align:right;}
.commentlist ul {margin:1rem 6.25% 0; border-top:1px solid #ddd;}
.commentlist ul li {position:relative; min-height:5.8rem; padding:1.5rem 0 1.5rem 7.8rem; border-bottom:1px solid #ddd; color:#777; font-size:1.1rem; line-height:1.375em;}
.commentlist ul li .ico {position:absolute; top:50%; left:1%; width:5.7rem; height:5.7rem; margin-top:-2.8rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69435/m/bg_img_card_01.png) no-repeat 0 0;background-size:100% 100%; text-indent:-999em;}
.commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69435/m/bg_img_card_02.png);}
.commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69435/m/bg_img_card_03.png);}
.commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69435/m/bg_img_card_04.png);}
.commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69435/m/bg_img_card_05.png);}
.commentlist ul li .ico6 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69435/m/bg_img_card_06.png);}
.commentlist ul li .ico7 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69435/m/bg_img_card_07.png);}
.commentlist ul li .date {margin-top:0.7rem;}
.commentlist ul li .button {margin-top:0.5rem;}
.commentlist ul li .mob img {width:0.9rem;}
.commentlist .btnmore {margin-top:2%;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:2500,
		speed:500,
		autoplayDisableOnInteraction:false,
		pagination:'.pagination',
		effect:'fade'
	});

	/* comment list icon random */
	var random = [ 'ico1', 'ico2', 'ico3', 'ico4', 'ico5', 'ico6', 'ico7'];
	var sort = random.sort(function(){
		return Math.random() - Math.random();
	});

	$('.commentlist ul li .ico').each( function(index,item){
		$(this).addClass(sort[index]);
	});
});

$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",300);
	<% else %>
		setTimeout("pagup()",300);
	<% end if %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt69435").offset().top}, 0);
}

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if commentcount>0 then %>
			alert("한 ID당 한번만 참여할 수 있습니다.");
			return false;
		<% else %>
			if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 600 || frm.txtcomm.value == '300자 이내로 적어주세요.'){
				alert("띄어쓰기 포함\n최대 한글 300자 이내로 적어주세요.");
				frm.txtcomm.focus();
				return false;
			}

			frm.action = "/event/lib/doEventComment.asp";
			frm.submit();
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
	if (frmcom.txtcomm.value == '300자 이내로 적어주세요.'){
		frmcom.txtcomm.value = '';
	}

}
</script>
	<div class="mEvt69435">
		<article>
			<h2 class="hidden">Renewal 기프트카드</h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/txt_giftcard.png" alt="더 쉬워진 기프트 카드로 마음을 담아 선물하세요! 카드 결선택부터 결제까지 한 번에, 내가 직업 만드는 기프트 카드, 언제 어디서나 쓸 수 있다" /></p>
			<div class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/img_slide_01_v1.jpg" alt="스텝 1 기프트 카드 메뉴 클릭" /></p>
							</div>
							<div class="swiper-slide">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/img_slide_02_v2.jpg" alt="스텝 2 카드이미지 또는 사진 등록" /></p>
							</div>
							<div class="swiper-slide">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/img_slide_03_v1.jpg" alt="스텝 3 메시지 입력" /></p>
							</div>
							<div class="swiper-slide">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/img_slide_04_v1.jpg" alt="스텝 4 금액 선택 후 연락처 입력" /></p>
							</div>
							<div class="swiper-slide">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/img_slide_05_v1.jpg" alt="스텝 5 결제하고 선물하기" /></p>
							</div>
						</div>
					</div>
					<div class="pagination"></div>
				</div>
			</div>

			<div class="btnget"><a href="https://m.10x10.co.kr/giftcard/" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT,[],'기프트카드',[BtnType.SHARE],'<%=wwwUrl%>/apps/appCom/wish/web2014/giftcard/','giftcard');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/btn_get_v1.png" alt="기프트카드 구매하러 가기" /></a></div>

			<div class="presentUse">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/txt_use_v1.png" alt="기프트 카드 선물을 받으셨다면 이렇게 사용하세요! 기프트 카드 메시지가 수신되며 로그인 후 카드 등록 후 온라인 결제 시 사용 하실 수 있으며, 오프라인에서는 인증번호 제시 후 사용하실 수 있습니다." /></p>
			</div>

			<!-- comment -->
			<div class="commentevt">
				<!-- form -->
				<div class="form">
					<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
					<input type="hidden" name="mode" value="add">
					<input type="hidden" name="pagereload" value="ON">
					<input type="hidden" name="iCC" value="1">
					<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
					<input type="hidden" name="eventid" value="<%= eCode %>">
					<input type="hidden" name="linkevt" value="<%= eCode %>">
					<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
					<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
					<input type="hidden" name="gubunval">
					<input type="hidden" name="isApp" value="<%= isApp %>">	
						<fieldset>
						<legend>어떤 분께 기프트 카드를 선물하고 싶은지 코멘트 쓰기</legend>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69435/m/txt_comment.png" alt="이 카드로 선물하고 싶어요! 기프트카드로 어떤 분에게 선물하고 싶은지에 대해 정성껏 코멘트를 남겨주신 4분을 선정하여, 텐바이텐 기프트카드 50,000원 권을 선물로 드립니다. 기간은 2016년 3월 7일부터 3월 13일 까지며, 당첨자 발표는 2016년 3월 15일 화요일입니다." /></p>
							<div class="inner">
								<div class="field">
									<textarea cols="60" rows="5" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>300자 이내로 적어주세요.<%END IF%></textarea>
									<input type="submit" onclick="jsSubmitComment(document.frmcom); return false;" value="응모하기" class="btnsubmit" />
								</div>
							</div>
						</fieldset>
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

				<% if cmtYN = "Y" then %>
					<% IF isArray(arrCList) THEN %>
						<div class="commentlist" id="commentevt">
							<p class="total">total <%= iCTotCnt %></p>
							<ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
								<li>
									<span class="ico"></span>
									<div class="letter">
										<p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
											<span class="button btS1 btWht cBk1"><button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" >삭제</button></span>
										<% end if %>
									</div>
									<div class="date">
										<span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span> 
										<% if arrCList(8,intCLoop) <> "W" then %>
											<span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span>
										<% end if %>
									</div>
								</li>
							<% next %>
							</ul>
							<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
						</div>
					<% end if %>
				<% end if %>
			</div>
		</article>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->