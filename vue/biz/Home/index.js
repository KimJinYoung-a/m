let app = new Vue({
    el: '#app',
    store: store,
    mixins: [common_mixin, item_mixin],
    template: `
		<div id="content" class="content category_main">
            <!-- main banner -->
            <div v-show="banner_list != null && banner_list.length > 0" id="mainSwiper" class="text-bnr main-bnr">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <section v-for="item in banner_list" class="swiper-slide">
                            <a :href="item.linkurl">
                                <div class="thumbnail"><img :src="item.imageurl" alt="이미지"></div>
                                <div class="desc">
                                    <h2 class="headline">{{item.titlename}}<br> {{item.subtitlename}}</h2>
                                </div>
                            </a>
                        </section>
                    </div>
                    <div class="pagingNo"></div>
                    <span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span>
                </div>
            </div>
    
            <div class="category_icon">
                <div v-for="(category, index) in categories" :class="['icon_wrap', 'line0' + (index+1)]">
                    <div v-for="item in category" @click="go_category(item.category_code)" :class="[item.category_code == category_code ? 'on' : '', item.category_name == '곧 만나요!' ? 'soon' : '']">
                        <a href="javascript:void(0)"><img :src="decodeBase64(item.category_image)" :alt="item.category_name">{{item.category_name}}</a>
                    </div>
                    <!--<div class="soon"><a href="javscript:void(0)"><img src="//fiximage.10x10.co.kr/web2021/biz/m/soon.gif" alt="곧 만나요">곧 만나요!</a></div>-->				
                </div>
            </div>

            <a v-show="is_confirm != 'Y' && is_confirm != 'S'" href="/biz/login.asp" class="biz_float">
                <p class="f_noti">이 곳은 <span>사업자 전용 쇼핑몰</span>입니다!</p>
                <p class="f_link">사업자 전용계정 만들러 가기</p>
            </a>
    
            <div v-if="best_pick != null && best_pick.length > 0" class="today_prd">
                <div class="today_pick"><button type="button" class="btn_view_type_biz active">오늘의 추천</button></div>			
                <article v-for="item in best_pick" class="prd_item">
                    <figure class="prd_img">
                        <img :src="decodeBase64(item.basic_image)" alt="">
                    </figure>
                    <div class="prd_info">
                        <!-- 비즈 회원 아닐 경우 노출 -->
                        <div class="prd_price not_biz">
                            <template v-if="item.item_price">
                                <span class="set_price"><dfn>판매가</dfn>{{number_format(item.item_price)}}</span>
                                <span class="discount"><dfn>할인율</dfn>{{item.sale_percent}}%</span>                                
                            </template>
                            <template v-else>
                                <span>BIZ</span> 회원전용가
                            </template>
                        </div>
                        <div class="prd_name">{{item.item_name}}</div>
                        <div class="user_side">
                            <span v-if="item.totalpoint >= 80" class="user_eval"><dfn>평점</dfn><i :style="'width:' + item.totalpoint + '%'">{{item.totalpoint}}점</i></span>
                            <span v-if="item.review_cnt >= 5" class="user_comment"><dfn>상품평</dfn>{{item.review_cnt}}</span>
                        </div>
                    </div>
                    <a @click="go_product(item.item_id, item.move_url)" href="javascript:void(0)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                </article>
            </div>    
            
            <!-- 뷰 타입 탭 -->
            <div class="tab_view_type_biz">
                <button @click="change_sort_method('best')" type="button" :class="['btn_view_type_biz', sort_method == 'best' ? 'active' : '']">많이 찾고 있어요</button>
                <button @click="change_sort_method('new')" type="button" :class="['btn_view_type_biz', sort_method == 'new' ? 'active' : '']">새로 들어왔어요</button>
            </div>
            
            <!-- 상품 리스트 -->
            <div class="prd_list type_basic">
                <Product-Item-Basic
                    v-for="(product, index) in recommend_list"
                    :key="product.item_id"
                    :index="index + 1"
                    @go_item_detail="go_item_detail"
                    :isApp="false"
                    :product="product"
                    :view_type="'list'"
                    :sort="sort_method"
                    :isBiz="true"
                ></Product-Item-Basic>
            </div>    
    
            <!-- 가입승인 대기 -->
            <div v-if="is_confirm == 'S' && join_loading_flag" class="join_loading">
                <div class="load_wrap">
                    <div class="loader">
                        <div class="circle" id="a"></div>
                        <div class="circle" id="b"></div>
                        <div class="circle" id="c"></div>
                        <div class="circle" id="d"></div>
                    </div>
                </div>			
                <p class="main_noti">가입 승인 대기 중입니다</p>
                <p class="sub_noti">승인 여부는 24시간 내에 알려드릴게요</p>
                <a @click="close_join_loading" href="javascript:void(0)" class="btn_close"></a>
            </div>
        </div>
    `,
    data() {
        return {
            isApp : isApp // 앱 여부
            , is_confirm : is_confirm
            , main_swiper : null
            , sort_method : "best"
            , category_code : 0
            , join_loading_flag : true
        }
    },
    created() {
        let master_code = 21;
        if(isDevelop){
            master_code = 17
        }
        this.$store.dispatch("GET_BANNER_LIST", master_code); // test: 17 / prd : 21
        this.$store.dispatch("GET_BEST_PICK");

        let recommend_request = {"sort_method" : "best", "category_code" : 0};
        this.$store.dispatch("GET_RECOMMEND_LIST", recommend_request);
        this.$store.dispatch("GET_CATEGORIES", 0);
    },
    mounted() {
        const _this = this;
        this.$nextTick(function() {
            setTimeout(function() {
                _this.main_swiper = new Swiper("#mainSwiper .swiper-container", {
                    paginationClickable:true,
                    loop:true,
                    speed:600,
                    parallax:true,
                    initialSlide:0,
                    pagination: {
                        el: ".pagingNo",
                        type: "fraction"
                    },
                    onInit : function (){
                        $("#mainSwiper .pagingNo .page strong").text(1);
                    }
                    , onSlideChangeStart: function (data) {
                        let vActIdx = parseInt(data.activeIndex);
                        //console.log("vActIdx", vActIdx);
                        if (vActIdx<=0) {
                            vActIdx = data.slides.length-2;
                        } else if(vActIdx>(data.slides.length-2)) {
                            vActIdx = 1;
                        }
                        $("#mainSwiper .pagingNo .page strong").text(vActIdx);
                    }
                });
            }, 1000);

            setTimeout(function() {
                _this.join_loading_flag = false;
            }, 20000);
        });

        fnAmplitudeEventMultiPropertiesAction('view_biz_main','','');
    },
    computed : {
        banner_list(){
            return this.$store.getters.banner_list;
        }
        , best_pick(){
            return this.$store.getters.best_pick;
        }
        , recommend_list() {
            return this.$store.getters.recommend_list;
        }
        , categories(){
            return this.$store.getters.categories;
        }
    },
    methods : {
        decodeBase64(str) {
            if (str == null) return null;
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        }
        , go_product(item_id, move_url){
            this.itemUrl(item_id);
        }
        , go_item_detail(index, product) {
            fnAmplitudeEventObjectAction('click_Home_productlist_item', {
                'item_index' : index,
                'list_style' : 'list',
                'sort' : amplitudeSort(this.sort_method),
                'itemid' : product.item_id,
                'category_name' : product.category_name,
                'brand_name' : product.brand_name_en
            });
        }
        , change_sort_method(sort_method){
            this.sort_method = sort_method;
            this.$store.dispatch("GET_RECOMMEND_LIST", {"sort_method" : sort_method, "category_code" : this.category_code});
        }
        ,go_category(category_code){
            if(category_code){
                location.href = "/biz/category_list.asp?disp=" + category_code;
            }
        }
        , close_join_loading(){
            this.join_loading_flag = false;
        }
        , get_cookie(name){
            const nameOfCookie = name + "=";
            //alert(nameOfCookie);
            let x = 0;
            while ( x <= document.cookie.length ){
                let y = (x+nameOfCookie.length);
                if ( document.cookie.substring( x, y ) == nameOfCookie ) {
                    if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
                        endOfCookie = document.cookie.length;
                    return unescape( document.cookie.substring( y, endOfCookie ) );
                }
                x = document.cookie.indexOf( " ", x ) + 1;
                if ( x == 0 ){
                    break;
                }
            }
            return "";
        }
    }
});