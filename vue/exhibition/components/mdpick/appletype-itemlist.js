Vue.component('appletype-itemlist',{
    template :'\
                <li class="swiper-slide">\
                    <a @click="itemUrl(itemid)">\
                        <div class="thumbnail">\
                            <img :src="itemimage" :alt="itemname">\
                            <slot>\
                                <ShoppingBag\
                                    :itemId="itemid"\
                                    :optionCount="optionCount"\
                                    :sellCash="sellCash"\
                                    :isApp="isApp"\
                                >\
                                </ShoppingBag>\
                            </slot>\
                        </div>\
                        <div class="desc">\
                            <p class="txt1">{{mainText}}</p>\
                            <p class="txt2">{{subText}}</p>\
                        </div>\
                    </a>\
                </li>\
                '
    ,
    props: {
        index : {
            type: Number,
            default: 0
        },
        itemid: {
            type: Number,
            default: 0
        },
        brandname : {
            type : String,
            default : ''
        },
        itemname : {
            type : String,
            default : ''
        },
        addText1 : {
            type : String,
            default : ''
        },
        addText2 : {
            type : String,
            default : ''
        },
        itemimage : {
            type : String,
            default : ''
        },
        optionCount : {
            type : Number,
            default : 0
        },
        sellCash : {
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
    },
    computed : {
        mainText : function() {
            return this.addText1 == "" ? this.brandname : this.addText1;
        },
        subText : function() {
            return this.addText2 == "" ? this.itemname : this.addText2;
        }
    },
    methods : {        
        itemUrl : function(itemid) {
            fnAmplitudeEventAction(this.amplitudeActionName + 'item','itemid',itemid);

            this.isApp ? fnAPPpopupProduct(itemid) : function() {
                var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemid +"&flag=e";
                location.href = itemUrl;
            }()
        },
    },
    mounted : function() {
        this.$nextTick(function() {
			setTimeout(function() {
                var today = $('.today-rec');
                var progressFill = today.find('.pagination-fill');
                var length = today.find('.swiper-slide').length;
                var init = (1 / length).toFixed(2);
                progressFill.css("transform", "scaleX(" + init + ") scaleY(1)");
                var swiper2 = new Swiper('.today-rec .swiper-container', {
                    slidesPerView: 'auto',
                    onSlideChangeStart: function(swiper2) {
                        var scale = (swiper2.activeIndex+1) * init;
                        progressFill.css("transform", "scaleX(" + scale + ") scaleY(1)");
                    },
                    onSliderMove: function(swiper2){
                        var scale = (swiper2.activeIndex+1) * init;
                        var lastprev = swiper2.slides.length-1
                        if($('.today-rec .swiper-slide:nth-child('+ lastprev +')').hasClass('swiper-slide-active')){
                            progressFill.css("transform", "scaleX(" + scale + ") scaleY(1)");
                        }
                    },
                    onReachEnd: function(swiper2) {
                        progressFill.css("transform", "scaleX(1) scaleY(1)");
                    }
                });
            },100);
		});
    }
})