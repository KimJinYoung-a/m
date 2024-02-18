// 카테고리 탐색 메뉴
Vue.component('Category-Nav-Type1',{
    template : `
    <div class="ctgr_nav_type1">
        <header class="ctgr_nav_head">
            <a @click="pop_category_explorer">
                <h2 class="ttl">{{this_category.category_name}}<i class="i_arw_d2"></i></h2>
            </a>
        </header>
        <div v-if="categories != null && categories.length > 0" class="ctgr_nav_group">
            <!-- 하위 카테고리 리스트 -->
            <Row-Category
                @click_category="click_category"
                :categories="categories" :view_count="first_category_view_count"
                >
            </Row-Category>
            <button type="button" class="btn_more" v-if="more_category_count > 0" @click="view_more_category">
                {{more_category_count}}개의 카테고리 더보기
                <i class="i_arw_d1"></i>
            </button>
        </div>
    </div>
    `,
    props : {
        this_category : { // 현재 카테고리
            category_code : {type:Number, default:0}, // 카테고리 코드
            category_name : {type:String, default:''} // 카테고리 명
        },
        categories : { // 하위 카테고리 리스트
            catecode : {type:Number, default:0}, // 카테고리코드
            catename : {type:String, default:''}, // 카테고리명
            itemCount : {type:Number, default:0}, // 상품 수
            hasRowList : {type:Boolean, default:false} // 하위카테고리 보유 여부
        },
        first_category_view_count : {type:Number, default:100}, // 처음 노출할 하위 카테고리 수
    },
    computed : {
        more_category_count() {
            return this.categories.length - this.first_category_view_count;
        }
    },
    methods : {
         view_more_category () { // 카테고리 더보기
            $('.ctgr_nav_type1').find('.ctgr_nav_list li:gt(' + (this.first_category_view_count-1) + ')').fadeIn(100);
            $('.ctgr_nav_group .btn_more').hide();
        },
        click_category (category_code, has_row_list) { // 카테고리 클릭
             this.$emit('click_category', category_code, has_row_list);
        },
        pop_category_explorer() { // 카테고리 익스플로어 팝업
             this.$emit('pop_category_explorer');
        }
    }
});