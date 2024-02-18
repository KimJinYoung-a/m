Vue.component('Brand-Set-Type2',{
    template : `
                <!-- 브랜드 SET 타입2 -->
                <div class="brd_set_type2">
                    <div class="prd_list">
                        <article class="prd_item"
                            v-for="product in products"
                            :key="product.item_id"
                        >
                            <Product-Image
                                :image_url="product.item_image"
                            ></Product-Image>
                            <a @click="itemUrl(product.item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                        </article>
                    </div>
                    <article class="brd_item">
                        <div class="brd_info">
                            <div class="brd_name">{{brand_name}}<i class="i_arw_r2"></i></div>
                        </div>
                        <a @click="move_brand_page(brand_id)" class="brd_link"><span class="blind">브랜드 바로가기</span></a>
                        <WISH
                            @change_wish_flag="change_wish_flag_item"
                            :id="brand_id"
                            :brand_name_en="brand_name_en"
                            type="brand"
                            :place="wish_place"
                            :on_flag="wish_yn"
                            :wish_cnt="wish_cnt"
                            :isApp="isApp"
                        ></WISH>
                    </article>
                </div>
    `,
    props : {
        brand_id : {type:String, default:''}, // 브랜드ID
        brand_name : {type:String, default:''}, // 브랜드명(KR)
        brand_name_en : {type:String, default:''}, // 브랜드명(EN)
        wish_yn : {type:Boolean, default:false}, // 브랜드 위시 여부
        products : { // 상품 리스트
            item_id : {type : Number, default : 0}, // 상품 ID
            item_image : {type : String, default : ''}, // 큰 이미지
            sell_flag : {type : String, default : 'Y'}, // 판매 여부
            adult_type : {type : Number, default : 0}, // 성인상품 구분
            wish_yn : {type : Boolean, default : false} // 위시 여부
        },
        isApp : {type:Boolean, default:false},
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        wish_cnt : {type : Number, default : 0} // 위시 수
    }
})