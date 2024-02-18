<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [텐쑈]뽑아주쑈!
' History : 2017.09.26 정태훈
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/event/16th/pickshowCls.asp" -->
<%
dim eCode, eItemCode, vUserID, nowdate, itemid, ItemGroupCate
Dim sqlstr, evtsubscriptcnt, ItemGroup, ItemGroupNum, gid
IF application("Svr_Info") = "Dev" THEN
	eCode = "67435"
	eItemCode="67436"
Else
	eCode = "80412"
	eItemCode="80741"
End If

gid = requestCheckVar(Request("gid"),10)

If gid<>"" Then
	nowdate=GetItemGroupDate(gid)
Else
	nowdate = date()
End If
vUserID = getEncLoginUserID

If nowdate="2017-10-10" Then
	ItemGroup="220325"
	ItemGroupNum="0"
	ItemGroupCate="101"
ElseIf nowdate="2017-10-11" Then
	ItemGroup="220326"
	ItemGroupNum="1"
	ItemGroupCate="102"
ElseIf nowdate="2017-10-12" Then
	ItemGroup="220327"
	ItemGroupNum="2"
	ItemGroupCate="103"
ElseIf nowdate="2017-10-13" Then
	ItemGroup="220328"
	ItemGroupNum="3"
	ItemGroupCate="104"
ElseIf nowdate="2017-10-14" Then
	ItemGroup="220329"
	ItemGroupNum="4"
	ItemGroupCate="124"
ElseIf nowdate="2017-10-15" Then
	ItemGroup="220437"
	ItemGroupNum="5"
	ItemGroupCate="121"
ElseIf nowdate="2017-10-16" Then
	ItemGroup="220438"
	ItemGroupNum="6"
	ItemGroupCate="122"
ElseIf nowdate="2017-10-17" Then
	ItemGroup="220439"
	ItemGroupNum="7"
	ItemGroupCate="120"
ElseIf nowdate="2017-10-18" Then
	ItemGroup="220440"
	ItemGroupNum="8"
	ItemGroupCate="112"
ElseIf nowdate="2017-10-19" Then
	ItemGroup="220441"
	ItemGroupNum="9"
	ItemGroupCate="119"
ElseIf nowdate="2017-10-20" Then
	ItemGroup="220442"
	ItemGroupNum="10"
	ItemGroupCate="117"
ElseIf nowdate="2017-10-21" Then
	ItemGroup="220443"
	ItemGroupNum="11"
	ItemGroupCate="116"
ElseIf nowdate="2017-10-22" Then
	ItemGroup="220444"
	ItemGroupNum="12"
	ItemGroupCate="125"
ElseIf nowdate="2017-10-23" Then
	ItemGroup="220445"
	ItemGroupNum="13"
	ItemGroupCate="118"
ElseIf nowdate="2017-10-24" Then
	ItemGroup="220446"
	ItemGroupNum="14"
	ItemGroupCate="115"
ElseIf nowdate="2017-10-25" Then
	ItemGroup="220447"
	ItemGroupNum="15"
	ItemGroupCate="110"
Else
	ItemGroup="220325"
	ItemGroupNum="0"
	ItemGroupCate="101"
End If

Function GetItemGroupDate(groupcode)
	If groupcode="220325" Then
		GetItemGroupDate="2017-10-10"
	ElseIf groupcode="220326" Then
		GetItemGroupDate="2017-10-11"
	ElseIf groupcode="220327" Then
		GetItemGroupDate="2017-10-12"
	ElseIf groupcode="220328" Then
		GetItemGroupDate="2017-10-13"
	ElseIf groupcode="220329" Then
		GetItemGroupDate="2017-10-14"
	ElseIf groupcode="220437" Then
		GetItemGroupDate="2017-10-15"
	ElseIf groupcode="220438" Then
		GetItemGroupDate="2017-10-16"
	ElseIf groupcode="220439" Then
		GetItemGroupDate="2017-10-17"
	ElseIf groupcode="220440" Then
		GetItemGroupDate="2017-10-18"
	ElseIf groupcode="220441" Then
		GetItemGroupDate="2017-10-19"
	ElseIf groupcode="220442" Then
		GetItemGroupDate="2017-10-20"
	ElseIf groupcode="220443" Then
		GetItemGroupDate="2017-10-21"
	ElseIf groupcode="220444" Then
		GetItemGroupDate="2017-10-22"
	ElseIf groupcode="220445" Then
		GetItemGroupDate="2017-10-23"
	ElseIf groupcode="220446" Then
		GetItemGroupDate="2017-10-24"
	ElseIf groupcode="220447" Then
		GetItemGroupDate="2017-10-25"
	Else
		GetItemGroupDate="2017-10-10"
	End If
End Function

Dim pickitem1, pickitem2, pickitem3
if vUserID <> "" Then
	sqlstr = ""
	sqlstr = "select pickitem1, pickitem2, pickitem3"
	sqlstr = sqlstr & " from [db_temp].[dbo].[tbl_event_16th_pickshow]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and evt_sub_code="& ItemGroup &" and userid='"& vUserID &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		pickitem1 = rsget("pickitem1")
		pickitem2 = rsget("pickitem2")
		pickitem3 = rsget("pickitem3")
	END IF
	rsget.close
End If



Dim cEventItemTop, iTotCnt2
Set cEventItemTop = New ClsEvtItem
cEventItemTop.FECode 	= eItemCode
cEventItemTop.FEGCode 	= ItemGroup
cEventItemTop.FEItemCnt=3
cEventItemTop.FItemsort=8
cEventItemTop.fnGetEventItem
iTotCnt2 = cEventItemTop.FTotCnt

Dim cEventItem, iTotCnt, ix
Set cEventItem = New ClsEvtItem
cEventItem.FECode 	= eItemCode
cEventItem.FEGCode 	= ItemGroup
cEventItem.FEItemCnt=36
cEventItem.FItemsort=9
cEventItem.fnGetEventItem
iTotCnt = cEventItem.FTotCnt

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg, vAppLink, vAdrVer, vLink, vTitle
snpTitle = Server.URLEncode("[텐바이텐] 16주년 텐쇼 뽑아주쑈!")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/16th/pickshow.asp")
snpPre = Server.URLEncode("[텐바이텐] 16주년 텐쑈")
snpTag = Server.URLEncode("[텐바이텐] 16주년 텐쇼 뽑아주쑈!")
snpTag2 = Server.URLEncode("#10x10")
snpImg = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_sub2.jpg")	

vLink = "http://m.10x10.co.kr/event/16th/pickshow.asp"
vTitle = "매일매일 마음에 드는 아이템을 골라주세요.\n\n참여해주신 모든 분께 100마일리지를 드립니다!"

'//핀터레스트용
Dim ptTitle , ptLink , ptImg
ptTitle = "[텐바이텐] 16주년 뽑아주쑈!"
ptLink	= "http://m.10x10.co.kr/event/16th/pickshow.asp"
ptImg	= "http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_sub2.jpg"

if inStr(lcase(vLink),"appcom")>0 then
	vAppLink = vLink
else
	vAppLink = replace(vLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")
end If
	'APP 버전 접수
	vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
	if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>
<style type="text/css">
/* common */
.ten-show .noti {padding:2.30rem; background-color:#6a6a6a; color:#cecece;}
.ten-show .noti h3 {position:relative; padding-left:2.39rem; margin-bottom:.94rem; color:#fff;font-size:1.37rem;}
.ten-show .noti h3:before {display:inline-block; content:' '; position:absolute; top:50%; left:0;width:1.62rem; height:1.62rem; margin-top:-.81rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/m/img_noti.png) no-repeat 0 0;background-size:100%;}
.ten-show .noti ul li {font-size:1.1rem; line-height:1.79rem; text-indent:-1rem; padding-left:1rem;}
.ten-show .share {position:relative;}
.ten-show .share .btn-group {position:absolute; bottom:2.39rem; left:50%; margin-left:-9.2rem;}
.ten-show .share .btn-group a {display:inline-block; width:3.75rem; margin:0 .85rem;}
.ten-show .ten-show-bnr li{margin-top:.6rem;}

/* pick show */
.pick-show {background-color:#fff; }
.pick-head {position:relative; background:#102c73 url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/bg_dark_blue.jpg) no-repeat 0 0; background-size:100%;}
.subcopy {padding-top:53.73%;}
.pick-head span {display:inline-block; position:absolute;}
.pick-head .t1 {width:50.4%; top:27.28%; left:12.26%; z-index:10; opacity:0; animation:bounce1 .8s forwards; -webkit-animation:bounce1 .8s forwards; }
.pick-head .t2 {width:25.2%; top:29.21%; right:11.46%; opacity:0; animation:bounce1 1s .3s forwards; -webkit-animation:bounce1 1s .3s forwards;}
.pick-head .dc1 {width:12.53%; bottom:36.31%; right:30.66%; opacity:0;  animation:cursor .8s .5s forwards; -webkit-animation:cursor .8s .5s forwards;}
.pick-head .dc2 {width:16.8%; top:30.51%; left:9.7%; opacity:0; animation:bounce1 1.2s 1.3s forwards; -webkit-animation:bounce1 1.2s 1.3s forwards;}
.pick-head .dc3 {width:11.46%; top:30.51%; left:25.4%; z-index:15; opacity:0; animation:twinkle1 1s 1.3s 100; -webkit-animation:twinkle1 1s 1.3s 100;}
.pick-head .dc4 {width:4.93%; top:36.2%; right:19.33%; opacity:0; animation:twinkle1 1s 1.5s 100; -webkit-animation:twinkle1 1s 1.5s 100;}

.pick-nav {position:relative; z-index:30; width:100%; height:5.55rem; -webkit-box-shadow:0px 10px 20px 0px rgba(231,231,231,1); -moz-box-shadow:0px 10px 20px 0px rgba(231,231,231,1); box-shadow:0px 10px 20px 0px rgba(231,231,231,1);}
.pick-nav .swiper-slide {width:30.66%; height:5.55rem; background-color:#fff; color:#fff; font-size:1.02rem; line-height:1.495rem; text-align:center;}
.pick-nav .swiper-slide:first-child {margin-left:0;}
.pick-nav .swiper-slide a {display:block; height:100%; padding-top:1.065rem; border-right:0.13rem solid #e5e5e5;}
.pick-nav .swiper-slide span {display:inline-block; height:1.795rem; width:4.69rem; margin:0 auto 0.64rem; background-color:#d9d8d8; font-size:1.02rem; line-height:1.95; border-radius:1rem; font-weight:bold}
.pick-nav .swiper-slide strong {display:block; font-size:1.325rem; color:#d9d8d8;}
.pick-nav .swiper-slide.current {padding-top:0; background-color:#3873eb; }
.pick-nav .swiper-slide.current a {border-right:0.13rem solid #3267d3;}
.pick-nav .swiper-slide.current span {background-color:#0d4cca; color:#72b4ff;}
.pick-nav .swiper-slide.current strong {color:#fff;}
.pick-nav .swiper-slide.open {padding-top:0; background-color:#bddcff; }
.pick-nav .swiper-slide.open a {border-right:0.13rem solid #93c3fa;}
.pick-nav .swiper-slide.open span {background-color:#fff; color:#bddcff;}
.pick-nav .swiper-slide.open strong {color:#fff;}

.item-list {padding:3.5rem 0 2.99rem; background-color:#fff;}
.items-rolling {position:relative; width:100%; height:33.8rem;margin: 0 auto; z-index:1;}
.items-rolling .swiper-container {overflow:hidden; width:25.35rem; height:33.8rem; margin:0 auto;}
.items-rolling .swiper-slide {overflow:hidden; float:left; width:25.35rem !important; height:33.8rem !important;}
.items-rolling li {position:relative; float:left; width:8.02rem; height:8.02rem; margin:0.215rem;}
.items-rolling li:nth-child(3n+1){clear:left;}
.items-rolling li.on span{position:relative; display:inline-block; position:absolute; top:0; left:0; width:8.02rem; height:8.02rem; border:solid 0.64rem #ff4e4e;}
.items-rolling li.on span:after {content:' '; display:block; position:absolute; top:-.6rem; right:-.6rem; width:3.84rem; height:3.84rem; background-size:100%; z-index:10;}
.items-rolling li.on1 span:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/txt_choice1.png);}
.items-rolling li.on2 span:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/txt_choice2.png);}
.items-rolling li.on3 span:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/txt_choice3.png);}
.items-rolling button {position:absolute; top:0; width:11.2%; background-color:transparent;}
.items-rolling .btnPrev {left:0;}
.items-rolling .btnNext {right:0;}
.items-rolling .pagination {position:absolute; bottom:-2.99rem; left:50%; margin-left:-3.9rem; padding:0; height:1.835rem; z-index:20;}
.items-rolling .pagination span{display:inline-block; width:1.835rem; height:1.835rem; margin:0 .385rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_pagination.png)no-repeat 0 0; background-size:7.09rem 4.01rem; transition:all .6s;}
.items-rolling .pagination span:nth-child(2) {background-position:-2.65rem 0;}
.items-rolling .pagination span:nth-child(3) {background-position:100% 0;}
.items-rolling .pagination .swiper-active-switch {background-position:0 100%;}
.items-rolling .pagination span:nth-child(2).swiper-active-switch {background-position:-2.65rem 100%;}
.items-rolling .pagination span:nth-child(3).swiper-active-switch {background-position:100% 100%;}

.default-font .thumbnail:before {display:none;}
.pick-conts {position:relative; z-index:5}
.pick-conts.before .my-pick {padding-top:3.5rem;}
.pick-conts.before .real-rank {display:none;}
.pick-conts.after .real-rank {display:block; position:absolute; top:0; left:0;}
.pick-conts.after .my-pick {display:none;}
.pick-conts.after .item-list {padding:23.4rem 0 6.4rem;}

.picked-item ul li .thumbnail {display:block; width:100%; height:0; padding-bottom:100%;}
.picked-item ul li .thumbnail img{display:block; width:100%; height:auto;}
.picked-item {overflow:hidden;}
.picked-item .my-pick ul {overflow:visible; width:79.34%; padding-bottom:20.66%;  margin:0 auto 1.71rem;}
.picked-item .my-pick ul li {float:left; position:relative; width:33.33%; height:auto; padding:0 1.02rem;}
.picked-item .my-pick ul li .thumbnail {background:#d6d6d6 url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/bg_blank.png) no-repeat 50% 50%; background-size:4.1rem; color:transparent;}
.picked-item .my-pick ul li .delete {display:block; position:absolute; top:-.85rem; right:0; z-index:20; width:2.39rem;}
.picked-item .my-pick .submit {width:100%; background-color:transparent;}
.picked-item .my-pick .submit.bounce2 {animation:bounce2 .2s forwards;}

.picked-item .real-rank {position:relative; width:100%; background-color:#f0f0f0; padding-top:3.5rem;}
.picked-item .real-rank h3 {width:36%; margin-left:2.99rem;}
.picked-item .real-rank .go-category {display:inline-block; position:absolute; top:3.75rem; right:2.99rem; font-size:1.11rem; color:#7a7a7a; text-decoration:underline;}
.picked-item .real-rank ul{overflow:hidden;; margin:1.54rem 9.4% 3.33rem;}
.picked-item .real-rank ul li{position:relative; float:left; width:29.76%; height:100%; margin:0 .68rem;}
.picked-item .real-rank ul li:nth-child(1){margin-left:0;}
.picked-item .real-rank ul li:nth-child(3){margin-right:0;}
.picked-item .real-rank ul li .rank{content:' '; display:block; position:absolute; top:0; left:0; z-index:20; width:1.88rem; height:1.54rem; background-color:#da3d3d; color:#fff; line-height:1.7rem;text-align:center;}
.picked-item .real-rank ul li .thumbnail img{border:solid .34rem #fff;}

.ly-item {position:absolute; top:0; left:0; z-index:30; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/bg_black.png) repeat 0 0;}
.ly-item .chosen-item {position:relative; top:10.07rem; width:70.8%; padding:1.37rem; margin:0 auto; background-color:#fff; border-radius:.51rem;}
.ly-item .chosen-item .thumbnail {width:100%; height:auto; }
.ly-item .chosen-item .item-detail {margin-top:1.54rem; font-size:1.4rem; color:#343434; text-align:center;}
.ly-item .chosen-item .item-detail .p {width:100%;}
.ly-item .chosen-item .item-detail .name {margin-top:1.04rem; line-height:1.3;}
.ly-item .chosen-item .item-detail .price {width:100%; padding:.85rem 0;}
.ly-item .chosen-item .item-detail .orgin {color:#4c4c4c; text-decoration:line-through}
.ly-item .chosen-item .item-detail .final-price {color:#da3d3d; font-weight:bold;}
.ly-item .chosen-item .item-detail .btn {display:block; width:100%; height:3.41rem; margin-top:.85rem; font-size:1.28rem; line-height:3.41rem; color:#fff;}
.ly-item .chosen-item .item-detail .btn-pick {background-color:#d11d1d;}
.ly-item .chosen-item .item-detail .btn-more {background-color:#9e9e9e;}
.ly-item .chosen-item .close {position:absolute; top:-.85rem; right:-.85rem; width:2.345rem;}
.ellipsis-multi {overflow:hidden; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-wrap:break-word; white-space: normal;}
.ellipsis {display: inline-block; white-space: nowrap;overflow: hidden; text-overflow: ellipsis;}

@keyframes cursor {from {transform:translate(70px, 50px); opacity:0;} 80% {transform:translate(0);} 85% {transform:translateY(10px);}to {transform:translate(0); opacity:1;}}
@keyframes bounce1 {from {transform:translateY(-30px);} 50%{transform:translateY(10px)} to {transform:translateY(0); opacity:1;}}
@keyframes bounce2 {from to{transform:translateY(0);} 50%{transform:translateY(5px)}}
@keyframes twinkle1 {from,to {opacity:0;} 50% {opacity:1;}}

@-webkit-keyframes cursor {from {transform:translate(30px, 10px); opacity:0;} 80% {transform:translate(0);} 85% {transform:translateY(10px);}to {transform:translate(0); opacity:1;}}
@-webkit-keyframes bounce1 {from {transform:translateY(-30px);} 50%{transform:translateY(10px)} to {transform:translateY(0); opacity:1;}}
@-webkit-keyframes bounce2 {from to{transform:translateY(0);} 50%{transform:translateY(5px)}}
@-webkit-keyframes twinkle1 {from,to {opacity:0;} 50% {opacity:1;}}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#pick-nav .swiper-container",{
		initialSlide:<% If ItemGroupNum>0 Then Response.write ItemGroupNum-1 Else Response.write ItemGroupNum End If %>,
		slidesPerView:"auto"
	});

	itemSwiper = new Swiper('.items-rolling .swiper-container',{
		initialSlide:0,
		loop:true,
		autoplay:false,
		speed:800,
		slidesPerView:'1',
		pagination:'.items-rolling .pagination',
		nextButton:'.items-rolling .btnNext',
		prevButton:'.items-rolling .btnPrev',
		paginationClickable: true
	});

	$('.items-rolling .btnPrev').on('click', function(e){
		e.preventDefault()
		itemSwiper.swipePrev()
	});

	$('.items-rolling .btnNext').on('click', function(e){
		e.preventDefault()
		itemSwiper.swipeNext()
	});

	$(".ly-item").hide();
	$(".ly-item .thumbnail").hide();
//	$(".items-rolling ul li").click(function(){
//		$(".ly-item").show();
//		$(".ly-item .thumbnail").fadeIn(800);
//		window.parent.$('html,body').animate({scrollTop:$('.chosen-item').offset().top - 70},400);
//		event.preventDefault();
//	});
});

function fnClosePop(){
	$(".ly-item").hide();
	$(".ly-item .thumbnail").hide();
	event.preventDefault();
	return false;
}
function fnItemInfoView(itemid,sid){
//alert(itemid);
	$.ajax({
		url: "/event/16th/act_itemprd_pop.asp?itemid="+itemid+"&eCode=<%=eCode%>&sid="+sid,
		cache: false,
		async: false,
		success: function(message) {
			if(message!="") {
				$str = $(message);
				$(".ly-item").empty(); 
				$(".ly-item").show();
				$(".ly-item .thumbnail").fadeIn(800);
				//event.preventDefault();
				$(".ly-item").append($str);
				return false;
			} else {
				alert("제공 할 정보가 없습니다.");
				return false;
			}
		}
	});
}

function fnSelectPickItem(itemid,img,sid){
<% If IsUserLoginOK() Then %>
	if($("#itemid1").val()&&$("#itemid2").val()&&$("#itemid3").val()) {
		alert("아이템은 최대 3개까지 고를 수 있습니다.");
		return;
	}

	if($("#itemid1").val()==itemid||$("#itemid2").val()==itemid||$("#itemid3").val()==itemid) {
		alert("이미 선택하신 상품입니다.");
		return;
	}

	var str='<span class="thumbnail"><img src="' + img + '" /></span>';

	if($("#itemid1").val()=="")
	{
		str=str+'<a href="" onclick="fnDeletePickItem(1,'+sid+');return false;" class="delete"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_delete.png" alt="선택 취소하기" /></a>';
		$("#spick1").empty();
		$("#itemid1").val(itemid);
		$("#spick1").append(str);
		$("#lyrItemRolling [data='sid"+sid+"']").addClass("on on1");
	}
	else if($("#itemid2").val()=="")
	{
		str=str+'<a href="" onclick="fnDeletePickItem(2,'+sid+');return false;" class="delete"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_delete.png" alt="선택 취소하기" /></a>';
		$("#spick2").empty();
		$("#itemid2").val(itemid);
		$("#spick2").append(str);
		$("#lyrItemRolling [data='sid"+sid+"']").addClass("on on2");
	}
	else
	{
		str=str+'<a href="" onclick="fnDeletePickItem(3,'+sid+');return false;" class="delete"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_delete.png" alt="선택 취소하기" /></a>';
		$("#spick3").empty();
		$("#itemid3").val(itemid);
		$("#spick3").append(str);
		$("#lyrItemRolling [data='sid"+sid+"']").addClass("on on3");
	}
	$(".ly-item").hide();
	$(".ly-item .thumbnail").hide();
	//event.preventDefault();
	return false;	
<% else %>
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/16th/pickshow.asp")%>');
		return false;
	<% end if %>
<% End IF %>
}
function fnDeletePickItem(delnum,sid){
	$("#itemid"+delnum).val("");
	$("#spick"+delnum).empty();
	$("#spick"+delnum).append('<span class="thumbnail"></span>');
	if(delnum=="1")
	{
		$("#lyrItemRolling [data='sid"+sid+"']").removeClass("on on1");
	}
	else if(delnum=="2")
	{
		$("#lyrItemRolling [data='sid"+sid+"']").removeClass("on on2");
	}
	else if(delnum=="3")
	{
		$("#lyrItemRolling [data='sid"+sid+"']").removeClass("on on3");
	}
	return false;
}
function fnSubmitPick(){
<% If IsUserLoginOK() Then %>
	if($("#itemid1").val()=="" && $("#itemid2").val()=="" && $("#itemid3").val()=="")
	{
		alert("아이템을 한가지 이상 선택해 주세요.");
		return false;
	}
	else
	{
		document.pickfrm.action="/event/16th/dopickshow.asp";
		document.pickfrm.submit();
	}
<% else %>
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/16th/pickshow.asp")%>');
		return false;
	<% end if %>
<% End IF %>
}

function tnKakaoLink(title){
	parent_kakaolink(title , 'http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_sub2.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/16th/pickshow.asp');
	return false;
}

// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	return false;
}

function fnSelectItemDel(itemid){
	$("#itemid1").val("");
	$("#itemid2").val("");
	$("#itemid3").val("");
	location.href="/category/category_itemPrd.asp?itemid="+itemid+"&pEtr=<%=eCode%>";
}

</script>
			<div class="ten-show pick-show">
				<div class="pick-head">
					<h2>
						<span class="t1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/tit_pick1.png" alt="뽑아주" /></span>
						<span class="t2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/tit_pick2.png" alt="쑈!" /></span>
					</h2>
					<span class="dc1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_cursor.png" alt="커서" /></span>
					<span class="dc2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_coin.png" alt="동전" /></span>
					<span class="dc3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_star1.png" alt="반짝이" /></span>
					<span class="dc4"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_star2.png" alt="반짝이" /></span>
					<p class="subcopy"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/txt_subcopy.jpg" alt="매일매일 마음에 드는 아이템을 최대 3개까지 골라주세요!" /></p>
				</div>

				<!-- 날짜별 tab -->
				<!-- for dev msg 현재탭에 current 붙여주세요-->
				<div id="pick-nav" class="pick-nav">
					<div class="swiper-container">
						<ul class="swiper-wrapper">
							<li class="swiper-slide<% If ItemGroup="220325" Or ItemGroup="137205" Then %> current<% Else %><% If date() < "2017-10-11" Then %><% Else %> open<% End If %><% End If %>">
								<a href="/event/16th/pickshow.asp?gid=220325" target="_top"><span class="date">10/10</span><strong>디자인 문구</strong></a>
							</li>
							<li class="swiper-slide<% If ItemGroup="220326" Then %> current<% Else %><% If date() < "2017-10-11" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-11" Then %>
									<% If Date() < "2017-10-11" Then %>
									<a><span class="date">10/11</span><strong>디지털 &middot; 핸드폰</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220326" target="_top"><span class="date">10/11</span><strong>디지털 &middot; 핸드폰</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220326" target="_top"><span class="date">10/11</span><strong>디지털 &middot; 핸드폰</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220327" Then %> current<% Else %><% If date() < "2017-10-12" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-12" Then %>
									<% If Date() < "2017-10-12" Then %>
									<a><span class="date">10/12</span><strong>캠핑 &middot; 트래블</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220327" target="_top"><span class="date">10/12</span><strong>캠핑 &middot; 트래블</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220327" target="_top"><span class="date">10/12</span><strong>캠핑 &middot; 트래블</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220328" Then %> current<% Else %><% If date() < "2017-10-13" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-13" Then %>
									<% If Date() < "2017-10-13" Then %>
									<a><span class="date">10/13</span><strong>토이</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220328" target="_top"><span class="date">10/13</span><strong>토이</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220328" target="_top"><span class="date">10/13</span><strong>토이</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220329" Then %> current<% Else %><% If date() < "2017-10-14" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-14" Then %>
									<% If Date() < "2017-10-14" Then %>
									<a><span class="date">10/14</span><strong>디자인가전</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220329" target="_top"><span class="date">10/14</span><strong>디자인가전</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220329" target="_top"><span class="date">10/14</span><strong>디자인가전</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220437" Then %> current<% Else %><% If date() < "2017-10-15" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-15" Then %>
									<% If Date() < "2017-10-15" Then %>
									<a><span class="date">10/15</span><strong>가구 &middot; 수납</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220437" target="_top"><span class="date">10/15</span><strong>가구 &middot; 수납</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220437" target="_top"><span class="date">10/15</span><strong>가구 &middot; 수납</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220438" Then %> current<% Else %><% If date() < "2017-10-16" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-16" Then %>
									<% If Date() < "2017-10-16" Then %>
									<a><span class="date">10/16</span><strong>데코 &middot; 조명</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220438" target="_top"><span class="date">10/16</span><strong>데코 &middot; 조명</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220438" target="_top"><span class="date">10/16</span><strong>데코 &middot; 조명</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220439" Then %> current<% Else %><% If date() < "2017-10-17" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-17" Then %>
									<% If Date() < "2017-10-17" Then %>
									<a><span class="date">10/17</span><strong>패브릭 &middot; 생활</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220439" target="_top"><span class="date">10/17</span><strong>패브릭 &middot; 생활</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220439" target="_top"><span class="date">10/17</span><strong>패브릭 &middot; 생활</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220440" Then %> current<% Else %><% If date() < "2017-10-18" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-18" Then %>
									<% If Date() < "2017-10-18" Then %>
									<a><span class="date">10/18</span><strong>키친</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220440" target="_top"><span class="date">10/18</span><strong>키친</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220440" target="_top"><span class="date">10/18</span><strong>키친</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220441" Then %> current<% Else %><% If date() < "2017-10-19" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-19" Then %>
									<% If Date() < "2017-10-19" Then %>
									<a><span class="date">10/19</span><strong>푸드</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220441" target="_top"><span class="date">10/19</span><strong>푸드</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220441" target="_top"><span class="date">10/19</span><strong>푸드</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220442" Then %> current<% Else %><% If date() < "2017-10-20" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-20" Then %>
									<% If Date() < "2017-10-20" Then %>
									<a><span class="date">10/20</span><strong>패션의류</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220442" target="_top"><span class="date">10/20</span><strong>패션의류</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220442" target="_top"><span class="date">10/20</span><strong>패션의류</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220443" Then %> current<% Else %><% If date() < "2017-10-21" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-21" Then %>
									<% If Date() < "2017-10-21" Then %>
									<a><span class="date">10/21</span><strong>패션잡화</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220443" target="_top"><span class="date">10/21</span><strong>패션잡화</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220443" target="_top"><span class="date">10/21</span><strong>패션잡화</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220444" Then %> current<% Else %><% If date() < "2017-10-22" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-22" Then %>
									<% If Date() < "2017-10-22" Then %>
									<a><span class="date">10/22</span><strong>쥬얼리 &middot; 시계</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220444" target="_top"><span class="date">10/22</span><strong>쥬얼리 &middot; 시계</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220444" target="_top"><span class="date">10/22</span><strong>쥬얼리 &middot; 시계</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220445" Then %> current<% Else %><% If date() < "2017-10-23" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-23" Then %>
									<% If Date() < "2017-10-23" Then %>
									<a><span class="date">10/23</span><strong>뷰티</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220445" target="_top"><span class="date">10/23</span><strong>뷰티</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220445" target="_top"><span class="date">10/23</span><strong>뷰티</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220446" Then %> current<% Else %><% If date() < "2017-10-24" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-24" Then %>
									<% If Date() < "2017-10-24" Then %>
									<a><span class="date">10/24</span><strong>베이비 &middot; 키즈</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220446" target="_top"><span class="date">10/24</span><strong>베이비 &middot; 키즈</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220446" target="_top"><span class="date">10/24</span><strong>베이비 &middot; 키즈</strong></a>
								<% End If %>
							</li>
							<li class="swiper-slide<% If ItemGroup="220447" Then %> current<% Else %><% If date() < "2017-10-25" Then %><% Else %> open<% End If %><% End If %>">
								<% If nowdate < "2017-10-25" Then %>
									<% If Date() < "2017-10-25" Then %>
									<a><span class="date">10/25</span><strong>CAT&DOG</strong></a>
									<% Else %>
									<a href="/event/16th/pickshow.asp?gid=220447" target="_top"><span class="date">10/25</span><strong>CAT&DOG</strong></a>
									<% End If %>
								<% Else %>
								<a href="/event/16th/pickshow.asp?gid=220447" target="_top"><span class="date">10/25</span><strong>CAT&DOG</strong></a>
								<% End If %>
							</li>
						</ul>
					</div>
					<div class="shadow"></div>
				</div>

				<div class="pick-conts<% If pickitem1<>"" Or pickitem2<>"" Or pickitem3<>"" Then %> after<% Else %> before<% End If %>">
					<!-- 상품 리스트 -->
					<!-- for dev msg 
						- 선택한 상품은 <li>...</li>에 on 클래스 붙여주세요.
						- 선택한 순서에 따라 on1, on2, on3 붙여주세요
						<li class="on on1">
					-->
					
					<div class="item-list">
						<div class="items-rolling">
							<div class="swiper-container" id="lyrItemRolling">
								<div class="swiper-wrapper">
									<% IF (iTotCnt >= 0) Then %>
									<ul class="swiper-slide">
										<% For ix=0 To iTotCnt %>
										<li id="sid<%=ix%>" data="sid<%=ix%>" <% If pickitem1=cEventItem.FCategoryPrdList(ix).FItemID Then Response.write " class=""on on1""" %><% If pickitem2=cEventItem.FCategoryPrdList(ix).FItemID Then Response.write " class=""on on2""" %><% If pickitem3=cEventItem.FCategoryPrdList(ix).FItemID Then Response.write " class=""on on3""" %> onClick="fnItemInfoView(<%=cEventItem.FCategoryPrdList(ix).FItemID%>,'<%=ix%>');return false;"><img src="<% if Not(cEventItem.FCategoryPrdList(ix).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(ix).Ftentenimage400)) Then %><%=getThumbImgFromURL(cEventItem.FCategoryPrdList(ix).Ftentenimage400,"200","200","true","false") %><% Else %><%=getThumbImgFromURL(cEventItem.FCategoryPrdList(ix).FImageIcon1,"200","200","true","false")%><% End If %>" alt="" /><span></span></li> 
									<% If (ix=11 Or ix=23) And ix<>0 Then %>
									</ul>
									<ul class="swiper-slide">
									<% End If %>
										<% Next %>
									</ul>
									<% End If %>
								</div>
							</div>
							<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/btn_prev.png" alt="이전" /></button>
							<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/btn_next.png" alt="다음" /></button>
							<div class="pagination"></div>
						</div>
						<div class="ly-item"></div>
					</div>
					<form method="post" name="pickfrm">
					<input type="hidden" name="itemid1" id="itemid1">
					<input type="hidden" name="itemid2" id="itemid2">
					<input type="hidden" name="itemid3" id="itemid3">
					<input type="hidden" name="eCode" value="<%=eCode%>">
					<input type="hidden" name="evt_sub_code" value="<%=ItemGroup%>">
					<div class="picked-item">
						<div class="my-pick">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/tit_mypick<%=ItemGroupNum+1%>.png" alt="" /></h3>
							<ul class="items">
								<li id="spick1">
									<span class="thumbnail"></span>
								</li>
								<li id="spick2">
									<span class="thumbnail"></span>
								</li>
								<li id="spick3">
									<span class="thumbnail"></span>
								</li>
							</ul>
							<button class="submit" onClick="fnSubmitPick();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/btn_submit.png" alt="제출하기" /></button>
						</div>
						</form>
						<div class="real-rank">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/tit_real_rank.png" alt="실시간 순위" /></h3>
							<% if isApp=1 then %>
							<a href="javascript:fnAPPpopupCategory('<%=ItemGroupCate%>');" class="go-category">더 많은 상품 보러가기 ></a>
							<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%=ItemGroupCate%>" class="go-category">더 많은 상품 보러가기 ></a>
							<% End If %>
							<% IF (iTotCnt2 >= 0) Then %>
							<ul>
								<% For ix=0 To 2 %>
								<li>
									<% if isApp=1 then %>
									<a href="javascript:fnAPPpopupProduct('<%=cEventItemTop.FCategoryPrdList(ix).FItemID%>');">
									<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=<%=cEventItemTop.FCategoryPrdList(ix).FItemID%>">
									<% End If %>
										<span class="rank"><strong><%=ix+1%></strong>위</span>
										<span class="thumbnail"><img src="<% if Not(cEventItemTop.FCategoryPrdList(ix).Ftentenimage400="" Or isnull(cEventItemTop.FCategoryPrdList(ix).Ftentenimage400)) Then %><%=getThumbImgFromURL(cEventItemTop.FCategoryPrdList(ix).Ftentenimage400,"110","110","true","false")%><% Else %><%=getThumbImgFromURL(cEventItemTop.FCategoryPrdList(ix).FImageIcon1,"110","110","true","false")%><% End If %>" alt="<%=cEventItemTop.FCategoryPrdList(ix).FItemName%>" alt="<%=ix+1%>위 상품" /></span>
									</a>
								</li>
								<% Next %>
							</ul>
							<% End If %>
						</div>
					</div>

					<!-- 유의사항 -->
					<div class="noti">
						<h3>이벤트 유의사항</h3>
						<ul>
							<li>- 본 이벤트는 텐바이텐 회원님을 위한 혜택입니다.</br >(비회원 증정 불가)</li>
							<li>- ID당 하루에 한 번씩만 참여 가능합니다.</li>
							<li>- 참여 마일리지는 10월 27일(금)에 일괄지급될 예정입니다.</li>
						</ul>
					</div>
					<!-- 공유하기 -->
					<div class="share">
						<div class="inner">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/tit_share.png" alt="1년에 한번 있는 텐바이텐 쑈! 친구와 함께하쑈~!" /></p>
							<div class="btn-group">
								<a href="#" onClick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_fb_v2.png" alt="페이스북으로 텐쑈 공유하기" /></a>
								<% if isApp=1 then %>
								<a href="#" onClick="return false;" id="kakaoa"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_kakao.png" alt="카카오톡으로 텐쑈 공유하기" /></a>
								<script>
									//카카오 SNS 공유
							<%
								'// 아이폰 1.998, 안드로이드 1.92 이상부터는 카카오링크 APPID 변경 (2017.07.12; 허진원)
								if (flgDevice="I" and vAdrVer>="1.998") or (flgDevice="A" and vAdrVer>="1.92") then
							%>
									Kakao.init('b4e7e01a2ade8ecedc5c6944941ffbd4');
							<%	else %>
									Kakao.init('c967f6e67b0492478080bcf386390fdd');
							<%	end if %>

									// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
									Kakao.Link.createTalkLinkButton({
									  //1000자 이상일경우 , 1000자까지만 전송 
									  //메시지에 표시할 라벨
									  container: '#kakaoa',
									  label: '<%=vTitle%>',
									  <% if snpImg <>"" then %>
									  image: {
										//500kb 이하 이미지만 표시됨
										src: 'http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_sub2.jpg',
										width: '200',
										height: '200'
									  },
									  <% end if %>
									  appButton: {
										text: '10X10 앱으로 이동',
										webUrl : '<%=vLink%>',
										execParams :{
											android : {"url":"<%=Server.URLEncode(vAppLink)%>"},
											iphone : {"url":"<%=vAppLink%>"}
										}
									  }
									  //,
									  //installTalk : true
									});
								</script>
								<% Else %>
								<a href="javascript:tnKakaoLink('<%=vTitle%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_kakao.png" alt="카카오톡으로 텐쑈 공유하기" /></a>
								<% End If %>
								<a href="javascript:sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_pinterest.png" alt="핀터레스트로 텐쑈 공유하기" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<ul>
				<li>
					<a href="/event/16th/together.asp" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/bnr_together.jpg" alt="함께하쑈" /></a>
					<a href="#" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appcom/wish/web2014/event/16th/together.asp'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/bnr_together.jpg" alt="함께하쑈" /></a>
				</li>
				<li>
					<a href="/event/16th/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/bnr_main.jpg" alt="텐쑈 메인" /></a>
					<a href="#" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appcom/wish/web2014/event/16th/'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/bnr_main.jpg" alt="텐쑈 메인" /></a>
				</li>
			</ul>
<!-- #include virtual="/lib/db/dbclose.asp" -->