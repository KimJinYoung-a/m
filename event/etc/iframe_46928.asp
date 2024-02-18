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
	eCode   =  21008
Else
	eCode   =  46778
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
<title>생활감성채널, 텐바이텐 > 이벤트 > EVERYDAY WATERFUL CHRISTMAS!</title>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
<script type="text/javascript">
$(function(){
	$('.replySlide').slidesjs({
		width: 960,
		height: 482,
		navigation: {
			effect: "fade"
		},
		pagination: {
			effect: "fade"
		},
		play: {
			interval:3000,
			effect: "fade",
			auto: true,
			swap: false
		},
		effect: {
			fade: {
				speed:1000,
				crossfade: true
			}
		}
	});
});

<!--
 	function jsGoComPage(iP){
		location.href="/event/etc/iframe_46928.asp?iCC="+iP;
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
	    alert("이미지를 선택해주세요");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="<응답하라 1994>에 대한 응원글을 남겨주세요! (최대100자)"){
	    alert("코멘트를 입력해주세요");
	    document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }
	   	if(GetByteLength(frm.txtcomm.value)>200){
			alert('최대 한글 100자 까지 입력 가능합니다.');
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
			if(document.frmcom.txtcomm.value =="<응답하라 1994>에 대한 응원글을 남겨주세요! (최대100자)"){
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
			document.frmcom.txtcomm.value="<응답하라 1994>에 대한 응원글을 남겨주세요! (최대100자)";
		}
	}
	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 최대 100자 입니다.");
		obj.value = obj.value.substring(0,maxLength); //100자 이하 튕기기
		}
	}

//-->
</script>
<style type="text/css">
.mEvt46928 {}
.mEvt46928 img {vertical-align:top;}
.mEvt46928 .replyPrd {position:relative;}
.mEvt46928 .replyPrd ul {position:absolute; left:0; top:0; z-index:10; overflow:hidden; padding:0 6%; width:88%;}
.mEvt46928 .replyPrd li {float:left; width:33%;}
.mEvt46928 .replySlide {position:relative; overflow:visible !important; background:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_bg03.png) left top no-repeat; background-size:100% 100%;}
.mEvt46928 .replySlide .slidesjs-navigation {position:absolute; top:50%; z-index:100; display:block; width:15px; height:18px; margin-top:-8px; text-indent:-9999px; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
.mEvt46928 .replySlide .slidesjs-previous {left:6%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_btn_prev.png);}
.mEvt46928 .replySlide .slidesjs-next {right:6%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_btn_next.png);}
.mEvt46928 .replySlide .slidesjs-pagination {overflow:hidden; position:absolute; left:50%; bottom:-7%; width:130px; margin-left:-65px; z-index:100;}
.mEvt46928 .replySlide .slidesjs-pagination li {float:left; width:8px; padding:0 4px; text-align:center;}
.mEvt46928 .replySlide .slidesjs-pagination li a {display:block; width:8px; height:8px; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_pagination_off.png) left top no-repeat; background-size:100% 100%;}
.mEvt46928 .replySlide .slidesjs-pagination li a.active {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_pagination_on.png);}

.mEvt46928 .reply1994Cmt {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_bg02.png) left top repeat-y; background-size:100% auto;}
.mEvt46928 .reply1994Cmt .character {overflow:hidden; margin:0 2%;}
.mEvt46928 .reply1994Cmt .character li {float:left; width:25%; text-align:center;}
.mEvt46928 .reply1994Cmt .character li label {display:block; margin:6px 2px 0;}
.mEvt46928 .reply1994Cmt .character li input {margin-right:4%;}
.mEvt46928 .reply1994Cmt .writeCmt {overflow:hidden; width:94%; margin:0 auto; padding-top:18px;}
.mEvt46928 .reply1994Cmt .writeCmt .tBox {padding:10px 5px; border:4px solid #31a952; border-bottom:0; background:#fff;}
.mEvt46928 .reply1994Cmt .writeCmt textarea {width:100%; height:58px; overflow:hidden; font-size:11px;  color:#888; overflow:hidden; text-align:left; border:0;}
.mEvt46928 .reply1994Cmt .enroll {width:100%;}
.mEvt46928 .reply1994Cmt .enroll input { -webkit-border-radius:0; -webkit-appearance:none;}
.mEvt46928 .reply1994Cmt .first {padding-bottom:15px;}
.mEvt46928 .reply1994Cmt .first li:first-child {padding-left:12%;}

.mEvt46928 .reply1994List {overflow:hidden; width:100%;}
.mEvt46928 .reply1994List .list {overflow:hidden; padding:28px 10px 30px;}
.mEvt46928 .reply1994List li {position:relative; margin-top:18px; font-size:11px; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
.mEvt46928 .reply1994List li:first-child {margin-top:0;}
.mEvt46928 .reply1994List li .num {position:absolute; left:5%; top:6%; color:#fff;}
.mEvt46928 .reply1994List li .txt {position:absolute; left:5%; top:24%; width:90%; line-height:17px;  color:#616161; word-break:break-all;}
.mEvt46928 .reply1994List li .txt .btn {margin-top:-3px;}
.mEvt46928 .reply1994List li .writerInfo {position:absolute; right:5%; bottom:10%; overflow:hidden; font-size:11px; line-height:15px; }
.mEvt46928 .reply1994List li .writerInfo p {float:left; padding-right:10px;}
.mEvt46928 .reply1994List li .writerInfo .userId {font-weight:bold; color:#9a9a9a;}
.mEvt46928 .reply1994List li .writerInfo .date {padding:0 0 0 10px; color:#616161; background:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_bar.png) left center no-repeat; background-size:1px 5px;}
.mEvt46928 .reply1994List li.c01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_my_character01.png);}
.mEvt46928 .reply1994List li.c02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_my_character02.png);}
.mEvt46928 .reply1994List li.c03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_my_character03.png);}
.mEvt46928 .reply1994List li.c04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_my_character04.png);}
.mEvt46928 .reply1994List li.c05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_my_character05.png);}
.mEvt46928 .reply1994List li.c06 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_my_character06.png);}
.mEvt46928 .reply1994List li.c07 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_my_character07.png);}
</style>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt46928">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_head.png" alt="응답하라1994 공식MD 사전판매" style="width:100%;" /></div>
					<div class="replyPrd">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_bg01.png" alt="" style="width:100%;" /></p>
						<ul>
							<li><a href="/category/category_itemPrd.asp?itemid=961864" target="_top" ><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_product01.png" alt="까리뽕삼 문구세트" style="width:100%;" /></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=961865" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_product02.png" alt="꼽나? 유에스비" style="width:100%;" /></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=961866" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_product03.png" alt="스페이스 티셔츠" style="width:100%;" /></a></li>
						</ul>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_img01.png" alt="응답하라1994 공식MD 상품 미리보기" style="width:100%;" /></p>
					<div class="prdPreview">
						<div class="replySlide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_mdprd01.png" alt="응답하라1994 공식MD 상품 이미지" style="width:100%;" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_mdprd02.png" alt="응답하라1994 공식MD 상품 이미지" style="width:100%;" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_mdprd03.png" alt="응답하라1994 공식MD 상품 이미지" style="width:100%;" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_mdprd04.png" alt="응답하라1994 공식MD 상품 이미지" style="width:100%;" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_mdprd05.png" alt="응답하라1994 공식MD 상품 이미지" style="width:100%;" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_mdprd06.png" alt="응답하라1994 공식MD 상품 이미지" style="width:100%;" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_mdprd07.png" alt="응답하라1994 공식MD 상품 이미지" style="width:100%;" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_mdprd08.png" alt="응답하라1994 공식MD 상품 이미지" style="width:100%;" />
						</div>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_img02.png" alt="" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_img03.png" alt="COMMENT EVENT" style="width:100%;" /></p>
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<div class="reply1994Cmt">
						<!-- 캐릭터 선택 -->
						<ul class="character first">
							<li>
								<input type="radio" name="spoint" value="1" id="reply01" />
								<label for="reply01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_character01.png" alt="성나정" style="width:100%;" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="2" id="reply02" />
								<label for="reply02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_character02.png" alt="쓰레기" style="width:100%;" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="3" id="reply03" />
								<label for="reply03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_character03.png" alt="칠봉이" style="width:100%;" /></label>
							</li>
						</ul>
						<ul class="character">
							<li>
								<input type="radio" name="spoint" value="4" id="reply04" />
								<label for="reply04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_character04.png" alt="삼천포" style="width:100%;" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="5" id="reply05" />
								<label for="reply05"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_character05.png" alt="해태" style="width:100%;" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="6" id="reply06" />
								<label for="reply06"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_character06.png" alt="빙그레" style="width:100%;" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="7" id="reply07" />
								<label for="reply07"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_character07.png" alt="조윤진" style="width:100%;" /></label>
							</li>
						</ul>

						<!-- 코멘트 작성 -->
						<div class="writeCmt">
							<p class="tBox"><textarea cols="130" rows="5" name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="<응답하라 1994>에 대한 응원글을 남겨주세요! (최대100자)" autocomplete="off">&lt;응답하라 1994&gt;에 대한 응원글을 남겨주세요! (최대100자)</textarea></p>
							<p class="enroll"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_btn_enroll.png" alt="등록하기" style="width:100%;" /></p>
						</div>
					</div>
				</form>
				<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript46928.asp" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				</form>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_img04.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다." style="width:100%;" /></p>

					<!-- 코멘트 리스트 -->
					<a name="rank" id="rank"></a>
					<div class="reply1994List">
						<ul class="list">
						<% IF isArray(arrCList) THEN %>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li class="c0<%= arrCList(3,intCLoop) %>">
								<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
								<p class="txt"><%=db2html(arrCList(1,intCLoop))%>&nbsp; <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %><span class="btn btn6 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span><% End If %></p>
								<div class="writerInfo">
									<p class="userId"><% If arrCList(8,intCLoop)="M" Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" width="9px" alt="모바일에서 작성" /><% End IF %> <%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
									<p class="date"><%=FormatDate(arrCList(4,intCloop),"0000.00.00")%></p>
								</div>
								<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46928/46928_cmt_blank.png" alt="" style="width:100%;" /></p>
							</li>
							<% next %>
						<% End If %>
						</ul>
					</div>
					<!--// 코멘트 리스트 -->

					<div class="paging">
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
					</div>
				</div>
			</div>
			<!-- //content area -->

</body>
</html>