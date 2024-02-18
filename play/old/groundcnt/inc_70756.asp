<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 30-3 M/A 유형선택
' History : 2016-05-14 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid , strSql , totcnt , pagereload , totcntall
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66130
Else
	eCode   =  70756
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 페스티벌에서 나의 유형 Test & Tip")
snpLink = Server.URLEncode("http://m.10x10.co.kr/play/playGround.asp?idx=1397&contentsidx=124")
snpPre = Server.URLEncode("텐바이텐")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#텐바이텐 #10x10 #뷰티풀민트라이프")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐]나의 유형을 알아봐형\n\n페스티벌에 어떤 옷을 입을지,\n뭘 가져갈 지 고민하셨던 분들!\n\n당신은 페스티벌에서\n어떤 유형인가요?\n\n텐바이텐이 준비한 테스트를 통해 여러분의 유형을 알아보세요!\n\n유형별 맞춤 아이템과 팁도 준비했으니 페스티벌을 알차게 보내보아요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/playmo/ground/20160516/img_kakao.png"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1397&contentsidx=124"
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1397&contentsidx=124"
	end If

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.myType button {background-color:transparent;}

.myType .topic {position:relative;}
.myType .topic .btnStart {display:block; position:absolute; bottom:8.5%; left:50%; width:23.43%; margin-left:-11.715%;}

.myType .test .question {position:relative;}
.myType .test .question .btngroup {overflow:hidden; position:absolute; top:35.33%; left:0; width:100%;}
.myType .test .question .btngroup button {float:left; width:37.66%; margin:0 6.17%; padding-bottom:1%;}

.resultWrap {padding-bottom:9%; background:#0dadbb url(http://webimage.10x10.co.kr/playmo/ground/20160516/bg_blue.png) repeat-y 50% 0; background-size:100% auto;}
.item {position:relative; padding:0 5%;}
.item .btnPlus {position:absolute; bottom:-5%; right:3%; width:13.93%;}
.item ul {position:absolute; top:5%; left:26%; width:63%;}
.item ul li {float:left; width:33.333%;}
.item ul li a {overflow:hidden; display:block; position:relative; height:0; margin-right:5%; padding-bottom:120%; color:transparent; font-size:12px; line-height:12px; text-align:center;}
.item ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.result2 .item ul {left:30%;}
.result3 .item ul {left:21%; width:70%;}
.result3 .item ul li a {padding-bottom:110%;}
.result4 .item ul {left:21%; width:70%;}
.result4 .item ul li a {padding-bottom:110%;}

.sns {margin-top:9%;}
.sns ul {overflow:hidden; padding:0 2%;}
.sns ul li {float:left; width:50%;}
.sns ul li a {display:block; margin:0 5%;}

.ranking {padding-bottom:15%; background:#077b53 url(http://webimage.10x10.co.kr/playmo/ground/20160516/bg_green.png) repeat-y 50% 0; background-size:100% auto;}
.ranking ul {width:82.18%; margin:0 auto;}
.ranking ul li {position:relative; height:3.7rem; border-radius:15rem; margin-top:5%; background:url(http://webimage.10x10.co.kr/playmo/ground/20160516/bg_ranking.png) 0 0 no-repeat; background-size:100% 100%;*/}
.ranking ul li:after {content:''; display:inline-block; position:absolute; left:0; top:50%; width:4.3rem; height:4.3rem; margin-top:-2.15rem; background-size:100% 100%;}
.ranking ul li:first-child {margin-top:0;}
.ranking ul li:nth-child(1):after {background-image:url(http://webimage.10x10.co.kr/play/ground/20160516/txt_raking_01.png);}
.ranking ul li:nth-child(2):after {background-image:url(http://webimage.10x10.co.kr/play/ground/20160516/txt_raking_02.png);}
.ranking ul li:nth-child(3):after {background-image:url(http://webimage.10x10.co.kr/play/ground/20160516/txt_raking_03.png);}
.ranking ul li:nth-child(4):after {background-image:url(http://webimage.10x10.co.kr/play/ground/20160516/txt_raking_04.png);}
.ranking ul li div {position:relative; min-width:46%; height:3.7rem;  background:#adf3db; border-radius:15rem;}
.ranking ul li p {color:#0b583e; font-size:1.2em; line-height:1.5em; line-height:3.7rem; text-align:left;}
.ranking ul li span {position:absolute; left:4.7rem; top:0.1rem;}
.ranking ul li b {position:absolute; top:0.1rem; right:1rem; font-weight:bold;}

.bounce {animation-name:bounce; animation-iteration-count:5; animation-duration:0.8s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:0.8s;}
@keyframes bounce {
	from, to{margin-bottom:0; animation-timing-function:linear;}
	50% {margin-bottom:5px; animation-timing-function:linear;}
}

@-webkit-keyframes bounce {
	from, to{margin-bottom:0; -webkit-animation-timing-function:linear;}
	50% {margin-bottom:5px; -webkit-animation-timing-function:linear;}
}
</style>
<script type="text/javascript">
$(function(){
	/* 더블클릭시 최상단으로 이동 이벤트 없애기 */
	$(document).unbind("dblclick").dblclick(function () {});

	/* skip to test */
	$("#btnStart").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},300);
	});

	// 테스트 시작
	$("#test .question").hide();
	$("#test .question:first").show();
	$("#test .question button").on("click", function(e){
		<% if Not(IsUserLoginOK) then %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsevtlogin();
				return false;
			<% end if %>
			return false;
		<% end if %>
		<% if not(left(now(), 10)>="2016-05-14" And left(now(), 10) < "2016-07-01") then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% end if %>

		$("#test .question").hide();
		$(this).parent(".btngroup").parent(".question").next().show();
	});

	$('.question .resultWrap').hide();
});

function fnAnswerChk(qNo, Ans)
{
	if (qNo=="1")
	{
		$("#qAnswer").val(Ans);
	}
	else if (qNo=="4")
	{
		$("#qAnswer").val($("#qAnswer").val().substr(0, qNo-1));
		$("#qAnswer").val($("#qAnswer").val()+Ans);
		if (!$("#qAnswer").val().length==qNo)
		{
			alert("순서대로 TEST에 응모해주세요.");
			return false;
		}
		<% if Not(IsUserLoginOK) then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				parent.jsevtlogin();
				return false;
			<% end if %>
			return false;
		<% end if %>
		<% if not(left(now(), 10)>="2016-05-14" And left(now(), 10) < "2016-07-01") then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% end if %>

		$.ajax({
			type:"GET",
			url:"/play/groundcnt/doEventSubscript70756.asp",
	        data: $("#frmSbS").serialize(),
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
								$('#result'+res[1]).show();
								showRankingData();
								window.parent.$('html,body').animate({scrollTop:$("#resultpov").offset().top},300);
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg );
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
	else
	{
		$("#qAnswer").val($("#qAnswer").val().substr(0, qNo-1));
		$("#qAnswer").val($("#qAnswer").val()+Ans);
		if (!$("#qAnswer").val().length==qNo)
		{
			alert("순서대로 TEST에 응모해주세요.");
			return false;
		}
	}
}

function showRankingData()
{
	$.ajax({
		type:"GET",
		url:"/play/groundcnt/doEventSubscript70756.asp?mode=ranking",
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
							$('#rankingData').empty().html(res[1]);
							$('.ranking').show();
						}
						else
						{
							errorMsg = res[1].replace(">?n", "\n");
							alert(errorMsg );
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
</script>
<div class="mPlay20160516 myType">
	<article>
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/tit_my_type.png" alt="나의 유형을 알아봐형 My type" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_my_type.png" alt="페스티벌에 어떤 옷을 입을지, 무엇을 가져가야 할지 항상 고민하셨던 분들!! 당신은 페스티벌에서 어떤 유형인가요? 텐바이텐이 준비한 테스트를 통해 여러분의 유형을 알아보세요! 유형별 맞춤 아이템과 팁도 준비했으니 페스티벌을 알차게 보내보아요!" /></p>
			<a href="#test" id="btnStart" class="btnStart bounce"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_start.png" alt="테스트 시작하기" /></a>
		</div>
		<div id="resultpov"></div>

		<%' test %>
		<div id="test" class="test">
			<%' question %>
			<div class="question question1">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_test_question_01.png" alt="즐겨 듣는 음악은?" /></p>
				<div class="btngroup">
					<button type="button" onclick="fnAnswerChk('1','A');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_choice_01_a.png" alt="신나는 댄스 음악" /></button>
					<button type="button" onclick="fnAnswerChk('1','B');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_choice_01_b.png" alt="잔잔한 어쿠스틱 음악" /></button>
				</div>
			</div>
			<div class="question question2">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_test_question_02.png" alt="주로 올리는 포스팅은?" /></p>
				<div class="btngroup">
					<button type="button" onclick="fnAnswerChk('2','A');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_choice_02_a.png" alt="#먹스타그램" /></button>
					<button type="button" onclick="fnAnswerChk('2','B');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_choice_02_b.png" alt="#셀스타그램" /></button>
				</div>
			</div>
			<div class="question question3">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_test_question_03.png" alt="기분이 좋지 앟을 때는?" /></p>
				<div class="btngroup">
					<button type="button" onclick="fnAnswerChk('3','A');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_choice_03_a.png" alt="음악에 맞춰 맘껏 뛰기" /></button>
					<button type="button" onclick="fnAnswerChk('3','B');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_choice_03_b.png" alt="먹고 또 먹고" /></button>
				</div>
			</div>
			<div class="question question4">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_test_question_04.png" alt="시간 날때 누구와?" /></p>
				<div class="btngroup">
					<button type="button" onclick="fnAnswerChk('4','A');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_choice_04_a.png" alt="혼자가 좋아" /></button>
					<button type="button" onclick="fnAnswerChk('4','B');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_choice_04_b.png" alt="친구와 수다떨기" /></button>
				</div>
			</div>

			<%' result %>
			<div class="question resultWrap">
				<%' 뛰뛰방방형 %>
				<div class="result result1" id="result1" style="display:none;">
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_test_result_01.gif" alt="뛰고 뛰고, 방방 또 뛰자! 당신은 뛰뛰방방형 페스티벌에서는 역시 뛰어야 제맛! 두 손 가볍게 필요한 소품만 담을 수 있는 크로스백은 필수! 화려한 패턴의 힙색도 느낌 있게 연출 가능! 오래 뛰어다닐 당신을 위해 편안한 샌들도 꼭 챙기자. 단, 스타일까지 포기하면 안 돼!" /></p>

					<div class="item">
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/img_item_01.png" alt="이런건 어때?" /></p>
						<% If isapp = "1" Then %>
						<ul>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1045290&amp;pEtr=70756" onclick="fnAPPpopupProduct(1045290);return false;"><span></span>poster side bag denim</a></li>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1075746&amp;pEtr=70756" onclick="fnAPPpopupProduct(1075746);return false;"><span></span>weekade let&apos;s waist bag</a></li>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1272166&amp;pEtr=70756" onclick="fnAPPpopupProduct(1272166);return false;"><span></span>츄바스코 게레로</a></li>
						</ul>
						<div class="btnPlus bounce">
							<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=70756#group179243" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=70756#group179243');"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_plus.png" alt="뛰뛰방방형 상품 더보기" /></a>
						</div>
						<% Else %>
						<ul>
							<li><a href="/category/category_itemPrd.asp?itemid=1045290&amp;pEtr=70756" target="_blank" title="새창"><span></span>poster side bag denim</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1075746&amp;pEtr=70756" target="_blank" title="새창"><span></span>weekade let&apos;s waist bag</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1272166&amp;pEtr=70756" target="_blank" title="새창"><span></span>츄바스코 게레로</a></li>
						</ul>
						<div class="btnPlus bounce">
							<a href="/event/eventmain.asp?eventid=70756#group179243" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_plus.png" alt="뛰뛰방방형 상품 더보기" /></a>
						</div>
						<% End If %>
					</div>
				</div>

				<%' 유유자적형 %>
				<div class="result result2"  id="result2" style="display:none;">
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_test_result_02.gif" alt="이곳에 내 한 몸 뉘련다 당신은 유유자적형 잔디밭에 누워 하늘을 보며 노래를 들을 때 피크닉 매트와 포근한 담요까지 있다면 금상첨화 햇빛과 주위사람에게 방해받고 싶지 않다면 귀여운 안대 착용을 추천! 사르르 잠에 드는 순간, 쌓였던 피로가 싹 가실걸?" /></p>

					<div class="item">
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/img_item_02.png" alt="이런건 어때?" /></p>
						<% If isapp = "1" Then %>
						<ul>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1118175&amp;pEtr=70756" onclick="fnAPPpopupProduct(1118175);return false;"><span></span>피크닉 타월</a></li>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1088289&amp;pEtr=70756" onclick="fnAPPpopupProduct(1088289);return false;"><span></span>오아시스피크닉매트</a></li>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=682897&amp;pEtr=70756" onclick="fnAPPpopupProduct(682897);return false;"><span></span>New Eye Mask 수면안대</a></li>
						</ul>
						<div class="btnPlus bounce">
							<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=70756#group179245" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=70756#group179245');"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_plus.png" alt="유유자적형 상품 더보기" /></a>
						</div>
						<% Else %>
						<ul>
							<li><a href="/category/category_itemPrd.asp?itemid=1118175&amp;pEtr=70756" target="_blank" title="새창"><span></span>피크닉 타월</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1088289&amp;pEtr=70756" target="_blank" title="새창"><span></span>오아시스피크닉매트</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=682897&amp;pEtr=70756" target="_blank" title="새창"><span></span>New Eye Mask 수면안대</a></li>
						</ul>
						<div class="btnPlus bounce">
							<a href="/event/eventmain.asp?eventid=70756#group179245" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_plus.png" alt="유유자적형 상품 더보기" /></a>
						</div>
						<% End If %>
					</div>
				</div>

				<%' 간지나는형 %>
				<div class="result result3" id="result3" style="display:none;">
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_test_result_03.gif" alt="이 구역에 간지는 바로 나야! 당신은 간지나는형 1일 1셀카 하는 당신을 위해 셀카 렌즈를 추천! 차별화된 인증샷에는 데코 용품들이 필요하겠지? 함께 가는 친구들과 트윈룩으로 맞춰 입고 화관, 꽃팔찌, 선글라스 등으로 한껏 멋을 낸다면 남들도 부러워 할껄?" /></p>

					<div class="item">
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/img_item_03.png" alt="이런건 어때?" /></p>
						<% If isapp = "1" Then %>
						<ul>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1246002&amp;pEtr=70756" onclick="fnAPPpopupProduct(1246002);return false;"><span></span>셀카렌즈</a></li>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1354437&amp;pEtr=70756" onclick="fnAPPpopupProduct(1354437);return false;"><span></span>써커스보이밴드 스트라이프 티</a></li>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1196210&amp;pEtr=70756" onclick="fnAPPpopupProduct(1196210);return false;"><span></span>꽃팔찌</a></li>
						</ul>
						<div class="btnPlus bounce">
							<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=70756#group179246" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=70756#group179246');"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_plus.png" alt="간지나는형 상품 더보기" /></a>
						</div>
						<% Else %>
						<ul>
							<li><a href="/category/category_itemPrd.asp?itemid=1246002&amp;pEtr=70756" target="_blank" title="새창"><span></span>셀카렌즈</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1354437&amp;pEtr=70756" target="_blank" title="새창"><span></span>써커스보이밴드 스트라이프 티</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1196210&amp;pEtr=70756" target="_blank" title="새창"><span></span>꽃팔찌</a></li>
						</ul>
						<div class="btnPlus bounce">
							<a href="/event/eventmain.asp?eventid=70756#group179246" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_plus.png" alt="간지나는형 상품 더보기" /></a>
						</div>
						<% End If %>
					</div>
				</div>

				<%' 쳐묵쳐묵형 %>
				<div class="result result4" id="result4" style="display:none;">
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/txt_test_result_04.gif" alt="먹을 건 배신 하지 않는다 당신은 쳐묵쳐묵형 어딜 가나 먹을 것을 잔뜩 챙겨 다니는 야무진 당신 꼭 한 번 만나고 싶다! 완전 우리 스타일! 음료를 차갑게 유지시켜줄 쿨러와 보냉백은 필수지! 밤이 되면 더 잘 먹을 수 있게 랜턴도 준비하자 우리의 밤은 쳐묵쳐묵으로 빛나리!" /></p>

					<div class="item">
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/img_item_04.png" alt="이런건 어때?" /></p>
						<% If isapp = "1" Then %>
						<ul>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1320364&amp;pEtr=70756" onclick="fnAPPpopupProduct(1320364);return false;"><span></span>쿨헬퍼</a></li>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1296243&amp;pEtr=70756" onclick="fnAPPpopupProduct(1296243);return false;"><span></span>토트백</a></li>
							<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1284635&amp;pEtr=70756" onclick="fnAPPpopupProduct(1284635);return false;"><span></span>랜턴</a></li>
						</ul>
						<div class="btnPlus bounce">
							<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=70756#group179248" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=70756#group179248');"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_plus.png" alt="쳐묵쳐묵형 상품 더보기" /></a>
						</div>
						<% Else %>
						<ul>
							<li><a href="/category/category_itemPrd.asp?itemid=1320364&amp;pEtr=70756" target="_blank" title="새창"><span></span>쿨헬퍼</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1296243&amp;pEtr=70756" target="_blank" title="새창"><span></span>토트백</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1284635&amp;pEtr=70756" target="_blank" title="새창"><span></span>랜턴</a></li>
						</ul>
						<div class="btnPlus bounce">
							<a href="/event/eventmain.asp?eventid=70756#group179248" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_plus.png" alt="쳐묵쳐묵형 상품 더보기" /></a>
						</div>
						<% End If %>
					</div>
				</div>

				<%' sns %>
				<div class="sns">
					<ul>
						<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_sns_facebook.png" alt="나의 유형을 알아봐형 My type 페이스북으로 공유하기" /></a></li>
						<li><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160516/btn_sns_kakao.png" alt="나의 유형을 알아봐형 My type 카카오톡으로 공유하기" /></a></li>
					</ul>
				</div>
			</div>
		</div>

		<%' ranking %>
		<%' for dev msg : 테스트 후 보여주세요 %>
		<div class="ranking" id="rankingData" style="display:none;"></div>

	</article>
</div>
<form method="post" name="frmSbS" id="frmSbS">
	<input type="hidden" name="qAnswer" id="qAnswer">
	<input type="hidden" name="mode" value="add">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->