<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<% Dim isEventBanner: isEventBanner = False
    If left(now(),10) >= "2022-01-05" And left(now(),10) < "2022-03-01" Then
        isEventBanner = True
    End If
    Dim isTwoEventBanner : isTwoEventBanner = False
    '2021.12.01 태훈 추가(페이퍼즈 전용 띠배너)
    if request("itemid") <> "" And left(now(),10) >= "2021-12-01" And left(now(),10) < "2021-12-20" then
        dim oItem
        set oItem = new CatePrdCls
        oItem.GetItemData request("itemid")
        if left(oItem.Prd.FcateCode,3)="101" then
            isTwoEventBanner = True
        end if
        Set oItem = Nothing
    end if
 %>
<% If isEventBanner Then %>
<% if isTwoEventBanner then %>
<div class="bnr_nomemeber" style="display:none;">
    <a href="/event/eventmain.asp?eventid=115414"><img src="http://fiximage.10x10.co.kr/m/2021/banner/bnr_payback.jpg" alt="디자인 문구 3만 원 이상 구매 시 페이백!"></a>
    <button type="button" class="btn_close" onclick="close_banner()"><img src="http://fiximage.10x10.co.kr/m/2021/banner/icon_header_close.png" alt="close"></button>
</div>
<% Else %>
<div class="bnr_nomemeber" style="display:none;">
    <img onclick="clickBanner()" id="bnr_event_coupon" src="http://imgstatic.10x10.co.kr/main/202201/740/mobileprdtopbanner_83985_20220104172005.jpg" alt="">
    <button type="button" class="btn_close" onclick="close_banner()"><img src="http://fiximage.10x10.co.kr/m/2021/banner/icon_header_close.png" alt="close"></button>
</div>
<% End If %>
<% Else %>
<div class="bnr_nomemeber" style="display:none;">
    <img onclick="clickBanner()" id="bnr_nomemeber_img" src="" alt="">
    <button type="button" class="btn_close" onclick="close_banner()"><img src="http://fiximage.10x10.co.kr/m/2021/banner/icon_header_close.png" alt="close"></button>
</div>
<% End If %>

<script>
    let prdTopBannerLink = "";
    $(document).ready(function (){
        let front_api_url = '//fapi.10x10.co.kr/api/web/v1';
        let GetImageUrl = "//imgstatic.10x10.co.kr/main/";
        if( '<%=application("Svr_Info")%>'.toLowerCase() === 'dev' ) {
            front_api_url = '//localhost:8080/api/web/v1';
            GetImageUrl = "//testimgstatic.10x10.co.kr/main/";
        }

        <% If isEventBanner Then %>
            // 상단 배너 이벤트 성 배너 (이벤트 쿠폰 사용여부 파악하여 노출/비노출 처리)
            front_api_url = '//fapi.10x10.co.kr/api/web/v2';
            <% If Now() > #01/04/2022 00:00:00# AND Now() < #01/31/2022 23:59:59# Then%>
            let couponIdx = "1947"; // 쿠폰 일련번호 값은 고정 test:3976, prd:1877 미정
            <% elseIf Now() > #02/01/2022 00:00:00# AND Now() < #02/28/2022 23:59:59# Then%>
            let couponIdx = "2027"; // 쿠폰 일련번호 값은 고정 test:3976, prd:1877 미정
            <% end if %>
            if( '<%=application("Svr_Info")%>'.toLowerCase() === 'dev' ) {
                front_api_url = '//testfapi.10x10.co.kr/api/web/v2';
                couponIdx = "3976";
            }
            return new Promise(function (resolve, reject){
                $.ajax({
                    type : 'GET'
                    , url: front_api_url + '/coupon/eventCouponUsed/' + couponIdx
                    , data: {}
                    , crossDomain: true
                    , async: false
                    , xhrFields: {
                        withCredentials: true
                    }
                    , success: function(data) {
                        if(data === 0){
                            prdTopBannerLink = '/my10x10/couponbook.asp?tab=3'; // 클릭시 이동 페이지
                            resolve();
                        }else{
                            reject();
                        }
                    }
                    , error: function (xhr) {
                        console.log(xhr);
                        reject();
                    }
                });
            }).then(function (){
                let nowUrl = window.location.href;
                let hasCookie = getCookie("prdTopBanner");
                let userid = "<%= session("ssnuserid") %>";

                if(nowUrl.toLowerCase().indexOf("category_itemprd") > 0 && prdTopBannerLink){
                    document.getElementById("header").className += " bnr_on";
                    $(".bnr_nomemeber").css("display", "block");
                }
            }).catch(function(e){
                console.log("catch", e);
            });
        <% Else %>
        return new Promise(function (resolve, reject){
            $.ajax({
                type : 'GET'
                , url: front_api_url + '/banner/prd-top-banner'
                , data: {"poscode" : "740"}
                , crossDomain: true
                , async: false
                , xhrFields: {
                    withCredentials: true
                }
                , success: function(data) {
                    console.log("data", data);
                    if(data.imageurl){
                        $("#bnr_nomemeber_img").attr("src", GetImageUrl + data.imageurl);
                        prdTopBannerLink = data.linkurl;

                        resolve();
                    }else{
                        console.log("data.imageurl is null");
                        reject();
                    }
                }
                , error: function (xhr) {
                    console.log(xhr);
                    reject();
                }
            });
        }).then(function (){
            let nowUrl = window.location.href;
            let hasCookie = getCookie("prdTopBanner");
            let userid = "<%= session("ssnuserid") %>";

            if(nowUrl.toLowerCase().indexOf("category_itemprd") > 0 && !hasCookie && userid == "" && prdTopBannerLink){
                document.getElementById("header").className += " bnr_on";
                $(".bnr_nomemeber").css("display", "block");
            }
        }).catch(function(e){
            console.log("catch", e);
        });
        <% End If %>
    });

    function close_banner(){
        setCookie("prdTopBanner","done" , 3);
        $(".bnr_nomemeber").css("display", "none");
        document.getElementById("header").classList.remove("bnr_on");
    }

    function clickBanner(){
        <% If isEventBanner then %>
            fnAmplitudeEventObjectAction('click_product_top_banner', {}); // Amplitude 이벤트 전송
            goApp();
        <% Else %>
            fnAmplitudeEventObjectAction("click_marketing_nonuser_bnr", {"itemid" : "<%= request("itemid")%>"});
            location.href = prdTopBannerLink.replaceAll("\\0x2F", "/");
        <% End If %>
    }

    // 쿠키 가져오기
    function getCookie(name) {
        var nameOfCookie = name + "=";
        //alert(nameOfCookie);
        var x = 0;
        while ( x <= document.cookie.length )
        {
            var y = (x+nameOfCookie.length);
            if ( document.cookie.substring( x, y ) == nameOfCookie ) {
                if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
                endOfCookie = document.cookie.length;
                return unescape( document.cookie.substring( y, endOfCookie ) );
            }
            x = document.cookie.indexOf( " ", x ) + 1;
            if ( x == 0 ){
                break;
            }
        }
        return "";
    }

    function setCookie(name, value, expiredays) {
        var todayDate = new Date();
        todayDate.setDate( todayDate.getDate() + expiredays );
        document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
    }

    function goApp() {
        var userAgent = navigator.userAgent.toLowerCase();
        let link = 'http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=3&isFIRDynamicLink=true';
        let ampPlace = 'couponbook';
        let url = "https://tenbyten.page.link/?";
        amplitudeGoApp(ampPlace);

        if(userAgent.match('iphone')){
            url += "link=" + encodeURIComponent(link);
            url += "&ibi=kr.co.10x10.wish";
            url += "&isi=864817011";
            url += "&ius=tenwishapp";
            url += "&efr=1";
        }else if(userAgent.match('android')){
            url += "link=" + encodeURIComponent(link);
            url += "&apn=kr.tenbyten.shopping";
            url += "&amv=99251";
        }else{
            alert("Android/IOS 만 지원합니다.");
        }

        $.ajax({
            type: "POST",
            url: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyDSNXV6tYgTBetChYR8NU2jKxCI_ldVMcM",
            data: {"longDynamicLink" : url},
            ContentType: "json",
            crossDomain: true,
            success: function(data){
                //console.log(data);
                url = data.shortLink;
            }
        });
        location.href = url;
    }

    function amplitudeGoApp(val){
        let amplitudeProperties = {
            place : val
        };
        amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
        amplitude.getInstance().logEvent("click_open_app", amplitudeProperties);
    }
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->