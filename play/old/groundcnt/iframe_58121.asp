<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  크리스마스 이벤트
' History : 2014.11.26 한용민 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/play/groundcnt/event58121Cls.asp" -->
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

	iCPageSize = 10		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	if isMyComm="Y" then cEComment.FUserID = GetLoginUserID

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.mPlay20141229 {}
.twinkle {}
.section2 {padding-bottom:12%; background-color:#fff;}
.section2 .link {overflow:hidden; padding:0 5%;}
.section2 .link a {float:left; width:50%; padding:0 1.5%;}

.section4 {padding-bottom:12%; background-color:#fff;}
/* swiper */
.rolling-swiper {position:relative; width:320px; margin:0 auto;}
.rolling-swiper .swiper-container {overflow:hidden; width:320px;}
.rolling-swiper .swiper .swiper-slide {float:left;}
.rolling-swiper .pagination {position:absolute; bottom:15px; left:0; width:100%; text-align:center; z-index:10;}
.rolling-swiper .pagination span {display:inline-block; width:6px; height:6px; margin:0 5px; background-color:#fff; font-size:12px; font-weight:bold; line-height:1em; text-align:center;}
.rolling-swiper .pagination .swiper-active-switch {background-color:#a49089;}
.rolling-swiper button {display:none;}

.field {padding:20px 0;}
.field legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.field ul {overflow:hidden; width:295px; margin:0 auto;}
.field ul li {float:left; width:49px; margin:0 5px; text-align:center;}
.field ul li input {width:15px; height:15px; margin-top:5px; border-radius:50%; vertical-align:baseline;}
.field ul li input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}
.enter {width:320px; min-height:164px; margin:15px auto 0; background:url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_light_illust.gif) no-repeat 50% 0; background-size:100% auto;}
.enter textarea {width:160px; height:90px; margin-top:10px; margin-left:140px; border-radius:0; font-size:11px; line-height:1.5em;}
.enter .submit {margin-top:2px; margin-left:140px;}
.enter .submit input {width:160px;}

.commentwrap {background-color:#fff;}
.commentlist {overflow:hidden; width:300px; margin:0 auto;}
.commentlist .msgbox {float:left; width:150px; padding-top:20px; border-bottom:1px solid #ddd; text-align:center;}
.commentlist .msgbox .inside {position:relative; height:270px; padding:20px 0; background-repeat:no-repeat; background-position:50% 0; background-size:100% auto;}
.commentlist .msgbox .inside:nth-child(odd) {margin-right:6px;}
.bg1 .inside {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_comment_light_01.gif);}
.bg2 .inside {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_comment_light_02.gif);}
.bg3 .inside {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_comment_light_03.gif);}
.bg4 .inside {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_comment_light_04.gif);}
.bg5 .inside {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_comment_light_05.gif);}
.msgbox p, .msgbox .no, .msgbox .id {display:block; font-size:11px; line-height:1.5em; text-align:center;}
.msgbox p {width:81px; height:195px; margin:0 auto; padding-top:55px;}
.msgbox p img {display:block; width:7px; margin:0 auto;}
.msgbox .no {color:#bbb;}
.msgbox .id {margin-top:10px; color:#aaa; letter-spacing:-1px;}
.msgbox .btndel {position:absolute; top:3px; right:3px; width:30px; height:30px; background:url(http://webimage.10x10.co.kr/playmo/ground/20141229/btn_del.png) no-repeat 50% 0; background-size:100% auto; text-indent:-999em;}

.paging {overflow:hidden; position:relative; z-index:5; margin-top:-1px !important; padding-top:20px; border-top:1px solid #f4f7f7;}

@media all and (min-width:480px){
	.rolling-swiper .pagination span {width:9px; height:9px;}
	.rolling-swiper {position:relative; width:480px; margin:0 auto;}
	.rolling-swiper .swiper-container {overflow:hidden; width:480px;}
	.field {padding:30px 0;}
	.field ul {width:435px;}
	.field ul li {width:73px; margin:0 7px;}
	.field ul li input {width:22px; height:22px; margin-top:7px;}
	.enter {width:480px; min-height:260px;}
	.enter textarea {width:240px; height:135px; margin-top:15px; margin-left:210px; font-size:16px;}
	.enter .submit {margin-top:3px; margin-left:210px;}
	.enter .submit input {width:240px;}
	.commentlist {width:380px;}
	.commentlist .msgbox {width:190px; padding-top:30px;}
	.commentlist .msgbox .inside {height:350px; padding:30px 0;}
	.commentlist .msgbox .inside:nth-child(odd) {margin-right:9px;}
	.msgbox p {width:100px; height:243px; margin:0 auto;  font-size:13px;}
	.msgbox .no, .msgbox .id {font-size:13px; letter-spacing:0;}
	.msgbox .id {margin-top:15px;}
	.msgbox .btndel {width:40px; height:40px;}
	.paging {padding-top:30px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:1000,
		autoplay:5000,
		autoplayDisableOnInteraction: true,
		nextButton:'.arrow-right',
		prevButton:'.arrow-left'
	});

	$('.arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});

	$('.arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
});

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

	if(frmcom.txtcomm.value =="코멘트 입력 (50자 이내)"){
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
		<% If not( getnowdate>="2014-12-29" and getnowdate<"2015-01-08") Then %>
			alert('이벤트 응모 기간이 아닙니다.');
			return;
		<% end if %>
		<% if commentexistscount>=5 then %>
			alert('한아이디당 5회 까지만 참여가 가능 합니다.');
			return;
		<% end if %>

		var tmpgubun='';
		for (var i=0; i < frmcom.gubun.length ; i++){
			if (frmcom.gubun[i].checked){
				tmpgubun=frmcom.gubun[i].value;
			}
		} 
		if (tmpgubun==''){
			alert('빛을 선택해 주세요.');
			return;
		}
		if(frmcom.txtcomm.value =="코멘트 입력 (50자 이내)"){
			frmcom.txtcomm.value ="";
		}
		if(!frmcom.txtcomm.value){
			alert("코멘트를 입력해주세요");
			frmcom.txtcomm.focus();
			return false;
		}
		if (GetByteLength(frmcom.txtcomm.value) > 50){
			alert("코맨트가 제한길이를 초과하였습니다. 50자 까지 작성 가능합니다.");
			frmcom.txtcomm.focus();
			return;
		}

		frmcom.action='/play/groundcnt/doEventSubscript58121.asp';
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
			document.frmdelcom.action='/play/groundcnt/doEventSubscript58121.asp';
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

<!-- for dev msg : iframe -->
<div class="mPlay20141229">
	<div class="twinkle">
		<div class="section section1">
			<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/tit_twinkle_2015.gif" alt="반짝 반짝 빛나라 2015" /></h1>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_topic.jpg" alt="열심히 달려온 2014년, 이제 우리는 새해를 맞이합니다. 텐바이텐과 일광전구는 2015년, 여러분이 간절히 원하는 모든 것들이 이루어지기를 바라는 마음으로 특별한 의미를 지닌 전구를 준비했습니다. 전구의 빛들이 환하게 밝혀지는 만큼, 여러분의 새해도 밝게 빛나기 바랍니다! " /></p>
		</div>

		<div class="section section2">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/tit_brand.gif" alt="일광전구" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_brand.jpg" alt="시대가 변하면서 가장 원시적인 것이 가장 값진 물건이 되듯이 백열전구는 가장 고급스러운 전구가 될 것이라 생각합니다. 대량생산이 아닌 수작업 방식을 선택하고 디자인 가치를 넣으려 합니다. 일광전구의 가장 큰 자산인 수많은 장인들이 만들어내는 역사적 가치와 노하우를 기업의 근간으로 계속 성장하고자 합니다. 지금까지의 전구가 산업용 또는 생활 필수품 정도였다면, 이제는 디자인/인테리어 제품으로서 새로운 가치를 부여한 전구 브랜드로 다시 태어납니다." /></p>
			<div class="link">
				<% if isApp=1 then %>
					<a href="" onclick="parent.fnAPPpopupExternalBrowser('http://www.iklamp.co.kr'); return false;" title="일광전구 홈페이지 새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/btn_homepage.gif" alt="홈페이지 가기" /></a>
					<a href="" onclick="parent.fnAPPpopupExternalBrowser('http://www.facebook.com/iklamp'); return false;" title="일광전구 페이스북 새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/btn_facebook.gif" alt="페이스북 가기" /></a>
				<% else %>
					<a href="http://www.iklamp.co.kr" target="_blank" title="일광전구 홈페이지 새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/btn_homepage.gif" alt="홈페이지 가기" /></a>
					<a href="http://www.facebook.com/iklamp" target="_blank" title="일광전구 페이스북 새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/btn_facebook.gif" alt="페이스북 가기" /></a>
				<% end if %>
			</div>
		</div>

		<div class="section section3">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/tit_package.jpg" alt="일광전구" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_package_composition.jpg" alt="패키지는 클래식 시리즈 ST64 220볼트 40와트짜리 전구와 소켓으로 구성되어 있습니다. 전구와 소켓은 비매품입니다." /></p>
		</div>

		<div class="section section4">
			<!-- swipe -->
			<div class="rolling-swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/img_slide_full_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/img_slide_full_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/img_slide_full_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/img_slide_full_04.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="arrow-left">이전</button>
				<button type="button" class="arrow-right">다음</button>
			</div>
		</div>

		<!-- comment event -->
		<div class="section section5">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_message.gif" alt="2015년, 가장 원하는 빛을 선택하고 간단한 응원의 메시지를 남겨보세요! 추첨을 통해 50분에게 텐바이텐x일광전구 스페셜 패키지 상품을 선물로 드립니다! 이벤트 기간은 2014년 12월 29일부터 2015년 1월 7일까지며, 당첨자 발표는 2015년 1월 9일까지입니다." /></p>
			<div class="field">
				<form name="frmcom" method="post" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="spoint" value="0">
				<input type="hidden" name="isMC" value="<%=isMyComm%>">
					<fieldset>
					<legend>응원 메시지 남기기</legend>
						<ul>
							<li>
								<label for="light01"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_label_01.gif" alt="열정" /></label>
								<input type="radio" value="1" name="gubun" id="light01" name="" />
							</li>
							<li>
								<label for="light02"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_label_02.gif" alt="사랑" /></label>
								<input type="radio" value="2" name="gubun" id="light02" name="" />
							</li>
							<li>
								<label for="light03"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_label_03.gif" alt="변화" /></label>
								<input type="radio" value="3" name="gubun" id="light03" name="" />
							</li>
							<li>
								<label for="light04"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_label_04.gif" alt="희망" /></label>
								<input type="radio" value="4" name="gubun" id="light04" name="" />
							</li>
							<li>
								<label for="light05"><img src="http://webimage.10x10.co.kr/playmo/ground/20141229/txt_label_05.gif" alt="건강" /></label>
								<input type="radio" value="5" name="gubun" id="light05" name="" />
							</li>
						</ul>
						<div class="enter">
							<textarea name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> cols="60" rows="5" title="응원 메시지 입력"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>코멘트 입력 (50자 이내)<%END IF%></textarea>
							<div class="submit"><input type="image" onclick="jsSubmitComment(); return false;" src="http://webimage.10x10.co.kr/playmo/ground/20141229/btn_submit.gif" alt="전구 밝히기" /></div>
						</div>
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

		<!-- comment list -->
		<% IF isArray(arrCList) THEN %>
			<div class="section section6">
				<div class="commentwrap">
					<div class="commentlist">
						<% ' for dev msg : <div class="msgbox">...</div 한 묶음입니다. 한줄에 5개씩 한페이지당 3줄씩 보여주세요 인풋 라디오 선택에 따라 bg1~bg5 클래스명 넣어주세요 %>
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
						<div class="msgbox bg<%= tmpcommentgubun %>">
							<div class="inside">
								<p>
									<%= tmpcommenttext %>
									
									<% If arrCList(8,i) <> "W" Then %>
										<img src="http://webimage.10x10.co.kr/playmo/ground/20141229/ico_mobile.png" alt="모바일에서 작성" />
									<% end if %>								
								</p>
								<span class="no">no.<%=iCTotCnt-i-(iCPageSize*(iCCurrpage-1))%></span>
								<span class="id">
									<strong><%=printUserId(arrCList(2,i),2,"*")%>님</strong>의 전구
								</span>

								<% if ((GetLoginUserID = arrCList(2,i)) or (GetLoginUserID = "10x10")) and ( arrCList(2,i)<>"") then %>
									<button type="button" onclick="jsDelComment('<% = arrCList(0,i) %>');return false;" class="btndel">삭제</button>
								<% end if %>
							</div>
						</div>
						<% next %>
					</div>
				</div>

				<div class="paging">
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				</div>
			</div>
		<% end if %>
	</div>
</div>
<!-- //iframe -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->