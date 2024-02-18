<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : the pen fair
' History : 2016-08-26 유태욱 생성
'####################################################
%>
<%
Dim Ecode, appevturl,vEventID, vStartNo

Ecode = requestCheckVar(Request("eventid"),8)
vEventID = requestCheckVar(Request("eventid"),8)

If isapp = "1" Then
	appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
Else
	appevturl = "/event/eventmain.asp?"
End If 

Select Case vEventID
	Case "72643"		vStartNo = 0
	Case "72720"		vStartNo = 0
	Case "72923"		vStartNo = 1
	Case "72924"		vStartNo = 2
	Case "73013"		vStartNo = 2
	Case Else			vStartNo = 0
End Select
%>
	<script type="text/javascript">
	$(function(){
		penDateSwiper = new Swiper('.penNav .swiper-container',{
			initialSlide:<%= vStartNo %>,
			loop:false,
			autoplay:false,
			speed:500,
			slidesPerView:'auto',
			pagination:false
		});
	});
	</script>
	<style>
	.penNav {position:relative; z-index:1; background:#fff;}
	.penNav .swiper-container {width:100%;}
	.penNav li {position:relative; float:left; width:9.1rem; height:6.3rem; background-position:0 0; background-repeat:no-repeat; background-size:100% auto;}
	.penNav li:after {content:''; display:inline-block; position:absolute; left:0; top:50%; width:1px; height:1.2rem; margin-top:-0.6rem; background:#c1c1c1;}
	.penNav li:first-child:after {display:none;}
	.penNav li span {display:block; width:9.1rem; height:6.3rem; background-position:0 0; background-repeat:no-repeat; background-size:100% auto;}
	.penNav li a {display:none; width:9.1rem; height:6.3rem; text-indent:-999em;}
	.penNav li.nav1,.penNav li.nav1 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_nav_1.png);}
	.penNav li.nav2,.penNav li.nav2 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_nav_2.png);}
	.penNav li.nav3,.penNav li.nav3 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_nav_3_v1.png);}
	.penNav li.nav4,.penNav li.nav4 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_nav_4.png);}
	.penNav li.nav5,.penNav li.nav5 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_nav_5_v2.png);}
	.penNav li.open span {background-position:0 -6.3rem;}
	.penNav li.current span {background-position:0 100%;}
	.penNav li.open span a,
	.penNav li.current span a {display:block;}

	.penNav li.nav3 {margin-right:1.5rem;}
	</style>
</head>
<body>
	<div class="penNav">
		<div class="swiper-container">
			<ul class="swiper-wrapper">
				<!-- for dev msg : 오픈된 페이지 open / 현재 보고있는 페이지 current 클래스 붙여주세요-->
				<% If Date() >="2016-08-26" then %>
					<li class="swiper-slide nav1 <% If Date() >="2016-08-26" then %>open<% end if %> <% if Ecode="72643" then %> current<% end if %>"><span><a href="<% If Date() >="2016-08-26" then %><%=appevturl%>eventid=72643<% end if %>" target="_top">25가지 볼펜</a></span></li>
					<li class="swiper-slide nav2 <% If Date() >="2016-09-05" then %>open<% end if %> <% if Ecode="72720" then %> current<% end if %>"><span><a href="<% If Date() >="2016-09-05" then %><%=appevturl%>eventid=72720<% end if %>" target="_top">25가지 만년필/캘리펜</a></span></li>
					<li class="swiper-slide nav3 <% If Date() >="2016-09-12" then %>open<% end if %> <% if Ecode="72923" then %> current<% end if %>"><span><a href="<% If Date() >="2016-09-12" then %><%=appevturl%>eventid=72923<% end if %>" target="_top">25가지 펠트팁펜</a></span></li>
					<li class="swiper-slide nav4 <% If Date() >="2016-09-19" then %>open<% end if %> <% if Ecode="72924" then %> current<% end if %>"><span><a href="<% If Date() >="2016-09-19" then %><%=appevturl%>eventid=72924<% end if %>" target="_top">25가지 멀티펜/젤펜</a></span></li>
					<li class="swiper-slide nav5 <% If Date() >="2016-09-26" then %>open<% end if %> <% if Ecode="73013" then %> current<% end if %>"><span><a href="<% If Date() >="2016-09-26" then %><%=appevturl%>eventid=73013<% end if %>" target="_top">25가지 펠트팁펜</a></span></li>
				<% end if %>
			</ul>
		</div>
	</div>
</body>
</html>