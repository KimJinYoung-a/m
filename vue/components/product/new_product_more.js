Vue.component('NEW-PRODUCT-MORE',{
    template : `
        <div class="modal_body">
            <div class="modal_cont">
                <div class="new_more">
                    <header class="head_type1">
                        <h2 class="ttl">
                            <a @click="linkToBrand">{{parameter.brand_name}}<i class="i_arw_r2"></i></a>
                            <br>새로 나왔어요
                        </h2>
                    </header>
                    <Product-Slider-Type4
                        @change_wish_flag="wish_product"
                        slider_id="new_product_more"
                        :products="parameter.items"
                        :brand_more_new_yn="parameter.more_yn"
                        @linkToBrand="linkToBrand"
                        :wish_place="wish_place"
                        :wish_type="wish_type"
                        :isApp="isApp"
                    ></Product-Slider-Type4>
                </div>
            </div>
        </div>
    `,
    data() {return {
        wish_type: 'more_new_product', // 위시 구분값
        wish_place: 'new_new_more'
    }},
    props : {
        isApp : {type:Boolean , default : false}, // 앱 여부
        parameter : {
            brand_id : {type : String , default : 0}, // 상품 ID
            brand_name : {type : String , default : ''}, // 상품명
            items : {
                item_id : {type : Number, default : 0}, // 상품 ID
                item_name : {type : String, default : ''}, // 상품명
                big_image : {type : String, default : ''}, // 큰 이미지
                item_price : {type : Number, default : 0}, // 상품가격
                sale_percent : {type : Number, default : 0}, // 세일 퍼센트
                item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
                item_coupon_value : {type : Number, default : 0}, // 쿠폰값
                item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:율, 1:가격)
                move_url : {type : String, default : ''}, // 이동할 URL
                wish_yn : {type : Boolean, default : false}, // 위시 여부
            }, // 상품명
            item_count : {type : Number , default : 0}, // 상품 ID
            more_url : {type : Number , default : 0}, // 상품 ID
            more_yn : {type : Number , default : 0}, // 상품 ID
        }
    },
    methods : {
        linkToBrand() {
            console.log('click brand link');
            console.log(this.parameter.brand_id);

            const _brandID = this.parameter.brand_id;
            this.isApp ? fnAPPpopupBrand(_brandID) : function() {
                let brandUrl = "/brand/brand_detail2020.asp?brandid="+ _brandID;
                location.href = brandUrl;
            }()
        },
        wish_product(wish_place, wish_type, item_id, flag) {
            this.$emit('wish_product', {
                wish_place: wish_place,
                wish_type: wish_type,
                item_id: item_id,
                on_flag : flag
            });
        }
    }
})