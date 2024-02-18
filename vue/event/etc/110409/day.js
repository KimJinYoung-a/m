Vue.component('Day', {
    template : `
        <div :class="this_class" :data-point="mileage_amount + 'p'">
            <p>{{date}}</p>
            <strong>{{mileage_amount}}p</strong>
        </div>
    `,
    props: {
        date : {type:String, default:''}, // 일자
        status : {type:String, default:'W'}, // 현재상태(R:지급받음, F:실패, W:지급대기)
        mileage_amount : {type:Number, default:0}, // 마일리지 금액
    },
    computed: {
        this_class() {
            return ['daily', {done: this.status === 'R'}, {pass: this.status === 'F'}];
        }
    }
});