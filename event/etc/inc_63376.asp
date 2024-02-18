<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  신나는 예술, 즐거운 기부! [ Mr. Gibro ] 
' History : 2015.06.09 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<%
dim nowdate, eCodelink
dim eCode, ename, userid, sub_idx, i, intCLoop, leaficonimg
	userid = getloginuserid()
dim iCPerCnt, iCPageSize, iCCurrpage
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호

	nowdate = date()
'	nowdate = "2015-06-10"		'''''''''''''''''''''''''''''''''''''''''''''''''''''
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   	= 63782
		eCodelink	= 63784		''링크
	Else
		eCode		= 63376
		eCodelink	= 63378		''링크
	End If

	IF iCCurrpage = "" THEN iCCurrpage = 1
	iCPageSize = 7		' 한페이지에 보여지는 댓글 수
	iCPerCnt = 4		'한페이지에 보여지는 페이징번호 1~10
	
	dim ccomment, cEvent
	set ccomment = new Cevent_etc_common_list
		ccomment.FPageSize        = iCPageSize
		ccomment.FCurrpage        = iCCurrpage
		ccomment.FScrollCount     = iCPerCnt
		ccomment.event_subscript_one
		ccomment.frectordertype="new"
		ccomment.frectevt_code    = eCode
		ccomment.event_subscript_paging
	
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode
		cEvent.fnGetEvent
		
		eCode		= cEvent.FECode	
		ename		= cEvent.FEName
	set cEvent = nothing

%>
<style type="text/css">
img {vertical-align:top;}

.rolling {padding:0 3.9% 9%; background:#fed61f url(http://webimage.10x10.co.kr/eventIMG/2015/63378/bg_pattern_yellow.png) no-repeat 50% 0; background-size:100% auto;}
.swiper {overflow:visible; position:relative;}
.swiper .swiper-container {width:100%;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper .pagination {position:absolute; bottom:-32px; left:0; width:100%; padding-top:0; text-align:center;}
.swiper .pagination .swiper-pagination-switch {width:7px; height:7px; margin:0 3px; background-color:#fff; cursor:pointer;}
.swiper .pagination .swiper-active-switch {background-color:#ff7814;}
.swiper button {position:absolute; bottom:-30px; z-index:150; width:11px; background:transparent;}
.swiper .prev {left:32%;}
.swiper .next {right:32%;}

.btnget {width:80%; margin:13% auto 0;}

.field {padding:0 10% 10%; background:#eaf4f7 url(http://webimage.10x10.co.kr/eventIMG/2015/63378/bg_pattern_grey.png) no-repeat 50% 0; background-size:100% auto;}
.field .inner {position:relative; padding-right:79px;}
.field legend {visibility:hidden; width:0; height:0;}
.field textarea {width:100%; height:81px; padding:10px; border:3px solid #ff7814; border-radius:0; color:#999; font-size:12px;}
.field .btnsubmit {position:absolute; top:0; right:0; width:79px;}
.field .btnsubmit input {width:100%;}

.count {padding-top:10%; text-align:center;}
.count .inner {position:relative; width:300px; margin:0 auto;}
.count strong {position:absolute; top:0; left:105px; width:65px; height:20px; color:#ff7814; font-size:15px; font-weight:normal; line-height:23px; text-align:center;}

.commentlist {border-top:2px solid #ffdb14; margin:10px 20px 0;}
.commentlist .col {padding:15px 0; border-bottom:2px solid #d0d0d0;}
.commentlist .col:first-child {margin-top:2px; border-top:2px solid #ffdb14;}
.commentlist .col .no {display:block; position:relative; height:33px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/63378/bg_no.png) no-repeat 0 0; background-size:102px auto; color:#ff9b24; font-size:11px; font-weight:normal;}
.commentlist .col .no span {position:absolute; top:9px; left:44px; width:56px; height:14px; line-height:18px; text-align:center;}
.commentlist .col .no .btndel {position:absolute; top:8px; left:105px; width:18px; height:18px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/63378/btn_del.png) no-repeat 0 0; background-size:100% auto; text-indent:-999em;}
.commentlist .col .msg {margin-top:6px; color:#333; font-size:12px; line-height:1.375em;}
.commentlist .col .date {position:relative; margin-top:10px; padding-right:13px; color:#999; font-size:11px; text-align:right;}
.commentlist .col .date img {position:absolute; bottom:0; right:0; width:9px;}

@media all and (min-width:600px){
	.swiper .pagination {bottom:-40px;}
	.swiper .pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 5px;}
	.swiper button {bottom:-35px; width:14px;}

	.field .inner {padding-right:118px;}
	.field textarea {height:121px; padding:15px; font-size:14px;}
	.field .btnsubmit {width:118px;}

	.count .inner {width:450px;}
	.count strong {left:153px; width:97px; height:30px; font-size:20px; line-height:30px;}

	.commentlist {margin:15px 30px 0;}
	.commentlist .col {padding:25px 0;}
	.commentlist .col .no {height:50px; background-size:153px auto; font-size:14px;}
	.commentlist .col .no span {top:15px; left:64px; width:84px; height:21px; line-height:20px;}
	.commentlist .col .msg {margin-top:10px; font-size:16px;}
	.commentlist .col .date {margin-top:15px; padding-right:17px; font-size:14px;}
	.commentlist .col .date img {width:11px;}
	.commentlist .col .no .btndel {position:absolute; top:13px; left:155px; width:22px; height:22px;}
</style>
<script type="text/javascript">
<% if Request("iCC") <> "" then %>
	$(function(){
		setTimeout("pagedown()",500);
	});
<% end if %>

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#commentdiv").offset().top}, 0);
}

function jsSubmitComment(frm){      //코멘트 입력
	<% If IsUserLoginOK() Then %>
		<% If Now() > #09/30/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If nowdate>="2015-06-16" and nowdate<"2015-10-01" Then %>
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 200 || frm.txtcomm.value == '100글자 이내로 남겨주세요.'){
					alert("코멘트가 없거나 제한길이를 초과하였습니다.(100자 이하로 써주세요)");
					frm.txtcomm.focus();
					return;
				}

		   		frm.mode.value="addcomment";
				frm.action="/event/etc/doeventsubscript/doEventSubscript63376.asp";
				frm.target="evtFrmProc";
				frm.submit();
				return;
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
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

function jsDelComment(sub_idx)	{
	if(confirm("삭제하시겠습니까?")){
		frmcomm.sub_idx.value = sub_idx;
		frmcomm.mode.value="delcomment";
		frmcomm.action="/event/etc/doeventsubscript/doEventSubscript63376.asp";
		frmcomm.target="evtFrmProc";
   		frmcomm.submit();
	}
}

function jsGoComPage(iP){
	document.frmcomm.iCC.value = iP;
	document.frmcomm.submit();
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
	}
	
	if (frmcomm.txtcomm.value == '100글자 이내로 남겨주세요.'){
		frmcomm.txtcomm.value='';
	}
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}
</script>

	<!-- 신나는 예술, 즐거운 기부! Mr. Gibro -->
	<div class="mEvt63378">
		<div class="topic">
			<p class="collabo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/txt_collabo.png" alt="텐바이텐과 서울문화재단 신나는 예술, 즐거운 기부! Mr. Gibro" /></p>
		</div>

		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/img_slide_01.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/img_slide_02.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/img_slide_03.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/img_slide_04.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/img_slide_05.png" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/btn_prev.png" alt="이전" /></button>
				<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/btn_next.png" alt="다음" /></button>
			</div>

			<!-- for dev msg : 링크 -->
			<div class="btnget"><a href="" onclick="jsViewItem('1301039'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/btn_get.png" alt="미스터 기부로 구매하러 가기" /></a></div>
		</div>

		<div class="howto">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/tit_howto.png" alt="미스터 기부로는 이렇게 사용하세요!" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/txt_howto.png" alt="텐바이텐에서 미스터 기부로 구입한 후 저금통 표면에 그림을 그려 나만의 기부로를 만들고 미스터 기부로를 알뜰살뜰 동전으로 가둑 채운 후 가득찬 저금통을 보내고 새로운 기부로를 받으세요" /></p>
		</div>

		<div class="good">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/txt_good.png" alt="미스터 기부로는 이런 점이 좋아요! 저금통을 다 채워서 서울문화재단으로 보내주시면 새로운 기브로를 받을 수 있어요. 저금통의 금액은 소외계층의 문화활동 지원을 위한 기부금으로 사용하게 되죠. 서울시청 등지에서 예쁘게 꾸며진 기부로가 전시되어 누군가에게 즐거움을 줄거에요." /></p>
		</div>

		<!-- for dev msg : comment -->
		<div class="commentevt">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/txt_comment.png" alt="미스터 기부로에게 메시지를 남기고 기부하세요! 작성해주신 응원의 메시지는 1개당 100원씩 서울문화재단에 기부됩니다." /></p>
			<div class="field">
				<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
				<input type="hidden" name="mode">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="sub_idx">
					<fieldset>
					<legend>미스터 기부로에게 메시지를 남기기</legend>
						<div class="inner">
							<textarea cols="60" rows="3" title="응원 메시지 입력" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %>><% IF NOT IsUserLoginOK THEN %>로그인 후 글을 남길 수 있습니다.<% else %>100글자 이내로 남겨주세요.<% END IF %></textarea>
							<div class="btnsubmit"><input type="image" onclick="jsSubmitComment(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/63378/btn_submit.png" alt="등록하기" /></div>
						</div>
					</fieldset>
				</form>
			</div>
		</div>

		<!-- for dev msg : count -->
		<div class="count" id="commentdiv">
			<div class="inner">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/63378/txt_count.png" alt="현재 총 메시지" />
				<strong><%= ccomment.ftotalcount %></strong>
			</div>
		</div>

		<% IF ccomment.ftotalcount>0 THEN %>
			<!-- comment list -->
			<div class="commentlist">
				<!-- for dev msg : 한페이지당 7개 -->
				<% for i = 0 to ccomment.fresultcount - 1 %>
					<div class="col">
						<div class="no">
							<span>no.<%=ccomment.FTotalCount-i-(ccomment.FPageSize*(ccomment.FCurrPage-1))%></span> 
							<% if ((userid = ccomment.FItemList(i).fuserid) or (userid = "10x10")) and ( ccomment.FItemList(i).fuserid<>"") then %>
								<button type="butotn" class="btndel" onclick="jsDelComment('<%= ccomment.FItemList(i).fsub_idx %>'); return false;">삭제</button>
							<% end if %>
						</div>
						<p class="msg"><%= ReplaceBracket(ccomment.FItemList(i).fsub_opt3) %></p>
						<div class="date"><%=FormatDate(ccomment.FItemList(i).fregdate,"0000-00-00")%> / <%= printUserId(ccomment.FItemList(i).fuserid,2,"*") %>
							<% if ccomment.FItemList(i).fdevice = "M" then %>
								<img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성">
							<% end if %>
						</div>
					</div>
				<% next %>
			</div>
	
			<%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage") %>
		<% end if %>
	</div>
	<!-- //신나는 예술, 즐거운 기부! Mr. Gibro -->
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		pagination:false,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3500,
		speed:1000,
		pagination:'.pagination',
		paginationClickable:true,
		autoplayDisableOnInteraction:false
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});
});
</script>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>

<% set ccomment=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->