Vue.component('Brand-Set-Type1',{
    template : `
                <!-- 브랜드 SET 타입1 -->
                <div class="brd_set_type1">
                    <!-- 브랜드 유닛 -->
                    <article class="brd_item">
                        <figure class="brd_img">
                            <img :src="main_image" alt="">
                        </figure>
                        <div class="brd_info">
                            <div class="brd_name" lang="ko">{{brand_name_kr}}</div>
                            <div class="brd_name ellipsis2" lang="en">{{brand_name_en}}</div>
                            <div class="brd_desc ellipsis4" v-html="sub_copy"></div>
                        </div>
                        <a @click="move_brand_page(brand_id)" class="brd_link"><span class="blind">브랜드 바로가기</span></a>
                        <WISH
                            @change_wish_flag="wish_brand"
                            :id="brand_id"
                            :brand_name_en="brand_name_en"
                            type="brand"
                            :place="wish_place"
                            :on_flag="brand_wish_yn"
                            :category="category"
                            :is_white="true"
                            :isApp="isApp"
                        >
                        </WISH>
                    </article>
                    <!-- 브랜드 상품 리스트 -->
                    <div class="prd_list">
                        <template v-for="(product, index) in products">
                            <Product-Item-Photo
                                @change_wish_flag="change_wish_flag_list"
                                :key="index"
                                :isApp="isApp"                                
                                :item_id="product.item_id"
                                :item_name="product.item_name"
                                :image_url="product.item_image"     
                                :wish_yn="product.wish_yn"
                                :sell_flag="product.sell_flag"
                                :adult_type="product.adult_type"
                                :isBigImage="false"
                                :wish_place="wish_place + '_item'"
                                :wish_type="wish_type"
                                :category="category"
                            ></Product-Item-Photo>
                        </template>
                    </div>
                </div>
    `,
    props : {
        brand_id : {type:String, default:''}, // 브랜드ID
        main_image : {type:String, default:''}, // 메인 이미지
        brand_name_kr : {type:String, default:''}, // 브랜드명(KR)
        brand_name_en : {type:String, default:''}, // 브랜드명(EN)
        sub_copy : {type:String, default:''}, // 서브카피
        brand_wish_yn : {type:Boolean, default:false}, // 브랜드 위시 여부
        products : { // 상품 리스트
            item_id : {type : Number, default : 0}, // 상품 ID
            item_name : {type : String, default : ''}, // 상품명
            item_image : {type : String, default : ''}, // 큰 이미지
            sell_flag : {type : String, default : 'Y'}, // 판매 여부
            adult_type : {type : Number, default : 0}, // 성인상품 구분
            wish_yn : {type : Boolean, default : false} // 위시 여부
        },
        isApp : {type:Boolean, default:false},
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        category: {type:Number, default:0} // 현재 카테고리
    },
    methods: {
        wish_brand(id, on_flag) { // 브랜드 위시
            console.log('wish_brand', id, on_flag);
            this.$emit('wish_brand', id, on_flag);
        }
    }
})