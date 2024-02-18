Vue.component('Product-List-Magazine',{
	template : `
		<div class="prd_list">
			<article
				v-for="(item, index) in magazines"
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
					<div v-if="item.new_yn || item.mileage_item_yn" class="prd_badge">
						<span v-if="item.new_yn" class="badge_type1">new</span>
						<span v-if="item.mileage_item_yn" class="badge_type2">마일리지 구매상품</span>
					</div>
					<div class="prd_price">
						<span class="set_price" v-html="price_html(item)"></span>
					</div>
					<div class="prd_name">{{ item.item_name }}</div>
				</div>
				<a @click="click_magazine(index, item)" class="prd_link"><span class="blind">상품 바로가기</span></a>
			</article>
		</div>
	`,
	props : {
		isApp : { type : Boolean, default : false }, // 앱 여부
		magazines : {
			item_id : { type: Number, default: 0 }, // 상품코드
			item_image : { type : String, default : '' }, // 상품이미지 url
			item_name : { type : String, default : '' }, // 상품명
			item_price : {type : Number, default : 0}, // 상품가격
			mileage_item_yn : { type : Boolean, default : false }, // 마일리지상품 여부
			new_yn : { type : Boolean, default : false }, // new 여부
			sold_out_yn : { type : Boolean, default : false }, // 일시품절 여부
		}
	},
	methods : {
		price_html(item) {
			let price_html = '<dfn>판매가</dfn>';
			price_html += this.number_format(item.item_price);
			if (item.mileage_item_yn) {
				price_html += ' Point';
			}
			return price_html;
		},
		click_magazine(index, item) { // 매거진 클릭 Amplitude이벤트 전송 후 이동
			const parameter = `itemid=${item.item_id}&hAmpt=mgz_${index}`;
			if( this.isApp ) {
				fnAPPpopupBrowserRenewal('push', '상품정보'
					, `${vueAppUrl}/category/category_itemPrd.asp?${parameter}`);
			} else {
				location.href = `/category/category_itemPrd.asp?${parameter}`;
			}
		}
	}
})