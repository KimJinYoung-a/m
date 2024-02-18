var app = new Vue({
    el: '#app',
    store: store,
    template: `<div id="content" class="content new_detail">
                    <template v-if="first_loading_complete && items.length > 0">
                        <div class="prd_list type_basic">
                            <Product-Item-Basic
                                v-for="(item,index) in items"
                                :key="index"
                                :isApp="isApp"
                                :product="item"
                                @click_OpenModal="click_OpenModal"
                                @change_wish_flag="change_wish_flag_product"
                                wish_place="new_new"
                                wish_type="list"
                            ></Product-Item-Basic>
                        </div>
                    </template>
                    <template v-else-if="first_loading_complete">
                        <No-Data
                            :backUrlButtonDisplayFlag="false"
                        ></No-Data>
                    </template>
                    <Modal
                        :type=3
                        :content="slider_Type4"
                        :parameter="moreItems"
                        :isApp="isApp"
                        @wish_product="wish_more_product"
                    ></Modal>

                    <!-- 탑 버튼 -->
                    <Button-Top/>
               </div>
            `,
    mixins : [item_mixin , common_mixin, modal_mixin],
    data() {
        return {
            slider_Type4 : 'NEW-PRODUCT-MORE' // component name
        }
    },
    created() {
        this.$store.commit('SET_DETAIL_TYPE', 'new'); // SET 상세 구분값

        // 상품 목록 불러오기
        this.$store.commit('SET_URI', '/new/items');
        this.$store.dispatch('GET_PRODUCTS');

        fnAmplitudeEventObjectAction('view_new_new', {paging_index : 1});
    },
    mounted() {
        this.scroll(this.loading_page); // 스크롤 시 페이지 로딩
    },
    computed : {
        items() { // 상품 리스트
            return this.$store.getters.items;
        },
        parameter() { // 파라미터
            return this.$store.getters.parameter;
        },
        isApp() { // 앱 여부
            return this.$store.getters.isApp;
        },
        moreItems() {
            return this.$store.getters.moreItems;
        },
        first_loading_complete() { // 처음 loading 종료 여부
            return this.$store.getters.first_loading_complete;
        },
    },
    methods : {
        loading_page() { // 페이징
            const next_page = this.$store.getters.next_page;

            this.$store.commit('SET_PAGE', next_page);
            this.$store.dispatch('GET_PRODUCTS');

            fnAmplitudeEventObjectAction('view_new_new', {paging_index : next_page});
        },
        click_OpenModal(brand_id) { // 신상품 모달팝업
            this.$store.commit('CLEAR_MOREITEMS'); // 데이터 초기화
            this.$store.commit('SET_BRANDID' , brand_id ); // 데이터 초기화
            this.$store.commit('SET_URI', '/new/items/more');
            this.$store.dispatch('GET_MORE_PRODUCTS'); // 데이터 로드
            this.open_pop('modal');
        },
        wish_more_product(wish_info) {
            console.log('wish_more_product', wish_info, this.moreItems);
            this.$store.commit('UPDATE_PRODUCT_WISH', wish_info);
        }
    }
});