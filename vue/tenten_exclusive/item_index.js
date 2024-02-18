Vue.use(VueAwesomeSwiper)

const app = new Vue({
    el: '#app'
    , store : store
    , mixin : [common_mixin]
    , template : `
        <div id="content" class="content ten_only">
            <div class="main">
                <img @click="go_detail" :src="item.detail_top_img" alt="텐텐 상세 이미지">                
            </div>
            <div class="title">
                <h1 class="ten_title">텐텐단독상점</h1>
                <p class="tit_sub">
                    오직 텐바이텐에서 만날 수 있는 모든 것을 소개할게요.<br>
                    매력적인 브랜드와 함께 특별한 상품을 준비했어요.<br>
                    이번 주인공은 <span class="brand">{{item.brand_name}}</span>의 <span class="b_product">{{item.item_name}} </span>입니다.
                </p>
            </div>
            <div class="info">
                <img @click="go_detail" :src="item.brand_image" alt="브랜드 이미지">
                <div class="info_wrap">
                    <h2 class="brand_name"><span>BRAND</span>{{item.brand_name}}</h2>
                    <pre class="brand_info" v-html="change_nr(item.brand_content)"></pre>
                    <a @click="go_brand" href="#javscript:void(0)" class="brand_link">브랜드 보러가기<span class="icon"></span></a>
                </div>
            </div>
            <div class="pro_detail">
                <div class="detail_main">
                    <img @click="go_detail" :src="item.image1" alt="상품 이미지">
                    <div class="detail_wrap">
                        <h2 class="detail_sub" v-html="change_nr(item.main_copy1)"></h2>
                            <pre class="detail_info" v-html="change_nr(item.content1)"></pre>                            
                    </div>            
                </div>
                <div class="detail_more">
                    <swiper :options="swiperOption" class="detail_swiper" >
                        <swiper-slide v-for="rolling in item.rolling_list">
                            <img @click="go_detail" :src="rolling" alt="롤링 이미지">
                        </swiper-slide>                      
                        <div class="swiper-pagination" slot="pagination"></div> 
                    </swiper>
                    
                    <div class="detail_wrap">    
                        <h2 class="detail_sub" v-html="change_nr(item.main_copy2)"></h2>
                        <pre class="detail_info" v-html="change_nr(item.content2)"></pre>
                    </div>
                </div>
                <div class="chat_zone">
                    <div class="chat01">
                        <p class="brand" v-bind:style="{\'background-image\': \'url(\'+ item.brand_profile_img +\')\'}" style="background-size: 8vw; background-repeat: no-repeat;background-position:0 0;">{{item.brand_nickname}}</p>
                            <pre class="chat_brand" v-html="item.brand_bubble"></pre>
                    </div>
                    <div class="chat02">
                        <p class="brand" v-bind:style="{\'background-image\': \'url(\'+ item.tenten_profile_img +\')\'}" style="background-size: 8vw; background-repeat: no-repeat;background-position:0 0;">{{item.tenten_nickname}}</p>
                            <pre class="chat_brand" v-html="item.tenten_bubble"></pre>
                    </div>
                </div>
                <div class="sub_event">
                    <!--<div class="event">
                        <p class="icon">EVENT</p>
                        <div>
                            <p class="event_info">
                                프루아의 질문에 답해주신 분들 중<br>추첨을 통해 shell card holder를<br>선물로 드립니다!
                            </p>
                        </div>
                        <a href="" class="go_shop">
                            상품 보러가기<span class="icon"></span>
                        </a>
                    </div>-->
                    <div class="vote">
                        <p class="quest">{{item.brand_name}}의 질문</p>
                        <p class="question" v-html="change_nr(servey.question_contents)"></p>
                        <div class="option" id="vote_option">
                            <template v-for="(answer, index) in servey.choice">
                                <div @click="go_update_choice($event, servey.question_idx, answer.choice_idx, index)" :data-label="answer.choice_contents" :data-level="answer.vote_percent" :class="[{best : servey.already_choice_idx == answer.choice_idx}, 'chart']">
                                    <span></span>
                                    <p></p>
                                    <i>{{answer.vote_percent}}<b>%</b></i>
                                </div>
                            </template>

                            <div class="comment"><a @click="popup_comment('commnet')" href="javascript:void(0)">만족스러운 답이 없는 걸?</a></div>
                        </div>                        
                        <p class="vote_noti"><span>{{servey.total_vote_cnt}}</span>명이 투표했어요</p>
                    </div>
                    <div v-if="comment_list.totalCount > 1" class="comment_zone">
                        <p class="com_tit"><span>{{comment_list.totalCount}}</span>명이 의견을 나누고 있어요!</p>
                        <div class="com_list">
                            <div v-for="item in comment_list.comments" class="com_wrap">
                                <pre class="comment">{{item.contents}}</pre>
                                <p class="com_info"><span class="user_id">{{item.userId}}</span><i class="date">{{item.regDt}}</i></p>
                            </div>
                        </div>
                        <a @click="popup_comment('all')" href="javascript:void(0)" class="com_more">전체보기<span class="icon"></span></a>
                    </div>
                    <a @click="go_share()" :data-clipboard-text="'m.10x10.co.kr/tenten_exclusive/item_detail.asp?exclusive_idx=' + item.exclusive_idx" id="urlcopy" href="javascript:void(0)" class="share" >친구에게도 공유하기</a><!-- 투표 완료 시 노출 -->
                </div>
                <p class="banner_img">
                    <a @click="go_main" href="javascript:void(0)"><img src="http://fiximage.10x10.co.kr/m/2021/tenten/detail_banner.png" alt=""></a>
                </p>
            </div>    
            <a @click="go_detail" href="javascript:void(0)" class="go_shop">상품 구매하러가기</a>
            <div id="modalLayer" style="display:none;"></div>
        </div>
    `
    , created() {
        this.$store.dispatch("GET_DATA");
        this.$store.dispatch("GET_SERVEY");
        this.$store.dispatch("GET_COMMENT_LIST");

        this.isLoginOk = isUserLoginOK;
    }
    , mounted(){
        const _this = this;
        setTimeout(function() {
            fnAmplitudeEventMultiPropertiesAction("view_exclusive_detail", "item_id", "'" + _this.item.itemid + "'");

            if(_this.servey.already_participate){
                console.log("already_participate");
                _this.click_choice();
            }
        }, 1500);
    }
    , computed : {
        item : function(){
            return this.$store.getters.item;
        }
        , servey(){
            return this.$store.getters.servey;
        }
        , comment_list(){
            return this.$store.getters.comment_list;
        }
    }
    , data(){
        return {
            isLoginOk : false
            , swiperOption: {
                slidesPerView: 1
                , spaceBetween: 30
                , pagination: {
                    el: '.swiper-pagination'
                    , type: "bullets"
                    , clickable: true
                }
            }
            , is_saving : false
            , isApp : isApp
        }
    }
    , methods : {
        go_update_choice(e, question_idx, choice_idx, index){
            const _this = this;

            if(this.is_saving){
                return false;
            }

            if(this.servey.already_participate){
                if(this.servey.already_choice_idx == choice_idx){

                }else{
                    alert("고마워요! 하지만 투표는 한 번만 참여 할 수 있어요 :)");
                }
            }else{
                if(this.isLoginOk){
                    this.is_saving = true;
                    const api_data = {
                        "question_idx" : question_idx
                        , "choice_idx" : choice_idx
                    }

                    call_api("POST", "/tenten-exclusive-real/servey", api_data
                        , data=>{
                            console.log("go_update_choice", data);
                            _this.is_saving = false;

                            if(data == 200){
                                //alert("참여 완료");
                                _this.$store.dispatch("GET_SERVEY");
                                _this.click_choice();

                                fnAmplitudeEventMultiPropertiesAction('click_exclusive_detail_vote','item_id|number', _this.item.itemid+"|"+(index+1));
                            }else if(data == 101){
                                alert("이미 참여하셨습니다.");
                            }else if(data == 102){
                                if(confirm("투표를 하시려면 로그인이 필요해요!\n로그인 하시겠어요?")){
                                    if( isApp ) {
                                        fnAPPpopupLogin(location.pathname + location.search);
                                    } else {
                                        location.href = '/login/login.asp?backpath=' + location.pathname + location.search.replaceAll("&", "^^");
                                    }
                                }
                            }
                        }
                    );
                }else{
                    if(confirm("투표를 하시려면 로그인이 필요해요!\n로그인 하시겠어요?")){
                        if( isApp ) {
                            fnAPPpopupLogin(location.pathname + location.search);
                        } else {
                            location.href = '/login/login.asp?backpath=' + location.pathname + location.search.replaceAll("&", "^^");
                        }
                    }
                }
            }
        }
        , go_share(){
            fnAmplitudeEventMultiPropertiesAction('click_exclusive_detail_share','item_id', "'" + this.item.itemid + "'");

            let clipboard = new Clipboard('#urlcopy');
            clipboard.on('success', function(e) {
                alert('URL이 복사 되었습니다.');
                console.log(e);
            });
            clipboard.on('error', function(e) {
                console.log(e);
            });
        }
        , click_choice(){
            $("#vote_option").addClass('on');
            $('span').delay(0).animate({"opacity" : "1"}, 0, function(){
                $(".vote .chart span").each(function (){
                    $(this).css({"width" : $(this).parent().attr("data-level") + "%"});
                    //$(this).css("width", $(this).parent().attr("data-level") + "%");
                });
            });
        }
        , popup_comment(type){
            if(type == "comment"){
                fnAmplitudeEventMultiPropertiesAction('click_exclusive_detail_comment','item_id', "'" + this.item.itemid + "'");
            }else if(type == "all"){
                fnAmplitudeEventMultiPropertiesAction('click_exclusive_comment_all','item_id', "'" + this.item.itemid + "'");
            }

            console.log("popup_comment", isApp);
            if(isApp){
                fnAPPpopupBrowserURL('코멘트',location.origin + '/apps/appCom/wish/web2014/tenten_exclusive/comment.asp?exclusiveIdx=' + this.item.exclusive_idx);
            } else {
                fnOpenModal('/tenten_exclusive/comment.asp?exclusiveIdx=' + this.item.exclusive_idx);
            }
        }
        , go_detail(){
            fnAmplitudeEventMultiPropertiesAction('click_exclusive_detail_product','item_id', "'" + this.item.itemid + "'");
            this.itemUrl(this.item.itemid, this.decodeBase64(this.item.move_url));
        }
        , decodeBase64(str){
            if( str == null ) return null;
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        }
        , change_nr(text){
            if(text){
                return text.replaceAll("\r\n", "<br />");
            }
        }
        , go_main(){
            if(isApp){
                location.href="/apps/appCom/wish/web2014/tenten_exclusive/main.asp";
            }else{
                location.href="/tenten_exclusive/main.asp?gnbflag=1";
            }
        }
        , go_brand(){
            if(isApp){
                fnAPPpopupBrand(this.item.brand_id);
            }else{
                location.href="/brand/brand_detail2020.asp?brandid=" + this.item.brand_id;
            }
        }
    }
    , watch : {

    }
});