Vue.component('SearchBar',{
    template : '\
                <!-- 검색 진입 -->\
                <section class="srch_top">\
                    <!-- 검색바 -->\
                    <div class="srchbar_wrap">\
                        <div class="srchbar input_txt">\
                            <input type="search" title="검색어 입력" placeholder="검색어를 입력해주세요" class="srch_input">\
                        </div>\
                    </div>\
                </section>\    
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