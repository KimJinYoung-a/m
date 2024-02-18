Vue.component('rolling', {
    template: '\
    <div>\
        <div class="section sc4">\
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/tit_sc4.jpg" alt="화끈팩을 나눠보세요"></h3>\
            <div class="swiper-container slider">\
                <div class="swiper-wrapper">\
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide1_1.jpg?v=1.01" alt=""></div>\
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide1_2.jpg?v=1.01" alt=""></div>\
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide1_3.jpg?v=1.01" alt=""></div>\
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide1_4.jpg?v=1.01" alt=""></div>\
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide1_5.jpg?v=1.01" alt=""></div>\
                </div>\
                <button type="button" class="btn-nav btn-prev">이전</button>\
                <button type="button" class="btn-nav btn-next">다음</button>\
            </div>\
            <a href="/category/category_itemPrd.asp?itemid=2605091&pEtr=99723" onclick="TnGotoProduct(\'2605091\');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/btn_get2.png" alt="선물하기"></a>\
        </div>\
        <div class="swiper-container slider2">\
            <div class="swiper-wrapper">\
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide2_1.jpg" alt=""></div>\
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide2_2.jpg" alt=""></div>\
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide2_3.jpg" alt=""></div>\
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide2_4.jpg" alt=""></div>\
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_slide2_5.jpg" alt=""></div>\
            </div>\
            <div class="pagination"></div>\
        </div>\
        <div class="section sc5"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/txt_sc5.jpg?v=1.01" alt="화끈다짐하고 100만원 받자"></div>\
    </div>\
    ',
    props: {
        slotProps: {
            type: Object,
            default: function(){
                return {}
            }
        }
    },
    mounted: function(){
        var slider = new Swiper(".slider",{
                effect:'fade',
                loop:true,
                autoplay:2000,
                speed:250,
                nextButton:'.btn-next',
                prevButton:'.btn-prev'
            });
            var slider2 = new Swiper(".slider2",{
                loop:true,
                autoplay:3000,
                speed:1200,
                pagination:".slider2 .pagination",
                paginationClickable:true
            });
    }
})
