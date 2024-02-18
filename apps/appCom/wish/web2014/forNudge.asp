<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
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

%>

<% 
if NOT ((GetLoginUserID="sunku") Or (GetLoginUserID="icommang") Or (GetLoginUserID="qpark99") Or (GetLoginUserID="fun")) then
    response.write "require login...."
    response.end
    
end if  
%> 

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type='text/javascript'>
// getDeviceInfo :: 각 페이지 내에서 사용.
    function fnAPPgetDeviceInfo() {
        callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
            alert(deviceInfo.uuid+'::'+deviceInfo.psid+'::'+deviceInfo.version+'::'+deviceInfo.nudgeuid)
            // deviceInfo.uuid;
            // deviceInfo.psid;
            // deviceInfo.version;
        }});
    }
    
    function getRecentlyViewedProductsApp(products){
       // alert(products.join(','));
       // location.href="/apps/appCom/wish/web2014/my10x10/mytodayshopping.asp?itemarr="+products.join(',');
    }


</script>
</head>

<body style="font-size:12px;">
    <div style="padding:20px;">
        <ul style="line-height: 150%;">
            <br><br><br>
            
            <li>현재 <b>운영 서버</b>입니다.(<%=application("Svr_Info")%>)
            
            <li align="right"><input type="button" value="Reload" onClick="document.location.reload();"></li>
            <br>
            <li>
                <ul>
                    <li><a href="javascript:fnAPPsetNudgeTrack('incrCustParam',2,'wish_count',1);">넛지 incrCustParam(wish_count)</a><li>
                </ul>
            </li>
            <br>
            <li>
                <ul>
                    <li><a href="javascript:fnAPPsetNudgeTrack('loadNshow',1,'','');">넛지 loadNshow(1)</a><li>
                </ul>
            </li>
            
            <li align="right"><input type="button" value="Reload" onClick="document.location.reload();"></li>
       </ul>
    </div>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>