Vue.component('pb-brand-list', {
    template: '\
        <div class="swiper-slide"\
            v-if="brandPage.length > 0"\
        >\
            <ul>\
                <li\
                    v-for="brand in brandPage"\
                >\
                    <a @click="handleClickLink(brand.brandId)">\
                        <span class="thumbnail">\
                        <img :src="brand.brand_icon" alt="">\
                        </span>\
                        <span class="brand-name">{{brand.socname_kor}}</span>\
                        <em class=new\
                            v-if="brand.isNew == 1"\
                        >신상</em>\
                    </a>\
                </li>\
            </ul>\
        </div>\
    ',
    props: {
        brandPage: {
            type: Array,
            default: []
        },
    },
    methods: {
        handleClickLink: function(brandId){
            if(isapp == 1){
                fnAPPpopupBrand(brandId);return false;
            }else{
                window.location.href = "/brand/brand_detail2020.asp?brandid="+brandId
            }
            return false;
        }
    }
})