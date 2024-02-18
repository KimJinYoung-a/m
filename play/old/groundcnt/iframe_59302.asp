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
Dim eCode, tmponload
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "21472"
Else
	eCode   =  "59302"
End If
tmponload	= requestCheckVar(request("upin"),2)

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

	iCPageSize = 15		'한 페이지의 보여지는 열의 수
	iCPerCnt = 10		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	'arrCList = cEComment.fnGetComment		'리스트 가져오기
	'iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	'arrCList = cEComment.fnGetComment		'리스트 가져오기
	'iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

	Dim vQuery, vArr, v1Count, v2Count, v3Count, i
	vQuery = "select evtcom_point, count(evtcom_idx) from [db_event].[dbo].[tbl_event_comment] where evt_code = '" & eCode & "' group by evtcom_point"
	rsget.Open vQuery, dbget, 1
	if not rsget.eof then
		vArr = rsget.getrows()
	end if

	v1Count = "0"
	v2Count = "0"
	v3Count = "0"

	IF isArray(vArr) THEN
		For i =0 To UBound(vArr,2)
			if vArr(0,i) = "1" then
				v1Count = vArr(1,i)
			end if
			if vArr(0,i) = "2" then
				v2Count = vArr(1,i)
			end if
			if vArr(0,i) = "3" then
				v3Count = vArr(1,i)
			end if
		Next
	End IF
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mPlay20150223 {}
.shoesGuard .section1 {position:relative; padding:46% 0 45%; background:#252525 url(http://webimage.10x10.co.kr/playmo/ground/20150223/bg_dark.png) no-repeat 0 0; background-size:100% auto;}
.shoesGuard .section1 h1 {position:absolute; top:11%; left:0; width:100%;}
.shoesGuard .section1 p {position:relative; z-index:10; margin-top:7%;}
.shoesGuard .section1 .person {position:absolute; bottom:0; left:0; z-index:5; width:100%;}
.shoesGuard .section4 {padding:15% 0; background:#3f3f3f url(http://webimage.10x10.co.kr/playmo/ground/20150223/bg_pattern_grid.png) repeat-y 0 0; background-size:100% auto;}
.shoesGuard .section4 h2 + p {margin-top:10%;}
.field legend {visibility:hidden;overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.field ul {overflow:hidden; margin-top:12%; padding:0 2.4%;}
.field ul li {float:left; position:relative; width:33.333%; padding:0 2% 8%; text-align:center;}
.field ul li em {color:#edf569; font-size:18px; line-height:18px;}
.field ul li label {display:block; margin-bottom:10%;}
.field input[type=radio] {position:absolute; bottom:0; left:50%; margin-left:-10px; border-radius:50%;}
.field input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}
.field input[type=image] {width:100%;}
.field .btnsubmit {width:61.5%; margin:10% auto 0;}
.field p {}
.field p img {width:16px; /*vertical-align:middle;*/}
.field p span {display:block; margin-top:3px;}
.field p span img {width:63px;}
@media all and (min-width:480px){
	.field ul li em {font-size:27px;}
	.field input[type=radio]:checked {background-size:15px 15px;}
	.field p img {width:24px;}
	.field p span {margin-top:5px;}
	.field p span img {width:94px;}
}
</style>
<script type="text/javascript">
<!--
 	function jsSubmitComment(){
	   var frm = document.frmcom;
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% else %>
			if (!frm.spoint[0].checked && !frm.spoint[1].checked && !frm.spoint[2].checked)
			{
				alert("당신의 집을 안전하게 지켜줄 '그'를 선택하세요!")
				return false;
			}
		<% end if %>

	   frm.action = "doEventSubscript59302.asp";
	   frm.submit();
	   return true;
	}
	
<% if tmponload="ON" then %>
	$(function(){
		window.parent.$('html,body').animate({scrollTop:$(".field").offset().top}, 500);
		//window.parent.$('html,body').animate({scrollTop:5600}, 500);
		//document.getElementById('sectiontemp').scrollIntoView();
	});
<% end if %>
//-->
</script>
</head>
<body>
<div class="mPlay2015023">
	<div class="shoesGuard">
		<div id="animation" class="section1">
			<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/tit_shoes_guard.png" alt="신발가드" /></h1>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_shoes_guard.png" alt="혼자 사는 당신을 지켜주는 든든한 신발가드" /></p>
			<span class="person"><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/img_person.png" alt="" /></span>
		</div>

		<div class="section2">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_somebody.jpg" alt="혼자 있는 무서움 속에서 나를 지켜 줄 든든한 누군가가 필요하신가요?" /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_mean.jpg" alt="혼자 사는 분들에게 필요한 안전한 보디가드 그 역할을 해 줄 신발가드를 현관에 함께 두세요. 어두운 밤, 무서움으로부터 신발가드가 여러분을 지켜드릴 거에요." /></p>
		</div>

		<div class="section3">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/tit_profile.png" alt="Shoes Guard PROFILE" /><span></span></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_define.png" alt="신발가드란 혼자 사니는 분들의 집에 두는 남자 신발로 텐바이텐이 보내드리는 슈즈 보디가드의 신조어입니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_profile_01.jpg" alt="신사옵화 : 똑 부러지며 날렵한 얼굴에 정갈한 매무새를 지닌, 스마트하며 일 처리가 깔끔한 남자. 온종일 서 있을 수 없는 체력 부족의 단점과 재빨리 착용하고 뛰쳐나가기에는 다소 어려운 순발력의 부재가 있지만, 전투력만큼은 남들 못지 않은 편. 주 무기에는 정강이 히트가 있음." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_profile_02.jpg" alt="몸짱옵화 : 다부진 체격과 단단한 근육으로 무장한 전직 운동선수 출신인 몸짱옵화. 운동을 좋아하는 그에게는 전광석화와 같은 스피드가 있으며, 가볍고 날렵한 몸놀림은 언제든지 발 빠른 추격을 가능하게 함. 하지만 다소 약한 피부로 인해 보호력이 떨어지는 것이 유일한 약점. 주 무기에는 돌려차기, 이단옆차기, 점프가 있음." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_profile_03.jpg" alt="키다리옵화 : 자칫 군인으로 보일 수 있지만 모델같이 큰 키와 묵직한 매력을 지닌 남자. 자유로운 영혼을 지닌 듯 하지만 그렇다고 부드럽다고는 할 수는 없는 터프한 성격. 전투력, 보호력, 체력 등 모든 면에서 우월하지만, 순발력은 다소 떨어지는 것이 약점. 주 무기에는 찍어차기가 있음." /></p>
		</div>

		<div class="section4">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/tit_event.png" alt="Shoes Guard EVENT" /><span></span></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_event.png" alt="당신의 집을 안전하게 지켜줄 그를 선택하세요! 추첨을 통해 3분께 신발가드가 찾아갑니다. 이벤트 기간은 2월 23일부터 3월 4일까지며 발표는 3월 6일입니다. 신발 사이즈는 랜덤으로 발송됩니다." /></p>
			<div id="field" class="field">
				<form name="frmcom" method="post" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>"/>
				<input type="hidden" name="bidx" value="<%=bidx%>"/>
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
				<input type="hidden" name="iCTot" value=""/>
				<input type="hidden" name="mode" value="add"/>
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
					<fieldset>
					<legend>당신의 집을 안정하세 지켜줄 그 선택하기</legend>
						<ul>
							<li>
								<label for="select01"><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_label_01.png" alt="신사옵화" /></label>
								<input type="radio" id="select01" name="spoint" value="1" />
								<p>
									<em><%=v1Count%></em> <img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_num_01.png" alt="명이" />
									<span><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_num_02.png" alt="보호의 손길을 기다리고있습니다!" /></span>
								</p>
							</li>
							<li>
								<label for="select02"><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_label_02.png" alt="몸짱옵화" /></label>
								<input type="radio" id="select02" name="spoint" value="2" />
								<p>
									<em><%=v2Count%></em> <img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_num_01.png" alt="명이" />
									<span><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_num_02.png" alt="보호의 손길을 기다리고있습니다!" /></span>
								</p>
							</li>
							<li>
								<label for="select03"><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_label_03.png" alt="키다리옵화" /></label>
								<input type="radio" id="select03" name="spoint" value="3" />
								<p>
									<em><%=v3Count%></em> <img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_num_01.png" alt="명이" />
									<span><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/txt_num_02.png" alt="보호의 손길을 기다리고있습니다!" /></span>
								</p>
							</li>
						</ul>
						<div class="btnsubmit"><img src="http://webimage.10x10.co.kr/playmo/ground/20150223/btn_submit.png" alt="응모하기" onclick="jsSubmitComment();return false;" /></div>
					</fieldset>
				</form>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	/* animation effect */
	setInterval(function(){
		animation();
	},100);

	$("#animation h1").hide().animate({width:"0"},100);
	$("#animation p").css({"opacity":"0"});
	$("#animation .person").css({"opacity":"0"});
	function animation () {
		$("#animation h1").show().animate({width:"100%"},1500);
		$("#animation .person").delay(100).animate({"opacity":"1"},700);
		$("#animation p").delay(500).animate({"opacity":"1"},2000);
	}
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->