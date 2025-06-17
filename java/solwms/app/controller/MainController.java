package solwms.app.controller;


import java.security.Principal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import solwms.app.dto.NoticeDto;
import solwms.app.dto.ProductDto;
import solwms.app.dto.ReturnDto;
import solwms.app.dto.SuggDto;
import solwms.app.service.NoticeService;
import solwms.app.service.ProductService;
import solwms.app.service.SolwmsService;
import solwms.app.service.SuggService;

@Controller
public class MainController {

	@Autowired
	private ProductService productservice;

	@Autowired
	private NoticeService noticeService;

	@Autowired
	private SuggService suggestionService;
	


	@GetMapping("/adminMain")
	public String getInventory(Model model) {
		List<ProductDto> inventoryList = productservice.getUserInventory();
		System.out.print(inventoryList);
	    model.addAttribute("inventoryList", inventoryList); // 데이터 전달

		List<NoticeDto> topNotices = noticeService.getTopNotice();
		model.addAttribute("topNotices", topNotices);

		List<SuggDto> topSuggestion = suggestionService.getTopSuggestion();
		model.addAttribute("topSuggestion", topSuggestion);

		return "adminMain/main"; // JSP 경로를 반환
	}

	@GetMapping("/")
	public String redirectToJSP(Model model, Principal principal) {
		if (principal != null) {
			String role = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();

			if (role.equals("ROLE_USER")) {
				return "redirect:http://localhost:5173";
			} else if (role.equals("ROLE_ADMIN")) {
				return "redirect:/adminMain";
			}
		}
		return "/login";
	}

	//공지사항
	@GetMapping("/adminMain/Announcement")
	public String announPage(Model model) {
		List<NoticeDto> noticeList = noticeService.getAllNotices();
	       model.addAttribute("noticeList", noticeList);
	       return "adminMain/Announcement";
	}


	/* 공지사항 추가 */
	@GetMapping("/adminMain/addAnnounce")
	public String addNoticePage() {
		return "adminMain/addAnnounce";
	}

	/* 건의사항 */
	@GetMapping("/adminMain/Suggestion")
	public String suggestionPage(Model model) {
		List<SuggDto> suggestionList = suggestionService.getAllSuggestions();
		model.addAttribute("suggestionList", suggestionList);
		return "adminMain/Suggestion";
	}

	@GetMapping("/hidden")
	public String hidden(){return "crazy";}





}

