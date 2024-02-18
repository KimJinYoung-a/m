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
'############################################################
' 2014-10-02 13주년 이벤트 컬처스테이션
' 이종화 생성
'############################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21316
Else
	eCode   =  55077
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

	Function imgalt_13th(v)
		Dim retaltname
		Select Case v
			Case "1"
				retaltname = "황태자 루돌프"
			Case "2"
				retaltname = "레드카펫"
			Case "3"
				retaltname = "미쳐도 괜찮아 베를린"
			Case "4"
				retaltname = "유럽 블로그"
			Case "5"
				retaltname = "마리 앙투아네트"
			Case "6"
				retaltname = "우리는 형제입니다."
			Case "7"
				retaltname = "빨래"
			Case "8"
				retaltname = "도쿄 일상산책"
			Case "9"
				retaltname = "러브액츄얼리"
		End Select
		Response.write retaltname
	End Function
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 떠나요, 모든걸 훌훌 버리고</title>
<style type="text/css">
.mEvt55079 {}
.mEvt55079 img {vertical-align:top:}
.culture-station .heading {position:relative;}
.culture-station .heading .heart {position:absolute; top:23%; left:35%; width:8.5%;}
.comment-evt {padding-bottom:40px; background:url(http://webimage.10x10.co.kr/eventIMG/2014//55079/bg_paper_white.gif) repeat-y 0 0; background-size:100% auto;}
.comment-evt h4 {margin-top:7%;}
.comment-evt .choice ul {overflow:hidden; margin:25px 10px 0; padding:20px 0; background-color:#ddf3f1;}
.comment-evt .choice ul li {float:left; width:50%; margin-top:20px; padding-left:15px;}
.comment-evt .choice ul li label {line-height:1em; vertical-align:top;}
.comment-evt .choice ul li input {vertical-align:top;}
.comment-evt .choice ul li img {width:66%;}
.comment-evt .fill {text-align:center;}
.comment-evt .fill h4 {margin-bottom:20px;}
.comment-evt .fill input[type=image] {width:100%;}
.comment-evt .fill input[type=text] {width:36px; height:36px; padding:0; color:#545454; font-size:18px; text-align:center; vertical-align:middle;}
.comment-evt .fill span img {width:30%; vertical-align:middle;}
.comment-evt .fill .btnSubmit {margin:20px 15px 0;}
.comment-list-wrap {padding:20px 0 35px; background-color:#f4f7f7;}
.comment-list {overflow:hidden; padding:0 5px 10px;}
.comment-list .magicbox {overflow:hidden; float:left; position:relative; width:45%; margin:20px 2% 0; height:0; padding-bottom:30%; color:#545454;}
.comment-list .magicbox .bg {position:absolute; top:0; left:0; width:100%; height:100%;}
.comment-list .type01 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_01.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .type02 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_02.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .type03 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_03.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .type04 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_04.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .type05 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_05.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .type06 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_06.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .type07 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_07.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .type08 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_08.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .type09 .bg {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/bg_tag_09.png) no-repeat 0 0; background-size:100% auto;}
.comment-list .magicbox .num {display:block; margin-left:5%; padding-top:5%; font-size:11px;}
.comment-list .magicbox .word {margin:13% 5% 0 45%; font-size:12px; line-height:1.375em;}
.comment-list .magicbox .word strong {display:inline-block; padding:1px 3px 0; line-height:1.25em; color:#fff;}
.comment-list .magicbox .word span {display:block;}
.comment-list .type01 .word strong { background-color:#dc7a4e;}
.comment-list .type02 .word strong { background-color:#7fa75b;}
.comment-list .type03 .word strong { background-color:#72b3ac;}
.comment-list .type04 .word strong { background-color:#c8812c;}
.comment-list .type05 .word strong { background-color:#b5b03d;}
.comment-list .type06 .word strong { background-color:#c68aaa;}
.comment-list .type07 .word strong { background-color:#83afc9;}
.comment-list .type08 .word strong { background-color:#a19dbd;}
.comment-list .type09 .word strong { background-color:#989898;}
.comment-list .magicbox .writer {display:block; margin:1% 5% 0 45%; font-size:11px; line-height:1.25em;}
.comment-list .magicbox .writer img {width:6px; height:12px; vertical-align:top;}
.comment-list .magicbox .btnDel {position:absolute; top:5%; right:5%; width:10px; height:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55079/btn_del.png) no-repeat 50% 50%; background-size:10px 10px; text-indent:-999em;}
@media all and (min-width:480px){
	.comment-evt .fill input[type=text] {width:48px; height:48px; font-size:24px;}
	.comment-list .magicbox .btnDel {width:16px; height:16px; background-size:16px 16px;}
	.comment-list .magicbox .num {font-size:12px;}
	.comment-list .magicbox .word {font-size:15px;}
	.comment-list .magicbox .writer {font-size:12px;}
}
@media all and (min-width:600px){
	.comment-list .magicbox .num {font-size:15px;}
	.comment-list .magicbox .word {margin-top:13%; font-size:18px;}
	.comment-list .magicbox .writer {margin-top:3%; font-size:15px;}
}
.bnrAnniversary13th {position:relative;}
.bnrAnniversary13th .mobil {position:absolute; top:15%; left:0; width:100%;}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Bounce animation */
@-webkit-keyframes bounce {
	40% {-webkit-transform: translateY(10px);}
}
@keyframes bounce {
	40% {transform: translateY(10px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* FadeIn animation */
@-webkit-keyframes fadeIn {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes fadeIn {
	0% {opacity:0;}
	100% {opacity:1;}
}
.fadeIn {-webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-name: fadeIn; animation-name: fadeIn; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
<script type="text/javascript">
	$(function(){
		$(".accodian .intro").hide();
		$(".accodian .con:first-child .intro").show();
		$(".accodian h3 a").click(function(){
			if($(this).parent().next(".accodian .intro").css("display")=="none") {
				$(".accodian .intro").hide();
				$(this).parent().next(".accodian .intro").slideDown("fast");
	
				$('html, body', parent.document).animate({
					scrollTop: ($(this).parent().offset().top)+($('#evt_55079', parent.document).offset().top)
				}, 0);
			} else {
				$(".accodian .intro").hide();
			}
			return false;
		});

		<% if iCCurrpage>1 then %>
		setTimeout(function(){
			$('html, body', parent.document).animate({
		        scrollTop: ($('.comment-list').offset().top)+($('#evt_55079', parent.document).offset().top)
			}, 0);
			},200);
		<% end if %>
	});

	function goPage(page){
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
			<% if isApp then %>
				parent.calllogin();
			<% else %>
				parent.jsevtlogin();
			<% end if %>
		<% end if %>

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked||frm.spoint[4].checked||frm.spoint[5].checked||frm.spoint[6].checked||frm.spoint[7].checked||frm.spoint[8].checked)){
	    alert("작품을 선택 해주세요.");
	    return false;
	   }

	   if(!frm.msg1.value){
	    alert("세 글자를 모두 채워주세요!");
		document.frmcom.msg1.value="";
	    frm.msg1.focus();
	    return false;
	   }

	   if(!frm.msg2.value){
	    alert("세 글자를 모두 채워주세요!");
		document.frmcom.msg2.value="";
	    frm.msg2.focus();
	    return false;
	   }

	   if(!frm.msg3.value){
	    alert("세 글자를 모두 채워주세요!");
		document.frmcom.msg3.value="";
	    frm.msg3.focus();
	    return false;
	   }

	   document.frmcom.txtcomm.value = document.frmcom.msg1.value + document.frmcom.msg2.value + document.frmcom.msg3.value;

	   frm.action = "doEventSubscript55079.asp";
	   return true;
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			return true;
		} else {
			<% if isApp then %>
				parent.calllogin();
			<% else %>
				parent.jsevtlogin();
			<% end if %>
		}
		return false;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}
</script>
</head>
<body>
<div class="mEvt55079">
	<div class="anniversary13th culture-station">
		<div class="heading">
			<span class="heart animated fadeIn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/img_heart.png" alt="" /></span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_culture_station.gif" alt="9개의 문화 이벤트로 특별한 하루를 선물합니다!" /></p>
		</div>

		<!-- 영화 소개 -->
		<div class="accodian">
			<div class="con">
				<h3><a href="#rudolf"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_rudolf.jpg" alt="황태자 루돌프" /></a></h3>
				<div id="rudolf" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_rudolf.jpg" alt="오스트리아 황태자 루돌프와 그의 연인 마리 베체라의 운명적 실화! 디큐브 아트센터에서 2014년 10월 11일부터 2015년 1월 4일까지 공연하며, 20분께 초대권을 드립니다. 1인 2매" /></p>
				</div>
			</div>
			<div class="con">
				<h3><a href="#redcarpet"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_redcarpet.jpg" alt="레드카펫" /></a></h3>
				<div id="redcarpet" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_redcarpet.jpg" alt="이틀에 한편 찍는 대로 대박 매력 백퍼센트 19금 영화계의 어벤져스군단이 나타났다. 2014년 10월 23일 개봉 100분께 예매권을 증정합니다. 1인 2매" /></p>
				</div>
			</div>
			<div class="con">
				<h3><a href="#berlin"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_berlin.jpg" alt="미쳐도 괜찮아 베를린" /></a></h3>
				<div id="berlin" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_berlin.jpg" alt="불편하겠지만 꼭 당신들의 소파에서 자고 싶다! 일러스트레이터 아방의 카우치 서핑 30분께 도서를 증정합니다." /></p>
				</div>
			</div>
			<div class="con">
				<h3><a href="#europe"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_europe.jpg" alt="유럽 블로그" /></a></h3>
				<div id="europe" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_europe.jpg" alt="의리 있는 20년 지기 김수로와 강성진이 들려주는 유럽 이야기 대학로 TOM에서 2014년 10월 21일부터 공연이 시작되며, 30분께 초대권을 드립니다. 1인 2매" /></p>
				</div>
			</div>
			<div class="con">
				<h3><a href="#marie"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_marie.jpg" alt="마리 앙투아네트" /></a></h3>
				<div id="marie" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_marie.jpg" alt="18세기 파리 베르사이유 궁을 배경으로 펼쳐지는 마리 앙투아 네트의 드라마틱한 다룬 마리 앙투아네트는 샤롯데씨어터에서 2014년 11월 1이루터 2015년 2월 1알까지 공연되며 20분께 초대권을 드립니다. 1인 2메" /></p>
				</div>
			</div>
			<div class="con">
				<h3><a href="#brother"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_brother.jpg" alt="우리는 형제입니다" /></a></h3>
				<div id="brother" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_brother.jpg" alt="극과 극 형제의 비정상 만남! 2014년 10월 23일 개봉 100분께 예매권을 증정합니다. 1인 2매" /></p>
				</div>
			</div>
			<div class="con">
				<h3><a href="#laundry"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_laundry.jpg" alt="빨래" /></a></h3>
				<div id="laundry" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_laundry.jpg" alt="사는 게 왜 이렇게 힘드니 아트센터K 네모극장에서 2014년 10월 16일부터 2015년 5월 31일까지 공연합니다. 모두 30분께 초대권을 증정합니다. 1인 2매" /></p>
				</div>
			</div>
			<div class="con">
				<h3><a href="#tokyo"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_tokyo.jpg" alt="도쿄 일상산책" /></a></h3>
				<div id="tokyo" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_tokyo.jpg" alt="언제 떠나도 새로운이 가득한 도쿄를 걷는 27가지 방법 30분께 도쿄 일상산책을 드립니다." /></p>
				</div>
			</div>
			<div class="con">
				<h3><a href="#love"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_love.jpg" alt="러브 액츄얼리" /></a></h3>
				<div id="love" class="intro">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_love.jpg" alt="연애 공식 설명서, 연애 불면의 법칙이 궁금하세요? 대학로 소극장축제에서 2014년 7월 31일부터 10월 31일까지 공연되며, 40분께 초대권을 드립니다. 1인 2매" /></p>
				</div>
			</div>
		</div>

		<div class="comment-evt">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_three_word.png" alt="세글자의 주문을 외워보세요!" /></h3>
			
			<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
			<input type="hidden" name="iCTot" value="">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			<input type="hidden" name="txtcomm">
				<fieldset>
				<legend></legend>
					<div class="choice">
						<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_choice.png" alt="1. 작품을 선택하세요!" /></h4>
						<ul>
							<li>
								<input type="radio" id="choice01" name="spoint" value="1" />
								<label for="choice01"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_01.gif" alt="레드카펫" /></label>
							</li>
							<li>
								<input type="radio" id="choice02" name="spoint" value="2" />
								<label for="choice02"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_02.gif" alt="러브액츄얼리" /></label>
							</li>
							<li>
								<input type="radio" id="choice03" name="spoint" value="3" />
								<label for="choice03"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_03.gif" alt="마리 앙투아네트" /></label>
							</li>
							<li>
								<input type="radio" id="choice04" name="spoint" value="4" />
								<label for="choice04"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_04.gif" alt="빨래" /></label>
							</li>
							<li>
								<input type="radio" id="choice05" name="spoint" value="5" />
								<label for="choice05"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_05.gif" alt="우리는 형제입니다" /></label>
							</li>
							<li>
								<input type="radio" id="choice06" name="spoint" value="6" />
								<label for="choice06"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_06.gif" alt="도쿄 일상산책" /></label>
							</li>
							<li>
								<input type="radio" id="choice07" name="spoint" value="7" />
								<label for="choice07"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_07.gif" alt="황태자 루돌프" /></label>
							</li>
							<li>
								<input type="radio" id="choice08" name="spoint" value="8" />
								<label for="choice08"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_08.gif" alt="미쳐도 괜찮아 베를린" /></label>
							</li>
							<li>
								<input type="radio" id="choice09" name="spoint" value="9" />
								<label for="choice09"><img src="http://webimage.10x10.co.kr/eventIMG/2014//55079/txt_label_09.gif" alt="유럽블로그" /></label>
							</li>
						</ul>
					</div>

					<div class="fill">
						<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/tit_fill.png" alt="빈칸에 주문을 외운 후 응모하세요!" /></h4>
						<input type="text" title="첫번째 글자 입력" value="" placeholder="즐" name="msg1" maxlength="1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');" class="iText" />
						<input type="text" title="두번째 글자 입력" value="" placeholder="겨" name="msg2" maxlength="1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');" class="iText" />
						<input type="text" title="세번째 글자 입력" value="" placeholder="라" name="msg3" maxlength="1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');" class="iText" />
						<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/55079/txt_culture.png" alt="컬쳐스테이션!" /></span>
						
						<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/55079/btn_submit.png" alt="컬쳐스테이션 응모하기" /></div>
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
		<!-- 리스트 -->
		<% IF isArray(arrCList) THEN %>
		<div class="comment-list-wrap">
			<div class="comment-list">
				<!-- 한페이지당  한줄에 2개 * 3줄 -->
				<% For intCLoop = 0 To UBound(arrCList,2)%>
				<div class="magicbox type0<%=arrCList(3,intCLoop)%>">
					<div class="bg">
						<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
						<p class="word"><strong><%=nl2br(arrCList(1,intCLoop))%>,</strong> <span>컬쳐스테이션!</span></p>
						<em class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%>&nbsp;<% If arrCList(8,intCLoop) = "M"  then%><img src="http://webimage.10x10.co.kr/eventIMG/2014/55077/ico_mobile.png" alt="모바일 에서 작성된 글입니다." /><% End If %></em>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<button type="button" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</button>
						<% end if %>
					</div>
				</div>
				<% Next %>
			</div>
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
		</div>
		<% End If %>

		<!-- main banner -->
		<div class="bnrAnniversary13th">
			<a href="<%=appUrlPath%>/event/eventmain.asp?eventid=55074" target="_top">
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/55074/img_bnr_main.gif" alt="즐겨라 YOUR 텐바이텐 이벤트 메인으로 가기" />
				<span class="mobil animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55074/img_small_mobil.png" alt="" /></span>
			</a>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->