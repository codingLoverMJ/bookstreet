package com.group4.erp.service;

import java.util.List;
import java.util.Map;

import com.group4.erp.CommonChartDTO;
import com.group4.erp.MainChartsDTO;

public interface MainService {

	List<Map<String, String>> getMonthEvnt();
	CommonChartDTO getOrderStat();
	CommonChartDTO getReturnStat();
	List<Map<String, String>> getBestSellers();
	MainChartsDTO getMainCharts();

}
