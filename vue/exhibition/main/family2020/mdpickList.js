var app = new Vue({
    el: '#mdpicklist',
    store : store ,
    template: '\
                <section class="item-carousel md-pick">\
                    <div class="hgroup">\
                        <h3 class="headline headline-speech"><span lang="en">Present Pick!</span> <small>MD가 추천하는 선물</small></h3>\
                    </div>\
                    <div class="items swiper-container">\
                        <ul class="swiper-wrapper">\
                            <slideitem-list\
                                v-for="(item,index) in mdPickItemLists"\
                                :key="index"\
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
                                :optionCode="item.optionCode"\
                            >\
                            </slideitem-list>\
                        </ul>\
                    </div>\
                </section>\
            ',
    data : function() {
        return {
            itemType : 'SET_PARTITIONLIMITCOUNT',
            isApp : isApp,
            amplitudeActionName : "click_family2020_mdpick_item",
        }
    },
    computed: {
        pageSize : function() {
            return this.$store.state.params.pageSize;
        },
        mdPickItemLists : function() {
            return this.$store.state.itemLists;
        },
    },
    created : function() {
        // mastercode init
        this.$store.commit('SET_MASTERCODE', '14'); // test 11 , live 14
        this.$store.commit('SET_PAGESIZE', { pageSize : 20 });

        // MD`s Pick
        this.$store.commit('SET_ISPICK', { isPick : '1' });
        this.$store.commit('SET_CATEGORY', '');
        this.$store.dispatch('GET_ITEMLISTS');
        this.$store.commit('CLEAR_ISPICK');
    },
    mounted : function() {
        this.$nextTick(function() {
			setTimeout(function() {
                var itemSwiper = new Swiper(".item-carousel .swiper-container", {
                    slidesPerView:"auto",
                    freeMode:true,
                    freeModeMomentumRatio:0.5
                });
			},1000);
		});
    }
})
