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
'#### 2014-03-14 이종화 작성 play_sub ###################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21113
Else
	eCode   =  50071
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

	iCPageSize = 3		'한 페이지의 보여지는 열의 수
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
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">
$(function(){
//	mySwiper0 = new Swiper('.swiper0',{
//		pagination:'.paging0',
//		paginationClickable:true,
//		loop:true,
//		resizeReInit:true,
//		calculateHeight:true
//	});

	swiper = new Swiper('.swiper0', {
		pagination : '.paging0',
		loop:true,
		autoPlay: 3000
	});

	$('.approvalList .t01 .getOff strong').text('칼퇴');
	$('.approvalList .t02 .getOff strong').text('밥퇴');
	$('.approvalList .t03 .getOff strong').text('10시퇴근');
	$('.approvalList .t04 .getOff strong').text('12시퇴근');
	$('.approvalList .t05 .getOff strong').text('예측불가');

	$(".goMemo a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
	});
});
</script>
<script type="text/javascript">
	function goPage(page){
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

		if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked||frm.spoint[4].checked)){
			alert("현재 당 수치를 선택해주세요");
			return false;
		}

		if(!(frm.txtcomm[0].checked||frm.txtcomm[1].checked||frm.txtcomm[2].checked||frm.txtcomm[3].checked||frm.txtcomm[4].checked)){
			alert("예상 퇴근시간을 선택해주세요");
			return false;
		}

		frm.action = "doEventSubscript50069.asp";
		return true;
	}

	function jsDelComment(cidx) {
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
			document.frmdelcom.submit();
		}
	}
</script>
<title>생활감성채널, 텐바이텐 > 이벤트 > 야근수당! 야근 야금 까먹자~</title>
<style type="text/css">
	.mEvt50069 img {vertical-align:top; width:100%;background-size:3px 3px;}
	.mEvt50069 p {max-width:100%;}
	.mEvt50069 .evtNotice {background:url(http://webimage.10x10.co.kr/eventIMG/2014/49974/bg_notice.png) left top repeat; background-size:10px 10px;}
	.mEvt50069 .approval {padding-bottom:20px; background:#f9efcb;}
	.mEvt50069 .approval dl {position:relative; overflow:hidden;}
	.mEvt50069 .approval dd {position:absolute; left:9%; top:28%; width:82%;}
	.mEvt50069 .approval li {float:left; width:20%; text-align:center;}
	.mEvt50069 .approval li label {display:block; margin-bottom:8px;}
	.mEvt50069 .approval .fBtn {width:50%; margin-left:25%;}
	.mEvt50069 .approval .fBtn input {width:100%;}
	.mEvt50069 .approvalList {}
	.mEvt50069 .approvalList ul {padding:20px 0 25px; background:#f0f0f0;}
	.mEvt50069 .approvalList li {position:relative; margin-bottom:20px; }
	.mEvt50069 .approvalList li:last-child {margin-bottom:0;}
	.mEvt50069 .approvalList li div {position:absolute; width:45%; left:45%; top:0; padding-top:8%;}
	.mEvt50069 .approvalList li .energy {position:absolute; left:0; top:0; display:inline-block; width:50%; height:100%; background-position:left top; background-repeat:no-repeat; background-size:100% auto;}
	.mEvt50069 .approvalList li.e01 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/50069/ico_energy04.png);}
	.mEvt50069 .approvalList li.e02 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/50069/ico_energy03.png);}
	.mEvt50069 .approvalList li.e03 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/50069/ico_energy02.png);}
	.mEvt50069 .approvalList li.e04 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/50069/ico_energy01.png);}
	.mEvt50069 .approvalList li.e05 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/50069/ico_energy00.png);}
	.mEvt50069 .approvalList li .delete {position:absolute; right:4.5%; top:0; width:3%; cursor:pointer; padding:5px;}
	.mEvt50069 .approvalList li .docNum {display:block; color:#777; font-size:10px; padding-bottom:8%;}
	.mEvt50069 .approvalList li .getOff {display:inline-block; border-bottom:2px solid #181818; font-size:19px; line-height:20px; color:#222;}
	.mEvt50069 .approvalList li .txt {color:#333; font-size:11px; line-height:15px; padding-top:6%;}
	.mEvt50069 .memo03Head {position:relative;}
	.mEvt50069 .memo03Head .goMemo {position:absolute; left:22%; bottom:10%; width:56%; }
	.mEvt50069 .tentenBaemin .slash {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50069/bg_slash.png) left top repeat; background-size:10px 10px;}
	.mEvt50069 .kitWrap {padding:0 10px 25px; width:300px; margin:0 auto;}
	.mEvt50069 .kit {width:300px; padding-top:10px; position:relative; overflow:hidden;}
	.mEvt50069 .kit .swiper-container {width:300px; height:246px; overflow:hidden; margin:0 auto; position:relative;}
	.mEvt50069 .kit .swiper-wrapper {position:relative; overflow:hidden;}
	.mEvt50069 .kit .swiper-slide {width:300px; height:216px; float:left; overflow:hidden;}
	.mEvt50069 .kit .pagination {text-align:center; padding-top:10px; position:absolute; bottom:0; left:0; text-align:center; width:100%;}
	.mEvt50069 .kit .pagination span {width:14px; height:14px; display:inline-block; text-align:center; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50069/blt_pagination_off.png); background-size:14px 14px; margin:0 5px;}
	.mEvt50069 .kit .pagination span.swiper-active-switch {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/50069/blt_pagination_on.png)}
	.mEvt50069 .baeminIntro {position:relative;}
	.mEvt50069 .baeminIntro ul {overflow:hidden; position:absolute; left:14%; top:65%; width:80%;}
	.mEvt50069 .baeminIntro ul li {float:left; width:26%; padding:0 2%;}

@media all and (min-width:480px){
	.mEvt50069 .kitWrap {padding:0 15px 25px; width:450px;}
	.mEvt50069 .kit {width:450px;}
	.mEvt50069 .kit .swiper-container {width:450px; height:354px;}
	.mEvt50069 .kit .swiper-slide {width:450px; height:324px;}
}
</style>

</head>
<body>
	<div class="mEvt50069">
		<div class="memo03Head">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/txt_memo_head.png" alt="야근수당! 야근 야금 까먹자~" />
			<p class="goMemo"><a href="#writeMemo"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/btn_go_approval.png" alt="" /></a></p>
		</div>
		<ol class="tentenBaemin">
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_delivery_img01.png" alt="" /></li>
			<li class="slash">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_delivery_img02.png" alt="" /></p>
				<div class="kitWrap">
					<div class="kit">
						<div class="swiper-container swiper0">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_slide_kit01.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_slide_kit02.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_slide_kit03.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_slide_kit04.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_slide_kit05.png" alt="" /></div>
							</div>
							<div class="pagination paging0"></div>
						</div>
					</div>
				</div>
			</li>
			<li class="baeminIntro">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_delivery_img03.png" alt="" /></p>
				<ul>
					<li><a href="https://play.google.com/store/apps/details?id=com.sampleapp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/btn_and.png" alt="" /></a></li>
					<li><a href="https://itunes.apple.com/app/id378084485" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/btn_iphone.png" alt="" /></a></li>
					<li><a href="/street/street_brand.asp?makerid=woowahan"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/btn_product.png" alt="" /></a></li>
				</ul>
			</li>
		</ol>
		<!-- 이벤트 참여하기 -->
		<div class="applyEvtWrap" id="writeMemo">
			<div class="applyEvt">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/txt_approval.png" alt="" /></p>
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				<div class="approval">
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/tit_energy.png" alt="현재 당 수치" /></dt>
						<dd colspan="3">
							<ul class="selectEnergy">
								<li class="energy01">
									<label for="energy01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_energy04.png" alt="" /></label>
									<input type="radio" id="energy01" name="spoint" value="1" />
								</li>
								<li class="energy02">
									<label for="energy02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_energy03.png" alt="" /></label>
									<input type="radio" id="energy02" name="spoint" value="2" />
								</li>
								<li class="energy03">
									<label for="energy03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_energy02.png" alt="" /></label>
									<input type="radio" id="energy03" name="spoint" value="3" />
								</li>
								<li class="energy04">
									<label for="energy04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_energy01.png" alt="" /></label>
									<input type="radio" id="energy04" name="spoint" value="4" />
								</li>
								<li class="energy05">
									<label for="energy05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_energy00.png" alt="" /></label>
									<input type="radio" id="energy05" name="spoint" value="5" />
								</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/tit_time.png" alt="예상 퇴근시간" /></dt>
						<dd colspan="3">
							<ul class="selectTime">
								<li>
									<label for="time01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_time01.png" alt="" /></label>
									<input type="radio" id="time01" name="txtcomm" value="1" />
								</li>
								<li>
									<label for="time02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_time02.png" alt="" /></label>
									<input type="radio" id="time02" name="txtcomm" value="2" />
								</li>
								<li>
									<label for="time03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_time03.png" alt="" /></label>
									<input type="radio" id="time03" name="txtcomm" value="3" />
								</li>
								<li>
									<label for="time04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_time04.png" alt="" /></label>
									<input type="radio" id="time04" name="txtcomm" value="4" />
								</li>
								<li>
									<label for="time05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/img_time05.png" alt="" /></label>
									<input type="radio" id="time05" name="txtcomm" value="5" />
								</li>
							</ul>
						</dd>
					</dl>
					<p class="fBtn"><span><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/50069/btn_finish.png" alt="작성완료" /></span></p>
				</div>
				</form>
				<form name="frmdelcom" method="post" action="doEventSubscript50069.asp" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				</form>
				<% IF isArray(arrCList) THEN %>
				<div class="approvalList">
					<ul>
						<% For intCLoop = 0 To UBound(arrCList,2)%>
						<li class="t0<%=nl2br(arrCList(1,intCLoop))%> e0<%=arrCList(3,intCLoop)%>">
							<span class="energy"></span>
							<div>
								<span class="docNum">문서코드 <em>no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></em></span>
								<p class="getOff">나오늘 <strong></strong></p>
								<p class="txt"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님의<br />결재 요청서가 접수되었습니다.</p>
							</div>
							<p class="docBg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/bg_doc.png" alt="" /></p>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<span class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>')"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50069/btn_delete.png" alt="삭제" /></span>
							<% End If %>
						</li>
						<% Next %>
					</ul>
					<div class="paging tMar10">
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
					</div>
				</div>
				<% End If %>
			</div>
		</div>
		<!--// 이벤트 참여하기 -->
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->