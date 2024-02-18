Vue.component('Search-Result-RelationKeyword',{
    template : '\
                <!-- 연관 검색어 -->\
                <div class="kwd_swiper swiper-container">\
                    <div class="swiper-wrapper">\
                        <div class="swiper-slide"><a href="">스누피</a></div>\
                        <div class="swiper-slide"><a href="">우드스탁</a></div>\
                        <div class="swiper-slide"><a href="">피넛츠</a></div>\
                        <div class="swiper-slide"><a href="">스누피친구들</a></div>\
                        <div class="swiper-slide"><a href="">찰찰리브라운</a></div>\
                        <div class="swiper-slide"><a href="">peanuts</a></div>\
                        <div class="swiper-slide"><a href="">snoopy</a></div>\
                    </div>\
                </div>\
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
        /*
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
       */
    }
})