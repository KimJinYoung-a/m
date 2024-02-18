var banner_component = {
    template : `
    <section v-if="items != null && items.length > 0" class="item_module">
        <div class="evt_slider_type1">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <article class="swiper-slide evt_item"
                        v-for="(banner, index) in items"
                        :key="index"
                    >
                        <figure class="evt_img">
                            <img :src="banner.banner_image" alt="">
                        </figure>
                        <div class="evt_info">
                            <div class="evt_name ellipsis3" v-html="banner.banner_text"></div>
                        </div>
                        <a :href="banner.move_url" class="evt_link"><span class="blind">기획전 바로가기</span></a>
                    </article>
                </div>
            </div>
            <button @click="click_more_button" type="button" class="btn_more">
                <div class="paging"></div>
                <em class="em">전체보기</em>
            </button>
        </div>
    </section>
    `,
    props : {
        items: { // 배너 리스트
            banner_image: String,
            banner_text: String,
            move_url: String
        }
    },
    mounted() {
        this.create_slider();
    },
    updated() {
        this.create_slider();
    },
    methods: {
        create_slider() {
            $('.evt_slider_type1').each(function(i, el) {
                var slider = $(el).find('.swiper-container'),
                    lth = slider.find('.swiper-slide').length,
                    paging = $(el).find('.paging');

                if (lth > 1) {
                    slider.addClass('on'+i);
                    paging.addClass('on'+i);
                    var evtSwiper1 = new Swiper('.swiper-container.on'+i, {
                        speed: 500,
                        pagination: {
                            el: '.paging.on'+i,
                            type: 'fraction',
                            currentClass: 'em',
                            totalClass: 'total',
                            renderFraction: function (currentClass, totalClass) {
                                return '<em class="' + currentClass + '"></em>' + '<i class="bar">/</i>' + '<span class="' + totalClass + '"></span>';
                            }
                        }
                    });
                } else {
                    $(el).find('.btn_more').hide();
                }
            });
        },
        click_more_button() {
            this.$emit('click_more_button');
        }
    }
};