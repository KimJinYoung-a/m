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
' PLAY #21 T-SHIRT_좋은 것, 좋은 것. 좋아하는 것!
' 2015-06-12 원승현 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  63789
Else
	eCode   =  63687
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, iColorVal, eCC

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	iColorVal = 1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
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

<style type="text/css">
img {vertical-align:top;}
.swiper {position:relative; overflow:hidden;}
.swiper .swiper-container {width:100%;}
.swiper .swiper-slide {overflow:hidden;}
.swiper .swiper-slide p {position:absolute; left:0; top:10px; opacity:0; width:100%;}
.swiper .numbering {position:absolute; left:0; bottom:8.5%; width:100%; text-align:center;}
.swiper .numbering span {display:inline-block; width:8px; height:8px; margin:0 8px; border:1px solid #000; background:#fff; border-radius:50%;}
.swiper .numbering span.swiper-active-switch {background:#000;}
.aboutLazyOwl {position:relative;}
.aboutLazyOwl a {display:none; position:absolute; left:23%; bottom:14%; width:54%; height:21%; color:transparent;}
.goApply {position:relative;}
.goApply a {display:block; position:absolute; left:32%; top:7%; width:36%; height:71%; color:transparent;}
.myFavorWrite .writeCont {padding:30px 0; text-align:center; background:#f4e1be;}
.myFavorWrite .writeCont strong {display:block; font-size:16px;}
.myFavorWrite .writeCont span {display:block; width:68%; padding:8px 0; margin:10px auto; background:#fff; box-shadow:0px 0px 3px 0px #f4c979;}
.myFavorWrite .writeCont span input {width:90%; height:25px;  color:#ff833f; font-size:18px; font-weight:bold; text-align:center; border:0; border-bottom:2px solid #000; border-radius:0;}
.myFavorWrite .writeCont .btnApply {width:82%; margin:20px auto 0;}
.myFavorWrite .writeCont .btnApply input {width:100%;}
.myFavorList {padding-top:20px;}
.myFavorList ul {overflow:hidden; padding:0 3%;}
.myFavorList li {float:left; width:50%; padding:0 3%; margin-bottom:20px; font-size:12px; color:#000;}
.myFavorList li .num {line-height:1; padding-left:5%; padding-bottom:5px;}
.myFavorList li .noteCont {position:relative;  background-repeat:no-repeat; background-position:0 0; background-size:100% 100%;}
.myFavorList li .noteCont p {position:absolute;}
.myFavorList li .noteCont p.favor {left:13.5%; top:45%; font-size:13px; line-height:1; font-weight:bold; letter-spacing:-0.025em;}
.myFavorList li .noteCont p.writer {right:13.5%; bottom:7%;}
.myFavorList li.note01 .noteCont {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150615/bg_cmt01.gif);}
.myFavorList li.note02 .noteCont {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150615/bg_cmt02.gif);}
.myFavorList li.note03 .noteCont {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150615/bg_cmt03.gif);}

@media all and (min-width:480px){
	.swiper .swiper-slide p {top:15px;}
	.swiper .numbering span {width:12px; height:12px; margin:0 12px;}
	.myFavorWrite .writeCont {padding:45px 0;}
	.myFavorWrite .writeCont strong {font-size:24px;}
	.myFavorWrite .writeCont span {padding:12px 0; margin:15px auto;}
	.myFavorWrite .writeCont span input {height:38px; font-size:24px;}
	.myFavorWrite .writeCont .btnApply {margin:25px auto 0;}
	.myFavorList {padding-top:25px;}
	.myFavorList li {margin-bottom:25px; font-size:18px;}
	.myFavorList li .num {padding-bottom:7px;}
	.myFavorList li .noteCont p.favor {font-size:20px;}
}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javascript">
	$(function(){
		mySwiper = new Swiper('.swiper1',{
			loop:true,
			resizeReInit:true,
			calculateHeight:true,
			pagination:'.numbering',
			speed:600,
			autoplay:false,
			autoplayDisableOnInteraction: true,
			onSlideChangeStart: function(swiper){
				$('.swiper-slide').find('p').delay(100).animate({top:'10px',opacity:'0'},300);
				$('.swiper-slide-active').find('p').delay(50).animate({top:'0',opacity:'1'},800);
			}
		});

		$('.swiper-slide-active').find('p').delay(100).animate({top:'0',opacity:'1'},1000);

		$(".goApply a").click(function(event){
			event.preventDefault();
			window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
		});
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$(".ma").show();
			$(".mw").hide();
		}else{
			$(".ma").hide();
			$(".mw").show();
		}

	<% if Request("iCC")<>"" or Request("eCC")<>"" then %>
		window.parent.$('html,body').animate({scrollTop:$('.myFavorList').offset().top}, 300);
	<% end if %>

	});

 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>

	   
	    if(!frm.qtext1.value || frm.qtext1.value == "10자 이내" ){
	    alert("내용을 입력해주세요.");
		document.frmcom.qtext1.value="";
	    frm.qtext1.focus();
	    return false;
	   }

	   frm.action = "/play/groundcnt/doEventSubscript63687.asp";
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
			if(document.frmcom.qtext1.value =="10자 이내"){
				document.frmcom.qtext1.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

//-->
</script>
</head>
<body>

<div class="mPlay20150615">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/tit_like_thing.jpg" alt="좋은것,좋은것. 좋아하는것!" /></h2>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/txt_make_shirt.jpg" alt="내가 좋아하는 것을 담은 티셔츠를 만들어 보세요!" /></p>
	<div class="goApply">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/btn_go_apply.jpg" alt="" /></p>
		<a href="#myFavorWrite">브랜드 바로가기</a>
	</div>
	<div class="swiper">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/txt_like_lazyowl.gif" alt="레이지아울이 좋아하는 것" /></h3>
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/img_slide01.jpg" alt="01.OWL" /></div>
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/txt_slide01.png" alt="부엉이는 나라마다 조금씩 다르긴 하지만 지혜와 부, 복을 상징하는 동물이에요. 좋은 의미뿐 아니라 신비한 눈동자, 귀여운 몸짓과 생김새가 저의 마음을 사로잡았죠. " /></p>
				</div>
				<div class="swiper-slide">
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/img_slide02.jpg" alt="02.FLAMINGO" /></div>
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/txt_slide02.png" alt="개인적으로 트로피컬한 원색적인 느낌을 내는 앵무새나 플라밍고를 좋아해요. 화려하고 신비로운 느낌의 컬러의 새들을 그리고 있으면 마치 여행을 하는 것처럼 기분도 좋아져요." /></p>
				</div>
				<div class="swiper-slide">
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/img_slide03.jpg" alt="03.HEART" /></div>
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/txt_slide03.png" alt="부엉이 얼굴이 하트 모양 같다는 생각을 하게 되었어요. 남자친구가 눈을 가려보면 어떻겠냐는 아이디어를 주어서 이렇게 발전하게 되었죠. 하트와 남자친구의 의견이 더해져서 만들어진 Blind my mind! 그래서 더 애착이 가요." /></p>
				</div>
			</div>
			<div class="numbering"></div>
		</div>
	</div>
	<div class="aboutLazyOwl">
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/txt_about_brand2.gif" alt="LAZY OWL은 직접 쓴 손글씨, 그림과 같은 아날로그 감성을 바탕으로 사람들의 보통날의 일상에 따뜻함을 더하는 제품을 선보입니다." /></div>
		<a href="/event/eventmain.asp?eventid=63769" class="mw">브랜드 바로가기</a>
		<a href="#" onclick="fnAPPpopupEvent('63769'); return false;" class="ma"> 브랜드 바로가기</a>
	</div>

	<%' 코멘트 작성 %>
	<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>"/>
	<input type="hidden" name="bidx" value="<%=bidx%>"/>
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
	<input type="hidden" name="iCTot" value=""/>
	<input type="hidden" name="mode" value="add"/>
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
	<div class="myFavorWrite" id="myFavorWrite">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/txt_comment_event.gif" alt="COMMENT EVENT" /></p>
		<div class="writeCont">
			<strong>나는</strong>
			<span><input type="text" name="qtext1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" maxlength="10"  /></span>
			<strong>이(가) 좋아요</strong>
			<p class="btnApply"><input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20150615/btn_apply.gif" alt="신청하기" /></p>
		</div>
	</div>
	<%'// 코멘트 작성 %>
	</form>
	<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	</form>

	<% IF isArray(arrCList) THEN %>
	<!-- 코멘트 리스트 -->
	<div class="myFavorList">
		<ul>
			<!-- for dev msg : li에 클래스 note01~03 랜덤으로 붙여주세요 / 리스트는 6개씩 노출됩니다. -->
			<% For intCLoop = 0 To UBound(arrCList,2) %>
			<% 
					Dim opt1 , opt2 , opt3
					If arrCList(1,intCLoop) <> "" then
						opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
						opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
						opt3 = SplitValue(arrCList(1,intCLoop),"//",2)
					End If 

					If iColorVal > 3 Then
						iColorVal = 1
					End If
			%>
			<li class="note0<%=iColorVal%>">
				<p class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
				<div class="noteCont">
					<p class="favor"><%=opt1%></p>
					<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
					<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150615/bg_cmt.png" alt="" /></div>
				</div>
			</li>
				<%
					iColorVal = iColorVal + 1
				%>
			<% Next %>
		</ul>
		<div class="paging">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
	</div>
	<!--// 코멘트 리스트 -->
	<% End If %>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->