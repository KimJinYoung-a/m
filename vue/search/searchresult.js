var app = new Vue({
    el: '#app',
    store : store ,
    template: '\
                <div id="content" class="content srch_total">\
                    <h1 class="blind">검색결과(전체)</h1>\
                    <!-- 검색 결과(전체) -->\
                    <section class="srch_top">\
                            <Search-Result-Bar></Search-Result-Bar>\
                            <Search-Result-RelationKeyword></Search-Result-RelationKeyword>\
                            <!--Search-Result-Cate></Search-Result-Cate-->\
                            <!--Search-Result-Empty></Search-Result-Empty-->\
                            <Search-Result-KeywordQuickLink></Search-Result-KeywordQuickLink>\
                    </section>\
                    <!-- 상품 검색결과 -->\
                    <section class="item_module">\
                        <header class="head_type1">\
                            <a href="./product.asp">\
                                <span class="cnt">8,673건의</span>\
                                <h2 class="ttl">상품을 찾았어요<i class="i_arw_r2"></i></h2>\
                            </a>\
                        </header>\
                        <div class="prd_list">\
                            <article class="prd_item">\
                                <ItemList-Image></ItemList-Image>\
                                <div class="prd_info">\
                                    <ItemList-Price></ItemList-Price>\
                                    <ItemList-Name></ItemList-Name>\
                                    <ItemList-Brand></ItemList-Brand>\
                                    <ItemList-Badge></ItemList-Badge>\
                                    <ItemList-ReviewArea></ItemList-ReviewArea>\
                                </div>\
                                <ItemList-Link></ItemList-Link>\
                                <button type="button" class="btn_wish_on">위시 해제</button>\
                            </article>\
                        </div>\
                        <div class="sect_more">\
                            <a href="./product.asp" class="btn_more">상품 검색결과 더보기<i class="i_arw_r2"></i></a>\
                        </div>\
                    </section>\
                </div>\
    ',
    data : function() {
        return {
            /*
            itemType : 'SET_PARTITIONLIMITCOUNT',
            amplitudeActionName : "click_apple_",
            moveButtonText : "제품 더보기",
            numbers : [ 1 , 3 , 5 , 7 , 9 , 11 ],
            //isApp : isApp,
            itemListsSortingNumber : 0,
            */
        }
    },
    computed: {
        /*
        pageSize : function() {
            return this.$store.state.params.pageSize;
        },
        slideEventLists : function() {
            return this.$store.state.slideLists;
        },
        mdPickItemLists : function() {
            return this.$store.state.mdPickItemLists;
        },
        partitionItemLists : function() {
            return this.$store.getters.getPartitionItemListSorting;
        },
        tempItemId : function() {
            return ;
        },
    },
    created : function() {
        // Init
        this.$store.commit('SET_MASTERCODE', '11');
        this.$store.commit('SET_LIMITCOUNT', { itemShowLimitCount : 4 });

        // MD`s Pick
        this.$store.commit('SET_ISPICK', { isPick : '1' });
        this.$store.commit('SET_PAGESIZE', { pageSize : 4 });
        this.$store.commit('SET_CATEGORY', '');
        this.$store.dispatch('GET_ITEMLISTS');
        this.$store.commit('CLEAR_ISPICK');

        this.$store.commit('SET_PAGESIZE', { pageSize : 30 });

        // ipad
        this.$store.commit('SET_CATEGORY', '10');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // ipad 액세서리
        this.$store.commit('SET_CATEGORY', '11');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // macbook
        this.$store.commit('SET_CATEGORY', '20');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // macbook 액세서리
        this.$store.commit('SET_CATEGORY', '21');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // airpods
        this.$store.commit('SET_CATEGORY', '30');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // airpods 액세서리
        this.$store.commit('SET_CATEGORY', '31');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // mac
        this.$store.commit('SET_CATEGORY', '40');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // mac 액세서리
        this.$store.commit('SET_CATEGORY', '41');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // iphone
        this.$store.commit('SET_CATEGORY', '50');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // iphone 액세서리
        this.$store.commit('SET_CATEGORY', '51');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // watch
        this.$store.commit('SET_CATEGORY', '60');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // watch 액세서리
        this.$store.commit('SET_CATEGORY', '61');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // SLIDEEVENT
        this.$store.dispatch('GET_SLIDELISTS');
        */
    },
    methods : {

    },
    mounted : function() {
        this.$nextTick(function() {
			setTimeout(function() {
                /*
                var listTop = $(".items-list-wrap").offset().top;
                $(window).scroll(function(){
                    var scrollTop = $(window).scrollTop();
                    if ( listTop <= scrollTop ) {
                        $(".go-category").addClass("show");
                    } else {
                        $(".go-category").removeClass("show");
                    }
                });
                */
			},50);
		});
    }
})
