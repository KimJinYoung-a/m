Vue.component('Search-Result-Bar',{
    template : '\
                <!-- 검색바 -->\
                <div class="srchbar_wrap">\
                    <div class="srchbar input_txt">\
                        <input type="search" title="검색어 입력" placeholder="검색어를 입력해주세요" class="srch_input" style="display:none;">\
                        <div class="kwd_list">\
                            <div class="kwd_inner">\
                                <span>스누핑<button class="btn_del"><i class="i_close"></i></button></span>\
                                <span>우드스탁<button class="btn_del"><i class="i_close"></i></button></span>\
                                <span>친구들<button class="btn_del"><i class="i_close"></i></button></span>\
                                <span>절친들<button class="btn_del"><i class="i_close"></i></button></span>\
                            </div>\
                        </div>\
                        <button class="btn_add_kwd">이 안에서 검색</button>\
                        <p class="bbl_ten bbl_t">혹시, <em>스누피 snoopy</em> 찾으셨나요?</p>\
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