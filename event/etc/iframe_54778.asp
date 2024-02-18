<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'########################################################
' Play-sub 안아줘요 셔츠맨! - for Mobile Web
' 2014-09-12 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21299
Else
	eCode   =  54945
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 4		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > PLAY #12 Shirts_안아줘요 셔츠-맨</title>
<style type="text/css">
.mEvt54778 {}
.mEvt54778 img {vertical-align:top; width:100%;}
.mEvt54778 p {max-width:100%;}
.shirtman .section, .shirtman .section h3 {margin:0; padding:0;}
.shirtman .heading {padding-bottom:10%; background-color:#f6f6f6;}
.shirtman .btn-apply {margin:7% 18.75% 0;}
.shirtman .about {position:relative; padding-top:10%; background-color:#fff;}
.shirtman .about .figure {position:absolute; top:10%; left:0; width:100%;}
.shirtman .comment-event {background-color:#fff;}
.shirtman .comment-event form fieldset {border:0;}
.shirtman .comment-event form legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.shirtman .comment-event ul {overflow:hidden; padding:0 20px;}
.shirtman .comment-event ul li {float:left; width:33.33333%; padding:0 2.5%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; text-align:center;}
.shirtman .comment-event ul li input {border-radius:20px;}
.shirtman .comment-event ul li label {display:block; margin-top:6%;}
.shirtman .comment-event .write {position:relative; padding:15px 75px 20px 15px;}
.shirtman .comment-event textarea {width:100%; height:77px; padding:15px; background-color:#f9f9f9; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; color:#999; font-size:12px;}
.shirtman .comment-event .write .btn-submit {position:absolute; top:15px; right:20px; width:50px;}
.shirtman .comment-event .write .btn-submit input {width:100%;}
.shirtman .comment-list {padding-bottom:28px; background-color:#f6f6f6;}
.shirtman .comment-shirt {padding:20px 20px 0;}
.shirtman .comment-shirt .shirt {position:relative; margin-top:20px; padding:10px; min-height:115px; border-radius:10px; text-align:left;}
.shirtman .comment-shirt .shirt .bg {display:block; position:absolute; top:-9px; left:50%; width:46px; height:39px; margin-left:-23px; background-repeat:no-repeat; background-position:50% 0; background-size:46px auto;}
.shirtman .comment-shirt .color01 {border:2px solid #7ca9d5;}
.shirtman .comment-shirt .color01 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54778/bg_shirt_01.gif);}
.shirtman .comment-shirt .color02 {border:2px solid #ea8fa9; }
.shirtman .comment-shirt .color02 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54778/bg_shirt_02.gif);}
.shirtman .comment-shirt .color03 {border:2px solid #596290;}
.shirtman .comment-shirt .color03 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54778/bg_shirt_03.gif);}
.shirtman .comment-shirt .shirt strong {padding-left:8px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54778/blt_dot.gif) no-repeat 0 4px; background-size:3px auto; color:#b5b5b5; font-size:11px;}
.shirtman .comment-shirt .shirt .num {position:absolute; top:10px; right:20px; color:#b5b5b5; font-size:11px;}
.shirtman .comment-shirt .shirt .reason img {width:8px; margin-left:3px; vertical-align:middle;}
.shirtman .comment-shirt .shirt .reason {margin-top:8px; color:#555; font-size:12px; line-height:1.4;}
.shirtman .comment-shirt .shirt .btnDel {position:absolute; right:-10px; top:-7px; width:18px; height:18px; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54778/btn_del.png) no-repeat 0 0; background-size:18px auto; text-indent:-999em; cursor:pointer;}
.shirtman .comment-list .paging {margin-top:28px;}
</style>
<script type="text/javascript">
$(function(){
	$('.tentList .bg01 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent01.png" alt="" />');
	$('.tentList .bg02 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent02.png" alt="" />');
	$('.tentList .bg03 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent03.png" alt="" />');
	$('.tentList .bg04 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent04.png" alt="" />');
});
</script>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>

		var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
	    isAndroid = navigator.userAgent.match('Android');

		if (isiOS || isAndroid) {
			parent.calllogin();
			return false;
		} else {
			parent.jsevtlogin();
			return;
		}
		<% end if %>

	   
	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked)){
	    alert("셔츠맨을 선택 해주세요");
	    return false;
	   }

	    if(!frm.txtcomm.value || frm.txtcomm.value == "100자 이내로 입력해주세요."){
	    alert("100자 이내로 입력해주세요.");
		document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }

	   	if(GetByteLength(frm.txtcomm.value)>201){
			alert('100자 까지 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}

	   frm.action = "doEventSubscript54778.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.txtcomm.value == "100자 이내로 입력해주세요." ){
				document.frmcom.txtcomm.value="";
			}
			return true;
		} else {
			var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
			isAndroid = navigator.userAgent.match('Android');

			if (isiOS || isAndroid) {
				parent.calllogin();
				return false;
			} else {
				parent.jsevtlogin();
				return;
			}
		}

		return false;
	}

	function jsChkUnblur()
	{
		if(document.frmcom.txtcomm.value ==""){
			document.frmcom.txtcomm.value = "100자 이내로 입력해주세요."
		}
	}

	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 100자 이내로 제한됩니다.");
		obj.value = obj.value.substring(0,maxLength); //100자 이하 튕기기
		}
	}

//-->
</script>
</head>
<body>
<div class="mEvt54778">
	<div class="shirtman">
		<div class="section heading">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/txt_dont_be_lonely.gif" alt="Don&apos;t be lonely" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/txt_define.gif" alt="안다의 사전적 의미는 두 팔을 벌려 가슴 쪽으로 끌어당기거나 그렇게 하여 품 안에 있게 하다" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/txt_shirtman.gif" alt="당신을 힘껏 안아 줄 셔츠맨! 셔츠를 생각했을 때, 왠지 등과 어깨가 넓은 남자가 떠올랐어요. 그 셔츠맨은 내가 힘들거나 외로울 때, 아무 이유 없이, 나를 꽈악 안아 주었으면 좋겠다고 생각했죠. 그래서 텐바이텐 PLAY는 안아줘요. 셔츠맨을 만들었습니다. 텐바이텐이 한 땀 한 땀 제작한 셔츠맨을 만나보세요!" /></p>
			<div class="btn-apply"><a href="#comment-event"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/btn_apply.gif" alt="셔츠맨 신청하러 가기" /></a></div>
		</div>

		<div class="section visual">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/img_hug_shirtman.jpg" alt="셔츠맨과 안고 있는 모습" />
		</div>

		<div class="section about">
			<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/img_about_shirtman.png" alt="" /></div>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/tit_about_shirtman.gif" alt="ABOUT SHIRTS MAN" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/txt_about_shirtman.gif" alt="셔츠맨은 듬직한 어깨와 넓은 가슴을 가진 남자이자, 포근함을 간직한 바디 필로우입니다. 허리까지 제작되어 있으며, 셔츠는 언제든 이상형에 맞게 바꿔줄 수 있어요" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/txt_size_information.gif" alt="셔츠맨은 세로 100센치미터, 어깨 50센치미터이며 M사이즈 착용합니다. 사이즈는 조금씩 달라질 수 있습니다." /></p>
		</div>

		<div class="section scene">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/txt_hug.jpg" alt="안아줄게요 당신의 몸과 마음이 따뜻해질 수 있도록 당신을 꼬옥 안아 드릴게요" /></p>
		</div>

		<!-- comment -->
		<div id="comment-event" class="section comment-event">
			<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>"/>
			<input type="hidden" name="bidx" value="<%=bidx%>"/>
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
			<input type="hidden" name="iCTot" value=""/>
			<input type="hidden" name="mode" value="add"/>
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
				<fieldset>
				<legend>나의 이상형 작성하기</legend>
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/tit_comment_event.gif" alt="코멘트 이벤트" /></h3>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/txt_comment_event.gif" alt="마음에 드는 셔츠맨을 선택하고, 자신의 이상형을 적어주세요!" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/txt_gift.gif" alt="추첨을 통해 3분께 텐바이텐이 제작한 에디션 셔츠맨 바디필로우를 선물로 드립니다. 이벤트 기간은 2014년 9월 15일 월요일부터 9월 24일 수요일까지며, 당첨자 발표는 9월 26일 금요일입니다." /></p>
					<div class="cmtField">
					<ul>
						<li>
							<input type="radio" id="idealtype01" name="spoint" value="1" />
							<label for="idealtype01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/ico_shirtman_01.jpg" alt="따뜻포근 자상셔츠맨" /></label>
						</li>
						<li>
							<input type="radio" id="idealtype02" name="spoint" value="2" />
							<label for="idealtype02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/ico_shirtman_02.jpg" alt="위트폭발 애교셔츠맨" /></label>
						</li>
						<li>
							<input type="radio" id="idealtype03" name="spoint" value="3" />
							<label for="idealtype03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/ico_shirtman_03.jpg" alt="남자냄새 의리셔츠맨" /></label>
						</li>
					</ul>
					</div>
					<div class="write">
						<textarea title="코멘트 작성" cols="50" rows="5" title="나의 이상형 작성" placeholder="코멘트를 입력해주세요." id="writearea" name="txtcomm" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%> autocomplete="off" maxlength="100">100자 이내로 입력해주세요.</textarea>
						<div class="btn-submit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/54778/btn_submit.gif" alt="이벤트 응모하기" /></div>
					</div>
				</fieldset>
			</form>
			<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			</form>
		</div>

		<!-- comment list -->
		<div class="section comment-list">
			<% IF isArray(arrCList) THEN %>
			<div class="comment-shirt">
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<div class="shirt color0<%=arrCList(3,intCLoop)%>">
					<span class="bg"></span>
					<div class="num"><span>no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span></div>
					<strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong>
					<div class="reason">
						<%=nl2br(arrCList(1,intCLoop))%> <% If arrCList(8,intCLoop) = "M"  then%><img src="http://webimage.10x10.co.kr/eventIMG/2014/54778/ico_mobile.gif" alt="모바일 에서 작성된 글입니다." /><% End If %>
					</div>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button type="button" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</button>
					<% end if %>
				</div>
				<% Next %>
			</div>
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			<% End If %>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->