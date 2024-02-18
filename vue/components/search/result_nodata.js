Vue.component('Search-Result-Nodata',{
    template : `
            <div>
                <!-- 검색 결과 없음 -->
                <No-Data
                    @click_return_button="click_return_button"
                ></No-Data>
                
                <hr v-if="is_show_how_about_this" class="hr_div">
                
                <!-- 그게 아니면 이런 건 어때요? -->
                <section v-if="is_show_how_about_this && best_keywords.length > 0" class="item_module">
                    <header class="head_type1">
                        <h2 class="ttl">그게 아니면<br>이런 건 어때요?</h2>
                    </header>
                    <Tab-Type1 @click_tab="change_best_keyword" :tabs="best_keyword_tabs"></Tab-Type1>
                    <Product-List-Grid1
                        @change_wish_flag="change_wish_flag_list"
                        :products="best_products"
                        :wish_place="wish_place"
                        :wish_type="wish_type"
                    ></Product-List-Grid1>
                    <Item-Module-Footer-Button
                        @click_item_module_footer_btn="move_best_items_page"
                        :text="active_best_keyword + ' 상품 더보기'"
                    ></Item-Module-Footer-Button>
                </section>
            </div>
    `,
    data() {
        return{
            active_best_keyword: '' // 활성화중인 베스트 키워드
        }
    },
    props : {
        is_show_how_about_this: {type:Boolean, default:false}, // 이런건 어때요 노출 여부
        best_keywords: {type:Array, default:function(){return [];}}, // 베스트 키워드 리스트
        best_products: {type:Array, default:function(){return [];}}, // 베스트 키워드 상품 리스트
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
    },
    computed : {
        best_keyword_tabs() { // 베스트 키워드 탭 리스트
            const tabs = [];
            for( let i=0 ; i<this.best_keywords.length ; i++ ) {
                if( i===0 )
                    this.active_best_keyword = this.best_keywords[i];

                tabs.push({
                    value : this.best_keywords[i],
                    text : this.best_keywords[i],
                    is_active : i === 0
                });
            }
            return tabs;
        }
    },
    methods : {
        click_return_button() { // 돌아가기 버튼 클릭
            history.back();
        },
        change_best_keyword(keyword) { // 활성화 베스트 키워드 변경
            this.active_best_keyword = keyword;
            this.$emit('change_best_keyword', keyword);
        },
        move_best_items_page() { // 베스트 키워드 검색 결과 이동
            location.href = '/search/search_product2020.asp?keyword=' + this.active_best_keyword;
        },
    }
})