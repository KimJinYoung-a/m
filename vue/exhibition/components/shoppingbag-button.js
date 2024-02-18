Vue.component('ShoppingBag',{
    template : '<button class="btn-cart" v-on:click.stop="addShoppingBag">장바구니</button>\
    ',
    props : {
        itemId : {
            type : Number,
            default : 0,
        },
        optionCount : {
            type : Number,
            default : 0,
        },
        isApp : {
            type : Boolean,
            default : false,
        },
    },
    methods : {
        addShoppingBag : function() {
            if (this.itemId == 0) {
                return false;
            }

            if (this.optionCount > 0) {
                this.$store.commit('CLEAR_TEMPITEMID');
                this.$store.commit('SET_TEMPITEMID', this.itemId);

                $("#optionBoxV18").show();
            } else {
                let frm = document.sbagfrm;
                    frm.mode.value = "add";
                    frm.itemid.value = this.itemId;
                    frm.action = "/inipay/shoppingbag_process.asp?tp=pop";
                    frm.target = "iiBagWin";
                    frm.submit();
            }
       }
    }
})