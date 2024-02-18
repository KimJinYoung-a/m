<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 2016 웨딩 just 1week big sale
' History : 2016-03-25 유태욱 생성
'####################################################
%>
<style type="text/css">
body {background-color:transparent;}
.navigator {width:304px; height:105px; margin:0 auto; padding:23px 0 12px;}
.navigator:after {content:' '; display:block; clear:both;}
.navigator li {float:left; position:relative; width:70px; height:70px; margin:0 3px;}
.navigator li a,
.navigator li span {display:block; position:relative; width:100%; height:70px; color:#000; font-size:11px; line-height:20px; text-align:center;}
.navigator li a i,
.navigator li span i {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69756/m/bg_navigator_date_01.png) no-repeat 0 0; background-size:70px 260px;}
.navigator li.nav2 a i,
.navigator li.nav2 span i {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69756/m/bg_navigator_date_02.png);}
.navigator li.nav3 a i,
.navigator li.nav3 span i {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69756/m/bg_navigator_date_03.png);}
.navigator li.nav4 a i,
.navigator li.nav4 span i {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69756/m/bg_navigator_date_04.png);}
.navigator li .dDay {position:absolute; top:-23px; left:50%; width:51px; margin-left:-25px;}
.navigator li .dDay {animation-name:bounce; animation-iteration-count:3; animation-duration:2s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:3; -webkit-animation-duration:2s;}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform:translateY(0);}
	40% {transform:translateY(7px);}
	60% {transform:translateY(3px);}
}
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform:translateY(0);}
	40% {-webkit-transform:translateY(7px);}
	60% {-webkit-transform:translateY(3px);}
}

.navigator li span i {background-position:0 0;}
.navigator li .today i {background-position:0 -95px;}
.navigator li span.done i {background-position:0 100%;}

@media all and (min-width:360px){
	.navigator {width:336px;}
	.navigator li {width:78px; height:78px;}
	.navigator li a,
	.navigator li span {height:78px;}
	.navigator li a i, .navigator li span i {background-size:78px 289px;}

	.navigator li .dDay {position:absolute; left:50%; width:60px; margin-left:-30px;}

	.navigator li .today i {background-position:0 -106px;}
}

@media all and (min-width:480px){
	.navigator {width:480px; height:157px; padding:34px 0 18px;}
	.navigator li {width:105px; height:105px; margin:0 6px;}
	.navigator li a,
	.navigator li span {height:105px;}
	.navigator li a i, .navigator li span i {background-size:105px 389px;}

	.navigator li .dDay {position:absolute; top:-34px; left:50%; width:76px; margin-left:-38px;}

	.navigator li .today i {background-position:0 -142px;}
}
</style>

<% 
'		69757 JUST 1 WEEK BIG SALE #1 : 3.28-4.03
'		69758 JUST 1 WEEK BIG SALE #2 : 4.04-4.10
'		69759 JUST 1 WEEK BIG SALE #3 : 4.11-4.17
'		69760 JUST 1 WEEK BIG SALE #4 : 4.18-4.24
%>
	<ul class="navigator">
		<% If Date() >="2016-03-25" and Date() < "2016-04-04"then %>
			<li class="nav1">
				<span class="today">
					<i></i>1주차<br /> 3.28-4.03
				</span>
				<% if Date() ="2016-04-03" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_3.png" alt="D-day" /></b>
				<% end if %>
				<% if Date() ="2016-04-02" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_1.png" alt="D-1" /></b>
				<% end if %>
				<% if Date() ="2016-04-01" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_2.png" alt="D-2" /></b>
				<% end if %>
			</li>
		<% else %>
			<% if Date() > "2016-04-03"then %>
				<li class="nav1">
					<span class="done">
						<i></i>1주차<br /> 3.28-4.03
					</span>
				</li>
			<% else %>
				<li class="nav1">
					<span>
						<i></i>1주차<br /> 3.28-4.03
					</span>
				</li>
			<% end if %>
		<% end if %>

		<% If Date() >="2016-04-04" and Date() < "2016-04-11"then %>
			<li class="nav2">
				<span class="today">
					<i></i>2주차<br /> 4.04-4.10
				</span>
				<% if Date() ="2016-04-10" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_3.png" alt="D-day" /></b>
				<% end if %>
				<% if Date() ="2016-04-09" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_1.png" alt="D-1" /></b>
				<% end if %>
				<% if Date() ="2016-04-08" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_2.png" alt="D-2" /></b>
				<% end if %>
			</li>
		<% else %>
			<% if Date() > "2016-04-10"then %>
				<li class="nav2">
					<span class="done">
						<i></i>2주차<br /> 4.04-4.10
					</span>
				</li>
			<% else %>
				<li class="nav2">
					<span>
						<i></i>2주차<br /> 4.04-4.10
					</span>
				</li>
			<% end if %>
		<% end if %>

		<% If Date() >="2016-04-11" and Date() < "2016-04-18"then %>
			<li class="nav3">
				<span class="today">
					<i></i>3주차<br /> 4.11-4.17
				</span>
				<% if Date() ="2016-04-18" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_3.png" alt="D-day" /></b>
				<% end if %>
				<% if Date() ="2016-04-17" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_1.png" alt="D-1" /></b>
				<% end if %>
				<% if Date() ="2016-04-16" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_2.png" alt="D-2" /></b>
				<% end if %>
			</li>
		<% else %>
			<% if Date() > "2016-04-17"then %>
				<li class="nav3">
					<span class="done">
						<i></i>3주차<br /> 4.11-4.17
					</span>
				</li>
			<% else %>
				<li class="nav3">
					<span>
						<i></i>3주차<br /> 4.11-4.17
					</span>
				</li>
			<% end if %>
		<% end if %>

		<% If Date() >="2016-04-18" and Date() < "2016-04-25"then %>
			<li class="nav4">
				<span class="today">
					<i></i>4주차<br /> 4.18-4.24
				</span>
				<% if Date() ="2016-04-24" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_3.png" alt="D-day" /></b>
				<% end if %>
				<% if Date() ="2016-04-23" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_1.png" alt="D-1" /></b>
				<% end if %>
				<% if Date() ="2016-04-22" then %>
					<b class="dDay"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/ico_d_day_2.png" alt="D-2" /></b>
				<% end if %>
			</li>
		<% else %>
			<% if Date() > "2016-04-24"then %>
				<li class="nav4">
					<span class="done">
						<i></i>4주차<br /> 4.18-4.24
					</span>
				</li>
			<% else %>
				<li class="nav4">
					<span>
						<i></i>4주차<br /> 4.18-4.24
					</span>
				</li>
			<% end if %>
		<% end if %>
	</ul>
