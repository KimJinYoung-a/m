Vue.component('wish-evaluate',{
    template : '\
                <div class="etc">\
                    <div class="tag review" v-if="evalCount > 0">\
                        <span class="icon icon-rating"><i v-bind:style="{width : totalPoint +\'%\'}">리뷰 종합 별점 {{totalPoint}}점</i></span><span class="counting" title="리뷰 개수">{{evalCount}}</span>\
                    </div>\
                    <div class="tag wish">\
                        <span class="icon icon-wish"><i v-bind:class="classObject"> wish</i></span><span class="counting" title="위시 개수">{{wishCount}}</span>\
                    </div>\
                </div>\
    ',
    props: {
        evalCount: {
            type: Number,
            default: 0
        },
        favCount : {
            type : Number,
            default : 0
        },
        totalPoint : {
            type : Number,
            default : 0
        },
    },
    computed : {
        classObject : function() {
            return {
                hidden : this.favCount > 0
            }
        },
        wishCount : function() {
            return this.favCount > 999 ? "999+" : this.favCount == 0 ? "" : this.favCount ;
        }
    }
})