package kr.co.seoulit.logistics.busisvc.sales.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class ReturnInfoTO extends BaseTO {

    private String deliveryNo;
    private String deliveryDate;
    private String customerName;
    private String itemName;
    private String returnUnit;
    private String returnUnitPrice;
    private String returnSumPrice;

}
