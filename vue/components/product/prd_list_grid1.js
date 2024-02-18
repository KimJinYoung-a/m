Vue.component('Product-List-Grid1',{
    template : `<div class="prd_list type_grid1">
                    <Product-Item-Photo
                        v-for="(product, index) in products"
                        :key="index"
                        @change_wish_flag="change_wish_flag_list"
                        :isApp="isApp"
                        :item_id="product.item_id"
                        :item_name="product.item_name"
                        :image_url="product.item_image"
                        :image_style="product.image_style"
                        :amplitudeActionName="product.amplitudeActionName"
                        :wish_place="wish_place"
                        :wish_type="wish_type"
                        :wish_yn="product.wish_yn"
                        :sell_flag="product.sell_flag"
                        :adult_type="product.adult_type"
                        :isBigImage="product.isBigImage"
                        :sale_percent="product.sale_percent"
                    ></Product-Item-Photo>
                </div>
                `,
    props : {
        isApp : { type : Boolean, default : false }, // M/A 구분 App === true , Mobile === false
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        products : {
            item_id: { type: Number, default: 0 }, // 상품코드
            item_name : { type : String, default : '' }, // 상품명
            item_image : { type : String, default : '' }, // 이미지 url
            image_style : { type : String, default : '' }, // 기타 추가할 스타일
            amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
            wish_yn : { type : Boolean, default : false }, // 위시 on off flag
            sell_flag : { type : String, default : 'Y' }, // 판매상태
            adult_type : { type : Number, default : 0 }, // 성인상품 구분
            isBigImage : { type : Boolean, default : false }, // 큰이미지 적용 여부
            sale_percent : { type : Number, default : 0 }, // 할인율
        }
    },
})