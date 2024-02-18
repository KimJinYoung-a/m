const app = new Vue({
    el : '#app',
    template : /* html */`
    <div class="mEvt114117">
        <section class="section01">
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/top.jpg?v=3" alt="">
            <p class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/txt01.png" alt=""></p>
            <p class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/txt02.png" alt=""></p>
            <p class="app_float"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/app_float.png" alt=""></p> 
        </section>
        <section class="section02">
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/submit02.jpg?v=2" alt="">
            <p class="float01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/float01.png" alt=""></p>
            <a href="https://tenten.app.link/wRyajD1vvjb?%24deeplink_no_attribution=true" class="submit"></a>
        </section>
        <section class="section03">
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/notice.jpg" alt="">
            <a @click="onOffPrecaution" class="notice"><span :class="{'on':showPrecaution}"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/arrow_down.png" alt=""></span></a>
            <div v-show="showPrecaution" class="info">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/info.jpg" alt="">
            </div>
        </section>
        <section class="section05">
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/product.jpg" alt="">
            <div class="swiper-container slide">
                <div class="swiper-wrapper">
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide01.png?v=2" alt="slide01"></div>
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide02.png?v=2" alt="slide02"></div>
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide03.png" alt="slide03"></div>
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide04.png" alt="slide02"></div>
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide05.png" alt="slide03"></div>
                </div>
            </div>
        </section>
        <section class="section06">
            <div class="item01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item01.jpg" alt="">
                <p class="float02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/float02.png" alt=""></p>
                <a href="/category/category_itemprd.asp?itemid=3767177&pEtr=114116" class="prd01"></a>
                <a href="/category/category_itemprd.asp?itemid=3987474&pEtr=114116" class="prd02"></a>
                <a href="https://m.10x10.co.kr/search/search_product2020.asp?rect=%EC%BA%94%EB%93%A4" class="url01"></a>                
                <a href="/category/category_itemprd.asp?itemid=3812529&pEtr=114116" class="prd03"></a>
                <a href="https://m.10x10.co.kr/search/search_product2020.asp?rect=%EB%AC%B4%EB%93%9C%EB%93%B1" class="url02"></a>
            </div>
            <div class="item02">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item02.jpg" alt="">
                <a href="https://m.10x10.co.kr/search/search_product2020.asp?rect=%EB%A8%B8%EA%B7%B8%EC%BB%B5" class="url01"></a>
                <a href="/category/category_itemprd.asp?itemid=4017518&pEtr=114116" class="prd01"></a>
                <a href="/category/category_itemprd.asp?itemid=3855587&pEtr=114116" class="prd02"></a>
                <a href="https://m.10x10.co.kr/search/search_product2020.asp?rect=%EC%99%80%EC%9D%B8%EC%9E%94" class="url02"></a>                        
            </div>
            <div class="item03">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item03.jpg" alt="">
                <a href="https://m.10x10.co.kr/event/eventmain.asp?eventid=113987" class="url01"></a>
                <a href="/category/category_itemprd.asp?itemid=3507415&pEtr=114116" class="prd01"></a>
            </div>
            <div class="item04">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item04.jpg" alt="">
                <a href="/category/category_itemprd.asp?itemid=3997620&pEtr=114116" class="prd01"></a>
                <a href="https://m.10x10.co.kr/event/eventmain.asp?eventid=113899" class="url01"></a>        
            </div>
            <div class="item05">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item05.jpg" alt="">
                <a href="https://m.10x10.co.kr/search/search_product2020.asp?rect=%EB%85%B8%ED%8A%B8" class="url01"></a>
                <a href="/category/category_itemprd.asp?itemid=3852495&pEtr=114116" class="prd01"></a>
            </div>
        </section>
        <section class="section07">
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/bottom.jpg" alt="">
            <a href="https://m.10x10.co.kr/event/benefit/" class="new_page"></a>
        </section>
    </div>
    `,
    mounted() {
        this.onTitleSection();
    },
    data() {return {
        showPrecaution : false
    }},
    computed : {},
    methods : {
        onTitleSection() {
            $(function() { $('.mEvt114117 .section01 p').addClass('on'); });
        },
        onOffPrecaution() {
            this.showPrecaution = !this.showPrecaution;
        }
    }
});