package kr.co.seoulit.logistics.busisvc.sales.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.seoulit.logistics.busisvc.sales.to.*;
import org.apache.ibatis.annotations.Mapper;

import org.apache.ibatis.annotations.Param;

@Mapper
public interface DeliveryMapper {

    public ArrayList<DeliveryInfoTO> selectDeliveryInfoList();

    public void deliver(HashMap<String, Object> map);

    public void insertDeliveryResult(DeliveryInfoTO TO);

    public void updateDeliveryResult(DeliveryInfoTO TO);

    public void deleteDeliveryResult(DeliveryInfoTO TO);

    public ArrayList<QuarterTO> selectSalesChart();

    public ArrayList<SalesStatusTO> selectSalesStatus(@Param("start") String startDate, @Param("end")  String endDate);

    public void deleteCustomerList();

    public void insertCustomerList(CustomerReportTO customerReportTO);

    public ArrayList<ReturnInfoTO> selectReturnInfoList(@Param("start") String startDate, @Param("end")  String endDate);

}