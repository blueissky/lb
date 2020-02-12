package com.traffic.lb;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class BeginAction
 */
@WebServlet("/BeginAction")
public class BeginAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BeginAction() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String p1=request.getParameter("p1");//x�����ر���
		String p2=request.getParameter("p2");//y�����ر���
		String p3=request.getParameter("p3");//������
		String p4=request.getParameter("p4");//·����
		request.setAttribute("p1", p1);
		request.setAttribute("p2", p2);
		request.setAttribute("p3", p3);
		request.setAttribute("p4", p4);
		StringBuffer roadPanel=new StringBuffer();
		for(int i=1;i<=Integer.parseInt(p4);i++) {
			roadPanel.append("<label>·��"+i+"</label>");
			roadPanel.append("<label>&nbsp;("+(i-1)+"->"+i+")����</label> <input id=\"road_"+i+"_1\" type=\"text\" >");
			roadPanel.append("<label>�̲�ʱ��</label> <input id=\"road_"+i+"_2\" type=\"text\" >");
			roadPanel.append("<label>��λ��</label> <input id=\"road_"+i+"_3\" type=\"text\" value=\"0\">");
			roadPanel.append("<label>"+(i-1)+"->"+i+" ������</label> <input id=\"road_"+i+"_4\" type=\"text\" value=\"0\">");
			roadPanel.append("<label>"+(i+1)+"->"+i+" ������</label> <input id=\"road_"+i+"_5\" type=\"text\" value=\"0\"><br>");
		}
		request.setAttribute("roadPanel", roadPanel.toString());
		request.getRequestDispatcher("/lb/NewFile2.jsp").forward(request,response);
		doGet(request, response);
	}

}
