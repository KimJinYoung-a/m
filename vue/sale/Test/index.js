// todo : 세일상품 전체보기 링크

var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin],
    template: `
        <div id="content" class="content category_main">
            <!-- 뭐 없을까 싶을 떄 -->
		    <section class="item_module">
                <header class="head_type1">
                    <span class="txt">아 돈 쓰고 싶은데</span>
                    <h2 class="ttl">뭐 없을까 싶을 때</h2>
                </header>
                <Tab-Type1 @click_tab="change_wonder_type" :tabs="titles"></Tab-Type1>
                <template v-for="title in titles">
                    <Product-List-Grid2
                        v-show="active_wonder_type == title.value"
                        :key="title.value"
                        :products="show_wonders"
                    ></Product-List-Grid2>
                </template>
		    </section>
        </div>
    `,
    data() { return {
        is_loading : false,
        show_wonders : []
    }},
    created() {
        this.$store.dispatch('GET_MAIN_ITEMS');
    },
    computed : {
        wonder_products : function() { // 뭐 없을까 싶을 때 상품 리스트
            return this.$store.getters.wonder_products;
        },
        titles : function() { // 뭐 없을까 싶을 때 상품 리스트
            return this.$store.getters.titles;
        },
        active_wonder_type : function() { // 뭐 없을까 싶을 때 상품 리스트
            return this.$store.getters.active_wonder_type;
        },
    },
    methods : {
        change_wonder_type(type) { // 뭐 없을까 싶을 때 탭 변경
            this.$store.commit('SET_ACTIVE_WONDER_TYPE', type);
            this.show_wonders = [];
            this.get_wonders(type);
        },
        get_wonders(type) {
            let index = 0;
            const _this = this;

            _this.is_loading = true;
            let interval = setInterval(function() {
                if( _this.is_loading ) {
                    _this.get_wonder(type, index++);
                } else {
                    clearInterval(interval);
                }
            }, 200);
        },
        get_wonder(type, index) {
            const wonder = this.wonder_products[type][index];
            if( wonder !== undefined ) {
                this.show_wonders.push(wonder);
            } else {
                this.is_loading = false;
            }
        }
    }
});