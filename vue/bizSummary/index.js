let app = new Vue({
    el: '#app',
    store: store,
    mixins: [common_mixin, item_mixin],
    template: `
		<div id="content" class="content category_main">
		    <div class="GNB_summary biz_summary">
                <div class="main"><img src="//fiximage.10x10.co.kr/web2021/biz/GNB_main.jpg" alt=""></div>
                <div class="biz_popup">
                    <div class="biz_noti">
                        <p class="main_noti">텐바이텐 BIZ는 어떻게 이용하나요?</p>
                        <p class="sub_noti">사업자 번호를 가지고 있다면, 누구든지 BIZ 회원이 될 수 있어요. {{biz_popup.sub_noti}}</p>
                    </div>
                    <a @click="go_biz_page" href="javascript:void(0)" class="go_biz">{{biz_popup.go_biz}}<i class="i_go_biz"><img src="//fiximage.10x10.co.kr/web2021/biz/go_biz.png" alt=""></i></a>
                </div>
            </div>
            <!-- main banner -->
            <div v-show="banner_list != null && banner_list.length > 0" id="mainSwiper" class="text-bnr main-bnr GNB_main">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <section v-for="item in banner_list" class="swiper-slide">
                            <a @click="go_banner(item.linkurl)" href="javascript:void(0)">
                                <div class="thumbnail"><img :src="item.imageurl" alt="이미지"></div>
                                <div class="desc">
                                    <h2 class="headline">{{item.titlename}}<br> {{item.subtitlename}}</h2>
                                </div>
                            </a>
                        </section>
                    </div>
                    <div class="pagingNo"></div>
                <span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span></div>
            </div>
    
            <div v-if="best_pick != null && best_pick.length > 0" class="today_prd">
                <div class="today_pick"><button type="button" class="btn_view_type_biz active">오늘의 추천</button></div>			
                <article v-for="item in best_pick" class="prd_item">
                    <figure class="prd_img">
                        <img :src="decodeBase64(item.basic_image)" alt="">
                    </figure>
                    <div class="prd_info">
                        <!-- 비즈 회원 아닐 경우 노출 -->
                        <template v-if="item.item_price">
                            <span class="set_price"><dfn>판매가</dfn>{{number_format(item.item_price)}}</span>
                            <span class="discount"><dfn>할인율</dfn>{{item.sale_percent}}%</span>                                
                        </template>
                        <template v-else>
                            <span>BIZ</span> 회원전용가
                        </template>
                        <div class="prd_name">{{item.item_name}}</div>
                        <!--<div class="user_side">
                            <span v-if="item.totalpoint >= 80" class="user_eval"><dfn>평점</dfn><i :style="'width:' + item.totalpoint + '%'">{{item.totalpoint}}점</i></span>
                            <span v-if="item.review_cnt >= 5" class="user_comment"><dfn>상품평</dfn>{{item.review_cnt}}</span>
                        </div>-->   
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
                    :isSummary="true"
                    :app_version_deny = "app_version_deny"
                ></Product-Item-Basic>
            </div>
            
            <div class="biz_more">
                <a @click="go_biz_page" href="javascript:void(0)">더 많은 상품 보러가기</a>
            </div>
        </div>
    `,
    data() {
        return {
            isApp : isApp // 앱 여부
            , app_version_deny : false
            , main_swiper : null
            , sort_method : "best"
            , category_code : 0
            , biz_popup : {
                sub_noti : "지금 바로 가입하고 BIZ를 이용해보세요!"
                , go_biz : "텐바이텐 BIZ 바로가기"
            }
        }
    },
    created() {
        const _this = this;

        let master_code = 21;
        if(isDevelop){
            master_code = 17
        }
        this.$store.dispatch("GET_BANNER_LIST", master_code); // test: 17 / prd : 21
        this.$store.dispatch("GET_BEST_PICK");

        let recommend_request = {"sort_method" : "best", "category_code" : 0};
        this.$store.dispatch("GET_RECOMMEND_LIST", recommend_request);

        if(isApp){
            callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
                    console.log("deviceInfo.version", deviceInfo.version);
                    if (getAppOperatingSystemValue().iOS()){
                        if (deviceInfo.version < 4.026){
                            _this.app_version_deny = true;
                            _this.biz_popup.sub_noti = "지금 앱을 업데이트하고 BIZ를 구경해보세요!";
                            _this.biz_popup.go_biz = "앱 업데이트 하고, BIZ 구경하기";
                        }
                    }else if (getAppOperatingSystemValue().Android()){
                        if (deviceInfo.version < 4.029){
                            _this.app_version_deny = true;
                            _this.biz_popup.sub_noti = "지금 앱을 업데이트하고 BIZ를 구경해보세요!";
                            _this.biz_popup.go_biz = "앱 업데이트 하고, BIZ 구경하기";
                        }
                    }
                }});
        }
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
                    onSlideChangeStart: function (data) {
                        let vActIdx = parseInt(data.activeIndex);
                        console.log("vActIdx", vActIdx);
                        if (vActIdx<=0) {
                            vActIdx = data.slides.length-2;
                        } else if(vActIdx>(data.slides.length-2)) {
                            vActIdx = 1;
                        }
                        $("#mainSwiper .pagingNo .page strong").text(vActIdx);
                    }
                });
            }, 1000);
        });
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
    },
    methods : {
        decodeBase64(str) {
            if (str == null) return null;
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        }
        , go_product(item_id, move_url){
            if(isApp){
                if(this.app_version_deny){
                    if(confirm("신규 서비스 BIZ를 이용하시려면\n" +
                        "앱 업데이트가 필요해요!\n" +
                        "앱을 업데이트 하시겠어요?")){
                        let userAgent = navigator.userAgent.toLowerCase();

                        if(userAgent.match('iphone') || userAgent.match('ipad') || userAgent.match('ipod')) { //아이폰
                            location.href = "https://itunes.apple.com/kr/app/tenbaiten/id864817011";
                        } else if(userAgent.match('android')) { //안드로이드 기기
                            location.href = 'market://details?id=kr.tenbyten.shopping';
                        } else { //그 외
                            location.href = 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping';
                        }
                    }
                }else{
                    const url = "https://m.10x10.co.kr/category/category_itemPrd.asp?itemid=" + item_id + "&flag=e";
                    const endcode_url = btoa(url);
                    fnOpenExternalBrowser(endcode_url);
                }
            }else{
                this.itemUrl(item_id);
            }
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
        , go_biz_page(){
            if(isApp){
                if(this.app_version_deny){
                    if(confirm("신규 서비스 BIZ를 이용하시려면\n" +
                        "앱 업데이트가 필요해요!\n" +
                        "앱을 업데이트 하시겠어요?")){
                        let userAgent = navigator.userAgent.toLowerCase();

                        if(userAgent.match('iphone') || userAgent.match('ipad') || userAgent.match('ipod')) { //아이폰
                            location.href = "https://itunes.apple.com/kr/app/tenbaiten/id864817011";
                        } else if(userAgent.match('android')) { //안드로이드 기기
                            location.href = 'market://details?id=kr.tenbyten.shopping';
                        } else { //그 외
                            location.href = 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping';
                        }
                    }
                }else{
                    const url = "https://m.10x10.co.kr/biz/index.asp";
                    const endcode_url = btoa(url);
                    fnOpenExternalBrowser(endcode_url);
                }
            }else{
                location.href = "/biz/index.asp";
            }
        }
        , go_banner(link){
            if(isApp){
                if(this.app_version_deny){
                    if(confirm("신규 서비스 BIZ를 이용하시려면\n" +
                        "앱 업데이트가 필요해요!\n" +
                        "앱을 업데이트 하시겠어요?")){
                        let userAgent = navigator.userAgent.toLowerCase();

                        if(userAgent.match('iphone') || userAgent.match('ipad') || userAgent.match('ipod')) { //아이폰
                            location.href = "https://itunes.apple.com/kr/app/tenbaiten/id864817011";
                        } else if(userAgent.match('android')) { //안드로이드 기기
                            location.href = 'market://details?id=kr.tenbyten.shopping';
                        } else { //그 외
                            location.href = 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping';
                        }
                    }
                }else{
                    const url = "https://m.10x10.co.kr" + link
                    const endcode_url = btoa(url);
                    fnOpenExternalBrowser(endcode_url);
                }
            }else{
                location.href = link;
            }
        }
    }
});