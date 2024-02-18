<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/etc/event72792Cls.asp" -->
<%
'####################################################
' Description : 1Week BIG SALE
' History : 2017-03-29 조경애 생성
'####################################################
%>
<%
Dim Ecode, appevturl, eGc
dim dday1, dday2, dday3, dday4
Ecode = requestCheckVar(Request("eventid"),8)
eGc = requestcheckvar(request("eGc"),10)

If isapp = "1" Then
	appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
Else
	appevturl = "/event/eventmain.asp?"
End If

if eGc = "" then
	if date() < "2017-04-10" then
		eGc = 203997
	elseif date() >= "2017-04-10" and date() < "2017-04-17" then
		eGc = 203998
	elseif date() >= "2017-04-17" and date() < "2017-04-24" then
		eGc = 203999 
	elseif date() >= "2017-04-24" then
		eGc = 204000
	end if
end if

dday1=DateDiff("D", Date(), CDate("2017-04-09"))
dday2=DateDiff("D", Date(), CDate("2017-04-16"))
dday3=DateDiff("D", Date(), CDate("2017-04-23"))
dday4=DateDiff("D", Date(), CDate("2017-05-02"))
%>
<style type="text/css">
.navigator {position:relative; z-index:2; background:#f4f7f7 url(http://webimage.10x10.co.kr/eventIMG/2017/72793/m/bg_tab.png) 0 0 no-repeat; background-size:100%;}
.navigator ul:after {content:' '; display:block; clear:both;}
.navigator ul li {position:relative; float:left; width:25%; padding-bottom:29.6%;}
.navigator ul li span {display:block; position:absolute; left:0; top:0; width:100%; height:100%; background-repeat:no-repeat; background-position:0 0; background-size:100% 200%;}
.navigator ul li a {display:block; height:100%; text-indent:-999em;}
.navigator ul li.nav1 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tab_1.png);}
.navigator ul li.nav2 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tab_2.png);}
.navigator ul li.nav3 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tab_3.png);}
.navigator ul li.nav4 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tab_4.png);}
.navigator ul li.finish span {background-position:0 100%;}
.navigator ul li.finish span a {display:none;}
.navigator ul li.current span:after {content:''; display:inline-block; position:absolute; top:0; z-index:30; width:103.75%; height:100%; background-position:0 0; background-repeat:no-repeat; background-size:100%;}
.navigator ul li.nav1.current span:after {left:1%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tab_01_on.png);}
.navigator ul li.nav2.current span:after {left:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tab_02_on.png);}
.navigator ul li.nav3.current span:after {left:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tab_03_on.png);}
.navigator ul li.nav4.current span:after {right:1%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tab_04_on.png);}
.just1week {width:94%; margin:0 auto; padding:1.7rem 0; text-align:center; font-size:1.2rem; line-height:1.4; border:1px solid #ddd; background-color:#fff;}
.just1week strong {font-size:1.3rem;}
.just1week em {color:#d60000;}
</style>
</head>
<body>
<script type="text/javascript">
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
<div class="bigsale">
	<div class="navigator">
		<ul>
			<!-- 현재 보고있는 페이지 current, 날짜 지난 페이지 current 붙여주세요 -->
			<li class="nav1 <% if date() < "2017-04-10" and eGc="203997" then %> current <% elseif date() >= "2017-04-10" then %>finish<% end if %>">
				<span>
					<% if date() < "2017-04-10" then %>
						<a href="" onclick="goEventLink('76948&amp;eGc=203997&amp;redt=on'); return false;">1주차(9/16-9/25)</a>
					<% else %>
						<a href="">1주차(9/16-9/25)</a>
					<% end if %>
				</span>
				<p class="dday"><em>D-<%= dday1 %></em></p>
			</li>

			<li class="nav2 <% if date() >= "2017-04-10" and date() < "2017-04-17" and eGc="203998" then %> current <% elseif date() >= "2017-04-17" then %>finish<% end if %>">
				<span>
					<% if date() >= "2017-04-10" and date() < "2017-04-17" then %>
						<a href="" onclick="goEventLink('76948&amp;eGc=203998&amp;redt=on'); return false;">2주차(9/26-10/2)</a>
					<% else %>
					<% end if %>
				</span>
				<p class="dday"><em>D-<%= dday2 %></em></p>
			</li>

			<li class="nav3 <% if date() >= "2017-04-17" and date() < "2017-04-24" and eGc="203999" then %> current <% elseif date() >= "2017-04-24" then %>finish<% end if %>">
				<span>
					<% if date() >= "2017-04-17" and  date() < "2017-04-24" then %>
						<a href="" onclick="goEventLink('76948&amp;eGc=203999&amp;redt=on'); return false;">3주차(10/3-10/9)</a>
					<% else %>
					<% end if %>
				</span>
				<p class="dday"><em>D-<%= dday3 %></em></p>
			</li>

			<li class="nav4 <% if date() >= "2017-04-24" then %> current <% elseif date() >= "2017-05-03" then %>finish<% end if %>">
				<span>
					<% if date() >= "2017-04-24" and  date() < "2017-05-03" then %>
						<a href="" onclick="goEventLink('76948&amp;eGc=204000&amp;redt=on'); return false;">4주차(10/10-10/16)</a>
					<% else %>
					<% end if %>
				</span>
				<p class="dday"><em>D-<%= dday4 %></em></p>
			</li>

		</ul>
	</div>
	<p class="just1week">알뜰하고 현명하게 준비하는<br /><strong>살림살이/집들이 선물 <em><% fnGetGroupMaxSalePer Ecode,eGc %>%~</em></strong></p>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->