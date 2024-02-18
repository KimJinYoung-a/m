//필터
Vue.filter('nl2br', function (value) {
    // 처리된 값을 반환합니다
    var returnString = String(value).replace(/(?:\r\n|\r|\n)/g, '<br />');
    return returnString.split('\n').join('<br />');
})

//lazy load
Vue.use(VueLazyload, {
	preLoad: 1.3,
	error : false,
	loading : false,
	supportWebp : false,
    listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove'],
    attempt : 1
})


// 컴포넌트-탬플릿
// 그룹 리스트 case : 3 , 9
Vue.component('group-itemlist',{
    props: {
        items : {
            type : Object,
            default : [],
        },
        groups : {
            type : Object,
            default : [],
        },
        isapp : {
            type : [String , Number],
            default : "0",
        },
        wrapper : {
            type : String,
            default : '',
        },
        barcolor : {
            type : String,
            default : '',
        },
        ltype : {
            type : String,
            default : '',
        },
    },
    template : '<div>\
                    <slot v-if="wrapper && groups.length > 1"><group-list :grouplists="groups" :getGroupName="getGroupName"></group-list></slot>\
                    <div v-if="items" :id="getGroupCode(items.groupCode)" class="items-list" >\
                        <h3 class="groupBar" v-if="wrapper && groups.length > 1 && items.itemlists.length > 0">\
                            <span v-if="barcolor" :style="themeColor(barcolor)"></span>\
                            <span v-else class="default"></span>\
                            <b>{{items.groupName}}</b>\
                        </h3>\
                        <div :class="listType(ltype)">\
                            <slot v-for="(item,index) in items.itemlists"><item-list :items="item" :itemIndex="index" :isapp="isapp"></item-list></slot>\
                        </div>\
                    </div>\
                </div>\
                ',
    computed : {
        getGroupName :  function() {
            return this.groups[1] != '' ? this.groups[1].groupName : '';
        }
    },
    methods : {
        getGroupCode : function(groupcode) {
            return "group"+groupcode;
        }
        , listType : function(obj) {
            if(obj == "type-grid"){
                obj= "prd_list type_basic";
            }else if(obj == "type-list"){
                obj = "prd_list type_wide";
            }else if(obj == "type-big"){
                obj = "prd_list type_big"
            }

            console.log("items", this.items);
            return obj;
        }
        , themeColor : function(obj) {
            return  "background-color:"+obj
        }
    }
})

// 그룹 리스트 case : 6 , etc
Vue.component('nogroup-itemlist',{
    props: {
        items : {
            type : Array,
            default : [],
        },
        isapp : {
            type : [String , Number],
            default : "0",
        },
        ltype : {
            type : String,
            default : '',
        }
    },
    template : `<div class="items-list">
                    <div :class="listType(ltype)">
                        <slot><item-list v-for="(item, index) in items" :items="item" :itemIndex="index" :isapp="isapp"></item-list></slot>
                    </div>
                </div>
                `
    , methods : {
        listType : function(obj) {
            if(obj == "type-grid"){
                obj= "prd_list type_basic";
            }else if(obj == "type-list"){
                obj = "prd_list type_wide";
            }else if(obj == "type-big"){
                obj = "prd_list type_big"
            }

            return obj;
        }
    }
})

// select 영역
Vue.component('group-list',{
    props: {
        grouplists : {
            type : Object,
            default : [],
        },
        getGroupName : {
            type : String,
            default : '',
        }
    },
    template : '<div class="dropdownWrap" style="position: absolute;">\
                    <div class="dropDown dropDown-event">\
                        <button type="button" class="btnDrop">{{getGroupName}}</button>\
                        <div class="dropBox" style="display: none;">\
                            <ul>\
                                <slot v-for="(grouplist,index) in grouplists" v-if="index > 0"><select-grouplist :groupinfo="grouplist" :index="index"></select-grouplist></slot>\
                            </ul>\
                        </div>\
                    </div>\
                </div>\
                ',
})

// 그룹 목록
Vue.component('select-grouplist',{
    props: {
        groupinfo : {
            type : Object,
            default : [],
        },
        index : {
            type : [String , Number],
            default : "0",
        }
    },
    template : '<li><a @click="gotoItemList(groupinfo.groupCode,index)"><div class="option">{{groupinfo.groupName}}</div></a></li>',
    methods : {
        gotoItemList : function(obj,idx) {
            list.$data.display = idx;
            setTimeout(function() {
                list.tabMove(obj); // 클릭 이동시 전체 바인딩
            },300);
        },
    }
})


// 상품 목록
Vue.component('item-list',{
    props: {
        items : {
            type : Object,
            default : []
        },
        isapp : {
            type : [String, Number],
            default : "0",
        },
        itemIndex : {
            type : [String, Number],
            default : "0",
        }
    }
    , data() {
        return {
            aniWish : null
            , on_flag : false
        }
    }
    ,template : `
        <article name="article" :class="['prd_item', {soldout : items.soldOut}, {adultType : items.adultType == 1}]">
            <figure class="prd_img">
                <img v-lazy="items.imageURL" alt="상품명">
                <span class="prd_mask"></span>
            </figure>
            <div class="prd_info">
                <div class="prd_price">
                    <span v-if="items.rental" class="set_price">
                        <dfn>판매가</dfn><em>월</em>{{numberWithCommas(rentalPrice(items.price))}}<em>~</em>
                    </span>
                    <span v-else class="set_price"><dfn>판매가</dfn>{{numberWithCommas(items.price)}}</span>
                    
                    <!-- 할인율 있을 경우 노출 --> 
                    <span v-if="items.salePer && items.couponType" class="discount"><em>더블할인</em></span>
                    <span v-else-if="items.salePer" class="discount">
                        <dfn>할인율</dfn>{{items.salePer}}
                    </span>
                    <span v-else-if="items.couponType" class="discount">
                        <dfn>할인율</dfn>{{items.couponType}}<em>쿠폰</em>
                    </span>                    
                </div>
                <div class="prd_name ellipsis2">{{items.itemName}}</div>
                <div class="prd_brand">앱 ? {{isapp}}</div>
                <!-- 평점 : 4점(80%) 이상일 경우 노출-->
                <!-- 상품평 : 평점 있을 경우 && 상품평 5개 이상일 경우 노출 -->
                <div v-if="items.reviewCount > 0" class="user_side">
                    <span class="user_eval"><dfn>평점</dfn><i style="width:87%">{{reviewAVG(items.evalPoint)}}점</i></span>
                    <span class="user_comment"><dfn>상품평</dfn>{{showCount(items.reviewCount)}}</span>
                </div>
            </div>
            <a @click="linkUrl(items, isapp, itemIndex)" class="prd_link"><span class="blind">상품 바로가기</span></a>
            <button @click="click_wish" :id="btn_wish" type="button" class="btn_wish" data-flag="on">
                <figure class="ico_wish"></figure>
            </button>
            <!--<div v-if="items.badge1 || items.badge2" class="prd_badge">
                <span class="badge_type1" v-if="items.badge1">{{items.badge1}}</span>
                <span class="badge_type2" v-if="items.badge2">{{items.badge2}}</span>
            </div>-->
        </article>        
    `,
    computed : {
        uiwebview : function(){
            return (list.isAppCheck() && list.iosCheck()) ? true : false;
        }
        , btn_wish(){
            return `wish_btn_${this.itemIndex}_${Math.round(Math.random()*100)}`;
        }
    }
    , mounted : function(){
        const _this = this;

        if(this.listType == "type-big"){
            $("#item-list-div").className += " items";
        }

        // 리뉴얼 위시 lottie
        this.aniWish = bodymovin.loadAnimation({
            container: document.querySelector('#' + _this.btn_wish + ' .ico_wish')
            , loop: false
            , autoplay: false
            , path: 'https://assets4.lottiefiles.com/private_files/lf30_n9czk9v0.json'
        });

        this.aniWish.goToAndStop(0, true);
        this.on_flag = false;
    }
    , methods : {
        numberWithCommas : function(price) {
            return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        addClassName : function(isDeal , adultType) {
            var className = "";
            
            if (!list.$data.isAdult && adultType == 1) className = "adult-item";
            if (isDeal) className = "deal-item";

            return className;
        },
        reviewAVG : function(obj) {
            return "width:"+obj+"%";
        },
        showCount : function(obj){
            return obj == "999" ? "999+" : obj;
        },
        linkUrl : function(obj,isApp,itemIndex){
            var amplitudeProperties = dataObject.eventkind+'|'
            +dataObject.eventid+'|'
            +dataObject.eventtype+'|'
            +obj.categoryName+'|'
            +(obj.brandName ? obj.brandName.trim() : '')+'|'
            +obj.itemID+'|'
            +obj.eventGroupCode_mo+'|'
            +parseInt(itemIndex+1)+'|'
            +list.$data.listType.replace("type-","");

            // amplitude
            fnAmplitudeEventMultiPropertiesAction('click_event_item','eventkind|eventcode|eventtype|categoryname|brand_id|itemid|group_number|item_index|list_type',amplitudeProperties);

            if (isApp == 1) {
                (obj.deal) ? fnAPPpopupDealProduct(obj.itemID+dataObject.addparam) : fnAPPpopupProduct(obj.itemID+dataObject.addparam);
            } else {
                var itemurl = (obj.deal) ? "/deal/deal.asp?itemid="+obj.itemID+dataObject.logparam+"&flag=e"+dataObject.addparam : "/category/category_itemPrd.asp?itemid="+obj.itemID+dataObject.logparam+"&flag=e"+dataObject.addparam;
                location.href = itemurl;
            }
        },
        rentalPrice : function(obj){
            var rentalPee;
            // 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨
            if (new Date() >= new Date('05/03/2021 09:00:00')
            && new Date() < new Date('06/01/2021 00:00:00')) {
                // 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)
                rentalPee = 1.105;
                return Math.floor(((obj*rentalPee) / 12)/100)*100;
            } else {
                rentalPee = 1.155;
                return Math.floor(((obj*rentalPee) / 24)/100)*100;
            }
        }
        , click_wish : function (event) {
            const _this = this;

            if(_this.isapp && _this.isapp != '0') {
                fnShowToast();
            }

            /*if( _this.on_flag ) {
                // 위시 제거
                if( _this.call_wish_api('delete') ) {
                    _this.aniWish.playSegments([18,30], true);
                    _this.on_flag = false;
                }
            } else {
                // 위시 등록
                if( _this.call_wish_api('post') ) {
                    _this.aniWish.playSegments([0,18], true);
                    _this.on_flag = true;
                }
            }*/
        }
        , call_wish_api : function (method) {
            const _this = this;
            let _url = apiurl + '/wish/item';
            let request = {
                method : method
            };
            request.item_id = this.items.itemID;

            let result = false;
            $.ajax({
                type : 'POST',
                url: _url,
                data: request,
                ContentType : "json",
                crossDomain: true,
                async: false,
                xhrFields: {
                    withCredentials: true
                }
                , success: function(data) {
                    result = true;
                    _this.send_amplitude(method === 'post' ? 'on' : 'off');
                }
                , error: function (xhr) {
                    console.log(xhr);
                    const error = JSON.parse(xhr.responseText);
                    if( error.code === -10 ) {
                        if( _this.isapp && _this.isapp != '0' ) {
                            calllogin();
                            return false;
                        } else {
                            location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
                        }
                    }
                }
            });
            return result;
        }
        , send_amplitude(on_off) {
            const parameter = this.create_amplitude_parameter(on_off);
            fnAmplitudeEventMultiPropertiesAction('click_wish', parameter.keys, parameter.values);
        }
        , create_amplitude_parameter(on_flag) { // Amplitude 파라미터 생성
            let keys = 'on_off|place';
            let values = on_flag + '|event_list';

            let eventType = list.$data.listType;
            if( eventType !== '' ) {
                keys += '|event_list_type';
                values += '|' + eventType.replace("type-", "");
            }

            return {
                keys : keys,
                values : values
            };
        }
    }
})

// 리스트 로딩전 
Vue.component('temp-layout',{
    template : '<div class="loadingV19"><i></i><p>리스트 불러오는 중</p></div>'
})

// Play List 
var list = new Vue({
    el : '#eventitemlist',
	data : function () {
		return {
            display : 2 ,	// 최초 보여질 갯수
            offset : 1 ,	// 스크롤 이후 보여질 갯수
            trigger : parseInt(document.body.scrollHeight/2) , // 무한 스크롤 트리거 (높이값)
            listType : '',
            themebarColor : '',
            items : [],    // api 상품 데이터
            groups : [],    // api 그룹 데이터
            itemlength : 0,
            tempFlag : true,
            timer : null,
            isAdult : false,
            isLogin : false,
		}
    },
    computed : {
		sliced : function() {
            return this.items.slice(0,this.display); //최초 보여질 계산된 카운트 (0,1) -- 1개 소카테고리
        },
    },
    methods : {
        scroll : function() {
			var _this = this;
			window.onscroll = function(ev){
				if (window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) - _this.trigger){
					_this.addContents();
				}
			};
        },
        tabMove : function(obj) {
            this.addContents();
            setTimeout(function(){
                location.href ="#group"+obj;
            },300);
        },
        iosCheck : function() {
            var uagentLow = navigator.userAgent.toLocaleLowerCase();
            return (uagentLow.search("iphone") > -1 || uagentLow.search("ipad") > -1) ? true : false;
        },
        isAppCheck : function() {
            return (window.location.href.search("/apps/appcom/wish/web2014") > -1) ? true : false;
        },
        lastCheckDeBounce : function() {
            var _timer = this.timer;
            var _this = this;

            if (_timer) {
                clearTimeout(_timer);
            }

            _timer = setTimeout(function(){
                _this.addScript();
            }, 1000);

            this.timer = _timer;
        },
        addScript : function () {
            $(".btnDrop").on("click", function(e){
                e.stopPropagation();
                $(".btnDrop + .dropBox").hide();
                $(this).next().show();
                $(this).toggleClass("on");
                $(this).next().toggleClass("on");
                return false;
            });
            $(".dropBox ul li a").on("click", function(e){
                $(this).parent().parent().parent().prev(".btnDrop").removeClass("on")
                $(this).parent().parent().parent().removeClass("on").prev(".btnDrop").text($(this).text());
            });
            $(document).on("click", function(e){
                $(".dropBox + .dropBox").hide();
                $(".btnDrop").removeClass("on");
                $(".lyDropdown .btnDrop").addClass("on");
                $(".dropBox").removeClass("on");
            });

            this.groups.forEach(function(item){
                if($("#group"+item.groupCode).length) {
                    if( $(window).scrollTop()>=$("#group"+item.groupCode).offset().top-$(".dropdownWrap").outerHeight()) {
                        var groupbar = $("#group"+item.groupCode).children("h3").text();
                        $(".exhibition-list-wrap").find(".btnDrop").text(groupbar);
                    }
                }
            })

            // image preload
            if (list.iosCheck() && list.isAppCheck()) {
                console.log("this is IOS uiwebview");
                this.items.forEach(function(item){
                    var imageArray = new Array();
                    item.itemlists.forEach(function(i,index){
                        imageArray[index] = new Image()
                        imageArray[index].src = i.imageURL;
                        console.log(i+':img:'+imageArray[index].src);
                    })
                })
            } else {
                console.log("this is not uiwebview");
            }
        },
        addContents : function() {
            var _this = this;
            if(_this.display < _this.items.length){
                _this.display = _this.display + _this.offset;
            } 
        }
    },
    mounted : function() {
        this.scroll();
	},
	created : function () {
        var self = this;
        $.ajax({
            type : "GET",
            url: data_itemlist,
            ContentType : "json",
            crossDomain: true,
            xhrFields: {
                withCredentials: true
            },
            success: function(data) {
                if (data != null){
                    if ( data.grouplist.length == 0) {
                        self.items = data.itemlist[0].itemlists;
                        self.offset = 8;
                        self.display = 8;
                    } else {
                        self.items = data.itemlist;
                    }
                    self.listType = data.listType;
                    self.themebarColor = data.themebarColor;
                    self.groups = data.grouplist;
                    self.itemlength = data.itemlist.length;
                    self.isLogin = data.login;
                    self.isAdult = data.adult;
				}
            },
            error: function (xhr) {
                 console.log(xhr.responseText);
            }
        });
    },
    updated : function() {
        this.$nextTick(function() {
            // 로딩중 template 처리
            this.tempFlag = false;
            this.lastCheckDeBounce();
        });
    },
    watch : {
        display : function(val) {
            if (val > 0) {
                this.lastCheckDeBounce();
            }
        }
    }
})

// 앵커 이동 렌더링 점프
$(function() { 
    $('a[href*=#]:not([href=#])').click(function() {
        var target = $(this.hash);
        var targetSlice = this.hash.slice(6);

        var index = list.$data.groups.findIndex(function(item){
            return item.groupCode === parseInt(targetSlice);
        })

        list.$data.display = index;
        list.tabMove(target);
    });
});