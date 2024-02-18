<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20908
Else
	eCode   =  42765
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt
	Dim cate


	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 5		'한 페이지의 보여지는 열의 수
	iCPerCnt = 5		'보여지는 페이지 간격

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
	<script src="/lib/js/swiper-1.8.min.js"></script>
	<script src="/lib/js/swiper.scrollbar-1.0.js"></script>
	<title>생활감성채널, 텐바이텐 > 이벤트 > 식수펌프 이야기 SHARING MAKES LOVE</title>
	<style type="text/css">
	.mEvt42766 img {vertical-align:top;}
	.mEvt42766 .gift {overflow:hidden;}
	.mEvt42766 .gift li {float:left; width:50%;}
	.mEvt42766 .itemSelect {overflow:hidden; background:#ddf3ff;}
	.mEvt42766 .itemSelect li {float:left; width:25%; text-align:center;}
	.mEvt42766 .itemSelect li span {display:block; padding-top:10px;}
	.mEvt42766 .cmtInput {background:#ddf3ff; padding:20px 10px 10px 10px; text-align:center;}
	.mEvt42766 .cmtInput textarea {border:2px solid #7bc1f8; color:#999;}
	.mEvt42766 .cmt01 {background:#e7e7e7 url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_item1.png) 10px 50% no-repeat;}
	.mEvt42766 .cmt02 {background:#bff2fe url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_item2.png) 10px 50% no-repeat;}
	.mEvt42766 .cmt03 {background:#ffdee7 url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_item3.png) 10px 50% no-repeat;}
	.mEvt42766 .cmt04 {background:#e9f5c9 url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_item4.png) 10px 50% no-repeat;}
	.mEvt42766 .cmtList {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_dot1.png) left top repeat-x; background-size:31px 3px; padding-top:10px; margin-top:12px; border-top:none;}
	.mEvt42766 .cmtList li {padding:10px 10px 10px 100px; margin:5px 0; background-size:80px 105px; border-bottom:none;}
	.mEvt42766 .cmtList li div {background:#fff; min-height:130px; position:relative; padding-bottom:24px;}
	.mEvt42766 .cmtList li .cmtNo {text-align:right; padding:8px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_dot2.png) left bottom repeat-x; font-weight:bold; color:#777; font-size:10px; background-size:16px 1px;}
	.mEvt42766 .cmtList li .cmtCont {padding:8px 8px 5px 8px; font-size:10px; color:#888; line-height:1.2;}
	.mEvt42766 .cmtList li .ctmBtn {padding:0 8px 5px 8px;}
	.mEvt42766 .cmtList li .cmtInfo {position:absolute; left:0; bottom:0; padding:8px; font-size:10px; color:#999;}
	.mEvt42766 .cmtList li .cmtInfo span {padding-right:7px;}
	.mEvt42766 .cmtList li .cmtInfo strong {border-right:1px solid #ccc; padding-right:8px; line-height:10px;}
	.mEvt42766 .snsWrap {background:#eff9ff url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_img4.png) 50% bottom no-repeat; background-size:100% 92px; position:relative; height:92px;}
	.mEvt42766 .snsWrap .sns {overflow:hidden; padding-left:1em;}
	.mEvt42766 .snsWrap .sns li {float:left; margin:0 5px;}
	.mEvt42766 .totalNum {background:#987c6e; text-align:center; padding-bottom:15px;}
	.mEvt42766 .total {background:#fff1e3; padding:10px 30px; border-radius:20px; width:50%; margin:15px auto 0 auto; font-size:12px;}
	.mEvt42766 .total span {display:inline-block; background:url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_img6.png) left 1px no-repeat; padding-left:18px; background-size:12px 11px;}
	.mEvt42766 .total span strong {font-weight:bold; color:#f76252;}
	.mEvt42766 .photoWrap {background:#fffcf5; padding-top:15px;}
	.mEvt42766 .photoSlide {position:relative; width:273px; margin:0 auto;}
	.mEvt42766 .photoSlide img {vertical-align:top;}
	.mEvt42766 .swiper-slide {width:267px; height:152px; float:left; overflow:hidden; padding:0;}
	.mEvt42766 .swiper-container {position:relative; overflow:hidden;}
	.mEvt42766 .swiper-main {height:152px; width:267px; position:relative; margin:0 auto; border:3px solid #7bc1f8;}
	.mEvt42766 .swiper1 {width:267px; height:152px; margin:0 auto;}
	.mEvt42766 .swiper-wrapper {position:relative;}
	.mEvt42766 .arrow-left {width:18px; height:38px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_slide_left.png) left top no-repeat; position:absolute; left:-18px; top:50%; margin-top:-19px; background-size:18px 38px;}
	.mEvt42766 .arrow-right {width:18px; height:38px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_slide_right.png) left top no-repeat; position:absolute; right:-18px; top:50%; margin-top:-19px; background-size:18px 38px;}

	@media all and (orientation:landscape){
		.mEvt42766 .cmtList li div {min-height:100px;}
	}

</style>
<script type="text/javascript">
	$(function() {
		swiper = new Swiper('.swiper1', {
			pagination : '.pagination1',
			loop:true,
			autoPlay: 3000
		});
		$('.photoSlide .arrow-left').click(function(e) {
			e.preventDefault()
			swiper.swipePrev()
    });
		$('.photoSlide .arrow-right').click(function(e) {
			e.preventDefault()
			swiper.swipeNext()
    });
	});
</script>
<script type="text/javascript">
<!--

 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function goPage(page)
	{
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
	}


	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked)){
	    alert("이미지를 선택해주세요.");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="100자 이내로 입력해주세요."){
	    alert("코멘트를 입력해주세요.");
	    document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }
	   	if(GetByteLength(frm.txtcomm.value)>200){
			alert('100자 이내로 입력해주세요.');
	    frm.txtcomm.focus();
	    return false;
		}

	   frm.action = "/event/etc/doEventSubscript42766.asp";
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
			if(document.frmcom.txtcomm.value =="100자 이내로 입력해주세요."){
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
			document.frmcom.txtcomm.value="100자 이내로 입력해주세요.";
		}
	}
	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("100자이내로 입력해주세요");
		obj.value = obj.value.substring(0,maxLength);
		}
	}

//-->
</script>
</head>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt42766">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_head.png" alt="식수펌프 이야기 SHARING MAKES LOVE" style="width:100%;" /></p>

					<div class="photoWrap">
						<div class="photoSlide"> <a class="arrow-left" href="#"></a> <a class="arrow-right" href="#"></a>
							<div class="swiper-main">
								<div class="swiper-container swiper1">
									<div class="swiper-wrapper">
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_photo1.png" alt="photo1" style="width:100%;" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_photo2.png" alt="photo2" style="width:100%;" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_photo3.png" alt="photo3" style="width:100%;" /></div>
									</div>
								</div>
							</div>
							<div class="pagination pagination1"></div>
						</div>
					</div>

					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_txt1.png" alt="깨끗한 물을 마시는 것, 우리 모두가 누려야 할 기본 권리 입니다." style="width:100%;" /></p>
					<p><a href="http://www.worldvision.or.kr/sponsor/support/foreign/water.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_btn1.png" alt="월드비전 식수사업 후원하기" style="width:100%;" /></a></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_img1.png" alt="Sharing Makes Love Item" style="width:100%;" /></p>
					<ul class="gift">
						<li><a href="/category/category_itemPrd.asp?itemid=871358" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_gift1.png" alt="cotton bag (2 type)" style="width:100%;" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=871341" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_gift2.png" alt="sticker set (2 type)" style="width:100%;" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=871349" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_gift3.png" alt="mug (2 type)" style="width:100%;" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=871304" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_gift4.png" alt="ice tumbler (2 type)" style="width:100%;" /></a></li>
					</ul>
					<p><a href="/street/street_brand.asp?makerid=circusboyband" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_btn2.png" alt="Circusboyband 브랜드 보러가기" style="width:100%;" /></a></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_img2.png" alt="마을의 식수 펌프는 이렇게 만들어져요!" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_img3.png" alt="Sharing Makes Love 응원메시지 남기고 기부하자!" style="width:100%;" /></p>
					<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="iCTot" value="">
					<input type="hidden" name="mode" value="add">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<ul class="itemSelect">
						<li>
							<p><label for="icon01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_item1.png" alt="Sharing makes Love1" style="width:100%;" /></label></p>
							<span><input type="radio" name="spoint" value="1" id="icon01" /></span>
						</li>
						<li>
							<p><label for="icon02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_item2.png" alt="Sharing makes Love2" style="width:100%;" /></label></p>
							<span><input type="radio" name="spoint" value="2" id="icon02" /></span>
						</li>
						<li>
							<p><label for="icon03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_item3.png" alt="Sharing makes Love3" style="width:100%;" /></label></p>
							<span><input type="radio" name="spoint" value="3" id="icon03" /></span>
						</li>
						<li>
							<p><label for="icon04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_item4.png" alt="Sharing makes Love4" style="width:100%;" /></label></p>
							<span><input type="radio" name="spoint" value="4" id="icon04" /></span>
						</li>
					</ul>
					<div class="cmtInput">
						<textarea name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="100자 이내로 입력해주세요." autocomplete="off" style="width:97.5%; height:80px;">100자 이내로 입력해주세요.</textarea>
					</div>
					<p class="bPad15" style="background:#ddf3ff;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_btn3.png" alt="응원메시지 등록하기" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_txt2.png" alt="ID당 1개의 응원메시지를 남길 수 있습니다." style="width:100%;" /></p>
					</form>
					<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript42766.asp" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					</form>
					<div class="snsWrap">
						<ul class="sns">
								<%
									dim snpTitle, snpLink, snpPre, snpTag, snpTag2
									snpTitle = Server.URLEncode("텐바이텐 나눔 프로젝트")
									snpLink = Server.URLEncode("http://www.10x10.co.kr/event/eventmain.asp?eventid=42765")

									'기본 태그
									snpPre = Server.URLEncode("텐바이텐")
									snpTag = Server.URLEncode("Sharing Makes Love")
									snpTag2 = Server.URLEncode("#10x10")
								%>
							<img src="http://fiximage.10x10.co.kr/m/common/sns_facebook.png" alt="페이스북 공유" onClick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','')" style="width:27px;cursor:pointer;" /></li>
							<img src="http://fiximage.10x10.co.kr/m/common/sns_twitter.png" alt="트위터 공유" onClick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>')" style="width:27px;cursor:pointer;" /></li>
							<img src="http://fiximage.10x10.co.kr/m/common/sns_me2day.png" alt="미투데이 공유" onClick="popSNSPost('m2','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag%>')" style="width:27px;cursor:pointer;" /></li>
						</ul>
					</div>
					<div class="totalNum">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42766/42766_txt3.png" alt="여러분이 작성하신 응원메시지는 1개당 100원씩 적립되어 식수사업에 기부됩니다." style="width:69%;" /></p>
						<p class="total"><span>총 <strong><%= iCTotCnt %></strong> 개의 응원메세지</span></p>
					</div>
					<% IF isArray(arrCList) THEN %>
					<ul class="cmtList">
						<% For intCLoop = 0 To UBound(arrCList,2) %>
						<li class="cmt0<%= arrCList(3,intCLoop) %>"><!-- for dev msg : 아이콘 선택시마다 클래스명 변경 -->
							<div>
								<p class="cmtNo">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
								<p class="cmtCont"><%=db2html(arrCList(1,intCLoop))%></p>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<p class="ctmBtn"><span class="btn btn5 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span></p>
								<% End If %>
								<p class="cmtInfo">
									<% If arrCList(8,intCLoop)="M" Then %>
									<span><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" alt="모바일에서 작성" width="9px" /></span><!--for dev msg : 모바일에서 작성시 노출 -->
									<% End If %>
									<span><strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong></span>
									<span><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%></span>
								</p>
							</div>
						</li>
						<% next %>

					</ul>
						<div style="padding-top:10px;">
							<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
						</div>
					<% End If %>
				</div>
			</div>
			<!-- //content area -->
<!-- #include virtual="/lib/db/dbclose.asp" -->