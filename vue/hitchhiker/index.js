var app = new Vue({
	el: '#app',
	store: store,
	mixins: [common_mixin, item_mixin, modal_mixin],
	template: `
		<div id="content" class="content hitchhiker">
			<!-- 배경 이미지 (GIF) : 어드민 등록 -->
			<div class="topic" :style="{ 'background-image': 'url(' + back_image + ')' }">
				<header class="title">
					<p>소소한 즐거움과<br>위로를 건낼 매거진</p>
					<h2>HITCHHIKER</h2>
				</header>

				<!-- 배너 -->
				<Hitchhiker-Banner
					@click_banner="pop_address"
					:address_banner_show_yn="address_banner_show_yn"
					:closed_application_yn="closed_application_yn"
					:editor_banner_show_yn="editor_banner_show_yn"
				></Hitchhiker-Banner>

				<!-- 구독 상품 링크 -->
				<div class="subscribe">
					히치하이커 1년 구독하기
					<a @click="click_subscription" class="link"></a>
				</div>
			</div>
			<div class="intro">
				<p>히치하이커는 격월간으로 발행되며,<br>매 호 다른 주제로<br>일상의 풍경을 담아냅니다.<br><br>히치하이커가 당신에게<br>소소한 즐거움, 작은 위로가 되길 바랍니다.</p>
			</div>
			<nav class="tab_nav">
				<ul class="tab_list">
					<li class="active"><a href="#magazine" @click="send_amplitude_tab('magazine')">MAGAZINE</a></li>
					<li><a href="#goods" @click="send_amplitude_tab('goods')">GOODS</a></li>
					<li><a href="#video" @click="send_amplitude_tab('video')">VIDEO</a></li>
				</ul>
			</nav>
			
			<section id="magazine" class="item_module">
				<!-- 매거진 상품 리스트
					- 썸네일, 뱃지(new/마일리지 구매상품), 가격, 상품명
					- new 뱃지 : 등록일로부터 3주간
					- 최근등록 순
					- 일시품절 클래스 (soldout)
					- 초기 최대 5개 + 더보기 버튼 노출, 클릭시 나머지 노출
				-->
				<Product-List-Magazine
					:isApp="isApp"
					:magazines="magazines"
				></Product-List-Magazine>
				<div v-if="magazines.length > 5" class="sect_foot">
					<button @click="render_more_magazines" class="btn_more">매거진 더보기<i class="i_arw_d2"></i></button>
				</div>
			</section>
			
			<section id="goods" class="item_module">
				<header class="head_type1">
					<h2 class="ttl">굿즈로 만나는<br>히치하이커</h2>
				</header>
				<!-- 굿즈 상품 리스트
					- 썸네일, 뱃지(new), 가격, 할인율, 상품명, 별점, 리뷰 수
					- new 뱃지 : 등록일로부터 3주간
					- 최근등록 순
					- 일시품절 클래스 (soldout)
					- 초기 최대 5개 + 더보기 버튼 노출, 클릭시 나머지 노출
				-->
				<Product-List-Goods
					:isApp="isApp"
					:goods="goods"
				></Product-List-Goods>
				<div v-if="goods.length > 5" class="sect_foot">
					<button @click="render_more_goods" class="btn_more">굿즈 더보기<i class="i_arw_d2"></i></button>
				</div>
			</section>

			<section id="video" class="item_module">
				<header class="head_type1">
					<h2 class="ttl">영상으로 만나는<br>히치하이커</h2>
					<p class="desc">다양한 이야기를 가진 히치하이커 비디오 콘텐츠는<br>새로운 주제로 홀수 달 셋째주 월요일, 찾아옵니다</p>
				</header>
				<!-- 영상 리스트
					- 썸네일, 영상 (iframe), 제목
					- 최근등록 순 / 최대 4개 노출
				-->
				<Video-List
					:isApp="isApp"
					:videos="videos"
				></Video-List>
			</section>

			<!-- 주소입력 모달 -->
			<Modal modal_id="address_modal"
				:type="4"
				:isApp="isApp"
			>
				<Hitchhiker-Address slot="body"
					ref="address_modal"
					@search_zipcode="search_zipcode"
					:parameter="address"
					:isApp="isApp"
				></Hitchhiker-Address>
			></Modal>

			<!-- 우편번호 입력 모달(Daum) -->
			<Modal modal_id="zipcode_modal" :type="4" :isApp="isApp">
				<Hitchhiker-Zipcode @choose_address="choose_address" slot="body" ref="zipcode" :isApp="isApp"></Hitchhiker-Zipcode>
			</Modal>

			<Modal modal_id="extra_modal"
				:type="4"
				:isApp="isApp"
			>
				<Hitchhiker-Extra slot="body"
					ref="extra"
					:isApp="isApp"
					@return_search="return_search"
					@enter_detail="enter_detail"
				></Hitchhiker-Extra>
			</Modal>

			<!-- 탑 버튼 -->
			<Button-Top/>
		</div>
	`,
	data() {
		return {
			isApp : isApp, // 앱 여부
		}
	},
	created() {
		this.$store.dispatch('GET_HITCHHIKER');

		this.send_main_view_amplitude(); // 메인 페이지 뷰 Amplitude 전송
	},
	mounted() {
		this.set_tab_float();
	},
	computed : {
		address_banner_show_yn() {
			return this.$store.getters.address_banner_show_yn;
		},
		closed_application_yn() {
			return this.$store.getters.closed_application_yn;
		},
		editor_banner_show_yn() {
			return this.$store.getters.editor_banner_show_yn;
		},
		back_image() {
			return this.$store.getters.back_image;
		},
		goods() {
			return this.$store.getters.goods;
		},
		magazines() {
			return this.$store.getters.magazines;
		},
		videos() {
			return this.$store.getters.videos;
		},
		address() {
			return this.$store.getters.address;
		},
	},
	methods : {
		set_tab_float() {
			var hflag = $('body').hasClass('hflag');
			var hdH = this.isApp && hflag ? 76 : $('.tenten_header').outerHeight();
			var tabH = $('.hitchhiker .tab_nav').outerHeight();
			$('.hitchhiker .tab_nav a').on('click', function(e) {
				e.preventDefault();
				var target = $(this.hash).offset().top - tabH - hdH;
				$('html, body').animate({scrollTop: target + 10}, 0);
			});
			$(window).on('scroll', function() {
				var tab = $('.hitchhiker .tab_nav');
				var st = $(window).scrollTop() + hdH;
				if (st >= tab.offset().top) {
					tab.addClass('fixed');
					controlTabActive(st+tabH);
				} else {
					tab.removeClass('fixed');
				}
			});
			function controlTabActive(st) {
				var current = 0;
				$('.item_module').each(function(i, el) {
					if (st >= $(el).offset().top)	current = i;
				});
				$('.hitchhiker .tab_nav li').eq(current).addClass('active').siblings('li').removeClass('active');
			}
		},
		render_more_magazines(e) {
			$(e.target).fadeOut();
			$('#magazine .prd_item:gt(4)').fadeIn();
		},
		render_more_goods(e) {
			$(e.target).fadeOut();
			$('#goods .prd_item:gt(4)').fadeIn();
		},
		pop_address() { // 주소입력 팝업
			this.$store.dispatch('GET_DATA_FOR_INSERT_ADDRESS');
		},
		is_empty(object) {
			return Object.keys(object).length === 0;
		},
		return_search() {
			this.close_pop('extra_modal');
			this.search_zipcode();
		},
		search_zipcode() { // 우편번호 찾기
			this.open_pop('zipcode_modal');
			this.$refs.zipcode.search_zip('zipcode_area');
		},
		choose_address(address) { // 주소 선택
			this.close_pop('zipcode_modal');
			this.open_pop('extra_modal');
			this.$refs.extra.choose_address(address);
		},
		enter_detail(address) { // 상세주소 입력
			this.close_pop('extra_modal');
			this.$refs.address_modal.enter_detail(address);
		},
		send_main_view_amplitude() {
			const access_path = getParameter('ap');
			let place; // 진입경로
			switch(access_path) {
				case 'today' : place = 'today_hitchhiker'; break; // 투데이하단
				case 'cm' : place = 'category_tab_hitchhiker'; break; // 카테고리 메인 탭
				default : place = 'etc'; // 기타
			}
			fnAmplitudeEventMultiPropertiesAction('view_hitchhiker_main', 'place', place);
		},
		click_subscription() { // 구독하기 클릭 시 Amplitude전송 후 이동
			const sub_item_id = 1496196;
			if( isApp ) {
				fnAPPpopupBrowserRenewal('push', '상품정보'
					, vueAppUrl + '/category/category_itemPrd.asp?hAmpt=sub&itemid=' + sub_item_id);
			} else {
				location.href = '/category/category_itemPrd.asp?hAmpt=sub&itemid=' + sub_item_id;
			}
		},
		send_amplitude_tab(tab_type) { // 플로팅 탭 클릭 Amplitude 이벤트 전송
			fnAmplitudeEventMultiPropertiesAction('click_hitchhiker_floatingtab', 'tab_type', tab_type);
		}
	},
	watch : {
		address(address) {
			if( !this.is_empty(address) ) {
				this.open_pop('address_modal');
			} else {
				alert('에러코드 : 003');
			}
		}
	}
});