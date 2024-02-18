Vue.component('more-button',{
    template : '<button @click="moreShow" v-show="isShow" class="btn-more">{{moreButtonText}}<span class="btn-icon"></span></button>',
    data : function() {
        return {
            isShow : true,
        }
    },
    props : {
        index : {
            type : Number,
            default : 0
        },
        itemShowLimitCount : {
            type : Number,
            default : 0
        },
        itemType : {
            type : String,
            default : 'SET_LIMITCOUNT'
        },
        moveButtonText : {
            type : String,
            default : '더보기'
        },
    },
    computed : {
        moreButtonText : function() {
            return this.moveButtonText;
        }
    },
    methods : {
        moreShow : function() {
            this.$store.commit(this.itemType, { index : this.index , itemShowLimitCount : this.itemShowLimitCount });
            this.isShow = false;
        }
    }
})