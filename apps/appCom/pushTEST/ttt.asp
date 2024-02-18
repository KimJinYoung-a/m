<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% 
dim BASELNK : BASELNK="/apps/appCom/wish/web2014"
dim IsShow_OLDPROTOCOL : IsShow_OLDPROTOCOL= FALSE
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="format-detection" content="telephone=no" />
<title><%= "타이틀" %></title>


<% if (FALSE) then %>
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/common.css?v=2.14">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/content.css?v=4.17">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/section.css?v=3.68">

<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/diary2015.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">

<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/iscroll.js"></script>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/jquery.swiper-3.1.2.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/common.js?v=2.05"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.43"></script>

<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/confirm.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/shoppingbag_script.js"></script>
<% end if %>

<% if (FALSE) then %>
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/mw/lib/css/common.css">
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/mw/lib/css/content.css">
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/mw/lib/css/section.css">
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/mw/lib/css/diary2015.css">
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/mw/lib/css/newV15a.css" />
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/mw/lib/css/mytenten2013.css" />

<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/mw/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/mw/lib/js/jquery.swiper-3.1.2.min.js"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/mw/lib/js/common.js"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/mw/lib/js/customapp.js"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/mw/lib/js/confirm.js"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/mw/lib/js/shoppingbag_script.js"></script>
<% end if %>
</head>

<body style="font-size:12px;">
    <div style="padding:20px;">
        <ul style="line-height: 150%;">
            <li>현재 <b>운영 서버</b>입니다.(<%=application("Svr_Info")%>) <input type="button" value="Go TEST Srv." onClick="document.location.href='http://testm.10x10.co.kr/apps/appcom/wish/web2014/pagelist.asp';"></li>
            <li align="right"><input type="button" value="Reload" onClick="document.location.reload();"></li>
            <br>
            
             <li>
                <ul>
                    <li><%=request.serverVariables("REMOTE_ADDR")%> / <%= now() %>
                   
                    <li>
                    </ul>
            </li>
            <li>
            <br>
            <a href="tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1024019&rdsite=fbTEST">fbTEST</a>
            </li>
            
            <li>
            <br>
            <a href="http://wapi.10x10.co.kr/tt.asp">wapi</a>
            </li>
            
            <li>
            <br>
            <a href="http://ec2-52-79-79-124.ap-northeast-2.compute.amazonaws.com/awsde/tt.asp">http://ec2-52-79-79-124.ap-northeast-2.compute.amazonaws.com/awsde/tt.asp</a>
            </li>
            
            
            
        </ul>
    </div>
</body>
</html>