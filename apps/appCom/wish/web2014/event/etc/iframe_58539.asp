<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 어벤져박스의 기적
' History : 2015-01-14 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

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

	Dim vEdate : vEdate = "2015-01-25 23:59:59" '//주말

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21435
	Else
		eCode   =  58539
	End If
	
	Dim itemid : itemid = "1197448"
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
	dateitemlimitcnt=getitemlimitcnt(itemid)
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
.mEvt58539 {position:relative; margin-bottom:-50px;}
.mEvt58539 img {vertical-align:top;}
.mEvt58539 .evtNoti {padding:27px 14px; background:#fff;}
.mEvt58539 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt58539 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.mEvt58539 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}

.soldOut {position:absolute; left:0; top:0; z-index:50; width:100%;}
.avgPdt {position:relative;}
.avgPdt li {position:absolute; width:36%;}
.avgPdt li a,
.avgPdt li span {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.todayBox li { height:17.5%;}
.todayBox li.p01 {left:21%; top:13%; width:58%; height:25%;}
.todayBox li.p02 {left:10%; top:41%;}
.todayBox li.p03 {right:10%; top:41%;}
.todayBox li.p04 {left:10%; top:62%;}
.todayBox li.p05 {right:10%;  top:62%;}
.todayBox .goBtn {display:block; position:absolute; cursor:pointer;}
.todayBox .goBtn a {display:block;}
.todayBox .goBuy {left:10%; bottom:9%; width:80%;}
.todayBox .goNext {left:25%; bottom:4%; width:50%;}
.nextBox li {height:20%;}
.nextBox li.p01 {left:21%; top:11%; width:58%; height:28%;}
.nextBox li.p02 {left:10%; top:42%;}
.nextBox li.p03 {right:10%; top:42%;}
.nextBox li.p04 {left:10%; top:66%;}
.nextBox li.p05 {right:10%;  top:66%;}

/* 추가 */
.lastDay .todayBox .goBuy {bottom:4%;}
.lastDay .todayBox li {height:20%;}
.lastDay .todayBox li.p01 {top:14%; height:26%;}
.lastDay .todayBox li.p02 {top:43%;}
.lastDay .todayBox li.p03 {top:43%;}
.lastDay .todayBox li.p04 {top:65%;}
.lastDay .todayBox li.p05 {top:65%;}

.weekend .making {text-align:center; padding:11% 0; background:#242e51;}
.weekend .making .timer {padding:5% 0 6%;}
.weekend .making .timer em {display:inline-block; width:34px; height:34px; line-height:36px; font-size:23px; font-weight:bold; background:#fff;}
.weekend .making .timer span {display:inline-block; line-height:36px; font-size:23px; font-weight:bold; color:#fff; padding:0 2px;}
.weekend .promotion {background:#545f87; margin-bottom:50px;}
.weekend .promotion p {padding:0 3% 4.5%;}
.weekend .promotion {padding-bottom:3.5%;}
.weekend .goNext {display:block; width:53%; margin:0 auto;}
/* 추가 */

.avengerLayer {display:none; position:absolute; left:0; z-index:40; width:100%;}
.viewResult {top:58%; }
.viewNext {top:38%; }
.layerCont {padding-top:8%;}
.layerCont .lyBtn {display:block; position:absolute; left:20%; bottom:12%; width:60%;}
.layerCont .win .lyBtn {bottom:16%;}
.layerCont .closeBtn {bottom:5%;}
.mask {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5); z-index:30;}

@media all and (min-width:480px){
	/* 추가 */
	.weekend .making .timer em {width:51px; height:51px; line-height:54px; font-size:35px;}
	.weekend .making .timer span {line-height:54px; font-size:35px;padding:0 3px;}
	/* 추가 */

	.mEvt58539 .evtNoti {padding:40px 21px;}
	.mEvt58539 .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt58539 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt58539 .evtNoti li:after {top:6px; border-width:5px 0 5px 7px;}
}
</style>
<script type="text/javascript">
//버튼 관련
$(function(){
	$(".goNext").click(function(){
		<% IF (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
		$(".soldOut").css("z-index","1");
		<% end if %>
		$(".viewNext").show();
		$(".mask").show();
	});

	$(".lyBtn").click(function(){
		$(".viewNext").hide();
		$(".viewResult").hide();
		$(".mask").hide();
	});

	$(".mask").click(function(){
		if(confirm("현재 보고 있는 레이어를 닫으시겠습니까?")){
			$(".viewNext").hide();
			$(".viewResult").hide();
			$(".mask").hide();
		}
	});
});

//쿠폰Process
function get_coupon(){
	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript58539.asp",
		data: "mode=coupon",
		dataType: "text",
		async: false
	}).responseText;
	if (rstStr == "SUCCESS"){
		alert('쿠폰이 발급되었습니다.\n친구에게 어벤져박스를 알려주면, 한번 더 응모가 가능합니다.');
		return false;
	}else{
		alert('관리자에게 문의');
		return false;
	}
}

//주문Process
function TnAddShoppingBag58539(bool){
	<% If IsUserLoginOK Then %>
		<% If left(now(),10)>="2015-01-19" and left(now(),10)<"2015-01-31" Then %>
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
					return;
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
			url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript58539.asp",
			data: "mode=notlogin",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "OK"){
			parent.calllogin();
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% End If %>
}
	
//응모
function goAvengers(){
	<% If IsUserLoginOK Then %>
		<% If left(now(),10)>="2015-01-19" and left(now(),10)<"2015-01-31" Then %>
			<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
				var rstStr = $.ajax({
					type: "POST",
					url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript58539.asp",
					data: "mode=add",
					dataType: "text",
					async: false
				}).responseText;

				if (rstStr == "SUCCESS"){
					// success
					$(".viewResult").show();
					$(".viewResult .lose").hide();
					$(".viewResult .win").show();
					$(".mask").show();
					return false;
				}else if (rstStr == "FAIL"){
					// fail
					$(".viewResult").show();
					$(".viewResult .win").hide();
					$(".viewResult .lose").show();
					$(".mask").show();
					return false;
				}else if (rstStr == "END"){
					// end
					alert('오늘은 모두 참여 하셨습니다.');
					return false;
				}else if (rstStr == "KAKAO"){
					// kakao
					alert('친구에게 어벤져박스를 알려주면, 한 번 더! 응모 기회가 생겨요!');
					return false;
				}else if (rstStr == "SOLDOUT"){
					// soldout
					alert('오늘의 어벤져 박스는 품절 입니다.');
					return false;
				}
			<% else %>
				alert("오늘의 어벤져박스는 품절 입니다.");
				return;	
			<% end if %>
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		parent.calllogin();
		return false;
	<% end if %>
}

//카카오 친구 초대
function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If left(now(),10)>="2015-01-19" and left(now(),10)<"2015-01-31" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript58539.asp",
				data: "mode=kakao",
				dataType: "text",
				async: false
			}).responseText;
			//alert(rstStr);
			if (rstStr == "SUCCESS"){
				// success
				parent.parent_kakaolink('[텐바이텐] 어벤져박스의 기적!\n2015년, 위기의 순간! 당신을 도와줄 어벤져박스가 갑니다!\n매일 새로운 상품들을 배송비만 내고 받을 수 있는 기회!\n어디에서?\n오직 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/58539/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
				return false;
			}else if (rstStr == "FAIL"){
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}else if (rstStr == "END"){
				alert('오늘은 모두 참여 하셨습니다.');
				return false;
			}else if (rstStr == "NOT1"){
				alert('어벤저박스 응모후 눌러 주세요');
				return false;
			}else if (rstStr == "NOT2"){
				alert('오늘의 기적은 모두 참여 하셨습니다.');
				return false;
			}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		parent.calllogin();
		return;
	<% End If %>
}

	//주말용
	function go_Etcevent(v){
		//chk_click
		var modename
		var url
		if (v == "1"){
			modename = "mode=banner1";
			url = "56864";
		}else if(v == "2"){
			modename = "mode=banner2";
			url = "58600";
		}else{
			return;
		}

		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript58539.asp",
			data: modename,
			dataType: "text",
			async: false
		}).responseText;
			if (rstStr == "OK"){
				fnAPPpopupEvent(url);
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
	}

<% If now() > #01/24/2015 00:00:00# and now() < #01/26/2015 00:00:00# Then %>
var yr = "<%=Year(vEdate)%>";
var mo = "<%=TwoNumber(Month(vEdate))%>";
var da = "<%=TwoNumber(Day(vEdate))%>";
var hh = "<%=TwoNumber(hour(vEdate))%>";
var mm = "<%=TwoNumber(minute(vEdate))%>";
var ss = "<%=TwoNumber(second(vEdate))%>";
var tmp_hh = "99";
var tmp_mm = "99";
var tmp_ss = "99";
var minus_second = 0;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000)
		todayy+=1900
		

		var todaym=today.getMonth()
		var todayd=today.getDate()
		var todayh=today.getHours()
		var todaymin=today.getMinutes()
		var todaysec=today.getSeconds()
		var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
		//futurestring=montharray[mo-1]+" "+da+", "+yr+" 11:59:59";
		futurestring=montharray[mo-1]+" "+da+", "+yr+" "+hh+":"+mm+":"+ss;

		dd=Date.parse(futurestring)-Date.parse(todaystring)
		dday=Math.floor(dd/(60*60*1000*24)*1)
		dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
		dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
		dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)

		if (dday == 1){
			dhour = dhour + 24
		}

		if(dhour < 0)
		{
			$("#lyrCounter").hide();
			return;
		}

		if(dhour < 10) {
			dhour = "0" + dhour;
		}
		if(dmin < 10) {
			dmin = "0" + dmin;
		}
		if(dsec < 10) {
			dsec = "0" + dsec;
		}

		$("#lyrCounter").html("<em>"+Left(dhour,1)+ "</em> <em>"+ Right(dhour,1)+ "</em> <span>:</span> <em>"+ Left(dmin,1) +"</em> <em>"+ Right(dmin,1)+ "</em> <span>:</span> <em>"+ Left(dsec,1) + "</em> <em>"+ Right(dsec,1)+ "</em>");
		
		tmp_hh = dhour;
		tmp_mm = dmin;
		tmp_ss = dsec;
		minus_second = minus_second + 1;

	setTimeout("countdown()",1000)
}

countdown();

//left
function Left(Str, Num){
	if (Num <= 0)
		return "";
	else if (Num > String(Str).length)
		return Str;
	else
		return String(Str).substring(0,Num);
}

//right
function Right(Str, Num){
	if (Num <= 0)
		return "";
	else if (Num > String(Str).length)
		return Str;
	else
		var iLen = String(Str).length;
		return String(Str).substring(iLen, iLen-Num);
}
<% end if %>
</script>
</head>
<body>
<div class="evtCont">
	<!-- 어벤져박스의 기적(APP) -->
	<div class="mEvt58539">

		<% If (now() > #01/19/2015 00:00:00# and now() < #01/24/2015 00:00:00#) Or (now() > #01/26/2015 00:00:00# and now() < #01/31/2015 00:00:00#)  Then %>
			<% If hour(now()) < 10 Then '//커밍순%>
			<p class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/txt_soon.png" alt="COMING SOON" /></p>
			<% Else %>
				<% IF oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem Then '//SOLD OUT %> 
				<p class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/txt_soldout_.png" alt="SOLD OUT" /></p>
				<% End If %>
			<% End If %>
		<% End If %>
		<!-- 1월 19일 -->
		<% If now() > #01/19/2015 00:00:00# and now() < #01/20/2015 00:00:00# Then %>
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0119.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0119.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><a href="" onclick="fnAPPpopupProduct(1182606);return false;"  target="_top">애플 아이패드 미니3</a></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(801326);return false;"  target="_top">카이젤 가정용 토스터기 TO-20S</a></li>
					<li class="p03"><a href="" onclick="fnAPPpopupProduct(1171539);return false;"  target="_top">써모머그 엄브렐러 보틀</a></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(1181201);return false;"  target="_top">어벤져스 스마트폰 컨트롤톡 이어폰</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(1146493);return false;"  target="_top">반8 미니거울</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="응모하기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<!--// 1월 19일 -->
		<% End If %>

		<% If now() > #01/20/2015 00:00:00# and now() < #01/21/2015 00:00:00# Then %>
		<!-- 1월 20일 -->
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0120.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0120.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><a href="" onclick="fnAPPpopupProduct(1176161);return false;"  target="_top">애플 맥북에어 13형</a></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(425856);return false;"  target="_top">클래식 턴테이블</a></li>
					<li class="p03"><a href="" onclick="fnAPPpopupProduct(1161808);return false;"  target="_top">꽃송이가습기</a></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(457154);return false;"  target="_top">양키캔들</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(234933);return false;"  target="_top">모빌</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="응모하기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<!--// 1월 20일 -->
		<% End If %>

		<% If now() > #01/21/2015 00:00:00# and now() < #01/22/2015 00:00:00# Then %>
		<!-- 1월 21일 -->
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0123.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0123.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><a href="" onclick="fnAPPpopupProduct(1176161);return false;"  target="_top">애플 맥북에어 13형</a></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(1077842);return false;"  target="_top">심슨 캐릭터 USB 메모리</a></li>
					<li class="p03"><span>2015 몰스킨</span></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(865506);return false;"  target="_top">파우치</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(1030004);return false;"  target="_top">후치코</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="응모하기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<!--// 1월 21일 -->
		<% End If %>

		<% If now() > #01/22/2015 00:00:00# and now() < #01/23/2015 00:00:00# Then %>
		<!-- 1월 22일 -->
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0122.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0122.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><span>일본 온천 패키지</span></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(1151190);return false;"  target="_top">스마트빔 큐브 미니빔</a></li>
					<li class="p03"><a href="" onclick="fnAPPpopupProduct(1130755);return false;"  target="_top">비밀의 정원</a></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(822463);return false;"  target="_top">메탈웍스</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(1115073);return false;"  target="_top">자동스탬프</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="응모하기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<!--// 1월 22일 -->
		<% End If %>

		<% If now() > #01/23/2015 00:00:00# and now() < #01/24/2015 00:00:00# Then %>
		<!-- 1월 23일 -->
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0121.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0121.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><a href="" onclick="fnAPPpopupProduct(1182606);return false;"  target="_top">애플 아이패드 미니3</a></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(1153845);return false;"  target="_top">문스케일 디자인 체중계</a></li>
					<li class="p03"><a href="" onclick="fnAPPpopupProduct(949903);return false;"  target="_top">collinette 미니 지압기</a></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(1135607);return false;"  target="_top">달콤한 노라인 줄넘기 캔디</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(1042723);return false;"  target="_top">삐약이계란비누세트</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="응모하기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<!--// 1월 23일 -->
		<% End If %>

		<% If now() > #01/24/2015 00:00:00# and now() < #01/26/2015 00:00:00# Then %>
		<!-- 주말노출(24,25) -->
		<div class="avengersMiracle weekend">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_weekend.gif" alt="" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_making_box.gif" alt="" /></p>
			<div class="making">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/txt_monday_open.gif" alt="월요일 오전 10시! OPEN!" /></p>
				<div class="timer" id="lyrCounter">
					<em>0</em>
					<em>0</em>
					<span>:</span>
					<em>0</em>
					<em>0</em>
					<span>:</span>
					<em>0</em>
					<em>0</em>
				</div>
				<a href="#" class="goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box02.gif" alt="NEXT 어벤져박스 보기" /></a>
			</div>
			<div class="promotion">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_ten_weekend.gif" alt="" /></h3>
				<p><a href="#" onclick="go_Etcevent('1'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/bnr_event01.jpg" alt="PROJECT 2015" /></a></p>
				<p><a href="#" onclick="go_Etcevent('2'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/bnr_event02.jpg" alt="첫 눈에 반해 먹었어요" /></a></p>
			</div>
		</div>
		<!--// 주말노출 -->
		<% End If %>

		<% If now() > #01/26/2015 00:00:00# and now() < #01/27/2015 00:00:00# Then %>
		<!--// 1월 26일 -->
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0126.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0126.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><a href="" onclick="fnAPPpopupProduct(1182606);return false;" target="_top">애플 아이패드 미니3</a></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(801326);return false;" target="_top">카이젤 가정용 토스터기 TO-20S</a></li>
					<li class="p03"><a href="" onclick="fnAPPpopupProduct(1171539);return false;" target="_top">써모머그 엄브렐러 보틀</a></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(1181201);return false;" target="_top">어벤져스 스마트폰 컨트롤톡 이어폰</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(1146493);return false;" target="_top">반8 미니거울</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="구매하러가기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<% End If %>

		<% If now() > #01/27/2015 00:00:00# and now() < #01/28/2015 00:00:00# Then %>
		<!--// 1월 27일 -->
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0127.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0127.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><a href="" onclick="fnAPPpopupProduct(1176161);return false;" target="_top">애플 맥북에어 13형</a></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(425856);return false;" target="_top">클래식 턴테이블</a></li>
					<li class="p03"><a href="" onclick="fnAPPpopupProduct(1161808);return false;" target="_top">꽃송이가습기</a></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(457154);return false;" target="_top">양키캔들</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(234933);return false;" target="_top">모빌</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="구매하러가기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<% End If %>

		<% If now() > #01/28/2015 00:00:00# and now() < #01/29/2015 00:00:00# Then %>
		<!--// 1월 28일 -->
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0130_.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0130_.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><a href="" onclick="fnAPPpopupProduct(1176161);return false;" target="_top">애플 맥북에어 13형</a></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(1077842);return false;" target="_top">심슨 캐릭터 USB 메모리</a></li>
					<li class="p03"><span>2015 몰스킨</span></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(865506);return false;" target="_top">파우치</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(1030004);return false;" target="_top">후치코</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="구매하러가기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<% End If %>

		<% If now() > #01/29/2015 00:00:00# and now() < #01/30/2015 00:00:00# Then %>
		<!--// 1월 29일 -->
		<div class="avengersMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0129.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0129.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><span>일본 온천 패키지</span></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(1151190);return false;" target="_top">스마트빔 큐브 미니빔</a></li>
					<li class="p03"><a href="" onclick="fnAPPpopupProduct(1130755);return false;" target="_top">비밀의 정원</a></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(822463);return false;" target="_top">메탈웍스</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(1115073);return false;" target="_top">자동스탬프</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="구매하러가기" /></a>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a>
			</div>
		</div>
		<% End If %>

		<% If now() > #01/30/2015 00:00:00# and now() < #01/31/2015 00:00:00# Then %>
		<!--// 1월 30일 -->
		<div class="avengersMiracle lastDay">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0128.gif" alt="오늘의 HELP" /></h2>
			<div class="avgPdt todayBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_box_0128.jpg" alt="오늘의 어벤져박스" /></p>
				<ul>
					<li class="p01"><a href="" onclick="fnAPPpopupProduct(1182606);return false;" target="_top">애플 아이패드 미니3</a></li>
					<li class="p02"><a href="" onclick="fnAPPpopupProduct(1153845);return false;" target="_top">문스케일 디자인 체중계</a></li>
					<li class="p03"><a href="" onclick="fnAPPpopupProduct(949903);return false;" target="_top">collinette 미니 지압기</a></li>
					<li class="p04"><a href="" onclick="fnAPPpopupProduct(1135607);return false;" target="_top">달콤한 노라인 줄넘기 캔디</a></li>
					<li class="p05"><a href="" onclick="fnAPPpopupProduct(1042723);return false;" target="_top">삐약이계란비누세트</a></li>
				</ul>
				<a href="" onclick="goAvengers();return false;" class="goBtn goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_apply.png" alt="구매하러가기" /></a>
				<!-- <a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box.png" alt="NEXT 어벤져박스 보기" /></a> -->
			</div>
		</div>
		<% End If %>

		<!--// 오늘의 상품 -->

		<!-- 레이어팝업 (당첨여부) -->
		<div id="viewResult" class="avengerLayer viewResult">
			<div class="layerCont">

				<!-- 당첨 -->
				<div class="win" style="display:none">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_result_win.png" alt="오늘의 어벤져박스" /></p>
					<a href="" <% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>onclick="TnAddShoppingBag58539();return false;"<% Else %>onclick="alert('품절 되었습니다.');return false;"<% End If %> class="lyBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_buy.gif" alt="구매하러가기" /></a>
				</div>
				<!--// 당첨 -->

				<!-- 비당첨 -->
				<div class="lose" style="display:none">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_result_lose.png" alt="악! 이런 어벤져박스에 당첨되지 않았어요" /></p>
					<a href="" onclick="get_coupon();return false;" class="lyBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_down_coupon.gif" alt="쿠폰 다운받기" /></a>
				</div>
				<!--// 비당첨 -->

			</div>
		</div> 
		<!--// 레이어팝업 (당첨여부) -->

		<!-- 레이어팝업 (NEXT 어벤져박스) -->
		<div id="viewNext" class="avengerLayer viewNext">
			<div class="layerCont">
				<% If now() > #01/19/2015 00:00:00# and now() < #01/20/2015 00:00:00# Then %>
				<!-- 1월 19일 -->
				<div class="avgPdt nextBox">
					<ul>
						<li class="p01"><a href="" onclick="fnAPPpopupProduct(1176161);return false;"  target="_top">애플 맥북에어 13형</a></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(425856);return false;"  target="_top">클래식 턴테이블</a></li>
						<li class="p03"><a href="" onclick="fnAPPpopupProduct(1161808);return false;"  target="_top">꽃송이가습기</a></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(457154);return false;"  target="_top">양키캔들</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(234933);return false;"  target="_top">모빌</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0119.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 19일 -->
				<% End If %>

				<% If now() > #01/20/2015 00:00:00# and now() < #01/21/2015 00:00:00# Then %>
				<!-- 1월 20일 -->
				<div class="avgPdt nextBox">
					<ul>
						<li class="p01"><a href="" onclick="fnAPPpopupProduct(1176161);return false;"  target="_top">애플 맥북에어 13형</a></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(1077842);return false;"  target="_top">심슨 캐릭터 USB 메모리</a></li>
						<li class="p03"><span>2015 몰스킨</span></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(865506);return false;"  target="_top">mmmg 파우치</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(1030004);return false;"  target="_top">후치코</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0122.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 20일 -->
				<% End If %>


				<% If now() > #01/21/2015 00:00:00# and now() < #01/22/2015 00:00:00# Then %>
				<!-- 1월 21일 -->
				<div class="avgPdt nextBox">
					<ul>
						<li class="p01"><span>일본 온천 패키지</span></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(1151190);return false;"  target="_top">스마트빔 큐브 미니빔</a></li>
						<li class="p03"><a href="" onclick="fnAPPpopupProduct(1130755);return false;"  target="_top">비밀의 정원</a></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(822463);return false;"  target="_top">메탈웍스</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(1115073);return false;"  target="_top">자동스탬프</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0121.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 21일 -->
				<% End If %>

				<% If now() > #01/22/2015 00:00:00# and now() < #01/23/2015 00:00:00# Then %>
				<!-- 1월 22일 -->
				<div class="avgPdt nextBox">
					<ul>
						<li class="p01"><a href="" onclick="fnAPPpopupProduct(1182606);return false;"  target="_top">애플 아이패드 미니3</a></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(1153845);return false;"  target="_top">문스케일 디자인 체중계</a></li>
						<li class="p03"><a href="" onclick="fnAPPpopupProduct(949903);return false;"  target="_top">collinette 미니 지압기</a></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(1135607);return false;"  target="_top">달콤한 노라인 줄넘기 캔디</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(1042723);return false;"  target="_top">삐약이계란비누세트</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0120.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 22일 -->
				<% End If %>
				
				<% If now() > #01/23/2015 00:00:00# and now() < #01/24/2015 00:00:00# Then %>
				<!-- 1월 23일 -->
				<div class="avgPdt nextBox">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0123.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn" style="bottom:10%;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 23일 -->
				<% End If %>

				<% If now() > #01/24/2015 00:00:00# and now() < #01/26/2015 00:00:00# Then %>
				<!-- 주말(24,25일) -->
				<div class="avgPdt nextBox" style="margin-top:-120%;">
					<ul>
						<li class="p01"><a href="" onclick="fnAPPpopupProduct(1182606);return false;" target="_top">애플 아이패드 미니3</a></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(801326);return false;" target="_top">카이젤 가정용 토스터기 TO-20S</a></li>
						<li class="p03"><a href="" onclick="fnAPPpopupProduct(1171539);return false;" target="_top">써모머그 엄브렐러 보틀</a></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(1181201);return false;" target="_top">어벤져스 스마트폰 컨트롤톡 이어폰</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(1146493);return false;" target="_top">반8 미니거울</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_weekend.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 주말 -->
				<% End If %>

				<% If now() > #01/26/2015 00:00:00# and now() < #01/27/2015 00:00:00# Then %>
				<!-- 1월 26일 -->
				<div class="avgPdt nextBox">
					<ul>
						<li class="p01"><a href="" onclick="fnAPPpopupProduct(1176161);return false;" target="_top">애플 맥북에어 13형</a></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(425856);return false;" target="_top">클래식 턴테이블</a></li>
						<li class="p03"><a href="" onclick="fnAPPpopupProduct(1161808);return false;" target="_top">꽃송이가습기</a></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(457154);return false;" target="_top">양키캔들</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(234933);return false;" target="_top">모빌</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0126.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 26일 -->
				<% End If %>

				<% If now() > #01/27/2015 00:00:00# and now() < #01/28/2015 00:00:00# Then %>
				<!-- 1월 27일 -->
				<div class="avgPdt nextBox">
					<ul>
						<li class="p01"><a href="" onclick="fnAPPpopupProduct(1176161);return false;" target="_top">애플 맥북에어 13형</a></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(1077842);return false;" target="_top">심슨 캐릭터 USB 메모리</a></li>
						<li class="p03"><span>2015 몰스킨</span></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(865506);return false;" target="_top">mmmg 파우치</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(1030004);return false;" target="_top">후치코</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0129.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 27일 -->
				<% End If %>

				<% If now() > #01/28/2015 00:00:00# and now() < #01/29/2015 00:00:00# Then %>
				<!-- 1월 28일 -->
				<div class="avgPdt nextBox">
					<ul>
						<li class="p01"><span>일본 온천 패키지</span></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(1151190);return false;" target="_top">스마트빔 큐브 미니빔</a></li>
						<li class="p03"><a href="" onclick="fnAPPpopupProduct(1130755);return false;" target="_top">비밀의 정원</a></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(822463);return false;" target="_top">메탈웍스</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(1115073);return false;" target="_top">자동스탬프</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0128.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 28일 -->
				<% End If %>

				<% If now() > #01/29/2015 00:00:00# and now() < #01/30/2015 00:00:00# Then %>
				<!-- 1월 29일 -->
				<div class="avgPdt nextBox">
					<ul>
						<li class="p01"><a href="" onclick="fnAPPpopupProduct(1182606);return false;" target="_top">애플 아이패드 미니3</a></li>
						<li class="p02"><a href="" onclick="fnAPPpopupProduct(1153845);return false;" target="_top">문스케일 디자인 체중계</a></li>
						<li class="p03"><a href="" onclick="fnAPPpopupProduct(949903);return false;" target="_top">collinette 미니 지압기</a></li>
						<li class="p04"><a href="" onclick="fnAPPpopupProduct(1135607);return false;" target="_top">달콤한 노라인 줄넘기 캔디</a></li>
						<li class="p05"><a href="" onclick="fnAPPpopupProduct(1042723);return false;" target="_top">삐약이계란비누세트</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_0127.png" alt="NEXT 어벤져박스" /></p>
					<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
				</div>
				<!--// 1월 29일 -->
				<% End If %>
			</div>
		</div> 
		<!--// 레이어팝업 (NEXT 어벤져박스) -->
		
		<% If (now() > #01/19/2015 00:00:00# and now() < #01/24/2015 00:00:00#) Or (now() > #01/26/2015 00:00:00# and now() < #01/31/2015 00:00:00#) Then '//첫주 혹은 2주일때 노출 %>
		<p><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_noti_friends.gif" alt="친구에게 어벤져박스를 알려주면, 한번 더! 응모 기회가 생겨요! - 오늘의 기적을 알려주기" /></a></p>
		<dl class="evtNoti">
			<dt>이벤트 유의사항</dt>
			<dd>
				<ul>
					<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
					<li>어벤져상품이 품절 되면, 이벤트가 조기 종료될 수 있습니다.</li>
					<li>어벤져박스는 하루에 ID당 1회 응모만 가능하며, 친구 초대 시, 한 번 더 응모 기회가 주어집니다.</li>
					<li>어벤져박스에는 해당 일자의 상품이 랜덤으로 담겨서, 당일 발송됩니다.</li>
					<li>어벤져박스는 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
					<li>어벤져박스의  모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>1등 상품 당첨자는 아래 하단에 있는 텐바이텐 공지사항에서 확인 가능합니다.</li>
				</ul>
			</dd>
		</dl>
		<% End If %>
		<div class="mask"></div>
	</div>
	<!--// 어벤져박스 아침의 기적(APP) -->
</div>
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