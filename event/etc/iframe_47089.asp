<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event46226Cls.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21021
Else
	eCode   =  47083
End If

dim com_egCode, bidx
	Dim cEComment
	Dim cEComment1
	Dim iCTotCnt, arrCList,arrClist1,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, FCpage

	'파라미터값 받기 & 기본 변수 값 세팅
	FCpage =requestCheckVar(Request("FCpage"),10)
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 8		'한 페이지의 보여지는 열의 수
	iCPerCnt = 10		'보여지는 페이지 간격

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
%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 생활감정채널 - EPISODE 03</title>
	<style type="text/css">
	.mEvt47089 {}
	.mEvt47089 p {max-width:100%;}
	.mEvt47089 img {vertical-align:top; display:inline;}
	.mEvt47089 .overHidden {overflow:hidden;}
	.mEvt47089 .myWishCmt {background:#5da4bb;}
	.mEvt47089 .myWishCmt .selectFace {position:relative;}
	.mEvt47089 .myWishCmt .selectFace ul {position:absolute; left:18%; top:13%; width:64%;}
	.mEvt47089 .myWishCmt .selectFace li {float:left; width:50%; padding-bottom:4%; text-align:center;}
	.mEvt47089 .myWishCmt .selectFace li label {display:block; padding:0 5%;}
	.mEvt47089 .myWishCmt .selectFace li input {margin:5px 0 0 22%;}
	.mEvt47089 .writeWish {padding:4% 8% 0;}
	.mEvt47089 .writeWish .writeForm {padding:10px; margin:10px 0; border:3px solid #ffe200; background:#fff;}
	.mEvt47089 .writeWish .writeForm textarea {display:block; width:100%; height:50px; font-size:11px; font-weight:bold; color:#000; border:0;}
	.mEvt47089 .writeWish .send {display:block; margin-top:7%; -webkit-border-radius:0; -webkit-appearance:none;}
	.mEvt47089 .myWishGift ol {margin:33px 0 40px;}
	.mEvt47089 .myWishGift li {position:relative; margin-bottom:10px;}
	.mEvt47089 .myWishGift li:last-child {margin-bottom:0;}
	.mEvt47089 .myWishGift li .face {position:absolute; left:0; top:0; width:20%; height:100%; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
	.mEvt47089 .myWishGift li.f01 .face {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img_face01.png);}
	.mEvt47089 .myWishGift li.f02 .face {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img_face02.png);}
	.mEvt47089 .myWishGift li.f03 .face {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img_face03.png);}
	.mEvt47089 .myWishGift li.f04 .face {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img_face04.png);}
	.mEvt47089 .myWishGift .txtInfo {position:absolute; left:23%; top:8%; width:72%; font-size:11px; line-height:14px; font-weight:bold; color:#fff; overflow:hidden;}
	.mEvt47089 .myWishGift .txtInfo .writer {float:left;}
	.mEvt47089 .myWishGift .txtInfo .writer img {margin-right:3px; margin-top:2px;}
	.mEvt47089 .myWishGift .txtInfo .num {float:right;}
	.mEvt47089 .myWishGift .txt {position:absolute; left:23%; top:28%; width:63%; padding:0 5%; font-size:12px; color:#777;}
	.mEvt47089 .myWishGift .txt strong {display:block; color:#000; line-height:16px; padding:7px 0 5px;}
	.mEvt47089 .myWishGift .delete {position:absolute; right:7%; bottom:26%;}
	.mEvt47089 .myWishGift .date {position:absolute; bottom:6%; left:23%; padding:3px 10px; font-size:11px; color:#9babbd; border-radius:18px; background:rgba(0,0,0,.3);}

	.mWebtoonNav {overflow:hidden;}
	.mWebtoonNav li {float:left; width:25%;}
</style>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		location.href="/event/etc/iframe_47089.asp?iCC="+iP;
	}
	function goPage(page)
	{
		scrollToAnchor('rank');
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();

	}

function scrollToAnchor(where){
 scrollY=document.getElementById(where).offsetTop;
 scrollTo(0,scrollY);
}



	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked)){
	    alert("표정을 선택해주세요");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="30자 이내로 작성해 주세요."){
	    alert("받고싶은선물을 입력해주세요");
	    document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }
	   	if(GetByteLength(frm.txtcomm.value)>60){
			alert('최대 한글 30자 까지 입력 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}
	   frm.action = "/event/etc/doEventSubscript46928.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsupdateComment(cidx)	{
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return;
		<% end if %>

			document.frmupdatecom.Cidx.value = cidx;
	   		document.frmupdatecom.submit();
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.txtcomm.value =="30자 이내로 작성해 주세요."){
				document.frmcom.txtcomm.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur()
	{

		if(document.frmcom.txtcomm.value ==""){
			document.frmcom.txtcomm.value="30자 이내로 작성해 주세요.";
		}
	}
	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 최대 30자 입니다.");
		obj.value = obj.value.substring(0,maxLength); //100자 이하 튕기기
		}
	}

//-->
</script>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt47089">

					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_head.png" alt="생활감정채널" style="width:100%;" /></div>
					<ul class="mWebtoonNav">
						<!-- for dev msg : nav02부터 해당 날짜가 되면 이미지명이 _off.png로 바뀌게 해주세요 -->
						<li class="nav01"><a href="/event/eventmain.asp?eventid=47087" target="_top"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav01_off.png" alt="EPISODE 1" style="width:100%;" /></a></li>
						<li class="nav02"><a href="/event/eventmain.asp?eventid=47088" target="_top"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav02_off.png" alt="EPISODE 2" style="width:100%;" /></a></li>
						<li class="nav03"><a href="/event/eventmain.asp?eventid=47089" target="_top"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav03_on.png" alt="EPISODE 3" style="width:100%;" /></a></li>
						<li class="nav04"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav04.png" alt="EPISODE 4" style="width:100%;" /></li>
					</ul>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img01.png" alt="괜찮아" style="width:100%;" /></dt>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img02.png" alt="" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img03.png" alt="" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img04.png" alt="" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img05.png" alt="" style="width:100%;" /></dd>
					</dl>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_img06.png" alt="COMMENT EVENT" style="width:100%;" /></div>
					<!-- comment write -->
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<div class="myWishCmt">
						<div class="selectFace">
							<ul>
								<li>
									<label for="face01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_select_face01.png" alt="버럭" style="width:100%;" /></label>
									<input type="radio" name="spoint" value="1" id="face01" />
								</li>
								<li>
									<label for="face02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_select_face02.png" alt="웃음" style="width:100%;" /></label>
									<input type="radio" name="spoint" value="2" id="face02" />
								</li>
								<li>
									<label for="face03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_select_face03.png" alt="눈물" style="width:100%;" /></label>
									<input type="radio" name="spoint" value="3" id="face03" />
								</li>
								<li>
									<label for="face04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_select_face04.png" alt="놀람" style="width:100%;" /></label>
									<input type="radio" name="spoint" value="4" id="face04" />
								</li>
							</ul>
							<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_bg01.png" alt="" style="width:100%;" /></p>
						</div>
						<div class="writeWish">
							<div class="overHidden">
								<p style="width:40%;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_txt01.png" alt="나.. 사실은" style="width:100%;" /></p>
								<p class="writeForm"><textarea name="txtcomm" maxlength="30" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="30자 이내로 작성해 주세요." autocomplete="off">30자 이내로 작성해 주세요.</textarea></p>
								<p class="ftRt" style="width:40%;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_txt02.png" alt="선물로 받고 싶어" style="width:100%;" /></p>
							</div>
							<input type="image" class="send" src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_btn_send.png" style="width:100%;" alt="전송" />
						</div>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_txt03.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며,이벤트 참여에 제한을 받을 수 있습니다." style="width:100%;" /></p>
				</form>
				<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript46928.asp" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				</form>
					<!--// comment write -->
					<style>

					</style>
					<a name="rank" id="rank"></a>
					<!-- comment list -->
					<div class="myWishGift">
						<ol>
							<!-- for dev msg : 얼굴 선택에 따라 클래스 f01~04 / 리스트는 8개씩 노출됩니다. -->
						<% IF isArray(arrCList) THEN %>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li class="f0<%= arrCList(3,intCLoop) %>">
								<p class="face"></p>
								<p class="txtInfo">
									<span class="writer"><% If arrCList(8,intCLoop)="M" Then %><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_ico_mobile.png" style="width:6px;" alt="모바일에서 작성" /><% End IF %>&nbsp; <%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
									<span class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
								</p>
								<p class="txt">
									나 ··· 사실은 ···
									<strong><%=db2html(arrCList(1,intCLoop))%></strong>
									선물로 받고 싶어
								</p>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %><span class="delete btn btn6 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span><% End If %>
								<p class="date"><%=FormatDate(arrCList(4,intCloop),"0000.00.00")%></p>
								<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47089/47089_bg02.png" style="width:100%;" alt="모바일에서 작성" /></p>
							</li>
							<% next %>
						<% End If %>
						</ol>
						<div class="paging">
							<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
						</div>
					</div>
					<!--// comment list -->
				</div>
			</div>
			<!-- //content area -->
</body>
</html>
