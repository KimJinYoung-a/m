Vue.component('wish-list',{
    props : {
        item : {
            type : Object,
            default : {},
        },
        isApp : {
            type : [Number, String],
            default : ''
       },
    },
    template : '\
                <li>\
                    <a @click="itemUrl(isApp , item.itemid)">\
                        <div class="thumbnail"><img :src="item.basicimage" alt=""></div>\
                        <div class="desc">\
                            <div class="name">[{{item.brandname}}]  {{item.itemname}}</div>\
                            <div class="price">{{item.totalprice}}\
                                <span class="unit">원</span>\
                                <span class="sale" v-if="item.saleyn == \'Y\'">{{item.totalsaleper}}</span>\
                            </div>\
                            <button class="btn-bag" @click.stop="addCart(isApp, item.itemid , item.itemoptioncount)">장바구니 담기</button>\
                        </div>\
                    </a>\
                </li>\
                ',
    methods : {
        itemUrl : function(isApp, itemid) {
            if (isApp ==1 ) {
                fnAPPpopupProduct(itemid);
            } else {
                var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemid +"&flag=e";
                location.href = itemUrl;
            }
        },
        addCart : function(isApp, itemid , itemoptioncount) {

            var addCart = function(arg) {
                var frm = document.sbagfrm;
                frm.mode.value = "add";
                frm.itemid.value = arg;
                frm.action = "/inipay/shoppingbag_process.asp?tp=pop";
                frm.target = "iiBagWin";
                frm.submit()

                alert('장바구니에 상품이 담겼습니다.');
                getCartTotalAmount()
            }

            var notice = function(isApp, itemid) {
                var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemid +"&flag=e";

                alert('옵션이 있는 상품입니다.\n상품페이지로 이동 합니다.');

                return (isApp == 1) ? fnAPPpopupProduct(itemid) : location.href = itemUrl;
            }

            return (itemoptioncount > 0) ? notice(isApp, itemid) : addCart(itemid);
        }
    }

})