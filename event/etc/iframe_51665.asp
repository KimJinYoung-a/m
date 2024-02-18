<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/event49651Cls.asp" -->
<%
'----------------------------------------------------
' ClsEvtBBS : 이벤트 코멘트
'----------------------------------------------------
Class ClsEvtComment

	public FECode   '이벤트 코드
	public FEBidx   '이벤트 게시판 코드
	public FCPage	'Set 현재 페이지
 	public FPSize	'Set 페이지 사이즈
 	public FTotCnt	'Get 전체 레코드 갯수
 	public FComGroupCode	'이벤트구분 그룹코드(소풍가는 길 회차)
 	public Fblogurl

 	public FGubun
 	public FUserID
 	public FCommentTxt
 	public FResult

	public Function fnGetComment
		Dim strSql, arrList
		IF FEBidx = "" THEN FEBidx =0
		IF FComGroupCode = "" THEN FComGroupCode = 0
		strSql ="[db_etcmall].[dbo].sp_Between_event_comment ("&FECode&",'"&FComGroupCode&"',"&FEBidx&","&FCPage&","&FPSize&","&FTotCnt&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrList = rsget.GetRows()
			IF isNull(arrList(0,0)) THEN
				FTotCnt = 0
				rsget.close
				Exit Function
			END IF
			FTotCnt = arrList(5,0)
			fnGetComment = arrList
		END IF
		rsget.close
	End Function

	public Function fnGetCommentUpdate
		Dim strSql
		strSql ="[db_etcmall].[dbo].sp_Between_event_comment_update ('"&FGubun&"','"&FUserID&"','"&FEBidx&"','"&FCommentTxt&"')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FResult = rsget(0)
			ELSE
				FResult = null
			END IF
		rsget.close
	End Function
End Class



Dim UsName, UsPhone, vtQuery, vUserID, DvClsNameRnd

vUserID = GetLoginUserID

If IsUserLoginOK Then

	vtQuery = "SELECT username, usercell From db_user.dbo.tbl_user_n Where userid='"&vUserID&"' "
	vtQuery = vtQuery & "  "
	rsget.Open vtQuery, dbget, 1
	If Not rsget.Eof Then
		UsName = rsget("username")
		UsPhone = rsget("usercell")
	End If	
	rsget.close()

End If

Dim eCode, couponCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21166
	couponCode = 327
Else
	eCode   =  51665
	couponCode = 591
End If

dim cEComment ,blnFull, cdl_e, com_egCode, bidx, blnBlogURL, strBlogURL, LinkEvtCode
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt

	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	'eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	LinkEvtCode		= requestCheckVar(Request("linkevt"),10) '관련 이벤트 코드번호(온라인 메인 이벤트 코드)
	cdl_e			= requestCheckVar(Request("cdl_e"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL		= requestCheckVar(Request("blnB"),10)

	If eCode = "" Then
		Response.Write "<script>alert('올바른 접근이 아닙니다.');window.close();</script>"
		dbget.close()
		Response.End
	End If

	IF blnFull = "" THEN blnFull = True
	IF blnBlogURL = "" THEN blnBlogURL = False

	IF iCCurrpage = "" THEN
		iCCurrpage = 1
	END IF
	IF iCTotCnt = "" THEN
		iCTotCnt = -1
	END IF
	IF LinkEvtCode = "" THEN
		LinkEvtCode = 0
	END IF

	iCPerCnt = 10		'보여지는 페이지 간격
	iCPageSize = 10		'한 페이지의 보여지는 열의 수

	'데이터 가져오기
	set cEComment = new ClsEvtComment

	if LinkEvtCode>0 then
		cEComment.FECode 		= LinkEvtCode
	else
		cEComment.FECode 		= eCode
	end if
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

	dim nextCnt		'다음페이지 게시물 수
	if (iCTotCnt-(iCPageSize*iCCurrpage)) < iCPageSize then
		nextCnt = (iCTotCnt-(iCPageSize*iCCurrpage))
	else
		nextCnt = iCPageSize
	end if
%>
<head>
<title>생활감성채널, 텐바이텐 > 이벤트 > 넌, 나에게 GIFT를 줬어!</title>
<style type="text/css">
.mEvt51665 {position:relative;}
.mEvt51665 p {max-width:100%;}
.mEvt51665 img {vertical-align:top; width:100%;}
.mEvt51665 .evtBtnArea {overflow:hidden; _zoom:1; background-color:#ff8888;}
.mEvt51665 .evtBtnArea li {float:left; width:33.125%;}
.mEvt51665 .evtArea {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_bg2.png) 0 0 repeat-y; background-size:100%; padding:0 1em;}
.mEvt51665 .evtBox {padding:1em;}
.mEvt51665 .evtBox textarea {height:80px; background-color:#e5e5e5; padding:0.5em; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box; font-size:12px; color:#000;}
.mEvt51665 .evtAgree {text-align:center; color:#878787; font-size:12px; padding:0.5em 0;}
.mEvt51665 .notiBox {background-color:#fff4d1; padding:1em 0;}
.mEvt51665 .notiBox ul {padding:0.2em 1em;}
.mEvt51665 .notiBox li {padding:0 0 0.5em 1em; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_blt.png) 0 5px no-repeat; background-size:6px 4px; color:#777; font-weight:bold; font-size:10px; line-height:12px;}
.mEvt51665 .evtInputArea {padding:1em 1em 0 1em; overflow:hidden; _zoom:1; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt51665 .evtInputArea dt {height:22px; padding-bottom:5px;}
.mEvt51665 .evtInputArea dt img {width:98px; height:22px}
.mEvt51665 .evtInputArea dd input[type=text], .mEvt51665 .evtInputArea dd input[type=number] {border:2px solid #ffa8a8; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box; font-size:18px; color:#333; padding:10px 5px; text-align:center; height:36px;}
.mEvt51665 .evtCmtArea {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_bg4.png) 0 0 repeat-y; background-size:100%;}
.mEvt51665 .evtCmtBox {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_bg5.png) 0 100% no-repeat; background-size:100%; padding-bottom:30px;}
.mEvt51665 .evtCmtList {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_bg3.png) 0 0 no-repeat; background-size:100%; padding:30px 8px 15px 8px; overflow:hidden; _zoom:1;}
.mEvt51665 .evtCmtList li {float:left; position:relative; width:50%; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box; padding:17px 7px 7px 7px;}
.mEvt51665 .evtCmtList li .deleteBtn {position:absolute; right:7px; top:0; width:22px; height:19px; border-top-left-radius:11px; border-top-right-radius:11px; -webkit-border-top-left-radius:11px; -webkit-border-top-right-radius:11px; font-size:18px; color:#fff; text-align:center;}
.mEvt51665 .evtCmtList li > div {background-color:#fff; padding:0.5em; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; -webkit-border-radius:3px; border-radius:3px;}
.mEvt51665 .evtCmtList li > div .cont {background-size:54px; background-repeat:no-repeat; background-position:0 10px; padding:7px 0 10px 59px; font-size:10px; line-height:12px; height:75px; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box; letter-spacing:-0.04em;}
.mEvt51665 .evtCmtList li.type01 > div {border:3px solid #ff8888;}
.mEvt51665 .evtCmtList li.type02 > div {border:3px solid #4ed1ca;}
.mEvt51665 .evtCmtList li.type01 .cont {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_cmt1.png);}
.mEvt51665 .evtCmtList li.type02 .cont {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_cmt2.png);}
.mEvt51665 .evtCmtList li.type01 .deleteBtn {background-color:#ff8888;}
.mEvt51665 .evtCmtList li.type02 .deleteBtn {background-color:#4ed1ca;}
.mEvt51665 .swiperWrap {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_bg1.png) 0 0 no-repeat; background-size:100%; padding:14px 25px 10px 25px; position:relative;}
.mEvt51665 .swiperBox {width:268px; height:175px; margin:0 auto; position:relative; padding-bottom:30px; overflow:hidden;}
.mEvt51665 .swiperWrap .swiper-container {width:268px; height:175px; margin:0 auto; overflow:hidden; padding-bottom:30px;}
.mEvt51665 .swiperWrap .swiper-wrapper {width:268px; height:175px; margin:0 auto; overflow:hidden;}
.mEvt51665 .swiperWrap .swiper-slide {float:left; width:268px; height:175px; overflow:hidden;}
.mEvt51665 .swiperWrap .swiper-slide img {float:left;}
.mEvt51665 .btnArrow {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide_navi.png); background-repeat:no-repeat; position:absolute; top:50%; margin-top:-28px; background-size:268px auto; width:20px; height:28px; text-indent:-9999em; overflow:hidden;tjs}
.mEvt51665 .arrow-left {background-position:left top; left:0;}
.mEvt51665 .arrow-right {background-position:right top; right:0;}
.mEvt51665 .pagination {position:absolute; top:185px; left:0; text-align:center; z-index:100; width:100%; height:12px;}
.mEvt51665 .pagination .swiper-pagination-switch {margin:0 2px; display:inline-block; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide_page.png); background-repeat:no-repeat; width:12px; height:12px; background-position:-23px top; background-size:34px auto;}
.mEvt51665 .pagination .swiper-active-switch {background-position:left top;}

@media all and (min-width:480px){
	.mEvt51665 .evtBox textarea {height:120px; font-size:15px;}
	.mEvt51665 .evtAgree {font-size:15px;}
	.mEvt51665 .evtInputArea {padding:2em 1em 0.5em 1em;}
	.mEvt51665 .evtInputArea dt {height:33px; padding-bottom:10px;}
	.mEvt51665 .evtInputArea dt img {width:147px; height:33px}
	.mEvt51665 .evtInputArea dd input[type=text] {border:3px solid #ffa8a8; font-size:25px; color:#333; padding:10px 5px; text-align:center; height:48px;}
	.mEvt51665 .evtCmtBox {padding-bottom:40px;}
	.mEvt51665 .evtCmtList {padding:40px 10px 20px 10px;}
	.mEvt51665 .evtCmtList li > div {padding:1em;}
	.mEvt51665 .evtCmtList li > div .cont {background-size:81px; background-position:0 15px; padding:15px 0 15px 90px; font-size:14px; line-height:16px; height:95px;}
	.mEvt51665 .evtCmtList li {padding:22px 7px 15px 7px;}
	.mEvt51665 .evtCmtList li .deleteBtn {width:33px; height:25px; border-top-left-radius:16px; border-top-right-radius:16px; -webkit-border-top-left-radius:16px; -webkit-border-top-right-radius:16px; font-size:20px;}
	.mEvt51665 .evtArea {padding:0 2.75em;}
	.mEvt51665 .notiBox ul {padding:0.3em 1.5em;}
	.mEvt51665 .notiBox li {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_blt.png) 0 7px no-repeat; background-size:9px 6px; font-size:15px; line-height:18px;}
	.mEvt51665 .swiperWrap {padding:21px 38px 15px 38px;}
	.mEvt51665 .swiperBox {width:402px; height:262px; padding-bottom:45px;}
	.mEvt51665 .swiperWrap .swiper-container {width:402px; height:262px; padding-bottom:45px;}
	.mEvt51665 .swiperWrap .swiper-wrapper {width:402px; height:262px;}
	.mEvt51665 .swiperWrap .swiper-slide {width:402px; height:262px;}
	.mEvt51665 .btnArrow {margin-top:-42px; background-size:402px auto; width:30px; height:42px;}
	.mEvt51665 .pagination {top:275px; height:18px;}
	.mEvt51665 .pagination .swiper-pagination-switch {margin:0 5px; width:18px; height:18px; background-position:-34px top; background-size:51px auto;}
	.mEvt51665 .pagination .swiper-active-switch {background-position:left top;}
}

/* paging */
.paging {width:100%; text-align:center;}
.paging a {display:inline-block; width:38px; height:38px; border:1px solid #ddd;  text-decoration:none; background-color:#fff; font-size:13px; margin:0 3px; font-weight:bold;}
.paging a span {display:table-cell; width:38px; height:38px; vertical-align:middle; color:#888;}
.paging a.arrow {background-color:#ccc; border:1px solid #ccc;}
.paging a.current span {background-color:#f0f0f0; color:#444;}
.paging a span.elmBg {text-indent:-9999px; overflow:hidden;}
.paging a span.prev {background-position:-281px -154px;}
.paging a span.next {background-position:-229px -154px;}
.elmBg {background-image:url(http://fiximage.10x10.co.kr/m/2013/common/element01.png); background-repeat:no-repeat; background-size:400px 400px;}
</style>
<script src="/lib/js/swiper-2.1.min.js"></script>
<script type="text/javascript">
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}
	 	function jsGoPage(iP){
			document.frmSC.iC.value = iP;
			document.frmSC.submit();
		}
	function goPage(page)
	{
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){

	<% If getnowdate>="2014-05-09" and getnowdate<="2014-05-18" Then %>

	   if(!frm.txtcomm.value||frm.txtcomm.value=="상품명과 이유를 30자 미만으로 적어주세요."){
	    alert("코멘트를 입력해주세요");
	    frm.txtcomm.focus();
	    document.frmcom.txtcomm.value="";
	    return false;
	   }
	   if(GetByteLength(frm.txtcomm.value)>60){
		alert('문구 입력은 한글 최대 30자 까지 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}
	<% if IsUserLoginOK then %>
	<% else %>
	  if(frm.usrname.value=="")
	  {
		alert('이름을 입력해주세요.');
		frm.usrname.focus();
		return false;
	  }
	  if(frm.usrphone.value=="")
	  {
		alert('휴대폰번호를 입력해주세요.');
		frm.usrphone.focus();
		return false;
	  }
	  if($(':radio[name="priAgree"]:checked').val()!="1")
	  {
		alert('개인정보 수집 및 이용 안내에 동의해\n주셔야 이벤트 참여가 가능합니다.');
		return false;
	  }
	<% end if %>
	   frm.action = "/event/etc/doEventSubscript51665.asp";
	   frm.submit();

		<% else %>
			alert('이벤트 응모기간이 아닙니다.');
			return false;
		<% end if %>

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
			if(document.frmcom.txtcomm.value =="상품명과 이유를 30자 미만으로 적어주세요."){
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
			document.frmcom.txtcomm.value="상품명과 이유를 30자 미만으로 적어주세요.";
		}
	}

	function jsChkLength()
	{
		if (GetByteLength(document.frmcom.txtcomm.value) > 60)
		{
			alert('문구 입력은 한글 최대 30자 까지 가능합니다.');
		    document.frmcom.txtcomm.focus();
		    return false;
		}
	}

	$(function(){
		showSwiper= new Swiper('.specialSwiper',{
			loop:true,
			resizeReInit:true,
			calculateHeight:true,
			pagination:'.pagination',
			paginationClickable:true,
			speed:300,
			autoplay:3000
		});
		$('.arrow-left').on('click', function(e){
			e.preventDefault()
			showSwiper.swipePrev()
		})
		$('.arrow-right').on('click', function(e){
			e.preventDefault()
			showSwiper.swipeNext()
		});
		//화면 회전시 리드로잉(지연 실행)
		$(window).on("orientationchange",function(){
			var oTm = setInterval(function () {
				showSwiper.reInit();
					clearInterval(oTm);
				}, 1);
		});
	});


</script>


<body>
<!-- content area -->
	<div class="mEvt51665">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_head.png" alt="텐바이텐&amp;비트윈 GIFT SHOP OPEN!" /></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_tit.png" alt="넌, 나에게 GIFT를 줬어!" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_txt1.png" alt="이벤트 기간 : 05.12 ~ 05.18 | 당첨자 발표 : 05.29" /></p>
		<div class="swiperWrap">
			<div class="swiperBox">
				<div class="swiper-container specialSwiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide1.png" alt="" /></div>
						<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=1053097"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide2.png" alt="" /></a></div>
						<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=1052165"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide3.png" alt="" /></a></div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1028512"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide41.png" alt="" style="width:50%;" /></a>
							<a href="/category/category_itemPrd.asp?itemid=1028510"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide42.png" alt="" style="width:50%;" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1043157"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide51.png" alt="" style="width:50%;" /></a>
							<a href="/category/category_itemPrd.asp?itemid=1043160"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide52.png" alt="" style="width:50%;" /></a>
						</div>
						<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=950094"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_slide6.png" alt="" /></a></div>
					</div>
					<div class="pagination"></div>
				</div>
				<a class="btnArrow arrow-left" href="">이전</a>
				<a class="btnArrow arrow-right" href="">다음</a>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_txt2.png" alt="댓글을 남겨주신 분들 중 추첨을 통해, 총 30분께 드려요!" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_txt3.png" alt="잠깐! 혹시 텐바이텐 회원이신가요?" /></p>
		<ul class="evtBtnArea">
			<li><a href="/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=eCode%>" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_btn01.png" alt="로그인 하러가기" /></a></li>
			<li style="width:33.75%"><a href="/member/join.asp" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_btn02.png" alt="회원가입 하러가기" /></a></li>
			<li><a href="#inputarea"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_btn03.png" alt="비회원으로 참여하기" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_txt4.png" alt="이름과 휴대폰 번호를 입력하신 후, 비트윈 기프트 샵 기획전에서 마음에 드는 아이템과 이유를 남겨주세요!" /></p>
		<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="cpcode" value="<%=couponCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<a name="inputarea">
		<div class="evtArea">
			<div class="evtInputArea">
				<dl class="ftLt" style="width:37%">
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_subtit1.png" alt="01. 이름" /></dt>
					<dd><input type="text" name="usrname" id="usrname" value="<%=UsName%>" style="width:100%;" maxlength="8"/></dd>
				</dl>
				<dl class="ftRt" style="width:57%">
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_subtit2.png" alt="02. 휴대폰 번호" /></dt>
					<dd><input type="text" name="usrphone" id="usrphone" value="<%=UsPhone%>" style="width:100%;" maxlength="15" /></dd>
				</dl>
			</div>
			<div class="evtBox">
				<p><textarea style="width:100%" name="txtcomm" id="txtcomm" onClick="jsChklogin11('True');" onfocus="jsChklogin11('True');" onblur="jsChkUnblur()" onKeyup="jsChkLength();">상품명과 이유를 30자 미만으로 적어주세요.</textarea></p>
				<% If IsUserLoginOK Then %>

				<% Else %>
					<p class="evtAgree"><input type="radio" name="priAgree" id="priAgree" class="rMar05" value="1" /><label for="priAgree">개인정보 수집 및 이용 안내에 동의합니다.</label></p>
				<% End If %>
			</div>
		</div>
		<p><a href="javascript:jsSubmitComment(document.frmcom);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_btn04.png" alt="응모하기" /></a></p>
		</form>
		<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript51665.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="cpcode" value="<%=couponCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>

		<div class="evtCmtArea">
			<div class="evtCmtBox">
				<% IF isArray(arrCList) THEN %>
				<ul class="evtCmtList">
					<% For intCLoop = 0 To UBound(arrCList,2)%>
					<%
						Randomize()
						DvClsNameRnd = Int((Rnd*2)+1)
					%>
						<li class="type0<%=DvClsNameRnd%>">
							<div>
								<p class="overHidden ftSmall c666 btmDotBdr inner5">
									<span class="ftLt">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
									<span class="ftRt"><%=printUserId(arrCList(9,intCLoop),1,"*")%></span>
								</p>
								<div class="cont">
									<%=nl2br(arrCList(1,intCLoop))%>
								</div>
							</div>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<span class="deleteBtn" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>')">&times;</span>
							<% End If %>
						</li>
					<% Next %>
				</ul>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
				<% End If %>
			</div>
		</div>
		<div class="notiBox">
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_subtit3.png" alt="이벤트 내용" /></dt>
				<dd>
					<ul>
						<li>본 이벤트는 비트윈 사용자면 누구나 참여 가능합니다.</li>
						<li>로그인 시, ID 당 총 3회 응모 가능합니다.</li>
						<li>로그인 후, 이벤트 참여시 당첨 확률이 더 올라갑니다.</li>
						<li>당첨자 발표는 5월 29일 비트윈 기프티샵 공지 사항과 텐바이텐 공지 사항 모두에서 확인 가능합니다.</li>
					</ul>
				</dd>
			</dl>
			<dl <% If IsUserLoginOK Then %>style="display:none;"<% End If %>>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_subtit4.png" alt="개인정보 수집 안내" /></dt>
				<dd>
					<ul>
						<li>이벤트 당첨자 확인을 위해 이름과 휴대폰 번호를 수집합니다.</li>
						<li>수집 동의를 하셔야만 이벤트 참여가 가능합니다.</li>
						<li>개인정보를 텐바이텐과 비트윈 외, 타사에 제공하지 않으며, 이벤트 종료 후, 수집한 개인정보는 파기합니다.</li>
					</ul>
				</dd>
			</dl>
		</div>
	</div>
<!-- //content area -->
</body>
</html>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->