var app = new Vue({
    el: '#itemlist',
    store : store ,
    template: `
                <section class="tab-wrap">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_tab.png" alt="5월의 선물 키워드"></h3>
                    <nav class="tab-nav">
                        <ul class="tab-list">
                            <li><a href="#tab01">어버이날</a></li>
                            <li><a href="#tab02">스승의날 </a></li>
                            <li><a href="#tab03">어린이날</a></li>                            
                            <li><a href="#tab04">로즈데이</a></li>
                            <li><a href="#tab05">성년의날</a></li>
                        </ul>
                    </nav>                    
                    
                    <div v-for="(item, index) in partitionItemLists" :id="'tab0' + (index+1)" :class="'tab-cont tab0' + (index+1)">
                        <h4 v-html="itemHtml(index)"></h4>
                        <div class="items type-grid">
                            <div class="items type-grid">
                                <ul>
                                    <item-list
                                        v-for="(item2, index2) in item.items"
                                        :key="item.cateogry"
                                        :index="index2"
                                        :itemid="item2.itemid"
                                        :itemimage="item2.itemimage"
                                        :itemname="item2.itemname"
                                        :brandname="item2.brandname"
                                        :totalprice="item2.totalprice"
                                        :saleperstring="item2.saleperstring"
                                        :couponperstring="item2.couponperstring"
                                        :isApp="isApp"
                                        :amplitudeActionName="amplitudeActionName"
                                        :evalCount="item2.evalCount"
                                        :favCount="item2.favCount"
                                        :totalPoint="item2.totalPoint"
                                        v-show="index2 < item.itemShowLimitCount"
                                    >
                                    </item-list>
                                </ul>
                                <more-button
                                    :index="index"
                                    :itemShowLimitCount="pageSize"
                                    :itemType="itemType"
                                    :moveButtonText="moveButtonText"
                                >
                                </more-button>
                            </div>
                        </div>
                        </template>
                    </div>
                </section>
            `,
    data : function() {
        return {
            itemType : 'SET_PARTITIONLIMITCOUNT',
            isApp : isApp,
            amplitudeActionName : "click_family2020_",
            moveButtonText : "제품 더보기",
            heights : {
                tabTop : "",
                tabNav : "",
                tabParents : "",
                tabCouple : "",
                tabChild : "",
                tabEvent : "",
            }
        }
    },
    computed: {
        pageSize : function() {
            return this.$store.state.params.pageSize;
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

            const originList = this.$store.state.partitionItemLists.sort(compare);
            return this.changeListSort(originList, 1, 1);
        }
    },
    created : function() {
        // mastercode init
        this.$store.commit('SET_MASTERCODE', '20'); // test 12 , live 20
        this.$store.commit('SET_PAGESIZE', { pageSize : 20 });
        this.$store.commit('SET_LIMITCOUNT', { itemShowLimitCount : 4 });

        // 어버이날
        this.$store.commit('SET_CATEGORY', '20');
        this.$store.dispatch('GET_ITEMLIST');

        // 어린이날
        this.$store.commit('SET_CATEGORY', '70');
        this.$store.dispatch('GET_ITEMLIST');

        // 스승의날
        this.$store.commit('SET_CATEGORY', '50');
        this.$store.dispatch('GET_ITEMLIST');

        // 로즈데이
        this.$store.commit('SET_CATEGORY', '90');
        this.$store.dispatch('GET_ITEMLIST');

        // 성년의날
        this.$store.commit('SET_CATEGORY', '110');
        this.$store.dispatch('GET_ITEMLIST');
    },
    methods : {
        itemHtml : function(i) {
            switch (i) {
                case 0 :
                    return '<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_tab_01.png" alt="어버이날" />';
                case 1 :
                    return '<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_tab_02.png" alt="어린이날">';
                case 2 :
                    return '<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_tab_03.png" alt="스승의날">';
                case 3 :
                    return '<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_tab_04.png" alt="로즈데이">';
                case 4 :
                    return '<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_tab_05.png" alt="성년의날">';
            }
        }
        , changeListSort : function (list, target, move){
            if(list.length <= 0){
                return false;
            }

            const resultIndex = target + move;
            if(resultIndex < 0 || resultIndex >= list.length){
                return false
            }

            const resultList = JSON.parse(JSON.stringify(list));
            const targetItem = resultList.splice(target, 1)[0];

            resultList.splice(resultIndex, 0, targetItem);
            return resultList;
        }
    }
});