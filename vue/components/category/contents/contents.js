Vue.component('Contents',{
    template: `
    <div class="category_content">
        <component
            v-for="(content, index) in content_order"
            @click_more_button="click_more_button"
            @wish_brand="wish_brand"
            @change_wish_flag="change_wish_flag_list"
            :key="index"
            :is="get_component(index)"
            :items="get_items(index)"
            :category="category"
        ></component>
    </div>
    `,
    data() {
        return {
            Banner : banner_component,
            Exhibition : exhibition_component,
            Brand : brand_component
        }
    },
    props : {
        banners: { // 배너 리스트
            banner_image : String,
            banner_text : String,
            move_url : String
        },
        exhibitions: { // 기획전 리스트
            evt_code : Number,
            evt_name : String,
            banner_img : String,
            sale_and_coupon : String,
            badge1 : String,
            badge2 : String,
            move_url : String,
            wish_yn : Boolean
        },
        brand: { // 지금 뜨고있는 브랜드
            brand_id : {type:String, default:''}, // 브랜드ID
            main_image : {type:String, default:''}, // 메인 이미지
            brand_name_kr : {type:String, default:''}, // 브랜드명(KR)
            brand_name_en : {type:String, default:''}, // 브랜드명(EN)
            sub_copy : {type:String, default:''}, // 서브카피
            brand_wish_yn : {type:Boolean, default:false}, // 브랜드 위시 여부
            items : {type:Array, default:[]} // 상품 리스트
        },
        content_order: Array, // 컨텐츠 순서
        category: {type:Number, default:0} // 현재 카테고리
    },
    methods : {
        get_component : function(idx) { // GET 컴포넌트
            var component_type = this.content_order[idx];
            switch (component_type) {
                case 'banner': return this.Banner;
                case 'exhibition' : return this.Exhibition;
                case 'brand' : return this.Brand;
                default: return this.Banner;
            }
        },
        get_items : function(idx) { // GET 아이템 리스트
            var component_type = this.content_order[idx];
            switch (component_type) {
                case 'banner': return this.banners;
                case 'exhibition' : return this.exhibitions;
                case 'brand' : return this.brand;
                default: return this.banners;
            }
        },
        click_more_button() {
            this.$emit('click_more_button');
        },
        wish_brand(id, on_flag) { // 브랜드 위시
            console.log('wish_brand', id, on_flag);
            this.$emit('wish_brand', id, on_flag);
        }
    }
});