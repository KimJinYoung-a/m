/*
    prd_item_basic.js와 전반적으로 동일
    but, product라는 object를 인자로 받는다는점이 다름

    ※ prd_item_basic.js는 각각의 인자를 따로 받음
*/

Vue.component('Product-Item-Basic',{
    template : /*html*/`
                <article :id="wish_place + '_' + product.item_id" :class="maskImageClassName" :style="{ width : product.isBigImage ? '100%' : '' }">
                    <Product-Rank
                        :item_rank="product.rank"
                    >
                    </Product-Rank>
                    <Product-Image
                        :image_url="product.list_image"
                        :image_style="product.image_style"
                    >
                    </Product-Image>
                    <div class="prd_info">
                        <Product-Price
                            :item_price="product.item_price"
                            :sale_percent="product.sale_percent"
                            :item_coupon_yn="product.item_coupon_yn"
                            :item_coupon_value="product.item_coupon_value"
                            :item_coupon_type="product.item_coupon_type"
                            :rental_yn="product.rental_yn"
                        >
                        </Product-Price>
                        <Product-Name
                            :item_name="product.item_name"
                        >
                        </Product-Name>
                        <Product-Brand
                            v-if="!isSummary"
                            :brand_name="product.brand_name"
                        >
                        </Product-Brand>
                        <Product-Badge
                            v-if="!isSummary"
                            :badge1="product.badge1"
                            :badge2="product.badge2"
                        >
                        </Product-Badge>
                        <Product-Evaluate
                            v-if="!isSummary"
                            :review_cnt="product.review_cnt"
                            :review_rating="product.review_rating"
                        >
                        </Product-Evaluate>
                    </div>
                    <a @click="click_product" class="prd_link"><span class="blind">상품 바로가기</span></a>
                    <WISH
                        v-if="!isBiz"
                        @change_wish_flag="change_wish_flag_item"
                        :id="product.item_id"
                        type="product"
                        :place="wish_place"
                        :on_flag="product.wish_yn"
                        :is_white="true"
                        :category="category"
                        :product_name="product.item_name"
                        :view_type="view_type"
                        :sort="sort"
                        :filter_recommend="filter_recommend"
                        :filter_category="filter_category"
                        :filter_brand="filter_brand"
                        :filter_delivery="filter_delivery"
                        :filter_lowprice="filter_lowprice"
                        :filter_highprice="filter_highprice"
                        :isApp="isApp"
                    >
                    </WISH>
                    <Product-MoreButton
                        :more_cnt="product.more_cnt"
                        :brand_id="product.brand_id"
                        @click_OpenModal="click_OpenModal"
                    >
                    </Product-MoreButton>
                    <Product-Big-Sale v-if="product.badge_big_sale" :isApp="isApp"></Product-Big-Sale>
                </article>
                `,
    props : {
        isApp: {type: Boolean, default: false}, //  M/A 구분 App === true , Mobile === false
        index: {type: Number, default:0}, // 상품 현재 인덱스
        wish_type : { type : String, default : '' }, // 위시 타입
        wish_place : { type : String, default : 'place' }, // 위시 장소
        product: {
            item_id: {type: Number, default: 0}, // 상품코드
            rank: {type: Number, default: 0}, // 상품 랭크 ex)best 사용
            list_image: {type: String, default: ''}, // 이미지 url
            image_style: {type: String, default: ''}, // 기타 추가할 스타일
            item_price: {type: Number, default: 0}, // 상품가격
            sale_percent: {type: Number, default: 0}, // 세일 퍼센트
            item_coupon_yn: {type: Boolean, default: false}, // 상품 쿠폰 존재 여부
            item_coupon_value: {type: Number, default: 0}, // 쿠폰값
            item_coupon_type: {type: String, default: '1'}, // 쿠폰유형(0:% 할인, 1:원 할인가격)
            item_name: {type: String, default: ''}, // 상품명
            brand_id: {type: String, default: ''}, // 브랜드ID
            brand_name: {type: String, default: ''}, // 브랜드명
            brand_name_en: {type: String, default: ''}, // 브랜드명(EN)
            review_cnt: {type: Number, default: 0}, // 후기 갯수
            review_rating: {type: Number, default: 0}, // 후기 평점
            amplitudeActionName: {type: String, default: ""}, // amplitude 지정이름
            rental_yn : { type : Boolean, default : false }, // 렌탈상품 여부
            wishType: {type: String, default: 'product'}, // 위시 타입
            wish_yn: {type: Boolean, default: false}, // 위시 on off flag
            sell_flag: {type: String, default: 'Y'}, // 판매상태
            adult_type: {type: Number, default: 0}, // 성인상품 구분
            isBigImage: {type: Boolean, default: false}, // 큰이미지 적용 여부
            badge1: {type: String, default: ''}, // 뱃지1 텍스트
            badge2: {type: String, default: ''}, // 뱃지 2 텍스트
            badge_big_sale: {type: Boolean, default: false}, // 뱃지 2 텍스트
            more_cnt: {type: Number, default: 0}, // 신규 상품 더보기 갯수
            move_url: {type: String, default: ''}, // 이동 할 Url
            category_code: {type: String, default: ''}, // 상품 카테고리 코드
            category_name: {type: String, default: ''}, // 상품 카테고리 코드
        },
        category: {type:Number, default:0}, // 현재 카테고리
        view_type: {type:String, default:''}, // 뷰 타입
        sort: {type:String, default:''}, // 정렬
        filter_recommend: {type:Array, default:function(){return [];}}, // 필터 - 추천
        filter_category: {type:Array, default:function(){return [];}}, // 필터 - 카테고리
        filter_brand: {type:Array, default:function(){return [];}}, // 필터 - 브랜드ID
        filter_delivery: {type:Array, default:function(){return [];}}, // 필터 - 배송
        filter_lowprice: {type:String, default:''}, // 필터 - 가격 최저가
        filter_highprice: {type:String, default:''}, // 필터 - 가격 최고가
        page : {type:Number, default:0}, // 현재 페이지
        isBiz : {type: Boolean, default: false}, // Biz상품 여부(WISH 표시 X)
        isSummary : {type: Boolean, default: false}, // Biz Summary 여부 (브랜드, 뱃지, 평점 표시 X)
        app_version_deny : {type: Boolean, default: false}, // Native Function APP version check
    },
    computed : {
        maskImageClassName() {
            return {
                prd_item : true,
                soldout : this.product.sell_flag !== "Y" ,
                adult : this.product.adult_type === 1
            }
        },
    },
    methods : {
        click_OpenModal(brand_id) { // 신상품 모달팝업
            this.$emit('click_OpenModal',brand_id);
        },
        click_product() {
            this.$emit('go_item_detail', this.index, this.product);
            if(this.isSummary){
                if(isApp){
                    if(this.app_version_deny){
                        if(confirm("신규 서비스 BIZ를 이용하시려면\n" +
                            "앱 업데이트가 필요해요!\n" +
                            "앱을 업데이트 하시겠어요?")){
                            let userAgent = navigator.userAgent.toLowerCase();

                            if(userAgent.match('iphone') || userAgent.match('ipad') || userAgent.match('ipod')) { //아이폰
                                location.href = "https://itunes.apple.com/kr/app/tenbaiten/id864817011";
                            } else if(userAgent.match('android')) { //안드로이드 기기
                                location.href = 'market://details?id=kr.tenbyten.shopping';
                            } else { //그 외
                                location.href = 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping';
                            }
                        }
                    }else {
                        const url = "https://m.10x10.co.kr/category/category_itemPrd.asp?itemid=" + this.product.item_id + "&flag=e";
                        const endcode_url = btoa(url);
                        fnOpenExternalBrowser(endcode_url);
                    }
                }else{
                    this.itemUrl(this.product.item_id, this.product.move_url);
                }
            }else{
                this.itemUrl(this.product.item_id, this.product.move_url);
            }
        }
    }
})