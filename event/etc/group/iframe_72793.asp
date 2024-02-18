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
' History : 2016-09-13 유태욱 생성
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
	if date() < "2016-09-26" then
		eGc = 187549
	elseif date() >= "2016-09-26" and date() < "2016-10-03" then
		eGc = 187550
	elseif date() >= "2016-10-03" and date() < "2016-10-10" then
		eGc = 187551 
	elseif date() >= "2016-10-10" then
		eGc = 187552
	end if
end if

dday1=DateDiff("D", Date(), CDate("2016-09-25"))
dday2=DateDiff("D", Date(), CDate("2016-10-02"))
dday3=DateDiff("D", Date(), CDate("2016-10-09"))
dday4=DateDiff("D", Date(), CDate("2016-10-16"))



%>
<style type="text/css">
.navigator {position:relative; z-index:2; padding-top:11%; background:#9cbce0;}
.navigator ul:after {content:' '; display:block; clear:both;}
.navigator ul li {position:relative; float:left; width:25%; padding-bottom:18.6%;}
.navigator ul li span {display:block; position:absolute; left:0; top:0; width:100%; height:100%; background-repeat:no-repeat; background-position:0 0; background-size:100% 300%;}
.navigator ul li.nav1 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72793/m/tab_1.png);}
.navigator ul li.nav2 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72793/m/tab_2.png);}
.navigator ul li.nav3 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72793/m/tab_3.png);}
.navigator ul li.nav4 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72793/m/tab_4.png);}
.navigator ul li.current span {background-position:0 50.1%;}
.navigator ul li.finish span {background-position:0 100%;}
.navigator ul li a {display:block; height:100%; text-indent:-999em;}
.navigator ul li.finish span a {display:none;}
.navigator ul li .dday {display:none; position:absolute; left:50%; top:-2.5rem; width:4rem; height:2.4rem; margin-left:-2rem; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72793/m/bg_rate.png) 0 0 no-repeat; background-size:100% 100%; animation-name:bounce; animation-duration:1.2s; animation-iteration-count:4;}
.navigator ul li .dday em {line-height:1.7rem; font-weight:bold; color:#fff;}
.navigator ul li.current .dday {display:block;}
.just1week {padding:2.5rem 0 1rem; text-align:center; font-size:1.2rem; line-height:1.4;}
.just1week em {color:#d83813; font-size:1.3rem; font-family:arial;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:5px; animation-timing-function:ease-in;}
}
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
			<li class="nav1 <% if date() < "2016-09-26" and eGc="187549" then %> current <% elseif date() >= "2016-09-26" then %>finish<% end if %>">
				<span>
					<% if date() < "2016-09-26" then %>
						<a href="" onclick="goEventLink('72793&amp;eGc=187549'); return false;">1주차(9/16-9/25)</a>
					<% else %>
						<a href="">1주차(9/16-9/25)</a>
					<% end if %>
				</span>
				<p class="dday"><em>D-<%= dday1 %></em></p>
			</li>

			<li class="nav2 <% if date() >= "2016-09-26" and date() < "2016-10-03" and eGc="187550" then %> current <% elseif date() >= "2016-10-03" then %>finish<% end if %>">
				<span>
					<% if date() >= "2016-09-26" and date() < "2016-10-03" then %>
						<a href="" onclick="goEventLink('72793&amp;eGc=187550'); return false;">2주차(9/26-10/2)</a>
					<% else %>
					<% end if %>
				</span>
				<p class="dday"><em>D-<%= dday2 %></em></p>
			</li>

			<li class="nav3 <% if date() >= "2016-10-03" and date() < "2016-10-10" and eGc="187551" then %> current <% elseif date() >= "2016-10-10" then %>finish<% end if %>">
				<span>
					<% if date() >= "2016-10-03" and  date() < "2016-10-10" then %>
						<a href="" onclick="goEventLink('72793&amp;eGc=187551'); return false;">3주차(10/3-10/9)</a>
					<% else %>
					<% end if %>
				</span>
				<p class="dday"><em>D-<%= dday3 %></em></p>
			</li>

			<li class="nav4 <% if date() > "2016-10-10" then %> current <% elseif date() >= "2016-10-17" then %>finish<% end if %>">
				<span>
					<% if date() >= "2016-10-10" and  date() < "2016-10-17" then %>
						<a href="" onclick="goEventLink('72793&amp;eGc=187552'); return false;">4주차(10/10-10/16)</a>
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