var app = new Vue({
    el: '#app',
    store : store ,
    template: '\
                <section class="xmas-item">\
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/tit_item.jpg" alt="당신의 픽을 위한 추천"></h3>\
                    <template\
                        v-for="(itemlist,i) in partitionItemLists"\
                    >\
                        <div class="category-item">\
                            <h4>{{itemListName(i)}}</h4>\
                            <div class="items type-grid">\
                                <ul>\
                                    <item-list\
                                        v-for="(item,index) in itemlist.items"\
                                        :key="itemlist.cateogry"\
                                        :itemid="item.itemid"\
                                        :itemimage="item.itemimage"\
                                        :itemname="item.itemname"\
                                        :brandname="item.brandname"\
                                        :totalprice="item.totalprice"\
                                        :saleperstring="item.saleperstring"\
                                        :couponperstring="item.couponperstring"\
                                        :isApp="isApp"\
                                        v-show="index < itemlist.itemShowLimitCount"\
                                    >\
                                    </item-list>\
                                </ul>\
                                <more-button\
                                    :index="i"\
                                    :itemShowLimitCount="pageSize"\
                                    :itemType="itemType"\
                                >\
                                </more-button>\
                            </div>\
                        </div>\
                    </template>\
                    <slide-list\
                        v-if="slideEventLists != \'\'"\
                        :slideEventLists="slideEventLists"\
                        :isApp="isApp"\
                    >\
                    </slide-list>\
                    <a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=크리스마스" class="mWeb">\
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/bnr_xmas.png" alt="크리스마스 아이템 모두 보기">\
                    </a>\
                    <a href="javascript:fnSearchEventText(\'크리스마스\');" class="mApp">\
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/bnr_xmas.png" alt="크리스마스 아이템 모두 보기">\
                    </a>\
                </section>\
            ',
    data : function() {
        return {
            itemType : 'SET_PARTITIONLIMITCOUNT',
            isApp : isApp,
        }
    },
    computed: {
        pageSize : function() {
            return this.$store.state.params.pageSize;
        },
        slideEventLists : function() {
            return this.$store.state.slideLists;
        },
        partitionItemLists : function() {
            function compare(a, b) {
                if (parseInt(a.category) < parseInt(b.category)) {
                    return -1;
                }
                if (parseInt(a.category) > parseInt(b.category)) {
                    return 1;
                }
                return 0;
            }
            return this.$store.state.partitionItemLists.sort(compare);
        },
    },
    created : function() {
        // mastercode init
        this.$store.commit('SET_MASTERCODE', '13');
        this.$store.commit('SET_PAGESIZE', { pageSize : 12 });
        this.$store.commit('SET_LIMITCOUNT', { itemShowLimitCount : 4 });

        // MD`s Pick
        this.$store.commit('SET_ISPICK', { isPick : '1' });
        this.$store.dispatch('GET_PARTITIONITEMLISTS');
        this.$store.commit('CLEAR_ISPICK');

        // BEST
        this.$store.commit('SET_CATEGORY', '9');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // TREE
        this.$store.commit('SET_CATEGORY', '10');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // LIGHTING
        this.$store.commit('SET_CATEGORY', '20');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // WREATH / GARLAND
        this.$store.commit('SET_CATEGORY', '30');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // ORNAMENT
        this.$store.commit('SET_CATEGORY', '40');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // CANDLE / DIFFUSER
        this.$store.commit('SET_CATEGORY', '50');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // CHRISTMAS GIFT
        this.$store.commit('SET_CATEGORY', '60');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // CARD
        this.$store.commit('SET_CATEGORY', '70');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // SLIDEEVENT
        this.$store.dispatch('GET_SLIDELISTS');
    },
    methods : {
        itemListName : function(i) {
            switch (i) {
                case 0 :
                    return 'MD`s Pick';
                case 1 :
                    return 'BEST ITEM';
                case 2 : 
                    return 'TREE';
                case 3 : 
                    return 'LIGHTING';
                case 4 : 
                    return 'WREATH/GARLAND';
                case 5 : 
                    return 'ORNAMENT';
                case 6 : 
                    return 'CANDLE/DIFFUSER';
                case 7 : 
                    return 'GIFT';
                case 8 : 
                    return 'CARD';
                default : 
                    return ''
            }
        }
    }
})
