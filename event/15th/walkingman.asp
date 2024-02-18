<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [15주년] 워킹맨 MA
' History : 2016.10.07 원승현
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim eCode, vQuery, nowDate, userid, myAppearCnt, intLoop, intLoop2

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66215
	Else
		eCode   =  73063
	End If

	'// 아이디
	userid = getEncLoginUserid()
	'// 오늘날짜
	nowDate = Left(Now(), 10)

	If IsUserLoginOK() Then
		'// 현재 출석일수 확인
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			myAppearCnt = rsget(0)
		End IF
		rsget.close

		'// 출석일수 한자리일경우는 앞에 0추가
		If Len(Trim(myAppearCnt))=1 Then
			myAppearCnt = CStr("0"&myAppearCnt)
		Else
			myAppearCnt = CStr(myAppearCnt)
		End If
	Else
		myAppearCnt = CStr("00")
	End If

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle	= Server.URLEncode("[채널 teN 15] 워킹맨")
	snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/15th/walkingman.asp")
	snpPre		= Server.URLEncode("10x10")

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] 워킹맨과 함께\n하루에 한걸음씩, 출석체크하고\n다양한 선물에 도전하세요!\n\n지금 텐바이텐에서!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_kakao.jpg"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url 
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	End If

%>

<style type="text/css">
/* teN15th common */
.teN15th .noti {padding:3.5rem 2.5rem; background-color:#eee;}
.teN15th .noti h3 {position:relative; padding:0 0 1.2rem 2.4rem; font-size:1.4rem; line-height:2rem; font-weight:bold; color:#6752ac;}
.teN15th .noti h3:after {content:'!'; display:inline-block; position:absolute; left:0; top:0; width:1.8rem; height:1.8rem; color:#eee; font-size:1.3rem; line-height:2rem; font-weight:bold; text-align:center; background-color:#6752ac; border-radius:50%;}
.teN15th .noti li {position:relative; padding:0 0 0.3rem 0.65rem; color:#555; font-size:1rem; line-height:1.4;}
.teN15th .noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.35rem; height:1px; background-color:#555;}
.teN15th .noti li:last-child {padding-bottom:0;}
.teN15th .shareSns {position:relative;}
.teN15th .shareSns li {position:absolute; right:6.25%; width:31.25%;}
.teN15th .shareSns li.btnKakao {top:21.6%;}
.teN15th .shareSns li.btnFb {top:53.15%;}

.wkMan {background-color:#fff871;}
.wkMan h2 {width:32rem; margin:0 auto;}
.giftBox {position:relative; width:32rem; margin:0 auto;}
.giftBox .countAct {position:absolute; left:-0.3%; top:59%; width:100%; background-color:rgba(255,255,255,0);}
.giftBox .btnGiftView {overflow:hidden; display:block; position:absolute; left:0; top:10%; width:100%; height:45%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/btn_gift_view.png) no-repeat 90% 10%; background-size:20%; text-indent:-999em;}

@keyframes shake {
	0%, 25%, 55%, 100% {transform:translateX(0);}
	10%, 40% {transform:translateY(-2px);}
}
@-webkit-keyframes shake {
	0%, 25%, 55%, 100% {-webkit-transform:translateX(0);}
	10%, 40% {-webkit-transform:translateY(-2px);}
}
.shake {animation:shake 1.2s infinite both; -webkit-animation:shake 1.2s infinite both;}

.myCounting {position:relative; width:32rem; margin:0 auto; padding-bottom:5rem;}
.myCounting p {position:absolute; left:0; top:0; width:100%; text-align:center; color:#000; font-size:1.3rem; vertical-align:middle; font-weight:600; line-height:2.5rem;}
.myCounting p span {padding-left:1rem; font-size:2rem; font-family:helveticaNeue, helvetica, sans-serif !important; font-weight:600; line-height:2rem;}

.boardSection {position:relative; width:32rem; margin:0 auto;}
.walkBoard li {display:table; position:absolute; width:10.7rem; height:8.35rem;}
.walkBoard li div {display:table-cell; position:relative; width:100%; height:100%; vertical-align:middle;}
.walkBoard li div:after {display:none; width:100%; position:absolute; left:0; top:0; bottom:0; content:''; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/bg_day_finish.png) no-repeat 50% 0; background-size:cover;}
.walkBoard li div strong {overflow:hidden; display:block; position:absolute; left:50%; bottom:0.55rem; width:6.5rem; height:11.85rem; margin-left:-3.25rem; text-indent:-999em; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/walkingman.png) no-repeat 50% 100%; background-size:100% auto; z-index:100; opacity:0; filter:alpha(opacity=0);}
.walkBoard li div span {display:block; position:absolute; left:0; right:0; bottom:0; width:100%;}

.walkBoard li.done div:after {display:block; z-index:50;}
.walkBoard li.done div strong {display:none;}
.walkBoard li.done.step03 div p, .walkBoard li.done.step05 div p, .walkBoard li.done.step08 div p,
.walkBoard li.done.step11 div p, .walkBoard li.done.step13 div p, .walkBoard li.done.step15 div p {display:none;}
.walkBoard li.current div strong {display:block; opacity:1; filter:alpha(opacity=100);}
.walkBoard li.current div p {display:none;}
.walkBoard li.current.step00 div p {display:block;}
.walkBoard li.step00 {left:0; top:0; width:10.6rem; background-color:#fff871;}
.walkBoard li.step00 div:after {display:none;}
.walkBoard li.step01 {left:10.6rem; top:0; background-color:#fff;}
.walkBoard li.step02 {left:21.3rem; top:0; background-color:#e9e9e9;}
.walkBoard li.step03 {left:21.3rem; top:8.35rem; height:16.7rem; background-color:#6752ac;}
.walkBoard li.step03 div:after {margin-top:-0.8rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/bg_day03_finish.png) no-repeat 50% 0; background-size:cover;}
.walkBoard li.step03 div span {top:-0.8rem; width:}
.walkBoard li.step04 {left:10.6rem; top:16.7rem; background-color:#fff;}
.walkBoard li.step05 {left:0; top:16.7rem; width:10.6rem; height:16.7rem; background-color:#0fb8d9;}
.walkBoard li.step05 div:after {top:-3.1rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/bg_day05_finish.png) no-repeat 50% 0; background-size:cover;}
.walkBoard li.step05 div span {top:-3.1rem;}
.walkBoard li.step06 {left:0; top:33.4rem; width:10.6rem; background-color:#fff;}
.walkBoard li.step07 {left:10.6rem; top:33.4rem; background-color:#e9e9e9;}
.walkBoard li.step08 {left:21.3rem; top:33.4rem; height:16.7rem; background-color:#ff8d3a;}
.walkBoard li.step08 div:after {top:-1.65rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/bg_day08_finish.png) no-repeat 50% 0; background-size:cover;}
.walkBoard li.step08 div span {top:-1.65rem;}
.walkBoard li.step09 {left:21.3rem; top:50.1rem; background-color:#fff;}
.walkBoard li.step10 {left:10.6rem; top:50.1rem; background-color:#e9e9e9;}
.walkBoard li.step11 {left:0; top:50.1rem; width:10.6rem; height:16.7rem; background-color:#6752ac;}
.walkBoard li.step11 div:after {top:-3.55rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/bg_day11_finish.png) no-repeat 50% 0; background-size:cover;}
.walkBoard li.step11 div span {top:-3.55rem;}
.walkBoard li.step12 {left:0; top:66.8rem; width:10.6rem; background-color:#fff;}
.walkBoard li.step13 {left:10.6rem; top:66.8rem; width:21.4rem; background-color:#0fb8d9;}
.walkBoard li.step13 div:after {top:-5.4rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/bg_day13_finish.png) no-repeat 50% 0; background-size:cover;}
.walkBoard li.step13 div span {top:-5.4rem;}
.walkBoard li.step13 div strong {margin-left:2rem;}
.walkBoard li.step14 {left:21.3rem; top:75.15rem; background-color:#fff;}
.walkBoard li.step15 {left:0; top:83.5rem; width:32rem; background-color:#ff4d40;}
.walkBoard li.step15 div:after {top:-6.25rem;  background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/bg_day15_finish.png) no-repeat 50% 0; background-size:cover;}
.walkBoard li.step15 div span {top:-6.25rem;}

.walkBoard li.step02 div strong, .walkBoard li.step03 div strong,
.walkBoard li.step04 div strong, .walkBoard li.step08 div strong,
.walkBoard li.step09 div strong, .walkBoard li.step10 div strong,
.walkBoard li.step13 div strong, .walkBoard li.step14 div strong,
.walkBoard li.step15 div strong {background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/walkingman2.png) no-repeat 50% 100%; background-size:100% auto;}

.giftView {display:none; position:fixed; top:6% !important; left:50% !important; width:32rem; margin-left:-16rem; z-index:110;}
.giftView .inner {position:relative; width:100%; height:100%;}
.giftView .swiper-container {position:absolute; left:8%; top:20%; width:84%; height:65%; z-index:50;}
.giftView .swiper-wrapper {width:90%;}
.giftView .swiper-wrapper .swiper-slide {width:100%;}
.lyrClose {overflow:hidden; position:absolute; right:3.5rem; top:1.7rem; width:1.5rem; height:1.5rem; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/btn_lyr_close.png) 0 0 no-repeat; background-size:100% 100%; text-indent:-999em; outline:none;}

.giftLyr {display:none; position:fixed; top:10% !important; left:50% !important; width:32rem; margin-left:-16rem; z-index:110;}
.giftLyr > div {position:relative; width:100%; height:100%;}
.giftLyr .lyrClose {right:4.5rem; top:2rem;}
.btnGoLink {display:block; overflow:hidden; position:absolute; left:50%; bottom:5.5%; width:80%; height:20%; margin-left:-40%; text-indent:-999em; outline:none;}
.code {position:absolute; left:0; bottom:2.5rem; width:100%; color:#ccc; text-align:center; font-size:0.75rem; font-family:verdana, tahoma, sans-serif;}

#mask {display:none; position:absolute; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.5);}
</style>
<script type="text/javascript">
var giftScroll;
$(function(){
	$('html,body').animate({scrollTop:$(".teN15th").offset().top}, 0);

	giftScroll = new Swiper('.giftView .swiper-container', {
		scrollbar:'.giftView .swiper-scrollbar',
		direction:'vertical',
		slidesPerView:'auto',
		mousewheelControl:true,
		freeMode:true
	});

	<%'// 현재 맨 위치 계산 %>
	<% for intLoop=0 to 15 %>
		<% if intLoop < 10 then %>
			$("#step0<%=intLoop%>").removeClass('current');
			$("#step0<%=intLoop%>").removeClass('done');
		<% else %>
			$("#step<%=intLoop%>").removeClass('current');
			$("#step<%=intLoop%>").removeClass('done');
		<% end if %>
	<% next %>
	<% for intLoop2=0 to cint(myAppearCnt) %>
		<% if intLoop2 < 10 then %>
			$("#step0<%=intLoop2%>").addClass('done');
		<% else %>
			$("#step<%=intLoop2%>").addClass('done');
		<% end if %>
	<% next %>

	<% if cint(myAppearCnt)=15 then %>
		$(".countAct").attr('disabled','disabled'); 
		$(".countAct").children('img').attr('src','http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/btn_action_finish.png');
		$(".countAct").children('img').attr('alt','출석끝');
		$(".countAct").removeClass('shake');
	<% else %>
		$("#step<%=myAppearCnt%>").removeClass('done');
		$("#step<%=myAppearCnt%>").addClass('current');
	<% end if %>


	// 사은품 모두보기 레이어 노출
	$(".btnGiftView").click(function(){
		$("#giftView").show();
		$("#mask").show();
		var val = $('#giftView').offset();
		$('html,body').animate({scrollTop:val.top+50},200);
		giftScroll.update();
	});

	$("#giftView .lyrClose").click(function(){
		$("#giftView").hide();
		$("#mask").fadeOut();
	});

	$("#mask").click(function(){
		$("#giftView").hide();
		$("#giftLyr").hide();
		$("#mask").fadeOut();
	});

	// 출석하기
	$(".countAct").click(function() {
		<% If not(IsUserLoginOK()) Then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
		<% end if %>

		<% If not(nowDate >= "2016-10-10" and nowDate < "2016-10-25") Then %>
			alert("이벤트 응모기간이 아닙니다.");
			return;
		<% end if %>
		$(".countAct").attr('disabled','disabled').removeClass('shake');
		$('.walkBoard li').each(function(){
			if($(this).hasClass('current')) {
				var nowPos = $(this).index();
				var charPos = $('.walkBoard li.current').next().offset();
				$('html,body').animate({scrollTop:charPos.top-70},900);

				if ((nowPos==0)) {
					<%'// 1로 이동%>
					setAppearAc("ins", nowPos, "nomal1");
				} 
				else if ((nowPos==1)) 
				{
					<%'// 2로 이동%>
					setAppearAc("ins", nowPos, "nomal2");
				} 
				else if ((nowPos==2)) 
				{
					<%'// 3(첫번째 100마일리지 신청)으로 이동%>
					setAppearAc("ins", nowPos, "mileage1");
				} 
				else if ((nowPos==3)) 
				{
					<%'// 4로 이동%>
					setAppearAc("ins", nowPos, "nomal4");

				} 
				else if ((nowPos==4)) 
				{
					<%'// 5(첫번째 경품응모)로 이동%>
					setAppearAc("ins", nowPos, "gift1");

				} 
				else if ((nowPos==5)) 
				{
					<%'// 6으로 이동%>
					setAppearAc("ins", nowPos, "nomal6");
				} 
				else if ((nowPos==6)) 
				{
					<%'// 7으로 이동%>
					setAppearAc("ins", nowPos, "nomal7");
				}
				else if ((nowPos==7)) 
				{
					<%'// 8(cgv 이용권 응모)으로 이동%>
					setAppearAc("ins", nowPos, "cgv");
				}				
				else if ((nowPos==8)) 
				{
					<%'// 9으로 이동%>
					setAppearAc("ins", nowPos, "nomal9");
				} 
				else if ((nowPos==9)) 
				{
					<%'// 10으로 이동%>
					setAppearAc("ins", nowPos, "nomal10");
				} 
				else if ((nowPos==10)) 
				{
					<%'// 11(두번째 100마일리지 신청)으로 이동%>
					setAppearAc("ins", nowPos, "mileage2");
				} 
				else if ((nowPos==11)) 
				{
					<%'// 12로 이동%>
					setAppearAc("ins", nowPos, "nomal12");
				} 
				else if ((nowPos==12)) 
				{
					<%'// 13(두번째 경품응모)으로 이동%>
					setAppearAc("ins", nowPos, "gift2");
				} 
				else if ((nowPos==13)) 
				{
					<%'// 14로 이동%>
					setAppearAc("ins", nowPos, "nomal14");
				} 
				else if ((nowPos==14)) 
				{
					<%'// 15(마지막 500마일리지 신청)로 이동%>
					setAppearAc("ins", nowPos, "mileage3");

					/* 출석하기 버튼 비활성화 */
					$(".countAct").attr('disabled','disabled'); 
					$(".countAct").children('img').attr('src','http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/btn_action_finish.png');
					$(".countAct").children('img').attr('alt','출석끝');
					$(".countAct").removeClass('shake');
					/* 완주 레이어 노출 */
					$("#giftLyr").show();
					$("#mask").show();
				}


				$(this).removeClass('current').addClass('done');
				setTimeout(function(){
					if ((nowPos==14)) {
						$('.walkBoard li').eq(nowPos+1).addClass('done');
					} else {
						$('.walkBoard li').eq(nowPos+1).addClass('current'); /* 다음칸 이동(현재위치에 클래스 current 추가) */
					}
				}, 20);
			}
		});
	});
});

function snschk(snsnum) {

	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}

function setAppearAc(mode, nowpos, act)
{
	<%'// 폼값에 넣음 %>
	$("#mode").val(mode);
	$("#nowpos").val(nowpos);
	$("#act").val(act);

	$.ajax({
		type:"GET",
		url:"/event/15th/doeventsubscript/dowalkingman.asp",
		data: $("#frmAppearPrd").serialize(),
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
							if (mode=="ins")
							{
								if (res[2]!="")
								{
									$("#giftLyr").empty().html(res[2]);
									$("#giftLyr").show();
									$("#mask").show();
								}
								else
								{
									setTimeout(function(){alert("내일 또 걸어주세요!\n다양한 선물이 당신을 기다립니다!");}, 1000);
								}
								$("#dCnt").empty().html(res[1]);
								$(".countAct").attr('disabled',false).addClass('shake');
								return false;
							}
						}
						else
						{
							errorMsg = res[1].replace(">?n", "\n");
							alert(errorMsg);
							parent.location.reload();
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						parent.location.reload();
						return false;
					}
				}
			}
		},
		error:function(jqXHR, textStatus, errorThrown){
			alert("잘못된 접근 입니다.");
			var str;
			for(var i in jqXHR)
			{
				 if(jqXHR.hasOwnProperty(i))
				{
					str += jqXHR[i];
				}
			}
			alert(str);
			parent.location.reload();
			return false;
		}
	});
}

<%'// 경품, cgv영화권 응모 %>
function getAppearGift(mode, nowpos, act)
{
	<%'// 폼값에 넣음 %>
	$("#mode").val(mode);
	$("#nowpos").val(nowpos);
	$("#act").val(act);

	$.ajax({
		type:"GET",
		url:"/event/15th/doeventsubscript/dowalkingman.asp",
		data: $("#frmAppearPrd").serialize(),
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
							if (mode=="gift1")
							{
								$("#giftLyr").empty().html(res[1]);
								$("#giftLyr").show();
								$("#mask").show();
								return false;
							}
							else if (mode=="cgv")
							{
								$("#giftLyr").empty().html(res[1]);
								$("#giftLyr").show();
								$("#mask").show();
								return false;
							}
							else if (mode=="gift2")
							{
								$("#giftLyr").empty().html(res[1]);
								$("#giftLyr").show();
								$("#mask").show();
								return false;
							}
						}
						else
						{
							errorMsg = res[1].replace(">?n", "\n");
							alert(errorMsg);
							parent.location.reload();
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						parent.location.reload();
						return false;
					}
				}
			}
		},
		error:function(jqXHR, textStatus, errorThrown){
			alert("잘못된 접근 입니다.");
			var str;
			for(var i in jqXHR)
			{
				 if(jqXHR.hasOwnProperty(i))
				{
					str += jqXHR[i];
				}
			}
			alert(str);
			parent.location.reload();
			return false;
		}
	});
}

function giftLayerClose()
{
	$("#giftLyr").hide();
	$("#mask").fadeOut();
}
</script>


<div class="teN15th wkMan">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/tit_walkingman.gif" alt="뛰지말고 걸어라! 워킹맨!" /></h2>
	<div class="giftBox">
		<span class="countAct shake"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/btn_action.png" alt="출석하기" /></span>
		<span class="btnGiftView">사은품 보러가기</span>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_gift.jpg" alt="사은품박스" />
	</div>
	<div id="giftView" class="giftView">
		<div class="inner">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_gift_all.jpg" alt="당첨 상품 리스트" /></p>
					</div>
				</div>
				<div class="swiper-scrollbar"></div>
			</div>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/bg_lyr_gift_all_v1.png" alt="당첨 상품 리스트 레이어" />
			<button type="button" class="lyrClose">닫기</button>
		</div>
	</div>
	<div class="myCounting">
		<p>나의 출석일수 <span><strong id="dCnt"><%=myAppearCnt%></strong>일</span></p>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_bar.png" alt="" />
	</div>

	<div class="boardSection">
		<ul class="walkBoard">
			<li class="dayBlock step00 current" id="step00">
				<div>
					<strong>START 지점에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_start.png" alt="START" /></p>
				</div>
			</li>
			<li class="dayBlock step01 " id="step01">
				<div>
					<strong>step01 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day01.png" alt="01" /></p>
				</div>
			</li>
			<li class="dayBlock step02 " id="step02">
				<div>
					<strong>step02 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day02.png" alt="02" /></p>
				</div>
			</li>
			<li class="dayBlock step03 " id="step03">
				<div>
					<strong>step03 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day03.png" alt="100마일리지신청" /></p>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_day03.png" alt="" /></span>
				</div>
			</li>
			<li class="dayBlock step04 " id="step04">
				<div>
					<strong>step04 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day04.png" alt="04" /></p>
				</div>
			</li>
			<li class="dayBlock step05 " id="step05">
				<div>
					<strong>step05 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day05.png" alt="경품응모" /></p>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_day05.png" alt="" /></span>
				</div>
			</li>
			<li class="dayBlock step06 " id="step06">
				<div>
					<strong>step06 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day06.png" alt="06" /></p>
				</div>
			</li>
			<li class="dayBlock step07 " id="step07">
				<div>
					<strong>step07 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day07.png" alt="07" /></p>
				</div>
			</li>
			<li class="dayBlock step08 " id="step08">
				<div>
					<strong>step08 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day08.png" alt="CGV 주말 이용권 응모" /></p>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_day08.png" alt="" /></span>
				</div>
			</li>
			<li class="dayBlock step09 " id="step09">
				<div>
					<strong>step09 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day09.png" alt="09" /></p>
				</div>
			</li>
			<li class="dayBlock step10 " id="step10">
				<div>
					<strong>step10 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day10.png" alt="10" /></p>
				</div>
			</li>
			<li class="dayBlock step11 " id="step11">
				<div>
					<strong>step11 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day11.png" alt="100마일리지신청" /></p>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_day11.png" alt="" /></span>
				</div>
			</li>
			<li class="dayBlock step12 " id="step12">
				<div>
					<strong>step12 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day12.png" alt="12" /></p>
				</div>
			</li>
			<li class="dayBlock step13" id="step13">
				<div>
					<strong>step13 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day13.png" alt="경품응모" /></p>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_day13.png" alt="" /></span>
				</div>
			</li>
			<li class="dayBlock step14" id="step14">
				<div>
					<strong>step14 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day14.png" alt="14" /></p>
				</div>
			</li>
			<li class="dayBlock step15" id="step15">
				<div>
					<strong>step15 에 워킹맨이 있습니다.</strong>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/txt_day15.png" alt="500마일리지 신청" /></p>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_day15.png" alt="" /></span>
				</div>
			</li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_board_v1.png" alt="walkBoard" /></p>
	</div>

	<!-- layer -->
	<div id="giftLyr" class="giftLyr"></div>
	<div id="mask"></div>

	<!-- 이벤트 유의사항 -->
	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>본 이벤트는 ID당 하루에 한 번 다음 칸으로 이동할 수 있습니다.</li>
			<li>경품응모를 하지 않고 팝업 창을 닫았을 시(오류로 인한 종료포함) 다시 응모할 수 없습니다.</li>
			<li>당첨된 상품 및 마일리지는 10월 26일(수요일) 일괄 배송 혹은 지급예정입니다.</li>
			<li>5만원 이상의 상품에 당첨되신 분께는 세무신고를 위해 개인정보를 요청할 수 있으며, 제세공과금은 텐바이텐 부담입니다.</li>
			<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택할 수 없습니다.</li>
			<li>경품을 통해 받은 사은품은 재판매 혹은 현금성 거래가 불가 합니다.</li>
		</ul>
	</div>

	<!-- SNS 공유 -->
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/txt_share.png" alt="텐바이텐 15주년 이야기, 친구와 함께라면!" /></p>
		<ul>
			<li class="btnKakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_kakao.png" alt="텐바이텐 15주년 이야기 카카오톡으로 공유" /></a></li>
			<li class="btnFb"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_facebook.png" alt="텐바이텐 15주년 이야기 페이스북으로 공유" /></a></li>
		</ul>
	</div>

	<!-- 하단 배너 -->
	<ul class="tenSubNav bgGry">
		<li class="tPad1-5r"><a href="eventmain.asp?eventid=73064"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_discount.png" alt="비정상할인" /></a></li>
		<li class="tPad1r"><a href="eventmain.asp?eventid=73068"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_gift.png" alt="사은품을 부탁해" /></a></li>
		<li class="tPad1r"><a href="eventmain.asp?eventid=73053"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_main.png" alt="텐바이텐 15주년 이야기" /></a></li>
	</ul>
	<!--// 하단 배너 -->

</div>
<form name="frmAppearPrd" id="frmAppearPrd" method="get">
	<input type="hidden" name="mode" id="mode">
	<input type="hidden" name="nowpos" id="nowpos">
	<input type="hidden" name="act" id="act">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->