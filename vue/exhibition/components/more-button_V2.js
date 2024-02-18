Vue.component('more-button',{
    template : '<button @click="moreShow" v-show="isShow" class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/btn_more.png" alt="제품 더 보기"></button>',
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
            default : 'SET_PARTITIONLIMITCOUNT'
        },
        moveButtonText : {
            type : String,
            default : '더보기'
        }
    },
    computed : {
        moreButtonText : function() {
            return this.moveButtonText;
        }
    },
    methods : {
        moreShow : function() {
            console.log(this.index, this.itemShowLimitCount);
            
            /* 어버이날 어린이날 스왑*/
            if(this.index == 1){
                this.$store.commit(this.itemType, { index : 2 , itemShowLimitCount : this.itemShowLimitCount });
            }else if(this.index == 2){
                this.$store.commit(this.itemType, { index : 1 , itemShowLimitCount : this.itemShowLimitCount });
            }else{
                this.$store.commit(this.itemType, { index : this.index , itemShowLimitCount : this.itemShowLimitCount });
            }

            this.isShow = false;
        }
    }
})