Vue.component('pb-contents-container', {
    template: '\
    <section \
        :class = contentsId \
        :id = contentsId>\
        <div class="item-nav">\
            <ul>                \
                <li\
                    v-for="menu in menuArr"\
                    :class="[menu.contentsId === contentsId ? \'on\' : \'\']"\
                    v-if="menu.disp"\
                ><a :href="dispContentsId(menu.contentsId)">{{menu.menuName}}</a></li>\
            </ul>\
        </div>\
        <component v-bind:is="componentName"\
            :component-data=contentsData\
        ></component>\
    </section>\
    ',
    props: {
        contentsId: {
            type: String,
            default: ''
        },
        contentsData: {
            type: Array,
            default: []
        },
        menuArr: {            
            type: Array,
            default: []
        }
    },
    methods: {
        dispContentsId: function(id){
            return "#" + id
        }
    },
    computed: {
        componentName: function(){
            var componentN = ""
            switch (this.contentsId) {
                case 'pb-evt':
                    componentN = "pb-event-list"
                    break;
                case 'new-item':
                case 'now-item':
                case 'best-item':
                    componentN = "pb-items"
                    break;
                case 'pb-review':
                    componentN = "pb-reviews"
                    break;
                default:
                    break;
            }

            return componentN
        }
    }
})