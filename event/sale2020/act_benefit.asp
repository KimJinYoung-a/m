<script src="/lib/js/common.js?v=<%= CC_currentyyyymmdd %>"></script>
<%
dim currentDate
currentDate = date()
'currentDate = "2020-04-18"
%>
<ul class="mApp">
	<% if currentDate >= "2020-04-10" and currentDate <= "2020-04-17" then %>
	<li>
		<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101991');" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit9.jpg" alt="백원자판기">
		</a>
	</li>
	<% end if %>
	
	<% if currentDate <= "2020-04-10" then %>
	<li>
		<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit8_v3.jpg" alt="포토후기 작성하면 +500P를 드려요!">
		</a>
	</li>
	<% elseif currentDate >= "2020-04-13" then %>
	<li>
		<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit8_v4.jpg" alt="포토후기 작성하면 +500P를 드려요!">
		</a>
	</li>
	<% end if %>

	<li>
		<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101305');" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit3.jpg?v=1.01" alt="지금 토스로 6만원이상 결제하면 5천원 즉시할인">
		</a>
	</li>

	<% if currentDate <= "2020-04-12" then %>
	<li>
		<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101392');" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit2.jpg?v=1.01" alt="APP푸시 동의하면 최대 1,000p 를 드려요!">
		</a>
	</li>
	<% elseif currentDate >= "2020-04-13" and currentDate <= "2020-04-18" then %>
	<li>
		<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101392');" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit2_v2.jpg" alt="APP푸시 동의하면 최대 1,000p 를 드려요!">
		</a>
	</li>
	<% end if %>

	<li>
		<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96333');" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit5.jpg?v=1.01" alt="이메일 동의하고 매달 10,000p에 도전하세요!">
		</a>
	</li>
	<li>
		<a href="" onclick="fnAPPpopupBrowserURL('클리어런스','http://m.10x10.co.kr/apps/appCom/wish/web2014/clearancesale/');" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit6.jpg?v=1.01" alt="최대 90% 숨겨져 있는 보물같은 할인 상품들">
		</a>
	</li>
</ul>


<ul class="mWeb">	
	<% if currentDate >= "2020-04-10" and currentDate <= "2020-04-17" then %>
	<li>
		<a href="/event/eventmain.asp?eventid=101990" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit9.jpg" alt="백원자판기">
		</a>
	</li>
	<% end if %>

	<% if currentDate <= "2020-04-10" then %>
	<li>
		<a href="/my10x10/goodsusing.asp" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit8_v3.jpg" alt="포토후기 작성하면 +500P를 드려요!">
		</a>
	</li>
	<% elseif currentDate >= "2020-04-13" then %>
	<li>
		<a href="/my10x10/goodsusing.asp" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit8_v4.jpg" alt="포토후기 작성하면 +500P를 드려요!">
		</a>
	</li>
	<% end if %>

	<li>
		<a href="/event/eventmain.asp?eventid=101305" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit3.jpg?v=1.01" alt="지금 토스로 6만원이상 결제하면 5천원 즉시할인">
		</a>
	</li>

	<% if currentDate <= "2020-04-12" then %>
	<li>
		<a href="/event/eventmain.asp?eventid=101391" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit2.jpg?v=1.01" alt="APP푸시 동의하면 최대 1,000p 를 드려요!">
		</a>
	</li>
	<% elseif currentDate >= "2020-04-13" then %>
	<li>
		<a href="/event/eventmain.asp?eventid=101391" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit2_v2.jpg" alt="APP푸시 동의하면 최대 1,000p 를 드려요!">
		</a>
	</li>
	<% end if %>

	<li>
		<a href="/event/eventmain.asp?eventid=96333" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit5.jpg?v=1.01" alt="이메일 동의하고 매달 10,000p에 도전하세요!">
		</a>
	</li>
	<li>
		<a href="/clearancesale" target="_blank">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_benefit6.jpg?v=1.01" alt="최대 90% 숨겨져 있는 보물같은 할인 상품들">
		</a>
	</li>
</ul>
<button class="btn-best" onclick="{$('html, body').animate({ scrollTop: menuScrollTop },400);initTabDisplay('dt');init('dt',1,'');}"><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/btn_best.png" alt="잠깐만요, 베스트상품보셨어요?"></button>