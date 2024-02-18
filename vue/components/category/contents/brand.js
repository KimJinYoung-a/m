var brand_component = {
    template : `
    <section v-if="items != null" class="item_module">
		<header class="head_type1">
			<span class="txt">어머 나만 몰라</span>
			<h2 class="ttl">지금 뜨고 있는 브랜드</h2>
		</header>
		<Brand-Set-Type1
		    @wish_brand="wish_brand"
            @change_wish_flag="change_wish_flag_list"
		    :brand_id="items.brand_id"
		    :main_image="items.main_image"
		    :brand_name_kr="items.brand_name_kr"
		    :brand_name_en="items.brand_name_en"
		    :sub_copy="items.sub_copy"
		    :brand_wish_yn="items.brand_wish_yn"
		    :products="items.items"
		    :category="category"
            wish_type="brand"
            wish_place="category_main_brand"
		></Brand-Set-Type1>
	</section>
    `,
    props : {
        items: { // 브랜드 정보
            brand_id : {type:String, default:''}, // 브랜드ID
            main_image : {type:String, default:''}, // 메인 이미지
            brand_name_kr : {type:String, default:''}, // 브랜드명(KR)
            brand_name_en : {type:String, default:''}, // 브랜드명(EN)
            sub_copy : {type:String, default:''}, // 서브카피
            brand_wish_yn : {type:Boolean, default:false}, // 브랜드 위시 여부
            items : {type:Array, default:[]} // 상품 리스트
        },
        category: {type:Number, default:0} // 현재 카테고리
    },
    methods: {
        wish_brand(id, on_flag) { // 브랜드 위시
            console.log('wish_brand', id, on_flag);
            this.$emit('wish_brand', id, on_flag);
        }
    }
};