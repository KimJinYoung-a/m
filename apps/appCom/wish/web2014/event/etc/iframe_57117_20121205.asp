<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [럭키백]크리스박스의 기적 
' History : 2014.12.01 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event57117Cls.asp" -->

<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->

<%
	Dim eCode, vDisp
	Dim subscriptcount, dateitemlimitcnt, totalsubscriptcount, userid
		eCode=getevt_code
	
	Dim itemid : itemid = "1176393"
	if itemid="" or itemid="0" then
		Call Alert_AppClose("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_AppClose("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end if
	
	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim flag : flag = request("flag")

	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	'// 파라메터 접수
	vDisp = requestCheckVar(Request("disp"),18)
	if vDisp="" or (len(vDisp) mod 3)<>0 then vDisp = oItem.Prd.FcateCode

	'### 현재 위치 ###
	Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
	vIsLastDepth = true		'최하단 여부
	vCateNavi = printCategoryHistorymultiApp(vDisp,vIsLastDepth,false,vCateCnt)

subscriptcount=0
dateitemlimitcnt=0
totalsubscriptcount=0

'/상품 제한수량
dateitemlimitcnt=itemlimitcnt( dateitemval() )
'//전체 응모수
'totalsubscriptcount=getevent_subscripttotalcount(eCode, "itemcoupon", "", "")

'response.write stylecoange(currenttime)
%>

<style type="text/css">
.mEvt57117 {background-color:#fff;}
.mEvt57117 img {vertical-align:top;}
.lucky-box {}

<% if stylecoange(currenttime) = "a" then %>
	.section1{background-color:#635f96;}
	.section2 {padding-bottom:10%; background-color:#635f96;}
<% else %>
	.section1 {background-color:#ffeec9;}
	.section2 {padding-bottom:10%; background-color:#ffeec9;}
<% end if %>

.section2 ul {overflow:hidden; padding:0 5% 5%;}
.section2 ul li {float:left; width:50%; margin-top:5%; padding:0 1%;}
.section2 ul li:first-child {float:none; width:100%;}
.section2 ul li a, .section2 ul li span {display:block; padding:0 1%;}
.section2 ul li:first-child span {width:67%; margin:0 auto; padding:0;}
.section2 .item {position:relative;}
.section2 .sold-out {position:absolute; top:0; left:50%; width:96%; height:100%; margin-left:-48%; background-color:rgba(86,86,86,.6)}
.section2 .sold-out p {display:table; width:72%; margin:0 auto; height:100%;}
.section2 .sold-out p span {display:table-cell; vertical-align:middle;}
.section2 .btn-buy {width:81%; margin:10% auto 0;}
.section2 .btn-next {width:47%; margin:5% auto 0;}
.section3 {position:relative;}
.section3 .btn-kakao {position:absolute; bottom:18%; left:5%; width:50%;}
.section4 {padding-top:5%; padding-bottom:8%; background-color:#fff;}
.section4 ul {margin-top:5%; padding:0 4.7%;}
.section4 ul li {margin-top:3px; padding-left:15px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57117/blt_arrow.gif) no-repeat 0 3px; background-size:6px 7px; font-size:11px; line-height:1.375em;}
.section4 ul li em {color:#d60000;}
.section5 {margin-top:3%;}
/* layer */
.ly-chirsbox {display:none; position:absolute; top:25%; left:50% !important; z-index:210; width:96%; margin-left:-48%; background-color:#f0faf8;}
.ly-chirsbox .next-chirsbox {margin:4px; padding:10% 0; border:2px solid #bde1d2;}
.ly-chirsbox ul {overflow:hidden; padding:0 5%;}
.ly-chirsbox ul li {float:left; width:50%; margin-top:5%; padding:0 1%;}
.ly-chirsbox ul li:first-child {float:none; width:100%;}
.ly-chirsbox ul li:first-child span {width:67%; margin:0 auto; padding:0;}
.ly-chirsbox .btn-close {margin-top:10%; text-align:center;}
.ly-chirsbox .close {width:140px; height:39px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57117/btn_close.gif) no-repeat 50% 50%; background-size:140px 39px; text-indent:-999em;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.30);}
@media all and (min-width:480px){
	.section4 ul li {margin-top:5px; padding-left:15px; font-size:17px; background-position:0 6px; background-size:9px 10px;}
	.ly-chirsbox .close {width:210px; height:58px; background-size:210px 58px;}
}
</style>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
	$(function() {
		$(".btn-next a").click(function(){
			$("#ly-chirsbox").show();
			$(".mask").show();
		});

		$(".ly-chirsbox .close").click(function(){
			$("#ly-chirsbox").hide();
			$(".mask").hide();
		});

		$(".mask").click(function(){
			$("#ly-chirsbox").hide();
			$(".mask").hide();
		});
	});

function bannercall(){
	<% If left(currenttime,10)>="2014-12-03" and left(currenttime,10)<"2014-12-13" Then %>
   		evtfrm.mode.value="c2countchk";
		evtfrm.action="/apps/appcom/wish/web2014/event/etc/doEventSubscript57117.asp";
		evtfrm.target="evtFrmProc";
		evtfrm.submit();
	<% end if %>

	<% if currenttime < #12/04/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56725" %>');
	<% elseif currenttime < #12/05/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56701" %>');
	<% elseif currenttime < #12/06/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "57030" %>');
	<% elseif currenttime < #12/07/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "57294" %>');
	<% elseif currenttime < #12/08/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "57384" %>');
	<% elseif currenttime < #12/09/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "57436" %>');
	<% elseif currenttime < #12/10/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56725" %>');
	<% elseif currenttime < #12/11/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56725" %>');
	<% elseif currenttime < #12/12/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56725" %>');
	<% elseif currenttime >= #12/12/2014 00:00:00# then %>
		parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56725" %>');
	<% end if %>
}

Kakao.init('c967f6e67b0492478080bcf386390fdd');

function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If left(currenttime,10)>="2014-12-03" and left(currenttime,10)<"2014-12-13" Then %>
			<% if isApp=1 then %>
		   		evtfrm.mode.value="c1countchk";
				evtfrm.action="/apps/appcom/wish/web2014/event/etc/doEventSubscript57117.asp";
				evtfrm.target="evtFrmProc";
				evtfrm.submit();
			<% else %>
				alert("앱에서만 가능합니다.");
				return;
			<% end if %>
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		calllogin();
		return;
	<% End If %>

	kakaosend57117();
}

function kakaosend57117(){
	Kakao.Link.sendTalkLink({
	  label: '산타도 모르는 텐바이텐\n럭키박스 이벤트!\n배송비 2,000원만 내고,\n크리스박스의 주인공이 되세요.\n매일 오후3시!\n새로운 크리스박스가 열립니다!\n\n12월3일~12일까지!\n오직 텐바이텐 앱에서만 \n만날 수 있어요!',
	  image: {
		src: 'http://imgstatic.10x10.co.kr/offshop/temp/2014/201411/57117.jpg',
		width: '200',
		height: '200'
	  },
	 appButton: {
		text: '이벤트 응모하러 가기',
		execParams :{
		<% IF application("Svr_Info") = "Dev" THEN %>
			android: { url: encodeURIComponent('http://testm.10x10.co.kr:8080/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_code %>')},
			iphone: { url: 'http://testm.10x10.co.kr:8080/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_code %>'}
		<% Else %>
			android: { url: encodeURIComponent('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_code %>')},
			iphone: { url: 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_code %>'}
		<% End If %>
		}
	  },
	  installTalk : Boolean
	});
}

function TnAddShoppingBag57117(bool){
	<% If IsUserLoginOK Then %>
		<% If left(currenttime,10)>="2014-12-03" and left(currenttime,10)<"2014-12-13" Then %>
			<% if isApp=1 then %>
				<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
				    var frm = document.sbagfrm;
				    var optCode = "0000";
				
				    if (!frm.itemea.value){
						alert('장바구니에 넣을 수량을 입력해주세요.');
						return;
					}

				    frm.itemoption.value = optCode;
					frm.mode.value = "DO2";  //2014 분기
				    //frm.target = "_self";
				    frm.target = "evtFrmProc"; //2014 변경
					frm.action="/apps/appCom/wish/web2014/inipay/shoppingbag_process.asp";
					frm.submit();
				<% else %>
					alert("품절 입니다.다음 회차에 다시 구매 해주세요.");
					return;	
				<% end if %>
			<% else %>
				alert("앱에서만 구입 가능합니다.");
				return;
			<% end if %>
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		//쿠키
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript57117.asp",
			data: "mode=notlogin",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "111"){
			calllogin();
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% End If %>
}

</script>
</head>
<body>
<div class="evtCont">
	<div class="mEvt57117">
		<div class="lucky-box">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_christmas_miracle.gif" alt="산타도 모르는 텐바이텐 럭키박스 이벤트 크리스박스의 기적" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_date.gif" alt="배송비만 내고, 크리스박스의 주인공이 되세요! 산타도 모르는 기적의 상품이 여러분을 찾아갑니다. 이벤트 기간은 2014년 12월 3일부터 12월 12일까지며, 매일 오후 3시에 새로운 크리스박스가 오픈됩니다." /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox.gif" alt="" />
					<% if currenttime >= #12/03/2014 00:00:00# and currenttime < #12/05/2014 15:00:00# then %>
						<!-- for dev msg : 12/3 ~ 12/4 -->
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_chrisbox_date_01.gif" alt="매일 선착순 삼천명! 배송비 이천원만 결제하면 크리스박스가 갑니다." />
					<% end if %>
					<% if currenttime >= #12/05/2014 15:00:00# and currenttime < #12/06/2014 15:00:00# then %>
						<!-- for dev msg : 12/5 -->
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_chrisbox_date_02.gif" alt="매일 선착순 이천명! 배송비 이천원만 결제하면 크리스박스가 갑니다." />
					<% end if %>
					<% if currenttime >= #12/06/2014 15:00:00# and currenttime < #12/08/2014 15:00:00# then %>
						<!-- for dev msg : 12/6 ~ 12/7 -->
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_chrisbox_date_03.gif" alt="매일 선착순 천이백명! 배송비 이천원만 결제하면 크리스박스가 갑니다." />
					<% end if %>
					<% if currenttime >= #12/08/2014 15:00:00# then %>
						<!-- for dev msg : 12/8 ~ 12/12 -->
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_chrisbox_date_04.gif" alt="매일 선착순 오백명! 배송비 이천원만 결제하면 크리스박스가 갑니다." />
					<% end if %>
				</p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_take_away.gif" alt="참여방법은 텐바이텐 로그인 후 크리스마스를 구매하시면 크리스박스 상품을 받으시면 되요" /></p>
			</div>

			<!-- 오늘의 크리스박스 -->
			<div class="section section2">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/tit_today_christbox.gif" alt="오늘의 크리스박스" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_random.gif" alt="크리스박스에는 아래 상품이 랜덤으로 담겨 발송됩니다!" /></p>
				<div class="item">
					<ul>
						<% if currenttime >= #12/03/2014 00:00:00# and currenttime < #12/13/2014 00:00:00# then %>
							<!-- for dev msg : 맥북은 고정 상품 -->
							<li><span><a href="" onclick="fnAPPpopupProduct('1176162'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_macbook.png" alt="애플 맥북 에어 13.3인치 1,439,000원" /></a></span></li>
						<% end if %>
						
						<!-- for dev msg : 매일 4개 상품이 바뀝니다. 12/3 -->
						<% if currenttime >= #12/03/2014 00:00:00# and currenttime < #12/04/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('1153596'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_01_01.png" alt="네오 스마트펜 N2 178,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1077842'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_01_02.png" alt="심슨 캐릭터 USB 메모리 8기가 29,900원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1163356'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_01_03.png" alt="2015 DER REISENDE DIARY 9,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_01_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/04/2014 15:00:00# and currenttime < #12/05/2014 15:00:00# then %>
							<!-- 12/4 -->
							<li><a href="" onclick="fnAPPpopupProduct('310036'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_02_01.png" alt="안젤라시즌4 20인치 178,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1157043'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_02_02.png" alt="개인용 청정가습기 포그링 28,600원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('787842'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_02_03.png" alt="폭스바겐 마이크로버스 9,000원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_02_04.png" alt="MMMG 머그컵 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/05/2014 15:00:00# and currenttime < #12/06/2014 15:00:00# then %>
							<!-- 12/5 -->
							<li><a href="" onclick="fnAPPpopupProduct('1072344'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_03_01.png" alt="아이리버 블루투스 오디오 169,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('977528'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_03_02.png" alt="터치미손난로 49,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('942372'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_03_03.png" alt="Hungry bunny 13,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_03_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/06/2014 15:00:00# and currenttime < #12/07/2014 15:00:00# then %>
							<!-- 12/6 -->
							<li><a href="" onclick="fnAPPpopupProduct('971795'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_04_01.png" alt="그랑드글라스 1.2M 트리풀세트 162,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1143505'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_04_02.png" alt="샤오미 보조배터리 23,900원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('864470'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_04_03.png" alt="Organic Soy Candle 19,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_04_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/07/2014 15:00:00# and currenttime < #12/08/2014 15:00:00# then %>
							<!-- 12/7 -->
							<li><a href="" onclick="fnAPPpopupProduct('1062101'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_01.png" alt="프리 리클라이닝 소파베드 210,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('689629'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_02.png" alt="TIMEX Weekender 68,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1151678'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_03.png" alt="꽃보다 에로메스 라마 인형 20,000원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_04.png" alt="MMMG 머그컵 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/08/2014 15:00:00# and currenttime < #12/09/2014 15:00:00# then %>
							<!-- 12/8 -->
							<li><a href="" onclick="fnAPPpopupProduct('1153596'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_01.png" alt="네오 스마트펜 N2 178,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1077842'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_02.png" alt="심슨 캐릭터 USB 메모리 8기가 29,900원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1163356'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_03.png" alt="2015 DER REISENDE DIARY 9,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/09/2014 15:00:00# and currenttime < #12/10/2014 15:00:00# then %>
							<!-- 12/9 -->
							<li><a href="" onclick="fnAPPpopupProduct('310036'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_01.png" alt="안젤라시즌4 20인치 178,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1157043'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_02.png" alt="개인용 청정가습기 포그링 28,600원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('787842'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_03.png" alt="폭스바겐 마이크로버스 9,000원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_04.png" alt="MMMG 머그컵 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/10/2014 15:00:00# and currenttime < #12/11/2014 15:00:00# then %>
							<!-- 12/10 -->
							<li><a href="" onclick="fnAPPpopupProduct('1072344'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_08_01.png" alt="아이리버 블루투스 오디오 169,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('977528'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_08_02.png" alt="터치미손난로 49,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('942372'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_08_03.png" alt="Hungry bunny 13,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_04.png" alt="MMMG 머그컵 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/11/2014 15:00:00# and currenttime < #12/12/2014 15:00:00# then %>
							<!-- 12/11 -->
							<li><a href="" onclick="fnAPPpopupProduct('971795'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_09_01.png" alt="그랑드글라스 1.2M 트리풀세트 162,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1143505'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_09_02.png" alt="샤오미 보조배터리 23,900원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('864470'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_09_03.png" alt="Organic Soy Candle 19,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_09_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>

						<% if currenttime >= #12/12/2014 15:00:00# and currenttime < #12/13/2014 00:00:00# then %>
							<!-- 12/12 -->
							<li><a href="" onclick="fnAPPpopupProduct('1062101'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_10_01.png" alt="프리 리클라이닝 소파베드 210,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('689629'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_10_02.png" alt="TIMEX Weekender 68,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1151678'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_10_03.png" alt="꽃보다 에로메스 라마 인형 20,000원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_10_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>
					</ul>

					<!-- for dev msg : 선착순 3천명 소진시 보여주세요. -->
					<% IF oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut Then %>
						<div class="sold-out">
							<p><span><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/txt_sold_out.png" alt="솔드아웃 매일 오후 3시, 새로운 크리스박스가 오픈됩니다." /></span></p>
						</div>
					<% End if %>
				</div>

				<div class="btn-buy">
					<% if isApp=1 then %>
						<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
							<a href="" onclick="TnAddShoppingBag57117();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_buy.gif" alt="크리스박스 구매하기" /></a>
						<% Else %>
							<a href="" onclick="alert('품절 입니다.다음 회차에 다시 구매 해주세요.');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_buy.gif" alt="크리스박스 구매하기" /></a>
						<% end if %>
					<% else %>
						<a href="" onclick="alert('앱에서만 구입 가능합니다.');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_buy.gif" alt="크리스박스 구매하기" /></a>
					<% end if %>
				</div>
				<div class="btn-next">
					<a href="#ly-chirsbox"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_view_next_chrisbox.gif" alt="다음 크리스박스 보기 매일 오후 3시에 오픈됩니다." /></a>
				</div>
			</div>

			<div id="ly-chirsbox" class="ly-chirsbox">
				<div class="next-chirsbox">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/tit_next_chrisbox.gif" alt="NEXT 크리스박스" /></h3>
					<ul class="next-item">
						<li><span><a href="" onclick="fnAPPpopupProduct('1176162'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117/img_chrisbox_macbook.png" alt="애플 맥북 에어 13.3인치 1,439,000원" /></a></span></li>
						<% if currenttime >= #12/03/2014 00:00:00# and currenttime < #12/04/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('310036'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_02_01.png" alt="안젤라시즌4 20인치 178,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1157043'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_02_02.png" alt="개인용 청정가습기 포그링 28,600원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('787842'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_02_03.png" alt="폭스바겐 마이크로버스 9,000원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_04.png" alt="MMMG 머그컵 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/04/2014 15:00:00# and currenttime < #12/05/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('1072344'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_03_01.png" alt="아이리버 블루투스 오디오 169,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('977528'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_03_02.png" alt="터치미손난로 49,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('942372'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_03_03.png" alt="Hungry bunny 13,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_03_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/05/2014 15:00:00# and currenttime < #12/06/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('971795'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_04_01.png" alt="그랑드글라스 1.2M 트리풀세트 162,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1143505'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_04_02.png" alt="샤오미 보조배터리 23,900원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('864470'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_04_03.png" alt="Organic Soy Candle 19,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_04_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/06/2014 15:00:00# and currenttime < #12/07/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('1062101'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_01.png" alt="프리 리클라이닝 소파베드 210,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('689629'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_02.png" alt="TIMEX Weekender 68,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1151678'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_03.png" alt="꽃보다 에로메스 라마 인형 20,000원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_05_04.png" alt="MMMG 머그컵 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/07/2014 15:00:00# and currenttime < #12/08/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('1153596'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_01.png" alt="네오 스마트펜 N2 178,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1077842'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_02.png" alt="심슨 캐릭터 USB 메모리 8기가 29,900원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1163356'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_03.png" alt="2015 DER REISENDE DIARY 9,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_06_05.png" alt="MMMG 머그컵 4,500원" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_tree_b.gif" alt="" /></li>
						<% end if %>
						
						<% if currenttime >= #12/08/2014 15:00:00# and currenttime < #12/09/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('310036'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_01.png" alt="안젤라시즌4 20인치 178,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1157043'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_02.png" alt="개인용 청정가습기 포그링 28,600원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('787842'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_03.png" alt="폭스바겐 마이크로버스 9,000원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_04.png" alt="MMMG 머그컵 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/09/2014 15:00:00# and currenttime < #12/10/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('1072344'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_08_01.png" alt="아이리버 블루투스 오디오 169,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('977528'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_08_02.png" alt="터치미손난로 49,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('942372'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_08_03.png" alt="Hungry bunny 13,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_07_04.png" alt="MMMG 머그컵 4,500원" /></li>
						<% end if %>
						
						<% if currenttime >= #12/10/2014 15:00:00# and currenttime < #12/11/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('971795'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_09_01.png" alt="그랑드글라스 1.2M 트리풀세트 162,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1143505'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_09_02.png" alt="샤오미 보조배터리 23,900원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('864470'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_09_03.png" alt="Organic Soy Candle 19,800원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_09_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>

						<% if currenttime >= #12/11/2014 15:00:00# and currenttime < #12/12/2014 15:00:00# then %>
							<li><a href="" onclick="fnAPPpopupProduct('1062101'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_10_01.png" alt="프리 리클라이닝 소파베드 210,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('689629'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_10_02.png" alt="TIMEX Weekender 68,000원" /></a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1151678'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_10_03.png" alt="꽃보다 에로메스 라마 인형 20,000원" /></a></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/img_chrisbox_10_04.png" alt="10x10 PRESENT 워터볼 4,500원" /></li>
						<% end if %>
					</ul>
					<div class="btn-close"><button type="button" class="close">닫기</button></div>
				</div>
			</div>

			<div class="section section3">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/tit_kakao.gif" alt="친구에게도 크리스박스를 알려주세요! 12월의 기적을 선물하세요!" /></h2>
				<div class="btn-kakao">
					<a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_kakao.gif" alt="친구에게 알려주기" /></a>
				</div>
			</div>
			
			<!-- 이벤트 링크 -->
			<div class="section section5">
				<p>
					<a href="" onclick="bannercall(); return false;">
						<% if currenttime < #12/04/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_01.gif" alt="가스비 잡는 방한용품 발빠르게 준비하는 방한용품으로, 똑똑하게 월동 준비하세요!" />
						<% elseif currenttime < #12/05/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_02.jpg" alt="허니버터칩은 가라!! 극강의 맛! 하바나 옥수수 22% 할인 상품보러 가기" />
						<% elseif currenttime < #12/06/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_03.gif" alt="미안하다 생색이다 자신있게 말합니다! 온르 하루 앱에서 할인 쿠폰 다운받으러 가기" />
						<% elseif currenttime < #12/07/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_04.jpg" alt="날따라 사봐요 이렇게! 보는 순간 사게되는 텐바이텐 베스트 핫 아이템!" />
						<% elseif currenttime < #12/08/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_05.gif" alt="12 첫재쭈 주말 특가" />
						<% elseif currenttime < #12/09/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_06.jpg" alt="김수현 어느 별에서 왔니? 김수현 2015 시즌그리팅 단독 예약판매!" />
						<% elseif currenttime < #12/10/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_01.gif" alt="" />
						<% elseif currenttime < #12/11/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_01.gif" alt="" />
						<% elseif currenttime < #12/12/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_01.gif" alt="" />
						<% elseif currenttime >= #12/12/2014 00:00:00# then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/btn_bnr_01.gif" alt="" />
						<% end if %>
					</a>
				</p>
			</div>
			<div class="section section4">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117<%=stylecoange(currenttime)%>/tit_noti.gif" alt="이벤트 유의사항" /></h2>
				<ul>
					<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
					<li>크리스박스는 하루에 한 번만 구매가 가능합니다.</li>
					<li>크리스박스 속 상품은 랜덤으로 담겨 발송됩니다. </li>
					<li><em>본 이벤트 페이지를 다시 방문하기 위해서는 앱을 닫고, 재실행해주세요.(재실행 후, 노출되는 이벤트 배너를 클릭해야 입장할 수 있습니다.)</em></li>
					<li>크리스박스는 즉시 결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
				</ul>
			</div>
		</div>
		<div class="mask"></div>
	</div>
	<!--// [럭키백]크리스박스의 기적 -->
</div>
<form name="evtfrm" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="mode">
</form>
<form name="sbagfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode" value="add" />
<input type="hidden" name="itemid" value="<%= itemid %>" />
<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
<input type="hidden" name="itemoption" value="0000" />
<input type="hidden" name="userid" value="<%= getloginuserid() %>" />
<input type="hidden" name="isPresentItem" value="" />
<input type="hidden" name="itemea" readonly value="1" />
</form>	
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<% Set oItem = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->