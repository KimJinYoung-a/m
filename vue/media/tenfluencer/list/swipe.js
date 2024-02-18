// 스와이퍼 데이터 있을경우
Vue.component('swipe-layer',{
    props: ['swipelists','isapp'],
    template : '<div class="bnr-rolling">\
                    <div class="swiper-container">\
                        <div class="swiper-wrapper">\
                            <div class="swiper-slide" v-for="item in swipelists">\
                                <a @click="linkUrl(isapp,item.linkurl,item.eventid,item.contentsidx)">\
                                    <div class="thumbnail"><img :src="item.bannerimage" alt=""></div>\
                                    <div class="desc">\
                                        <b class="headline"><span class="ellipsis">{{item.maincopy}}</span></b>\
                                        <p class="subcopy"><span class="ellipsis">{{item.subcopy}}</span></p>\
                                    </div>\
                                </a>\
                            </div>\
                        </div>\
                        <div class="pagination-progress"><span class="pagination-progress-fill"></span></div>\
                    </div>\
                </div>'
    ,
    methods : {
        linkUrl : function(isapp, url, eventid, contentsidx) {
            if (isapp == 1) {
                if (contentsidx != null) {
                    fnAPPpopupTransparent('tenfluencer','http://fiximage.10x10.co.kr/m/2019/platform/tenfluencer.png','/tenfluencer/detail.asp?cidx='+contentsidx,'right','sc','titleimage');
                } else if (eventid != null) {
                    fnAPPpopupEvent(eventid);
                } else {
                    fnAPPpopupAutoUrl(url);
                }
            } else {
                if (contentsidx != null) {
                    location.href = '/tenfluencer/detail.asp?cidx='+contentsidx;
                } else if (eventid != null) {
                    location.href = '/event/eventmain.asp?eventid='+eventid;
                } else {
                    location.href = url;
                }
            }
        }
    },
    updated : function() {
        this.$nextTick(function() {
            setTimeout(function() {
                // slide banner
                if ($('.bnr-rolling .swiper-slide').length > 1) {
                    var total = $(".bnr-rolling .swiper-slide").length;
                    var initScale = 1 / total;
                    var progressFill = $(".bnr-rolling .pagination-progress-fill");
                    progressFill.css("transform", "scaleX(" + initScale + ")");

                    var pMainSwiper = new Swiper(".bnr-rolling .swiper-container", {
                        slidesPerView:'auto',
                        centeredSlides:true,
                        speed:600,
                        onSlideChangeStart:function (pMainSwiper) {
                            var current = pMainSwiper.activeIndex;
                            var scale = initScale * (current+1);
                            progressFill.css("transform", "scaleX(" + scale + ")");
                        }
                    });
                    $('.bnr-rolling').addClass('on');
                } else {
                    $(".bnr-rolling .pagination-progress").hide();
                }
            },500);
        });
    }
})