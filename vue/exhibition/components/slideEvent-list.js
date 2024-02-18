Vue.component('event-list',{
    template :'\
                <div class="swiper-slide">\
                    <a @click="eventUrl(index)">\
                        <div class="thumbnail"><img :src="imageurl" :alt="titlename"></div>\
                        <div class="copy">\
                            <p data-swiper-parallax="-900" v-bind:style="fontColor" v-if="titlename != \'\'">{{titlename}}</p>\
                            <p data-swiper-parallax="-1500" v-bind:style="fontColor" v-if="subtitlename != \'\'">{{subtitlename}}</p>\
                        </div>\
                    </a>\
				</div>\
                '
    ,
    props: {
        index : {
            type : Number,
            default : 0
        },
        titlename : {
            type : String,
            default : ""
        },
        subtitlename : {
            type : String,
            default : ""
        },
        imageurl : {
            type : String,
            default : ""
        },
        eventid : {
            type : Number,
            default : 0
        },
        isApp : {
            type : Boolean,
            default : false,
        },
        amplitudeActionName : {
            type : String,
            default : ""
        },
        fontColorText : {
            type : String,
            default : ""
        },
        linkUrl : {
            type : String,
            default : ""
        }
    },
    computed : {
        fontColor : function() {
            return {
                'color' : '#'+this.fontColorText
            }
        }
    },
    methods : {        
        eventUrl : function(index) {
            if (this.eventid > 0) {
                fnAmplitudeEventMultiPropertiesAction(this.amplitudeActionName + 'event','idx|eventcode',index +'|'+ this.eventid);
                var eventUrl = "/event/eventmain.asp?eventid="+ this.eventid;
            } else {
                var eventUrl = this.linkUrl;
            }

            this.isApp ? fnAPPpopupAutoUrl(eventUrl) : window.location.href = eventUrl;
        },
    },
    mounted : function() {
        this.$nextTick(function() {
			setTimeout(function() {
                var swiper1 = new Swiper(".main-slider", {
                    loop:true,
                    parallax:true,
                    autoplay:3000,
                    speed:800,
                    onSlideChangeStart: function (swiper1) {
                        var vActIdx = parseInt(swiper1.activeIndex);
                        if (vActIdx<=0) {
                            vActIdx = swiper1.slides.length-2;
                        } else if(vActIdx>(swiper1.slides.length-2)) {
                            vActIdx = 1;
                        }
                        $(".pagination b").text(vActIdx);
                    }
                });
                $(".pagination b").text(1);
                $(".pagination span").text(swiper1.slides.length-2);
			},50);
		});
    }
})