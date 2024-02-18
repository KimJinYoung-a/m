<%

dim checkCookieValid : checkCookieValid = True
dim checkCookieValidIp, checkCookieValidCCE, checkCookieValidCCV
dim isAndroidWebView : isAndroidWebView = False

checkCookieValidIp = Request.ServerVariables("REMOTE_ADDR")
if (checkCookieValidIp = "::1") then
    checkCookieValidIp = "127.0.0.1"
end if
checkCookieValidIp = Replace(checkCookieValidIp, ".", "")

isAndroidWebView = (InStr(Request.ServerVariables("HTTP_USER_AGENT"), "wv") > 0)


function createCheckCookieValidValue(byVal checkCookieValidIp)
    dim cce, ccv, ipstr, timestr

    ipstr = checkCookieValidIp
    if Not IsNumeric(ipstr) then
        ipstr = "127001"
    end if

    '// Left(StrReverse(YYYYMMDDHH), 7)
    timestr = Left(StrReverse(Replace(FormatDateTime(Now(), 2), "-", "") & Left(FormatDateTime(Now(), 4), 2)), 7)

    Randomize
    ccv = CStr(CLng(Rnd*9999999))
    ''response.write ccv & "<br />"

    if (ipstr*1 > 100000000) then
        cce = timestr*1 + CLng(ipstr*1/38763491) + ccv*1 + 89798423
    else
        cce = timestr*1 + CLng(ipstr*1/3491) + ccv*1 + 89798423
    end if
    cce = Right(cce, 7)
    ''response.write cce & "<br />"

    ''response.Cookies("ccv") = ccv
    ''response.Cookies("ccv").Expires = DateAdd("h", 24, now())

    ''response.Cookies("cce") = cce
    ''response.Cookies("cce").Expires = DateAdd("h", 24, now())

    checkCookieValidCCE = cce
    checkCookieValidCCV = ccv
end function

function checkCookieValidValue(byVal checkCookieValidIp)
    dim cce, ccv, ipstr, timestr, cceCalc

    cce = Request.Cookies("cce")
    ccv = Request.Cookies("ccv")

    ''response.write ccv & "<br />"
    ''response.write cce & "<br />"

    ipstr = checkCookieValidIp
    if Not IsNumeric(ipstr) then
        ipstr = "127001"
    end if

    '// Left(StrReverse(YYYYMMDDHH), 7)
    timestr = Left(StrReverse(Replace(FormatDateTime(Now(), 2), "-", "") & Left(FormatDateTime(Now(), 4), 2)), 7)

    if (ipstr*1 > 100000000) then
        cceCalc = timestr*1 + CLng(ipstr*1/38763491) + ccv*1 + 89798423
    else
        cceCalc = timestr*1 + CLng(ipstr*1/3491) + ccv*1 + 89798423
    end if
    cceCalc = Right(cceCalc, 7)

    checkCookieValidValue = (cceCalc = cce)
end function


if (Request.Cookies("cce") = "") or (Request.Cookies("ccv") = "") then
    checkCookieValid = False
    Call createCheckCookieValidValue(checkCookieValidIp)
else
    if checkCookieValidValue(checkCookieValidIp) <> True then
        checkCookieValid = False
        Call createCheckCookieValidValue(checkCookieValidIp)
    end if
end if

if (checkCookieValid = False) then
    '' function getErrorMessage() {
    ''     if (ww != true) {
    ''         return "ok";
    ''     } else if (
    ''         ((window.innerWidth == 300) || (window.innerWidth == 299))
    ''         &&
    ''         ((window.innerHeight == 150) || (window.innerHeight == 149))
    ''     ) {
    ''         return '현재 사용 중인 브라우저는 쿠키를 지원하지 않거나, 해당 기능이 활성화되어 있지 않습니다.<br />'
    ''              + '보다 자세한 사항은 <a href="/cscenter/">고객센터</a>로 문의주시기 바립니다.';
    ''     } else if (typeof document.hidden !== "undefined") {
    ''         if (document.hidden == true) {
    ''             return '현재 사용 중인 브라우저는 쿠키를 지원하지 않거나, 해당 기능이 활성화되어 있지 않습니다.<br />'
    ''              + '보다 자세한 사항은 <a href="/cscenter/">고객센터</a>로 문의주시기 바립니다.';
    ''         }
    ''     } else if (typeof document.webkitHidden !== "undefined") {
    ''         if (document.webkitHidden == true) {
    ''             return '현재 사용 중인 브라우저는 쿠키를 지원하지 않거나, 해당 기능이 활성화되어 있지 않습니다.<br />'
    ''              + '보다 자세한 사항은 <a href="/cscenter/">고객센터</a>로 문의주시기 바립니다.';
    ''         }
    ''     } else if ((typeof document.hidden === "undefined") && (typeof document.webkitHidden === "undefined")) {
    ''         return '현재 사용 중인 브라우저는 쿠키를 지원하지 않거나, 해당 기능이 활성화되어 있지 않습니다.<br />'
    ''              + '보다 자세한 사항은 <a href="/cscenter/">고객센터</a>로 문의주시기 바립니다.';
    ''     } else if ((window.innerWidth < 100) || (window.innerHeight < 50)) {
    ''         return '현재 사용 중인 브라우저는 쿠키를 지원하지 않거나, 해당 기능이 활성화되어 있지 않습니다.<br />'
    ''              + '보다 자세한 사항은 <a href="/cscenter/">고객센터</a>로 문의주시기 바립니다.';
    ''     }
    ''
    ''     return "ok";
    '' }
    ''
    '' function isValidBrowser() {
    ''     if (ww != true) {
    ''         return true;
    ''     } else if (
    ''         ((window.innerWidth == 300) || (window.innerWidth == 299))
    ''         &&
    ''         ((window.innerHeight == 150) || (window.innerHeight == 149))
    ''     ) {
    ''         return false;
    ''     } else if (typeof document.hidden !== "undefined") {
    ''         return (document.hidden != true);
    ''     } else if (typeof document.webkitHidden !== "undefined") {
    ''         return (document.webkitHidden != true);
    ''     } else if ((typeof document.hidden === "undefined") && (typeof document.webkitHidden === "undefined")) {
    ''         return false;
    ''     } else if ((window.innerWidth < 100) || (window.innerHeight < 50)) {
    ''         return false;
    ''     }
    ''
    ''     return true;
    '' }
    '' 스크립트 난독화 =================================
    ''
    '' https://obfuscator.io/
    %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8" />
    <title>텐바이텐 10X10</title>
    <script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
    <script>
    var ww = <%= LCase(isAndroidWebView) %>;

    function _0x54c4(){var _0x5255d1=['2280615lFjpcJ','webkitHidden','77gUoniY','12279312BfEfZQ','2jaDYIY','2156070zBvpcn','undefined','296783oatsPt','innerWidth','innerHeight','보다\x20자세한\x20사항은\x20<a\x20href=\x22/cscenter/\x22>고객센터</a>로\x20문의주시기\x20바립니다.','현재\x20사용\x20중인\x20브라우저는\x20쿠키를\x20지원하지\x20않거나,\x20해당\x20기능이\x20활성화되어\x20있지\x20않습니다.<br\x20/>','3973815ZYtlHR','hidden','2198504lxjUlx','105320nckFFt'];_0x54c4=function(){return _0x5255d1;};return _0x54c4();}(function(_0x5c64e1,_0x353b54){var _0x15fd44=_0x376b,_0x58e17f=_0x5c64e1();while(!![]){try{var _0x5cd92c=-parseInt(_0x15fd44(0x121))/0x1*(-parseInt(_0x15fd44(0x11e))/0x2)+-parseInt(_0x15fd44(0x12a))/0x3+parseInt(_0x15fd44(0x128))/0x4+-parseInt(_0x15fd44(0x126))/0x5+-parseInt(_0x15fd44(0x11f))/0x6+-parseInt(_0x15fd44(0x11c))/0x7*(-parseInt(_0x15fd44(0x129))/0x8)+parseInt(_0x15fd44(0x11d))/0x9;if(_0x5cd92c===_0x353b54)break;else _0x58e17f['push'](_0x58e17f['shift']());}catch(_0x326afc){_0x58e17f['push'](_0x58e17f['shift']());}}}(_0x54c4,0x6bbbf));function getErrorMessage(){var _0x4b7388=_0x376b;if(ww!=!![])return'ok';else{if((window[_0x4b7388(0x122)]==0x12c||window[_0x4b7388(0x122)]==0x12b)&&(window[_0x4b7388(0x123)]==0x96||window[_0x4b7388(0x123)]==0x95))return _0x4b7388(0x125)+_0x4b7388(0x124);else{if(typeof document['hidden']!==_0x4b7388(0x120)){if(document[_0x4b7388(0x127)]==!![])return _0x4b7388(0x125)+_0x4b7388(0x124);}else{if(typeof document[_0x4b7388(0x11b)]!==_0x4b7388(0x120)){if(document[_0x4b7388(0x11b)]==!![])return _0x4b7388(0x125)+_0x4b7388(0x124);}else{if(typeof document[_0x4b7388(0x127)]===_0x4b7388(0x120)&&typeof document[_0x4b7388(0x11b)]==='undefined')return _0x4b7388(0x125)+_0x4b7388(0x124);else{if(window[_0x4b7388(0x122)]<0x64||window[_0x4b7388(0x123)]<0x32)return _0x4b7388(0x125)+_0x4b7388(0x124);}}}}}return'ok';}function _0x376b(_0x2f8a4d,_0x3fb891){var _0x54c49d=_0x54c4();return _0x376b=function(_0x376be4,_0x12a025){_0x376be4=_0x376be4-0x11b;var _0x2115fc=_0x54c49d[_0x376be4];return _0x2115fc;},_0x376b(_0x2f8a4d,_0x3fb891);}function isValidBrowser(){var _0xa707c=_0x376b;if(ww!=!![])return!![];else{if((window[_0xa707c(0x122)]==0x12c||window[_0xa707c(0x122)]==0x12b)&&(window[_0xa707c(0x123)]==0x96||window[_0xa707c(0x123)]==0x95))return![];else{if(typeof document[_0xa707c(0x127)]!==_0xa707c(0x120))return document['hidden']!=!![];else{if(typeof document[_0xa707c(0x11b)]!==_0xa707c(0x120))return document['webkitHidden']!=!![];else{if(typeof document[_0xa707c(0x127)]===_0xa707c(0x120)&&typeof document[_0xa707c(0x11b)]==='undefined')return![];else{if(window[_0xa707c(0x122)]<0x64||window[_0xa707c(0x123)]<0x32)return![];}}}}}return!![];}

    function runScript() {
        if (navigator.cookieEnabled == true) {
            if ((isValidBrowser() == false) && <%= LCase(isAndroidWebView) %>) {
                document.getElementById("msg").innerHTML = getErrorMessage();
            } else {
                try {
                    var url = '/common/addlog.js?w=<%= LCase(isAndroidWebView) %>';
                    url = url + '&h=' + ((typeof document.hidden === "undefined") ? 'X' : (document.hidden ? 'Y' : 'N'));
                    url = url + '&k=' + ((typeof document.webkitHidden === "undefined") ? 'X' : (document.webkitHidden ? 'Y' : 'N'));
                    url = url + '&x=' + window.innerWidth;
                    url = url + '&y=' + window.innerHeight;
                    url = url + '&ox=' + window.outerWidth;
                    url = url + '&oy=' + window.outerHeight;

                    $.ajax({url:url});
                } catch (error) {
                    console.error(error);
                }

                var d = new Date();
                var c = '<%= checkCookieValidCCE %><%= checkCookieValidCCV %>';
                d.setDate(d.getDate() + 2);
                document.cookie = "cce=" + c.substring(0, <%= Len(checkCookieValidCCE) %>) + "; path=/; expires=" + d.toGMTString() + ";";
                document.cookie = "ccv=" + c.substring(<%= Len(checkCookieValidCCE) %>, 1000) + "; path=/; expires=" + d.toGMTString() + ";";
                setTimeout(function() {
                    document.location.reload();
                }, 200);
            }
        } else {
            document.getElementById("txt").innerHTML = '현재 사용 중인 브라우저는 쿠키를 지원하지 않거나, 해당 기능이 활성화되어 있지 않습니다.<br />'
                                                     + '보다 자세한 사항은 <a href="/cscenter/">고객센터</a>로 문의주시기 바립니다.';
        }
    }
    </script>
</head>
<body onLoad="runScript()">
    <noscript>
        현재 사용 중인 브라우저는 스크립트를 지원하지 않거나, 해당 기능이 활성화되어 있지 않습니다.<br />
        보다 자세한 사항은 <a href="/cscenter/">고객센터</a>로 문의주시기 바립니다.
    </noscript>
    <div id="txt"></div>
    <div id="msg"></div>
</body>
</html>
    <%
    Response.Status = "239 Check browser"
    response.end
end if

%>
