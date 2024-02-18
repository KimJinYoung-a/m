<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.09.10 유태욱 생성
'	Description : 봉투맨
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim tempcnt, ref
	dim nowdate, LoginUserid
	Dim eCode, sqlstr, cnt, realcnt, i, contemp, evtimagenum
	Dim result1, result2, result3
	Dim pdName1, pdName2, pdName3, pdName4
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3, evtItemCnt4
	Dim evtItemCode1, evtItemCode2, evtItemCode3, evtItemCode4

	ref = requestcheckvar(request("ref"),2)
	
	nowdate = now()
''	nowdate = "2015-09-14 10:10:00"

	LoginUserid = GetEncLoginUserID()

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64882
	Else
		eCode   =  66085
	End If

	pdName1 = "1등 10만gift"
	evtItemCode1 = "1111111"
	evtItemCnt1 = 1

	pdName2 = "2등 1만gift"
	evtItemCode2 = "2222222"
	evtItemCnt2 = 35

	pdName3 = "3등 500마일"
	evtItemCode3 = "3333333"
	evtItemCnt3 = 1500

	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
		result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

	tempcnt=1536

	'// 남은 상품 수량
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close
	realcnt = Cint(tempcnt)-Cint(cnt)
'	cnt=500
	
	'// 실시간 당첨자 id
	sqlstr = "SELECT top 5 userid, regdate"
	sqlstr = sqlstr & " From [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0 "
	sqlstr = sqlstr & " order by regdate desc"
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		contemp = rsget.getrows()
	END IF
	rsget.close
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66085 {position:relative;}
.selectBag {overflow:hidden; position:relative;}
.selectBag .openDrawer {position:absolute; left:0; top:0; width:100%; margin-top:-77.5%;}
.selectBag .openDrawer .btnBag {position:absolute; width:33%; background:transparent; vertical-align:top;}
.selectBag .openDrawer .bag01 {left:18%; top:12%;}
.selectBag .openDrawer .bag02 {left:48.5%; top:21.5%;}
.realTimeWinner {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66085/01/bg_pattern.gif) repeat 0 0; background-size:7.8% auto;}
.realTimeWinner .winnerIs {position:relative;}
.realTimeWinner .deco {display:block; width:100%; margin-bottom:-1.5%;}
.realTimeWinner .btnMore {position:absolute; right:0; top:8px; width:33px; height:33px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_more_down.png) no-repeat 50% 50%; background-size:23px 23px; text-indent:-999em; outline:none;}
.realTimeWinner .btnMore.fold {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_more_up.png);}
.realTimeWinner h3 {position:absolute; left:0; top:0; width:73px;}
.realTimeWinner li {width:100%; font-size:10px; color:#000;}
.realTimeWinner li div {display:table-cell; width:100%; height:50px; padding:3px 0 0 86px; vertical-align:middle;}
.realTimeWinner li:nth-child(odd) {background:rgba(230,219,197,.4);}
.realTimeWinner li:first-child {background:url(http://webimage.10x10.co.kr/eventIMG/2015/66085/01/bg_gradation.png) 0 100% no-repeat; background-size:100% auto;}
.realTimeWinner li .winner {font-size:13px; margin-bottom:4px;}
.realTimeWinner li .winner strong {display:inline-block; line-height:11px; font-weight:normal; color:#b30000; border-bottom:1px solid #b30000;}
.evtNoti {padding:6.5% 5.2%; text-align:left; background:#fff7ec;}
.evtNoti h3 {display:inline-block; font-size:15px; font-weight:bold; padding-bottom:1px; color:#490900; border-bottom:2px solid #490900; margin-bottom:12px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.4; padding:0 0 3px 8px; color:#444; }
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#490900; border-radius:50%;}

/* layer popup */
.bagLayer .bagLayerCont {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.7);}
.bagLayer .bagLayerCont .myBag {position:relative; padding-left:4.7%; padding-right:4.7%;}
.bagLayer .talk {padding-top:16%;}
.bagLayer .talk .myBag .btnGoBag {display:block; position:absolute; left:12%; bottom:5%; width:76%; }
.bagLayer .result {display:none;}
.bagLayer .result .btnClose {display:inline-block; position:absolute; right:6%; top:10%; width:7.5%; background:transparent; z-index:100;}
.bagLayer .result .btnConfirm {display:inline-block; position:absolute; left:13%; bottom:4%; width:74%; height:13%; background:transparent; z-index:100; font-size:0; color:transparent;}
.bagLayer .wincode {position:absolute; left:13%; bottom:1.8%; width:74%; text-align:center; font-size:10px; line-height:1; color:#333;}
@media all and (min-width:480px){
	.realTimeWinner .btnMore {top:12px; width:44px; height:44px; background-size:35px 35px;}
	.realTimeWinner h3 {width:101px;}
	.realTimeWinner li {font-size:15px;}
	.realTimeWinner li div {height:75px; padding:4px 0 0 129px;}
	.realTimeWinner li .winner {font-size:20px; margin-bottom:6px;}
	.realTimeWinner li .winner strong {line-height:17px; border-bottom:2px solid #b30000;}
	.evtNoti h3 {font-size:23px; border-bottom:3px solid #490900; margin-bottom:18px;}
	.evtNoti li {font-size:17px; padding:0 0 4px 12px;}
	.evtNoti li:after {top:6px; width:4px; height:4px;}
	.bagLayer .wincode {font-size:15px;}
}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javascript">
$(function(){
	window.parent.$('html,body').animate({scrollTop:75}, 300);
	// 실시간 당첨자
	$('.realTimeWinner li').hide();
	$('.realTimeWinner li:first').show();
	$('.realTimeWinner .btnMore').click(function(){
		if ($(this).hasClass('fold')){
			$(this).removeClass('fold');
			$('.realTimeWinner li:gt(0)').slideUp(500);
		} else {
			$(this).addClass('fold');
			$('.realTimeWinner li:gt(0)').slideDown(500);
		}
	});
	function moveBag01 () {
		$(".bag01").animate({"margin-top":"10px"},300).animate({"margin-top":"0"},300, moveBag01);
	}
	function moveBag02 () {
		$(".bag02").delay(400).animate({"margin-top":"10px"},300).animate({"margin-top":"0"},300, moveBag02);
	}
	// 서랍 열기
	$('.btnGoBag').click(function(){
		$('.bagLayer .talk').hide();
		$('.selectBag').find('.openDrawer').delay(150).animate({"margin-top":"0"},1000);
		$('.selectBag .bag01 img').delay(900).effect( "shake", { direction: "up", times:2, distance:10}, 900 );
		$('.selectBag .bag02 img').delay(1500).effect( "shake", { direction: "up", times:2, distance:10}, 900 );
	});
	<% if ref = "ok" then %>
		$('.bagLayer .talk').hide();
		$('.selectBag').find('.openDrawer').delay(150).animate({"margin-top":"0"},1000);
		$('.selectBag .bag01 img').delay(900).effect( "shake", { direction: "up", times:2, distance:10}, 900 );
		$('.selectBag .bag02 img').delay(1500).effect( "shake", { direction: "up", times:2, distance:10}, 900 );
		window.parent.$('html,body').animate({scrollTop:650}, 300);
	<% end if %>
});

function fnClosemask(){
	$('.bagLayer .result').hide();
	$('.mask').hide();
	$("#viewResult").empty();
//	document.location.reload();
	<% If isapp="1" Then %>
		document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>&ref=ok";
	<% else %>
		document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>&ref=ok";
	<% end if %>
}

function goLostFound(){
//alert("시스템 오류 입니다");
//return false;
<% If left(nowdate,10)>="2015-09-14" and left(nowdate,10)<"2015-09-23" Then %>
	<% If IsUserLoginOK Then %>
		<% if result1 <> "" then %>
			alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
			return false;
		<% else %>
			$.ajax({
				type:"POST",
				url:"/event/etc/doeventsubscript/doEventSubscript66085.asp",
		        data: $("#frmEvt").serialize(),
		        dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data)
								{
									 if(Data.hasOwnProperty(i))
									{
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK")
								{
									$("#viewResult").empty().html(res[1]);
									$('.bagLayer .result').show();
									window.parent.$('html,body').animate({scrollTop:60}, 300);
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg );
									$(".mask").hide();
									//document.location.reload();
									<% If isapp="1" Then %>
										document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
									<% else %>
										document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
									<% end if %>
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								//document.location.reload();
								<% If isapp="1" Then %>
									document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
								<% else %>
									document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
								<% end if %>
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다!");
					//document.location.reload();
					<% If isapp="1" Then %>
						document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
					<% else %>
						document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
					<% end if %>
					return false;
				}
			});
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End If %>
<% else %>
	alert('이벤트 기간이 아닙니다!');
	return;
<% end if %>
}

<%''카카오 친구 초대%>
function kakaosendcall(){
//alert("시스템 오류 입니다");
//return false;
	<% If IsUserLoginOK Then %>
		<% If left(nowdate,10)>="2015-09-14" and left(nowdate,10)<"2015-09-23" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url:"/event/etc/doeventsubscript/doEventSubscript66085.asp",
				data: "mode=kakao",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				// success
				<% If isapp="1" Then %>
					parent_kakaolink('[텐바이텐] 봉.투.맨\n\n당신의 선택이\n올 추석 보너스를 결정한다!\n\n텐바이텐 부장님의\n서랍 속 봉투를 확인해 보세요!\n\n최대 10만원의 보너스가\n당신을 기다립니다.\n\n지금 도전하세요!\n오직 텐바이텐에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/66085/bnr_kakao01.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
					return false;
				<% else %>
					parent_kakaolink('[텐바이텐] 봉.투.맨\n\n당신의 선택이\n올 추석 보너스를 결정한다!\n\n텐바이텐 부장님의\n서랍 속 봉투를 확인해 보세요!\n\n최대 10만원의 보너스가\n당신을 기다립니다.\n\n지금 도전하세요!\n오직 텐바이텐에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/66085/bnr_kakao01.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=<%= eCode %>' );
					return false;
				<% end if %>
			}else{
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End If %>
}

function fnbannerop(){
	<% If isapp="1" Then %>
		location.href = "/apps/appcom/wish/web2014/event/gnbeventmain.asp?eventid=65724";
		//fnAPPclosePopup();
		//callmain();
		//setTimeout("seltopmenu('hangawi')",300);
		//seltopmenu('hangawi');
		//setTimeout("fnAPPselectGNBMenu('hangawi','/event/eventmain.asp?eventid=65724')",500);
		//fnAPPselectGNBMenu('hangawi','/event/eventmain.asp?eventid=65724');
	<% else %>
		location.href = "/event/gnbeventmain.asp?eventid=65724";
	<% end if %>
}
</script>
	<!-- 봉투맨 -->
	<div class="mEvt66085">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/tit_bag_man.gif" alt="봉투맨 - 서랍 속 봉투를 확인해 보세요! 최대 10만원의 보너스를 드립니다!" /></h2>
		<!-- 봉투 선택하기 -->
		<div class="selectBag">
			<div class="openDrawer">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/txt_select.png" alt="아래 봉투 중 하나만 골라주세요!" /></p>
				<button type="button" onclick="goLostFound();return false;" class="btnBag bag01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_bag01.png" alt="첫번째 봉투" /></button>
				<button type="button" onclick="goLostFound();return false;" class="btnBag bag02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_bag02.png" alt="두번째 봉투" /></button>
			</div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/bg_bottom.gif" alt="" /></div>
		</div>
		<!--// 봉투 선택하기 -->
		<!-- 실시간 당첨소식 -->
		<div class="realTimeWinner" id="realuser">
			<span class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/bg_paper.png" alt="" /></span>
			<div class="winnerIs">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/txt_bonus_win.png" alt="보너스 당첨소식" /></h3>
				<button type="button" class="btnMore">더보기</button>
				<ul>
				<% if isarray(contemp) then %>
					<% for i = 0 to ubound(contemp,2) %>
						<li>
							<div>
								<p class="winner"><strong><%= printUserId(Left(contemp(0,i),10),2,"*")%>님</strong>이 보너스를 받았습니다.</p>
								<span class="date"><%= Left(contemp(1,i),22) %></span>
							</div>
						</li>
					<% next %>
				<% else %>
					<li>
						<div>
							<p class="winner">아직 보너스 당첨자가 없습니다.</p>
						</div>
					</li>
				<% end if %>
				</ul>
			</div>
		</div>
		<!--// 실시간 당첨소식 -->
		<div><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_kakao.gif" alt="친구에게 봉투맨 알려주기!" /></a></div>
		<div><a href="" onclick="fnbannerop(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/bnr_thanksgiving.gif" alt="한가위만 같아라 - 추석 기획전 바로가기" /></a></div>
		<!--<div><a href="" onclick="fnAPPclosePopup(); setTimeout("seltopmenu('hangawi')",300); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/bnr_thanksgiving.gif" alt="한가위만 같아라 - 추석 기획전 바로가기" /></a></div>-->
		<div class="evtNoti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
				<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
				<li>본 이벤트는 ID당 1일 1회만 응모가능 합니다.</li>
				<li>본 이벤트는 주말(토, 일)에는 진행되지 않습니다.</li>
				<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
			</ul>
		</div>

		<div class="bagLayer">
			<!-- 카카오톡 대화 화면 -->
			<div class="bagLayerCont talk">
				<div class="myBag">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/txt_kakao_talk.gif" alt="얼마 남지 않은 추석! 부장님이 나를 부르셨다" /></p>
					<button type="button" class="btnGoBag"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_go_confirm.gif" alt="확인하러 가기" /></button>
				</div>
			</div>
			<!--// 카카오톡 대화 화면 -->
			<div class="bagLayerCont result" id="viewResult">
			</div>
		</div>
	</div>
<form method="post" name="frmEvt" id="frmEvt">
	<input type="hidden" name="mode" id="mode" value="add">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->