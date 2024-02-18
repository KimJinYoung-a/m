<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'###########################################################
' Description : 12월 30일 APP전용
' History : 2016.12.15 유태욱
'###########################################################
Dim eCode, cnt, sqlStr, i, vUserID, currenttime, nowdate

currenttime = date()
'							currenttime = "2016-12-22"

'nowdate = Now()
'								nowdate = "2016-12-20 10:10:00"

If application("Svr_Info") = "Dev" Then
	eCode 		= "66252"
Else
	eCode 		= "75048"
End If

vUserID		= GetEncLoginUserID

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 12월 30일")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 12월 30일\n\n호텔에서 멋진\n연말파티를 즐길\n당신을 초대합니다!\n\n일시:2016년 12월 30일\n서울/부산 파크하얏트 호텔\n\n파티의 주인공은 바로 당신\n지금 도전하세요!\n\n오직 텐바이텐 APP에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/75048/m/kakao_sns_img.jpg"
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
img {vertical-align:top;}
.mEvt75050 {background:/* #aa72a1; */}

.tabTypeA {position:relative;}
.tabTypeA .tabNavi {position:absolute; top:0; left:0; width:100%; height:12%; overflow:hidden; color:transparent;}
.tabTypeA .tabNavi li {float:left; width:50%; height:100%; text-indent:-999em;}
.tabTypeA .tabNavi li a {display:block; width:100%; height:100%; border-bottom:0; text-align:center;}

.tabCont01 {display:none;}

.item {position:relative;}
.tab1 .item .btnMore {display:block; position:absolute; width:23.4%; height:20%; bottom:1%; right:7.34%; z-index:20; text-indent:-999em;}
.tab2 .item .btnMore {display:block; position:absolute; width:23.4%; height:10%; top:47%; right:7.34%; z-index:20; text-indent:-999em;}
.item .txtMore {width:85.4%; position:absolute; top:4.5%; left:7.3%; z-index:10; cursor:pointer;}
.item .btn {display:block;}

.evntWinner {position:relative;}
.evntWinner .name {position:absolute; height:6.17%; top:26.3%; left:37%; margin:3% 0; letter-spacing:0.1rem; font-size:2.5rem; color:#673708;}

.sns {position:relative;}
.sns ul{position:absolute; top:0; right:0; width:43%; height:100%; color:transparent;}
.sns ul li{float:left; width:50%; height:100%;}
.sns ul li a{display:block; width:100%; height:100%;}

.noti {padding:9% 3.5% 12.25%; background-color:#4d4d4d;}
.noti h4 {position:relative; width:12rem; padding-bottom:0.4rem; margin:0.2rem 0 0.4rem 1rem;  border-bottom:0.2rem #fff solid; color:#fff; font-size:1.63rem; font-weight:bold;}
.noti ul {margin-top:1rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#fff; font-size:1.1rem; line-height:1.4em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; border:solid 1px #fff; border-radius:100%; top:0.6rem; left:0; width:0.2rem; height:0.2rem; background-color:#fff;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt75048").offset().top}, 0);
});

$(function(){ 
	function slide01() {
		slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
			loop:true,
			autoplay:2000,
			autoplayDisableOnInteraction:true,
			speed:800,
			effect:'fade'
		});
	}
	function slide02() {
		slideTemplate02 = new Swiper('.slideTemplateV1502 .swiper-container',{
			loop:true,
			autoplay:2000,
			autoplayDisableOnInteraction:true,
			speed:800,
			effect:'fade'
		});
	}
	slide01();
	slide02();
	//$(".tabCont01").hide();
	//$(".tabContainer").find(".tabCont01:first").show();
	<% If currenttime > "2016-12-21" Then %>
		<% If now() >= #12/22/2016 00:00:00# and now() < #12/22/2016 14:00:00# Then %>
		<% else %>
			$(".tabNavi li").click(function() {
				$(this).closest(".tabNavi").nextAll(".tabContainer:first").find(".tabCont01").hide();
				var activeTab = $(this).find("a").attr("href");
				$(activeTab).show();
				return false;
			});
			<% end if %>
	<% end if %>

	$(".tabNavi li.t1").click(function() {
		<% If now() >= #12/22/2016 00:00:00# and now() < #12/22/2016 14:00:00# Then %>
		<% else %>
		slide01();
		slideTemplate.startAutoplay();
		slideTemplate02.stopAutoplay();
		<% end if %>
	});
	<% If currenttime > "2016-12-21" Then %>
		$(".tabNavi li.t2").click(function() {
			slide02();
			slideTemplate02.startAutoplay();
			slideTemplate.stopAutoplay();
		});
	<% end if %>

	$(".txtMore").hide();
	$(".tab1 .btnMore").on("click", function(e){
		$(".tab1 .txtMore").show();
		return false;
	});
	<% If currenttime > "2016-12-21" Then %>
		$(".tab2 .btnMore").on("click", function(e){
			$(".tab2 .txtMore").show();
			return false;
		});
	<% end if %>
	$(".txtMore").on("click", function(e){
		$(this).hide();
		return false;
	});
});

<% if isapp then %>
	function checkform(){
		<% If vUserID = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				<% If isApp = 1 Then %>
					parent.calllogin();
					return false;
				<% Else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
					return false;
				<% End If %>
				return false;
			}
		<% End If %>
		<% If vUserID <> "" Then %>
			<% If currenttime >= "2016-12-19" And currenttime < "2016-12-22" Then %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doeventsubscript/doEventSubscript75048.asp",
					data: "mode=add",
					dataType: "text",
					async:false,
					cache:true,
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
										alert('응모가 완료 되었습니다\n\n당첨자 발표는 12월 22일 오후 2시\n이벤트 페이지 및 공지사항을 확인해 주세요!');
										return
	//									$("#resultLayer").empty().html(res[1]);
	//									$('.resultLayer').fadeIn();
	//									window.parent.$('html,body').animate({scrollTop:$(".resultLayer").offset().top}, 300);
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
						document.location.reload();
						return false;
					}
				});
			<% Else %>
				alert("응모기간이 지났습니다ㅜㅜ\n부산하얏트 호텔에 응모해주세요.");
				return;				
			<% End If %>
		<% End If %>
	}

	function checkformbs(){
		<% If vUserID = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				<% If isApp = 1 Then %>
					parent.calllogin();
					return false;
				<% Else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
					return false;
				<% End If %>
				return false;
			}
		<% End If %>
		<% If vUserID <> "" Then %>
			<% If currenttime >= "2016-12-22" And currenttime < "2016-12-26" Then %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doeventsubscript/doEventSubscript75048.asp",
					data: "mode=add",
					dataType: "text",
					async:false,
					cache:true,
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
										alert('응모가 완료 되었습니다\n\n당첨자 발표는 12월 26일 오후 2시\n공지사항을 확인해 주세요!');
										return
	//									$("#resultLayer").empty().html(res[1]);
	//									$('.resultLayer').fadeIn();
	//									window.parent.$('html,body').animate({scrollTop:$(".resultLayer").offset().top}, 300);
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
						document.location.reload();
						return false;
					}
				});
			<% Else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% End If %>
		<% End If %>
	}

	function snschk(snsnum) {
		<% If vUserID = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				<% If isApp = 1 Then %>
					parent.calllogin();
					return false;
				<% Else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
					return false;
				<% End If %>
				return false;
			}
		<% End If %>
		<% If vUserID <> "" Then %>
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript75048.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "text",
			async: false
		}).responseText;
			reStr = str.split("|");
			if(reStr[1] == "tw") {
				popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
			}else if(reStr[1]=="fb"){
				popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			}else if(reStr[1]=="ka"){
				<% If isApp = "1" Then %>
					parent_kakaolink('[텐바이텐] 12월 30일\n\n호텔에서 멋진\n연말파티를 즐길\n당신을 초대합니다!\n\n일시:2016년 12월 30일\n서울/부산 파크하얏트 호텔\n\n파티의 주인공은 바로 당신\n지금 도전하세요!\n\n오직 텐바이텐 APP에서!', 'http://webimage.10x10.co.kr/eventIMG/2016/75048/m/kakao_sns_img.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=75048' );
				<% Else %>
					parent_kakaolink('[텐바이텐] 12월 30일\n\n호텔에서 멋진\n연말파티를 즐길\n당신을 초대합니다!\n\n일시:2016년 12월 30일\n서울/부산 파크하얏트 호텔\n\n파티의 주인공은 바로 당신\n지금 도전하세요!\n\n오직 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2016/75048/m/kakao_sns_img.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=75048' );
				<% End If %>
			}else if(reStr[1] == "none"){
				alert('참여 이력이 없습니다.\n응모후 이용 하세요');
				return false;
			}else if(reStr[1] == "end"){
				alert('오늘은 모두 응모하셨습니다.\n내일 다시 도전해 주세요!');
				return false;
			}else{
				alert('이벤트 기간이 아닙니다.');
				return false;
			}
		<% End If %>
	}
<% end if %>

function realt(){
	alert('부산 하얏트호텔은 12월 22일부터\n응모할 수 있습니다.');
	return false;
}

</script>
<% if isapp then %>
	<div class="mEvt75048">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tit_december_30th.jpg" alt="" /></h3>
		<div class="tabs tabTypeA">
			<ul class="tabNavi">
				<%'(탭1) 응모 기간동안에는 (탭2)로 넘어가지 않게 해주세요. %>
				<% If currenttime < "2016-12-22" Then %>
					<li class="t1"><a href="#tab1">서울</a></li>
					<li class="t2"><a href="" onclick="realt(); return false;">부산</a></li>
				<% else %>
					<% If now() >= #12/22/2016 00:00:00# and now() < #12/22/2016 14:00:00# Then %>
						<li class="t1">서울</li>
					<% else %>
						<li class="t1"><a href="#tab1">서울</a></li>
					<% end if %>
					<li class="t2"><a href="#tab2">부산</a></li>
				<% end if %>
			</ul>
			<div class="tabContainer">
				<% If currenttime < "2016-12-22" Then %>
				<div id="tab1" class="tabCont01 tab1"  style="display:block;">
				<% else %>
				<div id="tab1" class="tabCont01 tab1" >
				<% end if %>
					<%'' 12월 22일 14시 당첨자 발표시, tab_01.jpg 이미지를 tab_01_winner.jpg 로대체 %>
					<% If now() < #12/22/2016 14:00:00# Then %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tab_01.jpg" alt="" /></p>
					<% else %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tab_01_winner.jpg" alt="" /></p>
					<% end if %>

					<%'' 12월22일 14시 당첨자 발표시, <div class="item">~</div> 를 <div class="evntWinner">~</div> 로 대체 %>
					<% If now() < #12/22/2016 14:00:00# Then %>
						<div class="item">
							<div class="slideTemplateV15">
								<div class="swiper-container">
									<div class="swiper-wrapper">
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab01_item_01.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab01_item_02.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab01_item_03.jpg" alt="" /></div>
									</div>
								</div>
								<a class="btnMore" href="#">자세히 보기</a>
							</div>
							<p class="txtMore"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/txt_more_v3.png" alt="룸타입 파크 하얏트 서울 파크 킹 입실일 12월30일(금) 1박 (최대 성인 2인기준) 체크인  PM3시 체크아웃  PM12시 조식 불포함, 피트니스, 수영장, 사우나 이용 가능 호텔 내 인터넷 무료" /></p>
							<%'' If currenttime < "2016-12-22" Then %>
								<a class="btn" href="" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_go_apply.jpg" alt="응모하기" /></a>
							<%'' end if %>
						</div>
					<% else %>
						<div class="evntWinner">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_winner.jpg" alt="당첨을 축하드립니다." /></p>
							<p class="name">yoyo52**</p>
						</div>
					<% end if %>

					<%'' 12.21일 응모기간 이후 <div class="sns">~<div> 숨겨주세요 %>
					<% If currenttime < "2016-12-22" Then %>
						<div class="sns">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/txt_sns_evnt.jpg" alt="친구와 함께 4천원의 행복을!" /></p>
							<ul>
								<li><a href="" onclick="snschk('fb'); return false;">페이스북공유</a></li>
								<li><a href="" onclick="snschk('ka'); return false;">카카오톡으로 공유</a></li>
							</ul>
						</div>
					<% end if %>
				</div>

				<% If currenttime >= "2016-12-22" Then %>
					<div id="tab2" class="tabCont01 tab2"  style="display:block;">
						<%'' 12월 22일 14시 당첨자 발표시, tab_02_before.jpg 이미지를 tab_02.jpg 로대체 %>
						<% If now() < #12/22/2016 14:00:00# Then %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tab_02_before.jpg" alt="" /></p>
						<% else %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tab_02.jpg" alt="" /></p>
						<% end if %>

						<%'' If now() < #12/26/2016 14:00:00# Then %>
							<div class="item">
								<div class="slideTemplateV1502">
									<div class="swiper-container">
										<div class="swiper-wrapper">
											<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab02_item_01.jpg" alt="" /></div>
											<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab02_item_02.jpg" alt="" /></div>
											<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab02_item_03.jpg" alt="" /></div>
										</div>
									</div>
									<a class="btnMore" href="#">자세히 보기</a>
								</div>
								<p class="txtMore"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/txt_more_02.png" alt="룸타입 파크 하얏트 부산 파크 킹 입실일 12월30일(금) 1박 (최대 성인 2인기준) 체크인  PM3시 체크아웃  PM12시 조식 불포함, 피트니스, 수영장, 사우나 이용 가능 호텔 내 인터넷 무료" /></p>
								<% If currenttime >= "2016-12-22" and currenttime < "2016-12-26" Then %>
									<a class="btn" href="" onclick="checkformbs();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_go_apply_02.jpg" alt="App에서 응모하기" /></a>
								<% end if %>
							</div>
						<%'' else %>
						<%'' 당첨자 게시판으로 하기로했다고함 %>
						<!--
							<div class="evntWinner">

							</div>
						-->
						<%'' end if %>

						<% If currenttime >= "2016-12-22" and currenttime < "2016-12-26" Then %>
							<div class="sns">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/txt_sns_evnt.jpg" alt="친구와 함께 4천원의 행복을!" /></p>
								<ul>
									<li><a href="" onclick="snschk('fb'); return false;">페이스북공유</a></li>
									<li><a href="" onclick="snschk('ka'); return false;">카카오톡으로 공유</a></li>
								</ul>
							</div>
						<% end if %>
					</div>
				<% end if %>
			</div>
		</div>
		<div class="noti">
			<h4>이벤트 유의사항</h4>
			<ul>
				<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
				<li>본 이벤트는 하루에 하루에 ID당 1회 응모만 가능하며, 친구 초대 시, 한 번 더 응모 기회가 주어집니다.</li>
				<li>경품에 당첨 된 고객님께는 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				<li>제세공과금은 텐바이텐 부담입니다.</li>
				<li>당첨자 안내 공지는 응모기간 이후에 공지사항과 이벤트 페이지에서 확인 할 수 있습니다.</li>
				<li>당첨자 발표일자는 서울하얏트 호텔 2016년 12월 22일 오후 2시, 부산하얏트 호텔은 12월 26일 오후 2시에 공지사항에서 발표됩니다.</li>
			</ul>
		</div>
	</div>
<% else %>
	<div class="mEvt75048">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tit_december_30th.jpg" alt="" /></h3>
		<div class="tabs tabTypeA">
			<ul class="tabNavi">
				<%'(탭1) 응모 기간(12.19~12.21)동안에는 (탭2)로 넘어가지 않게 해주세요. %>
				<% If currenttime < "2016-12-22" Then %>
					<li class="t1"><a href="#tab1">서울</a></li>
					<li class="t2"><a href="" onclick="realt(); return false;">부산</a></li>
				<% else %>
					<li class="t1"><a href="#tab1">서울</a></li>
					<li class="t2"><a href="#tab2">부산</a></li>
				<% end if %>
			</ul>
			<div class="tabContainer">
				<% If currenttime < "2016-12-22" Then %>
				<div id="tab1" class="tabCont01 tab1"  style="display:block;">
				<% else %>
				<div id="tab1" class="tabCont01 tab1" >
				<% end if %>
					<%'' 12월 22일 14시 당첨자 발표시, tab_01.jpg 이미지를 tab_01_winner.jpg 로대체 %>
					<% If now() < #12/22/2016 14:00:00# Then %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tab_01.jpg" alt="" /></p>
					<% else %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tab_01_winner.jpg" alt="" /></p>
					<% end if %>

					<%'' 12월22일 14시 당첨자 발표시, <div class="item">~</div> 를 <div class="evntWinner">~</div> 로 대체 %>
					<% If now() < #12/22/2016 14:00:00# Then %>
						<div class="item">
							<div class="slideTemplateV15">
								<div class="swiper-container">
									<div class="swiper-wrapper">
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab01_item_01.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab01_item_02.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab01_item_03.jpg" alt="" /></div>
									</div>
								</div>
								<a class="btnMore" href="#">자세히 보기</a>
							</div>
							<p class="txtMore"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/txt_more_v3.png" alt="룸타입 파크 하얏트 서울 파크 킹 입실일 12월30일(금) 1박 (최대 성인 2인기준) 체크인  PM3시 체크아웃  PM12시 조식 불포함, 피트니스, 수영장, 사우나 이용 가능 호텔 내 인터넷 무료" /></p>
							<a class="btn" href="http://m.10x10.co.kr/apps/link/?9620161213" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_go_app_down.jpg" alt="app다운받기" /></a>
						</div>
					<% else %>
						<div class="evntWinner">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_winner.jpg" alt="당첨을 축하드립니다." /></p>
							<p class="name">yoyo52**</p>
						</div>
					<% end if %>

					<%'' 12.21일 응모기간 이후 <a class="coupon">~</a> 숨겨주세요 %>
					<% If currenttime < "2016-12-22" Then %>
						<a class="coupon" href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/txt_evnt_app.jpg" alt="지금 app을 설치하면 3천원 쿠폰을 드려요" /></a>
					<% end if %>
				</div>

				<% If currenttime >= "2016-12-22" Then %>
					<div id="tab2" class="tabCont01 tab2"  style="display:block;">
						<%'' 12월 22일 14시 당첨자 발표시, tab_02_before.jpg 이미지를 tab_02.jpg 로대체 %>
						<% If now() < #12/22/2016 14:00:00# Then %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tab_02_before.jpg" alt="" /></p>
						<% else %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/tab_02.jpg" alt="" /></p>
						<% end if %>
						<div class="item">
							<div class="slideTemplateV1502">
								<div class="swiper-container">
									<div class="swiper-wrapper">
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab02_item_01.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab02_item_02.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_tab02_item_03.jpg" alt="" /></div>
									</div>
								</div>
								<a class="btnMore" href="#">자세히 보기</a>
							</div>
							<p class="txtMore"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/txt_more_02.png" alt="룸타입 파크 하얏트 부산 파크 킹 입실일 12월30일(금) 1박 (최대 성인 2인기준) 체크인  PM3시 체크아웃  PM12시 조식 불포함, 피트니스, 수영장, 사우나 이용 가능 호텔 내 인터넷 무료" /></p>
							<a class="btn" href="http://m.10x10.co.kr/apps/link/?9620161213" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_go_app_down_02.jpg" alt="app다운받기" /></a>
						</div>
						<a class="coupon" href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/txt_evnt_app.jpg" alt="지금 app을 설치하면 3천원 쿠폰을 드려요" /></a>
					</div>
				<% end if %>
			</div>
		</div>
		<div class="noti">
			<h4>이벤트 유의사항</h4>
			<ul>
				<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
				<li>본 이벤트는 하루에 하루에 ID당 1회 응모만 가능하며, 친구 초대 시, 한 번 더 응모 기회가 주어집니다.</li>
				<li>경품에 당첨 된 고객님께는 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				<li>제세공과금은 텐바이텐 부담입니다.</li>
				<li>당첨자 안내 공지는 응모기간 이후에 공지사항과 이벤트 페이지에서 확인 할 수 있습니다.</li>
				<li>당첨자 발표일자는 서울하얏트 호텔 2016년 12월 22일 오후 2시, 부산하얏트 호텔은 12월 26일 오후 2시에 공지사항에서 발표됩니다.</li>
			</ul>
		</div>
	</div>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->