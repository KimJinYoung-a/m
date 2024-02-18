Vue.component('slide-list',{
    template :'\
                <div class="evt-slider list-card type-align-left">\
                    <h4>Christmas Event</h4>\
                    <div class="swiper-container">\
                        <div class="swiper-wrapper">\
                            <template\
                                v-for="(item,index) in slideEventLists" \
                            >\
                                <div class="swiper-slide">\
                                    <a @click="eventUrl(index,item.eventid,item.linkurl);">\
                                        <div class="thumbnail"><img :src="item.imageurl" alt="" width="312"></div>\
                                        <div class="desc">\
                                            <p class="headline"><span class="ellipsis">{{item.titlename}}</span><b class="discount" v-if="item.issale">~{{item.saleper}}%</b></p>\
                                            <p class="subcopy">{{item.subcopy}}</p>\
                                        </div>\
                                    </a>\
                                </div>\
                            </template>\
                        </div>\
                        <div class="pagination-dot"></div>\
                    </div>\
                </div>\
                '
    ,
    props : {
        slideEventLists : {
            type : Array,
            default : [],
        },
        isApp : {
            type : Boolean,
            default : false,
        },
        amplitudeActionName : {
            type : String,
            default : ""
        },
    },
    methods : {        
        eventUrl : function(index,eventid,eventurl) {
            fnAmplitudeEventMultiPropertiesAction(this.amplitudeActionName+'event','idx|eventcode',index +'|'+ eventid);

            this.isApp ? fnAPPpopupAutoUrl(eventurl) : window.location.href = eventurl;
        },
    },
    mounted : function() {
        this.$nextTick(function() {
			setTimeout(function() {
                var evtSwiper = new Swiper('.evt-slider .swiper-container', {
                    loop:true,
                    pagination:'.evt-slider .pagination-dot'
                });
			},2000);
		});
    }
})