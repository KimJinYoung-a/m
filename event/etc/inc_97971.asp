<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 롯데뮤지엄 스누피 전시 이벤트 
' History : 2019-10-14 원승현 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim evtStartDate, evtEndDate, currentDate, oExhibition
Dim mastercode, listType, bestItemList
dim totalPrice , salePercentString , couponPercentString , totalSalePercent '// 할인율 관련
	currentDate =  date()

    evtStartDate = Cdate("2019-10-14")
    evtEndDate = Cdate("2019-12-31")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90413
    mastercode =  9
Else
	eCode   =  97971
    mastercode =  12
End If


dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page	= getNumeric(requestCheckVar(Request("page"),10))

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 5		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if
'iCPageSize = 1

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

'// 전체 유저 참여수(unique user)
Dim strSql, uniqueUserCnt
strSql = " SELECT COUNT(DISTINCT userid) as userCnt FROM db_event.dbo.tbl_event_comment WITH(NOLOCK) WHERE evtcom_using='Y' AND evt_code='"&eCode&"' "
rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
uniqueUserCnt = rsget("userCnt")
rsget.close

'// 가운데 상품 리스트
listType = "A"
SET oExhibition = new ExhibitionCls
bestItemList = oExhibition.getItemsListProc( listType, 8, mastercode, "", "1", "" )     '리스트타입, row개수, 마스터코드, 디테일코드, best아이템 구분, 카테고리 정렬 구분 
%>
<style type="text/css">
.mEvt97971 {background-color:#fff;}
.mEvt97971 button {background-color:transparent;}

.snoopy-top {position:relative;}
.snoopy-top h2 {position:absolute; top:2.65rem; left:50%; width:32rem; margin-left:-16rem; text-align:center;}
.snoopy-top h2 .t2 {margin:1.28rem 0;}
.snoopy-top h2 span {position:relative; top:-3rem; z-index:10; display:inline-block; opacity:0; transition:all .5s;}
.snoopy-top i {opacity:0; transition:all .8s .6s;}
.snoopy-top.on h2 span {top:0; opacity:1;}
.snoopy-top.on h2 .t2 {transition-delay:.2s;}
.snoopy-top.on h2 .t3 {transition-delay:.4s;}
.snoopy-top.on i {opacity:1;}

.collabo {position:relative;}
.collabo:after {display:inline-block;position:absolute; bottom:-2.6rem; left:6.6%; z-index:10; width:1.37rem; height:2.6rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/bg_collabo.png) no-repeat 0 0/100%; content:'';}

.space-art {position:relative; background-color:#ededed;}
.space-art .inner {position:relative; width:32rem; margin:0 auto;}
.space-art .top {overflow:hidden; position:relative; height:48.3rem; background:#ededed url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/bg_sky.jpg) no-repeat 50% 0/100%;}
.space-art .top:after {position:absolute; bottom:0; left:0; width:100%; height:22.61rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/bg_planet.png?v=1.01) no-repeat 50% 0/100%; content:'';}
.space-art .top h3 {position:relative; z-index:10; width:48.93%; margin:0 auto; padding:5.55rem 0 1.96rem;}
.space-art .top .dc {display:inline-block; position:absolute; left:50%;}
.space-art .top .dc1 {width:25.6%; top:0rem; margin-left:-11.73rem;}
.space-art .top .dc2 {width:15.87%; top:9.15rem; margin-left:12.8rem;}
.space-art .top .dc3 {width:8.13%; top:16.49rem; margin-left:-14rem;}
.space-art .top .dc4 {width:22.4%; top:21.06rem; margin-left:6.61rem;}
.space-art .top .dc5 {width:32.27%; top:27.05rem; margin-left:-23.56rem; animation:rocketMove 5.3s .6s infinite linear;}
.space-art .top .dc6 {width:33.87%; top:84.95%; margin-left:-47.46%; z-index:15;}
.space-art .top .dc7 {width:19.47%; top:86.19%; margin-left:24.67%; z-index:15;}
@keyframes rocketMove {
    0% {transform:translate(0,0)}
    40% {transform:translate(350%, -430%);}
    40.001% {transform:translate(600%, -200%) rotate(-140deg);}
    99.999% {transform:translate(-400%, -200%) rotate(-140deg);}
    100% {transform:translate(0, 0) rotate(0);}
}

.main-items {position:relative; z-index:10; display:flex; align-items:center; width:100%; padding-bottom:5.25rem;}
.main-items a {display:inline-block; position:absolute; top:0; width:50%; height:80%; text-indent:-999em;}
.main-items .main-item1 {left:0;}
.main-items .main-item2 {right:0;}
.main-items .item-name {position:absolute; bottom:2.96rem; left:50%; width:28.2rem; margin-left:-14.1rem;}

.character-items {position:relative; width:32rem; margin:0 auto;}
.character-items .swiper-slide {padding:0 1.9rem 5.55rem;}
.character-items ul {display:flex; flex-wrap:wrap; justify-content:space-between;}
.character-items ul li {overflow:hidden; position:relative; flex-basis:13.65rem; margin:.43rem 0; border-radius:.43rem; background-color:#fff;}
.character-items ul li em {overflow:hidden; display:inline-block; width:100%; height:13.65rem;}
.character-items ul li em img {height:100%;}
.character-items ul li span {display:inline-block; width:100%; color:#fff; font-size:1.19rem; text-align:center;}
.character-items .name {padding-top:1.28rem; font-weight:bold; background-color:#f88f21;}
.character-items .price {padding:.43rem 0 1.28rem; background-color:#f88f21;}
.character-items ul li:nth-child(2) .name, .character-items ul li:nth-child(2) .price,
.character-items ul li:nth-child(3) .name, .character-items ul li:nth-child(3) .price {background-color:#dc4630;}

.character-items .pagination {position:absolute; bottom:3.29rem; left:0; width:100%; height:.85rem; z-index:10; padding-top:0;}
.character-items .pagination .swiper-pagination-switch {width:.85rem; height:.85rem; margin:0 .43rem;}
.character-items .btn-nav {position:absolute; top:15.96rem; z-index:10; width:8.93%; height:7.04rem; background-size:100%; text-indent:-999em; background-color:transparent; background-repeat:no-repeat;}
.character-items .btn-prev {left:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/btn_prev.png?v=1.01);}
.character-items .btn-next {right:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/btn_next.png?v=1.01);}

.snpy-night {position:relative;}
.snpy-night h4 {position:absolute; top:6.61rem; left:0; text-align:center;}
.snpy-night h4 span {position:relative; display:inline-block; opacity:0; left:-100%; transition:all .5s;}
.snpy-night h4 b {overflow:hidden; position:relative; display:inline-block;}
.snpy-night h4 .t2 {top:-1.08rem; transition-delay:.2s;}
.snpy-night h4 .t3 {top:-4.55rem; transition-delay:.75s;}
.snpy-night h4 .dc1, .snpy-night h4 .dc2 {top:-2.26rem; width:68.93%; opacity:0; transition:all .3s .6s;}
.snpy-night h4 .dc2 {top:-3.87rem; transition-delay:.65s;}
.snpy-night h4 .dc3 {position:absolute; top:-1.28rem; left:-30%; width:20.6%; transition:all 1.5s .9s;}

.snpy-night.on span {opacity:1; left:0;}
.snpy-night.on h4 b {opacity:1;}
.snpy-night.on h4 .dc3 {left:60.67%; animation:bounce 1s infinite linear;}
@keyframes bounce {
	0%, 100% {transform:translateY(0);}
	50% {transform:translateY(1.5rem);}
}

.cmt-evt {background-color:#fed600;}
.cmt-evt .select-char {display:flex; justify-content:center; padding:0 1.1rem}
.cmt-evt .select-char .char {padding:0 .5rem;}
.cmt-evt .select-char .char input {position:absolute; top:0; left:0; width:0; height:0; visibility:hidden;}
.cmt-evt .select-char .char label {display:flex; flex-direction:column; justify-content:space-between; height:100%; cursor:pointer;}
.cmt-evt .select-char .char label i {display:inline-block; width:100%; height:1.71rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_select.png)no-repeat 50% 0/auto 200%; content:'';}
.cmt-evt .select-char .char input:checked + label i {background-position:50% 100%;}

.write-cont {overflow:hidden; position:relative; display:flex; align-items:center; width:100%; height:8.23rem; margin:2.13rem 0 1.02rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/bg_input.png)no-repeat 50% 0/100% 100%; content:'';}
.write-cont textarea {width:77.33%; padding:0 4.5% 0 10.5%; border:0; background-color:transparent; font-size:1rem; line-height:1.67; color:#000; font-weight:bold; letter-spacing:-.1rem;}
.write-cont textarea::-webkit-input-placeholder {color:#000;}
.write-cont textarea::-moz-placeholder {color:#000;}
.write-cont textarea:-ms-input-placeholder {color:#000;}
.write-cont textarea:-moz-placeholder {color:#000;}
.write-cont .btn-submit {width:4.01rem; height:4.31rem; background:transparent url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/btn_submit.png)no-repeat 50% 0/100% 100%; text-indent:-999em;}
.caution {padding:0 5.6%; margin-top:1.02rem; color:#875f00; font-size:1.02rem; line-height:1.2; letter-spacing:-.07rem;}

.cmt-list {padding-bottom:3.41rem; background-color:#fed600;}
.cmt-list ul {width:32rem; margin:0 auto;}
.cmt-list ul li {position:relative; width:100%; height:10.58rem; padding:3rem 10% 0 29.6%; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/bg_reply.png)no-repeat 50% 100%/100% auto;}
.cmt-list ul li .info {display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem; font-size:1.01rem; font-weight:bold;}
.cmt-list ul li .info .delete {display:inline-block; margin-right:.85rem; font-size:1.01rem; font-weight:bold; color:#cb2c38; line-height:1;}
.cmt-list ul li .info .date {font-weight:normal;}
.cmt-list ul li .char {display:inline-block; position:absolute; top:.85rem; left:10.67%; width:4.52rem; height:8.53rem; background-repeat:no-repeat; background-position:50% 100%; background-size:100%;}
.cmt-list ul li .char1 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char1.png)}
.cmt-list ul li .char2 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char2.png)}
.cmt-list ul li .char3 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char3.png)}
.cmt-list ul li .char4 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char4.png)}
.cmt-list ul li .char5 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char5.png)}
.cmt-list ul li .conts {overflow:hidden; display:flex; align-items:center; height:5.67rem; font-size:1.02rem; line-height:1.67; font-weight:bold; word-break:break-all; letter-spacing:-.05rem;}
</style>

<script type="text/javascript">
$(function () {

    rolling1 = new Swiper(".rolling .swiper-container",{
        loop:true,
        autoplay:3000,
        speed:1200,
        pagination:".rolling .pagination",
        paginationClickable:true,
		nextButton:'.btn-next',
		prevButton:'.btn-prev'
    });

    // parallax
	$(window).scroll(function() {
		var st=$(this).scrollTop();
		var taOfs=$('.space-art').offset().top;
		var calc=taOfs-st*.94
		if(st>taOfs-window.innerHeight&& taOfs+$('.space-art').innerHeight()>st){
			$('.space-art .dc1').css({'transform':'translateY('+calc*.3+'%)'});
			$('.space-art .dc2').css({'transform':'translateY('+calc*.3+'%)'});
			$('.space-art .dc3').css({'transform':'translateY('+calc*.2+'%)'});
			$('.space-art .dc4').css({'transform':'translateY('+calc*.3+'%)'});
		}
	});

    // animation
    $('.snoopy-top').addClass('on');
    $(window).scroll(function() {
        var st=$(this).scrollTop();
        var winH=window.innerHeight;
        $('.animove').each(function(){
            var innerH=$(this).innerHeight()
            var ofs=$(this).offset().top;
            if(st>ofs-winH && ofs+ innerH>st){$(this).addClass('on')}
           // else{$(this).removeClass('on')}
        })
    })

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
    <% end if %>

    $('input[name=char]').click(function(){	        
        $("#spoint").val($(this).val())
    })       
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".cmt-list").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( currentDate >= evtStartDate and currentDate <= evtEndDate ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
            if(frm.txtcomm1.value == ""){
                alert('내용을 넣어주세요')
                frm.txtcomm1.focus()
                return false;
            }            
            frm.txtcomm.value = frm.txtcomm1.value
            frm.action = "/event/lib/doEventComment.asp";
            frm.submit();
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}
}
function fnChkByte(obj) {
    var maxByte = 80; //최대 입력 바이트 수
    var str = obj.value;
    var str_len = str.length;
 
    var rbyte = 0;
    var rlen = 0;
    var one_char = "";
    var str2 = "";
 
    for (var i = 0; i < str_len; i++) {
        one_char = str.charAt(i);
 
        if (escape(one_char).length > 4) {
            rbyte += 2; //한글2Byte
        } else {
            rbyte++; //영문 등 나머지 1Byte
        }
 
        if (rbyte <= maxByte) {
            rlen = i + 1; //return할 문자열 갯수
        }
    }    
 
    if (rbyte > maxByte) {
        alert("한글 "+ (maxByte / 2) +"자 이내로 작성 가능합니다.");
        str2 = str.substr(0, rlen); //문자열 자르기
        obj.value = str2;
        fnChkByte(obj, maxByte);
    } else {
        //document.getElementById('byteInfo').innerText = Math.ceil(rbyte / 2);
    }
}
</script>

<div class="mEvt97971">
    <div class="snoopy-top">
        <h2>
            <span class="t1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/tit_snoopy1.png" alt="To the Moon  with Snoopy"></span>
            <span class="t2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/txt_sub.png" alt="스누피 달 착륙 50주년 기념 한국 특별전"></span>
            <span class="t3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/txt_date.png" alt="2019. 10. 17 THU - 2020. 3. 1 SUN"></span>
        </h2>
        <i><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/bg_tit.png" alt=""></i>
        <% If isapp="1" Then %>
            <a href="" class="museum mApp" onclick="fnAPPpopupExternalBrowser('https://www.lottemuseum.com/Mobile'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/txt_museum.png" alt="전시 자세히 보러가기" /></a>
        <% Else %>
            <a href="https://www.lottemuseum.com/Mobile" class="museum mWeb" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/txt_museum.png" alt="전시 자세히 보러가기" /></a>
        <% End If %>
    </div>
    <div class="collabo"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/txt_collabo.png?v=1.01" alt="To the Moon with Snoopy의 공식 MD는 텐바이텐과 함께 합니다."></div>
    <div class="space-art">
        <div class="top">
            <div class="inner">
                <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/tit_collection.png" alt="To the Moon  with Snoopy"></h3>
                <div class="main-items">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_dolls.png" alt="To the Moon with Snoopy의 공식 MD는 텐바이텐과 함께 합니다.">
                    <span class="item-name"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/txt_itemname.png?v=1.01" alt="스누피 & 찰리브라운 인형 25cm"></span>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2535148');return false;" class="main-item1">찰리브라운</a>
                        <a href="" onclick="TnGotoProduct('2535141');return false;" class="main-item2">스누피</a>
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2535148&pEtr=97971" class="main-item1">찰리브라운</a>
                        <a href="/category/category_itemPrd.asp?itemid=2535141&pEtr=97971" class="main-item2">스누피</a>
                    <% End If %>
                </div>
                <div class="deco">
                    <span class="dc dc1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_planet1.png" alt=""></span>
                    <span class="dc dc2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_planet2.png" alt=""></span>
                    <span class="dc dc3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_planet3.png" alt=""></span>
                    <span class="dc dc4"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_planet4.png" alt=""></span>
                    <span class="dc dc5"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_rocket.png" alt=""></span>
                    <span class="dc dc6"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_hole1.png" alt=""></span>
                    <span class="dc dc7"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_hole2.png" alt=""></span>
                </div>
            </div>
        </div>
        <div class="character-items rolling">
            <% if Ubound(bestItemList) > 0 then %>
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <% for i = 0 to Ubound(bestItemList) - 1 %>
                            <% call bestItemList(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent) %>
                            <% If i = 0 Then %>
                                <div class="swiper-slide">
                                    <ul>
                            <% End If %>
                                <li>
                                    <% If isapp="1" Then %>
                                        <a href="" onclick="TnGotoProduct('<%=bestItemList(i).Fitemid%>');return false;">
                                    <% Else %>
                                        <a href="/category/category_itemPrd.asp?itemid=<%=bestItemList(i).Fitemid%>&pEtr=97971" class="main-item1">
                                    <% End If %>
                                        <em class="thumbnail">
                                            <% If Trim(bestItemList(i).FTentenImg400) <> "" Then %>
                                                <img src="<%=bestItemList(i).FTentenImg400%>" alt="<%=bestItemList(i).FAddtext1%>" />
                                            <% Else %>
                                                <img src="<%=bestItemList(i).FBasicimage%>" alt="<%=bestItemList(i).FAddtext1%>" />
                                            <% End If %>                                                                        
                                        </em>
                                        <span class="name">
                                            <% 
                                                If Trim(bestItemList(i).FAddtext1) <> "" Then 
                                                    Response.Write bestItemList(i).FAddtext1
                                                Else
                                                    Response.Write bestItemList(i).Fitemname
                                                End If
                                            %>                                        
                                        </span>
                                        <span class="price"><%=formatNumber(totalPrice, 0)%>원</span>
                                    </a>
                                </li>
                            <% If i = Ubound(bestItemList) - 1 Then %>
                                    </ul>
                                </div>
                            <% ElseIf (i+1) mod 4 = 0 Then %>
                                    </ul>
                                </div>
                                <div class="swiper-slide">
                                    <ul>                        
                            <% End If %>
                        <% Next %>
                    </div>
                </div>
                <div class="pagination"></div>
                <button type="button" class="btn-nav btn-prev">이전</button>
                <button type="button" class="btn-nav btn-next">다음</button>
            <% End If %>
        </div>
    </div>
    <div class="snpy-night animove">
        <h4>
            <span class="t1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/tit_snoopy_night1.png" alt="특별한 당신에게"></span>
            <span class="t2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/tit_snoopy_night2.png" alt="snoopy night"></span>
            <b class="dc1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/tit_snoopy_night4.png" alt=""></b>
            <b class="dc2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/tit_snoopy_night5.png" alt=""></b>
            <span class="t3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/tit_snoopy_night3.png?v=1.02" alt="11월 1일(금) 저녁 7시 오직 40명을 위해 PRIVATE전시가 열립니다"></span>
            <b class="dc3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/img_snoopy.png" alt=""></b>
        </h4>
        <i><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/bg_snoopy_night.png" alt=""></i>
        <div class="cmt-evt">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/txt_cmt_evt.png" alt="좋아하는 친구를 선택하고 전시 기대평을 남겨주세요. 1인 2매 증정!"></p>
            <div class="select-char">
                <div class="char"><input type="radio" id="char1" name="char" checked value="1" /><label for="char1"><i></i><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char1.png" alt="" /></label></div>
                <div class="char"><input type="radio" id="char2" name="char" value="2" /><label for="char2"><i></i><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char2.png" alt="" /></label></div>
                <div class="char"><input type="radio" id="char3" name="char" value="3" /><label for="char3"><i></i><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char3.png" alt="" /></label></div>
                <div class="char"><input type="radio" id="char4" name="char" value="4" /><label for="char4"><i></i><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char4.png" alt="" /></label></div>
                <div class="char"><input type="radio" id="char5" name="char" value="5" /><label for="char5"><i></i><img src="//webimage.10x10.co.kr/fixevent/event/2019/97971/m/ico_char5.png" alt="" /></label></div>
            </div>
            <form name="frmcom" method="post" onSubmit="return false;">
                <input type="hidden" name="mode" value="add">
                <input type="hidden" name="pagereload" value="ON">
                <input type="hidden" name="iCC" value="1">
                <input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
                <input type="hidden" name="eventid" value="<%= eCode %>">
                <input type="hidden" name="linkevt" value="<%= eCode %>">
                <input type="hidden" name="blnB" value="<%= blnBlogURL %>">
                <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
                <input type="hidden" id="spoint" name="spoint" value="1">
                <input type="hidden" name="txtcomm">
                <input type="hidden" name="isApp" value="<%= isApp %>">            
                <div class="write-cont">
                    <textarea title="코멘트 작성" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="fnChkByte(this);" cols="60" rows="2" placeholder="최대 40글자까지 입력 가능합니다." maxlength="40"></textarea>
                    <button type="button" class="btn-submit" onclick="jsSubmitComment(document.frmcom);"><img src="" alt="입력하기" /></button>
                </div>
                <p class="caution">통신예절에 어긋나는 글은 관리자에 의해  사전 통보 없이 삭제될 수 있습니다.</p>
            </form>
            <form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
                <input type="hidden" name="mode" value="del">
                <input type="hidden" name="pagereload" value="ON">
                <input type="hidden" name="Cidx" value="">
                <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
                <input type="hidden" name="eventid" value="<%= eCode %>">
                <input type="hidden" name="linkevt" value="<%= eCode %>">
                <input type="hidden" name="isApp" value="<%= isApp %>">
            </form>                
        </div>

        <%' for dev msg 선택한 캐릭터에 따라 [char1 ~ char5] 클래스 추가 // 5개씩 노출 %>
        <div class="cmt-list">
            <% IF isArray(arrCList) THEN %>
                <ul>
                    <% 
                        dim tmpImgCode
                        For intCLoop = 0 To UBound(arrCList,2) 

                        tmpImgCode = Format00(1, arrCList(3,intCLoop))
                    %>                
                        <li>
                            <div class="info">
                                <span class="user"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
                                <p>
                                    <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                                        <button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">[삭제]</button>
                                    <% End If %>
                                    <span class="date"><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span>
                                </p>
                            </div>
                            <span class="char char<%=tmpImgCode%>"></span>
                            <div class="conts"><span><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></span></div>
                        </li>
                    <%
                        next
                    %>
                </ul>
                <% If isArray(arrCList) Then %>
                <%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
                <% End If %>
            <% End If %>
        </div>
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->