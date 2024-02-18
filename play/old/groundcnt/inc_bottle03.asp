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
' PLAY #22 BOTTLE 3주차 
' 2015-07-17 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "64833"
Else
	eCode   =  "65017"
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
%>
<style type="text/css">
img {vertical-align:top;}

.mPlay20150713 {background-color:#fff;}
.coolhelper {position:relative;}
.coolhelper .btngroup {overflow:hidden; position:absolute; top:20%; left:0; width:100%; padding-left:8%;}
.coolhelper .btngroup a {float:left; width:25%; margin-right:3%;}

.rolling .app {display:none;}
.swiper .swiper-container {width:100%;}
.swiper .swiper-wrapper {}
.swiper .pagination {display:none;}
.swiper button {display:none;}

.need {position:relative;}
.need .btnNeed {position:absolute; top:57%; left:50%; width:79.4%; margin-left:-39.7%; background-color:transparent;}
.need .count {position:absolute; top:76%; left:0; width:100%; color:#353535; font-size:11px; line-height:1.5em; text-align:center;}
.need .count strong, .need .count em {color:#fff;}
.need .count strong {display:inline-block; font-size:18px;}

@media all and (min-width:360px){
	.need .count {font-size:13px;}
	need .count strong {font-size:24px;}
}

@media all and (min-width:480px){
	.need .count {font-size:14px;}
	need .count strong {font-size:24px;}
}

@media all and (min-width:600px){
	.need .count {font-size:16px;}
	.need .count strong {font-size:30px;}
}
</style>
<script type="text/javascript">
<!--
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
	   
	   var frm = document.frmcom;
	   frm.action = "/play/groundcnt/doEventSubscript65017.asp";
	   frm.submit();
	   return true;
	}
//-->
</script>
<div class="mPlay20150713">
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/txt_cool_summer.jpg" alt="쿨 썸머 쿨 헬퍼" /></p>

	<!-- cool helper -->
	<div class="coolhelper">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/tit_cool_helper.jpg" alt="보틀에게 입혀주는 시원한 옷 COOL HELPER" /></h3>
		<div class="btngroup">
			<a href="/category/category_itemPrd.asp?itemid=1320364" class="mo">
				<img src="http://webimage.10x10.co.kr/playmo/ground/20150720/btn_get.png" alt="쿨헬퍼 구매하러 가기" />
			</a>
			<a href="" onclick="fnAPPpopupProduct('1320364'); return false;" class="app">
				<img src="http://webimage.10x10.co.kr/playmo/ground/20150720/btn_get.png" alt="쿨헬퍼 구매하러 가기" />
			</a>
			<a href="#need" class="btnmove"><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/btn_apply.png" alt="쿨헬퍼 신청하러 가기" /></a>
		</div>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/txt_cool_helper.jpg" alt="RE - DESIGN 텐바이텐만의 스타일로 재탄생한 쿨헬퍼 스페셜 에디션 다용도 아이스홀더 음료, 생수, 주류를 끝까지 시원하게! 최적의 온도유지 음료를 가장 맛있게 마실 수 있는 온도 4-10도 장시간 시원함 유지 20도 실온 최대 8시간 30도 실온 최대 3시간 간단한 사용법 얼렸다가 재사용할 수 있고 끼우기만 하면 오케이!" /></p>
	</div>

	<!-- tip -->
	<div class="tip">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/tit_tip_v1.gif" alt="쿨헬퍼 사용 팁" /></h3>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/txt_tip.jpg" alt="내장되어 있는 특수 축냉제가 있어 얼리기만 하면 탁월한 보냉 효과 지속, 간편하게 탈 부착할 수 있는 벨크로, 병과 캔이 빠질 수 없도록 지지해주고 지열하는 받침 블록, 둘레가 큰 보틀은 실리콘 밴드로 고정" /></p>
	</div>

	<!-- swiper -->
	<div class="rolling">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="/category/category_itemPrd.asp?itemid=1320364" class="mo">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_slide_01.jpg" alt="COOL HELPER" /></p>
						</a>
						<a href="" onclick="fnAPPpopupProduct('1320364'); return false;" class="app">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_slide_01.jpg" alt="" /></p>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/category/category_itemPrd.asp?itemid=1320364" class="mo">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_slide_02.jpg" alt="" /></p>
						</a>
						<a href="" onclick="fnAPPpopupProduct('1320364'); return false;" class="app">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_slide_02.jpg" alt="" /></p>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/category/category_itemPrd.asp?itemid=1320364" class="mo">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_slide_03.jpg" alt="" /></p>
						</a>
						<a href="" onclick="fnAPPpopupProduct('1320364'); return false;" class="app">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_slide_03.jpg" alt="" /></p>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/category/category_itemPrd.asp?itemid=1320364" class="mo">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_slide_04.jpg" alt="" /></p>
						</a>
						<a href="" onclick="fnAPPpopupProduct('1320364'); return false;" class="app">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_slide_04.jpg" alt="" /></p>
						</a>
					</div>
				</div>
			</div>
		</div>
		<div class="pagination"></div>
	</div>

	<div class="us">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/img_use.jpg" alt="TRAVEL, CAMPING, HIKING, BASEBALL STADIUM, SPORTS, DAILY LIFE" />
	</div>

	<form name="frmcom" method="post" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>"/>
	<input type="hidden" name="linkevt" value="<%=eCode%>"/>
	<input type="hidden" name="bidx" value="<%=bidx%>"/>
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
	<input type="hidden" name="iCTot" value=""/>
	<input type="hidden" name="mode" value="add"/>
	<input type="hidden" name="spoint" value="1">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
	<div id="need" class="need">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/txt_need.jpg" alt="뜨거운 한 여름, 쿨헬퍼가 필요하세요? 추첨을 통해 20명에게 쿨헬퍼를 보내드립니다. 디자인 랜덤 신청기간은 2015년 7월 27일부터 8월 3일까지며, 당첨자 발표는 8월 4일입니다. ※ 쿨헬퍼는 제이엠아이디어에서 제작되었으며, 대한민국 특허 / 디자인 특허 등록 및 중국 특허 등록 제품입니다." /></p>
		<button type="button" class="btnNeed" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150720/btn_need.png" alt="쿨하세 신청하기" /></button>
		<p class="count">지금까지 <strong><%=iCTotCnt%></strong> 명이 <em>쿨헬퍼</em>를 신청하셨습니다.</p>
	</div>
	</form>
</div>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		pagination:false,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3500,
		speed:1000,
		pagination:false,
		paginationClickable:true,
		autoplayDisableOnInteraction:false
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".app").show();
			$(".mo").hide();
	}else{
			$(".app").hide();
			$(".mo").show();
	}

	/* move */
	$(".btngroup .btnmove").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 1200);
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->