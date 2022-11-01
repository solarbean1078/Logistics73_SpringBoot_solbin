package kr.co.seoulit.logistics.busisvc.sales.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class CustomerReportTO extends BaseTO {
    private String contractDate; // 수주일자
    private String contractNo; // 수주일련번호
    private String customerName;// 거래처명
    private String deliveryDate; // 납품날짜
    private String sumPrice; // 매출액
    private String netIncome; // 순수익
}
