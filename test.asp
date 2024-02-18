<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
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
    %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8" />
    <title>텐바이텐 10X10</title>
    <script>
    function getErrorMessage() {
        if (<%= LCase(isAndroidWebView) %> != true) {
            return "ok";
        } else if ((window.innerWidth < 100) || (window.innerHeight < 50)) {
            return "웹뷰 사이즈가 너무 작습니다.(too small webview)";
        } else if (typeof document.hidden !== "undefined") {
            if (document.hidden == true) {
                return "숨겨진 웹뷰입니다.(hidden webview)";
            }
        } else if (typeof document.webkitHidden !== "undefined") {
            if (document.webkitHidden == true) {
                return "숨겨진 웹뷰입니다.(hidden webview)";
            }
        } else if ((typeof document.hidden === "undefined") && (typeof document.webkitHidden === "undefined")) {
            return "정상적인 안드로이드 웹뷰가 아닙니다.(not a valid android webview)";
        }

        return "ok";
    }

    function isValidBrowser() {
        if (<%= LCase(isAndroidWebView) %> != true) {
            return true;
        } else if ((window.innerWidth < 100) || (window.innerHeight < 50)) {
            return false;
        } else if (typeof document.hidden !== "undefined") {
            return document.hidden;
        } else if (typeof document.webkitHidden !== "undefined") {
            return document.webkitHidden;
        } else if ((typeof document.hidden === "undefined") && (typeof document.webkitHidden === "undefined")) {
            return false;
        }

        return true;
    }

    function runScript() {
        if (navigator.cookieEnabled == true) {
            if ((isValidBrowser() == false) && <%= LCase(isAndroidWebView) %>) {
                document.getElementById("msg").innerHTML = getErrorMessage();
            } else {
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
ok
