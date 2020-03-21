package com.group4.erp.controller;


import com.group4.erp.service.*;
import com.group4.erp.*;
import java.util.*;
import javax.servlet.http.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;



@Controller

public class InvenController {

	
	@Autowired
	private InvenService invenService;	
	
	@RequestMapping(value="/goBookList.do")
	public ModelAndView goBookInvenList(
			HttpSession session,
			InvenSearchDTO invenSearchDTO
		) {
		
		ModelAndView mav = new ModelAndView();
		//mav.setViewName("eventScheduleForm.jsp");
		mav.setViewName("main.jsp");
		mav.addObject("subMenu", "viewInventoryList");	//viewInventoryList 아무 이름이나 설정 가능. 메인 페이지에서 해당 메뉴 뜰 때 해당 페이지를 임포트하기 위해서 붙이는 플래그명
		mav.addObject("navigator", "[재고현황] → [도서정보조회]");
		try {
			
			List<Map<String, String>> branch = this.invenService.getBranch(invenSearchDTO);
			//System.out.println("controller"+branch);
			mav.addObject("branch",branch);
			
			List<Map<String, String>> publisher = this.invenService.getPublisher(invenSearchDTO);
			mav.addObject("publisher",publisher);
			
			List<Map<String, String>> size = this.invenService.getSize();
			mav.addObject("size", size);
			
			List<Map<String, String>> category = this.invenService.getCategory();
			mav.addObject("category", category);
			
			List<Map<String, String>> inventory_loc = this.invenService.getInvenLoc(invenSearchDTO);
			mav.addObject("inventory_loc", inventory_loc);
			
			int bookListCnt = this.invenService.getBookListCnt(invenSearchDTO);
			mav.addObject("bookListCnt", bookListCnt);
			
			if(bookListCnt>0) {
				//선택한 페이지 번호 구하기
				int selectPageNo = invenSearchDTO.getSelectPageNo();
				//한 화면에 보여지는 행의 개수 구하기
				int rowCntPerPage = invenSearchDTO.getRowCntPerPage();
				//검색할 시작행 번호 구하기
				int beginRowNo = (selectPageNo*rowCntPerPage-rowCntPerPage+1);
				//만약 검색한 총 개수가 검색할 시작행 번호보다 작으면 선택한페이지 번호를 1로 세팅하기
				if(bookListCnt<beginRowNo) invenSearchDTO.setSelectPageNo(1);
			}
			
			List<Map<String, String>> BookList = this.invenService.getBookList(invenSearchDTO);
			mav.addObject("BookList", BookList);
			
			
		}catch(Exception e) {
			System.out.println("<게시글 불러오기 실패>");
			System.out.println("예외발생 =>"+e);
		}
		return mav; 
	}
	

	@RequestMapping(value="/goReleaseList.do")
	public ModelAndView goBookReleaseInfo(
			HttpSession session
			,InvenSearchDTO invenSearchDTO
			) {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("main.jsp");
		mav.addObject("subMenu", "viewReleaseList");
		mav.addObject("navigator", "[재고현황] → [출고현황조회]");
		
		try {
			
			List<Map<String, String>> publisher = this.invenService.getPublisher(invenSearchDTO);
			mav.addObject("publisher",publisher);
			
			List<Map<String, String>> inventory_loc = this.invenService.getInvenLoc(invenSearchDTO);
			mav.addObject("inventory_loc", inventory_loc);
			
			int releaseListCnt = this.invenService.getReleaseListCnt(invenSearchDTO);
			mav.addObject("releaseListCnt", releaseListCnt);
			
			if(releaseListCnt>0) {
				//선택한 페이지 번호 구하기
				int selectPageNo = invenSearchDTO.getSelectPageNo();
				//한 화면에 보여지는 행의 개수 구하기
				int rowCntPerPage = invenSearchDTO.getRowCntPerPage();
				//검색할 시작행 번호 구하기
				int beginRowNo = (selectPageNo*rowCntPerPage-rowCntPerPage+1);
				//만약 검색한 총 개수가 검색할 시작행 번호보다 작으면 선택한페이지 번호를 1로 세팅하기
				if(releaseListCnt<beginRowNo) invenSearchDTO.setSelectPageNo(1);
			}
			
			List<Map<String, String>> releaseList = this.invenService.getReleaseList(invenSearchDTO);
			mav.addObject("releaseList", releaseList);
		}catch(Exception e) {
			System.out.println("<출고형황 불러오기 실패>");
			System.out.println("예외발생 =>"+e);
		}
		
		return mav;
	}
	
	@RequestMapping(value="/goReleaseContentForm.do")
	@ResponseBody
	public Cus_releaseInfoDTO goReleaseContentForm(
			@RequestParam(value="all_order_no") int all_order_no
			,Cus_releaseInfoDTO cus_releaseInfoDTO
			) {
		
		//ModelAndView mav = new ModelAndView();
		//mav.setViewName("main.jsp");
		//mav.addObject("subMenu", "viewReleaseContent");
		//mav.addObject("navigator", "[재고현황]-[출고현황조회]-[상세보기]");
		
		String orderSize = all_order_no+"";
		Cus_releaseInfoDTO all_order = null;
		String cus = "cus";
		String corp = "corp";
		try {
			
			if(orderSize.length()==10) {
				Cus_releaseInfoDTO cus_order = this.invenService.getReleaseCusInfo(all_order_no);
				cus_order.setCheck_order_num(cus);
				all_order = cus_order;
				//mav.addObject("cus_order", cus_order);
			}else {
				Cus_releaseInfoDTO corp_order = this.invenService.getReleaseCorpInfo(all_order_no);
				corp_order.setCheck_order_num(corp);
				
				all_order = corp_order;
				//mav.addObject("corp_order", corp_order);
			}
			
			//mav.addObject("orderSize", orderSize);
		}catch(Exception e) {
			System.out.println("<출고 상세 정보 불러오기 실패>");
			System.out.println("예외발생 =>"+e);
		}
		
		
		return all_order;
	}
		

	@RequestMapping(value="/goReturnOrderList.do")
	public ModelAndView goReturnOrderList(HttpSession session, ReturnSearchDTO returnSearchDTO) {
		
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("main.jsp");
		mav.addObject("subMenu", "viewReturnOrderList");
		mav.addObject("navigator", "[재고현황] → [반품현황조회]");
		
		try {
			int returnOrderCnt = this.invenService.getReturnOrderCnt(returnSearchDTO);
			List<ReturnOrderDTO> returnOrderList = this.invenService.getReturnOrderList(returnSearchDTO);
			
			mav.addObject("returnOrderCnt", returnOrderCnt);
			mav.addObject("returnOrderList", returnOrderList);
			
		} catch(Exception e) {
			System.out.println("예외발생"+e);
		}
		return mav;
	}
	
	@RequestMapping(value="/goReturnOrderContent.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8")
	@ResponseBody
	public ReturnSalseContentDTO goReturnOrderInfo(
			@RequestParam(value="pk_no") int return_sales_no
			,ReturnSalseContentDTO returnContentDTO
			) {
		
		ReturnSalseContentDTO returnInfo = null;
		
		try {
			
			returnInfo = this.invenService.getReturnContent(return_sales_no);
			
		} catch(Exception e) {
			System.out.println("<반품 상세 정보 불러오기 실패>");
			System.out.println("예외발생 => "+e);
		}
		return returnInfo;
	}
	
	@RequestMapping(value="/viewSignUpBook.do")
	public ModelAndView viewSignUpBook() {
		
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("main.jsp");
		mav.addObject("subMenu", "viewSignUpBook");
		mav.addObject("navigator", "[재고현황] → [도서정보조회] → [도서등록]");
		
		List<Map<String, String>> size = this.invenService.getSize();
		mav.addObject("size", size);
		
		List<Map<String, String>> category = this.invenService.getCategory();
		mav.addObject("category", category);

		return mav;
	}
	
	@RequestMapping(value="/goSignUpBookProc.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8")
	@ResponseBody
	public int goSignUpBook(
			InvenDTO invenDTO
			) {
		
		int insertSignUpBookCnt = 0;
		try {
			
			insertSignUpBookCnt = this.invenService.getSignUpCnt(invenDTO);

			
		}catch(Exception e) {
			System.out.println("<책 등록 실패>");
			System.out.println("예외 발생=>"+e);
			insertSignUpBookCnt = -1;
		}
		
		return insertSignUpBookCnt;
	}
	
	@RequestMapping(value="/viewBookContentForm.do")
	public ModelAndView viewBookContentForm(
			@RequestParam(value="isbn13_search") String isbn13_search
			,BookInfoDTO bookInfoDTO
			,InvenSearchDTO invenSearchDTO
			) {
		
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("main.jsp");
		mav.addObject("subMenu", "viewBookContentForm");
		mav.addObject("navigator", "[재고현황] → [도서정보조회] → [상세정보]");
		
		//System.out.println(isbn13_search);
		
		try {
			
			BookInfoDTO bookInfo = this.invenService.getBookInfo(isbn13_search);
			
			String bookprice = bookInfo.getBook_price().trim();
			bookprice = bookprice.replace(",", "");
			bookInfo.setBook_price(bookprice);
			
			mav.addObject("bookInfo", bookInfo);
			
			List<Map<String, String>> inventory_loc = this.invenService.getInvenLoc(invenSearchDTO);
			mav.addObject("inventory_loc", inventory_loc);
			
		}catch(Exception e) {
			System.out.println("<서적 상세정보 불러오기 실패>");
			System.out.println("에러 발생=>"+e);
		}
		
		return mav;
	}
	
	@RequestMapping(value="/goBookInfoUpProc.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8")
	@ResponseBody
	public int goBookInfoUpProc(
			BookInfoDTO bookInfoDTO
			) {
		
		int bookInfoUpCnt = 0;
		
		try {
			
			bookInfoUpCnt = this.invenService.getBookInfoUpCnt(bookInfoDTO);
			
		}catch(Exception e) {
			System.out.println("<책 정보 수정 실패>");
			System.out.println("예외 발생 =>" + e);
		}
		
		return bookInfoUpCnt;
	}
	
	
	@RequestMapping(value="/goReleaseUp.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8")
	@ResponseBody
	public int goReleaseUp(
			@RequestParam(value="all_order_no") String all_order_no
			) {
		
		int releaseUpCnt = 0;
		int isbn_cnt = 0;
		int order_cnt = 0;
		
		try {
			
			order_cnt = this.invenService.getOrderCnt(all_order_no);
			
			isbn_cnt = this.invenService.getIsbnCnt(all_order_no);
			
			if(isbn_cnt>order_cnt) {
				
				releaseUpCnt = this.invenService.getReleaseUpCnt(all_order_no);
				
			}else{
				
				return releaseUpCnt = -1;
				
			}
			
		}catch(Exception e) {
			System.out.println("<출고 날짜 등록 실패>");
			System.out.println("예외 발생=>"+e);
			releaseUpCnt = -2;
		}
		
		return releaseUpCnt;
	}
}

  