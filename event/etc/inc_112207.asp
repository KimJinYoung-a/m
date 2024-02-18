<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description :  쿠폰 이벤트
' History : 2021-06-18 정태훈 생성
'####################################################

dim mktTest, currentDate
IF application("Svr_Info") = "Dev" THEN
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
    mktTest = true
Else
    mktTest = false
End If

if mktTest then
    currentDate = cdate("2021-06-21")
else
    currentDate = date()
end if
%>
<style type="text/css">
/* common */
.mEvt112207 .section{position:relative;}
.mEvt112207 .section .coupon_price{position:absolute;top:13.3rem;left:50%;width:84vw;margin-left:-42vw;}
.mEvt112207 .section .coupon_price a{position:relative;width:100%;height:13.2rem;display:inline-block;}
.mEvt112207 .section .coupon_price a .left{position:absolute;top:7rem;left:7.5vw;}
.mEvt112207 .section .coupon_price a .right{position:absolute;top:7rem;left:44vw;}
.mEvt112207 .section .coupon_price a .price{color:#fe3e00;font-size:2.0rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt112207 .section .coupon_price a .price s{display:block;color:rgba(255,255,255,0.5);font-size:1.5rem;font-style:italic;margin-bottom:.3rem;font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.mEvt112207 .section .more_items{position:absolute;top:70rem;left:50%;width:84vw;height:10rem;margin-left:-42vw;}
.mEvt112207 .section .coupon_go{position:absolute;bottom:0;width:100%;height:10rem;}
.mEvt112207 .section .coupon_go a{display:inline-block;width:100%;height:100%;}
.mEvt112207 .section05{position:relative;}
.mEvt112207 .section05 a{position:absolute;top:0;left:0;width:100%;height:100%;}
.mEvt112207 .section06 .evt_code{position:absolute;top:21rem;left:50%;width:84vw;margin-left:-42vw;}
.mEvt112207 .section06 .evt_code a{position:relative;width:100%;height:10.4rem;display:inline-block;}
.mEvt112207 .section06 .first_evt{position:absolute;top:68rem;left:50%;width:84vw;height:10.4rem;margin-left:-42vw;}
.mEvt112207 .section06 .first_evt a{display:inline-block;width:100%;height:100%;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_112207.js?v=1.00"></script>
<script>
$(function(){
    <% IF application("Svr_Info") = "Dev" THEN %>
    codeGrp = [3369684,3369682,3369677,3369670];
    <% Else %>
    codeGrp = [3880883,3818345,3874291,2453471];
    <% End If %>
    var $rootEl = $("#itemList");
    var itemEle = tmpEl = "";
    var ix1 = 1;
    $rootEl.empty();
    codeGrp.forEach(function(item){
        if(ix1%2 == 0){
            tmpEl = '<a href="" onclick="goProduct('+item+');return false;">\
                        <div class="price right"><s>정가</s><em>할인가</em>원</div>\
                    </a>\
                    '
            
        }else{
            tmpEl = '<a href="" onclick="goProduct('+item+');return false;">\
                        <div class="price left"><s>정가</s><em>할인가</em>원</div>\
                    </a>\
                    '
        }
        itemEle += tmpEl;
        ++ix1;
    });
    itemEle = itemEle + '<a href="#group370939" class="more_items"></a>';
    $rootEl.append(itemEle);

    fnApplyItemInfoList({
        items:codeGrp,
        target:"itemList",
        fields:["price"],
        unit:"none",
        saleBracket:false
    });

    <% IF application("Svr_Info") = "Dev" THEN %>
    codeGrp2 = [3369684,3369682,3369677,3369670];
    <% Else %>
    codeGrp2 = [3471364,3868587,2840663,3466746];
    <% End If %>
    var $rootEl2 = $("#itemList2");
    var itemEle2 = tmpEl2 = "";
    var ix2 = 1;
    $rootEl2.empty();
    codeGrp2.forEach(function(item){
        if(ix2%2 == 0){
            tmpEl2 = '<a href="" onclick="goProduct('+item+');return false;">\
                        <div class="price left"><s>정가</s><em>할인가</em>원</div>\
                    </a>\
                    '
            
        }else{
            tmpEl2 = '<a href="" onclick="goProduct('+item+');return false;">\
                        <div class="price right"><s>정가</s><em>할인가</em>원</div>\
                    </a>\
                    '
        }
        itemEle2 += tmpEl2;
        ++ix2;
    });
    itemEle2 = itemEle2 + '<a href="#group370940" class="more_items"></a>';
    $rootEl2.append(itemEle2);

    fnApplyItemInfoList2({
        items:codeGrp2,
        target:"itemList2",
        fields:["price"],
        unit:"none",
        saleBracket:false
    });

    <% IF application("Svr_Info") = "Dev" THEN %>
    codeGrp3 = [3369684,3369682,3369677,3369670];
    <% Else %>
    codeGrp3 = [2791610,2255061,3740712,3231840];
    <% End If %>
    var $rootEl3 = $("#itemList3");
    var itemEle3 = tmpEl3 = "";
    var ix3 = 1;
    $rootEl3.empty();
    codeGrp3.forEach(function(item){
        if(ix3%2 == 0){
            tmpEl3 = '<a href="" onclick="goProduct('+item+');return false;">\
                        <div class="price right"><s>정가</s><em>할인가</em>원</div>\
                    </a>\
                    '
            
        }else{
            tmpEl3 = '<a href="" onclick="goProduct('+item+');return false;">\
                        <div class="price left"><s>정가</s><em>할인가</em>원</div>\
                    </a>\
                    '
        }
        itemEle3 += tmpEl3;
        ++ix3;
    });
    itemEle3 = itemEle3 + '<a href="#group370941" class="more_items"></a>';
    $rootEl3.append(itemEle3);

    fnApplyItemInfoList3({
        items:codeGrp3,
        target:"itemList3",
        fields:["price"],
        unit:"none",
        saleBracket:false
    });

    <% IF application("Svr_Info") = "Dev" THEN %>
    codeGrp4 = [3369684,3369682,3369677,3369670];
    <% Else %>
    codeGrp4 = [3901824,1312203,3853712,2368844];
    <% End If %>
    var $rootEl4 = $("#itemList4");
    var itemEle4 = tmpEl4 = "";
    var ix4 = 1;
    $rootEl4.empty();
    codeGrp4.forEach(function(item){
        if(ix4%2 == 0){
            tmpEl4 = '<a href="" onclick="goProduct('+item+');return false;">\
                        <div class="price left"><s>정가</s><em>할인가</em>원</div>\
                    </a>\
                    '
            
        }else{
            tmpEl4 = '<a href="" onclick="goProduct('+item+');return false;">\
                        <div class="price right"><s>정가</s><em>할인가</em>원</div>\
                    </a>\
                    '
        }
        itemEle4 += tmpEl4;
        ++ix4;
    });
    itemEle4 = itemEle4 + '<a href="#group370942" class="more_items"></a>';
    $rootEl4.append(itemEle4);

    fnApplyItemInfoList4({
        items:codeGrp4,
        target:"itemList4",
        fields:["price"],
        unit:"none",
        saleBracket:false
    });
});

// 상품 링크 이동
function goProduct(itemid) {
	<% if isApp then %>
		parent.location.href= 'javascript:fnAPPpopupProduct('+itemid+')'
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}
</script>
			<div class="mEvt112207">
				<p class="go_coupon">
					<a href="https://m.10x10.co.kr/my10x10/couponbook.asp?tab=2" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/go_coupon.jpg" alt=""></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','https://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=2');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/go_coupon.jpg" alt=""></a>
				</p>
				<p class="bg_title">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/bg_title.jpg" alt="">
				</p>
				<section class="section section01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/coupon_3000.jpg" alt="">
					<div class="coupon_price" id="itemList"></div>
					<a href="#group370939" class="more_items"></a>
				</section>
				<section class="section section02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/coupon_10000.jpg?v=2" alt="">
					<div class="coupon_price" id="itemList2"></div>
					<a href="#group370940" class="more_items"></a>
				</section>
				<section class="section section03">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/coupon_15000.jpg?v=4" alt="">
					<div class="coupon_price" id="itemList3"></div>
					<a href="#group370941" class="more_items"></a>
				</section>
				<section class="section section04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/coupon_30000.jpg" alt="">
					<div class="coupon_price" id="itemList4"></div>
					<a href="#group370942" class="more_items"></a>
					<div class="coupon_go">
						<a href="https://m.10x10.co.kr/my10x10/couponbook.asp?tab=2" class="mWeb"></a>
                    	<a href="" onclick="fnAPPpopupBrowserURL('기획전','https://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=2');return false;" class="mApp"></a>
					</div>
				</section>
				<% If currentDate >= #2021-06-21 00:00:00# Then %>
				<section class="section section05">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/coupon_shinhan.jpg" alt="">
					<a href="/event/eventmain.asp?eventid=112094" class="mWeb"></a>
                    <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112094');return false;" class="mApp"></a>
				</section>
				<% end if %>
				<section class="section section06">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112207/m/banner.jpg" alt="">
					<div class="evt_code">
						<a href="/event/eventmain.asp?eventid=111787" class="mWeb"></a>
                    	<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111787');return false;" class="mApp"></a>
						<a href="/event/eventmain.asp?eventid=111775" class="mWeb"></a>
                    	<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111775');return false;" class="mApp"></a>
						<a href="/event/eventmain.asp?eventid=112025" class="mWeb"></a>
                    	<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112025');return false;" class="mApp"></a>
						<a href="/event/eventmain.asp?eventid=111766" class="mWeb"></a>
                    	<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111766');return false;" class="mApp"></a>
					</div>
					<div class="first_evt">
						<a href="/event/eventmain.asp?eventid=107535" class="mWeb"></a>
                   		<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107535');return false;" class="mApp"></a>
					</div>
				</section>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->