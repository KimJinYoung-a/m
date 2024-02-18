Vue.component('Search-Result-Empty',{
    template : '\
                <!-- 검색 결과 없음 -->\
                <div class="no_data">\
                    <figure style="display:inline-flex; align-items:center; justify-content:center; width:8.53rem; height:8.53rem; background-color:purple; color:white;">(미정)</figure>\
                    <p>\
                        <strong>아쉽게도 검색결과가 없어요</strong>\
                        상품이 품절되었을 경우 검색이 지원되지<br/>않을 수 있으니 참고해주세요 :)\
                    </p>\
                    <button class="btn_type2 btn_blk">돌아가기<i class="i_refresh2"></i></button>\
                </div>\
                <!-- 키워드 퀵링크 -->\
                <div class="kwd_quick">\
                    <figure><img src="http://webimage.10x10.co.kr/search/quick/201811/20181113170630_0e303.jpg" alt=""></figure>\
                    <a href="">\
                        <span class="kwd_info ellipsis2" style="color:#111;">키워드퀵링크키워드퀵링크키워드퀵링크키워드퀵링크</span>\
                    </a>\
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