<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  play 나도작가
' History : 2015.01.09 원승현 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/play/groundcnt/event58509Cls.asp" -->
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

	iCPageSize = 100000		'한 페이지의 보여지는 열의 수
	iCPerCnt = 6		'보여지는 페이지 간격

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	if isMyComm="Y" then cEComment.FUserID = GetLoginUserID

	arrCList = cEComment.fnGetCommentASC		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.section1 .topic {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.section3 {padding-bottom:15%; background:#7dfbaf url(http://webimage.10x10.co.kr/playmo/ground/20150112/bg_green.png) repeat-y 50% 0; background-size:100% auto;}
.wishlist {margin:0 20px; padding:5px 10px 20px 20px; background-color:#fff; border-radius:15px; -webkit-border-radius:15px;}
.wishlist ul {overflow:auto; height:240px; padding-right:10px; -webkit-overflow-scrolling:touch;}
.wishlist ul li {position:relative; padding:12px 0 9px; border-bottom:2px solid #ffe478;}
.wishlist .no {display:block; color:#08d892; font-size:12px; line-height:1.5em;}
.wishlist .no span {font-weight:bold;}
.wishlist em {display:block; margin-top:1px; color:#555; font-size:12px; line-height:1.5em;}
.wishlist em img {width:7px; margin-top:3px; margin-left:1px; vertical-align:middle;}
.wishlist .btndel {position:absolute; top:12px; right:0; width:21px; height:13px; background-color:#08d892; color:#fff; font-size:10px; line-height:1.25em;}
.field {position:relative; padding:0 20px;}
.field legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.itext {padding:15px; background-color:#fff; border-radius:20px; -webkit-border-radius:20px;}
.itext textarea {width:100%; height:40px; padding:0; border:0; font-size:12px; line-height:1.313em;}
.field .submit {width:53%; margin:15px auto 0;}
.field .submit input {width:100%;}
.field .leaf {position:absolute; top:43%; right:5%; width:6%;}
@media all and (min-width:640px){
	.wishlist {margin:0 30px; padding:7px 15px 30px 30px;}
	.wishlist ul {height:320px;}
	.wishlist ul li {padding:20px 0 16px;}
	.wishlist .no {font-size:16px;}
	.wishlist em {margin-top:2px; font-size:16px;}
	.wishlist em img {width:10px;}
	.wishlist .btndel {width:32px; height:18px; font-size:14px;}
	.field {padding:0 30px;}
	.itext {padding:20px;}
	.itext textarea {height:60px; font-size:16px;}
	.field .submit {margin-top:25px;}
	.field .leaf {top:46%;}
}
</style>
<script type="text/javascript">

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

	if(frmcom.txtcomm.value =="다음 이야기를 써주세요. (50자 이내)"){
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

		if(frmcom.txtcomm.value =="다음 이야기를 써주세요. (50자 이내)"){
			frmcom.txtcomm.value ="";
		}
		if(!frmcom.txtcomm.value){
			alert("다음 이야기를 입력해주세요");
			frmcom.txtcomm.focus();
			return false;
		}
		if (GetByteLength(frmcom.txtcomm.value) > 100){
			alert("다음 이야기가 제한길이를 초과하였습니다. 50자 까지 작성 가능합니다.");
			frmcom.txtcomm.focus();
			return;
		}

		frmcom.action='/play/groundcnt/doEventSubscript58509.asp';
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
			document.frmdelcom.action='/play/groundcnt/doEventSubscript58509.asp';
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
<div class="mPlay20150112">
	<div class="iamwriter">
		<div class="section section1">
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150112/img_iam_writer_v1.jpg" alt="" />
			<div class="topic">
				<h1>나도 작가</h1>
				<p>텐바이텐 PLAY에서는 컴퓨터, 모바일 폰의 자판을 펜으로 활용하여 재밌는 이야기를 만들어 보고자 합니다.</p>
				<p>우리 모두 소설 작가! 다 함께 만들어가는 엉뚱 발랄 끝을 알 수 없는 이야기! 재치만점 여러분의 상상력을 발휘하여 소설 &lt;아기양의 지혜&gt;를 완성해 주세요! 추첨을 통해 5분께, 라미 만년필을 선물로 드립니다.</p>
				<p>응모가 종료되었습니다.</p>
			</div>
		</div>

		<div class="section section2">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/tit_sheep.png" alt="아기양의 지혜" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/txt_story_01.gif" alt="어느 화창한 날, 양치기는 양들을 데리고 들판으로 나가 한가롭게 풀을 뜯고 있었어요." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/txt_story_02.gif" alt="아기 양은 맛있는 풀을 찾아 여기저기 헤매다 길을 잃어버리고 말았어요." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/txt_story_03.gif" alt="그러다가 날이 저물어 형제 무리의 길을 찾을 수가 없었어요. &quot;도대체, 여긴 어디야&quot;" /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/txt_story_04.gif" alt="그때 갑자기 어두운 수풀에서 늑대가 나타났어요. &quot;허허허 포동포동한 아기 양이라니! &quot; 늑대는 입맛을 다시며 아기 양에게 다가갔어요." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/txt_story_05.gif" alt="정신을 똑바로 차린 아기 양은 늑대에게 말했어요. &quot;늑대님, 저를 잡아먹으실 건가요?&quot; &quot;당연하지!&quot;" /></p>
		</div>

		<div class="section section3">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/tit_wish.png" alt="아기 양은 침착한 목소리로 늑대에게 말했어요. &quot;하지만 마지막 소원이 있어요, 늑대님&quot; 그 소원은…" /></h2>
			<% IF isArray(arrCList) THEN %>
				<!-- list -->
				<div class="wishlist">
					<ul>
						<%' for dev msg : 제일 먼저 쓴 글부터 보입니다.%>
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
							<span class="no"><span><%=i+1%>.</span> <%=printUserId(arrCList(2,i),2,"*")%></span>
							<em><%= tmpcommenttext %> <% If arrCList(8,i) <> "W" Then %> <img src="http://webimage.10x10.co.kr/playmo/ground/20150112/ico_mobile.png" alt="모바일에서 작성" /><% end if %></em>
							<% if ((GetLoginUserID = arrCList(2,i)) or (GetLoginUserID = "10x10")) and ( arrCList(2,i)<>"") then %>
								<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,i) %>');return false;">삭제</button>
							<% End If %>
						</li>
						<% Next %>
					</ul>
				</div>
			<% End If %>

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
					<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/tit_write.png" alt="다음 소설 한줄을 이어주세요" /></h2>
					<span class="leaf"><img src="http://webimage.10x10.co.kr/playmo/ground/20150112/img_leaf.png" alt="" /></span>
					<fieldset>
					<legend>다음 이야기 쓰기</legend>
						<div class="itext"><textarea cols="50" rows="3" title="다음 이야기 입력" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> ><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>다음 이야기를 써주세요. (50자 이내)<%END IF%></textarea></div>
						<div class="submit"><input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20150112/btn_submit.png" alt="소설쓰기" onclick="jsSubmitComment(); return false;" /></div>
					</fieldset>
				</form>
				<form name="frmdelcom" method="post" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="mode" value="del">
				</form>		
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
	$(".wishlist ul").scrollTop($(".wishlist ul")[0].scrollHeight);
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->