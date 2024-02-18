<%' for dev msg : 진행중인 이벤트 _on.png / 종료된 이벤트 _off.png / 아직 오픈전인 이벤트 _yet.png입니다. %>
<% ' for dev msg : 진행중인 이벤트 선택된거_on.png 미선택인거 _off.png/ 종료된 이벤트 _close.png / 아직 오픈전인 이벤트 _yet.png입니다. %>
<li>
	<% if getnowdate>="2014-08-25" and getnowdate<"2014-09-04" then %>
		<% if eCode="54471" then %>
			<!--<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=54471" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_01_on.png" alt="일어날 기 사은이벤트" /></a>-->
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_01_close.png" alt="일어날 기 사은이벤트" />
		<% else %>
			<!--<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=54471" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_01_off.png" alt="일어날 기 사은이벤트" /></a>-->
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_01_close.png" alt="일어날 기 사은이벤트" />
		<% end if %>
	<% elseif getnowdate>="2014-09-04" then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_01_close.png" alt="일어날 기 사은이벤트" />
	<% else %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_01_yet.png" alt="일어날 기 사은이벤트" />
	<% end if %>
</li>
<li>
	<% if getnowdate>="2014-09-02" and getnowdate<"2014-09-10" then %>
		<% if eCode="54589" then %>
			<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=54591" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_02_on.png" alt="이를 승 출석체크 9월 2일 오픈" /></a>
		<% else %>
			<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=54591" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_02_off.png" alt="이를 승 출석체크 9월 2일 오픈" /></a>
		<% end if %>
	<% elseif getnowdate>="2014-09-10" then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_02_close.png" alt="이를 승 출석체크 9월 2일 오픈" />
	<% else %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_02_yet.png" alt="이를 승 출석체크 9월 2일 오픈" />
	<% end if %>
</li>
<li>
	<% if getnowdate>="2014-09-02" and getnowdate<"2014-09-10" then %>
		<% if eCode="54769" then %>
			<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=54769" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_03_on.png" alt="바꿀 전 더블마일리지 9월 2일 오픈" /></a>
		<% else %>
			<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=54769" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_03_off.png" alt="바꿀 전 더블마일리지 9월 2일 오픈" /></a>
		<% end if %>
	<% elseif getnowdate>="2014-09-10" then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_03_close.png" alt="바꿀 전 더블마일리지 9월 2일 오픈" />
	<% else %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_03_yet.png" alt="바꿀 전 더블마일리지 9월 2일 오픈" />
	<% end if %>
</li>
<li>
	<% if getnowdate>="2014-09-10" and getnowdate<"2014-09-13" then %>
		<% if eCode="54760" then %>
			<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=54762" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_04_on.png" alt="앱쇼핑 앱 쿠폰 9월 10일 오픈" /></a>
		<% else %>
			<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=54762" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_04_off.png" alt="앱쇼핑 앱 쿠폰 9월 10일 오픈" /></a>
		<% end if %>
	<% elseif getnowdate>="2014-09-13" then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/54589/tab_04_close.png" alt="앱쇼핑 앱 쿠폰 9월 10일 오픈" />
	<% else %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/54589/tab_04_yet.png" alt="앱쇼핑 앱 쿠폰 9월 10일 오픈" />
	<% end if %>
</li>