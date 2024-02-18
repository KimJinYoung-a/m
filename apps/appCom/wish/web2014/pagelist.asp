<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim BASELNK : BASELNK="/apps/appCom/wish/web2014"
dim IsShow_OLDPROTOCOL : IsShow_OLDPROTOCOL= FALSE
%>
<%
if NOT ( _
    (GetLoginUserID="icommang") Or (GetLoginUserID="10x10green") Or (GetLoginUserID="thensi7") Or (GetLoginUserID="tozzinet") Or (GetLoginUserID="qpark99") Or (GetLoginUserID="kobula") Or (GetLoginUserID="greenteenz") Or _
    (GetLoginUserID="vhfhflsksk") Or (GetLoginUserID="phsman1") Or (GetLoginUserID="kjy8517") Or (GetLoginUserID="corpse2") Or (GetLoginUserID="ysys1418") Or (GetLoginUserID="skyer9") Or (GetLoginUserID="ley330") Or _
    (GetLoginUserID="cjw0515") Or (GetLoginUserID="jeonghyeon1211") Or (GetLoginUserID="rnldusgpfla") Or (GetLoginUserID="jjia94") Or (GetLoginUserID="sse1022") Or (GetLoginUserID="kjh951116") Or (GetLoginUserID="seojb1983") Or _
    (GetLoginUserID="kny9480") Or (GetLoginUserID="bestksy0527") Or (GetLoginUserID="mame234") Or (GetLoginUserID="starsun726") Or (GetLoginUserID="lglee2938") Or (GetLoginUserID="dlwjseh") Or (GetLoginUserID="integerkim") Or _
    (GetLoginUserID="coolhas") Or (GetLoginUserID="winnie") Or (GetLoginUserID="pinokio5600") Or (GetLoginUserID="10x10yellow") Or (GetLoginUserID="10x10blue") Or (GetLoginUserID="10x10vip") Or (GetLoginUserID="10x10vipgold") Or _
    (GetLoginUserID="10x10vvip") Or (GetLoginUserID="madash") Or (GetLoginUserID="cunhng") Or (GetLoginUserID="sonjisuu1014") Or (GetLoginUserID="pepe820") Or (GetLoginUserID="dokyong0401") Or (GetLoginUserID="z0516") Or _
    (GetLoginUserID="pinkmaring") Or (GetLoginUserID="kbm503")  Or (GetLoginUserID="jehyeon") Or (GetLoginUserID="yeg0117") Or (GetLoginUserID="angel1094") Or (GetLoginUserID="jimni0114") Or (GetLoginUserID="moonwork13") Or (GetLoginUserID="alice3211") _
    Or (GetLoginUserID="ysyoo89") Or (GetLoginUserID="wldbs4086") _
    ) Then

    response.write "...."
    response.end

end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type='text/javascript'>
// getDeviceInfo :: 각 페이지 내에서 사용.
    function fnAPPgetDeviceInfo() {
        callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
        alert(2);
            alert(deviceInfo.uuid+'::'+deviceInfo.psid+'::'+deviceInfo.version+'::'+deviceInfo.nudgeuid+'::'+deviceInfo.idfa)  ; //ios idfa ?
            // deviceInfo.uuid;
            // deviceInfo.psid;
            // deviceInfo.version;
        }});
    }

    function fnGetAppVersion() {
        callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
            alert(deviceInfo.version);
        }});
    }

    function getRecentlyViewedProductsApp(products){
       // alert(products.join(','));
       // location.href="/apps/appCom/wish/web2014/my10x10/mytodayshopping.asp?itemarr="+products.join(',');
    }

    function funcTEST(arg1,arg2,arg3){
        //alert(arg1+'|'+arg2+'|'+arg3);

        setTimeout(
            function(){
            alert(arg1+'|'+arg2+'|'+arg3);
        },1000);

    }

    function alertTEST(){
        alert(1);
        alert(2);
    }

    function confirmTEST(){
        if (confirm('이동하시겠습니까?')){
            alert('옙');
        }else{
            alert('아니오');
        }
    }

   function agentchk(){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp )
		{
			alert("앱임");
		}else{
			alert("모바일임");
		}
	}

//로그분석
/*
function fnAPPsetTrackLog1(trackType,trackval1,trackval2){
    if (!trackval2) trackval2="";
    callNativeFunction('setTrackLog', {"tracktype": trackType, "trackval1":trackval1, "trackval2":trackval2 });
    return false;
}
*/

function setTimeoutTEST(){
<%
    response.write "fnAPPsetOrderNum('10');"
    response.write "setTimeout(""fnAPPchangPopCaption('주문완료');"",500);"
    response.write "setTimeout(""fnAPPchangPopCaption('주문결제');"",1000);"
%>
    return false;
}

function TTT(iitemid){
    fnAPPopenerJsCall("TTT2("+iitemid+")");
}

function TTT2(iitemid){
alert(22);
    alert("["+iitemid+"]");
}


function fnAPPpopupPlay_URL_TEST(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "PLAY", [BtnType.SHARE, BtnType.CART], url, "play");
	//fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "PLAY", [BtnType.CART], url, "play");
	return false;
}

function fnEventQuickLink(){
    fnAPPpopupEvent_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" + $("#evtcode").val());
}

function fnEventQuickLinkHttps(){
    fnAPPpopupEvent_URL("https://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" + $("#evtcode2").val());
}

function fnEventQuickLinkPickUp(){
    fnAPPpopupEvent_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" + $("#evtcode3").val() + "&param=mktTest");
}

</script>

<% if  (FALSE) then %>
<script type='text/javascript'>
//신규방식-구준호.
    function callNativeFunction(funcname, args) {
        if ( !args ) { args = {} }
        args['funcname'] = funcname;
        registerCallback(funcname, args);
        window.location = 'callnativefunction:' + encodeURIComponent(JSON.stringify(args));
    }
    var _callbacks = [];
    function registerCallback(funcname, args) {
        if ( !args['callback'] ) { return; }
        _callbacks[funcname] = args['callback'];
        delete args['callback'];
    }
    function callback(funcname, jsonString) {
        _callbacks[funcname](JSON.parse(decodeURIComponent(jsonString)));
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    // getDeviceInfo :: 각 페이지 내에서 사용.
    function fnAPPgetDeviceInfo() {
        callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
            alert(deviceInfo.uuid+'::'+deviceInfo.psid+'::'+deviceInfo.version)
            // deviceInfo.uuid;
            // deviceInfo.psid;
            // deviceInfo.version;
        }});
    }

    function fnAPPsetCartNum(num) {
        callNativeFunction('setCartNum', {"num": num});
    }

    function fnAPPsetOrderNum(num) {
        callNativeFunction('setOrderNum', {"num": num});
    }

    function fnAPPsetMyIcon(myIconId) {
        callNativeFunction('setMyIcon', {"myIconId": myIconId});
    }

    function fnAPPsetMyCouponNum(num) {
        callNativeFunction('setMyCouponNum', {"num": num});
    }

    function fnAPPsetMyMileageNum(num) {
        callNativeFunction('setMyMileageNum', {"num": num});
    }

    function fnAPPaddRecentlyViewedProduct(itemid) {
        callNativeFunction('addRecentlyViewedProduct', {"itemid": itemid});
    }

    function fnAPPselectGNBMenu(menuid, url) {
        callNativeFunction('selectGNBMenu', {"menuid": menuid, "url": url});
    }

	function fnAPPpopupExternalBrowser(url) {
        callNativeFunction('popupExternalBrowser', {"url": url});
	}

    var OpenType = {
        FROM_RIGHT: "OPEN_TYPE__FROM_RIGHT",
        FROM_BOTTOM: "OPEN_TYPE__FROM_BOTTOM"
    }

    var BtnType = {
        SEARCH: "BTN_TYPE__SEARCH",
        CART: "BTN_TYPE__CART",
        RESET: "BTN_TYPE__RESET",
        SHARE: "BTN_TYPE__SHARE",
        LNB: "BTN_TYPE__LNB"
    }

    function fnAPPpopupLogin() {
        callNativeFunction('popupLogin', {
        	"openType": OpenType.FROM_BOTTOM,
        	"ltbs": [],
        	"title": "로그인",
        	"rtbs": []
        });
    }

    function fnAPPpopupCategory(cd1,cd2,cd3,nm1,nm2,nm3) {
        callNativeFunction('popupCategory', {
        	"openType": OpenType.FROM_BOTTOM,
        	"ltbs": [],
        	"title": "카테고리명",
        	"rtbs": [],
        	"cd1": cd1,
        	"cd2": cd2,
        	"cd3": cd3,
        	"nm1": nm1,
        	"nm2": nm2,
        	"nm3": nm3
        });
    }

    function fnAPPpopupBrand(brandid){
        callNativeFunction('popupBrand', {
        	"openType": OpenType.FROM_BOTTOM,
        	"ltbs": [],
        	"title": "브랜드명",
        	"rtbs": [],
        	"brandid": brandid
        });
    }

    function fnAPPpopupBrowser(openType, leftToolBarBtns, title, rightToolBarBtns, url) {
        callNativeFunction('popupBrowser', {
        	"openType": openType,
        	"ltbs": leftToolBarBtns,
        	"title": title,
        	"rtbs": rightToolBarBtns,
        	"url": url
        });
    }

    function fnAPPpopupBrowserEventDetails() {
		var url = "http://google.com";
    	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "이벤트상세", [BtnType.SHARE, BtnType.CART], url);
    }

    function fnAPPpopupBrowserURL(title,url){
        var url = url;
    	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], title, [BtnType.SHARE, BtnType.CART], url);
    }

      //현재 팝업 닫기
    function fnAPPclosePopup(){
        callNativeFunction('closePopup', {});
    }

    //상품페이지 팝업
    function fnAPPpopupProduct2(itemid){
        var url = "<%=wwwUrl%>/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid="+itemid;
    	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "상품상세", [BtnType.SHARE, BtnType.CART], url);
    }

	//마일리지 이동
	function jsgotest99(){
		alert("AAAAA");
//		setTimeout(function(){
//			fnAPPpopupBrowserURL('마일리지 내역','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/mileagelist.asp');
//		}, 3000);
	}
</script>
<% end if %>

<% if (IsShow_OLDPROTOCOL) then %>
<script type='text/javascript'>
//기존방식
//앱 로그인창 호출
function calllogin(){
    //window.appcallback.logindialog();
    window.location.href = "custom://login.custom";
    return false;
}

//장바구니 숫자 변경
function cartnum(num){
    window.location.href = "custom://cartnum.custom?num="+num;
    return false;
}

//카테고리 바로가기
function opencategoryCustom(param){
    window.location.href = "custom://opencategory.custom?"+param;
    return false;
}

// uuid
function getUUID(){
    window.location.href = "custom://uuid.custom?callback=jsCallbackFunc";
    return false;
}

// psid
function getPSID(){
    window.location.href = "custom://psid.custom?callback=jsCallbackFunc";
    return false;
}

//version
function getVersion(){
    window.location.href = "custom://version.custom?callback=jsCallbackFunc";
    return false;
}

function jsCallbackFunc(retval){
    alert(retval);
}

//LNB 주문배송조회 숫자변경
function setordercount(cnt){
    window.location.href = "custom://ordercount.custom?cnt="+cnt;
    return false;
}

//LNB 마이 아이콘 변경
function chgmyicon(id){
    window.location.href = "custom://myicon.custom?id="+id;
    return false;
}

//LNB 쿠폰 갯수 변경
function chgmycoupon(cnt){
    window.location.href = "custom://mycoupon.custom?cnt="+cnt;
    return false;
}

//LNB 마일리지  변경
function chgmymileage(mile){
    window.location.href = "custom://mymileage.custom?mile="+mile;
    return false;
}

//LNB 최근본상품 추가
function addtodayview(itemid){
    window.location.href = "custom://todayview.custom?itemid="+itemid;
    return false;
}

//메뉴 변경 및 URL 이동
function gotopmenuurl(menuid,url){
    window.location.href = "custom://topmenuurl.custom?id="+menuid+"&url="+url;
    return false;
}

//브랜드 페이지 이동
function gobrandcustom(brandid){
    window.location.href = "custom://brand.custom?brandid="+brandid;
    return false;
}

function FnGotoBrand(v){
	$.ajax({
		url: '/apps/appCom/wish/webview/lib/act_getBrandUrl.asp?makerid='+v,
		cache: false,
		success: function(message) {
			if(message!="") {

				window.location.href = "custom://brandproduct.custom?" + message;
			}
		}
	});
}

//외부 브라우져 호출
function openbrowser(url){
alert(url);
    url = Base64.encodeAPP(url);
alert(url);
    window.location.href = "custom://openbrowser.custom?url="+url;
    return false;
}
</script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/base64.js"></script>
<% end if %>
</head>

<body style="padding-top:9.22rem; font-size:12px;">
    <div style="padding:20px;">
        <ul style="line-height: 150%;">
            <li>현재 <b>운영 서버</b>입니다.(<%=application("Svr_Info")%>) <input type="button" value="Go TEST Srv." onClick="document.location.href='http://testm.10x10.co.kr/apps/appcom/wish/web2014/pagelist.asp';"></li>
            <li align="right"><input type="button" value="Reload" onClick="document.location.reload();"></li>
            <br>

            <li>
                <script>
                    var mktTimesaleCheckDate = "";
                    var mktTimesaleCheckHour = "";
                    var mktTimesaleCheckMin = "";

                    function goMktTimesale(service) {
                        if (mktTimesaleCheckDate == "") {
                            alert("날짜를 선택해주세요");
                            return;
                        }

                        if (mktTimesaleCheckHour == "") {
                            alert("날짜를 선택해주세요");
                            return;
                        }

                        if (mktTimesaleCheckMin == "") {
                            alert("날짜를 선택해주세요");
                            return;
                        }

                        if(confirm(mktTimesaleCheckDate +' '+mktTimesaleCheckHour+':'+mktTimesaleCheckMin+' 일정으로 테스트를 진행 합니다.')) {
                                return fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+ service +'&testCheckDate='+mktTimesaleCheckDate +'%20' + mktTimesaleCheckHour+':'+mktTimesaleCheckMin);
                        }
                    }
                </script>
                <ul>
                    <li><font size=2 color="red">====== 마케팅 타임세일 Test ======</font></li>
                    <li>
                        <select name="mktTimesaleCheckDate" onchange="{mktTimesaleCheckDate = this.value; document.getElementById('mktTimesaleCheckDate').innerHTML = this.value;}">
                                <option value="">Date</option>
                                <% dim mktDaysNumber
                                    for mktDaysNumber = 01 to 31
                                        if len(mktDaysNumber) = 1 then mktDaysNumber = "0"& mktDaysNumber
                                %>
                                    <option value="2022-02-<%=mktDaysNumber%>">2022-02-<%=mktDaysNumber%></option>
                                <%  next %>
                            </select>
                            <select name="mktTimesaleCheckHour" onchange="{mktTimesaleCheckHour = this.value; document.getElementById('mktTimesaleCheckHour').innerHTML = this.value;}">
                                <option value="">Time</option>
                                <% dim mktHoursNumber
                                    for mktHoursNumber = 0 to 23
                                        if len(mktHoursNumber) = 1 then mktHoursNumber = "0"& mktHoursNumber
                                %>
                                <option value="<%=mktHoursNumber%>"><%=mktHoursNumber%></option>
                                <%  next %>
                            </select>
                            <select name="mktTimesaleCheckMin" onchange="{mktTimesaleCheckMin = this.value; document.getElementById('mktTimesaleCheckMin').innerHTML = this.value;}">
                                <option value="">Minutes</option>
                                <% dim mktMinsNumber
                                    for mktMinsNumber = 0 to 59
                                        if len(mktMinsNumber) = 1 then mktMinsNumber = "0"& mktMinsNumber
                                %>
                                <option value="<%=mktMinsNumber%>"><%=mktMinsNumber%></option>
                                <%  next %>
                            </select>
                            <br/><br/>
                            이벤트일 : <span id="mktTimesaleCheckDate" style="color:red"></span> <span id="mktTimesaleCheckHour" style="color:red"></span>:<span id="tmktTimesaleCheckMin" style="color:red"></span>
                            <br/><br/>
                            <a href="javascript:goMktTimesale('116058')"><span style="color:blue">타임세일 티저 이동</span></a>
                            <br/>
                            <a href="javascript:goMktTimesale('116985')"><span style="color:blue">타임세일 이벤트 이동</span></a>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 아이템 위크 Test ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('Test', '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115376','right','','sc');">아이템위크 Test</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 텐텐단독 Test ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('Test', '<%=wwwUrl%>/apps/appCom/wish/web2014/tenten_exclusive/main.asp','right','','sc');">텐텐단독 Test</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 20주년 Test ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('😍 Linker 🚀', '<%=wwwUrl%>/apps/appCom/wish/web2014/linker/forum.asp?idx=1','right','','sc');">20주년 Test</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 기숙사 응모 Test ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('Test', '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115553','right','','sc');">기숙사 Test</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 핑크템 Test ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('Attendance Test', '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113819','right','','sc');">PINKTEM Test</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 추석 출첵 Test ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('Attendance Test', '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113634','right','','sc');">Attendance Test</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== App Wish Test ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('App Wish Test', '<%=wwwUrl%>/apps/appCom/wish/web2014/event/test/eventmain_test.asp?eventid=113090','right','','sc');">App Wish Test</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 2021 추석 기획전 리스트 ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('chuseok2021', '<%=wwwUrl%>/apps/appCom/wish/web2014/gnbevent/all_event_chuseok2021.asp?gnbflag=1','right','','sc');">추석 기획전 페이지로</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 2021 가정의달 ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('가정의달', '<%=wwwUrl%>/apps/appCom/wish/web2014/event/family2021/index.asp','right','','sc');">가정의달 페이지로</a></li>
                </ul>
            </li>
			<li>
                <ul>
                    <li><font size=2 color="red">----------- 이벤트 테스트 영역 시작 -------------</font></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112850');">112850 스페티벌</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li>
                        <input type="text" id="evtcode3" name="evtcode3">
                        <a href="" onclick="fnEventQuickLinkPickUp();return false;">줍줍 이벤트 바로가기</a>
                    </li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111138');">111138 홀맨 하트점수</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111375');">111375 Welcome to 범지 Shop!</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111585');">111585 캠핑 풀세트 9,900원</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111643');">111643 캠핑 마일리지 혜택</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111545');">111545 Welcome to 보쨘 Shop!</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111791');">111791 더블 마일리지</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111794');">111794 Welcome to 망고펜슬 Shop!</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112034');">112034 공부왕</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112207');">112207 쿠폰이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112122');">112122 Welcome to 수봉 Shop!</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112378');">112378 Welcome to 키덜트빈 Shop!</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112407');">112407 나만의 여름별장</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112487');">112487 Welcome to 노아스토리 Shop!</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111684');">111684 스누피 찐덕후 능력고사</a></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('신규회원 혜택','<%=wwwUrl%>/apps/appCom/wish/web2014/event/benefit/','right','','sc');">신규회원 혜택</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112869');">112869 app 푸시 마일리지</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113032');">113032 이왕 이렇게 된 거!</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113210');">113210 누구나 가슴속에 여행을 품고 산다</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113327');">113327 페이백 이벤트</a></li>
                    <li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '회원가입완료', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/member/join_welcome2.asp');return false;">회원가입완료 테스트용</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113347');">113347 서촌 06 텐바이텐X더레퍼런스</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113476');">113476 박스테이프 공모전</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114163');">114163 3000 마일리지 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114022');">114022 취향 나눔 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114301');">114301 vip 전용샵</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114420');">114420 페이백 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114332');">114332 로지텍 스토리</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114763');">114763 더블 마일리지</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114788');">114788 행운의 영수증</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114872');">114872 위시 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114637');">114637 골든 티켓 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115151');">115151 더블 마일리지</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115414');">115414 2022 페이퍼즈</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115576');">115576 행운의 영수증</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115698');">115698 2022 굿노트 다이어리</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116017');">116017 연말 선물 100원 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115948');">115948 스토리 꾸미기 파이터 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115624');">115624 2022 코멘트 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116209');">116209 행운의 영수증</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116196');">116196 내 맘 속 1등 시그는?</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116317');">116317 호텔에서 신년 계획짜기</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116483');">116483 나의 디지털 짝꿍에 새 옷 입히기</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116558');">116558 더블 마일리지</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116517');">116517 인스타그램 팔로우 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116556');">116556 위글위글 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116675');">116675 안녕? 난 고양이띠야</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116737 ');">116737 박스테이프 공모전</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116917 ');">116917 리뷰텐텐</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116996 ');">116996 선착순 마일리지</a></li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/benefit/specialBenefit.asp');">쿠폰 마일리지 페이지</a></li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li>
                        <script>
                            var testCheckDate5 = "";

                            function goTest5(service) {
                                if (testCheckDate5 == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if(confirm(testCheckDate5 + ' 일정으로 테스트를 진행 합니다.')) {
                                        return fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+ service +'&checkday='+testCheckDate5);
                                }
                            }
                        </script>

                    </li>
                    <li style="padding-top:20px;padding-bottom:20px;">
                        <span style="color:red">↓↓↓</span> 매일리지 이벤트 날짜 선택 <span style="color:red">↓↓↓</span>
                        <br/><br/>
                        <select name="testCheckDate5" onchange="{testCheckDate5 = this.value; document.getElementById('testCheckDate5').innerHTML = this.value;}">
                            <option value="">Date</option>
                            <% dim daysNumber5
                                for daysNumber5 = 6 to 19
                                    if len(daysNumber5) = 1 then daysNumber5 = "0"& daysNumber5
                            %>
                            <option value="2021-12-<%=daysNumber5%>">2021-12-<%=daysNumber5%></option>
                            <%  next %>
                        </select>
                        이벤트일 : <span id="testCheckDate5" style="color:red"></span>
                        <br/><br/>
                        <a href="javascript:goTest5('115806')"><span style="color:blue">매일리지 출석 체크 이동</span></a>
                    </li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li>
                        <script>
                            var testCheckDate4 = "";
                            var testCheckHour4 = "";
                            var testCheckMin4 = "";

                            function goTest4(service) {
                                if (testCheckDate4 == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if (testCheckHour4 == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if (testCheckMin4 == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if(confirm(testCheckDate4 +' '+testCheckHour4+':'+testCheckMin4+' 일정으로 테스트를 진행 합니다.')) {
                                        return fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+ service +'&setting_time='+testCheckDate4 +'%20' + testCheckHour4+':'+testCheckMin4);
                                }
                            }
                        </script>

                    </li>
                    <li style="padding-top:20px;padding-bottom:20px;">
                        <span style="color:red">↓↓↓</span> 타임세일 날짜 선택 <span style="color:red">↓↓↓</span>
                        <br/><br/>
                        <select name="testCheckDate4" onchange="{testCheckDate4 = this.value; document.getElementById('testCheckDate4').innerHTML = this.value;}">
                            <option value="">Date</option>
                            <% dim daysNumber4
                                for daysNumber4 = 01 to 31
                                    if len(daysNumber4) = 1 then daysNumber4 = "0"& daysNumber4
                            %>
                            <option value="2021-07-<%=daysNumber4%>">2021-07-<%=daysNumber4%></option>
                            <%  next %>
                        </select>
                        <select name="testCheckHour4" onchange="{testCheckHour4 = this.value; document.getElementById('testCheckHour4').innerHTML = this.value;}">
                            <option value="">Time</option>
                            <% dim hoursNumber4
                                for hoursNumber4 = 0 to 23
                                    if len(hoursNumber4) = 1 then hoursNumber4 = "0"& hoursNumber4
                            %>
                            <option value="<%=hoursNumber4%>"><%=hoursNumber4%></option>
                            <%  next %>
                        </select>
                        <select name="testCheckMin4" onchange="{testCheckMin4 = this.value; document.getElementById('testCheckMin4').innerHTML = this.value;}">
                            <option value="">Minutes</option>
                            <% dim minsNumber4
                                for minsNumber4 = 0 to 59
                                    if len(minsNumber4) = 1 then minsNumber4 = "0"& minsNumber4
                            %>
                            <option value="<%=minsNumber4%>"><%=minsNumber4%></option>
                            <%  next %>
                        </select>
                        <br/><br/>
                        이벤트일 : <span id="testCheckDate4" style="color:red"></span> <span id="testCheckHour4" style="color:red"></span>:<span id="testCheckMin4" style="color:red"></span>
                        <br/><br/>
                        <a href="javascript:goTest4('111786')"><span style="color:blue">타임세일 티저 이동</span></a>
                        <br/>
                        <a href="javascript:goTest4('111787')"><span style="color:blue">타임세일 이벤트 이동</span></a>
                        <br/>
                    </li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 이벤트(기획전) 상품 유닛 리뉴얼 ======</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('리뉴얼', '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain2021.asp?eventid=110227','right','','sc');">기획전 페이지로</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">====== 2021 봄 정기세일 ======</font></li>
                    <li><a href="javascript:goMileageEventTestPage();">마케팅 수신동의 이벤트</a></li>
                    <li><input type="text" id="test_value_110104"></li>
                    <br>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110211');">110211 메인페이지</a></li>
                    <br>
                    <li><a href="javascript:go110409EventTestPage();">110409 출석체크 발도장 꾹꾹</a></li>
                    <li><input type="text" id="test_value_110409"></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">============== 리뉴얼 안내 ==============</font></li>
                    <li><a href="#" onclick="fnAPPpopupBrowserURL('리뉴얼 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/event/renewal/renewal_1st.asp','right','','sc'); return false;">리뉴얼 안내</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">==============히치하이커 리뉴얼 1.5==============</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserRenewal('push','히치하이커','<%=wwwUrl%>/apps/appCom/wish/web2014/hitchhiker/index2020.asp','hitchhiker','blank');">히치하이커 메인</a></li>
                </ul>
            </li>  
            <li>
                <ul>
                    <li><font size=2 color="red">==============2020 GS CDP Test==============</font></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('회원가입완료','<%=wwwUrl%>/apps/appcom/wish/web2014/member/join_welcome.asp','right','','sc');">회원가입완료</a></li>
                </ul>
            </li>
            <li><a href="#" onclick="fnAPPpopupBrowserURL('개인정보의 위탁 현황 - 그 외 협력사','<%=wwwUrl%>/apps/appCom/wish/web2014/common/private_partner_company.asp','right','','sc'); return false;">개인정보의 위탁 현황 - 그 외 협력사</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/apple/index.asp');">애플관 2020</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/christmas/index.asp');">크리스마스기획전 - 2019</a></li>
            <!--<li>
                <ul>
                    <li><font size=2 color="red">=========2019-12-16 타임세일 테스트=========</font></li>
                </ul>
            </li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99312&isTeaser=1&currentType=0');">Teaser</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99312&isTeaser=2&currentType=0');">시작전</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99312&isTeaser=2&currentType=1');">첫 번째 타임세일 오전9시~</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99312&isTeaser=2&currentType=2');">두 번째 타임세일 오후1시~</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99312&isTeaser=2&currentType=3');">세 번째 타임세일 오후4시~</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99312&isTeaser=2&currentType=4');">마지막 타임세일 오후8시~</a></li>
            <li>
                <ul>
                    <li><font size=2 color="red">=========2019-12-16 타임세일 테스트=========</font></li>
                </ul>
            </li>-->
			<li>
                <ul>
                    <li><font size=2 color="red">==============19주년 이벤트==============</font></li>
                    <li><font size=2 color="red">줍줍 이벤트의 일자별 테스트는 2020년 10월 4일까지만 유효하며 그 이후는 사용이 불가 합니다.</font></li>
                </ul>
            </li>        
			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106237');">19주년 줍줍 이벤트</a></li>                
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=Server.URLEncode(wwwUrl&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106237&currentDateinTime=2020-10-05 14:45:00")%>');">19주년 줍줍 이벤트(2020년 10월 5일 오후 14시 45분)(당첨시간대)</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=Server.URLEncode(wwwUrl&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106237&currentDateinTime=2020-10-06 08:30:00")%>');">19주년 줍줍 이벤트(2020년 10월 6일 오전 8시 30분)(당첨시간대)</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=Server.URLEncode(wwwUrl&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106237&currentDateinTime=2020-10-07 08:30:00")%>');">19주년 줍줍 이벤트(2020년 10월 7일 오전 8시 30분)</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=Server.URLEncode(wwwUrl&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106237&currentDateinTime=2020-10-08 08:30:00")%>');">19주년 줍줍 이벤트(2020년 10월 8일 오전 8시 30분)</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=Server.URLEncode(wwwUrl&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106237&currentDateinTime=2020-10-09 08:30:00")%>');">19주년 줍줍 이벤트(2020년 10월 9일 오전 8시 30분)</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=Server.URLEncode(wwwUrl&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106237&currentDateinTime=2020-10-10 08:30:00")%>');">19주년 줍줍 이벤트(2020년 10월 10일 오전 8시 30분)</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=Server.URLEncode(wwwUrl&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106237&currentDateinTime=2020-10-11 08:30:00")%>');">19주년 줍줍 이벤트(2020년 10월 11일 오전 8시 30분)</a></li>                                                                                
                </ul>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/19th/index.asp');">19주년 메인 페이지</a></li>  
                </ul>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96480');">19주년 브랜드 세일 페이지(테스트)</a></li>  
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106390');">19주년 브랜드 세일 페이지(실서비스용)</a></li>                      
                </ul>                
                <ul>
                    <li>
                        <script>
                            var testCheckDate = "";
                            var testCheckHour = "";
                            var testCheckMin = "";
                            var testCheckPercent = "";
                            
                            function goTest(dev,service) {
                                if (testCheckDate == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if (testCheckHour == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if (testCheckMin == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if (testCheckPercent == "") {
                                    alert("확률을 선택해주세요");
                                    return;
                                }
                                
                                if(confirm(testCheckDate +' '+testCheckHour+':'+testCheckMin+' '+testCheckPercent/10+'% 일정으로 테스트를 진행 합니다.')) {
                                    <% IF application("Svr_Info") = "Dev" THEN %>
                                        location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid="+ dev +"&testCheckDate="+testCheckDate +' '+testCheckHour+':'+testCheckMin+"&testPercent="+testCheckPercent;
                                    <% ELSE %>
                                        return fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+ service +'&testCheckDate='+testCheckDate +' '+testCheckHour+':'+testCheckMin+"&testPercent="+testCheckPercent);
                                    <% END IF %>
                                }
                            }
                        </script>
                        
                    </li>
                    <li style="padding-top:20px;padding-bottom:20px;">
                        <span style="color:red">↓↓↓</span> 19주년 이벤트 날짜 선택 <span style="color:red">↓↓↓</span>
                        <br/><br/>
                        <select name="testCheckDate" onchange="{testCheckDate = this.value; document.getElementById('testCheckDate').innerHTML = this.value;}">
                            <option value="">Date</option>
                            <% dim daysNumber
                                for daysNumber = 1 to 31
                                    if len(daysNumber) = 1 then daysNumber = "0"& daysNumber
                            %>
                            <option value="2020-10-<%=daysNumber%>">2020-10-<%=daysNumber%></option>
                            <%  next %>
                        </select>
                        <select name="testCheckHour" onchange="{testCheckHour = this.value; document.getElementById('testCheckHour').innerHTML = this.value;}">
                            <option value="">Time</option>
                            <% dim hoursNumber
                                for hoursNumber = 0 to 23
                                    if len(hoursNumber) = 1 then hoursNumber = "0"& hoursNumber
                            %>
                            <option value="<%=hoursNumber%>"><%=hoursNumber%></option>
                            <%  next %>
                        </select>
                        <select name="testCheckMin" onchange="{testCheckMin = this.value; document.getElementById('testCheckMin').innerHTML = this.value;}">
                            <option value="">Minutes</option>
                            <% dim minsNumber
                                for minsNumber = 0 to 59
                                    if len(minsNumber) = 1 then minsNumber = "0"& minsNumber
                            %>
                            <option value="<%=minsNumber%>"><%=minsNumber%></option>
                            <%  next %>
                        </select>
                        <select name="testCheckPercent" onchange="{testCheckPercent = this.value; document.getElementById('testCheckPercent').innerHTML = this.value/10+'%';}">
                            <option value="">Percent</option>
                            <option value="300">30%</option>
                            <option value="600">60%</option>
                            <option value="900">90%</option>
                        </select>
                        <br/><br/>
                        이벤트일 : <span id="testCheckDate" style="color:red"></span> <span id="testCheckHour" style="color:red"></span>:<span id="testCheckMin" style="color:red"></span> / <span id="testCheckPercent" style="color:red"></span>
                        <br/><br/>
                        <a href="javascript:goTest('103235','106206')"><span style="color:blue">19주년 방구석 영화관 이벤트 이동</span></a>
                        <br/>
                        <a href="javascript:goTest('103243','106513')"><span style="color:blue">19주년 비밀의 책 이벤트 이동</span></a>
                    </li>
                </ul>
            </li>            
            <li>
                <ul>
                    <li><font size=2 color="red">=========2020-02-06 발렌 타임 세일 테스트=========</font></li>
                </ul>
            </li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100436&isTeaser=2&currentType=0');">시작전</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100436&isTeaser=2&currentType=1');">타임세일 오후5시~</a></li>
            <li>
                <ul>
                    <li><font size=2 color="red">=========2020-02-06 발렌 타임 세일 테스트=========</font></li>
                </ul>
            </li> 

            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98236');">독도 프렌즈 테스트용</a></li>
            <br/>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/datainfo/97448.asp');">100원자판기 현황 페이지</a></li>
            <br/>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/datainfo/97105.asp');">보름달-장바구니이벤트 현황 페이지</a></li>
			<br/>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/etc/datainfo_96682.asp');">추석보너스 현황 페이지</a></li>
            <br/>
            <li><a href="javascript:fnAPPpopupBrowserURL('다꾸톡톡','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2020/daccu_toktok.asp');">다꾸톡톡 앱용</a></li>
            <br/>
			<li>상품후기 이미지 업로드 테스트용- <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '상품후기', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsUsingWrite_v2.asp?orderserial=17021706246&itemid=879314&optionCD=0000&referVal=M');return false;">상품후기 이미지 업로드 테스트용</a></li>
			<br/>
			<li>상품후기 이미지 업로드 테스트용- <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '상품후기', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsUsingWrite_v2.asp?orderserial=17062235385&itemid=1685329&optionCD=Z330&referVal=M');return false;">염대리님 전용</a></li>
            <br>
			<li>회원가입완료 모로코 테스트용- <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '회원가입완료', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/member/join_welcome.asp');return false;">회원가입완료 모로코 테스트용</a></li>
            <br>
			<li>GNB메뉴 이동 갱신 테스트용- <a href="" onclick="fnAPPselectGNBMenu('taste', '<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/index.asp?currentDate=2019-10-01');return false;">GNB메뉴 이동 갱신 테스트용</a></li>            
            <br>
			<li>토스 결제 테스트 상품- <a href="" onclick="fnAPPpopupProduct(1517711);return false;">토스 결제 테스트용 상품</a></li>            
            <br>
            <li>
                <ul>
                    <li><font size=2 color="red">2021 정기세일</font></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110104');return false;">마케팅수신동의 (체크리스트)</a></li>
                </ul>
            </li>
            <li>
                <ul>
                    <li><font size=2 color="red">2020 정기세일</font></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101722');return false;">2020 봄 정기세일</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101719');return false;">데이세일</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101695');return false;">구매금액별 선물</a></li>
                    <li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101392');return false;">4월 푸시동의</a></li>
                    <li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=000000');return false;">텐X텐 인플루언서 쿠폰</a></li>
                    <li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=000000');return false;">실시간유입</a></li>
                </ul>
            </li>
            <br>
			<li>
                <ul>
                    <li><font size=2 color="red">==============18주년 이벤트==============</font></li>
                </ul>
            </li>        
			<li>
                <ul>
                    <li><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], '오늘의 취향', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/18th/index.asp');return false;">18주년 오늘의 취향</a></li>
                    <li><a href="#" onclick="fnAPPpopupBrowserURL('나에게 텐바이텐은','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97588');return false;">18주년 댓글이벤트(나에게 텐바이텐은?) 97588</a></li>
                    <li><a href="#" onclick="fnAPPpopupBrowserURL('스누피의 선물','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97589');return false;">18주년 사은이벤트(스누피의선물) 97589</a></li>
                    <li><a href="#" onclick="fnAPPpopupBrowserURL('텐텐데이','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97715');return false;">18주년 텐텐데이 97715</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97541');">18주년 매일리지 1차</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97567');">18주년 매일리지 2차</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97587');">18주년 오늘의 취향(리다이렉트 테스트)</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97806');">18주년 비밀번호 이벤트</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97856');">18주년 텐X텐 쿠폰 이벤트</a></li>
                </ul>
            </li>
            <li style="padding-top:20px;padding-bottom:20px;">
                <ul>
                    <li>
                        <script>
                            var adminCurrentDate = "";
                            var adminWinPercent = "";
                            var adminPrizeId = "";

                            function gachalink() {
                                // console.log(adminCurrentDate);
                                // console.log(adminWinPercent);
                                if (adminCurrentDate == "") {
                                    alert("이벤트 날짜 선택");
                                    return;
                                }
                                <% IF application("Svr_Info") = "Dev" THEN %>
                                    location.href = "/event/eventmain.asp?eventid=90466&istest=1&adminCurrentDate="+adminCurrentDate+"&adminWinPercent="+adminWinPercent+"&adminPrizeId="+adminPrizeId;
                                <% ELSE %>
                                    return fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100597&istest=1&adminCurrentDate='+adminCurrentDate+'&adminWinPercent='+adminWinPercent+'&adminPrizeId='+adminPrizeId);
                                <% END IF %>
                            }
                        </script>
                        <select name="adminCurrentDate" onchange="{adminCurrentDate = this.value; document.getElementById('adminCurrentDate').innerHTML = this.value;}">
                            <option value="">이벤트날짜</option>
                            <% dim dcnt
                                for dcnt = 17 to 29
                                    if len(dcnt) = 1 then dcnt = "0"& dcnt
                            %>
                            <option value="2020-02-<%=dcnt%>">2020-02-<%=dcnt%></option>
                            <%  next %>
                        </select> : 날짜 | <button class="button" value="1000" onclick="{adminWinPercent = this.value; document.getElementById('adminWinPercent').innerHTML = this.value;}">100%</button>&nbsp;&nbsp;<button class="button" value="300" onclick="{adminWinPercent = this.value; document.getElementById('adminWinPercent').innerHTML = this.value;}">30%</button> : 확률
                    </li>
                    <li style="padding-top:20px;padding-bottom:20px;">
                        이벤트일 : <span id="adminCurrentDate" style="color:red"></span> || 확률 : <span id="adminWinPercent" style="color:red"></span>
                        <br/><br/>
                        <a href="javascript:gachalink()">100원 자판기 링크 열기</a>
                    </li>
                </ul>
            </li>   
			<li>
                <ul>
                    <li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '매장안내', [BtnType.SEARCH, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/offshop2');return false;"><font size=2 color="red">오프라인샵</font></a></li>
                </ul>
            </li>
            <br>
            <br/>
            <li><a href="market://details?id=kr.tenbyten.shopping&referrer=utm_medium=mobileweb%utm_source=10x10%utm_campaign=app_conversion%utm_content=pull_banner">google play 이동 (referrer) (market://)</a></li>
            <li><a href="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_medium=mobileweb%utm_source=10x10%utm_campaign=app_conversion%utm_content=pull_banner">google play 이동 (referrer) ()</a></li>
            <br/>
            <br/>
   			<li><a href="http://m.10x10.co.kr/apps/appCom/wish/web2014/today/index2016_angularjs.asp">today_angularjs_2016</a></li>
            <br>
   			<li><a href="http://m.10x10.co.kr/apps/appCom/wish/web2014/today/index_vue_t.asp">2017 index vue.js</a></li>
			<br/>
			<li><a href="" onclick="fnAPPpopupWish_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/wish/index_test.asp');return false;">wish PC data</a></li>
			<br/>
			<li><a href="" onclick="fnAPPselectGNBMenu('digital','http://m.10x10.co.kr/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=500');return false;">스마트</a></li>
			<br/>
			<li><a href="" onclick="fnAPPselectGNBMenu('living','http://m.10x10.co.kr/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=100');return false;">리빙</a></li>
			<br/>
			<li><a href="" onclick="fnAPPselectGNBMenu('fashion','http://m.10x10.co.kr/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=200');return false;">패션</a></li>
			<br/>
			<li><a href="" onclick="fnAPPselectGNBMenu('PLAYing','http://m.10x10.co.kr/apps/appCom/wish/web2014/playing/index.asp?gnbcode=700');return false;">플레잉</a></li>
            <br/>
            <li><a href="" onclick="fnAPPselectGNBMenu('GOODS','http://m.10x10.co.kr/apps/appCom/wish/web2014/subgnb/GOODS/');return false;">GOODS</a></li>
            <br/>
            <li><a href="" onclick="fnAPPpopupAutoUrl('/subgnb/GOODS/index.asp');return false;">GOODS NewPopup</li>
             <li>
                <ul>
                    <li><a href="#" onclick="fnAPPpopupCategory(101107105);" class="app"><img src="http://webimage.10x10.co.kr/playmo/ground/20151109/btn_more.png" alt="선물의 감동을 더해줄 아이템" /></a><li>
                    </ul>
            </li>
            <br>
			<li>
                <ul>
                    <li><font size=2 color="red">2017정기세일 이벤트</font></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=77059');return false;">[소품전] main page</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=77060');return false;">[소품전] 웰컴 투 소품랜드</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=77061');return false;">[소품전] 내 친구를 소개합니다.</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=77062');return false;">[소품전] 숨은 보물 찾기</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=77063');return false;">[소품전] 완전 소중한 사은품</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=77064');return false;">[소품전] 반짝반짝 스티커</a></li>
                </ul>
            </li>
			<br/>
			<li>
                <ul>
                    <li><font size=2 color="red">2018정기세일 이벤트</font></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85144');return false;">[텐큐] main page</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85145');return false;">[텐큐] 100원의 기적</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85148');return false;">[텐큐] 텐베사고 선물받자</a></li>
					<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85146');return false;">[텐큐] 매일리지</a></li>
                </ul>
            </li>
			<br>
			<br/>
            <li>
                <ul>
                    <li><font size=2 color="red">2018 17주년 이벤트</font></li>
					<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89305');">89305 100원으로 인생역전</a></li>
                </ul>
            </li>
			<br>
			<br/>
			<li>
                <ul>
                    <li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '웨딩', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/wedding/index.asp');return false;"><font size=2 color="red">웨딩 기획전</font></a></li>
                </ul>
            </li>
			<br>
			<br/>

			<li>
                <ul>
                    <li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '히치하이커', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/hitchhiker');return false;"><font size=2 color="red">히치하이커</font></a></li>
                </ul>
            </li>
			<br>
			<br/>
			<li>
                <ul>
                    <li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], 'FASHION', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/fashion');return false;"><font size=2 color="red">FASHION</font></a></li>
                </ul>
            </li>
			<br>
			<br/>
			<li>
                <ul>
                    <li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '드라마존', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/dramazone/');return false;"><font size=2 color="red">드라마존</font></a></li>
                </ul>
            </li>
			<br>
			<br/>
			<li>
                <ul>
                    <li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '컬쳐스테이션', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/_culturestation/culturestation_event.asp?evt_code=97531');return false;"><font size=2 color="red">컬쳐스테이션</font></a></li>
                </ul>
            </li>
			<br>
			<br/>
			<li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=77547');return false;">브랜드위크</a></li>
			<br/><br/>
			<li>
                <input type="text" id="evtcode" name="evtcode">
                <a href="" onclick="fnEventQuickLink();return false;">이벤트바로가기</a>
            </li>
            <li>
                <input type="text" id="evtcode2" name="evtcode2" value="105795">
                <a href="" onclick="fnEventQuickLinkHttps();return false;">이벤트바로가기</a>
            </li>
			<br/>
			<li>
                <ul>
                    <li><font size=2 color="red">딜 상품 테스트</font></li>
					<li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐딜', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/deal/deal.asp?itemid=1832518');return false;"> 아날로그의 감성이 필요해</a></li>
					<li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐딜', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/deal/_deal.asp?itemid=1854322');return false;">멀티스틱/립스틱/틴트/섀도 외 역대급 클리어런스 세일</a></li>
					<li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐딜', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/deal/_deal.asp?itemid=1868882');return false;">말랑 말랑 스퀴시 복숭아</a></li>
					<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=83364');">83364 주말특가 (딜 상품 포함)</a></li>
					<li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], '배송조회', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/order/myshoporderlist.asp');return false;">오프샵 주문조회</a></li>
					<li><a href="javascript:fnAPPpopupProduct(1904980);">상품페이지 팝업 1117379</a></li>
                </ul>
            </li>
			<br>
            <li>
                <ul>
                <a href="/apps/appCom/wish/web2014/playing/">PLAYING</a>
                 </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><a href="javascript:fnAPPpopupProduct('1177009');">선물포장상품리스트상품</a></li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><a href="javascript:fnAPPpopupBrowserURL('선물포장안내','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/gift_recommend.asp');">선물포장상품리스트</a></li>
                </ul>
            </li>
            <br>

            <li>
                <ul>
                    <li><a href="" onclick="fnAPPpopupBrowserURL('기프트카드','<%=wwwUrl%>/apps/appCom/wish/web2014/giftcard/'); return false;">기프트카드</a><li>
                </ul>
            </li>
            <br>

            <li>
                <ul>
                    <li><a href="tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=78423&gaparam=t">tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=78423&gaparam=t</a><li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><a href="tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1632034&gaparam=t">tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1632034&gaparam=t</a><li>
                    <br>
                    <li><a href="tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd_t10.asp?itemid=1632034&gaparam=t" style="color:green;">상품상세 확대 테스트</a><li>
                </ul>
            </li>
            <br>

            <li>
                <ul>
                    <li><a href="tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?rdsite=fbec5&utm_source=facebook&utm_medium=ad&utm_campaign=dpa&term=fbdpa_echo&itemid=1924902&target_url=http://www.10x10.co.kr/shopping/category_prd.asp?rdsite=fbec5&utm_source=facebook&utm_medium=ad&utm_campaign=dpa&term=fbdpa_echo&itemid=1924902">target_url</a><li>
                </ul>
            </li>
            <br>


            <li>
                <ul>
                    <li><a href="tenwishapp://http://m.10x10.co.kr">tenwishapp://http://m.10x10.co.kr</a><li>
                </ul>
            </li>
            <br>

            <li>
                <ul>
                    <li><a href="javascript:fnAPPpopupPlay_URL_TEST('http://m.10x10.co.kr/apps/appCom/wish/web2014/play/playDesignFingers.asp?idx=302&contentsidx=1255');">PLAY TEST</a><li>
                </ul>
            </li>
            <br>

            <!--
            <li>
                <ul>
                    <li><a href="http://webimage.10x10.co.kr/eventIMG/2015/66982/main_mo20151026104321.JPEG"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66982/main_mo20151026104321.JPEG" width=150 alt="이미지1"></a><li>
                </ul>
            </li>
            <br>

            <li>
                <ul>
                    <li><a href="http://webimage.10x10.co.kr/eventIMG/2015/66905/img_slide_01.jpg"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66905/img_slide_01.jpg" width=150 alt="이미지1"></a><li>
                </ul>
            </li>
            <br>

            <li>
                <ul>
                    <li><a href="http://imgstatic.10x10.co.kr/mobile/201510/2052/MnA_Toprolling_5816.jpg"><img src="http://imgstatic.10x10.co.kr/mobile/201510/2052/MnA_Toprolling_5816.jpg" width=150 alt="이미지2"></a><li>
                </ul>
            </li>
            <br>
            -->


            <li>
                <ul>
                    <li><a href="" onclick='fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "장바구니1", [], "http://m.10x10.co.kr/apps/appcom/wish/web2014/inipay/UserInfo_Test.asp", "cart");return false;'>결제 N (80)</a><li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><a href="" onclick='fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "장바구니1", [], "https://m.10x10.co.kr/apps/appcom/wish/web2014/inipay/UserInfo_Test.asp", "cart");return false;'>결제 N (443)</a><li>
                </ul>
            </li>
            <br>

            <li>
                <ul>
                    <li><a href="" onclick='fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "장바구니2", [], "http://m.10x10.co.kr/apps/appcom/wish/web2014/inipay/UserInfo.asp", "cart");return false;'>결제 P (80)</a><li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><a href="" onclick='fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "장바구니2", [], "https://m.10x10.co.kr/apps/appcom/wish/web2014/inipay/UserInfo.asp", "cart");return false;'>결제 P (443)</a><li>
                </ul>
            </li>
            <br>
            <br>
            <li>
                <ul>
                    <li><a href="javascript:callNativeFunction('copyurltoclipboard', {'url':'http://m.10x10.co.kr','message':'복사되었습니다. 붙여넣어주세요.'});">클립보드로 복사(m.10x10.co.kr)</a><li>
                </ul>
            </li>
            <br>
            <br>
            <li>
                <ul>
                    <li><a href="javascript:fnAPPsetNudgeTrack('incrCustParam',2,'wish_count',1);">넛지 incrCustParam</a><li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><a href="javascript:fnAPPsetNudgeTrack('loadNshow',1,'','');">넛지 loadNshow</a><li>
                </ul>
            </li>

            <br>
			<li>-- 앱 크러쉬 재현 --
                <ul>
                    <li><a href="" onclick="fnAPPpopupBrowserURL('앱테스트','<%=wwwUrl%>/apps/appCom/wish/web2014/html/test/test1.asp');return false;">앱크러쉬 test - 작업중</a></li>
                    <br>
                </ul>
            </li>
            <li>
                <ul>
                    <li><a href="" onclick="alert('a');return false;">얼럿</a></li>
                    <br>
                    <li><a href="javascript:alert('a');">얼럿</a></li>
                    <br>
                    <li><a href="javascript:alert(confirm('a'));">컨펌</a></li>


                    <li>
					    <span class="button btM1 btRed cWh1"><a href="" onclick="fnAPPpopupBrowserURL('상품상세 보기','<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd_detail.asp?itemid=1219366'); return false;">상품상세 보기</a></span>
					</li>

                </ul>
            </li>
            <br>
            <li><a href="javascript:fnAPPpopupBrowserURL('lazy test','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain_TTT.asp?eventid=62182');">lazy</a></li>
            <br>
            <li><a href="javascript:fnAPPpopupBrowserURL('scrollcnt','http://m.10x10.co.kr/apps/appCom/pushTest/scrollcnt.html');">scrollcnt.html</a></li>
            <br>
            <li><a href="javascript:fnAPPpopupBrowserURL('scroll test','http://www.10x10.co.kr');">scroll</a></li>

            <br>
            <li><a href="http://m.10x10.co.kr/apps/appCom/wish/web2014/today/index_old.asp">today_old_ver</a></li>


            <br>
            <li><a href="#" onClick="document.location.href='http://testm.10x10.co.kr/html/today/index.asp'">http://testm.10x10.co.kr/html/event/index.asp</a></li>
            <li><a href="#" onClick="TTT(1);return false">TTT</a></li>
            <br><br>
            <li><a href="javascript:fnAPPpopupBrowserURL('타이틀','<%=wwwUrl%>/apps/appCom/wish/web2014/pagelist.asp');">이창 팝업(위)</a></li>
            <br><br>
            <li><a href="javascript:fnAPPpopupBrowserURL('타이틀','<%=wwwUrl%>/apps/appCom/pushTest/ttt.asp');">이창 팝업(위-ttt)</a></li>
            <br><br>
            <li><a href="javascript:fnAPPpopupBrowserURL('타이틀','http://www.10x10.co.kr/common/ttt.asp');">이창 팝업(위-ttt(www))</a></li>
            <br><br>

            <li><a href="javascript:fnAPPpopupBrowserURL('타이틀','<%=M_SSLUrl%>/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp');"> SSL</a></li>
            <br><br>
            <li><a href="#" onClick="document.location.href='<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent_T.asp';">RECTMove</a></li>
            <br>
            <li><a href="#" onClick="document.location.href='<%=wwwUrl%>/apps/appCom/wish/web2014/today/index_test3.asp';">RECTMove_today</a></li>
            <br>
            <li><a href="javascript:fnAPPpopupBrowserURL('RECTPop','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent_T.asp');">RECTPop</a></li>
            <br>
            <li><a href="javascript:fnAPPhideLeftBtns();">팝업창 왼쪽메뉴(뒤로가기,history) 숨기기</a></li>
            <li>&nbsp;</li>
            <li><a href="javascript:fnAPPpopupBrowserURL('타이틀','<%=wwwUrl%>/apps/appCom/wish/web2014/pagelist.asp');">이창 팝업(위)</a></li>
            <li>&nbsp;</li>
            <li><a href="#" onClick="document.location.href='<%=wwwUrl%>/apps/appCom/wish/web2014/pagelist.asp';">이창 이동</a></li>
            <li>&nbsp;</li>
            <li><strong>Cookies</strong>
                <ul>
                    <li>
                    <input type="button" value="[cookies Set]" onClick="location.href='cookieTest.asp'">
                    <%
                        ''response.cookies("TT").domain = "10x10.co.kr"
                        ''response.cookies("TT") = now()

                        response.write "cookies:"&request.cookies("TT")
                    %>
                    </li>
                </ul>
            </li>
            <br>
                <li>--업로드테스트(And 4.4)
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('업노드','<%=wwwUrl%>/apps/appCom/pushtest/uploadtest.asp');"><%=wwwUrl%>/apps/appCom/pushtest/uploadtest.asp</a></li>
                        <br>
                    </ul>
                </li>

            <br>
            <li>
            	<a href="#" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing1.asp'); return false;"><span>상품후기(goodsusing1.asp)</span></a>
            </li>
            <br>
			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://testm.10x10.co.kr/apps/appcom/between/inipay/userinfo.asp');">비트윈장바구니</a></li>
                    <br>
                </ul>
            </li>
            <li><strong>Play index</strong>
                <ul>
                    <li><a href="<%=wwwUrl%>/apps/appcom/wish/web2014/play/">PLAY</a></li>
                </ul>
            </li>
            <br>
			<li><strong>이벤트내용</strong>
                <ul>
                    <li><a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '이벤트', [], '<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=56093');">이벤트</a></li>
                </ul>
            </li>
			<br/>
            <li><strong>13th event</strong>
                <ul>
                    <li><a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '이벤트', [], '<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=55084');">이벤트 팝업(옆)</a></li>
                </ul>
            </li>
            <br>
            <li><strong>13th event</strong>
                <ul>
                    <li><a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '이벤트', [], '<%=wwwUrl%>/apps/appcom/wish/web2014/event/etc/iframe_55082.asp');">이벤트 iFrame(옆)</a></li>
                </ul>
            </li>
            <br>
            <li><strong>ServerVariables</strong>
                <ul>
                    <li><a href="/apps/appCom/pushtest/uagent.asp">/apps/appCom/apps/appCom/pushtest/uagent.asp</a></li>
                </ul>
            </li>
            <br>

            <li><strong>TEST iOS</strong>
                <ul>
                    <li><a href="/apps/appCom/pushtest/contest.asp">/apps/appCom/apps/appCom/pushtest/contest.asp</a></li>
                </ul>
            </li>
            <br>

            <li><strong>Protocol</strong>
                <ul>
                    <li><a href="/apps/appCom/pushtest/protoV2.asp">/apps/appCom/apps/appCom/pushtest/protoV2.asp</a></li>
                </ul>
            </li>
            <br>
            <li><strong>Links</strong> (<%=BASELNK%>)
                <ul>
                    <li>--GNB link - firstconnection 동적 변경
                        <ul>
                        <li>TODAY - <a href="<%=BASELNK%>/today/index.asp">/today/index.asp</a></li>
                        <li>BEST - <a href="<%=BASELNK%>/award/awarditem.asp">/award/awarditem.asp</a></li>
                        <li>EVENT - <a href="<%=BASELNK%>/event/eventmain.asp">/event/eventmain.asp</a></li>
                        <li>WISH - <a href="<%=BASELNK%>/wish/index.asp">/wish/index.asp</a></li>
                        <li>PLAY - <a href="<%=BASELNK%>/play/index.asp">/play/index.asp</a></li>
                        <li>SALE - <a href="<%=BASELNK%>/sale/saleitem.asp">/sale/saleitem.asp</a></li>
                        <li>CLASS - <a href="<%=BASELNK%>/event/gnbeventmain.asp?eventid=80684">evt80684</a></li>
                        </ul>
                    </li>
                    <br>
                    <li>--LNB link
                        <ul>
                            <li>장바구니 - <a href="<%=BASELNK%>/inipay/ShoppingBag.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBaguni();return false;">POP</a></li>
                            <li>HOME - GNB's top default</li>
                            <li>카테고리 - <a href="<%=BASELNK%>/category/category_sub.asp?disp=104">LINK</a>  &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupCategory('101101');return false;">POP</a></li>
                            <li>브랜드 - <a href="<%=BASELNK%>/street/index.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('브랜드','<%=wwwUrl%>/<%=BASELNK%>/street/index.asp');return false;">POP</a></li>
                            <li>로그인 - [APP]</li>
                            <li>회원가입 - <a href="<%=BASELNK%>/member/join.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/<%=BASELNK%>/member/join.asp');return false;">POP</a></li>
                            <li>아이디 - <a href="<%=BASELNK%>/member/find_id.asp">LINKp</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('아이디 찾기','<%=wwwUrl%>/<%=BASELNK%>/member/find_id.asp');return false;">POP</a></li>
                            <li>비번찾기 - <a href="<%=BASELNK%>/member/find_pw.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('비밀번호 찾기','<%=wwwUrl%>/<%=BASELNK%>/member/find_pw.asp');return false;">POP</a></li>
                            <li>주문배송 - <a href="<%=BASELNK%>/my10x10/order/myorderlist.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('주문배송 조회','<%=wwwUrl%>/<%=BASELNK%>/my10x10/order/myorderlist.asp');return false;">POP</a></li>
                            <li>최근본상품 - <a href="<%=BASELNK%>/my10x10/mytodayshopping.asp?itemarr=212323,123123,1231223,42123">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('최근본상품','<%=wwwUrl%>/<%=BASELNK%>/my10x10/mytodayshopping.asp?itemarr=212323,123123,1231223,42123');return false;">POP</a></li>
                            <li>최근본컨텐츠 - <a href="<%=BASELNK%>/my10x10/myrecentview.asp?itemarr=212323,123123,1231223,42123">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('최근 본 컨텐츠','<%=wwwUrl%>/<%=BASELNK%>/my10x10/myrecentview.asp?itemarr=212323,123123,1231223,42123');return false;">POP</a></li>
                            <li>마이텐바이텐 - <a href="<%=BASELNK%>/my10x10/mymain.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=BASELNK%>/my10x10/mymain.asp');return false;">POP</a></li>
                            <li>텐텐 초이스 - <a href="<%=BASELNK%>/shoppingtoday/10x10choice.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('텐텐 초이스','<%=wwwUrl%>/<%=BASELNK%>/shoppingtoday/10x10choice.asp');return false;">POP</a></li>
                            <br>
                            <li>우수회원샵 - <a href="<%=BASELNK%>/my10x10/special_shop.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('우수회원샵','<%=wwwUrl%>/<%=BASELNK%>/my10x10/special_shop.asp');return false;">POP</a></li>
                            <li>VIP LOUNGE - <a href="#" onClick="fnAPPpopupBrowserURL('VIP LOUNGE','<%=wwwUrl%>/<%=BASELNK%>/my10x10/viplounge.asp');return false;">POP</a></li>
                            <br>
                            <li>비회원주문조회 - <a href="<%=BASELNK%>/login/login_nonmember.asp">LINK</a> &nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('비회원로그인','<%=wwwUrl%>/<%=BASELNK%>/login/login_nonmember.asp');return false;">POP</a></li>
                            <br>
                            <li>로그아웃 - <a href="<%=wwwUrl%>/apps/appCom/wish/protov2/dologout.asp">LINK</a></li>
                        </ul>
                    </li>
                    <br>
                    <li>--설정 관련 link
                        <ul>
                            <li>이용약관 - <a href="<%=BASELNK%>/member/pop_viewUsageTerms.asp">LINK</a>&nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('이용약관','<%=wwwUrl%>/<%=BASELNK%>/member/pop_viewUsageTerms.asp');return false;">POP</a></li>
                            <li>개인정보 취급방침 - <a href="<%=BASELNK%>/member/pop_viewPrivateTerms.asp">LINK</a>&nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupBrowserURL('개인정보 취급방침','<%=wwwUrl%>/<%=BASELNK%>/member/pop_viewPrivateTerms.asp');return false;">POP</a></li>
                            <li>회원탈퇴 완료페이지 - <a href="#" onClick="fnAPPpopupBrowserURL('회원탈퇴','<%=wwwUrl%>/<%=BASELNK%>/my10x10/userinfo/withdrawDone.asp');return false;">pop</a></li>
                        </ul>
                    </li>
                    <br>
                    <li>--기타 참고용 link
                        <ul>
                            <li>상품페이지 - <a href="<%=BASELNK%>/category/category_itemPrd.asp?itemid=1119612">LINK</a>&nbsp;&nbsp;|&nbsp;&nbsp;  <a href="#" onClick="fnAPPpopupProduct('1119612');return false;">POP</a></li>
                            <br>
                            <li>팝업 배너 - <a href="<%=BASELNK%>/event/banner/appEventBanner.asp">LINK</a></li>
                        </ul>
                    </li>
                 </ul>
            </li>
            <br>
            <li><strong>custom Protocol - </strong>
                <ul>
                <li>--신규방식
                    <ul>
                        <li><a href="javascript:fnAPPpopupLogin();">로그인창 호출(완료시 부모창 reload)</a></li>
                        <li><a href="javascript:fnAPPpopupLogin('<%=wwwUrl%>/');">로그인창 호출 (완료시 backpath 이동)</a></li>
                        <li><a href="javascript:fnAPPpopupLogin('none');">로그인창 호출 (완료시 액션 없음)</a></li>

                        <li><a href="javascript:fnAPPLogout();">로그아웃</a></li>

                        <li><a href="javascript:fnAPPsetCartNum(3);">장바구니 숫자 변경</a></li>
                        <li><a href="javascript:fnAPPpopupCategory('103108');"><strong>카테고리 바로가기 (arg-categoryid 하나로변경됨)</strong></a></li>
                        <li><a href="javascript:fnAPPpopupCategory_OLD('103','103108','','캠핑/트래블','아웃도어','');">카테고리 바로가기 (구 방식)</a></li>


                        <li><a href="javascript:fnAPPgetDeviceInfo();">get uuid </a></li>
                        <li><a href="javascript:fnAPPgetDeviceInfo();">get psid </a></li>
                        <li><a href="javascript:fnGetAppVersion();">get version</a></li>
                        <li><a href="javascript:fnAPPgetDeviceInfo();">get nudgeUid</a></li>
                        <li><a href="javascript:fnAPPpopupExternalBrowser('http://pinterest.com/pin/create/button/?url=link&media=img');">외부 브라우져 호출 </a> (SNS 호출,파일 다운로드 등에 사용)  </li>
                        <li><a href="javascript:fnAPPsetOrderNum(2);">LNB 주문배송조회 숫자변경</a></li>
                        <li><a href="javascript:fnAPPsetOrderNum('a');">LNB 주문배송조회 숫자변경_T</a></li>
                        <li><a href="javascript:fnAPPsetMyIcon(3);">마이 아이콘 변경 </a></li>
                        <li><a href="javascript:fnAPPsetMyCouponNum(5);">마이 쿠폰 갯수 변경</a></li>
                        <li><a href="javascript:fnAPPsetMyMileageNum(5123);">마이 마일리지 변경 </a></li>
                        <li><a href="javascript:fnAPPaddRecentlyViewedProduct(98989);">LNB 최근본상품 추가 </a></li>
                        <li><a href="javascript:fnAPPselectGNBMenu('best','<%=wwwUrl%>/apps/appCom/wish/web2014/award/awarditem.asp?disp1=106');">메뉴 변경 및 URL 이동 </a></li>
                        <li><a href="javascript:fnAPPpopupBrand('mmmg');">브랜드 상품페이지 이동</a></li>
                        <li><a href="javascript:fnAPPclosePopup();">현재 팝업페이지 닫기</a>(팝업된 웹뷰 내에서 호출)</li>

                        <br>2014/09/21 이후 추가/변경
                        <li><a href="javascript:fnAPPchangPopCaption('캡션 caption');">현재 팝업페이지 캡션변경</a>(팝업된 웹뷰 내에서 호출) param:caption 임(기존오타)</li>
                        <li><a href="javascript:fnAPPaddWishCnt('670150',1);">호출한 원래 App의 wish 수량 변경</a></li>
                        <li><a href="javascript:fnAPPgetRecentlyViewedProducts();"><strong>최근본상품목록 Array</strong></a> (마이텐바이텐-오늘본상품 에서필요)</li>
                        <li>로그인 API backpath 추가됨(none:로그인 완료후 액션없음, '':부모창 리로드, '경로':부모창 경로변경)</li>

                        <li><a href="javascript:fnAPPhideTitle();">팝업창 타이틀 감추기(웹뷰 영역증가)</a> - 검토중</li>
                        <li><a href="javascript:fnAPPshowTitle();">팝업창 타이틀 다시 보이기</a> - 검토중</li>
                        <br><strong>2014/09/23 이후 추가/변경</strong>
                        <li><a href="javascript:fnAPPpopupBrowserURL('카테고리','<%=wwwUrl%>/apps/appCom/wish/web2014/opentest.asp');">TEST 팝업</a></li>
                        <br>
                        <li><a href="javascript:fnAPPopenerJsCall('funcTEST(\'aaa\',\'한글\',\'<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=670150&disp=101109108101\')');">부모창 js 호출</a></li>
                        <br>
                        <li><a href="javascript:funcTEST('aaa','한글','<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=670150&disp=101109108101');"> js 결과</a></li>
                        <br>
                        <li><a href="javascript:fnAPPpopupSearch('우산');"><strong>검색-우산</strong></a></li>
                        <br>
                        <li><a href="javascript:fnAPPpopupSearch('우산 걸이');"><strong>검색-우산 걸이</strong></a></li>
                        <br>
                        <li><a href="javascript:fnAPPsetTrackLog('event','iEvtName_Sample');"><strong>로그분석-event</strong></a></li>
                        <br>
                        <li><a href="javascript:fnAPPsetTrackLog('purchase','텐바이텐상품',1000);"><strong>로그분석-purchase</strong></a></li>
                        <br>
                        <li><a href="javascript:fnAPPsetTrackLog('conversion','iconversionName_Sample');"><strong>로그분석-conversion</strong></a></li>
                        <br>

                        <br>
                        <li><a href="javascript:setTimeoutTEST();"><strong>setTimeoutTEST</strong></a></li>
                        <br>
						<%
							Dim appboypurchase, appboyitemid, appboycode, appboyprice, appboyquantity
							appboyitemid = "2342342"
							appboycode = "KRW"
							appboyprice = 5999
							appboyquantity = 1

							appboypurchase = "[{'productId' : '"&appboyitemid&"', 'currencyCode' : '"&appboycode&"', 'price':"&appboyprice&", 'quantity':"&appboyquantity&" }]"

							appboypurchase = Replace(appboypurchase, "'", "\""")
						%>
						<li><a href='javascript:fnAppBoyPurchasedd("<%=appboypurchase%>");' >appboyTest</a></li>


                    </ul>
                </li>
                <br>
                <li>--응용
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('타이틀','<%=wwwUrl%>/apps/appCom/wish/web2014/pagelist.asp');">이창 팝업(위)</a></li>
                        <br>
                        <li><a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '타이틀', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/pagelist.asp');">이창 팝업(옆)</a></li>
                        <br>
                        <li><a href="javascript:fnAPPpopupProduct(1117379);">상품페이지 팝업 1117379</a></li>
                        <br>
                        <li><a href="javascript:fnAPPpopupProduct(123123);">상품페이지 팝업 123123(사용안함)</a></li>
                        <br>
                        <li><a href="javascript:fnAPPpopupProduct(483339);">상품페이지 팝업 483339</a></li>

                        <br>
                        <li><a href="javascript:fnAPPpopupEvent(55012);">이벤트 팝업 55012</a></li>


                        <br>
                        <li><a href="javascript:fnAPPpopupBaguni();">장바구니 팝업 </a></li>

                        <br>
                        <li><a href="javascript:alert('1');">얼랏1</a></li>
                        <br>
                        <li><a href="#" onClick="alertTEST();return false;">얼랏2</a></li>
                        <br>
                        <li><a href="#" onClick="confirm('2');return false;">컨펌</a></li>
                        <br>
                        <li><a href="#" onClick="confirmTEST();return false;">컨펌2</a></li>
                    </ul>
                </li>
                <br>
                <li>--이벤트테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupEvent(55074);">13th 메인</a></li>
                        <br>
                    </ul>
                </li>
                <li><a href="javascript:fnAPPpopupBrowserURL('이벤트 목록','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp');">이벤트 목록</a></li>
                <br>
                <li>--shoppingchance_allevent.asp
                    <ul>
                        <li><a href="http://testm.10x10.co.kr/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp" target="_top">/shoppingtoday/shoppingchance_allevent.asp</a></li>
                        <br>
                    </ul>
                </li>

                <br>
                <li>--다이어리2015테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2015/');">메인
                        <li><a href="javascript:fnAPPpopupBrowserURL('다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2015/today.asp');">투데이
                        <li><a href="javascript:fnAPPpopupBrowserURL('다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2015/event.asp');">이벤트
                        <br>
                    </ul>
                </li>
                <li>--다이어리2016테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2016 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2016/');">실섭실섭실섭실섭
                        <li><a href="javascript:fnAPPpopupBrowserURL('2016 다이어리','http://testm.10x10.co.kr/apps/appCom/wish/web2014/diarystory2016/');">테섭테섭테섭테섭
                        <br>
                    </ul>
                </li><br>
                <li>--다이어리2017테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2017 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2017/');">실섭실섭실섭실섭<br>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2017 다이어리','http://testm.10x10.co.kr/apps/appCom/wish/web2014/diarystory2017/');">테섭테섭테섭테섭

                        	<br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=73636');">이벤트팝업 다이어리</a></li>
                        <br>
                    </ul>
                </li>
                <li>--다이어리2018테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2018 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2018/');">실섭실섭실섭실섭<br>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2018 다이어리','http://testm.10x10.co.kr/apps/appCom/wish/web2014/diarystory2018/');">테섭테섭테섭테섭

                        	<br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=73636');">이벤트팝업 다이어리</a></li>
                        <br>
                    </ul>
                </li>
                <li>--다이어리2019테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2019 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2019/');">다이어리스토리 메인</li>
                        <br>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2019 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2019/search.asp');">다이어리스토리 검색</li>
                        <br>
                        <br>
                    </ul>
                </li>
                <li>--다이어리2020테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2020 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2020/');">다이어리스토리 메인</li>
                        <br>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2020 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2020/search.asp');">다이어리스토리 검색</li>
                        <br>
                        <br>
                    </ul>
                </li>
                <li>--다이어리2021테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2021 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2021/');">다이어리스토리 메인</li>
                        <br>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2021 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2021/search.asp');">다이어리스토리 검색</li>
                        <br>
                        <br>
                    </ul>
                </li>
                <li>--다이어리2022테스트
                    <ul>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2022 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2022/index.asp');">다이어리스토리 메인</li>
                        <br>
                        <li><a href="javascript:fnAPPpopupBrowserURL('2022 다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2022/search.asp');">다이어리스토리 검색</li>
                        <br>
                        <br>
                    </ul>
                </li>
                <br>
                <li>--pageSample.asp
                    <ul>
                        <li><a href="pageSample.asp"><%=wwwUrl%>/apps/appCom/wish/web2014/pageSample.asp</a></li>
                        <br>
                    </ul>
                </li>

                <li>--noSwipe
                    <ul>
                        <li><a href="today/index_test.asp"><%=wwwUrl%>/apps/appCom/wish/web2014/today/index_test.asp</a></li>
                        <br>
                    </ul>
                </li>
				<li>
                    <ul>
                        <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/play/playGround_review.asp?idx=20&contentsidx=84');">엄마에게 사랑의 메세지를 남겨주세요</a></li>
                        <br>
                    </ul>
                </li>
				<li>
					<ul>
						<li><a href="javascript:agentchk();">script app&mobile 구분</a></li>
					</ul>
				</li>

				<li>
					<ul>
						<li><a href="javascript:fnAPPpopupChance_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/chance/index.asp');">chance</a></li>
					</ul>
				</li>
				<li>--72336 NPay
	                <ul>
	                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=72336');">72336 NPay</a></li>
	                    <br>
	                </ul>
	            </li>
				<li>--72232 VIP 컬쳐스테이션
	                <ul>
	                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=72232');">72232 VIP 컬쳐스테이션 링크 테스트</a></li>
	                    <br>
	                </ul>
	            </li>

				<li>-- 투데이 리뉴얼
                    <ul>
                        <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/today/index2.asp');">투데이리뉴얼</a></li>
                        <br>
                    </ul>
                </li>
				<li>-- 레코벨 테스트용 상품상세 테섭
                    <ul>
                        <li><a href="javascript:fnAPPpopupProduct_URL('http://testm.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1234663');">레코벨 테스트용 상품상세 테섭</a></li>
                        <br>
                    </ul>
                </li>
				<li>-- 레코벨 테스트용 장바구니 테섭
                    <ul>
                        <li><a href="javascript:fnAPPpopupProduct_URL('http://testm.10x10.co.kr/apps/appCom/wish/web2014/inipay/shoppingbag.asp');">레코벨 테스트용 장바구니 테섭</a></li>
                        <br>
                    </ul>
                </li>
			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://testm.10x10.co.kr/apps/appCom/wish/web2014/inipay/ShoppingBag.asp');">장바구니(태섭)</a></li>
                    <br>
                </ul>
            </li>

			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/mytester/');">테스터후기(실섭)</a></li>
                    <br>
                </ul>
            </li>

            <li>--상품상세 동영상 테스트
                <ul>
                    <li><a href="javascript:fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1444424');">상품상세 테스트<br>
                    <br>
                </ul>
            </li>

            <li>--클리어런스세일
                <ul>
                    <li><a href="javascript:fnAPPpopupBrowserURL('ClearanceSale','<%=wwwUrl%>/apps/appCom/wish/web2014/clearancesale/');">실섭실섭실섭실섭<br>
                    <li><a href="javascript:fnAPPpopupBrowserURL('ClearanceSale','http://testm.10x10.co.kr/apps/appCom/wish/web2014/clearancesale/');">테섭테섭테섭테섭
                    <br>
                </ul>
            </li><br>


			<li>
                <ul>
                    <li><font size=2 color="red">----------- 이벤트 테스트 영역 시작-------------</font></li>
                </ul>
            </li>

			<li>
                <ul>
                    <li><font size=2 color="red">--17주년 이벤트--</font></li>
                </ul>
            </li>        
			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/17th/');">17주년 메인</a></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('코멘트이벤트', 'http://m.10x10.co.kr/event/17th/comment.asp');"></a></li>                    						
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88939');">매일리지 1차</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89076');">매일리지 2차</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89305');">100원으로 인생역전</a></li>                    
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89541');">md픽</a></li>                    
                    <li><a href="javascript:fnAPPpopupBrowserURL('잘사고 잘받자','<%=wwwUrl%>/apps/appcom/wish/web2014/event/17th/gift.asp');">잘사고 잘받자</a></li>
                    <li><a href="javascript:fnAPPpopupBrowserURL('텐퀴즈','<%=wwwUrl%>/apps/appcom/wish/web2014/tenquiz/quizmain.asp');">텐퀴즈</a></li>                    
                    <li><a href="#" onclick="fnAPPselectGNBMenu('diary','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2019/index.asp?gnbflag=1'); return false;">다이어리스토리</a></li>
                    <br>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/17th/index2.asp');">17주년 메인테스트페이지</a></li>
                </ul>
            </li>            
			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88939');">매일리지 1차</a></li>
                    <br>
                </ul>
            </li>
			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89076');">매일리지 2차</a></li>
                    <br>
                </ul>
            </li>
            <br />
            <br />
            <br />
            <br />
            <br />

			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/16th/pickshow.asp');">[텐쑈] 뽑아주쑈!</a></li>
                    <br>
                </ul>
            </li>
			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=80389');">릴레이 마일리지</a></li>
                    <br>
                </ul>
            </li>

			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://testm.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66020');">이벤트 메인 테스트</a></li>
                    <br>
                </ul>
            </li>


			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69435');">기프트카드</a></li>
                    <br>
                </ul>
            </li>

            <li><a href="javascript:fnAPPpopupEvent_URL('http://testm.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66021');">오늘은 털날 - 테스트서버</a></li>


			 <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=84691');">사대천왕</a></li>
			 <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69631');">웨딩코멘트배너</a></li>
			 <br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69627');">첫구매 & 연속구매</a></li>
			 <br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69628');">첫구매 방가방가</a></li>
			 <br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69634');">연속구매 주문을외쳐방</a></li>
			 <br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69698');">김수현 시즌 그리팅</a></li>
			 <br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69690');">4대천왕</a></li>
			 <br><li><a href="javascript:fnAPPpopupEvent_URL('http://testm.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66073');">4대천왕test</a></li>
			 <br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69768');">청첩장등록</a></li><br>

            <br><li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=69886');">추가배너 이미지 테스트 이벤트</a></li><br>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96480');">##링크 테스트</a></li>


			<li><font size=2 color="red">----------- 기획전 &amp; 이벤트 ------------</font></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88286');">88286 패션위크</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88182');">88182 네일펜으로 금손되자</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85745');">85745 텐텐쇼퍼3기</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85857');">85857 JMW</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85935');">85935 LOOK IT</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85819');">85819 하나멤버스 앱 설치 이벤트</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85939');">85939 TV와 사랑에 빠진 당신의 MUST HAVE 7</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=84447');">84447 동영상 test(vimeo)</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85857');">85857 동영상 test(youtube)</a></li>
			<li><a href="javascript:fnAPPpopupSearchOnNormal('트러플오일');"><strong>검색-트러플오일 스크립트</strong></a></li>
			<li><a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=트러플오일">검색-트러플오일 url</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86069');">86069 MULTI 3</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86026');">86026 이영자</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=82160');">팝업 테스트</a></li>
			<li><a href="http://m.10x10.co.kr/apps/link/?11720180510">드라마존 앱 URL 통합관리 test</a></li>
			<li><a href="/apps/appCom/wish/web2014/dramazone/index.asp">앱 url</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86497');">86497 SBS 드라마존 런칭 이벤트</a></li>
			<li><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐딜', [BtnType.SHARE, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/deal/deal.asp?itemid=1971898');return false;"> 딜코드</a></li>
			<li><a href="javascript:fnAPPpopupCategory('117102102');">카테고리 리스트</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87294');">87294 [멀티3] Fan페어</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87295');">87295 김비서도 김공무원도 ok</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87481');">87481 워터파크 VS 겨터파크</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87296');">87296 수박</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87630');">87630 [멀티3]</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87416');">87416 how to make summer</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87744');">87744 넣고, 누르고, 마시고 한번에</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87730');">87730 [멀티3] 7/13</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87731');">87730 [멀티3] 7/16</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87836');">87836 SUMMER VACATION</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87829');">87829 일상속에 스며드는 작품</a></li>
        	<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87847');">87847 스타일의 완성 SNRD</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87810');">87810 7월 구매사은</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87732');">87732 [멀티3] 7/17</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87734');">87734 [멀티3] 7/19</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87759');">87759 히치하이커</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87735');">87735 [멀티3] 7/20</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87849');">87849 summer week</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87736');">87736 [멀티3] 어글리 대란</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88134');">88134 매니아데이</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88034');">88034 [멀티3] 냉방병</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=87941');">텐텐백서</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88036');">88036 [멀티3] 여름 화장품</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88037');">88037 [멀티3] 모발관리j</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88176');">88176 텐텐쇼퍼</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88079');">88079 텐리단길</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88035');">88035 [멀티3] 몰디브</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88366');">88366 mkt wallpaper</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88401');">88401 물만 뿌려주면 위생걱정 끝</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88492');">88492 잔스포츠</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88578');">88578 매니아 digital</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88359');">88359 [멀티3] 바캉스 그 이후</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88421');">88421 두근두근 신학기, 첫 출근 맞이 집꾸미기</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88673');">88673 8/21 multi3</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88715');">88715 [컬쳐]나는 코코카피탄, 오늘을 살아가는 너에게</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88669');">88669 가을 트렌디 컬러, 라일락</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88670');">88670 멀티3</a></li>
   			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88837');">88837 더블마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88637');">88637 아리따움 10주년 이벤트</a></li>
   			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88678');">88678 멀티3</a></li>
   			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88928');">88928 패션위크</a></li>
   			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89005');">89005 굿템어워드</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88831');">88831 HITCHHIKER vol.71</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88831');">91578 HITCHHIKER vol.73</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88831');">92875 HITCHHIKER vol.74</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93186');">93186 HITCHHIKER 정기구독</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89168');">89168 [컬쳐]크리스토퍼 로빈(곰돌이 푸 다시 만나 행복해)</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88410');">88410 신상다반사 #데일리라이크</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89199');">89199 FASHION / BEAUTY WEEKLY ROOKIE!</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89231');">88998 굿아이템어워드 : 국민 육아템</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89964');">89964 VVIP사은품이벤트</a></li>
            <li><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '2019 다이어리', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2019/');return false;">다이어리스토리 새창</a></li>
            <li><a href="#" onclick="fnAPPselectGNBMenu('diary','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2019/index.asp?gnbflag=1'); return false;">다이어리스토리 지엔비</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90183');">90183 패션위크</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90303');">90303 아이폰이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89497');">89497 매니아데이</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89162');">89162 매니아데이2</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90806');">90806 패션위크</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101761');">101761 디즈니 앱다운</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101761');">90806 패션위크</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101962');">101962 부모님이 선택한 선물 1위, 용돈봉투!</a></li>

			<li><font size=2 color="red">----------- 크리스마스 ------------</font></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=81815');">81815 크리스마스</a></li>

			<li><font size=2 color="red">----------- 텐큐베리감사 ------------</font></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85144');">85144 메인</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85145');">85145 100원의 기적</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85146');">85146 매일리지</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85147');">85147 텐큐베리박스</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85148');">85148 천백만원</a></li>
			<li><a href="javascript:fnAPPpopupPlay_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/playing/sub/vol040main.asp?isadmin=o&didx=237&state=7&sdate=2018-05-08');">텐퀴즈</a></li>
			<li><a href="javascript:fnAPPpopupPlay_URL('http://m.10x10.co.kr/playing/view.asp?isadmin=o&didx=237&state=7&sdate=2018-05-08');">텐퀴즈모바일</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89454');">89454 카테고리쿠폰이벤트</a></li>
			<li><a href="javascript:fnAPPpopupPlay_URL('http://m.10x10.co.kr/event/etc/layerbanner/mkt_coupon_banner.asp');">쿠폰테스트</a></li>
            <li><a href="javascript:fnAPPpopupBrowserURL('바로배송','<%=wwwUrl%>/apps/appCom/wish/web2014/event/etc/baroquick/','right','','sc');">바로배송 기획전</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89063');">89063 추석쿠폰</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90144');">90144 위시리스트이벤트</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90292');">90292 앱쿠폰이벤트</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90519');">90519 천원의기적2</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90660');">90660 CRM 등급승격 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90662');">90662 캣앤독 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90726');">90726 12월의 구매사은품 이벤트</a></li>            
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90829');">90829 천원의기적3</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=90905');">90905 호로요이이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91395');">91395 호로요이이벤트2차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=81998');">81998 lucky3</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91229');">91229 lucky4</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91172');">91172 천원의기적4</a></li>            
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91528');">91528 언박싱콘테스트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91629');">91629 천원의기적5</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91397');">91397 선물, 말</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91819');">91819 PUBLY 독서하기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=92154');">92154 월페이퍼 개선 테스트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=92199');">92199 튜터링 영어공부</a></li>                        
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91956');">91956 마이다노 다이어트</a></li>                        
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=92309');">92309 마일리지 2019</a></li> 
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=92388');">92388 언박싱콘테스트2차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=92571');">92571 봄맞이 설문 이벤트</a></li>                       
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93081');">93081 스페셜 마일리지</a></li> 
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93258');">93258 성인상품</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/etc/parentmocktest.asp');">91452 부모님 모의고사</a></li>        
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94337');">94337 3333 마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94436');">94436 행운의편지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94433');">94433 더블마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93492');">93492 아이폰X blur test</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94521');">94521 가장 자연에 가까운 소재로</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94339');">94339 토토로</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94534');">94534 JAJU 써큘레이터</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94813');">94813 매일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94919');">94919 JAJU 선풍기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=94853');">94853 토이스토리4</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95252');">95252 하루 마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95316');">95316 백원 자판기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95524');">95524 6월 구매사은품</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95454');">95454 츄삐의 여름휴가 계획</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95733');">95733 3333마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95871');">95871 쿠폰전</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95815');">95815 대림미술관</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96063');">96063 비밀번호</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96191');">96191 댕댕이와 함께가는 호캉스!</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95866');">95866 7월의 문화생활</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96219');">96219 100원 마일리지 신청페이지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96221');">96221 100원 마일리지 발급페이지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96304');">96304 3333마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96333');">96333 행운의 편지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96220');">96220 K현대미술관 - 8월</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96413');">96413 와이파이 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/benefit/');">신규회원혜택</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96682');">추석보너스</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96367');">96367 인스타그램 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96769');">96769 다꾸티비</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96941');">96941 3333마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97105');">97105 달님 소원을 들어주세요!</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97329');">97329 todolist</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97493');">97493 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97971');">97971 롯데 뮤지엄 스누피</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97824');">97824 둘을 위한 집</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98366');">98366 리마인드쿠폰</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98339');">98339 2020 다이어리 이벤트 </a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98702');">98702 1111마일리지</a></li>  
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98568');">98568 블랙프라이데이 디지털/가전</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98740');">98740 메리라이트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98870');">98870 블랙프라이데이 디지털/가전(3번째)</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99034');">99034 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98974');">98974 크리스마스 선물 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99225&isTest=1');">99225 2019크리스박스</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99159');">99159 패션/뷰티 할인 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97629');">97629 MKT 푸시동의</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99363');">99363 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99403');">99403 카카오프렌즈 할인 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99318');">99318 리틀히어로 할인 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99611');">99611 텐텐 쇼핑 대상</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99678');">99678 소원을 담아봐</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99723');">99723 오뚜기 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100019');">100019 2020마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100138');">100138 득템이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100420');">100420 바꿔방이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100555');">100555 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100761');">100761 텐X텐 쿠폰</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100731');">100731 Flex이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100925');">100925 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101083');">101083 마일리지 알림 신청</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101084');">101084 마일리지 알림 받기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101180');">101180 방탈출 비밀번호 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101252');">101252 지금 가장 인기 있는 꿀쿠폰 상품</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101230');">101230 박스테이프 공모전</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101438');">101438 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101437');">101437 득템하기 좋은 날</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101392');">101392 마일리지 알림 신청</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101393');">101393 마일리지 알림 받기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101991');">101991 100원 자판기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102152');">102152 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102084');">102084 오늘의 꽃</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102078');">102078 부모님 모의고사</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102306');">102306 매일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102519');">102519 사과줍줍</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96459');">96459 추석선물</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102611');">102611 AGV이름짓기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102578');">102578 시원한 커피</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102808');">102808 마니또가 대신 결제</a></li>
            <li><a href="#" onclick="fnAPPselectGNBMenu('justsold','http://m.10x10.co.kr/apps/appCom/wish/web2014/justsold/index.asp?gnbflag=1'); return false;">방금판매된GNB</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103060');">103060 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103029');">103029 텐텐 분실물 센터</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102739');">102739 카카오톡 친구추가 마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103142');">103142 팬스티벌</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103229');">103229 인스타그램 팔로우</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103392');">103392 1일 1줍</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103450');">103450 여름에 뭐 입지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103765');">103765 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103766');">103766 에어팟 자판기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104006');">104006 고민을 들어줘</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104071');">104071 텐바이텐X텐텐쇼퍼 11기 </a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104175');">104175 단 2일간 6,000원 할인받는 팁</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103915');">103915 양/우산</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104371');">104371 타임세일</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104374');">104374 줍줍이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104719');">104719 마일리지 2000</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=1');">104741 매일리지 1일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=2');">104741 매일리지 2일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=3');">104741 매일리지 3일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=4');">104741 매일리지 4일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=5');">104741 매일리지 5일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=6');">104741 매일리지 6일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=7');">104741 매일리지 7일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=8');">104741 매일리지 8일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104741&checkday=9');">104741 매일리지 9일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104812');">104812 메몽 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104828');">104828 첫 구매 에어팟2</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104895');">104895 줍줍 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104895&teaser=Y');">104895 줍줍 이벤트 티저</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104828');">104828 첫 구매 에어팟2</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105018');">105018 텐바이텐X로우로우</a></li>            
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105230');">105230 2222 마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105235');">105235 푸시동의 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105293');">105293 줍줍 이벤트</a></li>            
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105176');">105176 정담추석</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105454');">105454 일리</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105500');">105500 달님 소원을 들어주세요!(장바구니이벤트)</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105514');">105514 9월 쇼핑혜택</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105709');">105709 보따리 주인을 찾습니다(데일리라이크제휴이벤트)</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105778');">105778 다이어리스토리</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105907');">105907 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105992');">105992 애플워치 줍줍</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105992&teaser=Y');">104895 애플워치 줍줍 티저</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=1');">106014 매일리지 1일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=2');">106014 매일리지 2일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=3');">106014 매일리지 3일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=4');">106014 매일리지 4일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=5');">106014 매일리지 5일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=6');">106014 매일리지 6일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=7');">106014 매일리지 7일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=8');">106014 매일리지 8일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106014&checkday=9');">106014 매일리지 9일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106294');">106294 런드리맷</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106295');">106295 런드리맷 오픈</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105918');">105918 그림일기장</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106171');">106171 주방정리</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106597');">106597 텐텐쿠폰12</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106511');">106511 득템의 기회</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106515');">106515 2222마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106761');">106761 신한 체크카드 프로모션</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106952');">106952 오구오구2 득템의기회</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106538');">106538 매일매일 쫄깃쫄KIT</a></li>
            <li><a href="javascript:fnAPPpopupProduct('3914');">106538 매일매일 쫄깃쫄KIT 상품찾기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107158');">107158 3000 마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107102');">107102 11을 뽑아봐</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107439');">107439 반짝 2000 마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107214');">107214 놀러와! 우리의 다꾸홈카페로!</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107401');">107401 크리스마스 코멘트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107535');">107535 첫 구매 SHOP season2</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107751');">107751 다이어리=텐바이텐</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107647');">107647 다이어리 무료배포 이벤트 티저</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107649');">107649 다이어리 무료배포 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/christmas/index.asp');">2020크리스마스</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107818');">107818 3000 마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107776');">107776 크리스박스</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107990');">107990 파티 키트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108209');">108209 마일리지 2000</a></li>
            <li>
                <ul>
                    <li>
                        <script>
                            var testCheckDate2 = "";
                            var testCheckHour2 = "";
                            var testCheckMin2 = "";
                            
                            function goTest2(service) {
                                if (testCheckDate2 == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if (testCheckHour2 == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }

                                if (testCheckMin2 == "") {
                                    alert("날짜를 선택해주세요");
                                    return;
                                }
                                
                                if(confirm(testCheckDate2 +' '+testCheckHour2+':'+testCheckMin2+' 일정으로 테스트를 진행 합니다.')) {
                                        return fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+ service +'&testCheckDate='+testCheckDate2 +'%20 ' + testCheckHour2+':'+testCheckMin2);
                                }
                            }
                        </script>
                        
                    </li>
                    <li style="padding-top:20px;padding-bottom:20px;">
                        <span style="color:red">↓↓↓</span> 다이어리 무료배포2 날짜 선택 <span style="color:red">↓↓↓</span>
                        <br/><br/>
                        <select name="testCheckDate2" onchange="{testCheckDate2 = this.value; document.getElementById('testCheckDate2').innerHTML = this.value;}">
                            <option value="">Date</option>
                            <% dim daysNumber2
                                for daysNumber2 = 11 to 17
                                    if len(daysNumber2) = 1 then daysNumber2 = "0"& daysNumber2
                            %>
                            <option value="2020-12-<%=daysNumber2%>">2020-12-<%=daysNumber2%></option>
                            <%  next %>
                        </select>
                        <select name="testCheckHour2" onchange="{testCheckHour2 = this.value; document.getElementById('testCheckHour2').innerHTML = this.value;}">
                            <option value="">Time</option>
                            <% dim hoursNumber2
                                for hoursNumber2 = 0 to 23
                                    if len(hoursNumber2) = 1 then hoursNumber2 = "0"& hoursNumber2
                            %>
                            <option value="<%=hoursNumber2%>"><%=hoursNumber2%></option>
                            <%  next %>
                        </select>
                        <select name="testCheckMin2" onchange="{testCheckMin2 = this.value; document.getElementById('testCheckMin2').innerHTML = this.value;}">
                            <option value="">Minutes</option>
                            <% dim minsNumber2
                                for minsNumber2 = 0 to 59
                                    if len(minsNumber2) = 1 then minsNumber2 = "0"& minsNumber2
                            %>
                            <option value="<%=minsNumber2%>"><%=minsNumber2%></option>
                            <%  next %>
                        </select>
                        <br/><br/>
                        이벤트일 : <span id="testCheckDate2" style="color:red"></span> <span id="testCheckHour2" style="color:red"></span>:<span id="testCheckMin2" style="color:red"></span>
                        <br/><br/>
                        <a href="javascript:goTest2('108350')"><span style="color:blue">다이어리 무료배포2 티저 이동</span></a>
                        <br/>
                        <a href="javascript:goTest2('108176')"><span style="color:blue">다이어리 무료배포2 이벤트 이동</span></a>
                        <br/>
                    </li>
                </ul>
            </li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=1');">108349 매일리지 1일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=2');">108349 매일리지 2일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=3');">108349 매일리지 3일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=4');">108349 매일리지 4일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=5');">108349 매일리지 5일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=6');">108349 매일리지 6일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=7');">108349 매일리지 7일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=8');">108349 매일리지 8일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108349&checkday=9');">108349 매일리지 9일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108561');">108561 마일리지 3000</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108649');">108649 줍줍 닌텐도</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108094');">108094 서촌도감#1</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108792');">108792 마일리지 2021</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108923');">108923 새해 1억 많이 받으세요</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109027');">109027 줍줍이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109096');">109096 2000 마일리지</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108944');">108944 인스타그램 팔로우 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109120');">109120 줍줍 에어팟 맥스</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=1');">109461 매일리지 1일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=2');">109461 매일리지 2일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=3');">109461 매일리지 3일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=4');">109461 매일리지 4일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=5');">109461 매일리지 5일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=6');">109461 매일리지 6일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=7');">109461 매일리지 7일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=8');">109461 매일리지 8일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109461&checkday=9');">109461 매일리지 9일차</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109208');">109208 서촌도감01 - 오프투얼론</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109570');">109570 두번째 구매샵</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108730');">108730 서촌도감03 - 미술관옆작업실</a></li>
			<li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109191');">109191 2020년은 ‘직장인 치트킷(KIT)’과 함께!</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110079');">110079 마니또가 대신 결제해드립니다</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110235');">110235 언박싱 이벤트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109897');">109897 핀란드프로젝트</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110645');">110645 이상형 월드꽃</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110643');">110643 #즐겨찾길_서촌 05 텐바이텐X커피한잔</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110793');">110793 오늘도 달콤한 텐몽카페</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110972');">110972 귀여움 저장소</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111102');">111102 인형뽑기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110936');">110936 귀여움 페스티벌</a></li>
                <ul>
                    <li><font size=2 color="red">----------- 이벤트 테스트 영역 끝-------------</font></li>
                </ul>
            </li>

			<li>
                <ul>
                    <li><font size=2 color="red">2019 4월 정기세일 세라벨</font></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93355');">93355 100원의 기적</a></li> 
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93354');">93354 100원의 기적 모웹</a></li>
                    <li><a href="" onclick="fnAPPpopupAutoUrl('/event/eventmain.asp?eventid=93354');return false;">100원의 기적 링크 테스트</a></li>            
                    <br/>
                    <br/>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93475');">앗싸~ 에어팟2 특템!</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/salelife/index.asp');">세라벨 메인</a></li>                     
                    <li><a href="" onclick="fnAPPpopupAutoUrl('/event/salelife/index.asp');return false;">세라벨 메인 링크테스트</li>                    
                </ul>
            </li>

			<li>
                <ul>
                	<li><a href="javascript:fnAPPpopupBrowserURL('핑거스 매거진','http://testm.10x10.co.kr/academy/magazine/index.asp');">핑거스 매거진<br>
                    <br>
                </ul>
            </li>
			<li>
                <ul>
                    <li><font size=2 color="red">----------- 플레잉 띵 &gt; 띵 영역 -------------</font></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=126&state=5&sdate=2017-08-07');return false;">마이띵프렌즈</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=147&state=7&sdate=2017-09-25');return false;">장바구니 탐구생활-매니큐어편</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=153&state=7&sdate=2017-10-10');return false;">포장의 발견</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=163&state=7&sdate=2017-10-30');return false;">장바구니 탐구생활 _다이어리편</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=163&state=7&sdate=2017-10-30');return false;">왜 우리는 다이어리를 끝까지 써 본적이 없을까?</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=178&state=7&sdate=2017-12-04');return false;">취향으로 알아보는 연애능력 TEST</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=184&state=7&sdate=2017-12-18');return false;">비누한모</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=187&state=7&sdate=2017-12-25');return false;">플레잉 연말정산</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=199&state=7&sdate=2018-01-22');return false;">THING BAG</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=216&state=7&sdate=2018-03-05');return false;">오늘뭐하지?</a></li>
					<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playing/view.asp?isadmin=o&didx=247&state=7&sdate=2018-06-26');return false;">직장생활</a></li>
					<li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/playwebview/detail.asp?pidx=442');">장바구니탐구생활_홈캉스편</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/playwebview/detail.asp?pidx=475');">PLAY GOODS 취향</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/playwebview/detail.asp?pidx=631');">PLAY GOODS 러브미모어</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/playwebview/detail.asp?pidx=621');">탐구생활 - 이거알면옛날사람??</a></li>
                    <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/playwebview/detail.asp?pidx=674');">PLAY GOODS 복덩이</a></li>
                </ul>
            </li>

			<!--li>
                <ul>
					<li><a href="javascript:fnAPPpopupPlay_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/play/playGround_review.asp?idx=1397&contentsidx=125')">페스티/a></li>

					<li><a href="javascript:fnAPPpopupPlay_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/play/playGround_review.asp?idx=1396&contentsidx=123'ㅅ)">SOSO한 일상의 소소한 축제</a></li><br>
					<li><a href="javascript:fnAPPpopupPlay_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/play/playGround_review.asp?idx=1402&contentsidx=129')">물좋은곳</a></li><br>
            </li>
			<li>
                <ul>
                    <li><font size=2 color="red">----------- 플레이 그라운드 영역  끝-------------</font></li>
                </ul>
            </li-->
<%

'response.write Request.ServerVariables("HTTP_USER_AGENT") & "<br>"
dim appVersion, VuserAgent 
Dim Reg : Set Reg = New RegExp
dim Matches, Match, RetStr
Reg.IgnoreCase = true
Reg.Global = true
Reg.Pattern = "[/ ]+([0-9]+(?:\.[0-9]+)?)#"
'[0-9]+(\.[0-9]+)*

VuserAgent = Request.ServerVariables("HTTP_USER_AGENT")
VuserAgent = "Mozilla/5.0 (Linux; Android 8.0.0; SM-G935K Build/R16NW; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/73.0.3683.90 Mobile Safari/537.36tenapp A2.482"
appVersion = mid(VuserAgent, Instr(VuserAgent,"tenapp")+8, 5)

set Matches = Reg.Execute(VuserAgent)

For Each Match in Matches   
    RetStr = RetStr & Match.Value
Next

response.write VuserAgent & "<br>"

if Instr(VuserAgent,"tenapp") > 0 then
    response.write "appVersion : " & appVersion & "<br>"
end if

if getAppVersion() then
    response.write "있음" & "<br>"
    if getAppVersion() >= 2.483 then    
        response.write "최신버전" & "<br>"
    else
        response.write "구버전" & "<br>"
    end if
else 
    response.write "없음"
end if
%>            
			 <li><font size=2 color="red">----------- -------------</font></li>
			<li>
                <ul>
                    <li><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '고마워 텐바이텐', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/cscenter/thanks10x10.asp');return false;">고마워 텐바이텐</a></li>
                </ul>
            </li>
			<li>
                <ul>
                    <li><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '컬쳐스테이션', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/culturestation/index.asp');return false;">컬쳐스테이션</a></li>
                </ul>
            </li>
			<li>
                <ul>
                    <li><a href="javascript:fnAPPpopupProduct('1212471');">테스터이벤트 후기</a></li>
                </ul>
            </li>
			<li>
                <ul>
					<li><a href="javascript:fnAPPpopupAutoUrl('/street/street_brand.asp?makerid=preludepost&gaparam=catemain_a');">preludepost 브랜드</a></li>
                </ul>
            </li>
            <li><font size=2 color="red">----------- -------------</font></li>
            <li>
                <ul>
                    <li><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '핑거스', [], 'http://m.thefingers.co.kr');return false;">m.thefingers.co.kr</a></li>
                </ul>
            </li>
            <li><font size=2 color="red">----------- -------------</font></li>
            <br>


            <li align="right"><input type="button" value="Reload" onClick="document.location.reload();"></li>
            <br>
            <% if IsShow_OLDPROTOCOL then %>
            ----사용중지----
            <br>
            <li>custom Protocol
                <ul>
                <li>기존 버전 재사용
                    <ul>
                        <li>로그인창 호출 <a href="javascript:calllogin();">custom://login.custom</a></li>
                        <li>장바구니 숫자 변경 <a href="javascript:cartnum(3);">custom://cartnum.custom?num=3</a></li>
                        <li>카테고리 바로가기 <a href="javascript:opencategoryCustom('cd1=103&cd2=103108&nm1=캠핑/트래블&nm2=아웃도어');">custom://opencategory.custom?cd1=103&cd2=103108&nm1=캠핑/트래블&nm2=아웃도어</a> (인코딩 안함-확인)</li>
                        <li>get uuid <a href="javascript:getUUID();">custom://uuid.custom?callback=jsCallbackFunc</a></li>
                        <li>get psid <a href="javascript:getPSID();">custom://psid.custom?callback=jsCallbackFunc</a></li>
                        <li>get version <a href="javascript:getVersion();">custom://version.custom?callback=jsCallbackFunc</a></li>
                        <li>외브 브라우져 호출 <a href="javascript:openbrowser('http://pinterest.com/pin/create/button/?url=link&media=img');">custom://openbrowser.custom?url=</a> (SNS 호출,파일 다운로드 등에 사용 Base64인코딩-확인 필요)  </li>
                    </ul>
                </li>
                <li>추가
                    <ul>
                        <li>LNB 주문배송조회 숫자변경 <a href="javascript:setordercount(2);">custom://ordercount.custom?cnt=2</a></li>
                        <li>마이 아이콘 변경 <a href="javascript:chgmyicon(3);">custom://myicon.custom?id=3</a></li>
                        <li>마이 쿠폰 갯수 변경 <a href="javascript:chgmycoupon(5);">custom://mycoupon.custom?cnt=5</a></li>
                        <li>마이 마일리지 변경 <a href="javascript:chgmymileage(5123);">custom://mymileage.custom?mile=5123</a></li>
                        <li>LNB 최근본상품 추가 <a href="javascript:addtodayview(98989);">custom://todayview.custom?itemid=98989</a></li>
                        <li>브랜드 상품페이지 이동 <a href="javascript:gobrandcustom('mmmg');">custom://brand.custom?brandid=mmmg</a> (브랜드 정보 프로토콜 변경 필요)</li>
                    </ul>
                </li>
                </ul>
            </li>
         <% end if %>
        </ul>
		<ul>
			<li><a href="javascript:fnAPPpopupBrowserURL('퀵리스트','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/quick_list.asp');">바로배송 퀵리스트 테스트</a></li>
			<li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=382');return false;">play_장바구니탐구생활_color</a></li>
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=771');return false;">play 4월 뱃지</a></li>
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=780');return false;">play 5월 뱃지</a></li>
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=523');return false;">탐구생활 에어팟</a></li>
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=577');return false;">탐구생활 환경</a></li>
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=664');return false;">탐구생활 연말정산</a></li>
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=586');return false;">meaning life</a></li>      
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=702');return false;">탐구생활 가성비</a></li>      
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=728');return false;">탐구생활 문구</a></li>      
            <li><a href="" onclick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/playwebview/detail.asp?pidx=760');return false;">탐구생활 장바구니</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/christmas/index.asp');">크리스마스기획전</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/valentine/index.asp');">발렌타인기획전</a></li>            
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/snsitem/index.asp');">snsitem기획전</a></li>            
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/funding/index.asp');">펀딩템</a></li>                        
            <li><a href="javascript:fnAPPpopupBrowserURL('텐퀴즈','<%=wwwUrl%>/apps/appcom/wish/web2014/tenquiz/quizmain.asp');">텐퀴즈</a></li>
			<li><a href="javascript:fnAPPpopupBrowserURL('WallPaper','<%=wwwUrl%>/apps/appcom/wish/web2014/wallpaper/');">월페이퍼 메인</a></li>
			<li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/event/eventmain.asp?eventid=89829');">월페이퍼 10주차 상세 (M)</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89829');">월페이퍼 10주차 상세 (A)</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/etc/baroquick/');">바로배송 기획전</a></li>
            <li><a href="javascript:fnAPPpopupBrowserURL('fingerprintdemo','<%=wwwUrl%>/fingerprint/');">fingerprintdemo</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/family2019/index.asp?gaparam=today_mainroll_1');">가정의달 기획전</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/foryou/index.asp');">for you</a></li>
            <li><a href="javascript:fnAPPpopupTransparent('tenfluencer','http://fiximage.10x10.co.kr/m/2019/platform/tenfluencer.png','/tenfluencer/','right','sc','titleimage');">텐플루언서 리스트</a></li>
            <li><a href="javascript:fnAPPpopupTransparent('tenfluencer','http://fiximage.10x10.co.kr/m/2019/platform/tenfluencer.png','/tenfluencer/detail.asp?cidx=3','right','sc','titleimage');">텐플루언서 상세</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/stationerystore/');">텐텐문방구</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/family2020/index.asp');">가정의달 2020</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102229');">102229 텐텐쇼퍼 10기</a></li>
            <li><a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103333');">103333 더블할인 가이드</a></li>
            <br/>
            <br/>
            <br/>
            <li><a href="javascript:fnAPPpopupAutoUrl('/tenfluencer/detail.asp?cidx=3');">텐플루언서 URL 테스트</a></li>
		</ul>
		<ul>
			<li><a href="javascript:fnAPPpopupProduct('2003173');">바로배송 테스트</a></li>
            <li><a href="javascript:fnAPPpopupProduct('2065172');">성인인증 테스트</a></li>
		</ul>
        <ul>
            <li id="browserHash1">
                loading...
            </li>
            <script>
            function callbackBrowserHash(value) {
                $('#browserHash1').html(value);
            }
            $(function() {
                function a() {
                    function a(a) {
                        return ("00000000" + a.toString(16)).slice(-8)
                    }

                    function c(a) {
                        for (var b = a.toString(16).toUpperCase(); b.length < 4;) b = "0" + b;
                        return "U+" + b
                    }

                    function d(a) {
                        return a <= 65535 ? String.fromCharCode(a) : (a -= 65536, String.fromCharCode(55296 + (a >> 10), 56320 + a % 1024))
                    }

                    function e(a, b) {
                        return (69069 * a + b) % 4294967296
                    }
                    $('<div id="fonts-utf-testbox"></div>').appendTo("html");
                    for (var f = ["default", "sans-serif", "serif", "monospace", "cursive", "fantasy"], g = [8377, 9601, 8378, 42813, 65533, 8376, 1478, 7838, 2431, 61443, 7386, 6109, 9134, 3330, 2946, 4442, 9253, 12334, 43056, 11014, 8676, 8381, 11387, 8368, 64494, 63504, 65535, 127, 4256, 120720, 1792, 6480, 12437, 21293, 1564, 8419, 65529, 536, 1423, 2276, 2483, 7248, 9753], h = document.getElementById("fonts-utf-testbox"), i = {}, j = {}, k = 0; k < f.length; k++) {
                        var l = f[k],
                            m = document.createElement("div"),
                            n = document.createElement("span");
                        m.id = "div-" + l, n.id = "span-" + l, "default" !== l && (n.style.fontFamily = l), n.textContent = "A", h.appendChild(m), m.appendChild(n), i[l] = m, j[l] = n
                    }! function() {
                        for (var b = 0, h = [], k = 0; k < g.length; k++) {
                            for (var l = g[k], m = d(l), n = [c(l)], o = 0; o < f.length; o++) {
                                var p = f[o],
                                    q = i[p],
                                    r = j[p];
                                r.textContent = m;
                                var s = r.offsetWidth,
                                    t = q.offsetHeight;
                                b = e(b, s), b = e(b, t);
                                var u = s + "," + t;
                                u.length < 4 && (u += "\t"), u.length < 8 && (u += "\t"), n.push(u)
                            }
                            h.push(n.join("\t"))
                        }
                        for (var o = 0; o < f.length; o++) {
                            var p = f[o],
                                r = j[p];
                            r.textContent = ""
                        }
                        var v = a(b);
                        callbackBrowserHash(v);
                    }()
                }
                setTimeout(function() {
                    a()
                }, 1)
            });
            </script>
        </ul>
    </div>
    <script>
        // 마일리지 이벤트 테스트 이동
        function goMileageEventTestPage() {
            const test_value = document.getElementById('test_value_110104').value;
            fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110104&test_value=' + test_value);
        }
        // 마일리지 이벤트 테스트 이동
        function go110409EventTestPage() {
            const test_value = document.getElementById('test_value_110409').value;
            fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110409&test_value=' + test_value);
        }
    </script>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>