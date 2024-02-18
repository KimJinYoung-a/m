Vue.component('pb-brand-container', {
    template: '\
    <section class="pb-brand" id="pb-brand">\
        <div class="brand-rolling"\
            :class="[moreBtnFlag ? \'on\' : \'\']"\
        >\
            <div class="swiper-container">\
                <div class="swiper-wrapper">\
                    <pb-brand-list\
                        v-for="brandPage in brandPages"\
                        :brand-page=brandPage\
                    ></pb-brand-list>\
                </div>\
                <div class="pagination"></div>\
            </div>\
            <button class="btn-more"\
                v-if="brands.length > 4 && !moreBtnFlag"\
                @click="handleClickMoreBtn"\
            >+ 스페셜 브랜드 전체보기</button>\
        </div>\
    </section>\
    ',
    data: function(){
        return{
            moreBtnFlag: false
        }
    },
    props: {
        brands: {
            type: Array,
            default: []
        },
    },
    mounted: function(){
    },
    methods: {
        arrayDivition: function(arr, n) {
            var tmpArr = [];
            var numOfArr =
              Math.floor(arr.length / n) + (Math.floor(arr.length % n) > 0 ? 1 : 0);
            for (let index = 0; index < numOfArr; index++) {
              tmpArr.push(arr.splice(0, n));
            }
            return tmpArr;
        },
        handleClickMoreBtn: function(e){
            e.preventDefault();
            playBrandRolling();
            this.moreBtnFlag = true
            // $(this).hide();
            // $(this).parent().addClass('on');
        }
    },
    computed: {
        brandPages: function(){
            var tmp = this.brands.slice();
            return this.arrayDivition(tmp, 12)
        }
    }
})