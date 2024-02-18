Vue.component('pb-main-rolling', {
    template: '\
    <div class="pb-rolling">\
        <div class="swiper-container">\
            <div class="swiper-wrapper">\
                <div class="swiper-slide"\
                    v-for="item in rollingBanners"\
                >\
                    <a @click="handleClickLink(item.eventCode)">\
                        <div class="thumbnail">\
                            <img\
                                :src="item.imgURL" alt="">\
                            <span class="bg" v-bind:style="{ backgroundColor: \'#\'+item.leftBGColor }"></span>\
                        </div>\
                        <div class="desc">\
                            <div class="copy-warp">\
                                <b class="headline"\
                                    v-html=item.headLine\
                                ></b>\
                                <p class="subcopy">{{item.subCopy}}</span></p>\
                            </div>\
                        </div>\
                    </a>\
                </div>\
            </div>\
        </div>\
        <div class="page-num"><p class="page"><strong></strong><em>ㅣ</em><span></span></p></div>\
    </div>\
    ',
    props: {
        rollingBanners: {
            type: Array,
            default: []
        },
    },
    mounted: function(){
        if($('.pb-rolling .swiper-slide').length > 1){
            var pbRolling = new Swiper(".pb-rolling .swiper-container", {
                autoplay:6000,
                effect:"fade",
                loop:true,
                speed:800,
                onSlideChangeStart:function (pbRolling) {
                    // console.log(`looped slide : ${pbRolling.loopedSlides}`)
                    // console.log(`realIndex : ${pbRolling.activeIndex}`)                    

                    var vActIdx = parseInt(pbRolling.activeIndex);
                    if (vActIdx <= 0) {
                        vActIdx = pbRolling.slides.length-2;
                    } else if(vActIdx>(pbRolling.slides.length-2)) {
                        vActIdx = 1;
                    }
                    $(".pb-rolling .page-num .page strong").text(vActIdx);
                    if((pbRolling.previousIndex - pbRolling.activeIndex) < 0){
                        $('.pb-rolling').removeClass('play-reverse');
                        $('.pb-rolling').addClass('play');
                    }
                    if((pbRolling.previousIndex - pbRolling.activeIndex) > 0){
                        $('.pb-rolling').removeClass('play');
                        $('.pb-rolling').addClass('play-reverse');
                    }
                    // ======================================================
                    if(pbRolling.activeIndex == pbRolling.slides.length-1){
                        pbRolling.slideTo(1)
                    }
                    if(pbRolling.activeIndex == 0){
                        pbRolling.slideTo(pbRolling.slides.length-2)
                    }                    
                }
            });
            $('.pb-rolling .page-num').show()
            $('.pb-rolling .page-num .page strong').text(1);
            $('.pb-rolling .page-num .page span').text(pbRolling.slides.length-2);        
        } else {
            $('.pb-rolling').addClass('single-slide');
        }       
    },
    methods: {
        handleClickLink: function(evtCode){
            if(isapp == 1){
                fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+evtCode);
            }else{
                window.location.href = "/event/eventmain.asp?eventid="+evtCode
            }
            return false;
        },
    }
})