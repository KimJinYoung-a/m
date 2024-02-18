<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 내 친구를 소개합니다.
' History : 2017-03-30 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim nowDate , i, vUserID, eCode, j, UserAppearChkCnt, slideVal
	nowDate = Left(Now(), 10)
	'nowDate = "2017-04-05"

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66296
	Else
		eCode   =  77061 
	End If

	vUserID = GetEncLoginUserID()


	'// 사용자가 해당일자에 참여했는지 확인
	Function evtFriendUserAppearChk(evt_code, uid, dateval)
		Dim vQuery
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & evt_code & "' And userid='"&uid&"' And convert(varchar(10), regdate, 120) = '"&dateval&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			evtFriendUserAppearChk = rsget(0)
		End IF
		rsget.close
	End Function
%>
<!-- #include virtual="/event/props/sns.asp" -->
<style type="text/css">
.friend {position:relative; background-color:#b0d062;}
.section1 {position:relative;}
.section1 .cardList {position:absolute; left:20.46%; top:26.71%; width:62.8125%; height:62%;}
.section1 .cardList li {position:absolute; left:0; top:0; width:100%;}
.section1 .cardList li.card1 {z-index:10;}
.section1 .cardList li.card2 {z-index:20;}
.section1 .cardList li.card3 {z-index:30;}
.section1 .cardList li.card4 {z-index:40;}
.section1 .cardList li.card5 {z-index:50;}
.section1 .btnTouch {position:absolute; left:27%; top:22.42%; z-index:75; width:40%; background:rgba(0,0,0,.5); border-radius:50%; animation:bounce 1.5s 30;}

.section2 .showcase {position:relative; background:#bfdf5e;}
.section2 .showcase h3 {position:absolute; left:0; top:0; z-index:50; width:100%;}
.section2 .swiper-slide {width:75%;}
.section2 .swiper-container button {position:absolute; top:51%; z-index:40; width:10.625%; background:transparent; opacity:1; transition:all .3s;}
.section2 .swiper-container .btnPrev {left:0;}
.section2 .swiper-container .btnNext {right:0;}
.section2 .swiper-container .swiper-button-disabled {opacity:0;}
.section2 ul {position:absolute; left:0; top:21.25%; width:100%; height:70%;}
.section2 .list1 ul {left:12.8%;width:87.2%;}
.section2 .list4 ul {width:84.2%;}
.section2 li {position:relative; float:left; width:50%; height:50%;}
.section2 li div {display:none;}
.section2 li span {display:block; height:100%; background-position:0 0; background-repeat:no-repeat; background-size:auto 100.2%; text-indent:-999em;}
.section2 li:nth-child(2) span {background-position:0 0;}
.section2 li:nth-child(2) span {background-position:33.33333% 0;}
.section2 li:nth-child(3) span {background-position:66.66666% 0;}
.section2 li:nth-child(4) span {background-position:100% 0;}
.section2 li.opened a,
.section2 li.collect a {display:block; height:100%; text-indent:-999em;}
.section2 .list1 li.opened span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_collect01_off.png);}
.section2 .list2 li.opened span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_collect02_off.png);}
.section2 .list3 li.opened span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_collect03_off.png);}
.section2 .list4 li.opened span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_collect04_off.png);}
.section2 .list1 li.collect span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_collect01_on.png);}
.section2 .list2 li.collect span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_collect02_on.png);}
.section2 .list3 li.collect span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_collect03_on.png);}
.section2 .list4 li.collect span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_collect04_on.png);}

.layerPopup {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.7);}
.layerPopup .applyFigure {position:absolute; left:50%; top:20%; width:75%; margin-left:-37.5%; cursor:pointer;}
.layerPopup .btnClose {position:absolute; right:0; top:0; width:18%; background:transparent;}

.noti {position:relative; margin-top:-0.2px; padding:2.5rem 2.5rem 2.4rem; border-top:1rem solid #81ac3d; background-color:#eee;}
.noti h3 {position:relative; color:#587e1b; font-size:1.3rem; font-weight:bold; line-height:1em;}
.noti h3:after {content:' '; display:block; position:absolute; top:50%; left:-1rem; width:0.4rem; height:1rem; margin-top:-0.4rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/blt_arrow.png) 50% 0 no-repeat; background-size:100% auto;}
.noti ul {margin-top:1.3rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#333; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.6rem; left:0; width:0.4rem; height:0.1rem; background-color:#333;}

.sns {position:relative;}
.sns ul {width:33.75%; position:absolute; top:31%; right:3.43%;}

@keyframes bounce {
	from, to {margin-top:0; transform:scale(1); animation-timing-function:ease-out;}
	50% {margin-top:5px; transform:scale(1.15); animation-timing-function:ease-in;}
}

.bnr {background-color:#f4f7f7;}
.bnr ul li {margin-top:1rem;}
.bnr ul li:first-child {margin-top:0;}
</style>
<script type="text/javascript">


$(function(){

	<% if evtFriendUserAppearChk(eCode, vUserID, nowDate) > 0 then %>
		window.parent.$('html,body').animate({scrollTop:$(".section2").offset().top},500);
	<% end if %>

	// 카드 뽑기
	$(".myFriend .section1 .cardList").click(function(){
		<% If not(nowDate >= "2017-04-03" And nowDate < "2017-04-18") Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			document.location.reload();
			return;				
		<% end if %>

		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isapp="1" Then %>
				parent.calllogin();
				return;
			<% else %>
				parent.jsevtlogin();
				return;
			<% End If %>
		}

		<% if evtFriendUserAppearChk(eCode, vUserID, nowDate) > 0 then %>
			<% If nowDate = "2017-04-17" Then %>
				<% Response.Write "alert('이미 응모하셨습니다.');return false;" %>
			<% Else %>
				<% Response.Write "alert('이미 응모하셨습니다.\n내일 또 응모해 주세요!');return false;" %>
			<% End If %>
		<% end if %>
		$(".layerPopup").fadeIn();
		window.parent.$('html,body').animate({scrollTop:$(".section1").offset().top},500);
	});

	// 내가 모은 피규어 
	<%
		if nowDate >= "2017-04-03" And nowDate < "2017-04-07" then
			slideVal = 0
		end if

		if nowDate >= "2017-04-07" And nowDate < "2017-04-11" then
			slideVal = 1
		end if

		if nowDate >= "2017-04-11" And nowDate < "2017-04-15" then
			slideVal = 2
		end if

		if nowDate >= "2017-04-15" And nowDate <= "2017-04-17" then
			slideVal = 3
		end if

		if nowDate < "2017-04-03" or nowDate > "2017-04-17" then
			slideVal = 0
		end if
	%>
	figureSwiper = new Swiper(".showcase .swiper-container",{
		speed:500,
		<% '//★DEV 3일~6일:0, 7일~10일:1, 11일~14일:2, 15일~17일:3 %>
		initialSlide:<%=slideVal%>,
		centeredSlides:true,
		slidesPerView:"auto",
		prevButton:'.showcase .btnPrev',
		nextButton:'.showcase .btnNext'
	});

	//animation
	$(".cardList li.card1").css({"margin-left":"-80%","margin-top":"-20%","opacity":"0"});
	$(".cardList li.card2").css({"margin-left":"-50%","margin-top":"0","opacity":"0"});
	$(".cardList li.card3").css({"margin-left":"50%","margin-top":"0","opacity":"0"});
	$(".cardList li.card4").css({"margin-left":"80%","margin-top":"0","opacity":"0"});
	$(".cardList li.card5").css({"margin-left":"90%","margin-top":"0","opacity":"0"});
	$(".cardList .btnTouch").css({"opacity":"0"});
	function animation() {
		$(".cardList li.card1").delay(300).animate({"margin-left":"0","margin-top":"0","opacity":"1"},600);
		$(".cardList li.card2").delay(600).animate({"margin-left":"0","margin-top":"0","opacity":"1"},600);
		$(".cardList li.card3").delay(900).animate({"margin-left":"0","margin-top":"0","opacity":"1"},600);
		$(".cardList li.card4").delay(1200).animate({"margin-left":"0","margin-top":"0","opacity":"1"},600);
		$(".cardList li.card5").delay(1500).animate({"margin-left":"0","margin-top":"0","opacity":"1"},600);
		$(".cardList .btnTouch").delay(2500).animate({"opacity":"1"},1000);
	}
	<% if evtFriendUserAppearChk(eCode, vUserID, nowDate) > 0 then %>

	<% else %>
		animation();
	<% end if %>
});

function checkform(){
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}

	<% If vUserID <> "" Then %>
		<% If nowDate >= "2017-04-03" And nowDate < "2017-04-18" Then %>
			$.ajax({
				type:"GET",
				url:"/event/props/friend_proc.asp?mode=ins",
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK"){
									alert("오늘의 상품에 응모가 완료되었습니다!\n당첨자 발표는 4월 20일 입니다.");
									$(".layerPopup").fadeOut();
									$("#"+res[1]).addClass("collect");
									document.location.reload();									
									window.parent.$('html,body').animate({scrollTop:$(".section2").offset().top}, 800);
								} else {
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								document.location.reload();
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
					document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			document.location.reload();
			return;				
		<% End If %>
	<% End If %>
}

</script>

<%' 4월 정기세일 소품전 [77061] 내 친구를 소개합니다 %>
<div class="sopum myFriend">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/tit_friend.gif" alt="오늘의 친구를 확인하세요 내 친구를 소개합니다" /></p>

	<% If evtFriendUserAppearChk(eCode, vUserID, nowDate) > 0 Then %>
		<%' 카드 선택 후 %>
		<div class="section section2" id="FigureSection">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/txt_finish.png" alt="내일 다시 출석체크 해주세요!" /></p>
			<div class="showcase">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/txt_my_character.png" alt="내가 모은 캐릭터" /></h3>
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide list1" style="width:85.9375%;">
							<%' for dev msg : 지난 날짜 opened / 캐릭터 모은 날 collect 클래스 붙여주세요. %>
							<%' 3일~6일 %>
							<ul>
								<li class="date0403 <% If vUserID <> "" Then %><% If nowDate > "2017-04-03" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-03") > 0 Then %> collect<% End If %><% End If %>" id="chr0403">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1652083&pEtr=77061">4월 3일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652083&pEtr=77061" onclick="fnAPPpopupProduct('1652083&pEtr=77061');return false;">4월 3일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0404 <% If vUserID <> "" Then %><% If nowDate > "2017-04-04" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-04") > 0 Then %> collect<% End If %><% End If %>" id="chr0404">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1654443&pEtr=77061">4월 4일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1654443&pEtr=77061" onclick="fnAPPpopupProduct('1654443&pEtr=77061');return false;">4월 4일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0405 <% If vUserID <> "" Then %><% If nowDate > "2017-04-05" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-05") > 0 Then %> collect<% End If %><% End If %>" id="chr0405">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1647131&pEtr=77061">4월 5일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1647131&pEtr=77061" onclick="fnAPPpopupProduct('1647131&pEtr=77061');return false;">4월 5일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0406 <% If vUserID <> "" Then %><% If nowDate > "2017-04-06" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-06") > 0 Then %> collect<% End If %><% End If %>" id="chr0406">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1473814&pEtr=77061">4월 6일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1473814&pEtr=77061" onclick="fnAPPpopupProduct('1473814&pEtr=77061');return false;">4월 6일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
							</ul>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_showcase_01_v1.png" alt="" /></div>
						</div>
						<div class="swiper-slide list2">
							<%' 7일~10일 %>
							<ul>
								<li class="date0407 <% If vUserID <> "" Then %><% If nowDate > "2017-04-07" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-07") > 0 Then %> collect<% End If %><% End If %>" id="chr0407"">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1357041&pEtr=77061">4월 7일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1357041&pEtr=77061" onclick="fnAPPpopupProduct('1357041&pEtr=77061');return false;">4월 7일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0408 <% If vUserID <> "" Then %><% If nowDate > "2017-04-08" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-08") > 0 Then %> collect<% End If %><% End If %>" id="chr0408">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1441800&pEtr=77061">4월 8일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1441800&pEtr=77061" onclick="fnAPPpopupProduct('1441800&pEtr=77061');return false;">4월 8일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0409 <% If vUserID <> "" Then %><% If nowDate > "2017-04-09" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-09") > 0 Then %> collect<% End If %><% End If %>" id="chr0409">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1494886&pEtr=77061">4월 9일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1494886&pEtr=77061" onclick="fnAPPpopupProduct('1494886&pEtr=77061');return false;">4월 9일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0410 <% If vUserID <> "" Then %><% If nowDate > "2017-04-10" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-10") > 0 Then %> collect<% End If %><% End If %>" id="chr0410">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1574596&pEtr=77061">4월 10일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1574596&pEtr=77061" onclick="fnAPPpopupProduct('1574596&pEtr=77061');return false;">4월 10일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
							</ul>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_showcase_02.png" alt="" /></div>
						</div>
						<div class="swiper-slide list3">
							<%' 11일~14일 %>
							<ul>
								<li class="date0411 <% If vUserID <> "" Then %><% If nowDate > "2017-04-11" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-11") > 0 Then %> collect<% End If %><% End If %>" id="chr0411">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1581032&pEtr=77061">4월 11일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1581032&pEtr=77061" onclick="fnAPPpopupProduct('1581032&pEtr=77061');return false;">4월 11일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0412 <% If vUserID <> "" Then %><% If nowDate > "2017-04-12" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-12") > 0 Then %> collect<% End If %><% End If %>" id="chr0412">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1494882&pEtr=77061">4월 12일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1494882&pEtr=77061" onclick="fnAPPpopupProduct('1494882&pEtr=77061');return false;">4월 12일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0413 <% If vUserID <> "" Then %><% If nowDate > "2017-04-13" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-13") > 0 Then %> collect<% End If %><% End If %>" id="chr0413">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1668464&pEtr=77061">4월 13일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1668464&pEtr=77061" onclick="fnAPPpopupProduct('1668464&pEtr=77061');return false;">4월 13일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0414 <% If vUserID <> "" Then %><% If nowDate > "2017-04-14" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-14") > 0 Then %> collect<% End If %><% End If %>" id="chr0414">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1231255&pEtr=77061">4월 14일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1231255&pEtr=77061" onclick="fnAPPpopupProduct('1231255&pEtr=77061');return false;">4월 14일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
							</ul>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_showcase_03.png" alt="" /></div>
						</div>
						<div class="swiper-slide list4" style="width:89.0625%;">
							<%' 15일~17일 %>
							<ul>
								<li class="date0415 <% If vUserID <> "" Then %><% If nowDate > "2017-04-15" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-15") > 0 Then %> collect<% End If %><% End If %>" id="chr0415">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1624145&pEtr=77061">4월 15일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1624145&pEtr=77061" onclick="fnAPPpopupProduct('1624145&pEtr=77061');return false;">4월 15일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0416 <% If vUserID <> "" Then %><% If nowDate > "2017-04-16" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-16") > 0 Then %> collect<% End If %><% End If %>" id="chr0416">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1473815&pEtr=77061">4월 16일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1473815&pEtr=77061" onclick="fnAPPpopupProduct('1473815&pEtr=77061');return false;">4월 16일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
								<li class="date0417 <% If vUserID <> "" Then %><% If nowDate > "2017-04-17" Then %>opened<% End If %> <% If evtFriendUserAppearChk(eCode, vUserID, "2017-04-17") > 0 Then %> collect<% End If %><% End If %>" id="chr0417">
									<span class="mWeb"><a href="/category/category_itemPrd.asp?itemid=1209251&pEtr=77061">4월 17일</a></span>
									<span class="mApp"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1209251&pEtr=77061" onclick="fnAPPpopupProduct('1209251&pEtr=77061');return false;">4월 17일</a></span>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/bg_blank.png" alt="" /></div>
								</li>
							</ul>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_showcase_04_v1.png" alt="" /></div>
						</div>
					</div>
					<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/btn_next.png" alt="다음" /></button>
				</div>
			</div>
		</div>
	<% Else %>
		<%' 카드 선택 전 %>
		<div class="section section1" id="CardSection">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/txt_figure_friends.png" alt="하루에 한번 카드를 확인해보세요! 추첨을 통해 피규어 친구가 찾아갑니다" /></p>
			<div class="cardList">
				<ul>
					<li class="card1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_card_01.png" alt="첫번째 카드" /></li>
					<li class="card2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_card_02.png" alt="두번째 카드" /></li>
					<li class="card3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_card_03.png" alt="세번째 카드" /></li>
					<li class="card4"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_card_04.png" alt="네번째 카드" /></li>
					<li class="card5"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_card_05.png" alt="다섯번째 카드" /></li>
				</ul>
				<button type="button" class="btnTouch"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/btn_touch.png" alt="첫번째 카드" /></button>
			</div>
		</div>
	<% End If %>

	<%' 응모하기 레이어팝업 %>
	<div class="layerPopup">
		<div class="applyFigure" onclick="checkform();return false;">
			<div>
				<%' 날짜순으로 이미지 01~15 %>
				<% Select Case nowDate %>
					<% Case "2017-04-03" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_01.png" alt="" />
					<% Case "2017-04-04" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_02.png" alt="" />
					<% Case "2017-04-05" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_03.png" alt="" />
					<% Case "2017-04-06" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_04.png" alt="" />
					<% Case "2017-04-07" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_05.png" alt="" />
					<% Case "2017-04-08" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_06.png" alt="" />
					<% Case "2017-04-09" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_07.png" alt="" />
					<% Case "2017-04-10" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_08.png" alt="" />
					<% Case "2017-04-11" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_09.png" alt="" />
					<% Case "2017-04-12" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_10.png" alt="" />
					<% Case "2017-04-13" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_11.png" alt="" />
					<% Case "2017-04-14" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_12.png" alt="" />
					<% Case "2017-04-15" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_13.png" alt="" />
					<% Case "2017-04-16" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_14.png" alt="" />
					<% Case "2017-04-17" %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_15.png" alt="" />
					<% Case Else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_figure_01.png" alt="" />
				<% End Select %>
			</div>
		</div>
	</div>

	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>본 이벤트는 ID당 하루에 한 번 응모 가능합니다.</li>
			<li>추첨을 통해 응모한 캐릭터 중 1종을 발송 해 드립니다.</li>
			<li>모든 상품의 옵션은 랜덤으로 배송되며, 선택이 불가합니다.</li>
			<li>당첨자 발표는 2017년 4월 20일(목)에 일괄 진행됩니다.</li>
		</ul>
	</div>

	<%' for dev msg : sns %>
	<div class="sns">
		<%=snsHtml%>
	</div>
	<%' bnr %>
	<div class="bnr">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/tit_event_more.gif" alt="이벤트 더보기" /></h3>
		<ul>
			<li>
				<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77059">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_index.jpg" alt="소품전 이벤트 메인페이지 가기" />
				</a>
			</li>
			<li>
				<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77060">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_sopumland.jpg" alt="매일 만나는 다양한 테마기획전" />
				</a>
			</li>
			<li>
				<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77064">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_sticker.jpg" alt="당신의 일상에 스티커를 붙여주세요!" />
				</a>
			</li>
		</ul>
	</div>
</div>
<!--// 4월 정기세일 소품전 [77061] 내 친구를 소개합니다 -->

<!-- #include virtual="/lib/db/dbclose.asp" -->