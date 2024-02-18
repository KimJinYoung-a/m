Vue.component('Product-Item-Type4',{
    template : `
        <article :class="['prd_item','type4', {soldout: sell_flag != 'Y'}]">
            <!-- 베스트 상품 : 순위 표시 (label_rank) -->
            <div v-if="rank != 0" class="label_rank"><span class="num">{{rank}}</span><span class="blind">위</span></div>
            <Product-Image :image_url="image_url"></Product-Image>
            <div class="prd_info">
                <Product-Price
                    :item_price="item_price"
                    :sale_percent="sale_percent"
                    :item_coupon_yn="item_coupon_yn"
                    :item_coupon_value="item_coupon_value"
                    :item_coupon_type="item_coupon_type"
                    :rental_yn="rental_yn"
                ></Product-Price>
                <Product-Name :item_name="item_name"></Product-Name>
            </div>
            <a @click="itemUrl(item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
            <WISH
                @change_wish_flag="change_wish_flag_item"
                :id="item_id"
                type="product"
                :place="wish_place"
                :product_name="item_name"
                :on_flag="wish_yn"
                :isApp="isApp"
            ></WISH>
        </article>
    `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        item_id: { type: Number, default: 0 }, // 상품코드
        image_url   : { type : String, default : '' }, // 이미지 url
        shape_type : { type : String, default : 'circle' }, // SVG 모양
        item_price : { type : Number, default : 0 }, // 최종 가격
        sale_percent : { type : Number, default : 0 }, // 세일 할인율
        item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
        item_coupon_value : {type : Number, default : 0}, // 쿠폰값
        item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:% 할인, 1:원 할인가격)
        item_name : { type : String, default : '' }, // 상품명
        amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
        rental_yn : { type : Boolean, default : false }, // 렌탈상품 여부
        wish_yn : { type : Boolean, default : false }, // 위시 on off flag
        rank : { type : Number, default : 0 }, // 순위
        wish_place : { type : String, default : 'place' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        sell_flag : { type : String, default : 'Y' } // 판매상태
    }
})