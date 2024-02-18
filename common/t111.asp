<%@  codepage="65001" language="VBScript" %>
<% response.Charset="UTF-8" %>
<%
response.write "Svr_Info:"&application("Svr_Info")
response.write "<br>"
response.write "ADDR:"&request.serverVariables("REMOTE_ADDR")
response.write "<br>"
response.write "session:"&session.sessionID
%>
<script language='javascript'> 
function aa(scm){
    document.location.href=scm;
}

function wishAppLink(vUrl) {
	var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
	    isAndroid = navigator.userAgent.match('Android');

	if (isiOS || isAndroid) {
		//document.getElementById('loader').src = "tenwishapp://" + encodeURIComponent(vUrl);
		document.getElementById('loader').src = "tenwishapp://" + vUrl;
		var fallbackLink = isAndroid ? 'market://details?id=kr.tenbyten.shopping' :
	                                 'https://itunes.apple.com/kr/app/id864817011' ;
		window.setTimeout(function (){ window.location.replace(fallbackLink); }, 25);
	} else {
		alert("안드로이드 또는 IOS 기기만 지원합니다.");
	}
}

//카테고리 바로가기
function opencategoryCustom(param){
    window.location.href = "custom://opencategory.custom?"+param;
    return false;
}

function callUUIDCustomUrl(){
    window.location="custom://uuid.custom?callback=jsCallbackUUID"; // psid.custom, version.custom
}

function callPSIDCustomUrl(){
    window.location="custom://psid.custom?callback=jsCallbackPSID"; // psid.custom, version.custom
}

function callVersionCustomUrl(){
    window.location="custom://version.custom?callback=jsCallbackVer"; // psid.custom, version.custom
}

function jsCallbackUUID(retval){
    alert(retval);
}

function jsCallbackPSID(retval){
    alert(retval);
}

function jsCallbackVer(retval){
    alert(retval);
}

function callCustomCallBack(ctype,fnName){
    window.location="custom://"+ctype+".custom?callback="+fnName; // ctype: uuid, psid, version
}
 
 
function jsCallbackFunc(retval){
    alert(retval);
}

function openevent(url){
    //url = Base64.encodeAPP(url);
    window.location.href = "custom://openevent.custom?url="+url;
    return false;
}

</script>
<br>
<input type="button" value="https://m.10x10.co.kr/test/t.asp" onClick="location.href='https://m.10x10.co.kr/test/t.asp';">

<br>
<br>
<input type="button" value="https://itunes.apple.com/kr/app/id864817011" onClick="aa('https://itunes.apple.com/kr/app/id864817011');">
<br>
<br>
<a href="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping">kr.tenbyten.shopping</a>
<br>
<br>
추적TEST
<BR>
<input type="button" value="https://itunes.apple.com/kr/app/id864817011?referrer=utm_source%3Dtest" onClick="aa('https://itunes.apple.com/kr/app/id864817011?referrer=utm_source%3Dtest');">
<br><br>
<a href="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dsource%26utm_medium%3Dmedium%26utm_term%3Dterm%26utm_content%3Dcontent%26utm_campaign%3Dcampaign">https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dsource%26utm_medium%3Dmedium%26utm_term%3Dterm%26utm_content%3Dcontent%26utm_campaign%3Dcampaign</a>
<br><br>
<input type="button" value="market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dsource%26utm_medium%3Dmedium%26utm_term%3Dterm%26utm_content%3Dcontent%26utm_campaign%3Dcampaign" onClick="aa('market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dsource%26utm_medium%3Dmedium%26utm_term%3Dterm%26utm_content%3Dcontent%26utm_campaign%3Dcampaign');">
<br>

<input type="button" value="tenwishappcam://id=kr.tenbyten.shopping&referrer=empty&utm_source=test.10x10&utm_medium=email&utm_term=empty&utm_content=shop&utm_campaign=code" onClick="aa('tenwishappcam://id=kr.tenbyten.shopping&referrer=empty&utm_source=test.10x10&utm_medium=email&utm_term=empty&utm_content=shop&utm_campaign=code');">

<input type="button" value="tenwishappcam://id=864817011&referrer=empty&utm_source=test.10x10&utm_medium=email&utm_term=empty&utm_content=shop&utm_campaign=code" onClick="aa('tenwishappcam://id=864817011&referrer=empty&utm_source=test.10x10&utm_medium=email&utm_term=empty&utm_content=shop&utm_campaign=code');">

<input type="button" value="market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dalarmmon%26utm_medium%3Dalliance%26utm_campaign%3Dalarmmon" onClick="aa('market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dalarmmon%26utm_medium%3Dalliance%26utm_campaign%3Dalarmmon');">

-------------------------------------
<br>
<input type="button" value="kr.tenbyten.shopping" onClick="aa('market://details?id=kr.tenbyten.shopping');">
<br>
<br>
<input type="button" value="com.google.android.gms" onClick="aa('market://details?id=com.google.android.gms');">
<br>
<br>
<!--
<input type="button" value="https://play.google.com/store/apps/details?id=com.google.android.gms" onClick="aa('https://play.google.com/store/apps/details?id=com.google.android.gms');">
<br>
<br>
-->



<input type="button" value="tenwishapp://http://bit.ly/1KMBQSL" onClick="aa('tenwishapp://http://bit.ly/1KMBQSL');">
<br>
<input type="button" value="tenwishapp://http://m.10x10.co.kr/apps/event.asp?eventid=64499" onClick="aa('tenwishapp://http://m.10x10.co.kr/apps/event.asp?eventid=64499');">
<br>

<input type="button" value="tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=64499" onClick="aa('tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=64499');">
<br>

<input type="button" value="tenwishapp://" onClick="aa('tenwishapp://');">
<br>
<input type="button" value="tenwishapp://http//m.10x10.co.kr" onClick="aa('tenwishapp://http//m.10x10.co.kr');">
<br>
<input type="button" value="tenwishapp://http://m.10x10.co.kr" onClick="aa('tenwishapp://http://m.10x10.co.kr');">
<br><br>
<input type="button" value="tenwishapp://http//m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=998755" onClick="aa('tenwishapp://http//m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=998755');">
<br>
<br>
<input type="button" value="tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=998755" onClick="aa('tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=998755');">
<br>
<br>
<input type="button" value="javascript:wishAppLink(&quot;http//m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=998755&quot;);" onClick="wishAppLink('http//m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=998755');">
<br>
<br><input type="button" value="javascript:wishAppLink(&quot;quot;);" onClick="wishAppLink('');">

<% if (FALSE) then %>
<!--
<iframe style="display:none" height="0" width="0" id="loader"></iframe>
<br>

<br><input type="button" value="intent://scan/#Intent;scheme=zxing;package=com.google.zxing.client.android;end" onClick="aa('intent://http//m.10x10.co.kr/apps/appcom/wish/webview/event/eventmain.asp?eventid=53581#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;end');">
<br><input type="button" value="intent://#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;end" onClick="aa('intent://#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;end');">

<br>
<input type="button" value="market-hitchhiker" onClick="aa('market://details?id=kr.tenbyten.hitchhiker');">
<br>
<br>
<input type="button" value="ispmobile" onClick="aa('ispmobile://');">

<br>
<input type="button" value="tenColorApp" onClick="aa('tencolorapp://');">

<br>
<hr>
<br>
<input type="button" value="custom:Login" onClick="aa('custom://login.custom');">

<br>
<br>
<input type="button" value="custom:goMain" onClick="aa('custom://gomain.custom');">

<br>
<br>
<input type="button" value="custom:goEvent" onClick="aa('custom://goevent.custom');">

<br>
<br>
<input type="button" value="custom:topMenu('event')" onClick="aa('custom://topmenu.custom?id=event');">

<br>
<hr>
<input type="button" value="custom:openbrowser('http://m.10x10.co.kr')" onClick="aa('custom://openbrowser.custom?url=http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=1116607');">
<br><br>
<input type="button" value="custom:openevent('http://m.10x10.co.kr');" onClick="openevent('http://m.10x10.co.kr');">
<br><br>
<br>
-->
<!--
<input type="button" value="v3mobileplus" onClick="aa('v3mobile://');">


<br>
<input type="text" value="twotrs_isp=Y&block_isp=Y">
-->
<!--
<br>
<br>
<input type="button" value="reload" onClick="document.location.reload()">
<br> custom :: UTF8 사용<br>
-->
<br>
<!--
<br>--이방식 아님-------------------------------------------------
<br><br>
    <a href="#" onClick="opencategoryCustom('<%="cd1=103&nm1=캠핑/트래블"%>');">opencategoryCustom:('cd1=103&nm1=캠핑/트래블')</a>
    <br>
    <br>
    <a href="#" onClick="opencategoryCustom('<%="cd1=103&cd2=108&nm1=캠핑/트래블&nm2=아웃도어"%>');">opencategoryCustom:('cd1=103&cd2=108&nm1=캠핑/트래블&nm2=아웃도어')</a>

    <br>
    <br>
    <a href="#" onClick="opencategoryCustom('<%="cd1=103&cd2=108&cd3=102&nm1=캠핑/트래블&nm2=아웃도어&nm3=배낭"%>');">opencategoryCustom:('cd1=103&cd2=108&cd3=102&nm1=캠핑/트래블&nm2=아웃도어&nm3=배낭')</a>
<br>
-->
<br>--2014/06/11-------------------------------------------------
<br>
    <a href="#" onClick="opencategoryCustom('<%="cd1=103&nm1=캠핑/트래블"%>');">opencategoryCustom:('cd1=103&nm1=캠핑/트래블')</a>
    <br>
    <br>
     <a href="#" onClick="opencategoryCustom('<%="cd1=103&cd2=103108&nm1=캠핑/트래블&nm2=아웃도어"%>');">opencategoryCustom:('cd1=103&cd2=103108&nm1=캠핑/트래블&nm2=아웃도어')</a>
    <br>
    <br>
    <a href="#" onClick="opencategoryCustom('<%="cd1=103&cd2=103108&cd3=103108102&nm1=캠핑/트래블&nm2=아웃도어&nm3=배낭"%>');">opencategoryCustom:('cd1=103&cd2=103108&cd3=103108102&nm1=캠핑/트래블&nm2=아웃도어&nm3=배낭')</a>
    
    <br>
    <br>
    <a href="opencategoryCustom('<%="cd1=103&nm1=캠핑/트래블"%>');">opencategoryCustom:('cd1=103&nm1=캠핑/트래블')</a>
    <br>
    
<%
'response.write "GSSN:"&request.Cookies("shoppingbag")("GSSN")
'response.write "<br>"
'response.write session("guestGSSN")

%>

<br><br><br>
--get uuid, pushid, version
<br>
<input type="button" value="callUUIDCustomUrl" onClick="callUUIDCustomUrl();">
<br><br>
<input type="button" value="callPSIDCustomUrl" onClick="callPSIDCustomUrl();">
<br><br>
<input type="button" value="callVersionCustomUrl" onClick="callVersionCustomUrl();">
<br><br>

<input type="submit" value="getUUID" onclick="callCustomCallBack('uuid','jsCallbackFunc'); return false;">
<br><br>
<input type="submit" value="getPSID" onclick="callCustomCallBack('psid','jsCallbackFunc'); return false;">
<br><br>
<input type="submit" value="getVERSION" onclick="callCustomCallBack('version','jsCallbackFunc'); return false;">
<br><br>
    
-- GO TODAY --
<br>
<input type="button" value="gotoday" onClick="window.location.href='custom://gotoday.custom';">
<br>

--카카오톡
<br><br>
<input type="button" value="kakaolink - No param" onClick="window.location.href='kakaoef127f70c902bff3f01fb7c9a53ee88f://kakaolink';">
<br><br>
<input type="button" value="kakaolink - param blank" onClick="window.location.href='kakaoef127f70c902bff3f01fb7c9a53ee88f://kakaolink?url=';">
<br><br>
<input type="button" value="kakaolink - param simple" onClick="window.location.href='kakaoef127f70c902bff3f01fb7c9a53ee88f://kakaolink?url=http://m.10x10.co.kr/apps/appCom/wish/webview/today/index.asp';">
<br><br>
<input type="button" value="kakaolink - param complex" onClick="window.location.href='kakaoef127f70c902bff3f01fb7c9a53ee88f://kakaolink?url=http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=982656';">
<br><br>

--텔레그램
<br>
<input type="button" value="Telegram" onClick="window.location.href='telegram://';">
<br>

<br><br>
<% if (FALSE) then %>
    <TABLE border="1">
    <% For Each key in Request.ServerVariables %>
        <TR>
            <TD><%=key %></TD>
            <TD>
            <% 
                if Request.ServerVariables(key) = "" Then
                    Response.Write " " 
                else 
                    Response.Write Request.ServerVariables(key)
                end if
            %>
            </TD>
        </TR>
    <% Next %>
    </TABLE>
<% end if %>

<% end if %>