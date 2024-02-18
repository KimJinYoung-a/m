var brandApi = {
    itemListUrl: "/apps/appCom/wish/webapi/specialbrand/items.asp"
}

var specialBrandApp = new Vue({
    el: '#specialBrand',
    template: '\
    <section class="item-carousel special-brand"\
        v-if="bestItem.length > 0 && newItem.length > 0"\
    >\
        <div class="hgroup">\
            <h2 class="headline headline-speech"><span lang="en">Special Brand</span> <small>조금은 특별한 상품들</small></h2>\
            <a class="btn-more btn-arrow"\
                @click="linkTo(\'/brand/\')"\
            >더보기</a>\
        </div>\
        <div class="items type-multi-row swiper-container" id="sp_swiper"\
            v-if="newItemLoad && bestItemLoad"\
        >\
            <ul class="swiper-wrapper">\
               <main-pb-items\
                    v-for="item in mixedItemList"\
                    :col-items=item\
                    :set-mounted-state="setMountedState"\
               ></main-pb-items>\
            </ul>\
        </div>\
        <div class="btn-group">\
            <a class="btn-plus color-blue"\
                @click="linkTo(\'/brand/\')"\
            >\
                <span class="icon icon-plus icon-plus-blue"></span> 스페셜 브랜드 상품 더보기\
            </a>\
        </div>\
    </section>\
    ',
    data: function(){
        return {
            bestItem: [],
            newItem: [],
            newItemLoad: false,
            bestItemLoad: false,
            allChildrenMounted: false,
            mountedChildren: 0
        }
    },
    methods: {
        getContentsDetails: function(params){
            var _this = this;

            $.getJSON(params.url, params, function (data, status, xhr) {
                if (status == "success") {
                    for( var key in data ) {
                        _this.$data[params.listName] = data[key]
                        _this.$data[params.isLoad] = true
                    }
                } else {
                    console.log("JSON data not Loaded.");
                }
            });
        },
        linkTo: function(url){
            if(isapp == 1){
                fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], 'Special Brand', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014' + url)
            }else{
                window.location.href = url;
            }
            return false;
        },
        setMountedState: function(){
            this.mountedChildren++
        }
    },
    mounted: function(){
        // console.log('parent mounted')
    },
    created: function(){
        this.getContentsDetails({
            url: brandApi.itemListUrl,
            contentsId: 'new-item',
            listType: 'B',
            numOfItems: 5,
            listName: 'newItem',
            isLoad: 'newItemLoad'
        });
        this.getContentsDetails({
            url: brandApi.itemListUrl,
            contentsId: 'best-item',
            listType: 'A',
            numOfItems: 5,
            listName: 'bestItem',
            isLoad: 'bestItemLoad'
        });
    },
    computed: {
        mixedItemList: function(){
            var mixedItems = []
            var standardArrLen = 0
            var tmpArr = []

            standardArrLen = this.newItem.length > this.bestItem.length ? this.newItem.length : this.bestItem.length
            for (var index = 0; index < standardArrLen; index++) {
                tmpArr = []
                tmpArr.push(this.newItem[index])
                tmpArr.push(this.bestItem[index])
                mixedItems.push(tmpArr)
            }
            return mixedItems
        }
    },
    watch: {
        mountedChildren: function(){
            var itemSwiper = new Swiper("#sp_swiper", {
                slidesPerView:"auto",
                freeMode:true,
                freeModeMomentumRatio:0.5
            });
        }
    }
})

Vue.component('main-pb-items', {
    template: /*html*/`
    <li class="swiper-slide">
        <a @click="productLink(subItem.itemid)"
            v-for="subItem in colItems"
            v-if="subItem != undefined"
        >
            <div class="thumbnail">
                <img v-lazy="subItem.itemImg" alt="" />
            </div>
            <div class="desc">
                <p class="name">{{subItem.itemName}}</p>
                <b v-if="subItem.saleStr != ''"
                    :class="getSaleClasses(subItem)"
                >{{subItem.saleStr+'%'}}</b>
            </div>
        </a>
    </li>
    `,
    data: function(){
        return {
            allMounted: false
        }
    },
    methods: {
        productLink: function(itemId){
            if(isapp == 1){
                TnGotoProduct(itemId);
            }else{
                window.location.href = "/category/category_itemPrd.asp?itemid="+itemId
            }
            return false;
        },
        getSaleClasses(item) {
            const classes = ['discount'];
            if( item.saleType === 'B' || item.saleType === 'S' )
                classes.push('color-red');
            else if( item.saleType === 'C' )
                classes.push('color-green');

            return classes;
        }
    },
    props: {
        colItems: {
            type: Array,
            default: []
        },
        setMountedState: {
            type: Function,
            default: function(){
                console.log('empty')
            }
        }
    },
    mounted: function(){
        // console.log('children mounted')
        this.setMountedState();
    }
})