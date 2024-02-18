<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [15주년] 비정상 할인 MA
' History : 2016.10.06 유태욱
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, userid, userlevel, nowdate, subscriptcount1, subscriptcount2, itemnum, beforenum, beforedonationCost

userid = GetEncLoginUserID()
userlevel = GetLoginUserlevel()

nowdate = now()
'	nowdate = #10/07/2016 00:00:01#

if left(nowdate,10) < "2016-10-11" then
	itemnum = 1
elseif left(nowdate,10) = "2016-10-11" then
	itemnum = 2
elseif left(nowdate,10) = "2016-10-12" then
	itemnum = 3
elseif left(nowdate,10) = "2016-10-13" then
	itemnum = 4
elseif left(nowdate,10) >= "2016-10-14" and left(nowdate,10) < "2016-10-17" then
	itemnum = 5
elseif left(nowdate,10) = "2016-10-17" then
	itemnum = 6
elseif left(nowdate,10) = "2016-10-18" then
	itemnum = 7
elseif left(nowdate,10) = "2016-10-19" then
	itemnum = 8
elseif left(nowdate,10) = "2016-10-20" then
	itemnum = 9
elseif left(nowdate,10) >= "2016-10-21" then
	itemnum = 10
end if

if left(nowdate,10) = "2016-10-11" then
	beforenum = 1
elseif left(nowdate,10) = "2016-10-12" then
	beforenum = 2
elseif left(nowdate,10) = "2016-10-13" then
	beforenum = 3
elseif left(nowdate,10) = "2016-10-14" then
	beforenum = 4
elseif left(nowdate,10) >= "2016-10-15" and left(nowdate,10) < "2016-10-18" then
	beforenum = 5
elseif left(nowdate,10) = "2016-10-18" then
	beforenum = 6
elseif left(nowdate,10) = "2016-10-19" then
	beforenum = 7
elseif left(nowdate,10) = "2016-10-20" then
	beforenum = 8
elseif left(nowdate,10) = "2016-10-21" then
	beforenum = 9
elseif left(nowdate,10) >= "2016-10-22" then
	beforenum = 10
end if

dim item1id, item2id, item3id, item4id, item5id, item6id, item7id, item8id, item9id, item10id
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66212
	item1id		=	282197
	item2id		=	1163356
	item3id		=	1163067
	item4id		=	1137708
	item5id		=	1147288
	item6id		=	1148209
	item7id		=	1155374
	item8id		=	1131262
	item9id		=	1180634
	item10id		=	1183273
Else
	eCode   =  73064
	item1id		=	1573039
	item2id		=	1574615
	item3id		=	1574633
	item4id		=	1574640
	item5id		=	1574700
	item6id		=	1574701
	item7id		=	1574702
	item8id		=	1574711
	item9id		=	1574721
	item10id		=	1574725
End If

Dim sqlStr, pNum, graph, donationCost, beforepNum, beforegraph

if userid<>"" then
	subscriptcount1 = getevent_subscriptexistscount(eCode, userid, "", itemnum, "")
	subscriptcount2 = getevent_subscriptexistscount(eCode, userid, "", beforenum, "")
end if

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[채널 teN 15] 비정상 할인!")
snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/15th/discount.asp")
snpPre		= Server.URLEncode("10x10")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 할인에는 국경도 없는 비정상할인 이벤트를 소개합니다.\n\n매일매일 다양한 할인가에 찬성하고 비정상적인 할인에 도전하세요!\n\n지금 텐바이텐에서 확인해보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_kakao.jpg"
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

/* discount */
.discount {position:relative;}
.discount .dateTab {position:relative;  padding:0 5.6375%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/bg_blue.png) repeat 0 0; background-size:12% auto;}
.discount .dateTab .swiper-container {padding-top:12%; margin-top:-11%;}
.discount .dateTab .swiper-slide {padding:0 1.77%; margin-bottom:-1px;}
.discount .dateTab .swiper-slide span {display:inline-block; background-position:0 0; background-repeat:no-repeat; background-size:100%;}
.discount .dateTab .date1010 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1010.png);}
.discount .dateTab .date1011 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1011.png);}
.discount .dateTab .date1012 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1012.png);}
.discount .dateTab .date1013 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1013.png);}
.discount .dateTab .date1014 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1014.png);}
.discount .dateTab .date1017 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1017.png);}
.discount .dateTab .date1018 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1018.png);}
.discount .dateTab .date1019 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1019.png);}
.discount .dateTab .date1020 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1020.png);}
.discount .dateTab .date1021 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tab_1021.png);}
.discount .dateTab li.soon span {background-position:0 28.55%;}
.discount .dateTab li.soon.current span {background-position:0 14.3%;}
.discount .dateTab li.open span {background-position:0 57.1%;}
.discount .dateTab li.open.current span {background-position:0 42.85%;}
.discount .dateTab li.today span {background-position:0 85.7%;}
.discount .dateTab li.today.current span {background-position:0 71.4%;}
.discount .dateTab li.finish span {background-position:0 100% !important;}
.discount .dateTab li span em {display:none; position:absolute; left:0; top:-37%; z-index:40; width:100%; height:37%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_go.gif) no-repeat 0 0; background-size:100% auto; cursor:pointer;}

.discount .dateTab li.open span em {display:block;}
.discount .dateTab button {position:absolute; top:0; width:7.5%; margin-top:11%;}
.discount .dateTab .prev {left:0;}
.discount .dateTab .next {righT:0;}
.discount button {background:transparent; vertical-align:top;}
.discount .btnPreview {padding:2.5rem 18%; background-color:#7dd089;}
.discount .btnPreview button {width:100%;}
.discount .itemPic {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/bg_box_01.png) no-repeat 0 0; background-size:100%;}
.discount .itemPic span {position:absolute; left:11.25%; top:4.2%; width:6.9rem; height:6.8rem; background-position:0 0; background-repeat:no-repeat; background-size:100%;}
.discount .itemPic .limit20 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_limit_20.png);}
.discount .itemPic .limit30 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_limit_30.png);}
.discount .itemPic .limit50 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_limit_50.png);}
.discount .itemInfo {padding-bottom:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/bg_box_02.png) no-repeat 0 100%; background-size:100% auto;}
.discount .itemInfo .open10am {width:54.375%; margin:0 auto; padding-bottom:2rem;}
.discount .itemInfo .btnBuy {display:block; width:54.375%; margin:0 auto;}
.discount .itemInfo .case1 {padding-top:1.8rem;}
.discount .itemInfo .case1 .q {width:69.2%; margin:0 auto; padding-bottom:2rem;}
.discount .itemInfo .case1 .btnArea {text-align:center;}
.discount .itemInfo .case1 .btnArea button {width:26.7%; margin:0 1rem;}
.discount .itemInfo .case1 .tip {width:79%; margin:0 auto; padding-top:2.4rem;}
.discount .itemInfo .case2 {padding:3.5rem 0 3.2rem;}
.discount .itemInfo .case3 {padding:3.5rem 0 3.2rem;}
.discount .itemInfo .case4 {padding:1rem 0;}
.discount .itemInfo .case4 p {width:51%; margin:0 auto;}
#lyrPreview {position:absolute; left:0; top:0; z-index:100; width:100%; height:100%; padding-top:5rem;background:rgba(0,0,0,.75);}
#lyrPreview .previewCont {position:relative;}
#lyrPreview .previewCont .close {position:absolute; right:0.5%; top:2%; width:21.25%;}
.discount .itemInfo .case5 {padding:4rem 0 3rem;}
.discount .itemInfo .case5 p {width:64.2%; margin:0 auto;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".teN15th").offset().top}, 0);
});

function snschk(snsnum) {

	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}

$(function(){

	<% if left(nowdate,10) < "2016-10-11" then %>
		$("#item1").show();
	<% elseif left(nowdate,10) = "2016-10-11" then %>
		$("#item2").show();
	<% elseif left(nowdate,10) = "2016-10-12" then %>
		$("#item3").show();
	<% elseif left(nowdate,10) = "2016-10-13" then %>
		$("#item4").show();
	<% elseif left(nowdate,10) >= "2016-10-14" and left(nowdate,10) < "2016-10-17" then %>
		$("#item5").show();
	<% elseif left(nowdate,10) = "2016-10-17" then %>
		$("#item6").show();
	<% elseif left(nowdate,10) = "2016-10-18" then %>
		$("#item7").show();
	<% elseif left(nowdate,10) = "2016-10-19" then %>
		$("#item8").show();
	<% elseif left(nowdate,10) = "2016-10-20" then %>
		$("#item9").show();
	<% elseif left(nowdate,10) >= "2016-10-21" then %>
		$("#item10").show();
	<% end if %>

	mySwiper = new Swiper('.dateTab .swiper-container',{
		<% if left(nowdate,10) > "2016-10-05" and left(nowdate,10) < "2016-10-12" then %>
			initialSlide:0,
		<% elseif left(nowdate,10) = "2016-10-12" then %>
			initialSlide:1,
		<% elseif left(nowdate,10) = "2016-10-13" then %>
			initialSlide:2,
		<% elseif left(nowdate,10) >= "2016-10-14" and left(nowdate,10) < "2016-10-17" then %>
			initialSlide:3,
		<% elseif left(nowdate,10) = "2016-10-17" then %>
			initialSlide:4,
		<% elseif left(nowdate,10) = "2016-10-18" then %>
			initialSlide:5,
		<% elseif left(nowdate,10) >= "2016-10-19" and left(nowdate,10) < "2016-10-20" then %>
			initialSlide:6,
		<% elseif left(nowdate,10) >= "2016-10-20" then %>
			initialSlide:7,
		<% elseif left(nowdate,10) >= "2016-10-21" then %>
			initialSlide:7,
		<% else %>
			initialSlide:0,
		<% end if %>
		loop:false,
		autoplay:false,
		speed:400,
		pagination:false,
		slidesPerView: 3,
		nextButton:'.dateTab .next',
		prevButton:'.dateTab .prev'
	});
	$('.btnPreview button').click(function(){
		$('#lyrPreview').fadeIn();
		window.parent.$('html,body').animate({scrollTop:$(".discount").offset().top}, 800);
	});
	$('#lyrPreview .close').click(function(){
		$('#lyrPreview').fadeOut();
	});
});

function jssubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(nowdate,10)>="2016-10-10" and left(nowdate,10)<"2016-10-24" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if userlevel = 7 then %>
				alert("텐바이텐 스탭은 참여할 수 없습니다.");
				return;			
			<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/15th/doeventsubscript/doEventSubscriptdiscount.asp",
					data: "mode=addok",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					<% if left(nowdate,10) = "2016-10-14" or left(nowdate,10) = "2016-10-15" or left(nowdate,10) = "2016-10-21" or left(nowdate,10) = "2016-10-22" then %>
						alert('다음주 월요일 오전 10시\n비정상할인의 문이 열립니다!\n할인에 도전하세요!');
					<% else %>
						alert('내일 오전 10시\n비정상할인의 문이 열립니다!\n할인에 도전하세요!');
					<% end if %>
					parent.location.reload();
				}else if (str1[0] == "04"){
					alert('이미 참여 하셨습니다.');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인을 해주세요.');
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jssubmitx(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(nowdate,10)>="2016-10-10" and left(nowdate,10)<"2016-10-25" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			alert(" ㅜㅜ 찬성하신 분들께만\n구매버튼이 열립니다");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsgetitem(iid){
	<% If IsUserLoginOK() Then %>
		<% If not( left(nowdate,10)>="2016-10-10" and left(nowdate,10)<"2016-10-25" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if userlevel = 7 then %>
				alert("텐바이텐 스탭은 참여할 수 없습니다.");
				return;			
			<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/15th/doeventsubscript/doEventSubscriptdiscount.asp",
					data: "mode=itget",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					<% if isApp=1 then %>
						parent.fnAPPpopupProduct(iid);
						return false;
					<% else %>
						top.location.href = "/category/category_itemprd.asp?itemid="+iid+"";
						return false;
					<% end if %>
				}else if (str1[0] == "03"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인을 해주세요.');
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsshow(numb){
	if(numb=="1"){
		$("#item1").show();
		$("#etb1").addClass('current');
		for (i = 2; i < 11; i++){
			$("#item"+i).hide();
			$("#etb"+i).removeClass('current');
		}
	}else if(numb=="2"){
		$("#item2").show();
		$("#etb2").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=2){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else if(numb=="3"){
		$("#item3").show();
		$("#etb3").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=3){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else if(numb=="4"){
		$("#item4").show();
		$("#etb4").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=4){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else if(numb=="5"){
		$("#item5").show();
		$("#etb5").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=5){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else if(numb=="6"){
		$("#item6").show();
		$("#etb6").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=6){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else if(numb=="7"){
		$("#item7").show();
		$("#etb7").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=7){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else if(numb=="8"){
		$("#item8").show();
		$("#etb8").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=8){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else if(numb=="9"){
		$("#item9").show();
		$("#etb9").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=9){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else if(numb=="10"){
		$("#item10").show();
		$("#etb10").addClass('current');
		for (i = 1; i < 11; i++){
			if(i!=10){
				$("#item"+i).hide();
				$("#etb"+i).removeClass('current');
			}
		}
	}else{
		for (i = 1; i < 11; i++){
			$("#item"+i).hide();
			$("#etb"+i).removeClass('current');
		}
	}
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}
</script>
<%' 15주년 이벤트 : 비정상할인  %>
<div class="teN15th discount">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/tit_discount.png" alt="비정상할인" /></h2>
	<div class="dateTab">
		<div class="swiper-container">
			<ul class="swiper-wrapper">
				<%' for dev msg : 구매불가 오픈 - soon / 구매가능 오픈 - open / 오늘- today / 솔드아웃 finish (pc와 동일)  %>
				<li id="etb1" <% if left(nowdate,10)>="2016-10-10" then %> onclick="jsshow('1'); return false;"<% end if %> class="swiper-slide date1010 <% if left(nowdate,10)="2016-10-10" then %>today current<% elseif left(nowdate,10)="2016-10-11" and nowdate < #10/11/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-11" and getitemlimitcnt(item1id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-11" and getitemlimitcnt(item1id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="1회차 10월 10일" /></span></li>
				<li id="etb2" <% if left(nowdate,10)>="2016-10-11" then %> onclick="jsshow('2'); return false;"<% end if %> class="swiper-slide date1011 <% if left(nowdate,10)="2016-10-11" then %>today current<% elseif left(nowdate,10)="2016-10-12" and nowdate < #10/12/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-12" and getitemlimitcnt(item2id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-12" and getitemlimitcnt(item2id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="2회차 10월 11일" /></span></li>
				<li id="etb3" <% if left(nowdate,10)>="2016-10-12" then %> onclick="jsshow('3'); return false;"<% end if %> class="swiper-slide date1012 <% if left(nowdate,10)="2016-10-12" then %>today current<% elseif left(nowdate,10)="2016-10-13" and nowdate < #10/13/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-13" and getitemlimitcnt(item3id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-13" and getitemlimitcnt(item3id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="3회차 10월 12일" /></span></li>
				<li id="etb4" <% if left(nowdate,10)>="2016-10-13" then %> onclick="jsshow('4'); return false;"<% end if %> class="swiper-slide date1013 finish"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="4회차 10월 13일" /></span></li>
				<li id="etb5" <% if left(nowdate,10)>="2016-10-14" then %> onclick="jsshow('5'); return false;"<% end if %> class="swiper-slide date1014 <% if left(nowdate,10)>="2016-10-14" and left(nowdate,10)<"2016-10-17" then %>today current<% elseif left(nowdate,10)="2016-10-17" and nowdate < #10/17/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-17" and getitemlimitcnt(item5id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-17" and getitemlimitcnt(item5id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="5회차 10월 14일~16일" /></span></li>
				<li id="etb6" <% if left(nowdate,10)>="2016-10-17" then %> onclick="jsshow('6'); return false;"<% end if %> class="swiper-slide date1017 <% if left(nowdate,10)="2016-10-17" then %>today current<% elseif left(nowdate,10)="2016-10-18" and nowdate < #10/18/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-18" and getitemlimitcnt(item6id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-18" and getitemlimitcnt(item6id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="6회차 10월 17일" /></span></li>
				<li id="etb7" <% if left(nowdate,10)>="2016-10-18" then %> onclick="jsshow('7'); return false;"<% end if %> class="swiper-slide date1018 <% if left(nowdate,10)="2016-10-18" then %>today current<% elseif left(nowdate,10)="2016-10-19" and nowdate < #10/19/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-19" and getitemlimitcnt(item7id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-19" and getitemlimitcnt(item7id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="7회차 10월 18일" /></span></li>
				<li id="etb8" <% if left(nowdate,10)>="2016-10-19" then %> onclick="jsshow('8'); return false;"<% end if %> class="swiper-slide date1019 <% if left(nowdate,10)="2016-10-19" then %>today current<% elseif left(nowdate,10)="2016-10-20" and nowdate < #10/20/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-20" and getitemlimitcnt(item8id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-20" and getitemlimitcnt(item8id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="8회차 10월 19일" /></span></li>
				<li id="etb9" <% if left(nowdate,10)>="2016-10-20" then %> onclick="jsshow('9'); return false;"<% end if %> class="swiper-slide date1020 <% if left(nowdate,10)="2016-10-20" then %>today current<% elseif left(nowdate,10)="2016-10-21" and nowdate < #10/21/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-21" and getitemlimitcnt(item9id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-21" and getitemlimitcnt(item9id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="9회차 10월 20일" /></span></li>
				<li id="etb10" <% if left(nowdate,10)>="2016-10-21" then %> onclick="jsshow('10'); return false;"<% end if %> class="swiper-slide date1021 <% if left(nowdate,10)>="2016-10-21" and left(nowdate,10)<"2016-10-24" then %>today current<% elseif left(nowdate,10)="2016-10-24" and  nowdate < #10/24/2016 10:00:00# then %>soon<% elseif left(nowdate,10)>="2016-10-24" and  getitemlimitcnt(item10id) < 1 then %> finish<% elseif left(nowdate,10)="2016-10-24" and  getitemlimitcnt(item10id) > 0 then %>open<% end if %>"><span><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_date.png" alt="10회차 10월 21일~23일" /></span></li>
			</ul>
		</div>
		<button class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_prev.png" alt="이전" /></button>
		<button class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_next.png" alt="다음" /></button>
	</div>
	<div class="todayItem">

	<% if left(nowdate,10) >= "2016-10-10" then %>
		<%' 10월 10일  %>
		<div class="itemWrap" id="item1" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('1262196'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1010.png" alt="다니엘웰링턴(클래식실버 여성용)" /></a>
				<% if left(nowdate,10) >= "2016-10-11" and nowdate >= #10/11/2016 10:00:00# then %>
					<span class="limit20"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) = "2016-10-10" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip.png" alt="찬성하시는 분께 다음날 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) = "2016-10-10" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-11" and nowdate < #10/11/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1011.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-11" and nowdate >= #10/11/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item1id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1011.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item1id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-11" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item1id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 10일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-11" then %>
		<%' 10월 11일  %>
		<div class="itemWrap" id="item2" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('1479124'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1011.png" alt="EMIE 블루투스 스피커" /></a>
				<% if left(nowdate,10) >= "2016-10-12" and nowdate >= #10/12/2016 10:00:00# then %>
					<span class="limit30"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) = "2016-10-11" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip.png" alt="찬성하시는 분께 다음날 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) = "2016-10-11" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-12" and nowdate < #10/12/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1012.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-12" and nowdate >= #10/12/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item2id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1012.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item2id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-12" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item2id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 11일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-12" then %>
		<%' 10월 12일  %>
		<div class="itemWrap" id="item3" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('1313465'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1012.png" alt="마이빈스 더치커피팩 세트" /></a>
				<% if left(nowdate,10) >= "2016-10-13" and nowdate >= #10/13/2016 10:00:00# then %>
					<span class="limit30"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) = "2016-10-12" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip.png" alt="찬성하시는 분께 다음날 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) = "2016-10-12" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-13" and nowdate < #10/13/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1013.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-13" and nowdate >= #10/13/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item3id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1013.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item3id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-13" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item3id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 12일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-13" then %>
		<%' 10월 13일  %>
		<div class="itemWrap" id="item4" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('1226544'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1013.png" alt="에어비타 공기청정기" /></a>
				<% if left(nowdate,10) >= "2016-10-14" and nowdate >= #10/14/2016 10:00:00# then %>
					<span class="limit20"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) = "2016-10-13" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip.png" alt="찬성하시는 분께 다음날 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) = "2016-10-13" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-14" and nowdate < #10/14/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1014.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-14" and nowdate >= #10/14/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item4id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-14" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item4id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 13일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-14" then %>
		<%' 10월 14,15,16일  %>
		<div class="itemWrap" id="item5" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('1260092'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1014.png" alt="이소품 캔빌리지(화이트)" /></a>
				<% if left(nowdate,10) >= "2016-10-17" and nowdate >= #10/17/2016 10:00:00# then %>
					<span class="limit30"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if  left(nowdate,10) >= "2016-10-14" and  left(nowdate,10) < "2016-10-17" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip_02.png" alt="찬성하시는 분께 다음주 월요일 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) >= "2016-10-14" and left(nowdate,10) < "2016-10-17" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-17" and nowdate < #10/17/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1017.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-17" and nowdate >= #10/17/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item5id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1017.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item5id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-17" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item5id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 14일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-17" then %>
		<%' 10월 17일  %>
		<div class="itemWrap" id="item6" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('742608'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1017.png" alt="플라워 프레그런스 디퓨져(오일향기 랜덤)" /></a>
				<% if left(nowdate,10) >= "2016-10-18" and nowdate >= #10/18/2016 10:00:00# then %>
					<span class="limit50"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) = "2016-10-17" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip.png" alt="찬성하시는 분께 다음날 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) = "2016-10-17" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-18" and nowdate < #10/18/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1018.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-18" and nowdate >= #10/18/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item6id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1018.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item6id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-18" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item6id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 15일~17일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-18"  then %>
		<%' 10월 18일  %>
		<div class="itemWrap" id="item7" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('841828'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1018.png" alt="미니토끼 LED램프" /></a>
				<% if left(nowdate,10) >= "2016-10-19" and nowdate >= #10/19/2016 10:00:00# then %>
					<span class="limit50"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) = "2016-10-18" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip.png" alt="찬성하시는 분께 다음날 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) = "2016-10-18" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-19" and nowdate < #10/19/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1019.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-19" and nowdate >= #10/19/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item7id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1019.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item7id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-19" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item7id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 18일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-19"  then %>
		<%' 10월 19일  %>
		<div class="itemWrap" id="item8" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('1494253'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1019.png" alt="오스터 볼 메이슨자 스무디 믹서기" /></a>
				<% if left(nowdate,10) >= "2016-10-20" and nowdate >= #10/20/2016 10:00:00# then %>
					<span class="limit30"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) = "2016-10-19" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip.png" alt="찬성하시는 분께 다음날 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) = "2016-10-19" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-20" and nowdate < #10/20/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1020.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-20" and nowdate >= #10/20/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item8id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1020.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item8id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-20" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item8id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 19일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-20"  then %>
		<%' 10월 20일  %>
		<div class="itemWrap" id="item9" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('1545082'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1020.png" alt="디즈니 티타임 팩" /></a>
				<% if left(nowdate,10) >= "2016-10-21" and nowdate >= #10/21/2016 10:00:00# then %>
					<span class="limit30"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) = "2016-10-20" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip.png" alt="찬성하시는 분께 다음날 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) = "2016-10-20" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-21" and nowdate < #10/21/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1021.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-21" and nowdate >= #10/21/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item9id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1021.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item9id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-21" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item9id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 20일  %>
	<% end if %>

	<% if left(nowdate,10) >= "2016-10-21" then %>
		<%' 10월 21일~23일  %>
		<div class="itemWrap" id="item10" style="display:none">
			<div class="itemPic">
				<a href="" onclick="jsViewItem('255242'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/item_1021.png" alt="오토 플립 클락" /></a>
				<% if left(nowdate,10) >= "2016-10-24" and nowdate >= #10/24/2016 10:00:00# then %>
					<span class="limit50"></span>
				<% end if %>
			</div>
			<div class="itemInfo">
			<% if left(nowdate,10) >= "2016-10-21" and left(nowdate,10) < "2016-10-24" then %>
				<% if subscriptcount1 < 1 then %>
					<%' case1. 찬성/반대 투표하기  %>
					<div class="case1">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_agree.png" alt="위 할인가에 찬성하십니까?" /></p>
						<div class="btnArea">
							<button type="button" onclick="jssubmit(); return false;" class="btnAgr agreeY"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_agree.png" alt="찬성" /></button>
							<button class="btnAgr agreeN" onclick="jssubmitx();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_disagree.png" alt="반대" /></button>
						</div>
						<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_tip_02.png" alt="찬성하시는 분께 다음주 월요일 오전 10시, 구매버튼이 열립니다!" /></p>
					</div>
				<% end if %>
			<% end if %>

			<% if (left(nowdate,10) >= "2016-10-21" and left(nowdate,10) < "2016-10-24" and subscriptcount1 > 0 ) or ( left(nowdate,10) = "2016-10-24" and nowdate < #10/24/2016 10:00:00# and subscriptcount2 > 0 ) then %>
				<%' case2. 구매하기(비활성)  %>
				<div class="case2">
					<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1024.png" alt="오전 10시 구매버튼이 열립니다" /></p>
					<button type="button" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_off.png" alt="구매하기" /></button>
				</div>
			<% elseif left(nowdate,10) >= "2016-10-24" and nowdate >= #10/24/2016 10:00:00# and subscriptcount2 > 0 then %>
				<% if getitemlimitcnt(item10id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case3. 구매하기(활성)  %>
					<div class="case3">
						<p class="open10am"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_10am_1024.png" alt="오전 10시 구매버튼이 열립니다" /></p>
						<a href="" onclick="jsgetitem('<%=item10id%>'); return false;" class="btnBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_buy_on.png" alt="지금 구매하기" /></a>
					</div>
				<% end if %>
			<% elseif left(nowdate,10) >= "2016-10-24" and subscriptcount2 < 1 then %>
				<% if getitemlimitcnt(item10id) < 1 then %>
					<div class="case5">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_soldout.png" alt="품절" /></p>
					</div>
				<% else %>
					<%' case4. 미참여/반대고객  %>
					<div class="case4">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/txt_sorry.png" alt="해당 기간 할인가에 천성해주신 고객분들께만 구매하기 버튼이 보입니다" /></p>
					</div>
				<% end if %>
			<% end if %>
			</div>
		</div>
		<%'// 10월 21일~23일  %>
	<% end if %>

		<div class="btnPreview"><button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_preview.png" alt="다음 상품 미리보기" /></button></div>
		<%' 상품 미리보기 레이어  %>
		<div id="lyrPreview" style="display:none;">
			<div class="previewCont">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/img_preview.png" alt="다음 상품 미리보기" /></div>
				<button type="button" class="close" onclick="ClosePopLayer()"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73064/m/btn_close.png" alt="닫기" /></button>
			</div>
		</div>
		<%'// 상품 미리보기 레이어  %>
	</div>
	<%' 이벤트 유의사항  %>
	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>본 이벤트는 각 회차 당 할인가에 찬성한 사람에게만 해당 상품을 구매할 수 있는 기회가 주어집니다.</li>
			<li>구매버튼은 다음 회차가 오픈되는 오전10시에 클릭할 수 있습니다.</li>
			<li>각 상품은 한정수량이며 선착순으로 구매할 수 있습니다.</li>
			<li>구매자에게는 상품에 따라 세무신고에 필요한 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
			<li>본 이벤트의 상품은 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
		</ul>
	</div>

	<%' SNS 공유  %>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/txt_share.png" alt="텐바이텐 15주년 이야기, 친구와 함께라면!" /></p>
		<ul>
			<li class="btnKakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_kakao.png" alt="텐바이텐 15주년 이야기 카카오톡으로 공유" /></a></li>
			<li class="btnFb"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_facebook.png" alt="텐바이텐 15주년 이야기 페이스북으로 공유" /></a></li>
		</ul>
	</div>

	<ul class="tenSubNav">
		<li class="tPad1-5r"><a href="eventmain.asp?eventid=73063"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_walk.png" alt="워킹맨" /></a></li>
		<li class="tPad1r"><a href="eventmain.asp?eventid=73068"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_gift.png" alt="사은품을 부탁해" /></a></li>
		<li class="tPad1r"><a href="eventmain.asp?eventid=73053"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_main.png" alt="텐바이텐 15주년 이야기" /></a></li>
	</ul>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->