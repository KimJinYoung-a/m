<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
dim currentdate
	currentdate = date()
	'currentdate = "2019-04-04"
	'response.write currentdate
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'####################################################
' Description : 세라벨 메인
' History : 2019-03-28 최종원
'####################################################
'If eventid = "" Then '// 이메일용
'	Response.Redirect "http://m.10x10.co.kr/event/eventmain.asp?eventid=85144"
'	REsponse.End
'End If
strHeadTitleName = "이벤트"
dim userid, vQuery

Dim cPopular, vDisp, vSort, vCurrPage, i, j, vArrEval, gnbflag
vDisp = RequestCheckVar(Request("disp"),18)
vSort = requestCheckVar(request("sort"),12)
vCurrPage = RequestCheckVar(Request("cpg"),5)
gnbflag = RequestCheckVar(Request("gnbflag"),5)

If vCurrPage = "" Then vCurrPage = 1

If vSort = "" Then vSort = "3"

dim couponIdx

IF application("Svr_Info") = "Dev" THEN
    couponIdx = "22171,22172,22173,22174"     
Else
    couponIdx = "40091,40090,40089,40088"     
End If

Dim iscouponeDown
iscouponeDown = false
vQuery = "select count(1) from [db_item].[dbo].[tbl_user_item_coupon] where userid = '" & getencLoginUserid() & "'"
vQuery = vQuery + " and itemcouponidx in ("&couponIdx&") "
vQuery = vQuery + " and usedyn = 'N' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
If rsget(0) = 4 Then
	iscouponeDown = true
End IF

dim myWishArr, sqlStr, objCmd , vRs	

if userid <> "" then
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "SELECT itemid from db_my10x10.dbo.tbl_myfavorite where userid = ? "
		.Prepared = true
		.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(userid), userid)
		SET vRs = objCmd.Execute
			if not vRs.EOF then
				myWishArr = vRs.getRows()
			end if
		SET vRs = nothing
	End With
	Set objCmd = Nothing
end if
%>
<style type="text/css">
#lyrCoupon {display:none; position:fixed; left:0; top:50%; z-index:999; transform:translateY(-50%);}
#lyrCoupon .btn-go {position:absolute; left:0; bottom:14.19%; width:100%; background:transparent;}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:100; width:100%; height:100%; background:rgba(0,0,0,.60);}

.salabal-main {position:relative; background:#f6d4c2 url(//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/bg_orange.png) 0 0;}
.salabal-main button {width:100%;}

.topic {overflow:hidden; position:relative;}
.topic i {display:inline-block; position:absolute; top:18.84%; left:19.73%; width:61.06%;}

.section > div {position:relative;}
.section > div h3 {position:relative; z-index:10;}
.section > div a > span {display:inline-block; position:absolute; z-index:15;}
.section .hundred  {position:relative; background:url(//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/bg_orange.png);}
.section .hundred span {display:inline-block; position:absolute; top:0; left:50%; z-index:5; width:82.13%; margin-left:-41.07%;}
.section .relay {position:relative;}
.section .relay span {top:5%; left:2.6%; width:32.9%; animation:bounce .7s 1000 ease-in-out;}
.section .relay em {overflow:hidden; display:inline-block; position:absolute; bottom:11.4%; left:8.7%; right:8.7%; z-index:15; height:18.75%;}
.section .relay em.open b {display:inline-block; position:absolute; top:0; left:0; width:60.98rem; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_stuff.png) repeat-x 50% 100%; background-size:100%; animation:slideLeft 8s infinite linear; animation-direction:alternate;}
.section .relay em.open:after {display:inline-block; position:absolute; bottom:8%; left:28.53%; width:20.19%; height:78.98%; background:url(//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_calc.png) no-repeat 50% 50%; background-size:100%; animation:none; content:'';}
.section .salabal-prj li {position:relative;}
.section .salabal-prj li span {position:absolute; left:14.67%; bottom:16.28%; color:#fff949; font-size:2rem; font-weight:bold;}
.section .salabal-prj li:nth-child(3) span {bottom:44.69%;}
.section .salabal-prj .pagination {position:absolute; bottom:7.9%; left:0; z-index:10; width:100%; text-align:center;}
.section .salabal-prj .pagination.disabled {opacity:0;}
.section .salabal-prj .pagination .swiper-pagination-switch {width:.85rem; height:.85rem; margin:0 .45rem; background-color:rgba(255,255,255,.5); border-radius:50%;}
.section .salabal-prj .pagination .swiper-active-switch {background-color:rgba(255,255,255,1);}
.section .scratch span {display:inline-block; position:absolute; width:61.2%; top:22.8%; left:31.2%; animation:swing .9s 1000 ease-in;  transform-origin:70% 60%;}
.section .prosale span {display:inline-block; position:absolute; top:13.32%; left:20.6%; z-index:15; width:62.8%;}
.section .quater-winner {padding-top:2%; background:#f6d4c2 url(//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/bg_orange2.png) 0 0;}
.section .quater-winner span {top:-4.4%; left:8.8%; width:26.67%; animation:swing2 .9s 1000 ease-in; transform-origin:44% 100%;}
.section .quater-winner em {display:inline-block; position:absolute; top:-2.3%; left:19.3%; z-index:16; width:23.46%;  animation:bounce 1.2s 1000 ease-in-out;}
.section .quater-winner em.item2 {top:10.88%; left:61.47%; width:25.6%; animation-delay:-.3s;}
.section .quater-winner em.item3 {top:24.3%; left:7.3%; width:20.93%; animation-delay:-.5s;}
.section .best span {top:0; left:0; z-index:15;}

.wish-items {padding:1.71rem 0 5rem; background-color:#f4f4f4;}
.wish-items > p {margin-bottom:1.28rem;}
.wish-items > ul {/*margin:0 1.28rem;*/ width:29.44rem; margin:0 auto; padding-bottom:1.28rem;}
.wish-items > ul:after {display:block; clear:both; content:'';}
.wish-items > ul > li {float:left; width:calc(50% - .64rem); margin-top:1.28rem; background-color:#fff; border-radius:.43rem; box-shadow:.43rem .43rem 1.28rem 0 rgba(0, 0, 0, 0.1);}
.wish-items > ul > li:before {clear:both; content:'';}
.wish-items > ul > li:first-child {margin-top:0;}
.wish-items > ul > li:nth-child(5n-4) {width:100%;}
.wish-items > ul > li:nth-child(5n-4) .thumbnail {height:29.44rem;}
.wish-items > ul > li:nth-child(5n-3), .wish-items > ul > li:nth-child(5n-1) {margin-right:.64rem;}
.wish-items > ul > li:nth-child(5n-2), .wish-items > ul > li:nth-child(5n) {margin-left:.64rem;}
.wish-items .thumbnail {width:100%; height:14.08rem;}
.wish-items .thumbnail img {width:100%; height:100%;}
.wish-items .thumbnail:after {display:Inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background-color:rgba(0,0,0,.02); content:'';}
.wish-items .desc {position:relative; padding-left:.43rem; margin:0 1.28rem 0 .85rem;}
.wish-items .desc .name {overflow:hidden; display:inline-block; width:100%; padding-top:3.41rem; font:1.19rem/1.38 'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; white-space:nowrap;overflow:hidden; text-overflow:ellipsis; }
.wish-items .desc .price {margin:.51rem 0 2.1rem; font-size:1.19rem;}
.wish-items .desc .price .discount {margin-right:.4rem; font-weight:600;}
.wish-items .btn-wish {position:absolute; top:-2.13rem; right:0; z-index:15; width:4.27rem; height:4.27rem; background-color:#fff; border-radius:50%; color:#999; font-size:.94rem; line-height:1.36;}
.wish-items .btn-wish i {display:inline-block; width:1.71rem; height:1.71rem; position:absolute; top:1.35rem; left:50%; margin-left:-.86rem; background-image:url(//fiximage.10x10.co.kr/m/2019/common/ico_heart.png?v=1.02); background-position:0 0; background-size:1.71rem auto;}
.wish-items .btn-wish.on i {background-position:0 100%; animation:scale .4s forwards;}
.wish-items .btn-wish span {position:relative; top:1.8rem;}
.wish-items .btn-more {padding:.85rem 0 5.25rem; background-color:#f4f4f4;}

<% If trim(gnbflag)="1" Then %>
	<% If isapp="1" Then %>
		.bnr-sns {display:flex; align-items:center; overflow:hidden; position:fixed; bottom:2.45rem; left:-10.3rem; z-index:30; height:3.84rem; padding:0 1.28rem 0 1.71rem; border-radius:0 2.05rem 2.05rem 0; background-color:rgba(132, 255, 116, .9); transition:all .5s;}
	<% Else %>
		.bnr-sns {display:flex; align-items:center; overflow:hidden; position:fixed; bottom:6.45rem; left:-10.3rem; z-index:30; height:3.84rem; padding:0 1.28rem 0 1.71rem; border-radius:0 2.05rem 2.05rem 0; background-color:rgba(132, 255, 116, .9); transition:all .5s;}
	<% End If %>
<% Else %>
	.bnr-sns {display:flex; align-items:center; overflow:hidden; position:fixed; bottom:2.45rem; left:-10.3rem; z-index:30; height:3.84rem; padding:0 1.28rem 0 1.71rem; border-radius:0 2.05rem 2.05rem 0; background-color:rgba(132, 255, 116, .9); transition:all .5s;}
<% End If %>
.bnr-sns em {overflow:hidden; display:inline-block; position:relative; top:.1rem; left:-15rem; width:auto; margin-right:1.28rem; color:#ff3838; font:1.19rem/1 'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; transition:all .5s;}
.bnr-sns span {display:inline-block; width:2.56rem;}
.bnr-sns span.fb {margin-right:.64rem;}
.bnr-sns.on {left:0; transition:all .5s;}
.bnr-sns.on em {left:0; transition:all .5s;}

.zoom {animation:zoom 2.5s 1000 forwards; transform-origin:50% 45%;}
@keyframes bounce{
	from,to {transform:translateY(-7px);}
	50% {transform:translateY(7px);}
}
@keyframes swing{
	from,to {transform:rotate(-1deg);}
	50% {transform:rotate(1deg);}
}
@keyframes swing2{
	from,to {transform:rotate(-15deg);}
	50% {transform:rotate(0deg);}
}
@keyframes zoom {
	from {transform:scale(1);}
	45% {transform:scale(0);}
	to {transform:scale(0);}
}
@keyframes slideLeft {
	from {transform:translateX(0);}
	to {transform:translateX(-50%);}
}
</style>
<script type="text/javascript" src="/lib/js/jquery.masonry.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
var isloading=true;
var myWish = ''

<%
if isArray(myWishArr) then
	for i=0 to uBound(myWishArr,2) 
	%>
	myWish = myWish + '<%=myWishArr(0,i)%>,'
	<%
	next
end if
%>
function getSaleInfo(){
    var evtcodes = ""
    var $evtEl = $(".evt-sale-info");
    var numOfEvt = $evtEl.length;
    // console.log(numOfEvt)
    $evtEl.each(function(){
        var tmpCode = $(this).attr("evtcode");
        evtcodes += tmpCode != "" ? tmpCode + "," : ""                 
    })    
    evtcodes = numOfEvt > 0 ? evtcodes.substr(0, evtcodes.length - 1) : "";
    // console.log(evtcodes)

    $.ajax({			
        type: "get",
        url: "/event/salelife/evtSaleAjax.asp",
        data: "evtArr="+evtcodes,
        cache: false,
        success: function(message) {            
            var items = message.items
            // console.log(items)
            $evtEl.each(function(idx, item){                
                for(var i = 0 ; i < items.length ; i ++){
                    if($(this).attr("evtcode") == items[i].evtCode){
                        $(this).html("~" + items[i].salePer + "%")
                    }
                }                
            })
        },
        error: function(err) {
            console.log(err.responseText);
        }
    });
    
}
$(function(){
	//scroll
	fnAmplitudeEventMultiPropertiesAction('view_2019salelife_main','','');
	$(".bnr-sns").addClass('on');
    $(window).scroll(function(){
		<% If gnbflag = "1" Then %>
        	var nowPos = $(this).scrollTop()-200;
		<% Else %>
			var nowPos = $(this).scrollTop();
		<% End If %>
        var topPos = $(".salabal-main").offset().top;
        if (topPos < nowPos) {
            $(".bnr-sns").removeClass('on');
        } else {
            $(".bnr-sns").addClass('on');
        }
	});
	salabalSwiper = new Swiper(".salabal-prj .swiper-container",{
		effect:'fade',
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:".salabal-prj .pagination",
		paginationClickable:true
	});
	if($(".salabal-prj .pagination span").length == 1) {
		$(".salabal-prj .pagination").addClass( "disabled" );
	}

	/*coupleSwiper = new Swiper(".couple-life .swiper-container",{
		effect:'fade',
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:".couple-life .pagination",
		paginationClickable:true
	});*/
    getList();
    getSaleInfo();
});
// 레이어닫기
function closeLy() {
	$('#lyrCoupon').fadeOut(200);
	$('#dimmed').fadeOut(300);
}
</script>

<script type="text/javascript">
function jsDownCoupon(stype,idx){
	fnAmplitudeEventMultiPropertiesAction('click_2019salelife_coupon','','');	
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(message.response=="Ok") {
                    $('#lyrCoupon').fadeIn(300);
					$('#dimmed').fadeIn(300);
					$('#couponImg').attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_coupon_done.png")					
				} else {
					alert(message.message);
				}
			} else {
				alert("처리중 오류가 발생했습니다.");
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
}

function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/salelife/index.asp")%>');
<% end if %>
	return;
}

function getList() {        
	var str = $.ajax({
			type: "GET",
	        url: "/event/salelife/act_salelife.asp",
	        data: $("#popularfrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;	
	if(str!="") {               
    	if($("#popularfrm input[name='cpg']").val()=="1") {
        	//내용 넣기                                  
        	$('#lySearchResult').html(str);			
        } else {            
       		$str = $(str)       		
       		$('#lySearchResult').append($str)   
        }
		isloading=false;
		chkMyWish()	
    } else {
    	//더이상 자료가 없다면 스크롤 이벤트 종료
    	$(window).unbind("scroll");
    }
}
function fnWishListMore(){    
	var pg = $("#popularfrm input[name='cpg']").val();    
	pg++;
	$("#popularfrm input[name='cpg']").val(pg);    
	setTimeout(getList(),500);
}
function TnAddFavoritePrd(iitemid){
<% if isapp = 1 then %>
    <% If IsUserLoginOK() Then %>        
        setTimeout(function(){
            fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3");
        }, 100);
    <% Else %>
        calllogin();
    <% End If %>
<% else %>
    <% If IsUserLoginOK() Then %>
        top.location.href="/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3";
    <% Else %>
        top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(CurrURLQ())%>";
    <% End If %>
<% end if %>
}
function chkMyWish(){	
    $('.item-list').each(function(index, item){
        if(myWish.indexOf($(this).attr("itemid")) > -1){
            $(this).find(".btn-wish").addClass("on")
        }        
    })
}
</script>
            <form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
                <input type="hidden" name="cpg" id="cpg" value="1" />
                <input type="hidden" name="disp" value="<%=vDisp%>" />
                <input type="hidden" name="sort" value="<%=vSort%>" />
            </form>                            
			<!-- 세라밸 : 메인 -->
			<div class="salabal-main">

				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/tit_salabal_v4.png" alt="세일페스티벌 라이프 밸런스"></h2>
					<i><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/tit_salabal_v4.gif" alt=""></i>
				</div>

				<div class="section">
					<div class="coupon">
                        <% If iscouponeDown Then %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_coupon_done_v3.png" alt="발급완료" />
                        <% Else %>
                            <button class="btn-coupon" onclick="jsDownCoupon('prd,prd,prd,prd','<%=couponIdx%>');return false;"><img id="couponImg" src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_coupon_v3.png" alt="쿠폰 받기" /></button>
                        <% End IF %>
					</div>
					<div id="lyrCoupon">
						<div onclick="closeLy();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_coupon_cont_v2.png" alt="쿠폰이 발급 되었습니다" /></div>
                        <% if isapp then %>
                            <a href="javascript:void(0)" onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp')" class="btn-go"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/btn_coupon.png" alt="쿠폰함으로 가기" /></a>
                        <% else %>
                            <a href="/my10x10/couponbook.asp" class="btn-go"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/btn_coupon.png" alt="쿠폰함으로 가기" /></a>                                                
                        <% end if %>                        
					</div>
					<!-- 100원의 기적 -->
					<div class="hundred">
					<% if isApp="1" then %>
						<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_100won','','', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '100원의 기적', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93355'); return false;}});">
					<% else %>
						<a href="/event/eventmain.asp?eventid=93354" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_100won','','');">
					<% end if %>
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/txt_hundred_v2.png" alt="100원의 기적 "></h3>
							<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_hundred_v5.gif" alt="100원의 기적 당첨 상품"></span>
						</a>
					</div>

					<!-- 앗싸 에어팟2 (릴레이) -->
					<div class="relay">
					<% if isApp="1" then %>
						<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_airpod2','','', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '앗싸 에어팟2', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93475'); return false;}});">
					<% else %>
						<a href="/event/eventmain.asp?eventid=93475" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_airpod2','','');">
					<% end if %>
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/tit_relay_v5.png?v=1.01" alt="앗싸~ 에어팟2 득템!"></h3>
							<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/ico_relay_v3.png" alt="SNS 참여 이벤트"></span>
							<em class="open">
								<b></b>
							</em>
						</a>
					</div>

					<!-- 세라밸 프로젝트 -->
					<div class="salabal-prj">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/tit_prj_sale_v3.png" alt="삶의 질 향상 아이템 추천!"></p>
						<div class="swiper-container">
							<div class="swiper-wrapper">

								<ul class="swiper-slide">
									<li>
									<% if isApp="1" then %>										
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','4', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93412'); return false;}});">
									<% else %>
										<a href="/event/eventmain.asp?eventid=93412" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','4');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_4_v3.jpg" alt="깔끔함의 끝,  정리정돈!">
											<span class="evt-sale-info" evtcode="93412">~0%</span>
										</a>
									</li>
									<li>
									<% if isApp="1" then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','5', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93413'); return false;}});">
									<% else %>
										<a href="/event/eventmain.asp?eventid=93413" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','5');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_5_v3.jpg" alt="집에서 즐기는  심야식당의 모든 것">
											<span class="evt-sale-info" evtcode="93413">~0%</span>
										</a>
									</li>
									<li>
									<% if isApp="1" then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','6', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93414'); return false;}});">
									<% else %>
										<a href="/event/eventmain.asp?eventid=93414" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','6');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_6_v3.jpg?v=1.01" alt="손 쉽게  부기빼는 방법">
											<span class="evt-sale-info" evtcode="93414">~0%</span>
										</a>
									</li>
								</ul>

								<ul class="swiper-slide">
									<li>
									<% if isApp="1" then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','4', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93415'); return false;}});">
									<% else %>
										<a href="/event/eventmain.asp?eventid=93415" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','7');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_7_v2.jpg" alt="하나를 샀는데,  두개를 얻은 기분">
											<span class="evt-sale-info" evtcode="93415">~0%</span>
										</a>
									</li>
									<li>
									<% if isApp="1" then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','5', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93416'); return false;}});">
									<% else %>
										<a href="/event/eventmain.asp?eventid=93416" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','8');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_8_v2.jpg" alt="우리 집 여백  활용백서">
											<span class="evt-sale-info" evtcode="93416">~0%</span>
										</a>
									</li>
									<li>
									<% if isApp="1" then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','6', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93417'); return false;}});">
									<% else %>
										<a href="/event/eventmain.asp?eventid=93417" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','9');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_9_v2.jpg?v=1.01" alt="하루를 기분좋게 마감하는 방법">
											<span class="evt-sale-info" evtcode="93417">~0%</span>
										</a>
									</li>
								</ul>

								<ul class="swiper-slide">
									<li>
									<% if isApp="1" then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','1', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93409'); return false;}});">										
									<% else %>
										<a href="/event/eventmain.asp?eventid=93409" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','1');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_1_v3.jpg" alt="프로자취러를 위한  모든 것">
											<span class="evt-sale-info" evtcode="93409">~0%</span>
										</a>
									</li>
									<li>
									<% if isApp="1" then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','2', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93410'); return false;}});">
									<% else %>
										<a href="/event/eventmain.asp?eventid=93410" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','2');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_2_v3.jpg" alt="직장생활의 완성은  데스크테리어!">
											<span class="evt-sale-info" evtcode="93410">~0%</span>
										</a>
									</li>
									<li>
									<% if isApp="1" then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','3', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '세라밸 프로젝트', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93411'); return false;}});">
									<% else %>
										<a href="/event/eventmain.asp?eventid=93411" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_project','idx','3');">
									<% end if %>
											<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_prj_sale_3_v3.jpg?v=1.01" alt="좋은 냄새 활용법">
											<span class="evt-sale-info" evtcode="93411">~0%</span>
										</a>
									</li>
								</ul>
							</div>
						</div>
						<div class="pagination"></div>
					</div>

					<!-- 스크래치 -->
					<div class="scratch">
						<% if isApp="1" then %>
							<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_event','evtname','스크래치기획전', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '스크래치전', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87066'); return false;}});">
						<% else %>
							<a href="/event/eventmain.asp?eventid=87066" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_event','evtname','스크래치기획전');"> 
						<% end if %>
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/tit_scratch_v3.png" alt="스크래치 가구展"></h3>
							<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_scratch_v3.png" alt=""></span>
						</a>
					</div>

					<!-- 1분기 결산템 -->
					<div class="quater-winner">
					<% if isApp="1" then %>
						<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_event','evtname','어서와 텐바이텐', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '어서와 텐바이텐', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91839'); return false;}});">
					<% else %>
						<a href="/event/eventmain.asp?eventid=91839" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_event','evtname','어서와 텐바이텐');">
					<% end if %>
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/tit_welcome.png" alt="텐바이텐처음이지?"></h3>
							<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/txt_welcome.png" alt="어서와"></span>
						</a>
					</div>

					<!-- 베스트셀러 -->
					<div class="best">
						<% if isApp="1" then %>
							<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2019salelife_event','evtname','베스트셀러', function(bool){if(bool) {fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '베스트셀러', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/award/awarditem.asp?gnbparam=1'); return false;}});">
						<% else %>
							<a href="/award/awarditem.asp" onclick="fnAmplitudeEventMultiPropertiesAction('click_2019salelife_event','evtname','베스트셀러');">
						<% end if %>
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/tit_best_v3.png" alt="베스트셀러"></h3>
							<span class="zoom"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_best_2_v3.png" alt=""></span>
							<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/img_best_1_v2.png" alt="삶의 질을 올려주는 베스트셀러를 소개합니다"></span>
						</a>
					</div>
				</div>

				<!-- 위시 -->
				<div class="wish-items">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/tit_wish_v3.jpg" alt="지금, 다른 사람들이 위시하는 상품을 실시간으로 만나보세요!"></p>
					<ul id="lySearchResult" class="wishList">
					</ul>
					<button class="btn-more" onclick="fnWishListMore()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/btn_more_v2.png" alt="상품더보기"></button>
				</div>

				<!-- sns 공유하기 -->
				<div class="bnr-sns" id="bnr-sns">
                    <em>친구들과 함께해요!</em>
                    <span class="fb"><a href="javascript:snschk('fb')" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/ico_facebook_v3.png" alt="페이스북으로 공유하기"></a></span>
                    <span class="kakao"><a href="javascript:snschk('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/index/m/ico_kakao_v3.png" alt="카카오로 공유하기"></a></span>
				</div>

				<div id="dimmed" onclick="closeLy();"></div>
			</div>
			<!--// 세라벨 : 메인 -->

<!-- #include virtual="/lib/db/dbclose.asp" -->