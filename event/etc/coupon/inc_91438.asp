<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
    dim iscouponeDown, eventCoupons, vQuery
    IF application("Svr_Info") = "Dev" THEN
        eventCoupons = "22103,22105,22106"	
    Else
        eventCoupons = "33043,33042,33041"	
    End If

    iscouponeDown = false

    if IsUserLoginOK then 
        vQuery = "select count(1) from [db_item].[dbo].[tbl_user_item_coupon] with (nolock) where userid = '" & getencLoginUserid() & "'"
        vQuery = vQuery + " and itemcouponidx in ("&eventCoupons&") "
        vQuery = vQuery + " and usedyn = 'N' "
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
        If rsget(0) = 3 Then	' 
            iscouponeDown = true
        End IF
        rsget.close
    end if 

     '// coupon
    dim userid, couponcnt
    dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3
    dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3

    IF application("Svr_Info") = "Dev" THEN
        getbonuscoupon1 = "22103"
        getbonuscoupon2 = "22105"
        getbonuscoupon3 = "22106"
    Else
        getbonuscoupon1 = "33043"	
        getbonuscoupon2 = "33042"	
        getbonuscoupon3 = "33041"
    End If

    userid = getencloginuserid()

    couponcnt=0
    totalbonuscouponcountusingy1=0
    totalbonuscouponcountusingy2=0
    totalbonuscouponcountusingy3=0

    couponcnt = getitemcouponexistscount("", eventCoupons, "", "")

    if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "motions" Or userid="leelee49" then
        totalbonuscouponcountusingy1 = getitemcouponexistscount("",getbonuscoupon1,"Y","")
        totalbonuscouponcountusingy2 = getitemcouponexistscount("",getbonuscoupon2,"Y","")
        totalbonuscouponcountusingy3 = getitemcouponexistscount("",getbonuscoupon3,"Y","")
    end if
%>
<style>
    .mEvt91438 {position:relative; background-color:#c5122b;}
    .mEvt91438 .bnr {border-top:0.43rem solid #fff;}
    .layer-coupon {display:none; position:absolute; top:0; left:0; width:100%; height:100%;}
    .layer-coupon:before {display:block; position:absolute; top:0; left:0; z-index:30; width:100%; height:100%; background-color:rgba(0,0,0,.65); content:' ';}
    .layer-coupon .inner {position:absolute; top:22.78rem; left:50%; z-index:50; width:83%; margin-left:-41.5%; -webkit-box-shadow:0 1.66rem 1.24rem rgba(46,3,9,.65); box-shadow:0 1.66rem 1.24rem rgba(46,3,9,.65);}
    .layer-coupon .btn-close {position:absolute; top:0; right:0; width:4.39rem; height:4.14rem; text-indent:-999em; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/91438/m/btn_close.png) 50% 50% no-repeat; background-size:1.92rem; outline:0;}
</style>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.4370"></script>
<script type="text/javascript">
$(function(){
    // coupon
	$('.layer-coupon').hide();
	$('.btn-coupon').click(function(){
        <% if Not(IsUserLoginOK) then %>
			jsEventLogin();
			return false;
		<% end if %>

        <% if iscouponeDown then %>
            alert("이미 쿠폰을 다운 받으셨습니다.");
    		return false;
		<% end if %>
        $('.layer-coupon').fadeIn(300);
		jsDownCoupon2('prd,prd,prd','<%=eventCoupons%>');
	});
	$('.layer-coupon .btn-close').click(function(){$('.layer-coupon').fadeOut(300);});
});

function jsDownCoupon2(stype,idx){
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
		return false;
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
            console.log(message);
			if(typeof(message)=="object") {
				if(message.response=="Ok") {
					setTimeout(function(){$('.layer-coupon').fadeIn();}, 1500);					
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
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=91438")%>');
    <% end if %>
        return;
}
</script>
<div class="mEvt91438">
    <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91438/m/tit_coupon.jpg" alt="연말정산 쿠폰"></h2>
    <p><a id="couponBtn" class="btn-coupon" title="쿠폰 한번에 다운받기"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91438/m/img_coupon.jpg" alt=""></a></p>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91438/m/txt_noti.jpg" alt="이벤트 유의사항"></p>
    <div class="bnr"><a href= "/event/eventmain.asp?eventid=91297" onclick="jsEventlinkURL(91297);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91438/m/img_bnr.jpg" alt="최최최저가"></a></div>
    <div class="layer-coupon">
        <div class="inner">
            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91438/m/popup.jpg" alt="쿠폰이 발급 되었습니다!" /></p>
            <p><a href= "/event/eventmain.asp?eventid=91467" onclick="jsEventlinkURL(91467);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91438/m/popup_bnr.jpg" alt="리빙 띵템"></a></p>
            <button class="btn-close">닫기</button>
        </div>
    </div>
</div>
<%
    if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "motions" Or userid="leelee49" then
        response.write couponcnt&"-발행수량<br>"
        response.write totalbonuscouponcountusingy1&"-사용수량(20%)<br>"
        response.write totalbonuscouponcountusingy2&"-사용수량(15%)<br>"
        response.write totalbonuscouponcountusingy3&"-사용수량(10%)<br>"        
    end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->