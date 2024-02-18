<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  play PEN_KEEP MY MEMORY
' History : 2015.01.02 원승현 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/play/groundcnt/event58265Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->

<%
dim eCode
	eCode   =  getevt_code()

dim commentexistscount, userid, i
commentexistscount=0
userid = getloginuserid()

if userid<>"" then
	commentexistscount=getcommentexistscount(userid, eCode, "", "", "", "Y")
end if

dim com_egCode, bidx, isMyComm
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	
	isMyComm	= requestCheckVar(request("isMC"),1)
	
	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	if isMyComm="Y" then cEComment.FUserID = GetLoginUserID

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.memory {padding-bottom:5%; background:#a7cad4 url(http://webimage.10x10.co.kr/playmo/ground/20150105/bg_pen.jpg) no-repeat 50% 0; background-size:100% auto;}
.movie {padding:5% 3.125%;}
.movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.topic {padding:8% 3.125% 10%;background:url(http://webimage.10x10.co.kr/playmo/ground/20150105/bg_paper_top.png) no-repeat 50% 0; background-size:100% auto;}
.topic p {margin-top:8%;}

.write {padding:0 3.125% 15%;background:url(http://webimage.10x10.co.kr/playmo/ground/20150105/bg_paper_btm.png) no-repeat 50% 100%; background-size:100% auto;}
legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.field {padding:0 7.5%;}
.field textarea {overflow:hidden; width:100%; min-height:35px; margin-top:5%; padding:10px; border:2px solid #5787a0; border-radius:0; background-color:transparent; color:#000; font-size:12px; line-height:1.313em;}
.field textarea::-webkit-input-placeholder {color:#000;}
.field textarea:-moz-placeholder {color:#000;}
.field textarea::-moz-placeholder {color:#000;}
.field textarea::-ms-input-placeholder {color:#000;}
.submit {width:66%; margin:3% auto 0;}
.submit input {width:100%;}
.commentlist {margin:7% 3.3% 0; padding-top:5px; background-color:rgba(211,216,217,0.6);}
.commentlist .inner {padding-bottom:30px; background-color:#fff;}
.commentlist ul {padding:13px 20px 0;}
.commentlist ul li {position:relative; padding:7px 0; border-bottom:1px solid #ccc;}
.commentlist ul li span {display:block; padding-bottom:6px; border-bottom:1px dashed #eee; color:#777; font-size:11px;}
.commentlist ul li span em {padding:1px 5px 0; border-radius:10px; background-color:#b1d1da; color:#fff; line-height:1em;}
.commentlist ul li strong {display:block; margin-top:3px; color:#6dadbf; font-size:12px; font-weight:normal; line-height:1.5em;}
.commentlist ul li img {width:7px; vertical-align:middle;}
.btndel {position:absolute; top:5px; right:0; padding-right:14px; background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20150105/btn_del.gif) no-repeat 100% 50%; background-size:7px auto; color:#aaa; font-size:11px; line-height:1.375em;}

@media all and (max-width:320px){
.paging span {margin:0 1px;}
.paging span.prevBtn {margin-right:4px;}
.paging span.nextBtn {margin-left:4px;}
}
@media all and (min-width:480px){
	.field textarea {min-height:52px; padding:15px; font-size:17px;}

	.commentlist {padding-top:7px;}
	.commentlist .inner {padding-bottom:45px;}
	.commentlist ul {padding:19px 30px 0;}
	.commentlist ul li {padding:10px 0;}
	.commentlist ul li span {padding-bottom:9px; font-size:16px;}
	.btndel {font-size:16px;}
	.commentlist ul li strong {margin-top:5px; font-size:17px;}
	.commentlist ul li img {width:10px;}
	.btndel {top:7px; background-size:10px auto;}
}
</style>
<script type="text/javascript">
$(function(){
	jQuery(window.parent).scroll(function(){
		var scrollTop = jQuery(document.parent).scrollTop();
		console.log("scrollTop : " + scrollTop);
		if (scrollTop < 70 ) {
			show();
		}
	});

	$(".topic h1").css({"opacity":"0"});
	$(".topic p").css({"opacity":"0"});

	function show() {
		$(".topic h1").delay(300).animate({"opacity":"1"},1000);
		$(".topic p").delay(300).animate({"opacity":"1"},1000);
	}
});

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/play/playGround.asp")%>');
			return false;
		<% end if %>
	}

	if(frmcom.txtcomm.value =="내가 좋아 하는 말 (40자 이내)"){
		frmcom.txtcomm.value ="";
	}
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
											
function jsSubmitComment(){
	<% If IsUserLoginOK() Then %>
		<% if commentexistscount>=5 then %>
//			alert('한아이디당 5회 까지만 참여가 가능 합니다.');
//			return;
		<% end if %>

		if(frmcom.txtcomm.value =="내가 좋아 하는 말 (40자 이내)"){
			frmcom.txtcomm.value ="";
		}
		if(!frmcom.txtcomm.value){
			alert("코멘트를 입력해주세요");
			frmcom.txtcomm.focus();
			return false;
		}
		if (GetByteLength(frmcom.txtcomm.value) > 80){
			alert("코맨트가 제한길이를 초과하였습니다. 40자 까지 작성 가능합니다.");
			frmcom.txtcomm.focus();
			return;
		}

		frmcom.action='/play/groundcnt/doEventSubscript58265.asp';
		frmcom.submit();
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/play/playGround.asp")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	<% If IsUserLoginOK() Then %>
		if (cidx==""){
			alert('정상적인 경로가 아닙니다');
			return;
		}
		
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
			document.frmdelcom.action='/play/groundcnt/doEventSubscript58265.asp';
	   		document.frmdelcom.submit();
		}
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/play/playGround.asp")%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>
<!-- iframe -->
<div class="mPlay20150105">
	<div class="memory">
		<div class="movie">
			<div class="youtube">
				<iframe src="//player.vimeo.com/video/115775467" frameborder="0" title="Keep My Memory" allowfullscreen></iframe>
			</div>
		</div>

		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20150105/tit_keep_my_memory.png" alt="Keep My Memory" /></h1>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150105/txt_topic.png" alt="우리가 살아가는 순간순간이 누군가 써주는 원고와 같다면 어떨까요. 플레이 열여섯 번째 주제는 쓱싹쓱싹 나와 가장 가까운 곳에서 기록자 역할을 해주는 펜입니다. 우리는 많은 순간 펜과 함께합니다. 순간의 기억들을 잡아두기 위해 펜을 잡기도 하고 잊지 않아야 할 곳에 한 번 더 체크를 해 두기도 하고 말로 하기는 어려운 말들을 대신 전하기도 합니다. 플레이에서는 우리의 일상 속에서 펜과 함께 기록되고 있는 순간, 글자들을 담아보았습니다. 여러분의 새로운 시작과 앞으로의 나날들이 행복한 이야기들로만 기록되어 지길 바랍니다." /></p>
		</div>

		<div class="write">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150105/tit_like_write.gif" alt="당신이 좋아하는 말을 기록해주세요." /></h2>

			<!-- comment form -->
			<div class="field">
				<form name="frmcom" method="post" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="spoint" value="0">
				<input type="hidden" name="isMC" value="<%=isMyComm%>">
					<fieldset>
					<legend>당신이 좋아하는 말 쓰기</legend>
						<textarea cols="50" rows="2" title="좋아하는 말 입력" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> placeholder="내가 좋아 하는 말 (40자 이내)"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>내가 좋아 하는 말 (40자 이내)<%END IF%></textarea>
						<div class="submit"><input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20150105/btn_submit.png" alt="기록하기" onclick="jsSubmitComment(); return false;" /></div>
					</fieldset>
				</form>
				<form name="frmdelcom" method="post" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="mode" value="del">
				</form>		
			</div>

			<!-- comment list -->
			<% IF isArray(arrCList) THEN %>
				<div class="commentlist">
					<div class="inner">
						<ul>
							<%' for dev msg : 한페이지당 6개 보여주세요. %>
							<%
							dim tmpcomment, tmpcommentgubun , tmpcommenttext
							For i = 0 To UBound(arrCList,2)
							
							tmpcomment = ReplaceBracket(db2html(arrCList(1,i)))
							tmpcomment = split(tmpcomment,"!@#")
							if isarray(tmpcomment) then
								tmpcommentgubun=tmpcomment(0)
								tmpcommenttext=tmpcomment(1)
							end if
							%>
								<li>
									<span><em>No.<%=iCTotCnt-i-(iCPageSize*(iCCurrpage-1))%></em> <%=printUserId(arrCList(2,i),2,"*")%>의 기록 <% If arrCList(8,i) <> "W" Then %><img src="http://webimage.10x10.co.kr/playmo/ground/20150105/ico_mobile.gif" alt="모바일에서 작성" /><% end if %></span>
									<strong><%= tmpcommenttext %></strong>
									<% if ((GetLoginUserID = arrCList(2,i)) or (GetLoginUserID = "10x10")) and ( arrCList(2,i)<>"") then %>
										<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,i) %>');return false;">삭제</button>
									<% End If %>
								</li>
							<% next %>
						</ul>

						<div class="paging">
							<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
						</div>
					</div>
				</div>
			<% End If %>
		</div>
	</div>
</div>
<!-- //iframe -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->