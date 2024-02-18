var app = new Vue({
    el: '#app',
    store : store ,
    template: '\
                <section class="xmas-item" id="xmas_item">\
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/tit_items.jpg" alt=""></h3>\
                    <SearchFilter></SearchFilter>\
                        <section class="prd_list type_basic">\
                            <item-list\
                                v-for="(item,index) in itemLists"\
                                :key="index"\
                                :index="index"\
                                :itemid="item.itemid"\
                                :itemimage="item.itemimage"\
                                :itemname="item.itemname"\
                                :brandname="item.brandname"\
                                :totalprice="item.totalprice"\
                                :saleperstring="item.saleperstring"\
                                :couponperstring="item.couponperstring"\
                                :totalsaleper="item.totalsaleper"\
                                :evalPoint="item.evalPoint"\
                                :evalCount="item.evalCount"\
                                :isApp="isApp"\
                            >\
                            </item-list>\
                        </section>\
                </section>\
            ',
    data : function() {
        return {
            isApp : isApp,
        }
    },
    computed: {
        pageSize : function() {
            return this.$store.state.params.pageSize;
        },
        itemLists : function() {
            console.log(this.$store.state.itemLists);
            return this.$store.state.itemLists;
        },
    },
    mounted() {
        this.scroll(); // 스크롤 시 페이지 로딩
    },
    created : function() {
        // mastercode init
        this.$store.commit('SET_MASTERCODE', '17');
        this.$store.commit('SET_PAGESIZE', { pageSize : 12 });
        this.$store.dispatch('GET_ITEMLISTS');
    },
    methods : {
        scroll : function() { 
            const _store = this.$store;

            window.onscroll = function () {
                
                if ($(window).scrollTop() >= ($(document).height() - $(window).height()) - 150) {
                    
                    _store.commit('SET_PAGENUMBER', _store.state.params.page+1);
                    console.log(_store.state.params.page+1);
                    _store.dispatch('GET_ITEMLISTS');
                }
            };
        }
    }
})
