var app = new Vue({
    el: '#app',
    store: store,
    template: `<div id="content" class="content best_detail">
                    <header class="head_type1">
                        <h2 class="ttl">
                            <a @click="click_period('D',$event)" class="tab active">오늘</a>
                            <a @click="click_period('W',$event)" class="tab">일주일간</a>
                            <a @click="click_period('M',$event)" class="tab">한달간</a>
                            <br>제일 잘 나가요
                        </h2>
                    </header>
                    <Category-Nav-Type2
                        ref="ctgrnav2"
                        @click_category="click_category"
                        :active_code="active_code"
                        :categories="categories"
                    ></Category-Nav-Type2>
                    <template v-if="first_loading_complete && items.length > 0">
                        <div class="prd_list type_basic">
                            <Product-Item-Basic
                                v-for="(item,index) in items"
                                :key="index"
                                :isApp="isApp"
                                :product="item"
                                @change_wish_flag="change_wish_flag_product"
                                :wish_place="best_wish_place"
                                wish_type="list"
                            ></Product-Item-Basic>
                        </div>
                    </template>
                    <template v-else-if="first_loading_complete">
                        <No-Data
                            :backUrlButtonDisplayFlag="false"
                        ></No-Data>
                    </template>

                    <!-- 탑 버튼 -->
                    <Button-Top/>
               </div>
            `,
    data() { return {
        active_period : 'D',
        active_category_code : 0,
        active_category_name : '전체',
    }},
    mixins : [item_mixin , common_mixin],
    created() {
        this.$store.commit('SET_DETAIL_TYPE', 'best'); // SET 상세 구분값

        // 카테고리 리스트 불러오기
        this.$store.commit('SET_URI', '/category/topDispCateList');
        this.$store.dispatch('GET_CATEGORIES');

        // 상품 목록 불러오기
        this.$store.commit('SET_URI', '/best/period/more');
        this.$store.dispatch('GET_PRODUCTS');
    },
    mounted() {
        this.scroll(this.loading_page); // 스크롤 시 페이지 로딩
        this.$refs.ctgrnav2.set_ctgrnav2_float(); // 카테고리 필터 슬라이더 플로팅

        fnAmplitudeEventObjectAction('view_best_best', {
            'period' : 'today',
            'category_code' : 0,
            'category_name' : '전체',
            'paging_index' : 1
        });
    },
    computed : {
        active_code() { // 활성화할 카테고리 코드
            return 0;
        },
        categories() { // 카테고리 리스트
            return this.$store.getters.categories;
        },
        items() { // 상품 리스트
            return this.$store.getters.items;
        },
        parameter() { // 파라미터
            return this.$store.getters.parameter;
        },
        isApp() { // 앱 여부
            return this.$store.getters.isApp;
        },
        first_loading_complete() { // 처음 loading 종료 여부
            return this.$store.getters.first_loading_complete;
        },
        best_wish_place() { // wish_place
            let period_place = 'best_best_';
            switch (this.active_period) {
                case 'D' : period_place += 'today'; break;
                case 'W' : period_place += 'week'; break;
                case 'M' : period_place += 'month'; break;
            }
            return period_place;
        }
    },
    methods : {
        click_period(date_type,event){
            $(event.target).addClass("active").siblings().removeClass("active");

            this.active_period = date_type;
            this.$store.commit('SET_PARAMETER', {period_type : date_type}); // 파라미터 변경
            this.$store.commit('SET_IS_LOADING_COMPLETE'); // 데이터 전체 로드 플레그
            this.$store.commit('SET_PAGE', 1); // 페이지 초기화
            this.$store.commit('CLEAR_ITEMS'); // 데이터 초기화
            this.$store.dispatch('GET_PRODUCTS'); // 데이터 로드

            const period = this.active_period === 'D' ? 'today' : (this.active_period === 'W' ? 'week' : 'month');
            fnAmplitudeEventObjectAction('view_best_best', {
                'period' : period,
                'category_code' : this.active_category_code,
                'category_name' : this.active_category_name,
                'paging_index' : 1
            });
        },
        click_category(category_code, category_name) {
            console.log('click ' + category_code, category_name);

            this.active_category_code = category_code;
            this.active_category_name = category_name;
            category_code = category_code === 0 ? '' : category_code

            this.$store.commit('SET_PARAMETER', {cate_code : category_code}); // 파라미터 카테고리 코드 변경
            this.$store.commit('SET_IS_LOADING_COMPLETE'); // 데이터 전체 로드 플레그
            this.$store.commit('SET_PAGE', 1); // 페이지 초기화
            this.$store.commit('CLEAR_ITEMS'); // 데이터 초기화
            this.$store.dispatch('GET_PRODUCTS'); // 데이터 로드

            const period = this.active_period === 'D' ? 'today' : (this.active_period === 'W' ? 'week' : 'month');
            fnAmplitudeEventObjectAction('view_best_best', {
                'period' : period,
                'category_code' : this.active_category_code,
                'category_name' : this.active_category_name,
                'paging_index' : 1
            });
        },
        loading_page() { // 페이징
            const next_page = this.$store.getters.next_page;

            this.$store.commit('SET_PAGE', next_page);
            this.$store.dispatch('GET_PRODUCTS');

            const period = this.active_period === 'D' ? 'today' : (this.active_period === 'W' ? 'week' : 'month');
            fnAmplitudeEventObjectAction('view_best_best', {
                'period' : period,
                'category_code' : this.active_category_code,
                'category_name' : this.active_category_name,
                'paging_index' : next_page
            });
        },
    }
});