var app = new Vue({
    el: '#app',
    store : store ,
    template: '\
                <div id="content" class="content apple-store main">\
                    <h2 style="display:none;">애플 전용관</h2>\
                    <div class="main-slider">\
                        <div class="swiper-wrapper">\
                            <event-list\
                                v-for="(item,index) in slideEventLists"\
                                        :key="index"\
                                        :index="index"\
                                        :titlename="item.titlename"\
                                        :subtitlename="item.subtitlename"\
                                        :imageurl="item.imageurl"\
                                        :eventid="item.eventid"\
                                        :amplitudeActionName="amplitudeActionName"\
                                        :isApp="isApp"\
                                        :fontColorText="item.titlecolor"\
                                        :linkUrl="item.linkurl"\
                            >\
                            </event-list>\
                        </div>\
                        <div class="pagination"><b></b>/<span></span></div>\
                    </div>\
                    <div id="appleNav" class="navigation">\
                        <h3>모델별 찾기</h3>\
                        <ul>\
                            <li><a href="#ipad">iPad</a></li>\
                            <li><a href="#macbook">Macbook</a></li>\
                            <li><a href="#airpods">AirPods</a></li>\
                            <li><a href="#imac">iMac</a></li>\
                            <li><a href="#iphone">iPhone</a></li>\
                            <li><a href="#watch">Watch</a></li>\
                        </ul>\
                    </div>\
                    <div class="today-rec" v-if="mdPickItemLists">\
                        <h3>오늘의 추천</h3>\
                        <div class="swiper-container">\
				            <ul class="swiper-wrapper">\
                                <appletype-itemlist\
                                    v-for="(item,index) in mdPickItemLists"\
                                        :key="index"\
                                        :index="index"\
                                        :itemid="item.itemid"\
                                        :brandname="item.brandname"\
                                        :itemname="item.itemname"\
                                        :addText1="item.addText1"\
                                        :addText2="item.addText2"\
                                        :itemimage="item.itemimage"\
                                        :sellCash="item.sellCash"\
                                        :optionCount="item.optionCount"\
                                        :amplitudeActionName="amplitudeActionName"\
                                        :isApp="isApp"\
                                >\
                                </appletype-itemlist>\
                            </ul>\
                            <div class="pagination"><span class="pagination-fill"></span></div>\
                        </div>\
                    </div>\
                    <div class="items-list-wrap">\
                        <a href="#appleNav" class="go-category">모델별 찾기</a>\
                        <template\
                            v-for="idx in numbers"\
                        >\
                            <template\
                                v-for="(itemlist,i) in partitionItemListsTo(idx)"\
                            >\
                            <div v-bind:id="addClassName(idx)" class="items-list" v-bind:class="addClassName(idx)">\
                                <h4>{{listName(idx)}}</h4>\
                                <ul>\
                                    <item-list\
                                        v-for="(item,index) in itemlist.items"\
                                        :key="index"\
                                        :index="index"\
                                        :itemid="item.itemid"\
                                        :brandname="item.brandname"\
                                        :itemname="item.itemname"\
                                        :addText1="item.addText1"\
                                        :addText2="item.addText2"\
                                        :itemimage="item.itemimage"\
                                        :sellCash="item.sellCash"\
                                        :totalprice="item.totalprice"\
                                        :saleperstring="item.saleperstring"\
                                        :couponperstring="item.couponperstring"\
                                        :optionCount="item.optionCount"\
                                        :amplitudeActionName="amplitudeActionName"\
                                        :isApp="isApp"\
                                        :evalCount="item.evalCount"\
                                        :favCount="item.favCount"\
                                        :totalPoint="item.totalPoint"\
                                        v-if="index < itemlist.itemShowLimitCount"\
                                    >\
                                    </item-list>\
                                    <template\
                                        v-for="(itemlist,i) in partitionItemListsTo(idx+1)"\
                                    >\
                                        <item-list\
                                            v-for="(item,index) in itemlist.items"\
                                            :index="index"\
                                            :itemid="item.itemid"\
                                            :brandname="item.brandname"\
                                            :itemname="item.itemname"\
                                            :addText1="item.addText1"\
                                            :addText2="item.addText2"\
                                            :itemimage="item.itemimage"\
                                            :sellCash="item.sellCash"\
                                            :totalprice="item.totalprice"\
                                            :saleperstring="item.saleperstring"\
                                            :couponperstring="item.couponperstring"\
                                            :optionCount="item.optionCount"\
                                            :amplitudeActionName="amplitudeActionName"\
                                            :isApp="isApp"\
                                            :evalCount="item.evalCount"\
                                            :favCount="item.favCount"\
                                            :totalPoint="item.totalPoint"\
                                            v-show="index < itemlist.itemShowLimitCount"\
                                            v-if="index < 2"\
                                        >\
                                        </item-list>\
                                    </template>\
                                </ul>\
                                <a @click="moreItem(itemlist.category)" class="btn-more">모든 {{listName(idx)}}{{suffix(idx)}}<br>추천 액세서리 보기</a>\
                            </div>\
                            </template>\
                        </template>\
                    </div>\
                    <div class="alertBoxV17a" style="display:none;" id="alertBoxV17a">\
                        <div>\
                            <p class="alertCart" id="sbaglayerx" style="display:none;"><span>장바구니에 상품이 담겼습니다.</span></p>\
                            <p id="sbaglayero" style="display:none"><span>장바구니에 이미 같은 상품이 있습니다.</span></p >\
                            <button type="button" class="btn btn-small btn-red btn-icon btn-radius" @click="gotoMyCart">장바구니 가기<span class="icon icon-arrow"></span></button>\
                        </div>\
                    </div>\
                    <div class="alertBoxV17a optionBoxV18" style="display:none" id="optionBoxV18">\
                        <div>\
                            <p><span>크기, 색상, 종류등과 같은<br/>다양한 옵션이 있는 상품입니다</span></p>\
                            <p class="btn-group">\
                                <button type="button" class="btn btn-small btn-line-white btn-radius" @click="gotoProductDetail(\'x\');return false;">쇼핑 계속하기</button>\
                                <button type="button" class="btn btn-small btn-red btn-radius" @click="gotoProductDetail(\'o\');return false;">옵션 선택</button>\
                            </p>\
                        </div>\
                    </div>\
                </div>\
    ',
    data : function() {
        return {
            itemType : 'SET_PARTITIONLIMITCOUNT',
            amplitudeActionName : "click_apple_",
            moveButtonText : "제품 더보기",
            numbers : [ 1 , 3 , 5 , 7 , 9 , 11 ],
            isApp : isApp,
            itemListsSortingNumber : 0,
        }
    },
    computed: {
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
    },
    methods : {
        gotoMyCart : function() {
            this.isApp ? fnAPPpopupBaguni() : function() {
                location.href='/inipay/ShoppingBag.asp';
            }()
        },
        gotoProductDetail : function(v) {
            if (v == "o") {
                this.isApp ? fnAPPpopupProduct(this.$store.state.tempItemId) : function(itemId) {
                    var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemId +"&flag=e";
                    location.href = itemUrl;
                }(this.$store.state.tempItemId)
            }

            $("#optionBoxV18").hide();
        },
        moreItem : function(category) {
            this.isApp ? fnAPPpopupAutoUrl('/event/apple/itemlist.asp?category='+category) : function() {
                var itemUrl = "/event/apple/itemlist.asp?category="+ category;
                location.href = itemUrl;
            }()
        },
        partitionItemListsTo : function(index) {
            return this.$store.getters.getPartitionItemListSorting.slice(parseInt(index-1),index);
        },
        listName : function(i) {
            switch (i) {
                case 1 :
                    return 'iPad';
                case 2 : 
                    return 'iPad 추천 액세서리';
                case 3 : 
                    return 'Macbook';
                case 4 : 
                    return 'Macbook 추천 액세서리';
                case 5 : 
                    return 'AirPods';
                case 6 : 
                    return 'AirPods 추천 액세서리';
                case 7 : 
                    return 'iMac';
                case 8 : 
                    return 'iMac 추천 액세서리';
                case 9 : 
                    return 'iPhone';
                case 10 : 
                    return 'iPhone 추천 액세서리';
                case 11 : 
                    return 'Watch';
                case 12 : 
                    return 'Watch 추천 액세서리';
                default : 
                    return ''
            }
        },
        suffix : function(i) {
            if (i == 1 || i == 11) {
                return "와";
            } else {
                return "과";
            }
        },
        addClassName : function(i) {
            switch (i) {
                case 1 :
                    return 'ipad';
                case 3 :
                    return 'macbook';
                case 5 : 
                    return 'airpods';
                case 7 :
                    return 'imac';
                case 9 : 
                    return 'iphone';
                case 11 :
                    return 'watch';
                default : 
                    return ''
            }
        }
    },
    mounted : function() {
        this.$nextTick(function() {
			setTimeout(function() {
                var listTop = $(".items-list-wrap").offset().top;
                $(window).scroll(function(){
                    var scrollTop = $(window).scrollTop();
                    if ( listTop <= scrollTop ) {
                        $(".go-category").addClass("show");
                    } else {
                        $(".go-category").removeClass("show");
                    }
                });
			},50);
		});
    }
})
