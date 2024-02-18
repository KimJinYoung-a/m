Vue.component('Brand-List',{
    template : `
            <!-- 브랜드 리스트 -->
            <div class="brd_list">
                <article class="brd_item"
                    v-for="(brand, index) in brands"
                    :key="brand.brand_id"
                    :id="'brand_' + index"
                >
                    <Brand-Image :image_url="brand.main_image"></Brand-Image>
                    <Brand-Info
                        :brand_name="brand.brand_name"
                        :best_yn="brand.best_yn"
                        :cate_name="brand.cate_name"
                        :search_keyword="search_keyword"
                    ></Brand-Info>
                    <a @click="click_brand(index, brand)" class="brd_link"><span class="blind">브랜드 바로가기</span></a>
                    <WISH
                        @change_wish_flag="change_wish_flag_item"
                        :id="brand.brand_id"
                        :brand_name_en="brand.brand_name_en"
                        type="brand"
                        :place="wish_place"
                        :on_flag="brand.wish_yn"
                        :isApp="isApp"
                    ></WISH>
                </article>
            </div>
    `,
    props : {
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        brands : {
            brand_id : { type : String, default : '' },      // 브랜드ID
            brand_name : { type : String, default : '' },    // 브랜드명
            brand_name_en : { type : String, default : '' },    // 브랜드명(EN)
            cate_name : { type : String, default : '' },     // 대표 카테고리명
            main_image : { type : String, default : '' },     // 메인 이미지
            move_url : { type : String, default : '' },      // 이동할 url
            wish_yn : { type : Boolean, default : false },      // 위시 여부(찜브랜드 여부)
            best_yn : { type : Boolean, default : false }       // 베스트브랜드 여부
        },
        search_keyword : {type:String, default:''}, // 검색 키워드
        isApp : { type : Boolean, default : false } // app 여부
    },
    methods : {
        click_brand(index, brand) {
            this.$emit('click_brand', index, brand);
            this.move_brand_page(brand.brand_id);
        }
    }
})