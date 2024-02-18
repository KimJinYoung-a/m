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
' Play-sub 고양이를 빌려드립니다.- for Mobile Web
' 2014-10-17 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21345
Else
	eCode   =  55765
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
<title>생활감성채널, 텐바이텐 > 이벤트 > PLAY #13 고양이를 빌려드립니다.</title>
<style type="text/css">
.mEvt55747 {overflow:hidden;}
.mEvt55747 img {width:100%; vertical-align:top;}
input[type=checkbox] {width:15px; height:15px;}
input[type=checkbox]:checked {background:#fff url(http://fiximage.10x10.co.kr/m/2014/common/element_checkbox.png) no-repeat 50% 50%; background-size:10px 10px;}
.rent-a-cat .topic {padding:10% 0; background-color:#f8f3e7; text-align:center;}
.rent-a-cat .topic .collaboration img {width:65%;}
.rent-a-cat .topic p:last-child {margin-top:5%;}
.rent-a-cat .comment-evt {padding:10% 0; background-color:#e8e0cf;}
.rent-a-cat .comment-evt legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}

.self-test {margin:25px 0 0;}
.self-test-checklist {position:relative; padding:15px 0;}
.self-test-checklist .checklist {position:absolute; top:17%; left:0; width:100%;}
.self-test-checklist ul {padding:0 10%;}
.self-test-checklist ul li {margin-bottom:3.8%;}
.self-test-checklist ul li input {margin-right:5px;}
.self-test-checklist ul li label {vertical-align:middle;}
.self-test-checklist ul li label img {width:74%; vertical-align:middle;}
.self-test-checklist .copy-right {margin-top:12px; padding:0 10%; text-align:right;}
.self-test-checklist .copy-right img {width:66%;}
.rent-a-cat .comment-evt .btn-submit {margin:10px 4% 0;}
.rent-a-cat .comment-evt .btn-submit input {width:100%;}
.comment-list {margin:0 10px;}
.comment-list .article {position:relative; margin-top:25px; padding-bottom:20px; border:5px solid #fff;}
.comment-list .article .num {display:block; width:80px; height:35px; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55747/bg_triangle.png) no-repeat 50%; background-size:80px 35px; color:#c2ac94; font-size:11px; line-height:1.438em; text-align:center;}
.comment-list .article .num img {display:block; width:7px; height:11px; margin:0 auto; text-align:center;}
.comment-list .article .id {display:block; position:absolute; top:50px; left:0; width:80px; color:#555; font-size:11px; letter-spacing:0.05em; text-align:right;}
.comment-list .article p {margin-top:10px; text-align:center;}
.comment-list .article p img {width:285px;}
.comment-list .article .btnDel {position:absolute; top:-10px; right:-10px; width:18px; height:18px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55747/btn_del.png) no-repeat 50%; background-size:18px 18px; text-indent:-999em;}

@media all and (min-width:360px){
	.self-test-checklist ul li {margin-bottom:4%;}
	.comment-list .article .id {width:100px;}
}
@media all and (min-width:480px){
	.comment-list .article .num {width:100px; height:43px; background-size:100px 43px; font-size:15px;}
	.comment-list .article {width:442px; margin:25px auto;}
	.comment-list .article .id {top:60px; width:120px; font-size:16px; letter-spacing:-0.01em;}
	.comment-list .article p img {width:427px;}
	.comment-list .article .btnDel {top:-12px; right:-12px; width:26px; height:26px; background-size:26px 26px;}
}
@media all and (min-width:600px){
	input[type=checkbox] {width:20px; height:20px;}
	input[type=checkbox]:checked {background-size:12px 12px;}
	.self-test-checklist ul li {margin-bottom:5.8%;}
}

.animated {
	-webkit-animation-duration:5s;
	animation-duration:5s; 
	-webkit-animation-fill-mode:both;
	animation-fill-mode:both;
	-webkit-animation-iteration-count:infinite;
	animation-iteration-count:infinite;
}

/* Pulse Animation */
@-webkit-keyframes pulse {
	0% {-webkit-transform: scale(1);}
	50% {-webkit-transform: scale(1.1);}
	100% {-webkit-transform: scale(1);}
} 
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(1.1);}
	100% {transform:scale(1);}
}
.pulse {
	-webkit-animation-name:pulse;
	animation-name:pulse;

</style>
<script type="text/javascript">
<!--
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

	   
	   if(!(frm.catcheck[0].checked||frm.catcheck[1].checked||frm.catcheck[2].checked||frm.catcheck[3].checked||frm.catcheck[4].checked||frm.catcheck[5].checked||frm.catcheck[6].checked||frm.catcheck[7].checked||frm.catcheck[8].checked||frm.catcheck[9].checked)){
		alert("1개 이상 항목을 체크 해주세요");
		return false;
		}

		//합계
		var total = 0;
		for (var i=0; i < frm.catcheck.length; i++) {
			if (frm.catcheck[i].checked){
				total += parseInt(frm.catcheck[i].value);
			}
		}
		
		frm.spoint.value = total;

	   frm.action = "doEventSubscript55747.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}
//-->
</script>
</head>
<body>
<div class="mEvt55747">
	<div class="rent-a-cat">
		<div class="section topic">
			<p class="collaboration animated pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_collaboration.png" alt="텐바이텐 플라이와 무비" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_rend_a_cat.gif" alt="&quot;고양이를 빌려드립니다&quot; 외로움으로 생긴 마음의 구멍, 많은 사람들에게 고양이를 빌려주며 그 마음이 따뜻함으로 메워지길 바라는 바램을 담은 영화. 텐바이텐 PLAY는 영화에서 영감을 얻어 “고양이를 빌려드립니다 KIT”를 만들었어요. 사람들의 마음을 치유하고 잠시나마 외로움을 잊고 따뜻해 질 수 있도록 텐바이텐에서 고양이와 함께하는 시간을 마련해드려요." /></p>
		</div>

		<div class="section">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/img_slide_01.jpg" alt="고양이를 빌려드립니다" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/img_slide_02.jpg" alt="도심 한구석에 평화로이 자리한 수상한 고양이 대여점" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/img_slide_03.jpg" alt="외로운 사람과 고양이의 만남을 돕는 사요코와 그녀가 만나는 다양한 사람들의 이야기" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/img_slide_04.jpg" alt="고양이 대여점 주인부터, 사랑하는 남편과 고양이를 먼저 떠나 보낸 노부인, 사춘기 딸을 둔 기러기 아빠, 늘 혼자였던 렌터카 가게 점원, 쫓기고 있는 남자까지" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/img_slide_05.jpg" alt="외로움으로 생긴 마음 속 구멍 제대로 메워주세요" /></p>
		</div>

		<div class="section kit">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/tit_kit.gif" alt="고양이를 빌려드립니다 KIT" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_kit.jpg" alt="고양이를 빌려드립니다 KIT에는 DVD, 포스터, 쿠션이 포함되어 있습니다." /></p>
		</div>

		<div class="section comment-evt">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/tit_comment_event.gif" alt="코멘트 이벤트" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_comment_event.gif" alt="고양이남, 고양이녀 레벨테스트를 해보세요 : ) 레벨 테스트를 하신 분들은 &quot;고양이를 빌려드립니다&quot; KIT에 자동 응모됩니다. 응모해주신 분들 중 추첨을 통해 10분에게 &quot;고양이를 빌려드립니다&quot; KIT를 선물로 드립니다. 이벤트 기간은 2014년 10월 20일부터 11월 3일까지며 당첨자 발표는 2014년 11월 5일입니다." /></p>

			<div class="self-test">
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>"/>
				<input type="hidden" name="bidx" value="<%=bidx%>"/>
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
				<input type="hidden" name="iCTot" value=""/>
				<input type="hidden" name="mode" value="add"/>
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
				<input type="hidden" name="spoint" value="0"/>
					<fieldset>
					<legend>나 이런적 있어! 해당 항목에 체크하기</legend>
						<div class="self-test-checklist">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_self_test_check.png" alt="나 이런적 있어! 해당 항목에 체크하세요" /></p>
							<div class="checklist">
								<ul>
									<li>
										<input type="checkbox" id="selftest01" name="catcheck" value="1" />
										<label for="selftest01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_01.png" alt="당신의 마음에 구멍난 곳이 있다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest02" name="catcheck" value="1"/>
										<label for="selftest02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_02.png" alt="혼자서 살고 있다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest03" name="catcheck" value="1"/>
										<label for="selftest03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_03.png" alt="렌터카를 이용해 본 적이 있다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest04" name="catcheck" value="1"/>
										<label for="selftest04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_04.png" alt="할머니와의 추억을 소중히 한다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest05" name="catcheck" value="1"/>
										<label for="selftest05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_05.png" alt="더운 날에는 역시 맥주라고 생각한다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest06" name="catcheck" value="1"/>
										<label for="selftest06"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_06.png" alt="도넛이 좋아서 홧김에 많이 산 적 있다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest07" name="catcheck" value="1"/>
										<label for="selftest07"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_07.png" alt="고양이를 좋아한다. 혹은 고양이가 따라온다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest08" name="catcheck" value="1"/>
										<label for="selftest08"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_08.png" alt="올해야 말로 결혼! 하고 싶다고 생각한다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest09" name="catcheck" value="1"/>
										<label for="selftest09"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_09.png" alt="아무도 모르지만, 사실은 어떤 사람한테 쫓기고 있다." /></label>
									</li>
									<li>
										<input type="checkbox" id="selftest10" name="catcheck" value="1"/>
										<label for="selftest10"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_label_self_test_check_10.png" alt="쉽게 잠들지 않는 밤이 많다. " /></label>
									</li>
								</ul>

								<p class="copy-right"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_self_test_copyright.png" alt="출처는 고양이를 빌려드립니다 일본 공식 홈페이지입니다." /></p>
							</div>
						</div>

						<div class="btn-submit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/55747/btn_submit.gif" alt="결과확인 KIT에 자동으로 응모됩니다." /></div>
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

			<% IF isArray(arrCList) THEN %>
			<div class="comment-list">
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<div class="article">
					<span class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %> <% If arrCList(8,intCLoop) = "M"  then%><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/ico_mobile_beige.gif" alt="모바일에서 작성된 글" /><% End If %></span>
					<strong class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong>
					<% If arrCList(3,intCLoop) < 4 Then %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_recomment_01.gif" alt="렌타네코 레벨 30퍼센트며, 당신에게는 아기 고양이 마미코짱이 제격입니다." /></p>
					<% ElseIf arrCList(3,intCLoop) > 3 And arrCList(3,intCLoop) < 8 then %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_recomment_02.gif" alt="렌타네코 레벨 70퍼센트며, 행운을 부르는 마네키네코가 든든한 내편이 되어줄 겁니다." /></p>
					<% ElseIf arrCList(3,intCLoop) > 7 Then %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55747/txt_recomment_03.gif" alt="렌타네코 레벨 100퍼센트며, 느긋하게 누워있는 우타마루 사부와 유유자적하게 이야기를 해보아요!" /></p>
					<% End If %>
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