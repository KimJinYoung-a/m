//lazy load
var app = new Vue({
    el: '#itemlist',
    store : store ,
    template: '\
                <section class="tab-wrap">\
                    <div class="tab-nav">\
                        <ul>\
                            <li class="parents on"><a href="#tab-parents">부모님</a></li>\
                            <li class="couple"><a href="#tab-couple">연인</a></li>\
                            <li class="child"><a href="#tab-child">어린이</a></li>\
                            <li class="event"><a href="#tab-event">기획전</a></li>\
                        </ul>\
                    </div>\
                    <div id="tab-parents" class="tab-cont tab-parents">\
                        <template\
                            v-for="(itemlist,i) in partitionItemSplitLists2"\
                        >\
                        <div class="category">\
                            <div class="category-title" v-html="titleRawHtml(i+4)"></div>\
                            <div class="items type-grid">\
                                <ul>\
                                    <item-list\
                                        v-for="(item,index) in itemlist.items"\
                                        :key="itemlist.cateogry"\
                                        :index="index"\
                                        :itemid="item.itemid"\
                                        :itemimage="item.itemimage"\
                                        :itemname="item.itemname"\
                                        :brandname="item.brandname"\
                                        :totalprice="item.totalprice"\
                                        :saleperstring="item.saleperstring"\
                                        :couponperstring="item.couponperstring"\
                                        :isApp="isApp"\
                                        :amplitudeActionName="amplitudeActionName"\
                                        :evalCount="item.evalCount"\
                                        :favCount="item.favCount"\
                                        :totalPoint="item.totalPoint"\
                                        v-show="index < itemlist.itemShowLimitCount"\
                                    >\
                                    </item-list>\
                                </ul>\
                                <more-button\
                                    :index="i+4"\
                                    :itemShowLimitCount="pageSize"\
                                    :itemType="itemType"\
                                    :moveButtonText="moveButtonText"\
                                >\
                                </more-button>\
                            </div>\
                        </div>\
                        </template>\
                    </div>\
                    <div id="tab-couple" class="tab-cont tab-couple">\
                        <template\
                            v-for="(itemlist,i) in partitionItemSplitLists3"\
                        >\
                        <div class="category">\
                            <div class="category-title" v-html="titleRawHtml(i+8)"></div>\
                            <div class="items type-grid">\
                                <ul>\
                                    <item-list\
                                        v-for="(item,index) in itemlist.items"\
                                        :key="itemlist.cateogry"\
                                        :index="index"\
                                        :itemid="item.itemid"\
                                        :itemimage="item.itemimage"\
                                        :itemname="item.itemname"\
                                        :brandname="item.brandname"\
                                        :totalprice="item.totalprice"\
                                        :saleperstring="item.saleperstring"\
                                        :couponperstring="item.couponperstring"\
                                        :isApp="isApp"\
                                        :amplitudeActionName="amplitudeActionName"\
                                        :evalCount="item.evalCount"\
                                        :favCount="item.favCount"\
                                        :totalPoint="item.totalPoint"\
                                        v-show="index < itemlist.itemShowLimitCount"\
                                    >\
                                    </item-list>\
                                </ul>\
                                <more-button\
                                    :index="i+8"\
                                    :itemShowLimitCount="pageSize"\
                                    :itemType="itemType"\
                                    :moveButtonText="moveButtonText"\
                                >\
                                </more-button>\
                            </div>\
                        </div>\
                        </template>\
                    </div>\
                    <div id="tab-child" class="tab-cont tab-child">\
                        <template\
                            v-for="(itemlist,i) in partitionItemSplitLists1"\
                        >\
                        <div class="category">\
                            <div class="category-title" v-html="titleRawHtml(i)"></div>\
                            <div class="items type-grid">\
                                <ul>\
                                    <item-list\
                                        v-for="(item,index) in itemlist.items"\
                                        :key="itemlist.cateogry"\
                                        :index="index"\
                                        :itemid="item.itemid"\
                                        :itemimage="item.itemimage"\
                                        :itemname="item.itemname"\
                                        :brandname="item.brandname"\
                                        :totalprice="item.totalprice"\
                                        :saleperstring="item.saleperstring"\
                                        :couponperstring="item.couponperstring"\
                                        :isApp="isApp"\
                                        :amplitudeActionName="amplitudeActionName"\
                                        :evalCount="item.evalCount"\
                                        :favCount="item.favCount"\
                                        :totalPoint="item.totalPoint"\
                                        v-show="index < itemlist.itemShowLimitCount"\
                                    >\
                                    </item-list>\
                                </ul>\
                                <more-button\
                                    :index="i"\
                                    :itemShowLimitCount="pageSize"\
                                    :itemType="itemType"\
                                    :moveButtonText="moveButtonText"\
                                >\
                                </more-button>\
                            </div>\
                        </div>\
                        </template>\
                    </div>\
                    <div id="tab-event" class="tab-cont tab-event">\
                        <div class="list-card">\
                            <ul>\
                                <event-list\
                                    v-for="(item,index) in eventLists"\
                                    :key="index"\
                                    :index="index"\
                                    :eventid="item.eventid"\
                                    :eventname="item.eventname"\
                                    :subcopy="item.subcopy"\
                                    :squareimage="item.squareimage"\
                                    :rectangleimage="item.rectangleimage"\
                                    :saleper="item.saleper"\
                                    :salecper="item.salecpeer"\
                                    :isgift="item.isgift"\
                                    :issale="item.issale"\
                                    :isoneplusone="item.isoneplusone"\
                                    :isApp="isApp"\
                                    :amplitudeActionName="amplitudeActionName"\
                                >\
                                </event-list>\
                            </ul>\
                        </div>\
                    </div>\
                </section>\
            ',
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
        eventLists : function() {
            return this.$store.state.eventLists;
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
        partitionItemSplitLists1 : function() {
            return this.partitionItemLists.slice(0,4);
        },
        partitionItemSplitLists2 : function() {
            return this.partitionItemLists.slice(4,8);
        },
        partitionItemSplitLists3 : function() {
            return this.partitionItemLists.slice(8,11);
        }
    },
    created : function() {
        // mastercode init
        this.$store.commit('SET_MASTERCODE', '14'); // test 11 , live 14
        this.$store.commit('SET_PAGESIZE', { pageSize : 20 });
        this.$store.commit('SET_LIMITCOUNT', { itemShowLimitCount : 6 });

        // 어린이 BEST
        this.$store.commit('SET_CATEGORY', '10');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 장난감
        this.$store.commit('SET_CATEGORY', '11');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 전자기기
        this.$store.commit('SET_CATEGORY', '12');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 개린이날
        this.$store.commit('SET_CATEGORY', '13');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 부모님 BEST
        this.$store.commit('SET_CATEGORY', '20');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 카네이션
        this.$store.commit('SET_CATEGORY', '21');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 용돈
        this.$store.commit('SET_CATEGORY', '22');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 효도선물
        this.$store.commit('SET_CATEGORY', '23');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 연인 BEST
        this.$store.commit('SET_CATEGORY', '30');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 커플아이템
        this.$store.commit('SET_CATEGORY', '31');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 로즈데이
        this.$store.commit('SET_CATEGORY', '32');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // 스무살
        this.$store.commit('SET_CATEGORY', '33');
        this.$store.dispatch('GET_PARTITIONITEMLISTS');

        // Event List
        this.$store.dispatch('GET_EVENTLISTS');
    },
    methods : {
        titleRawHtml : function(i) {
            switch (i) {
                case 0 :
                    return '아이들이 좋아할<br><b lang="ko">선물</b> <b lang="en">BEST 20</b>';
                case 1 :
                    return '<b lang="ko">장난감</b>';
                case 2 : 
                    return '<b lang="ko">전자기기</b>';
                case 3 : 
                    return '<b lang="ko">개린이날</b>';
                case 4 : 
                    return '부모님께 드리고 싶은<br><b lang="ko">선물</b> <b lang="en">BEST 20</b>';
                case 5 : 
                    return '<b lang="ko">카네이션</b>';
                case 6 : 
                    return '<b lang="ko">용돈</b>';
                case 7 : 
                    return '<b lang="ko">효도선물</b>';
                case 8 : 
                    return '연인을 위한<br><b lang="ko">선물</b> <b lang="en">BEST 20</b>';
                case 9 : 
                    return '<b lang="ko">커플아이템</b>';
                case 10 : 
                    return '<b lang="ko">로즈데이</b>';
                case 11 : 
                    return '<b lang="ko">스무살</b>';
                default : 
                    return ''
            }
        },
        scroll : function() {
            var didScroll;
            var lastScrollTop = 0;
            var delta = 5;
            var navbarHeight = $(".header-wrap").outerHeight();
            $(window).scroll(function(event){
                if ($("body").hasClass("body-main")){
                    didScroll = true;
                }
            });
            setInterval(function() {
                if (didScroll) {
                    hasScrolled();
                    didScroll = false;
                }
            }, 250);
            function hasScrolled() {
                var st = $(this).scrollTop();
                if(Math.abs(lastScrollTop - st) <= delta)
                    return;
                if ($(".tab-nav").hasClass("fixed")) {
                    if (st > lastScrollTop && st > navbarHeight){
                        if (isApp){
                            $(".tab-nav").css("top", "52px");
                        } else {
                            $(".tab-nav").css("top", "4.44rem");
                        }
                    } else {
                        if(st + $(window).height() < $(document).height()) {
                            if (isApp){
                                $(".tab-nav").css("top", "108px");
                            } else {
                                $(".tab-nav").css("top", "9.22rem");
                            }
                        }
                    }
                }
                lastScrollTop = st;
            }
            var _this = this;
            window.onscroll = function(ev) {
                var tabTop = $(".tab-wrap").offset().top,
                    tabNav = $(".tab-nav").outerHeight(),
                    tabParents = $(".tab-parents").offset().top - tabNav,
                    tabCouple = $(".tab-couple").offset().top - tabNav,
                    tabChild = $(".tab-child").offset().top - tabNav,
                    tabEvent = $(".tab-event").offset().top - tabNav,
                    y = $(window).scrollTop();

                    _this.heights.tabTop = tabTop;
                    _this.heights.tabNav = tabNav;
                    _this.heights.tabParents = tabParents;
                    _this.heights.tabCouple = tabCouple;
                    _this.heights.tabChild = tabChild;
                    _this.heights.tabEvent = tabEvent;

                if ( tabTop <= y ) {
                    $(".tab-nav").addClass("fixed");
                    if ( y < tabCouple ) {
                        $(".family2020 .tab-nav li.parents").addClass("on").siblings("li").removeClass("on");
                    } else if ( tabCouple <= y && y < tabChild ) {
                        $(".family2020 .tab-nav li.couple").addClass("on").siblings("li").removeClass("on");
                    } else if ( tabChild <= y && y < tabEvent ) {
                        $(".family2020 .tab-nav li.child").addClass("on").siblings("li").removeClass("on");
                    } else {
                        $(".family2020 .tab-nav li.event").addClass("on").siblings("li").removeClass("on");
                    }
                } else {
                    $(".tab-nav").removeClass("fixed");
                    $(".tab-nav").css("top",0);
                }
			};
        }
    },
    mounted : function() {
        this.scroll();
        this.$nextTick(function() {
            var _this = this;
			setTimeout(function(){
                $(".family2020 .tab-nav li a").click(function(e){
                    e.preventDefault();
                    $(this).parent("li").addClass("on").siblings("li").removeClass("on");
                    $('html,body').animate({'scrollTop': $(this.hash).offset().top - _this.heights.tabNav + 10},0);
                });
			},1500);
		});
    },
})
