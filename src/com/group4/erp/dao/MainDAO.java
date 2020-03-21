package com.group4.erp.dao;

import java.util.List;
import java.util.Map;

import com.group4.erp.CommonChartDTO;

public interface MainDAO {

	List<Map<String, String>> getMonthEvnt();
	CommonChartDTO getOrderStat();
	CommonChartDTO getReturnStat();
	List<Map<String, String>> getBestSellers();
	List<CommonChartDTO> getSellingStat();
	List<CommonChartDTO> getEventStat();
	List<CommonChartDTO> getGenderStat();
	List<CommonChartDTO> getAgeStat();

}
