Vue.use(VueAwesomeSwiper)

const app = new Vue({
    el : '#app'
    , store: store
    , mixins : [item_mixin, modal_mixin, common_mixin]
    , template : `
        <div id="content" class="content best_main2021">
            <section class="item_module">
                <nav class="ctgr_nav_type2 re_nav_type">
                    <swiper :options="swiperOption" ref="swiperCategories">
                        <swiper-slide class="swiper-slide"><a @click="go_search('', '')" href="javascript:void(0)" :class="[{active : cate_code == ''}]">전체</a></swiper-slide>
                        <swiper-slide v-for="item in categories" class="swiper-slide">
                            <a @click="go_search(item.cate_code, item.cate_name)" href="javascript:void(0)" :class="[{active : cate_code == item.cate_code}]">{{item.cate_name}}</a>
                        </swiper-slide>
                    </swiper>
                        
                    <p class="re_txt">베스트셀러</p>
                    <div class="best_main">
                        <div class="icon">
                            <p class="main"><img src="//fiximage.10x10.co.kr/m/2021/best/best_main.png?v=3" alt=""></p>
                            <p class="book"><img src="//fiximage.10x10.co.kr/m/2021/best/main_book.png" alt=""></p>
                            <p class="pen"><img src="//fiximage.10x10.co.kr/m/2021/best/main_pen.png?v=3" alt=""></p>
                            <p class="clock"><img src="//fiximage.10x10.co.kr/m/2021/best/main_clock.png" alt=""></p>
                        </div>
                        <p v-if="update_text" @click="click_modal('open')" class="update">{{update_text}}</p>	
                        <p v-else @click="click_modal('open')" v-show="countdown_flag" class="update update_set bbl_gray">다음 업데이트 까지 {{left_update_minutes}}:{{left_update_second}}</p>			
                    </div>
                </nav>
                
                <div v-if="items.length > 0" class="best_2021">
                    <template v-for="item in items">
                        <Product-Item-Best
                            @go_item="go_item"
                            @change_wish_flag="change_wish_flag_product"
                            :key="item.rank"
                            :isApp="isApp"
                            :item_id="item.item_id"
                            :image_url="item.list_image"
                            :item_price="item.item_price"
                            :sale_percent="item.sale_percent"
                            :item_coupon_yn="item.item_coupon_yn"
                            :item_coupon_value="item.item_coupon_value"
                            :item_coupon_type="item.item_coupon_type"
                            :item_name="item.item_name"
                            sell_flag="Y"
                            :rental_yn="item.rental_yn"
                            :wish_yn="item.wish_yn"
                            :rank="item.rank"
                            :rank_diff="item.rank_diff"
                            :flag_text="item.flag_text"
                        ></Product-Item-Best>
                    </template>
                </div>
                <div v-show="loading_flag" class="loadingV21">
                    <lottie-player src="https://assets2.lottiefiles.com/private_files/lf30_sf61wl6k.json" class="inner-loading" speed="1" loop autoplay></lottie-player>
                </div>
            </section>

            <!-- 탑 버튼 -->
            <Button-Top-Best :last_update_time="last_update_time" :left_update_hour="left_update_hour" 
                :left_update_minutes="parseInt(left_update_minutes)" :left_update_second="parseInt(left_update_second)"
                :refresh_gage_flag="refresh_gage_flag" :refresh_flag="refresh_flag"
                @reload="reload" @change_flag="change_flag"
            ></Button-Top-Best>
                
            <div class="modalV20 modal_type4 modal_best">
                <div @click="click_modal('close')" class="modal_overlay"></div>
                <div class="modal_wrap">
                    <div class="modal_header">
                        <h2>모달</h2>
                        <button @click="click_modal('close')" class="btn_close"><i class="i_close"></i>모달닫기</button>
                    </div>
                    <div class="modal_body">
                        <h2 class="modal_tit">베스트 랭킹 순위는<br>어떻게 산정하나요?</h2>
                        <p class="modal_noti">텐바이텐의 베스트셀러는 최근 24시간 동안의 판매량, 조회수, 위시 수, 후기 수 등의 고객 관심도를 반영하여 3시간 기준으로 업데이트하고 있답니다.</p>
                        <div class="tip">
                            <h3><i class="icon"></i>TIP</h3>
                            <p>상품 추천을 좋아하는 피키가 여러분들께 틈틈히<br>유용한 정보를 알려주고 있으니 말풍선을 주목해주세요!</p>
                            <div class="picky">
                                <p class="bbl_ten">제가 바로 피키예요. 저를 주목해주세요!</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>                     
        </div>
    `
    , created() {
        const _this = this;
        this.$store.dispatch('GET_ITEMS');
        this.$store.dispatch('GET_CATEGORIES');
        this.move_category_swiper();
    }
    , mounted() {
        this.scroll();
    }
    , data() {
        const _this = this;

        return {
            scroll_height : parseInt(document.body.scrollHeight/2) // 무한 스크롤 트리거 (높이값)
            , swiperOption: {
                slidesPerView: 'auto'
                , freeMode : true
                , on : { click : function(data){
                            const activeIndex = data.clickedIndex;
                            if(activeIndex){
                                console.log("click swiper index", activeIndex);
                                app.$refs.swiperCategories.$swiper.slideTo(activeIndex);
                            }
                        }
                }
            }
            , left_update_hour : 0
            , left_update_minutes : 0
            , left_update_second : 0
            , refresh_gage_flag : false
            , refresh_flag : false
            , countdown_flag : false

            , amplitudeActionName : "click_best_"
        }
    }
    , computed : {
        items(){
            return this.$store.getters.items;
        }
        , current_page(){
            return this.$store.getters.current_page;
        }
        , last_page(){
            return this.$store.getters.last_page;
        }
        , categories(){
            return this.$store.getters.categories;
        }
        , cate_code(){
            return this.$store.getters.cate_code;
        }
        , last_update_time(){
            return this.$store.getters.last_update_time;
        }
        , update_text(){
            return this.$store.getters.update_text;
        }
        , loading_flag(){
            return this.$store.getters.loading_flag;
        }
    },
    methods : {
        go_search(cate_code, cate_name){
            $('.best_2021').animate({opacity:0},0);
            $('.best_2021').animate({opacity:1},300);

            this.$store.commit("SET_CATE_CODE", cate_code);
            this.$store.commit("SET_CATE_NAME", cate_name);
            this.$store.commit("SET_CURRENT_PAGE", 1);
            this.$store.dispatch('GET_ITEMS', cate_code);
        }
        , scroll(){
            const _this = this;

            window.onscroll = function(ev){
                if ($(window).scrollTop() >= ($(document).height() - $(window).height()) - 450) {
                    if(_this.current_page < _this.last_page){
                        _this.$store.dispatch('GET_MORE_ITEMS');
                    }
                }

                /*picky*/
                $('.best_2021 .picky').each(function(){
                    if ($(window).scrollTop() + $(window).height() < $(this).offset().top) {
                        $(this).removeClass('show');
                    } else {
                        $(this).addClass('show');
                    }
                });
            };
        }
        , countdown(){
            const _this = this;
            
            let now = new Date();
            let updateTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(), parseInt(_this.last_update_time) + 3, 0, 0);
            let diff_time = updateTime - now;

            //dday=Math.floor(diff_time/(60*60*1000*24)*1);
            dhour=Math.floor((diff_time%(60*60*1000*24))/(60*60*1000)*1);
            dmin=Math.floor(((diff_time%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
            dsec = Math.floor((((diff_time%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);
            //console.log("part of time", dhour, dmin, dsec);

            this.left_update_hour = dhour < 10 ? "0" + dhour : dhour;
            this.left_update_minutes = dmin < 10 ? "0" + dmin : dmin;
            this.left_update_second = dsec < 10 ? "0" + dsec : dsec;;

            if(dhour == 0 && dmin <= 3){
                this.refresh_gage_flag = true;
            }
            if(dhour == 0 && dmin == 0 && dsec == 0){
                this.refresh_flag = true;
            }

            setTimeout(function() {
                _this.countdown()
            },500);
        }
        , click_modal(type){
            if(type == "open"){
                $('.modalV20').addClass('show');
                $('.modalV20 .modal_cont').animate({scrollTop : 0}, 0);
                this.toggleScrolling();

                fnAmplitudeEventObjectAction('click_best_info', {});
            }else{
                $(".modalV20").removeClass('show');
                this.toggleScrolling();
            }
        }
        , toggleScrolling(){
            if ($('.modalV20').hasClass('show')) {
                currentY = $(window).scrollTop();
                $('html').addClass('not_scroll');
            } else {
                $('html').removeClass('not_scroll');
                $('html').animate({scrollTop : currentY}, 0);
            }
        }
        , reload(){
            $('html, body').animate({scrollTop:0}, 'fast');
            $('.best_2021').animate({opacity:0},0);
            $('.best_2021').animate({opacity:1},300);

            this.$store.commit("SET_CURRENT_PAGE", 1);
            this.$store.dispatch('GET_ITEMS');
            this.$store.dispatch('GET_CATEGORIES');
            this.move_category_swiper();
        }
        , change_flag(){
            this.refresh_gage_flag = false;
            this.refresh_flag = false;
        }
        , move_category_swiper(){
            const _this = this;

            this.$nextTick(function(){
                $('.ctgr_nav_type2.re_nav_type').addClass('on');

                setTimeout(function() {
                    $('.ctgr_nav_type2.re_nav_type').removeClass('on');

                    if(!this.update_text){
                        _this.countdown();
                        _this.countdown_flag = true;
                    }
                }, 1500);
            });
        }
        , go_item(item_id, ranking, flag_text) {
            fnAmplitudeEventObjectAction('click_best_item', {
                "item_id" : item_id
                , "ranking" : ranking
                , "interfere" : flag_text && flag_text != "" ? "y" : "n"
            });

            if( this.isApp ) {
                fnAPPpopupProductRenewal(item_id);
            } else {
                location.href = "/category/category_itemPrd.asp?itemid=" + item_id + "&flag=e";
            }
        }
    }
});