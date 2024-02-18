<%' MAIN ROLLING %>
<script>
$(function(){
	var diaryMain = new Swiper(".diary-rolling .swiper-container", {
		pagination:".diary-rolling .pagination",
		paginationClickable:true,
		slidesPerView:'auto',
		speed:600,
		loop:true
	});
});
</script>
<div class="diary-rolling">
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<%' 1+1, gift 배너 평일만 %>
			<% If weekDate <> "토요일" and weekDate <> "일요일" and weekDate <> "공휴일" Then %>
				<% if cDiary.ftotalcount > 0 then %>
					<div class="swiper-slide">
						<% if isapp then %>
							<% if cDiary.FOneItem.Feventid <> "" then %>
							<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_giftbanner','itemid','<%=cDiary.FOneItem.FItemid%>',function(bool){if(bool) {fnAPPpopupEvent('<%=cDiary.FOneItem.Feventid%>');}});return false;">
							<% else %>
							<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_giftbanner','itemid','<%=cDiary.FOneItem.FItemid%>',function(bool){if(bool) {fnAPPpopupProduct('<%=cDiary.FOneItem.FItemid%>');}});return false;">
							<% end if %>
						<% else %>
							<% if cDiary.FOneItem.Feventid <> "" then %>
							<a href="javascript:goEventLink(<%=cDiary.FOneItem.Feventid%>);" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_giftbanner','itemid','<%=cDiary.FOneItem.FItemid%>');">
							<% else %>
							<a href="javascript:TnGotoProduct('<%=cDiary.FOneItem.FItemid%>');" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_giftbanner','itemid','<%=cDiary.FOneItem.FItemid%>');">
							<% end if %>
						<% end if %>
							<div class="thumbnail"><img src="//<%= imglink %>.10x10.co.kr/diary/oneplusone/<%= cDiary.FOneItem.Fmimage1 %>" alt="<%= cDiary.FOneItem.Fitemname %>" /></div>
							<% If GiftSu > 0 Then %>
							<div class="label">
								<span class="count"><em><%= GiftSu %>개</em><br/>남음</span>
								<% if cDiary.FOneItem.fplustype="1" then %>
								<span class="plus"></span>
								<% else %>
								<span class="gift"></span>
								<% end if %>
							</div>
							<% end if %>
						</a>
					</div>
				<% end if %>
			<% end if %>

			<%' 일반 배너 %>
			<% if cDiaryE.FTotalCount > 0 then %>
				<% for i = 0 to cDiaryE.FTotalCount -1 %>
					<div class="swiper-slide">
						<% if isapp then %>
						<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling','rollingnumber','<%=i+1%>',function(bool){if(bool) {fnAPPpopupAutoUrl('<%=cDiaryE.FItemList(i).Flinkpath %>');}});return false;">
						<% else %>
						<a href="<%=cDiaryE.FItemList(i).Flinkpath %>" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling','rollingnumber','<%=i+1%>');">
						<% end if %>
							<div class="thumbnail"><img src="<%= cDiaryE.FItemList(i).GetImageUrl %>" alt="<%= cDiaryE.FItemList(i).Fitemname %>" /></div>
						</a>
					</div>
				<% next %>
			<% end if %>
			
			<% if date() < "2018-09-24" then '다이애나 %>
			<div class="swiper-slide">
				<div class="prev-thumb">
					<% if isapp then %>
					<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_diana','eventcode','89316',function(bool){if(bool) {fnAPPpopupEvent('89316');}});return false;">
					<% else %>
					<a href="/event/eventmain.asp?eventid=89316" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_diana','eventcode','89316');">
					<% end if %>
						<img src="//webimage.10x10.co.kr/fixevent/event/2018/89316/m/img_main_rolling_vod.jpg" alt="텐바이텐 X 유튜버 다이애나" />
					</a>
				</div>
			</div>
			<% elseif date() >= "2018-09-24" and date() < "2018-10-08" then '망고펜슬 %>
			<div class="swiper-slide">
				<% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','89423',function(bool){if(bool) {fnAPPpopupEvent('89423');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=89423" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','89423');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/89423/m/img_main_rolling_vod.jpg" alt="" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-10-08" and date() < "2018-10-15" then '달밍 %>
			<div class="swiper-slide">
				<% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','89628',function(bool){if(bool) {fnAPPpopupEvent('89628');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=89628" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','89628');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/89628/m/img_main_rolling_vod.jpg" alt="텐바이텐과 함께하는 유튜버 달밍" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-10-15" and date() < "2018-10-22" then '초은작가 %>
			<div class="swiper-slide">
				<% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','89817',function(bool){if(bool) {fnAPPpopupEvent('89817');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=89817" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','89817');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/89817/m/img_main_rolling_vod.jpg" alt="텐바이텐과 함께하는 초은작가" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-10-22" and date() < "2018-10-29" then '너도 밤나무 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','89818',function(bool){if(bool) {fnAPPpopupEvent('89818');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=89818" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','89818');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/89818/m/img_main_rolling_vod.jpg" alt="텐바이텐과 함께하는 너도밤나무" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-10-29" and date() < "2018-11-12" then '소담한 작업실 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90070',function(bool){if(bool) {fnAPPpopupEvent('90070');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=90070" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90070');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/90070/m/img_main_rolling_vod.jpg" alt="텐바이텐 소담한 작업실" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-11-12" and date() < "2018-11-19" then '라이브워크 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90249',function(bool){if(bool) {fnAPPpopupEvent('90249');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=90249" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90249');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/90249/m/img_main_rolling_vod.jpg" alt="텐바이텐 X 오율하 - 라이브워크" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-11-19" and date() < "2018-11-26" then '마스킹테이프1탄 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90582',function(bool){if(bool) {fnAPPpopupEvent('90582');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=90582" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90582');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/90582/m/img_main_rolling_vod.jpg" alt="마스킹테이프 1탄" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-11-26" and date() < "2018-12-03" then '마테백과사전 vol.2 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90718',function(bool){if(bool) {fnAPPpopupEvent('90718');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=90718" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90718');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/90718/m/img_main_rolling_vod.jpg" alt="신비한 마테백과사전 vol.2" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-12-03" and date() < "2018-12-10" then '텐바이텐과 함께하는 유튜버 밥팅 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90879',function(bool){if(bool) {fnAPPpopupEvent('90879');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=90879" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90879');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/90879/m/img_main_rolling_vod.jpg" alt="텐바이텐과 함께하는 유튜버 밥팅" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-12-10" and date() < "2018-12-17" then '다꾸의 정석, 데코다꾸 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90871',function(bool){if(bool) {fnAPPpopupEvent('90871');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=90871" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','90871');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/90871/m/img_main_rolling_vod.jpg" alt="다꾸의 정석, 데코다꾸" /></div>
				</a>
			</div>
			<% elseif date() >= "2018-12-17" and date() < "2019-01-14" then '어서와, 이런 문방구는 처음이지 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','91292',function(bool){if(bool) {fnAPPpopupEvent('91292');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=91292" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','91292');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2018/91292/m/img_main_rolling_vod.jpg" alt="어서와, 이런 문방구는 처음이지" /></div>
				</a>
			</div>
			<% elseif date() >= "2019-01-14" and date() < "2019-01-28" then '신비한 마테백과사전vol.3 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','91894',function(bool){if(bool) {fnAPPpopupEvent('91894');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=91894" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','91894');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/91894/m/img_main_rolling_vod.jpg" alt="신비한 마테백과사전vol.3" /></div>
				</a>
			</div>
			<% elseif date() >= "2019-01-28" and date() < "2019-04-11" then '우리가 기억하는 올해의 다이어리 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','92235',function(bool){if(bool) {fnAPPpopupEvent('92235');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=92235" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','92235');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92235/m/img_main_rolling_vod.jpg" alt="우리가 기억하는 올해의 다이어리" /></div>
				</a>
			</div>
			<% elseif date() >= "2019-04-11" and date() < "2019-04-17" then '유튜버 망고펜슬의 디즈니 다꾸 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','93796',function(bool){if(bool) {fnAPPpopupEvent('93796');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93796" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','93796');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93796/m/img_main_rolling_vod.jpg" alt="세상모든 디즈니 아이템이 여기에!" /></div>
				</a>
			</div>
			<% elseif date() >= "2019-04-17" and date() < "2019-04-19" then '유투버 추삐 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','93883',function(bool){if(bool) {fnAPPpopupEvent('93883');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93883" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','93883');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93883/m/img_main_rolling_vod.jpg" alt="세상모든 디즈니 아이템이 여기에!" /></div>
				</a>
			</div>
			<% elseif date() >= "2019-04-19" and date() < "2019-06-03" then '유투버 하영의 디즈니 언박싱 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','93887',function(bool){if(bool) {fnAPPpopupEvent('93887');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=93887" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','93887');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93887/m/img_main_rolling_vod.jpg" alt="유투버 하영의 디즈니 언박싱" /></div>
				</a>
			</div>
			<% elseif date() >= "2019-06-03" and date() < "2019-08-21" then '유투버 망고펜슬 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','94995',function(bool){if(bool) {fnAPPpopupEvent('94995');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=94995" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','94995');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94995/m/img_main_rolling_vod.jpg" alt="유투버 망고펜슬" /></div>
				</a>
			</div>
			<% elseif date() >= "2019-08-21" then '유투버 망고펜슬 %>
			<div class="swiper-slide">
				 <% if isapp then %>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','96769',function(bool){if(bool) {fnAPPpopupEvent('96769');}});return false;">
				<% else %>
				<a href="/event/eventmain.asp?eventid=96769" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_rolling_youtube','eventcode','96769');">
				<% end if %>
					<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96769/m/img_main_rolling_vod.jpg" alt="유투버 나키" /></div>
				</a>
			</div>
			<% end if %>
		</div>
	</div>
	<div class="pagination"></div>
</div>
<%' MAIN ROLLING %>