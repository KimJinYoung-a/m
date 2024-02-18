<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : pen themselves
' History : 2016-09-06 유태욱 생성
'####################################################
%>
<%
Dim Ecode, appevturl

Ecode = requestCheckVar(Request("eventid"),8)

	If isapp = "1" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If
%>
	<style>
	.storyNav {overflow:hidden;}
	.storyNav li {position:relative; float:left; width:33.33333%; height:0; padding-bottom:17.75%;}
	.storyNav li:after {content:''; display:inline-block; position:absolute; left:0; top:50%; width:1px; height:1.2rem; margin-top:-0.4rem; background:#c8c8c8;}
	.storyNav li:first-child:after {display:none;}
	.storyNav li span {display:block; position:absolute; left:0; top:0; width:100%; height:100%; background-size:100% 300%; background-position:0 0; background-repeat:no-repeat; text-indent:-999em;}
	.storyNav li span a {display:none; height:100%; text-indent:-999em;}
	.storyNav li.open span {background-position:0 50%;}
	.storyNav li.current span {background-position:0 100%;}
	.storyNav li.open span a,
	.storyNav li.current span a {display:block;}
	.storyNav li.nav1 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72654/m/nav_1_v1.png);}
	.storyNav li.nav2 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72654/m/nav_2_v1.png);}
	.storyNav li.nav3 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72654/m/nav_3_v2.png);}
	</style>
</head>
<body>
	<div class="storyNav">
		<ul>
			<!-- for dev msg : 현재 보고있는 페이지 - current / 오픈된 페이지 open 붙여주세요 -->
			<% If Date() >="2016-08-29" then %>
				<li class="nav1 <% If Date() >="2016-08-29" then %>open<% end if %> <% if Ecode="72654" then %> current<% end if %>"><span><a href="<% If Date() >="2016-08-29" then %><%=appevturl%>eventid=72654<% end if %>" target="_top">1.석금호 대표 : 디자이너의 펜 이야기</a></span></li>
				<li class="nav2 <% If Date() >="2016-09-12" then %>open<% end if %> <% if Ecode="72992" then %> current<% end if %>"><span><a href="<% If Date() >="2016-09-12" then %><%=appevturl%>eventid=72992<% end if %>" target="_top">2. 작곡가 황성제 : 작곡가의 펜 이야기</a></span></li>
				<li class="nav3 <% If Date() >="2016-09-26" then %>open<% end if %> <% if Ecode="72993" then %> current<% end if %>"><span><a href="<% If Date() >="2016-09-26" then %><%=appevturl%>eventid=72993<% end if %>" target="_top">3. 김선현 건축가 : 건축가의 펜 이야기</a></span></li>
			<% end if %>
		</ul>
	</div>
</body>
</html>