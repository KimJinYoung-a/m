<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 어머, 이건 담아야해_APP 런칭 이벤트 2차(APP)
' History : 2014.04.11 유태욱
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event50838Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->

<%
dim cEvent, eCode, ename, emimg, subscriptcount
dim usercell, userid
	eCode=getevt_code
	userid = getloginuserid()

dim OrderType, SortMethod, vDisp, SellScope

subscriptcount=0
subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing

dim nowOpenYN, fidx
	fidx		= requestCheckVar(request("fidx"),10)
	
nowOpenYN = false	'현재 선택폴더 공개설정 여부
if fidx	= "" then fidx = 0

dim myfavorite
set myfavorite = new Cevent50838_list
	myfavorite.FPageSize        = 10
	myfavorite.FCurrpage        = 1
	myfavorite.FScrollCount     = 10
	myfavorite.FRectOrderType   = OrderType
	myfavorite.FRectSortMethod  = SortMethod
	myfavorite.FRectDisp		= vDisp
	myfavorite.FRectSellScope	= SellScope
	myfavorite.FRectUserID      	= userid
	myfavorite.FRectviewisusing = "Y"
	myfavorite.FFolderIdx		= ""

	if userid<>"" then
		'//위시리스트 상품 리스트 검색
		myfavorite.getMyWishList
	end if

dim myfolder, arrList
set myfolder = new Cevent50838_list
	myfolder.FRectUserID      	= userid

	if userid<>"" then
		'위시리스트 폴더 검색
		arrList = myfolder.fnGetFolderList
	end if
set myfolder=nothing

dim strSql, isMaxFolder, isSubscript, vFidx, ix
isSubscript = false
isMaxFolder = false

'// 이벤트 참여여부 및 위시폴더 확인
if IsUserLoginOK then
	'응모여부 확인
	strSql = "select count(*) cnt " &_
			"from db_event.dbo.tbl_event_subscript " &_
			"where evt_code=" & eCode &_
			"	and userid='" & GetLoginUserID & "' "
	rsget.Open strSql,dbget,1
	if rsget(0)>0 then isSubscript = true		'응모여부
	rsget.Close

	if isSubscript then
		'이벤트 폴더 접수
		strSql = "select top 1 fidx " &_
				"from db_my10x10.dbo.tbl_myFavorite_folder " &_
				"where userid='" & GetLoginUserID & "' " &_
				"	and viewIsUsing='Y' " & _
				"	and foldername='어머, 이건 담아야해' "
		rsget.Open strSql,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			vFidx = rsget(0)
		else
			vFidx = 0
		end if
		rsget.Close
	else
		'위시폴더 수 확인
		strSql = "select count(*) cnt " &_
				"from db_my10x10.dbo.tbl_myFavorite_folder " &_
				"where userid='" & GetLoginUserID & "' "
		rsget.Open strSql,dbget,1
		if rsget(0)>=9 then isMaxFolder = true
		rsget.Close
	end if
end if

'response.write left(currenttime,10)
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<style type="text/css">
.mEvt50838 {position:relative;}
.mEvt50838 p {max-width:100%;}
.mEvt50838 img {vertical-align:top; width:100%;}
.mEvt50838 .time {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_time_bg.png) center bottom no-repeat; background-size:100%; padding-bottom:23px;}
.mEvt50838 .time > div {width:296px; height:39px; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_time.png) center top no-repeat; background-size:296px 39px;}
.mEvt50838 .time > div > p {padding-left:50%;}
.mEvt50838 .time > div > p span {display:inline-block; color:#fff; font-weight:bold; letter-spacing:1em; padding:12px 30px 0 5px;}
.mEvt50838 .todayList {overflow:hidden; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_pdt_bg.png) center top repeat-y; background-size:100%; padding:1em;}
.mEvt50838 .todayList li {width:50%; float:left; padding:10px; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box; text-align:center; font-size:13px;}
.mEvt50838 .todayList li .pic {position:relative;}
.mEvt50838 .todayList li .pic span {display:none;}
.mEvt50838 .todayList ul.todayResult li .pic span {display:block; width:100%; height:100%; position:absolute; left:0; top:0; bottom:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_drop.png) left top no-repeat; background-size:cover;}
.mEvt50838 .todayList ul.todayResult li.todayWish .pic span {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_today.png) left top no-repeat; background-size:cover;}
.mEvt50838 .lyrWinner {}
.mEvt50838 .lyrWinner .lyrCont {position:fixed; left:12px; right:12px; top:100px; border:4px solid #d9d9d9; background-color:#fff; box-shadow:0 0 12px #555; -webkit-box-shadow:0 0 12px #555; z-index:50; padding:10px 0;}
.mEvt50838 .lyrWinner .dimmed {position:absolute; left:0; right:0; top:0; bottom:0; background-color:#000; opacity:0.3; z-index:10;}
.mEvt50838 .lyrWinner h3 { padding-bottom:10px; text-align:center; padding-top:10px;}
.mEvt50838 .lyrWinner h3 span {color:#d00808; font-size:22px; border-bottom:2px solid #d00808;}
.mEvt50838 .lyrWinner .winnerList {text-align:center;}
.mEvt50838 .lyrWinner .winnerList dl {width:60%; margin:10px auto;}
.mEvt50838 .lyrWinner .winnerList dl dt {border-bottom:1px solid #000; padding-bottom:5px; font-weight:bold;}
.mEvt50838 .lyrWinner .winnerList dl dd {padding:15px 40px 30px 0; line-height:1.3;}
.mEvt50838 .lyrWinner .lyrClose {position:absolute; right:7px; top:0; font-size:30px; color:#787878; padding:5px; text-align:center;}
.mEvt50838 .lyrWinner .listWrap {height:300px; position:relative;}
.mEvt50838 .lyrWinner #scroller {position:absolute; height:300px; left:0; top:0; right:0; bottom:0; width:100%;}
.mEvt50838 .lyrWinner #scroll {position:absolute; z-index:1; /*-webkit-touch-callout:none;*/ -webkit-tap-highlight-color:rgba(0,0,0,0); width:100%; padding:0;}
.mEvt50838 .ftLt {float:left;}
.mEvt50838 .ftRt {float:right;}
.mEvt50838 .overHidden {overflow:hidden; _zoom:1;}
.mEvt50838 .tPad10 {padding-top:10px;}
@media all and (min-width:480px){
	.mEvt50838 .time {padding-bottom:34px;}
	.mEvt50838 .time > div {width:444px; height:59px; background-size:444px 59px;}
	.mEvt50838 .time > div > p {font-size:28px;}
	.mEvt50838 .time > div > p span {letter-spacing:0.5em; padding:16px 44px 0 5px;}
}
</style>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript" src="/lib/js/iscroll.js"></script>
<script type="text/javascript">
function loaded() {
	var myScroll = new iScroll('scroller', {
		scrollbars: true,
		mouseWheel: true,
		preventDefault: false
	});
	//$('.dimmed').bind('touchmove', function (e) { e.preventDefault(); }, false);
}

$(function(){
	$('.lyrClose').click(function(e) {
		e.preventDefault();
		$('.lyrWinner').hide();
		//$('.dimmed').unbind('touchmove');
	});

	$('.winnerView').click(function(e) {
		$('.lyrWinner').show();
		loaded();
	});
});

var today=new Date(<%=Year(currenttime)%>, <%=Month(currenttime)-1%>, <%=Day(currenttime)%>, <%=Hour(currenttime)%>, <%=Minute(currenttime)%>, <%=Second(currenttime)%>);
var minus_second = 0;

//남은시간 카운트
function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getFullYear() 
	var todaym=today.getMonth()
	var todayd=today.getDate()
	var todayh=today.getHours()
	var todaymin=today.getMinutes()
	var todaysec=today.getSeconds()

	var dateA = new Date(todayy,todaym,todayd,todayh,todaymin,todaysec);
	var dateB = new Date(todayy,todaym,todayd,17,00,00 );

	var ss  = Math.floor(dateB.getTime() - dateA.getTime() ) / 1000;
	var mm  = Math.floor(ss / 60);
	var hh  = Math.floor(mm / 60);
	var day    = Math.floor(hh / 24);
	
	var diff_hour   = Math.floor(hh % 24);
	var diff_minute = Math.floor(mm % 60);
	var diff_second = Math.floor(ss % 60);
	
	if (diff_hour<10){
		diff_hour="0"+diff_hour
	}
	if (diff_minute<10){
		diff_minute="0"+diff_minute
	}		
	//alert( todayh );
	if (todayh>=14 && todayh<17){
		$("#lyrCounter").html("<span>"+diff_hour+"</span><span>"+diff_minute+"</span>");
	}else{
		$("#lyrCounter").html("<span>00</span><span>00</span>");
	}

	minus_second = minus_second + 1;

	setTimeout("countdown()",1000)		
}

$(function() {
	countdown();
});

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #05/23/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% if not (Hour(currenttime) > 13 and Hour(currenttime) < 17) then %>
				alert("오후 2시부터 5시까지만 응모가 가능합니다.");
				return;
			<% else %>
				<% If getnowdate>="2014-05-12" and getnowdate<="2014-05-23" Then %>
					<% if not (getnowdate >="2014-05-17" and getnowdate<="2014-05-18") Then %>
						<% if subscriptcount<2 then %>
							//alert('아이템코드를 받아옵니다');
							var listitemid = document.getElementsByName("listitemid");
							var tmpitemid='';
							for(var i=0; i < listitemid.length;i++){
								if(listitemid[i].checked){
									tmpitemid = listitemid[i].value
								}
							}
							//alert('상품선택여부 판단');
							if (tmpitemid==''){
								alert('상품을 선택해 주세요.');
								return;
							}
							frm.itemid.value=tmpitemid;
							frm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript50838.asp";
							frm.target="evtFrmProc";
							//alert('폼전송 합니다');
							frm.submit();
						<% else %>
							alert("응모는 하루에 한번만 가능합니다.");
							return;
						<% end if %>
					<% else %>
						alert("공휴일은 이벤트를 진행하지 않습니다.");
						return;
					<% end if %>
				<% else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% end if %>
			<% end if %>
		<% End If %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		calllogin();
		//return;
	<% End IF %>
}

function kakaosendcall(){
	kakaosend50838();
}

function kakaosend50838(){
	var url =  "http://bit.ly/1gcRbhO";
	kakao.link("talk").send({
		msg : "오늘 WISH하면 내일 선물이?!\n어머, 이건 담아야 해!\n매일 새롭게 등장하는 행운의 선물을 위시하세요!",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "어머, 이건 담아야 해!",
		type : "link"
	});
}

</script>
</head>
<body>
<div class="mEvt50838">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_tit.png" alt="어머, 이건 담아야해!" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt1.png" alt="매일 새롭게 등장하는 행운의 선물을 위시하세요!" /></p>
	<div class="overHidden" style="background-color:#db0d0d;">
		<span style="width:65%" class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt2.png" alt="이벤트 기간 및 당첨자 발표" /></span>
		<span style="width:35%" class="winnerView ftRt"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_btn01.png" alt="당첨 결과" /></span><!-- for dev msg : 4/15 이벤트 첫날에는 클릭시 알럿띄워주세요 -->
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt3.png" alt="매일 오후 2시부터 5시까지" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt4.png" alt="TODAY WISH" /></p>
	<div class="time">
		<div>
			<p id="lyrCounter"><span>00</span><span>00</span></p>
		</div>
	</div>
	<div class="todayList">
		<!-- 05.12 -->
		<ul class="today0415 <% IF Hour(currenttime) > 16 then  response.write "todayResult" end if %>"><!-- for dev msg : 18시에 결과 노출할때 todayResult 클래스 추가해주세요 -->
			<% if currenttime >= #04/12/2014 00:00:00# and currenttime < #05/13/2014 00:00:00# then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(963898);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_01.png" alt="라메카 빈티지 여행가방" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="963898" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1014574);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_02.png" alt="United Pouch - Laptop" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="1014574" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1005758);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_03.png" alt="누드루미네상스 스탠딩조명" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="1005758" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1007042);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_04.png" alt="니콘 쿨픽스 P330" /></a></p>
					<p class="tPad10">3명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="1007042" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(979160);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_05.png" alt="소니 3세대 헤드마운트 디스플레이 HMZ-T3" /></a></p>
					<p class="tPad10">1명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="979160" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(830847);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_06.png" alt="Lamy Safari 만년필" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="830847" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.12 -->

		<!-- 05.13 -->
		<ul class="today0416 <% IF Hour(currenttime) > 16 then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/13/2014 00:00:00# and currenttime < #05/14/2014 00:00:00# then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(866102);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_01.png" alt="Wrapping Ball - Pink/Blue/White" /></a></p>
					<p class="tPad10">100명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="866102" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(873357);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_02.png" alt="LG 포토프린터 포켓포토 포포" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="873357" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1011775);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_03.png" alt="셀리 스툴" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="1011775" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(990809);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_04.png" alt="북두칠성 귀걸이" /></a></p>
					<p class="tPad10">20명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="990809" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(884070);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_05.png" alt="[Mr.Maria] anana lamp" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="884070" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(930730);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_06.png" alt="basic notebook pouch 13" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio"  name="listitemid" value="930730" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.13 -->

		<!-- 05.14 -->
		<ul class="today0417 <% IF Hour(currenttime) > 16 then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/14/2014 00:00:00# and currenttime < #05/15/2014 00:00:00# then %>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(679375);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_01.png" alt="enjoy check picnicmat" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="679375" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1012187);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_02.png" alt="m.Humming NEO BAG" /></a></p>
					<p class="tPad10">20명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1012187" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1003632);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_03.png" alt="Manicure scissors - Seaflower" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1003632" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(995544);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_04.png" alt="1 MAN TENT - ORANGE" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="995544" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1005577);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_05.png" alt="다이슨 진공 핸드형 청소기" /></a></p>
					<p class="tPad10">1명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1005577" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(944301);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_06.png" alt="IRON MAN3 HAND" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="944301" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.14 -->

		<!-- 05.15 -->
		<ul class="today0418 <% IF Hour(currenttime) > 16 then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/15/2014 00:00:00# and currenttime < #05/16/2014 00:00:00# then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(364400);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_01.png" alt="RAIN PARADE(우산)" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="364400" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(931088);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_02.png" alt="밀크 테이블 스탠드" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="931088" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(808666);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_03.png" alt="15inch Cabaret Pink" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="808666" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(963413);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_04.png" alt="필립스 세코 반자동 커피머신 HD8325와 엔코 커피그라인더 세트" /></a></p>
					<p class="tPad10">1명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="963413" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(924864);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_05.png" alt="클래식 로드바이크" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="924864" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(884073);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_06.png" alt="[Mr.Maria] Miffy lamp S" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="884073" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.15 -->

		<!-- 05.16~05.18 -->
		<ul class="today0421 <% if currenttime >= #05/16/2014 17:00:00# and currenttime  < #05/19/2014 00:00:00# then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/16/2014 00:00:00# and currenttime < #05/19/2014 00:00:00# then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(830110);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_01.png" alt="[Aromaco] 티라이트 50P" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="830110" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(946234);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_02.png" alt="쿠펠 우유가열기" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="946234" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(772444);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_03.png" alt="sticky monster lab" /></a></p>
					<p class="tPad10">20명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="772444" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(931895);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_04.png" alt="알톤 피규어" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio"name="listitemid" value="931895"  /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(816426);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_05.png" alt="[바이빔]비트 장 스탠드-에쉬" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="816426" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1010223);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_06.png" alt="소니 A5000" /></a></p>
					<p class="tPad10">1명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1010223" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- 05.16~05.18 -->

		<!-- 05.19 -->
		<ul class="today0422 <% IF Hour(currenttime) > 16 then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/19/2014 00:00:00# and currenttime < #05/20/2014 00:00:00# then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(827212);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_01.png" alt="아이코닉 스마트 사이드백" /></a></p>
					<p class="tPad10">100명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="827212" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(850794);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_02.png" alt="ALLEN SUNGLASSES - BLACK" /></a></p>
					<p class="tPad10">20명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="850794" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1030043);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_03.png" alt="[심슨]룰드 노트북/옐로우 하드 L" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1030043" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(514766);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_04.png" alt="로즈워터 오 데 뚜왈렛" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="514766" /></p>
				</li>
				<li>
					<p class="pic"><span></span><!-- a href="" onclick="TnGotoProduct(979160);return false;" --><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_05.png" alt="텐바이텐 5만원 기프트카드" /><!--/a--></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="979160" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1021823);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_06.png" alt="티키타카 20_네온" /></a></p>
					<p class="tPad10">2명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1021823" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.19 -->

		<!-- 05.20 -->
		<ul class="today0423 <% IF Hour(currenttime) > 16 then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/20/2014 00:00:00# and currenttime < #05/21/2014 00:00:00# then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(949487);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_01.png" alt="[슈퍼잼] 무설탕 천연과일잼" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="949487" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(307349);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_02.png" alt="Kaffe duo 커피메이커" /></a></p>
					<p class="tPad10">20명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="307349" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1020719);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_03.png" alt="SECOND BAG_INNER BAG" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1020719" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(381047);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_04.png" alt="[젠하이저코리아 정품] PX200Ⅱ화이트" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="381047" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(759831);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_05.png" alt="코지 리클라이닝 소파베드" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="759831" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(990722);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_06.png" alt="[필드캔디] 리틀캠퍼 우주선" /></a></p>
					<p class="tPad10">2명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="990722" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.20 -->

		<!-- 05.21 -->
		<ul class="today0424 <% IF Hour(currenttime) > 16 then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/21/2014 00:00:00# and currenttime < #05/22/2014 00:00:00# then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(855317);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_01.png" alt="FOUR SEASONS" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="855317" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(679209);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_02.png" alt="Bella Flora 장우산" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="679209" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(655381);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_03.png" alt="C-탑 로딩 팩 블루/오렌지" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="655381" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(987255);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_04.png" alt="필립스 아이폰5 도킹스피커" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="987255" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(964441);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_05.png" alt="조본업 밴드" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="964441" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(924888);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_06.png" alt="JIKE CLASSIC" /></a></p>
					<p class="tPad10">2명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="924888" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.21 -->

		<!-- 05.22 -->
		<ul class="today0425 <% IF Hour(currenttime) > 16 then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/22/2014 00:00:00# and currenttime < #05/23/2014 00:00:00# then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(540407);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_01.png" alt="WEEKADE Riding Bag" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="540407" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(588234);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_02.png" alt="BRISEZ LA GLACE(망치)" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="588234" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(841576);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_03.png" alt="Boxer(복서) 2596번" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="841576" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(894718);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_04.png" alt="ED-1" /></a></p>
					<p class="tPad10">5명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="894718" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(920191);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_05.png" alt="스널커 Astronaut_Single" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="920191" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><!-- a href="" onclick="TnGotoProduct(830847);return false;" --><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_06.png" alt="텐바이텐 3만원 기프트카드" /><!-- /a --></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="830847" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.22 -->

		<!-- 05.23 -->		
		<ul class="today0428 <% if currenttime >= #05/23/2014 17:00:00#  then  response.write "todayResult" end if %>">
			<% if currenttime >= #05/23/2014 00:00:00#  then %>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(872776);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_01.png" alt="베이퍼 친환경 물병" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="872776" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1017394);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_02.png" alt="벤시몽(Bensimon)" /></a></p>
					<p class="tPad10">20명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1017394" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(1004175);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_03.png" alt="북유럽스타일 패브릭 바스켓" /></a></p>
					<p class="tPad10">50명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="1004175" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(822728);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_04.png" alt="인스탁스 mini25 Cath kidston(Mint)" /></a></p>
					<p class="tPad10">10명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="822728" /></p>
				</li>
				<li class="todayWish">
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(894438);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_05.png" alt="허니브레인-블랙얼반 숄더&크로스백" /></a></p>
					<p class="tPad10">30명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="894438" /></p>
				</li>
				<li>
					<p class="pic"><span></span><a href="" onclick="TnGotoProduct(990718);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_06.png" alt="파이어플라이스" /></a></p>
					<p class="tPad10">1명</p>
					<p class="tPad10"><input type="radio" name="listitemid" value="990718" /></p>
				</li>
			<% end if %>
		</ul>
		<!-- //05.23 -->
	</div>
	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="itemid">
		<input type="hidden" name="sub_idx">
		<p><a href="" onclick="jsSubmitComment(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_btn02.png" alt="WISH 담기" /></a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt5.png" alt="이벤트 참여방법" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt6.png" alt="10x10 WISH를 소문내 주세요!" /></p>
	</form>
	<div class="overHidden">
		<%
			Public Function URLEncodeUTF8(byVal szSource)
				Dim szChar, WideChar, nLength, i, result
				nLength = Len(szSource)
			
				For i = 1 To nLength
					szChar = Mid(szSource, i, 1)
			
					If Asc(szChar) < 0 Then
						WideChar = CLng(AscB(MidB(szChar, 2, 1))) * 256 + AscB(MidB(szChar, 1, 1))
			
						If (WideChar And &HFF80) = 0 Then
							result = result & "%" & Hex(WideChar)
						ElseIf (WideChar And &HF000) = 0 Then
							result = result & _
								"%" & Hex(CInt((WideChar And &HFFC0) / 64) Or &HC0) & _
								"%" & Hex(WideChar And &H3F Or &H80)
						Else
							result = result & _
								"%" & Hex(CInt((WideChar And &HF000) / 4096) Or &HE0) & _
								"%" & Hex(CInt((WideChar And &HFFC0) / 64) And &H3F Or &H80) & _
								"%" & Hex(WideChar And &H3F Or &H80)
						End If
					Else
						if (Asc(szChar)>=48 and Asc(szChar)<=57) or (Asc(szChar)>=65 and Asc(szChar)<=90) or (Asc(szChar)>=97 and Asc(szChar)<=122) then
							result = result + szChar
						else
							if Asc(szChar)=32 then
								result = result & "+"
							else
								result = result & "%" & Hex(AscB(MidB(szChar, 1, 1)))
							end if
						end if
					End If
				Next
				URLEncodeUTF8 = result
			End Function

			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			dim snpTitle, strTitle2, snpLink, snpLink2, snpPre, snpPre2, snpTag, snpTag2, snpImg
			snpTitle = URLEncodeUTF8(ename)
			strTitle2 = Server.URLEncode(ename)
			snpLink = URLEncodeUTF8("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
			snpLink2 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
			snpPre = URLEncodeUTF8("텐바이텐 이벤트")
			snpPre2 = Server.URLEncode("텐바이텐 이벤트")
			snpTag = URLEncodeUTF8("텐바이텐 " & Replace(ename," ",""))
			snpTag2 = URLEncodeUTF8("#10x10")
			snpImg = URLEncodeUTF8(emimg)
		%>
			<a href="" style="width:33.33333%" class="ftLt" onclick="popSNSPost('tw','<%=strTitle2%>','<%=snpLink2%>','<%=snpPre2%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns1.png" alt="twitter" /></a>
			<a href="" style="width:33.33333%" class="ftLt" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns2.png" alt="Facebook" /></a>
			<!-- a href="" style="width:33.33333%" class="ftLt" onclick="pinit('<%=snpLink%>','<%=snpImg%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns3.png" alt="Pinterest" /></a -->
			<!--<a href="" style="width:33.33333%" class="ftLt" onclick="kakaoLink('etc','<%=snpLink%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns3.png" alt="kakaotalk" /></a>-->
			<a href="" style="width:33.33333%" class="ftLt" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns3.png" alt="kakaotalk" /></a>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt7.png" alt="이벤트 유의사항" /></p>


	<div class="lyrWinner" style="display:none;">
		<div class="lyrCont">
			<h3><span>행운의 선물 당첨 결과</span></h3>
			<div class="listWrap">
				<div class="winnerList" id="scroller">
					<div class="scroll">
						<% if currenttime < #05/12/2014 18:00:00# then %>
							<br /><br /><br /><br /><br />아직 당첨자가 없습니다.
						<% else %>
							<dl>
								<dt>5월 12일</dt>
								<dd>
									choa6**<br />gogo**<br />sis**<br />dfsto**<br />jju12**<br />yosocu**<br />gloryage06**<br />goodi89**<br />hap4**<br />peggy3**<br />sunilo**<br />luckybon**<br />won77**<br />kjs26**<br />sk76**<br />haramha**<br />jin21**<br />kyuji**<br />pink**<br />soons**<br />besthi**<br />again84**<br />gksqhdrm**<br />gkssk6**<br />binba**<br />s1175**<br />soso010**<br />yunlee**<br />czar**<br />pherse**<br />
								</dd>
							</dl>
							<dl>
								<dt>5월 13일</dt>
								<dd>
									brillia**<br />ksh8310**<br />kirt**	<br />masca09**<br />ggalme**<br />mindy**<br />tngus08**<br />bibiana**<br />epcryst**<br />pcy88**<br />bearg**<br />melong01**<br />syl14**<br />kyu**<br />lsy99**<br />lsj9507**<br />dkang**<br />ddnl**<br />erti**<br />flurry02**<br />
								</dd>
							</dl>
							<dl>
								<dt>5월 14일</dt>
								<dd>
									1mari2ma**<br />9078k**<br />ahh02**<br />ald09**<br />asfirst**<br />as**<br />bambi4**<br />daini**<br />dazlri**<br />dollygirl**<br />enchant9**<br />eyes06**<br />ghtjr**<br />gpqlswkd**<br />hee78**<br />iambb**<br />iamstrong**<br />jjo06**<br />jong77**<br />jooli**<br />lhak10**<br />lovangel**<br />min65**<br />pearlpau**<br />pineyourki**<br />soprano**<br />teddy7**<br />tjs24**<br />trecoo**<br />xic**<br />
								</dd>
							</dl>	
							<dl>
								<dt>5월 15일</dt>
								<dd>
									crazygiz**<br />dear**<br />hoi12**<br />kkom**<br />msh53**<br />
								</dd>
							</dl>	
							<dl>
								<dt>5월 16일</dt>
								<dd>
									bomw**<br />
								</dd>
							</dl>	
							<dl>
								<dt>5월 19일</dt>
								<dd>
									qkrdkssk**<br />bbackgi**<br />aaaaa72**<br />fairy**<br />itzme**<br />berrylike**<br />ejp12**<br />guswns18**<br />kth23**<br />leesh03**<br />lily**<br />brir20**<br />cherry**<br />csae**<br />cucuru10**<br />dbstn**<br />khj27**<br />khw00**<br />ksm052**<br />lim**<br />marieange**<br />Mypa**<br />orangel**<br />radiance90**<br />rami75**<br />skyel**<br />smreo**<br />sso**<br />tear07**<br />tordusvlf**<br />
								</dd>
							</dl>	
							<dl>
								<dt>5월 20일</dt>
								<dd>
									cool6**<br />dongda**<br />
								</dd>
							</dl>	
							<dl>
								<dt>5월 21일</dt>
								<dd>
									leica10**<br />happyvirus06**<br />lolita63**<br />violet03**<br />hyekyung08**<br />
								</dd>
							</dl>	
							<dl>
								<dt>5월 22일</dt>
								<dd>
									daad30**<br />lever**<br />onion**<br />saranga**<br />sky94**<br />hyunibe**<br />2011rudd**<br />helloj**<br />jisoomelo**<br />mh04**<br />jin99**<br />witch48**<br />myeun**<br />thdl06**<br />geehee9**<br />euni**<br />foxrain**<br />girly**<br />gloomy2**<br />hakuna3**<br />s1101**<br />sa45**<br />shiho**<br />skdus**<br />skv**<br />sasur**<br />sylverla**<br />wuddldi**<br />choleesol**<br />dobeeeeb**<br />
								</dd>
							</dl>	
							<dl>
								<dt>5월 23일</dt>
								<dd>
									alswjd22**<br />rhcjdt**<br />dbgml9**<br />hoho12005**<br />eskh**<br />tos**<br />tru**<br />hsorry**<br />bomjoa**<br />es7**<br />plomb**<br />jyp86**<br />alswls13**<br />heather**<br />shj0227**<br />shinhye**<br />shw7**<br />trkyj**<br />dlthdus2**<br />leeshi**<br />leipzig10**<br />les75**<br />mackit**<br />hane12**<br />sh22sh**<br />lovea**<br />kiki30**<br />meu**<br />comic**<br />guswl62**<br />
								</dd>
							</dl>
						<% end if %>
					</div>
				</div>
			</div>
			<span class="lyrClose">&times;</span>
		</div>
		<div class="dimmed"></div>
	</div>
</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<%
set myfavorite=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
