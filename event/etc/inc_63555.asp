<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐바이텐x다노(이벤트페이지)
' History : 2015.06.12 유태욱 생성
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
dim nowdate, totalcnt, sqlstr
dim eCode, ename, userid, sub_idx, i, intCLoop, leaficonimg
	userid = getloginuserid()
dim iCPerCnt, iCPageSize, iCCurrpage
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호

	nowdate = date()
'	nowdate = "2015-06-17"		'''''''''''''''''''''''''''''''''''''''''''''''''''''
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   	= 63787
	Else
		eCode		= 63555
	End If

	IF iCCurrpage = "" THEN iCCurrpage = 1
	iCPageSize = 4		' 한페이지에 보여지는 댓글 수
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

''앱설치버튼 클릭 카운트
	''총 클릭 수
	sqlstr = "select count(*) as cnt "
	sqlstr = sqlstr & " from [db_temp].[dbo].[tbl_event_click_log]"
	sqlstr = sqlstr & " where eventid='"& eCode &"' and chkid ='appdowncnt'"
	rsget.Open sqlstr, dbget, 1

	If Not rsget.Eof Then
		totalcnt = rsget(0)
	End IF
	rsget.close
%>
<style type="text/css">
img {vertical-align:top;}
.topic .date {visibility:hidden; width:0; height:0;}

.wanted {padding:10% 0 24%; background:#f2e8d8 url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_pattern_food.png) repeat-y 50% 0; background-size:100% auto;}
.field {position:relative; width:75.6%; height:0; margin:5% auto 0; padding-bottom:100%;}
.field .inner {position:absolute; top:0; left:0; width:100%; height:100%; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_wanted_01.png) no-repeat 50% 0; background-size:100% auto;}
.field .bg1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_wanted_01.png);}
.field .bg2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_wanted_02.png);}
.field .bg3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_wanted_03.png);}
.field .bg4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_wanted_04.png);}
.field legend {visibility:hidden; width:0; height:0;}
.field .itext {overflow:hidden; display:block; position:absolute; top:56.5%; left:50%; width:62%; height:0; margin-left:-31%; padding-bottom:11.25%;}
.field .itext input {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; background-color:transparent; /*background-color:red; opacity:0.3;*/ color:#000; font-size:13px; font-weight:500; line-height:13px; text-align:center;}
.field .itext02 {top:72.5%; padding-bottom:17.25%;}
.field .itext02 input {font-size:17px; line-height:20px;}
::-webkit-input-placeholder {color:#ccc;}
::-moz-placeholder {color:#ccc;} /* firefox 19+ */
:-ms-input-placeholder {color:#ccc;} /* ie */
input:-moz-placeholder {color:#ccc;}

.btnsubmit {position:absolute; bottom:-16%; left:50%;width:61.5%; margin-left:-30.75%;}
.btnsubmit input {width:100%;}

.commentlist {padding-bottom:16%; background:#f9f7f1 url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_pattern_ivory.png) repeat-y 50% 0; background-size:100% auto;}
.commentlist ul {overflow:hidden; padding:2%;}
.commentlist ul li {overflow:hidden; float:left; position:relative; width:50%; height:0; margin-top:4%; padding:0 1% 68.25%;}
.commentlist ul li div {position:absolute; top:0; left:0; width:100%; height:100%; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_list_01.png) no-repeat 50% 0; background-size:100% auto;}
.commentlist ul li .type1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_list_01.png);}
.commentlist ul li .type2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_list_02.png);}
.commentlist ul li .type3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_list_03.png);}
.commentlist ul li .type4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_list_04.png);}
.commentlist ul li em, .commentlist ul li strong {overflow:hidden; display:block; position:absolute; top:68.5%; left:50%; width:90%; height:0; margin-left:-45%; padding-bottom:8.25%; text-align:center;}
.commentlist ul li span {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; background-color:transparent; /*background-color:red; opacity:0.3;*/ color:#000; font-size:11px; font-weight:500; line-height:15px; text-align:center;}
.commentlist ul li strong {top:80%; padding-bottom:10.25%;}
.commentlist ul li strong span {color:#fff; font-size:15px; line-height:16px;}

.noti {padding:30px 20px; background:#ed445b url(http://webimage.10x10.co.kr/eventIMG/2015/63555/bg_pink.png) repeat-y 50% 0; background-size:100% auto;}
.noti h2 {color:#ed445b; font-size:13px;}
.noti h2 strong {display:inline-block; padding:5px 12px 2px; border-radius:20px; background-color:#fff; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:15px; color:#fff; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #eee57b; border-radius:50%; background-color:transparent;}

@media all and (min-width:375px){
	.commentlist ul li em span {font-size:12px;line-height:17px;}
	.commentlist ul li strong span {font-size:17px; line-height:20px;}
}

@media all and (min-width:480px){
	.commentlist ul li em span {font-size:16px;line-height:19px;}
	.commentlist ul li strong span {font-size:22px; line-height:24px;}

	.noti {padding:40px 35px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.field .itext input {font-size:19px; line-height:19px;}
	.field .itext02 input {font-size:25px; line-height:28px;}

	.commentlist ul li em span {font-size:20px; line-height:26px;}
	.commentlist ul li strong span {font-size:26px; line-height:32px;}

	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}

@media all and (min-width:768px){
	.field .itext input {font-size:21px; line-height:21px;}
	.field .itext02 input {font-size:40px; line-height:60px;}

	.commentlist ul li em span {font-size:24px; line-height:32px;}
	.commentlist ul li strong span {font-size:32px; line-height:38px;}
}
</style>
<script type="text/javascript">
<% if Request("iCC") <> "" then %>
	$(function(){
		setTimeout("pagedown()",100);
	});
<% end if %>

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#commentdiv").offset().top}, 0);
}

function fnappdowncnt(){
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript63555.asp",
		data: "mode=appdowncnt",
		dataType: "text",
		async: false
	}).responseText;

	if (str == "OK"){
		var userAgent = navigator.userAgent.toLowerCase();
			parent.top.location.href='http://m.10x10.co.kr/apps/link/?7320150612';
			return false;
	
		$(function(){
			var chkapp = navigator.userAgent.match('tenapp');
			if ( chkapp ){
				$("#mo").hide();
			}else{
				$("#mo").show();
			}
		});
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

function jsSubmitComment(frm){      //코멘트 입력
	<% If IsUserLoginOK() Then %>
		<% If Now() > #06/21/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If nowdate>="2015-06-16" and nowdate<"2015-06-22" Then %>
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 12 || frm.txtcomm.value == '6글자 이내로 남겨주세요.'){
					alert("코멘트가 없거나 제한길이를 초과하였습니다.(6글자 이하로 써주세요)");
					frm.txtcomm.focus();
					return;
				}

				if (frm.txtcomm2.value == '' || GetByteLength(frm.txtcomm2.value) > 24 || frm.txtcomm2.value == '12글자 이내로 남겨주세요.'){
					alert("코멘트가 없거나 제한길이를 초과하였습니다.12글자 이하로 써주세요)");
					frm.txtcomm2.focus();
					return;
				}

		   		frm.mode.value="addcomment";
				frm.action="/event/etc/doeventsubscript/doEventSubscript63555.asp";
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
		frmcomm.action="/event/etc/doeventsubscript/doEventSubscript63555.asp";
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
}
</script>
	<!-- [모바일전용] 텐바이텐x다노 -->
	<div class="mEvt63555">
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/63555/tit_dano.png" alt="단호한 훼방꾼" /></h1>
			<p class="date">당신을 방해하는 그 녀석을 신고해주세요 ! 추첨을 통해 다이어트를 도와드릴 선물이 찾아갑니다! 이벶트 기간은 6월 16일부터 6월 21일까지며, 당첨자 발표는 6월 22일입니다.</p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63555/img_gift_v2.jpg" alt="한계를 모르는 친구 아이패드 1명, 평가하기 좋아하는 친구 샤오미 체중계 20명, 식탐이 강한 친구 다노 스템 식판 30명께 드립니다." /></p>
		</div>
		<!-- for dev msg : 입력 폼 -->
		<section>
			<div class="wanted">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/63555/tit_wanted.png" alt="여러분의 다이어트를 힘들게 하는 사람들을 적어주세요!" /></h2>
				<div class="field">
					<div class="inner">
						<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
						<input type="hidden" name="mode">
						<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
						<input type="hidden" name="sub_idx">
							<fieldset>
							<legend>다이어트를 힘들게 하는 사람과 이유 적기</legend>
								<div class="itext itext01">
									<input type="text" name="txtcomm2" id="txtcomm2" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>로그인을 해주세요.<% else %>12자 이내로 작성<% END IF %>" />
								</div>

								<div class="itext itext02">
									<input type="text" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>로그인을 해주세요.<% else %>6자 이내로 작성<% END IF %>" />
								</div>
								<div class="btnsubmit"><input type="image" onclick="jsSubmitComment(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/63555/btn_submit2.png" alt="응모하기" /></div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</section>

		<% IF ccomment.ftotalcount>0 THEN %>
		<!-- for dev msg : 리스트 -->
		<section>
			<div class="commentlist" id="commentdiv">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/63555/tit_list.png" alt="또 다른 훼방꾼 리스트" /></h2>
				<ul>
				<% for i = 0 to ccomment.fresultcount - 1 %>
					<li>
						<div>
							<em><span><%= ReplaceBracket(ccomment.FItemList(i).fsub_opt3) %></span></em>
							<strong><span><%= ReplaceBracket(ccomment.FItemList(i).fsub_opt1) %></span></strong>
						</div>
					</li>
				<% next %>
				</ul>

				<%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage") %>
			</div>
		</section>
		<% end if %>
		<div class="btnapp">
			<a href="" onclick="fnappdowncnt();return false;" title="텐바이텐 앱 설치하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63555/btn_app.png" alt="지금 텐바이텐 APP을 설치하면 재밌는 이벤트가 가득! 설치하러 가기" /></a>
		</div>
		<% 
		If userid="baboytw" Or userid="greenteenz" Or userid="cogusdk" Then
			response.write totalcnt
		end if
		%>
		<section>
			<div class="noti">
				<h2><strong>유의사항</strong></h2>
				<ul>
					<li>본 이벤트는 ID당 1회만 응모가능합니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>당첨된 고객께는 익일 당첨안내 문자가 전송될 예정입니다.</li>
					<li>당첨된 상품은 당첨안내 확인 후에 발송됩니다!<br /> 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
					<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
				</ul>
			</div>
		</section>

	</div>
	<!--// 텐바이텐x다노 -->
<script type="text/javascript">
$(function(){
	/* wanted random bg */
	var classes = ["bg1", "bg2", "bg3", "bg4"];
	$(".wanted .field .inner").each(function(){
		$(this).addClass(classes[~~(Math.random()*classes.length)]);
	});

	/* commentlist random bg */
	var randomList = ["type1", "type2", "type3", "type4"];
	var listSort = randomList.sort(function(){
		return Math.random() - Math.random();
	});
	$(".commentlist ul li div").each( function(index,item){
		$(this).addClass(listSort[index]);
	});
});
</script>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<% set ccomment=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->