var product_helper = {
    template : `
        <!-- 헬퍼 / 다른 사람들은 뭐 사지 (helper) -->
        <div class="modal_body">
            <div class="modal_cont">
                <div class="helper">
                    
                    <!-- 검색 결과 내 판매량순 1위 상품 노출 -->
                    <section v-if="parameter.best_seller.item_id" class="item_module">
                        <header class="head_type1">
                            <h2 class="ttl">가장 많이 판매된<br>상품이에요</h2>
                        </header>
                        <p class="bbl_ten bbl_b ani_bnc">{{number_format(parameter.best_seller.sell_cnt)}}개 판매되었어요</p>
                        <Product-Item-Type3
                            @change_wish_flag="change_helper_wish"
                            :item_id="parameter.best_seller.item_id"
                            :image_url="parameter.best_seller.big_image"
                            shape_type="circle"
                            :item_price="parameter.best_seller.item_price"
                            :sale_percent="parameter.best_seller.sale_percent"
                            :item_coupon_yn="parameter.best_seller.item_coupon_yn"
                            :item_coupon_value="parameter.best_seller.item_coupon_value"
                            :item_coupon_type="parameter.best_seller.item_coupon_type"
                            :item_name="parameter.best_seller.item_name"
                            :rental_yn="parameter.best_seller.rental_yn"
                            :wish_yn="parameter.best_seller.wish_yn"
                            wish_place="search_result_item_helper_topsales"
                            wish_type="best_seller"
                        ></Product-Item-Type3>
                    </section>
                    
                    <!-- 검색 결과 내 인기순 1위 상품 노출 -->
                    <section v-if="parameter.best_popularity.item_id" class="item_module">
                        <header class="head_type1">
                            <h2 class="ttl">요즘 제일<br>인기있는 상품이에요</h2>
                        </header>
                        <Product-Item-Type3
                            @change_wish_flag="change_helper_wish"
                            :item_id="parameter.best_popularity.item_id"
                            :image_url="parameter.best_popularity.big_image"
                            shape_type="round_diamond"
                            :item_price="parameter.best_popularity.item_price"
                            :sale_percent="parameter.best_popularity.sale_percent"
                            :item_coupon_yn="parameter.best_popularity.item_coupon_yn"
                            :item_coupon_value="parameter.best_popularity.item_coupon_value"
                            :item_coupon_type="parameter.best_popularity.item_coupon_type"
                            :item_name="parameter.best_popularity.item_name"
                            :rental_yn="parameter.best_popularity.rental_yn"
                            :wish_yn="parameter.best_popularity.wish_yn"
                            wish_place="search_result_item_helper_best"
                            wish_type="best_popularity"
                        ></Product-Item-Type3>
                    </section>
                    
                    <!-- MD추천 상품 -->
                    <section v-if="parameter.md_recommend.item_id" class="item_module">
                        <header class="head_type1">
                            <h2 class="ttl">MD가<br>적극 추천해요!</h2>
                        </header>
                        <Product-Item-Type3
                            @change_wish_flag="change_helper_wish"
                            :item_id="parameter.md_recommend.item_id"
                            :image_url="parameter.md_recommend.big_image"
                            shape_type="diamond"
                            :item_price="parameter.md_recommend.item_price"
                            :sale_percent="parameter.md_recommend.sale_percent"
                            :item_coupon_yn="parameter.md_recommend.item_coupon_yn"
                            :item_coupon_value="parameter.md_recommend.item_coupon_value"
                            :item_coupon_type="parameter.md_recommend.item_coupon_type"
                            :item_name="parameter.md_recommend.item_name"
                            :rental_yn="parameter.md_recommend.rental_yn"
                            :wish_yn="parameter.md_recommend.wish_yn"
                            wish_place="search_result_item_helper_mdspick"
                            wish_type="md_recommend"
                        ></Product-Item-Type3>
                    </section>
                    
                    <section v-if="parameter.best_rating.product" class="item_module">
                        <header class="head_type1">
                            <h2 class="ttl">평가가 가장<br>좋은 상품이에요</h2>
                        </header>
                        <article class="rv_item type3">
                            <div class="rv_info">
                                <span class="user_eval"><dfn>평점</dfn><i :style="{width : parameter.best_rating.review.rating*20 + '%'}">{{parameter.best_rating.review.rating*20}}점</i></span>
                                <div class="rv_desc ellipsis2">{{parameter.best_rating.review.content}}</div>
                                <span class="user_id"><dfn>작성자</dfn>{{parameter.best_rating.review.user_id}}</span>
                            </div>
                        </article>
                        <Product-Item-Type3
                            @change_wish_flag="change_helper_wish"
                            :item_id="parameter.best_rating.product.item_id"
                            :image_url="parameter.best_rating.product.big_image"
                            shape_type="bumpy"
                            :item_price="parameter.best_rating.product.item_price"
                            :sale_percent="parameter.best_rating.product.sale_percent"
                            :item_coupon_yn="parameter.best_rating.product.item_coupon_yn"
                            :item_coupon_value="parameter.best_rating.product.item_coupon_value"
                            :item_coupon_type="parameter.best_rating.product.item_coupon_type"
                            :item_name="parameter.best_rating.product.item_name"
                            :rental_yn="parameter.best_rating.product.rental_yn"
                            :wish_yn="parameter.best_rating.product.wish_yn"
                            wish_place="search_result_item_helper_review"
                            wish_type="best_rating"
                        ></Product-Item-Type3>
                    </section>
                    
                </div>
            </div>
        </div>
    `,
    props : {
        parameter: {
            best_seller : {type:Object, default:function(){return {};}}, // 판매량 1위 상품
            best_popularity : {type:Object, default:function(){return {};}}, // 인기 상품
            best_rating : {type:Object, default:function(){return {};}}, // 평가가 가장 좋은 상품
            md_recommend : {type:Object, default:function(){return {};}}, // MD 추천 상품
        }
    },
    methods: {
        change_helper_wish(wish_place, wish_type, id, flag) { // 상품 위시
            console.log('change_helper_wish', wish_place, wish_type, id, flag);
            this.$emit('wish_product', {
                wish_place: wish_place,
                wish_type: wish_type,
                item_id: id,
                on_flag : flag
            });
        }
    }
}