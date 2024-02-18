Vue.component('Product-List-Goods',{
	template : `
		<div class="prd_list">
			<article
				v-for="(item, index) in goods"
				:key="index"
				v-show="index < 5"
				:class="['prd_item', {soldout : item.sold_out_yn}]"
			>
				<figure class="prd_img">
					<img :src="item.item_image" alt="">
					<span class="prd_mask"></span>
				</figure>
				<div class="prd_info">
					<!-- 뱃지 있을 경우 노출 (prd_badge) -->
					<div v-if="item.new_yn" class="prd_badge">
						<span class="badge_type1">new</span>
					</div>
					<div class="prd_price">
						<span class="set_price"><dfn>판매가</dfn>{{ number_format(item.item_price) }}</span>
						<span class="discount" v-html="get_discount_html(item)"></span>
					</div>
					<div class="prd_name">{{ item.item_name }}</div>
					<div v-if="get_review_point(item.review_rating) > 79" class="user_side">
						<span class="user_eval"><dfn>평점</dfn><i :style="{width: get_review_point(item.review_rating) + '%'}"></i></span>
						<span class="user_comment" v-if="item.review_cnt > 4"><dfn>상품평</dfn>{{ item.review_cnt }}</span>
					</div>
				</div>
				<a @click="click_goods(index, item)" class="prd_link"><span class="blind">상품 바로가기</span></a>
			</article>
		</div>
	`,
	props : {
		isApp : { type : Boolean, default : false }, // 앱 여부
		goods : {
			item_id : { type: Number, default: 0 }, // 상품코드
			item_image : { type : String, default : '' }, // 상품이미지 url
			item_name : { type : String, default : '' }, // 상품명
			item_price : {type : Number, default : 0}, // 상품가격
			sale_percent : {type : Number, default : 0}, // 상품 할인율
			new_yn : { type : Boolean, default : false }, // new 여부
			sold_out_yn : { type : Boolean, default : false }, // 일시품절 여부
			review_cnt : { type : Number, default : 0 }, // 후기 갯수
			review_rating : { type : Number, default : 0 }, // 후기 평점
		}
	},
	methods : {
		get_review_point(review_rating) {
			return review_rating * 20;
		},
		click_goods(index, item) { // 굿즈 클릭 Amplitude이벤트 전송 후 이동
			const parameter = `itemid=${item.item_id}&hAmpt=gd_${index}`;
			if( this.isApp ) {
				fnAPPpopupBrowserRenewal('push', '상품정보'
					, `${vueAppUrl}/category/category_itemPrd.asp?${parameter}`);
			} else {
				location.href = `/category/category_itemPrd.asp?${parameter}`;
			}
		}
	}
})