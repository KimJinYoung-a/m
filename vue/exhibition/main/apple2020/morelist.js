var app = new Vue({
    el: '#app',
    store : store ,
    template: '\
                <div id="content" class="content apple-store" style="padding-bottom:0;">\
                    <div id="subNav" class="navigation-sub">\
                        <ul>\
                            <li v-show="category == 10 || category == 11" class="ipad"><input type="radio" id="cate1" name="category" checked v-model="category" value="10"><label for="cate1">iPad</label></li>\
                            <li v-show="category == 10 || category == 11" class="ipad-acc"><input type="radio" id="cate1a" name="category" v-model="category" value="11"><label for="cate1a">액세서리</label></li>\
                            <li v-show="category == 20 || category == 21" class="macbook"><input type="radio" id="cate2" name="category" v-model="category" value="20"><label for="cate2">Macbook</label></li>\
                            <li v-show="category == 20 || category == 21" class="macbook-acc"><input type="radio" id="cate2a" name="category" v-model="category" value="21"><label for="cate2a">액세서리</label></li>\
                            <li v-show="category == 50 || category == 51" class="iphone"><input type="radio" id="cate3" name="category" v-model="category" value="50"><label for="cate3">iPhone</label></li>\
                            <li v-show="category == 50 || category == 51" class="iphone-acc"><input type="radio" id="cate3a" name="category" v-model="category" value="51"><label for="cate3a">액세서리</label></li>\
                            <li v-show="category == 40 || category == 41" class="imac"><input type="radio" id="cate4" name="category" v-model="category" value="40"><label for="cate4">iMac</label></li>\
                            <li v-show="category == 40 || category == 41" class="imac-acc"><input type="radio" id="cate4a" name="category" v-model="category" value="41"><label for="cate4a">액세서리</label></li>\
                            <li v-show="category == 30 || category == 31" class="airpods"><input type="radio" id="cate5" name="category" v-model="category" value="30"><label for="cate5">AirPods</label></li>\
                            <li v-show="category == 30 || category == 31" class="airpods-acc"><input type="radio" id="cate5a" name="category" v-model="category" value="31"><label for="cate5a">액세서리</label></li>\
                            <li v-show="category == 60 || category == 61" class="watch"><input type="radio" id="cate6" name="category" v-model="category" value="60"><label for="cate6">Watch</label></li>\
                            <li v-show="category == 60 || category == 61" class="watch-acc"><input type="radio" id="cate6a" name="category" v-model="category" value="61"><label for="cate6a">액세서리</label></li>\
                        </ul>\
                    </div>\
                    <div class="items-list-wrap">\
                        <div class="items-list" style="padding-bottom:0;">\
                            <ul>\
                                <item-list\
                                    v-for="(item,index) in itemLists"\
                                    :key="index"\
                                    :index="index"\
                                    :itemid="item.itemid"\
                                    :brandname="item.brandname"\
                                    :itemname="item.itemname"\
                                    :addText1="item.addText1"\
                                    :addText2="item.addText2"\
                                    :itemimage="item.itemimage"\
                                    :sellCash="item.sellCash"\
                                    :totalprice="item.totalprice"\
                                    :saleperstring="item.saleperstring"\
                                    :couponperstring="item.couponperstring"\
                                    :optionCount="item.optionCount"\
                                    :amplitudeActionName="amplitudeActionName"\
                                    :isApp="isApp"\
                                    :evalCount="item.evalCount"\
                                    :favCount="item.favCount"\
                                    :totalPoint="item.totalPoint"\
                                >\
                                </item-list>\
                            </ul>\
                        </div>\
                    </div>\
                    <div class="alertBoxV17a" style="display:none;" id="alertBoxV17a">\
                        <div>\
                            <p class="alertCart" id="sbaglayerx" style="display:none;"><span>장바구니에 상품이 담겼습니다.</span></p>\
                            <p id="sbaglayero" style="display:none"><span>장바구니에 이미 같은 상품이 있습니다.</span></p >\
                            <button type="button" class="btn btn-small btn-red btn-icon btn-radius" @click="gotoMyCart">장바구니 가기<span class="icon icon-arrow"></span></button>\
                        </div>\
                    </div>\
                    <div class="alertBoxV17a optionBoxV18" style="display:none" id="optionBoxV18">\
                        <div>\
                            <p><span>크기, 색상, 종류등과 같은<br/>다양한 옵션이 있는 상품입니다</span></p>\
                            <p class="btn-group">\
                                <button type="button" class="btn btn-small btn-line-white btn-radius" @click="gotoProductDetail(\'x\');return false;">쇼핑 계속하기</button>\
                                <button type="button" class="btn btn-small btn-red btn-radius" @click="gotoProductDetail(\'o\');return false;">옵션 선택</button>\
                            </p>\
                        </div>\
                    </div>\
                </div>\
    ',
    data : function() {
        return {
            amplitudeActionName : "click_apple_",
            isApp : isApp,
            categoryId : categoryId,
        }
    },
    methods: {
        gotoMyCart : function() {
            this.isApp ? fnAPPpopupBaguni() : function() {
                location.href='/inipay/ShoppingBag.asp';
            }()
        },
        gotoProductDetail : function(v) {
            if (v == "o") {
                this.isApp ? fnAPPpopupProduct(this.$store.state.tempItemId) : function(itemId) {
                    var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemId +"&flag=e";
                    location.href = itemUrl;
                }(this.$store.state.tempItemId)
            }

            $("#optionBoxV18").hide();
        },
    },
    computed: {
        itemLists : function() {
            return this.$store.state.itemLists;
        },
        category : {
            get : function() {
                return this.$store.state.params.category;
            },
            set : function(value) {
                this.$store.commit('SET_CATEGORY', value);
                this.$store.commit('CLEAR_ITEMLISTS');
                this.$store.dispatch('GET_ITEMLISTS');
            }
        },
    },
    created : function() {
        // Init
        this.$store.commit('SET_MASTERCODE', '11');
        this.$store.commit('SET_CATEGORY', categoryId);
        this.$store.dispatch('GET_ITEMLISTS');
    },
    mounted : function() {
        this.$nextTick(function() {
			setTimeout(function() {
                window.onscroll = function() {stickyHeader()};
                var header = document.getElementById("subNav");
                var sticky = header.offsetTop;
                function stickyHeader() {
                    if (window.pageYOffset > sticky) {
                        header.classList.add("sticky");
                    } else {
                        header.classList.remove("sticky");
                    }
                }
			},50);
		});
    }
})
