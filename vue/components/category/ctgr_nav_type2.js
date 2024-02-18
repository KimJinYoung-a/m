/*
    카테고리 필터 슬라이더
*/
Vue.component('Category-Nav-Type2',{
    template : `        
            <nav :id="slider_id" class="ctgr_nav_type2">
                <div class="swiper-container">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide"
                            v-for="(category, index) in categories"
                            :key="index"
                        >
                            <a 
                                :id="'ctgr_nav_' + category.catecode"
                                :class="{active : category.catecode == active_code}"
                                @click="click_category(category.catecode, category.catename)">
                                {{category.catename}}
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
    `,
    data() {return {
        swiper : null
    }},
    props : {
        active_code : {type:Number, default:0}, // 활성화할 카테고리코드
        categories : { // 카테고리 리스트
            catecode : {type:Number, default:0}, // 카테고리 코드
            catename : {type:String, default:''} // 카테고리명
        },
        slider_id : {type : String, default : 'ctgr_nav_type2'},
    },
    mounted : function() {
        const _this = this;
        _this.$nextTick(function () {
            _this.swiper = new Swiper('#' + _this.slider_id + `.ctgr_nav_type2 .swiper-container`, {
                slidesPerView:'auto',
            });
        });
    },
    updated() {
        this.swiper.update();
    },
    methods : {
        click_category(category_code, category_name) { // 카테고리 클릭
            this.$emit('click_category',category_code, category_name); // 상위컴포넌트 이벤트 전달

            // 클릭카테고리 활성화
            const slider_arr = document.querySelectorAll( '#' + this.slider_id + ' .swiper-slide a');
            for( let i=0 ; i<slider_arr.length ; i++ ) {
                if( slider_arr[i].id === 'ctgr_nav_' + category_code ) {
                    slider_arr[i].classList.add('active');
                } else {
                    slider_arr[i].classList.remove('active');
                }
            }
        },
        set_ctgrnav2_float() { // 카테고리 필터 슬라이더 플로팅
            var ctgrNav2 = $('.ctgr_nav_type2'),
                headerH = $('.tenten_header').outerHeight(),
                headType1pb = $('.head_type1').css('padding-bottom').replace('px', '');
			
            $(window).on('scroll', function() {
                if ($(window).scrollTop() >= ctgrNav2.offset().top - headerH - headType1pb) {
                    ctgrNav2.addClass('fixed');
                } else {
                    ctgrNav2.removeClass('fixed');
                }
            }); 
        },
    }
})