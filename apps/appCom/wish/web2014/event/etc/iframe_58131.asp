<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 별에서 온 운세 (mobile)
' History : 2014.12.26 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->


<%


dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode, prevEventJoinChk, EventJoinChk, usrSelectItemid, preveCode, sqlStr, vScope
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	vScope = requestCheckVar(Request("vScope"),200)
	
	IF application("Svr_Info") = "Dev" Then
		eCode = "21421"
		vLinkECode = "21423"
	Else
		eCode = "58020"
		vLinkECode = "58131"
	End If

	If IsUserLoginOK Then
		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' And  convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"' "
		rsget.Open sqlStr, dbget, 1
			EventJoinChk = rsget(0) '// 현재 이벤트 참여여부
		rsget.Close
	End If
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
img {vertical-align:top;}
.constellation {background:url(http://webimage.10x10.co.kr/eventIMG/2014/58021/bg_cont.gif) left top no-repeat #464b69; background-size:100% auto;}
.constellation .selectBirth {width:90%; padding:25px; margin:0 auto; background:#3c415e; border-radius:50px;}
.constellation .selectBirth select {width:100%; border:0; border-radius:0; background-image: url(http://webimage.10x10.co.kr/eventIMG/2014/58021/element_select.png); }
.constellation .section {display:none;}
.constellation .consView {padding:0 5% 25px;}
.myFortune {padding-top:25px;}
.myFortune li {padding-bottom:30px; margin-bottom:25px; background:#f6eedf;}
.myFortune li p {width:85%; margin:0 auto; padding-top:10px; font-size:11px; line-height:1.4; color:#3d3d3d;}
.myFortune li.t05 {padding-bottom:15px;}
.myFortune li.t05 p strong {display:block; padding-bottom:3px;}
.myFortune .luckyItem {position:relative; margin:10px 0 15px;}
.myFortune .luckyItem a {display:block; position:absolute; width:27%; height:44%; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/58020/bg_blank.png) left top repeat;}
.myFortune .luckyItem a.item01 {left:7%; top:5%;}
.myFortune .luckyItem a.item02 {left:37%; top:5%;}
.myFortune .luckyItem a.item03 {right:7%; top:5%;}
.myFortune .luckyItem a.item04 {left:7%; bottom:5%;}
.myFortune .luckyItem a.item05 {left:37%; bottom:5%;}
.myFortune .luckyItem a.item06 {right:7%; bottom:5%;}
.myFortune .evtApply {position:relative; display:none;}
.myFortune .evtApply a {display:block; position:absolute; left:18%; bottom:11%; width:64%; height:19%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/58020/bg_blank.png) left top repeat; text-indent:-9999px;}
.shareSns {position:relative;}
.shareSns a {display:block; position:absolute; top:53%; width:16%; height:25%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/58020/bg_blank.png) left top repeat; text-indent:-9999px;}
.shareSns a.sns01 {left:23%;}
.shareSns a.sns02 {left:41%;}
.shareSns a.sns03 {left:60%;}
@media all and (min-width:480px){
	.constellation .selectBirth {padding:38px; border-radius:75px;}
	.constellation .consView {padding:0 5% 38px;}
	.myFortune {padding-top:38px;}
	.myFortune li {padding-bottom:45px; margin-bottom:38px;}
	.myFortune li p {padding-top:15px; font-size:17px;}
	.myFortune li.t05 p strong {padding-bottom:5px;}
	.myFortune .luckyItem {margin:15px 0 23px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function(){
	$('.myFortune li.t01').prepend('<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/tit_fortune01.gif" alt ="" /></div>');
	$('.myFortune li.t02').prepend('<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/tit_fortune02.gif" alt ="" /></div>');
	$('.myFortune li.t03').prepend('<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/tit_fortune03.gif" alt ="" /></div>');
	$('.myFortune li.t04').prepend('<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/tit_fortune04.gif" alt ="" /></div>');
	$('.myFortune li.t05').prepend('<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/tit_fortune05.gif" alt ="" /></div>');
});

function goViewHoroScope(horodate)
{
	if ($("#horoscope").val()=="")
	{
		alert("별자리를 선택해 주세요.");
		return false;
	}
	if ($("#horoscope").val()=="2015-01-20")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=01";
	}
	if ($("#horoscope").val()=="2015-02-19")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=02";
	}
	if ($("#horoscope").val()=="2015-03-21")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=03";
	}
	if ($("#horoscope").val()=="2015-04-20")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=04";
	}
	if ($("#horoscope").val()=="2015-05-21")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=05";
	}
	if ($("#horoscope").val()=="2015-06-22")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=06";
	}
	if ($("#horoscope").val()=="2015-07-23")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=07";
	}
	if ($("#horoscope").val()=="2015-08-23")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=08";
	}
	if ($("#horoscope").val()=="2015-09-24")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=09";
	}
	if ($("#horoscope").val()=="2015-10-23")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=10";
	}
	if ($("#horoscope").val()=="2015-11-23")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=11";
	}
	if ($("#horoscope").val()=="2015-12-25")
	{
		parent.location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=vLinkECode%>&vScope=12";
	}

}


function goEventP()
{
	<% if Not(IsUserLoginOK) then %>
		calllogin();
	<% else %>
			$.ajax({
				url: "doEventSubscript58131.asp",
				data: "acGubun=entry&userBirth="+$("#horoscope").val(),
				cache: false,
				success: function(message) {
					if (message=="00")
					{
						calllogin();
					}
					else if (message=="66")
					{
						alert("이미 참여하신 이벤트 입니다.")
						return false;
					}
					else if (message=="99")
					{
						alert('정상적인 경로로 접근해주세요.');
						return false;
					}
					else if (message=="88")
					{
						alert('이벤트 응모 기간이 아닙니다.');
						return false;
					}
					else
					{
						alert("이벤트 응모가 완료되었습니다.");
						return false;
					}
				}
				,error: function(err) {
					alert(err.responseText);
				}
			});
	<% end if %>
}

</script>

</head>
<body>
	<div class="evtCont">
		<!-- 별에서 온 운세(APP) -->
		<div class="mEvt58131">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/tit_constellation.gif" alt ="별에서 온 운세" /></h2>
			<div class="constellation">
				<div class="selectBirth">
					<select onchange="goViewHoroScope();" id="horoscope" name="horoscope">
						<option value="">별자리를 선택해주세요.</option>
						<option value="2015-01-20" <% If vScope="01" Then %>selected<% End If %>>물병자리(01.20~02.18)</option>
						<option value="2015-02-19" <% If vScope="02" Then %>selected<% End If %>>물고기자리(02.19~03.20)</option>
						<option value="2015-03-21" <% If vScope="03" Then %>selected<% End If %>>양자리(03.21~04.19)</option>
						<option value="2015-04-20" <% If vScope="04" Then %>selected<% End If %>>황소자리(04.20~05.20)</option>
						<option value="2015-05-21" <% If vScope="05" Then %>selected<% End If %>>쌍둥이자리(05.21~06.21)</option>
						<option value="2015-06-22" <% If vScope="06" Then %>selected<% End If %>>게자리(06.22~07.22)</option>
						<option value="2015-07-23" <% If vScope="07" Then %>selected<% End If %>>사자자리(07.23~08.22)</option>
						<option value="2015-08-23" <% If vScope="08" Then %>selected<% End If %>>처녀자리(08.23~09.23)</option>
						<option value="2015-09-24" <% If vScope="09" Then %>selected<% End If %>>천칭자리(09.24~10.22)</option>
						<option value="2015-10-23" <% If vScope="10" Then %>selected<% End If %>>전갈자리(10.23~11.22)</option>
						<option value="2015-11-23" <% If vScope="11" Then %>selected<% End If %>>사수자리(11.23~12.24)</option>
						<option value="2015-12-25" <% If vScope="12" Then %>selected<% End If %>>염소자리(12.25~01.19)</option>
					</select>
				</div>

				<% If vScope = "" Then %>
					<div class="animation"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_constellation_sign.gif" alt ="" /></div>
				<% End If %>

				<!-- for dev msg : 선택된 별자리 display:block 시켜주세요 -->
				<!-- 물병자리 -->
				<div class="section star01" <% If vScope="01" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 예측할 수 없는 괘도를 도는 ‘천왕성’이야.하늘의 신 ‘우라누스’가 널 지키는 수호신이지. 세상의 인습이나 고정관념을 두들겨 부수는 파격과 독창성, 그게 우라누스가 네게 준 선물이란다. 애인이 있건 말건 흔들림 없는 독립적인 라이프스타일, 그게 바로 네가 천왕성에서 왔다는 증거야. </p></li>
							<li class="t02"><p>어멋, 호기심과 탐구욕이 상승세를 타는군.문제는 ‘조리퐁 개수 세기’처럼 쓰잘데기 없는 영역으로만 지적 욕구가 뻗친다는 거. 영양가 없는 취미 생활에 너무 ‘버닝’ 하지 않도록 화력 조절에 유의하셈.</p></li>
							<li class="t03"><p>싱글은 덮어놓고 들이대지 마셔. ‘친근감의 마일리지’부터 차곡차곡 적립하는 게  순서. 커플은 마냥 오냐 오냐 할 때가 아니야. 그(그녀)의 버르장머리가 머리꼭대기에 앉을 기세라는~ 가끔은 꺾어줘야 한다는~</p></li>
							<li class="t04"><p>풉, 남의 말에 우왕좌왕하는 ‘팔랑귀 증후군’이 기승을 부리겠군. 하지만 남의 조언 따위에 귀 기울이지 마셔. 업무에 관한 한, 올해는 남의 지적질보다 너의 ‘염통 졸깃한’ 직감이 더 타율이 높아.</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_케이블정리용품]</strong>새해 대청소는 ‘케이블 정리’부터 시작해.온갖 IT 기기에 스마트폰 액세서리, 소형 가전들이 얽히고설켜 인테리어 점수를 깎아먹고 있거든. 물병자리의 공학도적인 센스를 끄집어내삼~</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('869744'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1163066'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('939478'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1180489'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('917667'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('434693'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item01.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 물고기자리 -->
				<div class="section star02" <% If vScope="02" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 파랗게 빛나는 ‘해왕성’이야. ‘바다의 신’ 넵튠이 널 지키는 수호신이지. 자신의 감정을 타인에게 쉽게 전이하며, 반대로 타인의 감정에 쉽게 전이되는 아스트랄(?)한 재능, 그게 넵튠이 네게 준 선물이란다. 뭍에 나온 물고기처럼 현실에 발을 디디지 못하는 비현실성, 그게 바로 네가 해왕성에서 왔다는 증거야.</p></li>
							<li class="t02"><p>오옷, 미아리 처녀보살에 빙의된 ‘꿈빨’이 넘실거리는군. 새해부터 수면을 청하는 바람직한 자세는 머리맡에 필기도구 지참이라는 거. 조상님이 숫자를 불러주시거든, 이때다 하고 받아적으셈. 특히 3월, 8월이 핫시즌.</p></li>
							<li class="t03"><p>싱글은 업무를 빙자해 모락모락 피어나는 로맨스의 낌새.결론은 둘 다 잘되거나, 둘 다 망하거나. 커플은 그(그녀)의 말귀를 못 알아듣는 ‘사오정 신드롬’이 로맨스의 앞길을 막네. 어떡하니, 너? 어떡하니?</p></li>
							<li class="t04"><p>쯧쯧, 책임을 추궁당하는 상황이 자주 이어지겠군. 기억해둘 만한 생존 전략은, 더 이상 번드르르한 핑계가 안 통한다는 거. 한 마디라도 진실만 발설하셔. 그래야 상대의 마음을 1센티라도 움직일 수 있어.</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_워터볼 오르골]</strong>지상에서의 삶이 팍팍해 너의 별로 돌아가고 싶은 날엔, ‘워터볼 오르골’에 마음을 기대봐. 엉엉 울면서 한 열 판 쯤 돌리고 나면, 너를 이 땅에 보낸 신의 마음을 알게 될 거야.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('199993'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1182122'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('839916'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('658353'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('928455'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1144847'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item02.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 양자리 -->
				<div class="section star03" <% If vScope="03" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 붉게 타오르는 ‘화성’이야. 전쟁의 신 ‘마르스’가 널 지키는 수호신이지. 열두 별자리 가운데 가장 뜨겁고 격렬하게 뛰는 심장, 그게 마르스가 네게 준 선물이란다. 돌려 말하지 못하는 직설 화법, ‘꿇고 사느니 서서 죽는’ 승부욕, 그게 바로 네가 화성에서 왔다는 증거야.</p></li>
							<li class="t02"><p>쳇, 연초부터 대인관계가 배배 꼬이는 ‘꽈배기 신드롬’이 강림할 예감이 스멀스멀~ 찰떡 같이 말해도 개떡 같이 알아듣는 오해가 난무하니, 알아먹기 난해한 농담은 입 밖에 꺼내기 있기 없기?</p></li>
							<li class="t03"><p>싱글아, 기대해. 소개팅 자리에서 ‘평행이론’ 돋네. 서로 인연이 있다는 거지. 커플은 짜릿한 이벤트가 서서히 줄어들면서 편안한 ‘생활형 로맨스’로 안착할 예감. 덕분에 ‘로맨스 유지비용’도 굳겠네.</p></li>
							<li class="t04"><p>허걱, 하반기부터 보스께옵서 동생에게 ‘바짝’ 접근하시는군. 그건 아마도 동생이 ‘관심사원’으로 떠올랐다는 뜻!? 당분간 퀄리티는 포기하더라도 속도는 높여줘. 미운털 뽑아내고 ‘이쁨’ 받는 길이라는~</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_키친타이머]</strong>한시도 가만있지 못해 번번이 요리를 망치는 양자리야.새해엔 키친타이머 옆구리에 차고 ‘스마트쿠킹’에 도전해보삼. 알람이 울릴 때 달려오면 되니, TV 드라마도 맘 놓고 보겠네.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('443114'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('45979'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('261066'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('45990'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('546397'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('816538'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item03.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 황소자리 -->
				<div class="section star04" <% If vScope="04" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 지구의 닮은꼴 행성 ‘금성’이야. 풍요의 여신 ‘비너스’가 널 지키는 수호신이지. 촉촉한 황소의 눈망울, 글래머러스한 ‘대문자 S라인’ 몸매, 그게 비너스가 네게 준 선물이란다. 열두 별자리 가운데 가장 느긋하면서도 섬세한 취향, 그게 바로 네가 금성에서 왔다는 증거야</p></li>
							<li class="t02"><p>에고, 친구관계 영역에서 ‘불만의 뾰루지’가 하나둘 포착되는군. 가슴 한 구석 찔리는 게 있거든, 바로 밥 사고 술 사며 달래주셔. 이대로 냅두면, 여름이 오기도 전에 반란(?)을 일으킬 기세야.</p></li>
							<li class="t03"><p>오옷, 싱글은 여행 중 ‘작업 성공률’이 반짝반짝. 올해 바캉스는 무조건 물 좋은 곳으로 Go~ Go~ 커플은 친구들의 훈수 따위 한 귀로 듣고 한 귀로 흘려. 걔네들 말 듣다가는 로맨스를 깨빡칠 거야.</p></li>
							<li class="t04"><p>헐, 사내정치 상황이 한치 앞을 내다보기도 어렵게 요동치겠군. 팽팽한 ‘기싸움’이 전개되니, 두 눈에 쌍심지 세우고 결계를 치삼. 쉽게 보이면 끝장인 거 알지? 한번 밀리면 죽음이야.</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_보온력 빵빵한 보온병]</strong>꼭 마셔야 맛이 아니지. 가방에 따뜻한 보온병 하나 있으면, 그것만으로도 ‘영혼의 허기’가 채워진다고나 할까. 까칠해진 마음을 가장 빨리 위로하는 너만의 응급처방이 될 거야.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('1110058'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1148508'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1131176'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1128640'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('291678'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1178386'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item04.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 쌍둥이자리 -->
				<div class="section star05" <% If vScope="05" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 태양의 가장 가까운 궤도를 도는 ‘수성’이야. 전령의 신 ‘머큐리’가 널 지키는 수호신이지. ‘빨간 머리 앤’에 빙의된 듯한 톡톡 튀는 언어감각과 깨알 같은 재치, 그게 머큐리가 네게 준 선물이란다. 가장 적게 알면서도, 남 보기엔 가장 많이 아는 사람이 되는 재능, 그게 바로 네가 수성에서 왔다는 증거야.</p></li>
							<li class="t02"><p>쩝, 하던 일은 끝내지도 않고 계속해서 일만 벌리는 ‘문어발 증후군’이 올해 내내 기승을 부리겠군. 온갖 약속이 빚쟁이처럼 압박해오기 전에, 얼른 정신 차리셈. 뭐 하나라도 똑 부러지게 끝내.</p></li>
							<li class="t03"><p>싱글은 왜 그러니? 애먼 상대에게 번번이 꽂히네. 길게 갈 인연, 절대 아니거든. 커플은 너의 무관심에 그(그녀)가 하루하루 비뚤어져가고 있어. 잡은 고기에게도 떡밥은 좀 주라, 응? </p></li>
							<li class="t04"><p>오옷, 노력에 비해 성과가 높은 시즌이야. 말 한 마디로 천 냥 빚을 털거나, 남이 차린 밥상에 슬며시 밥숟갈 얹을 수 있다는 거. ‘눈치코치 게이지’만 최강으로 높여둬. 특히, 6~9월이 핫시즌.</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_캐릭터 일러스트 스마트폰케이스]</strong>미키 마우스도 좋고, 스파이더맨도 좋고, 페코짱도 좋아. 키덜트 취향이 물씬 묻어나는 알록달록한 스마트폰 케이스야말로 쌍둥이자리의 재기발랄함을 돋보이게 하는 단짝 중의 단짝.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('1173830'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1187492'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1163169'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1183448'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1065301'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1154407'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item05.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 게자리 -->
				<div class="section star06" <% If vScope="06" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 지구의 엄마별 ‘달’이야. 가정의 신 ‘주노’가 널 지키는 수호신이지. 사람들을 거둬 먹이기 좋아하는 ‘가족주의적 취향’과 영혼을 파고드는 ‘시인의 감수성’, 그게 주노가 네게 준 선물이란다. 달이 차오르면 고조되고, 달이 기울면 까다로워지는 감정, 그게 바로 네가 달에서 왔다는 증거야.</p></li>
							<li class="t02"><p>풉, 게자리 특유의 ‘삐돌이 게이지’가 상승세를 타겠군. 웃자고 던진 농담에도 죽자고 반응할 예감이니, 부디 워~워~ 친구들이 ‘은따’ 놓기 전에 개념 탑재하고 돌아오는 게 좋겠어.</p></li>
							<li class="t03"><p>싱글은 마음이 아직도 과거에 붙잡혀 있군. 하지만 옛사랑을 버려야 새로운 사랑을 시작할 수 있다는 거, 명심해. 커플은 그(그녀)의 ‘흑역사 털기’에 사로잡힐 예감. 제발 적당히 하자, 적당히.</p></li>
							<li class="t04"><p>오옷, 꾸준히 다져온 ‘찰진 인맥관리’가 새해 들어 궤도에 오르겠네. 맹숭맹숭 하던 웃전과의 사이가 ‘찰떡궁합’으로 발전할 기세. 착실히 눈도장을 찍어둬. ‘커리어의 백년지계’가 시원하게 열릴 거야</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_손뜨개 DIY 키트]</strong>‘삐돌이 게이지’를 잠재우는데 이만한 게 없지. 한 코 한 코 바늘을 놀리다보면, 토라진 마음은 가라앉고 이해심은 살아나거든. 하지만 기념일에 목도리 선물은 제발 참아줘.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('1184593'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1176641'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('975854'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1153760'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1169165'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1152661'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item06.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 사자자리 -->
				<div class="section star07" <% If vScope="07" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 별들의 제왕 ‘태양’이야. 빛의 신 ‘아폴로’가 널 지키는 수호신이지. 열두 별자리 가운데 가장 도드라지는 카리스마와 화려한 존재감, 그게 아폴로가 네게 준 선물이란다. 잊힐 만하면 내뱉는 자기도취에 빠진 ‘중2병’ 돋는 발언, 그게 바로 네가 태양에서 왔다는 증거야.</p></li>
							<li class="t02"><p>에고, 해봤자 안 되는 일에 미련을 떠는 ‘미련곰탱이’ 기질이 엿보이는군. 적어도 새해엔 그래. 한번 해보고 안 되는 일은 영원히 안 되거든. ‘싹수 노란’ 일에선 얼른 손 떼는 게 정신건강을 지키는 길이야.</p></li>
							<li class="t03"><p>싱글은 해가 바뀌면 생길 거 같죠? 그랬다면 경기도 오산(?)이죠~ 커플은 ‘들켰다’ 싶을 땐 발뺌하지 말 것. 섣부른 설레발보다 이실직고가 현명한 해결책이라는 걸 명심해.</p></li>
							<li class="t04"><p>풉, 사장님의 ‘칭찬 드립’에 넘어가 ‘불판 위의 곰’처럼 깨춤을 추겠네. 그깟 감언이설에 너무 혹하지 마셈. 얻는 건 고작 말 뿐인 총애, 잃는 건 되돌아오지 않는 ‘젊음의 생간’이야. </p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_버블바스]</strong>사자의 코털을 건드리는 발칙한 세상에 맘 상한 날엔,욕조 가득버블바스를 풀어놓고 ‘거품목욕’을 즐겨봐. 몽글몽글 풍성한 거품이 현실에서는실현하기 어려운 너의 화려한 존재감을 충족시켜줄 거야.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('1183721'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1127887'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1060249'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1174709'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1174707'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('922672'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item07.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 처녀자리 -->
				<div class="section star08" <% If vScope="08" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 태양의 시종 ‘수성’이야. 비즈니스의 신 ‘머큐리’가 널 지키는 수호신이지. 온 세상 사장님들이 ‘완소 사원’으로 꼽을 만큼 야무진 일 솜씨, 빈틈없는 정리벽, 그게 머큐리가 네게 준 선물이란다. 언성 한번 높이지 않고도 상대를 분노로 숨이 기함하게 만드는 말빨, 그게 바로 네가 수성에서 왔다는 증거야.</p></li>
							<li class="t02"><p>쳇, 까칠하기가 ‘사포 캐릭터’를 뒤집어쓰겠네. 까칠한 ‘성질머리’에 송곳 같은 ‘지적질’로 온 동네 미움을 한 몸에 받을 기세라는 거. 제발 머리에 떠오르는 말을 곧장 입 밖에 내뱉지는 말아줘. </p></li>
							<li class="t03"><p>싱글은 우정을 사랑으로 갈아타기 하려는 시도는 포기해. 있던 우정까지 날아갈 뿐이야. 커플은 너무 수동적인 거 아니니? 적극적으로 리드하는 모습을 보여야 할 때야. 특히, 계산대 앞에서.</p></li>
							<li class="t04"><p>오옷, 짜릿한 승진운과 스카우트의 암시가 반짝이는군. 특히 2~4월 즈음, 연봉협상을 한다면 대화의 물줄기를 유리하게 이끌 수 있다는 거. 무심한 척 시크하게 ‘협상의 미끼’를 던져봐. </p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_퍼즐]</strong>문제의 해답을 찾지 못해 답답할 때, 머리를 쥐어뜯는 대신‘퍼즐 맞추기’를 해봐. 퍼즐 조각이 많으면 많을수록 좋아.‘이성의 하이퍼엔진’을 단 듯, 생각이 명료해질 거야.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('1111255'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('644571'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('803595'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('932431'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1144950'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('803606'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item08.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 천칭자리 -->
				<div class="section star09" <% If vScope="09" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 아름다운 샛별 ‘금성’이야. 미의 여신 ‘비너스’가 널 지키는 수호신이지. 아름다움의 원리인 황금비율을 충실하게 반영한 이목구비, 그게 비너스가 네게 준 선물이란다. 오락가락하는 천칭의 몸놀림처럼, 다정과 냉정 사이를 매끄럽게 오가는 ‘밀땅’의 테크닉, 그게 바로 네가 금성에서 왔다는 증거야.</p></li>
							<li class="t02"><p>오옷, 과거에 베풀었던 공덕이 ‘므흣한’ 열매가 되어 되돌아오겠군. 특히 4~5월과 9~10월을 기대해. ‘인맥의 그물망’에 월척이 들어올 예감이거든. 미리 안부 인사를 잘 챙겨두는 게 좋겠어.</p></li>
							<li class="t03"><p>싱글은 까칠한 ‘엘프’와 성격 좋은 ‘드워프’ 사이에서 갈팡질팡. 결정은 미루고 일단 ‘어장관리’를 추천함. 커플은 너무 우려서 사골이 되어가는 로맨스. 뭔가 참신한 게 필요해.</p></li>
							<li class="t04"><p>쳇, 이랬다, 저랬다하는 보스의 ‘다중이 드립’에 희생양이 될 듯한 예감이야. 하룻밤 새에 “이 산이 아닌게벼~”하고 말 바꾸기 쉬우니, 절대 내일 일을 오늘 앞당겨하지 말 것. 만사가 돼야 되는 거야. 낚이지 마셔.</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_명함홀더]</strong>새해엔 인맥 관리에 깨알같이 꼼꼼해질 필요가 있겠어. 말했잖니, ‘귀인 상봉’의 촉이 벌써부터 찌르르하다고. 찾기 쉽게 정돈된 명함홀더는 너의 가장 강력한 서포터즈가 될 거야</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('115125'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1122476'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1007016'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1115185'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('480384'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('956188'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item09.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 전갈자리 -->
				<div class="section star10" <% If vScope="10" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 태양계의 끝 ‘명왕성’이야. ‘죽음의 신’ 플루토가 널 지키는 수호신이지. 화창한 봄날의 한복판에서도 폭풍의 징후를 감지하는 통찰력과 직관, 그게 플루토가 네게 준 선물이란다. 트리플 샷의 에스프레소 같은 중독성과 맹독성, 그게 바로 네가 명왕성에서 왔다는 증거야.</p></li>
							<li class="t02"><p>어멋, 친구나 가족의 비밀을 감지하겠군. 비밀에 대처하는 바람직한 자세는 ‘침묵’이라는 걸 명심해. 내버려둬도 알려질 비밀을 굳이 발설하지는 말라는 거지. 그의 원망이 백만 년 갈 거야.</p></li>
							<li class="t03"><p>싱글은 ‘삽질 로맨스’로 한해가 저물겠네. (방향이 잘못 됐거든~ 거기가 아니거든~ 이미 마음 떠났거든~) 커플은 그냥 별일 없이 산다. 나아가지도 않고, 물러서지도 않는 딱 제자리걸음</p></li>
							<li class="t04"><p>올해 너에게 시급한 건, 아무래도 야무진 일솜씨가 아니라 센스 있는 말솜씨 같아. 보스를 비롯해 웃전들의 비위에 ‘착착 감기는’ 화법을 연마하셈. 그래야 실력으로 승부하는 ‘본선 무대’에 진출할 수 있어.</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_해골 모티프 아이템]</strong>쉿! 전갈자리의 독설은 가슴에 묻어둬. 추악한 진실은 너만 알고 넘어가는 거야. 남들에게는 그냥 그들이 원하는 얘기를 해줘. ‘해골 모티프’ 주얼리가 침묵할 수 있는 힘을 줄 거야.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('738813'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1184206'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1075017'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('883659'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('977749'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1005276'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item10.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 사수자리 -->
				<div class="section star11" <% If vScope="11" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 지구의 11배나 되는 거대 행성 ‘목성’이야. ‘최고의 신’ 주피터가 널 지키는 수호신이지. 가스덩어리로 이루어진 목성처럼, 사람들을 포부와 희망으로 붕붕 띄우는 낙천성, 그게 주피터가 네게 준 선물이란다. 부담 없는 매력 탓에 부담 없는 관계로 남는 딜레마, 그게 바로 네가 목성에서 왔다는 증거야.</p></li>
							<li class="t02"><p>쯧쯧, ‘육감 게이지’가 신통찮은 시즌이야. ‘촉’만 가지고 넘겨짚거나, ‘감’만 믿고 덤볐다가는 다 망한다는 거지. 하나하나 앞뒤 재보고 계산기 두드려가며 판단하고 처리하는 원칙을 꼭 지키삼.</p></li>
							<li class="t03"><p>싱글은 축하해. ‘등잔 밑’에서 로맨스를 ‘득템’ 하겠네. 먼저 네 주변부터 샅샅이 살펴 보삼. 범인(?)은 분명 가까이 있어. 커플은 여름부터 서로의 단점이 완전 크게 보여는 위기의 시즌. </p></li>
							<li class="t04"><p>상반기는 무난하고 무탈해. 문제는 하반기 접어들면서부터 ‘야근 게이지’의 압박이 심상찮다는 거. 오는 업무를 다 받다간 책상 앞에서 순직하거든. 적당히 반사하는 ‘방어 신공’을 사용해야 할 때야.</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_세계지도]</strong>오호 통제라! 반인반마(半人半馬)의 켄타우로스 종족이 삼실 책상 앞에서 세월을 보내다니. 아침저녁 세계지도를 보며 역마살을 달래는 영약으로 삼으셈. 세계일주의 꿈을 키워도 좋고말고.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('1133435'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1133573'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1133431'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('705272'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('745222'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('385030'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item11.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- 염소자리 -->
				<div class="section star12" <% If vScope="12" Then %> style="display:block;"<% End If %>>
					<div class="consView">
						<ul class="myFortune">
							<li class="t01"><p>너의 별은 여러 개의 고리에 감금된 행성 ‘토성’이야. ‘시간의 신’ 크로노스가 널 지키는 수호신이지. 시간의 풍화작용을 이겨내는 끈기와 집념, 그게 크로노스가 내게 준 선물이란다. 목적을 위해서는 수단과 방법을 가리지 않는 마키아벨리즘, 그게 바로 네가 토성에서 왔다는 증거야. </p></li>
							<li class="t02"><p>새해엔 귀를 활짝 열고 주위사람들의 조언을 고분고분 따르셈. 고집 부린다고 그게 다 소신은 아니거든. 올해는 남들이 “예스”하면 동생도 “예스”하는 ‘따라쟁이’ 전략이 제일이야.</p></li>
							<li class="t03"><p>싱글은 패스해도 아쉽지 않은 ‘심심풀이 땅콩’ 같은 로맨스. 심심하면 하든가~ 귀찮으면 패스하든가~ 커플은 ‘뻣뻣대마왕’ 노릇은 닥쳐. 적어도 이벤트만큼은 손발이 오그라들게 해줘야 한다는.</p></li>
							<li class="t04"><p>허걱, 의무만 ‘쩔고’ 권한은 없는 ‘중간 관리자’ 캐릭터를 뒤집어쓸 예감이야. 위에서 눌리고 아래에서 치일 예정이니, 마우스피스 끼고 어금니를 꽉 깨물셈어야 해. 그래도 하반기부터는 차차 풀린다는~</p></li>
							<li class="t05">
								<p><strong>[행운의 아이템_문서 세단기]</strong>깜깜한 그믐밤이 좋겠어. 종이에 복수하고픈 녀석의 이름을 빨간 펜으로 쓰는 거야. 딱 스물한 장만. 그 다음엔 문서 세단기로 잘근잘근 갈아버리는 거지. 염소자리를 위한 스트레스 해소법 또는 초급마법이야.</p>
								<div class="luckyItem">
									<a href="" onclick="parent.fnAPPpopupProduct('405996'); return false;" class="item01">행운의 아이템1</a>
									<a href="" onclick="parent.fnAPPpopupProduct('380146'); return false;" class="item02">행운의 아이템2</a>
									<a href="" onclick="parent.fnAPPpopupProduct('831301'); return false;" class="item03">행운의 아이템3</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1003376'); return false;" class="item04">행운의 아이템4</a>
									<a href="" onclick="parent.fnAPPpopupProduct('695875'); return false;" class="item05">행운의 아이템5</a>
									<a href="" onclick="parent.fnAPPpopupProduct('1133544'); return false;" class="item06">행운의 아이템6</a>
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_item12.jpg" alt="" /></span>
								</div>
								<div class="evtApply">
									<a href="" onclick="goEventP();return false;">이벤트 응모</a>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/txt_event_cont.gif" alt ="" /></div>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<%
				'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
				Dim vTitle, vLink, vPre, vImg, vAppLink
				vTitle = "별에서 온 운세"
				vLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&vLinkECode
				vPre = "10x10 이벤트"
				vImg = "http://webimage.10x10.co.kr/eventIMG/2014/58021/tit_constellation.gif"

				if inStr(vLink,"appCom")>0 then
					vAppLink = vLink
				else
					vAppLink = replace(vLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")
				end if

				
				dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
				snpTitle = Server.URLEncode(vTitle)
				snpLink = Server.URLEncode(vLink)
				snpPre = Server.URLEncode(vPre)
				snpImg = Server.URLEncode(vImg)

				'기본 태그
				snpTag = Server.URLEncode("텐바이텐 " & Replace(vTitle," ",""))
				snpTag2 = Server.URLEncode("#10x10")
			%>
			<div class="shareSns">
				<a href="" class="sns01" onclick="popSNSPost('tw','<%=vTitle%>','<%=vLink%>','<%=vPre%>','<%=snpTag2%>'); return false;">twitter</a>
				<a href="" class="sns02" onclick="popSNSPost('fb','<%=vTitle%>','<%=vLink%>','',''); return false;">facebook</a>
				<a href="" class="sns03" onClick="return false;" id="kakaob">kakao talk</a>
				<script>
					//카카오 SNS 공유
					Kakao.init('c967f6e67b0492478080bcf386390fdd');

					// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
					Kakao.Link.createTalkLinkButton({
					  //1000자 이상일경우 , 1000자까지만 전송 
					  //메시지에 표시할 라벨
					  container: '#kakaob',
					  label: '<%=vTitle%>',
					  <% if vImg <>"" then %>
					  image: {
						//500kb 이하 이미지만 표시됨
						src: '<%=vImg%>',
						width: '200',
						height: '150'
					  },
					  <% end if %>
					  appButton: {
						text: '10X10 앱으로 이동',
						execParams :{
							android : {"url":"<%=vAppLink%>"},
							iphone : {"url":"<%=vAppLink%>"}
						}
					  },
					  installTalk : Boolean
					});
				</script>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58021/img_share_sns.gif" alt ="2015년 별자리 운세 같이 봐요~" /></p>
			</div>
		</div>
		<!--// 별에서 온 운세(APP) -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->