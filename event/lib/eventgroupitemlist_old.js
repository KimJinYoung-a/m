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
    props: ['items', 'groups', 'wrapper', 'isapp', 'barcolor', 'ltype'],
    template : '<div>\
                    <slot v-if="wrapper && groups.length > 1"><group-list :grouplists="groups" :getGroupName="getGroupName"></group-list></slot>\
                    <div v-if="items" :id="getGroupCode(items.groupCode)" class="items-list" >\
                        <h3 class="groupBar" v-if="wrapper && groups.length > 1 && items.itemlists.length > 0">\
                            <span v-if="barcolor" :style="themeColor(barcolor)"></span>\
                            <span v-else clsss="defalut"></span>\
                            <b>{{items.groupName}}</b>\
                        </h3>\
                        <div class="items" :class="listType(ltype)">\
                            <ul>\
                                <slot v-for="item in items.itemlists"><item-list :items="item" :isapp="isapp"></item-list></slot>\
                            </ul>\
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
        },
        listType : function(obj) {
            return obj;
        },
        themeColor : function(obj) {
            return  "background-color:"+obj
        }
    }
})

// 그룹 리스트 case : 6 , etc
Vue.component('nogroup-itemlist',{
    props: ['items', 'isapp', 'ltype'],
    template : '<div class="items-list">\
                    <div class="items" :class="listType(ltype)">\
                        <ul>\
                            <slot><item-list v-for="item in items" :items="item" :isapp="isapp"></item-list></slot>\
                        </ul>\
                    </div>\
                </div>\
                ',
    methods : {
        listType : function(obj) {
            return obj;
        },
    }
})

// select 영역
Vue.component('group-list',{
    props: ['grouplists', 'getGroupName'],
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
	props: ['groupinfo','index'],
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
    props: ['items', 'isapp'],
    template : '<li :class="addClassName(items.addClass)" @click="isAdultCheck(isapp,items.isAdult,items.itemID,items.logparam,items.isLogin)">\
                    <a @click="linkUrl(items,isapp)">\
                        <span v-if="items.isDeal" class="deal-badge">텐텐<i>DEAL</i></span>\
                        <span v-if="items.isDirectPurchase" class="abroad-badge">해외직구</span>\
                        <div class="thumbnail" v-if="uiwebview">\
                            <img :src="items.imageURL" alt="">\
                            <div v-if="items.isAdult" class="adult-hide"><p>19세 이상만 <br />구매 가능한 상품입니다</p></div>\
			                <b v-if="items.isSoldOut" class="soldout">일시 품절</b>\
                        </div>\
                        <div class="thumbnail" v-else>\
                            <img v-lazy="items.imageURL" alt="">\
                            <div v-if="items.isAdult" class="adult-hide"><p>19세 이상만 <br />구매 가능한 상품입니다</p></div>\
			                <b v-if="items.isSoldOut" class="soldout">일시 품절</b>\
                        </div>\
                        <div class="desc">\
                            <span class="brand">{{items.brandName}}</span>\
                            <p class="name">{{items.itemName}}</p>\
                            <div class="price">\
                                <div class="unit">\
                                    <b class="sum">{{items.price}}<span class="won">{{items.priceType}}</span></b>\
                                    <b v-if="items.salePer" class="discount color-red">{{items.salePer}}</b>\
                                    <b v-if="items.couponType" class="discount color-green">{{items.couponType}}<small>쿠폰</small></b>\
                                </div>\
                            </div>\
                        </div>\
                    </a>\
                    <div class="etc" v-if="!items.isDeal">\
                        <div v-if="items.reviewCount > 0" class="tag review"><span class="icon icon-rating"><i :style="reviewAVG(items.evalPoint)">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수">{{showCount(items.reviewCount)}}</span></div>\
                        <button class="tag wish btn-wish">\
                            <div v-if="items.wishCount > 0" ><span class="icon icon-wish"><i class="hidden"> wish</i></span><span class="counting">{{showCount(items.wishCount)}}</span></div>\
                            <div v-else><span class="icon icon-wish"><i> wish</i></span><span class="counting"></span></div>\
                        </button>\
                        <div v-if="items.freeShipping" class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>\
                    </div>\
                </li>\
                ',
    computed : {
        uiwebview : function(){
            return (list.isAppCheck() && list.iosCheck()) ? true : false;
        }
    },
    methods : {
        addClassName : function(obj) {
            return obj;
        },
        isAdultCheck : function(isApp,isAdult,itemID,logparam,isLogin) {
            var itemUrl;
            if (isApp == 1) {
                itemUrl = window.location.pathname + window.location.search + "&adtprdid="+ itemID + logparam;
                (isAdult) ? confirmAdultAuth(itemUrl,isLogin) : "";
            } else {
                itemUrl = "/category/category_itemPrd.asp?itemid="+ itemID + logparam;
                (isAdult) ? confirmAdultAuth(itemUrl) : "";
            }
        },
        reviewAVG : function(obj) {
            return "width:"+obj+"%";
        },
        showCount : function(obj){
            return obj == "999" ? "999+" : obj;
        },
        linkUrl : function(obj,isApp){
            var amplitudeProperties = obj.amplitude_eventkind+'|'+obj.amplitude_eventcode+'|'+obj.amplitude_eventtype+'|'+obj.amplitude_categoryname+'|'+obj.amplitude_brandname+'|'+obj.itemID+'|'+obj.amplitude_groupnumber+'|'+obj.amplitude_itemindex+'|'+obj.amplitude_listtype;
            
            // amplitude
            fnAmplitudeEventMultiPropertiesAction('click_event_item','eventkind|eventcode|eventtype|categoryname|brand_id|itemid|group_number|item_index|list_type',amplitudeProperties);

            if (isApp == 1) {
                (obj.isDeal) ? fnAPPpopupDealProduct(obj.itemID+obj.addparam) : fnAPPpopupProduct(obj.itemID+obj.addparam);
            } else {
                var itemurl = (obj.isDeal) ? "/deal/deal.asp?itemid="+obj.itemID+obj.logparam+"&flag=e"+obj.addparam : "/category/category_itemPrd.asp?itemid="+obj.itemID+obj.logparam+"&flag=e"+obj.addparam;
                location.href = itemurl;
            }
        },
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
		$.getJSON(data_itemlist, function (data, status, xhr) {
			if (status == 'success') {
				if (data != null)
				{
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
				}
			} else {
				console.log('JSON data not Loaded.');
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
            return item.groupCode === targetSlice;
        })

        list.$data.display = index;
        list.tabMove(target);
    });
});
