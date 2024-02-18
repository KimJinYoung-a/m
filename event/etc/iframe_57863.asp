<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  배송의 민족 텐바이텐, 널리 박스 테이프를 이롭게 하다 M
' History : 2014.12.19 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event57863Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->

<%
dim eCode, ename, userid, sub_idx, i, intCLoop, leaficonimg
	eCode=getevt_code
	userid = getloginuserid()
dim iCPerCnt, iCPageSize, iCCurrpage
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호

IF iCCurrpage = "" THEN iCCurrpage = 1
iCPageSize = 6		' 한페이지에 보여지는 댓글 수
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
.boxtape {padding-bottom:35px; background-color:#fff;}
.guide .article {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.commentForm {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57864/bg_blue.gif) repeat-y 0 0; background-size:100% auto;}
.commentForm legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.commentForm fieldset {position:relative; padding:20px 107px 20px 10px;}
.commentForm .itext {width:100%; height:42px; border:0; border-radius:0; color:#000; font-size:11px; line-height:42px;}
.commentForm .itext::-webkit-input-placeholder {color:#000;}
.commentForm .submit {position:absolute; top:20px; right:10px; width:87px;}
.commentForm .submit input {width:100%;}
.commentList {padding-top:10px; padding-bottom:15px; background-color:#fff;}
.article {width:300px; margin:25px auto 0;}
.article .no {overflow:hidden;}
.article .no em {float:left; width:50%; color:#919191; font-size:11px; font-weight:bold; line-height:1.25em; text-align:left;}
.article .no span {float:left; width:50%; font-size:11px; line-height:1.25em; text-align:right;}
.commentList .no span img {width:7px; margin-right:5px; vertical-align:middle;}
.commentList .article p {width:300px; height:46px; margin-top:3px; color:#fff; font-size:11px; line-height:46px; text-align:center; word-wrap:break-word;}
.btndel {padding:0 5px; background-color:#a6a6a6; color:#fff; font-size:11px; line-height:1.313em;}
.bg1 .no span {color:#404040;}
.bg2 .no span {color:#dc0610;}
.bg3 .no span {color:#2aae9d;}
.bg4 .no span {color:#404040;}
.bg5 .no span {color:#dc0610;}
.bg6 .no span {color:#2aae9d;}
.bg1 p {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57864/bg_comment_01.gif) no-repeat 0 0; background-size:100% auto;}
.bg2 p {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57864/bg_comment_03.gif) no-repeat 0 0; background-size:100% auto;}
.bg3 p {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57864/bg_comment_02.gif) no-repeat 0 0; background-size:100% auto;}
.bg4 p {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57864/bg_comment_01.gif) no-repeat 0 0; background-size:100% auto;}
.bg5 p {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57864/bg_comment_03.gif) no-repeat 0 0; background-size:100% auto;}
.bg6 p {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57864/bg_comment_02.gif) no-repeat 0 0; background-size:100% auto;}
@media all and (min-width:480px){
	.commentForm fieldset {padding:35px 162px 35px 20px;}
	.commentForm .itext {height:62px; font-size:17px; line-height:62px;}
	.commentForm .submit {top:35px; right:20px; width:130px;}
	.article {width:450px; margin-top:37px;}
	.article .no em {font-size:16px;}
	.article .no span {font-size:16px;}
	.commentList .no span img {width:10px;}
	.commentList .article p {width:450px; height:69px; margin-top:5px; font-size:18px; line-height:69px;}
	.btndel {padding:0 8px; font-size:16px;}
}
</style>
<script type="text/javascript">
function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #01/11/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-12-18" and getnowdate<="2015-01-11" Then %>
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 50 || frm.txtcomm.value == '띄어쓰기 포함 최대 25자 이내로 적어주세요.'){
					alert("코멘트가 없거나 제한길이를 초과하였습니다. 띄어쓰기 포함 25자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return;
				}
		   		frm.mode.value="addcomment";
				frm.action="/event/etc/doEventSubscript57863.asp";
				frm.target="evtFrmProc";
				frm.submit();
				return;
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% End If %>
	<% Else %>
		parent.jsChklogin('<%=IsUserLoginOK%>');
		return false;
	<% End IF %>
}

function jsDelComment(sub_idx)	{
	if(confirm("삭제하시겠습니까?")){
		frmcomm.sub_idx.value = sub_idx;
		frmcomm.mode.value="delcomment";
		frmcomm.action="/event/etc/doEventSubscript57863.asp";
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
	
	if (frmcomm.txtcomm.value == '띄어쓰기 포함 최대 25자 이내로 적어주세요.'){
		frmcomm.txtcomm.value='';
	}
}
</script>
</head>
<body>
<div class="mEvt57864">
	<div class="boxtape">
		<div class="topic">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57864/txt_box_tape.gif" alt ="쇼핑의 기쁨이 배가 될 수 있도록 홍익테이프 정신으로 여러분을 기다립니다." /></p>
		</div>

		<div class="guide">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/57864/txt_guide_01.gif" alt ="" />
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/57864/txt_guide_02.gif" alt ="" />
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/57864/txt_guide_03.gif" alt ="" />
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/57864/txt_guide_04.gif" alt ="" />

			<div class="article">
				<h3>일정</h3>
				<ul>
					<li>카피 응모 : 2014년 12월 19일 (금) ~ 2015년 1월 11일 (일)</li>
					<li>1차 발표 및 고객 투표 : 2015년 1월 14일 (수) ~ 1월 18일 (일)</li>
					<li>최종 발표 : 2015년 1월 21일 (수)</li>
				</ul>

				<h3>시상</h3>
				<ul>
					<li>1등 (1명) : 텐바이텐 gift 카드 30만원 권 + 직접 만들어진 박스 테이프 10개</li>
					<li>2등 (3명) : 텐바이텐 gift 카드 10만원 권 + 직접 만들어진 박스 테이프 10개</li>
					<li>3등 (10명) : 텐바이텐 gift 카드 1만원 권 + 직접 만들어진 박스 테이프 10개</li>
				</ul>

				<h3>규정</h3>
				<ul>
					<li>모든 응모작의 저작권을 포함한 일체 권리는 (주)텐바이텐에 귀속됩니다.</li>
					<li>상품 제작 시 상품 판매 기준에 맞게 일부 분 수정될 가능성이 있습니다.</li>
				</ul>

				<h3>주제</h3>
				<p>쇼핑을 보다 재밌게 표현할 수 있는 카피를 응모해주세요! 재미 50% + 공감 50%</p>
				<p>예시 : 쇼핑과 배송에 대한 재미있는 카피들을 적어주세요. 지나친 쇼핑은 감사합니다, 보람아, 넌 쇼핑할 때 제일 이뻐, 텐바이텐에서 1일 1택배</p>
			</div>
		</div>

		<div class="commentForm">
			<div class="field">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/57864/tit_copy_writer.gif" alt ="우리는 모두 감성 카피라이터다" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57864/txt_cyworld.gif" alt ="다들 싸이월드 일기장에 포도알 좀 붙여봤잖아?" /></p>
				<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
				<input type="hidden" name="mode">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="sub_idx">
					<fieldset>
						<legend>카피 작성하기</legend>
						<input type="text" title="카피 문구" class="itext" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> value="<% IF NOT IsUserLoginOK THEN %>로그인 후 글을 남길 수 있습니다.<% else %>띄어쓰기 포함 최대 25자 이내로 적어주세요.<% END IF %>"/>
						<div class="submit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/57864/btn_submit.gif" onclick="jsSubmitComment(frmcomm); return false;" alt="응모" /></div>
					</fieldset>
				</form>
			</div>
		</div>

		<% IF ccomment.ftotalcount>0 THEN %>
			<div class="commentList">
				<% for i = 0 to ccomment.fresultcount - 1 %>
					<div class="article bg<%= i+1 %>">
						<div class="no">
							<em>no.<%=ccomment.FTotalCount-i-(ccomment.FPageSize*(ccomment.FCurrPage-1))%>
								<% if ((userid = ccomment.FItemList(i).fuserid) or (userid = "10x10")) and ( ccomment.FItemList(i).fuserid<>"") then %>
									<button type="button" class="btndel" onclick="jsDelComment('<%= ccomment.FItemList(i).fsub_idx %>'); return false;">삭제</button>
								<% End If %>
							</em>
							<span><% if ccomment.FItemList(i).fdevice = "M" then %> <img src="http://webimage.10x10.co.kr/eventIMG/2014/57863/ico_mobile.gif" alt ="모바일에서 작성" /><% end if %><strong><%=printUserId(ccomment.FItemList(i).fuserid,2,"*")%></strong>님</span>
						</div>
						<p><strong><%=ReplaceBracket(ccomment.FItemList(i).fsub_opt3)%></strong></p>
					</div>
				<% next %>					
			</div>
			<%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage") %>
		<% end if %>
	</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</div>
</body>
</html>
<% set ccomment=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->