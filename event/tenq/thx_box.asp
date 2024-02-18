<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description :텐큐베리감사 : 텐큐박스
' History : 2018-03-30 정태훈
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67498
Else
	eCode   =  85147
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.thx-box .vod {padding:0 4.6%; background-color:#fa5356;}
.thx-box .vod .inner {width:100%;height:18.3rem;border:solid .42rem #9b19cf; border-radius:.426rem;}
.thx-box .vod iframe {width:100%; height:100%;}
.thx-box .noti {background:#0a9b9d;}
.thx-box .noti ul {padding:0 6% 4.1rem;}
.thx-box .noti li {padding:1rem 0 0 0.65rem; color:#fff; font-size:1.02rem; line-height:1.52rem; text-indent:-0.65rem;}
.thx-box .noti li:first-child {padding-top:0;}
.tenq-navigation {background-color:#fff;}
.tenq-navigation li {padding-top:0.85rem;}
.tenq-navigation li:first-child {padding-top:0;}
</style>
			<!-- 텐큐베리감사 : 텐큐박스 -->
			<div class="mEvt85145 tenq thx-box">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85147/m/tit_thx_box.jpg" alt="" /></h2>
				<div class="vod"><div class="inner"><iframe src="https://www.youtube.com/embed/KEMKJ_yqIPU?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div></div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85147/m/txt_evt.jpg" alt="" /></p>
				<div class="process"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85147/m/txt_how_to.jpg" alt="" /></div>
				<a href="https://m.facebook.com/your10x10/videos/1879157532104750/" onclick="fnAPPpopupExternalBrowser('https://m.facebook.com/your10x10/videos/1879157532104750/'); return false;" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85147/m/txt_fb.png" alt="페이스북 이동" /></a>
				<!-- 유의사항 -->
				<div class="noti">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85147/m/tit_noti.png" alt="유의사항" /></h3>
					<ul>
						<li>- 본 이벤트는 텐바이텐 공식 페이스북(@your10x10)에서 진행되는 이벤트입니다.</li>
						<li>- 텐바이텐 공식 페이스북 페이지를 팔로우 하지 않을 시<br/ > 당첨자 명단에서 제외될 수 있습니다.</li>
						<li>- 당첨자 발표는 페이스북을 통해 04월 23일 월요일에<br/ > 발표할 예정입니다.</li>
						<li>- 이벤트 발표는 텐바이텐 페이스북 페이지, 텐바이텐 사이트 내<br/ >공지사항에 기재됩니다.</li>
						<li>- 당첨자에게는 세무신고에 필요한 개인정보를<br/ > 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					</ul>
				</div>
				<div class="tenq-navigation">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/txt_event.png" alt="이벤트 더보기" /></h3>
					<ul>
						<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=85144"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_main.png" alt="텐큐베리감사 다양한 혜택의 쿠폰받기" /></a></li>
						<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=85145"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_miracle.png" alt="100원에 도전하라" /></a></li>
						<li><% If isapp="1" Then %><a href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid=85146"><% Else %><a href="/event/eventmain.asp?eventid=85634"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_mileage.png" alt="매일받자 마일리지" /></a></li>
					</ul>
				</div>
			</div>
			<!--// 텐큐베리감사 : 텐큐박스 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->