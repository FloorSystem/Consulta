package ja_jdbc_plpgsql.servlet;

import ja_jdbc_plpgsql.bean.bConsulta;
import ja_jdbc_plpgsql.jdbc.jConsultaWeb;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author psantos
 */
public class listaProdData extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        ArrayList<bConsulta> abObj = new ArrayList<bConsulta>();
        String acao = request.getParameter("acao");

        try {

            if (acao.equals("fun")) {
                abObj = jConsultaWeb.getListaProdData(request.getParameter("data_in"), request.getParameter("gmp"));
                for (bConsulta b : abObj) {
                    out.println(b.getCod_prod() + "|" + b.getCod_prod() + " " + b.getStr_prod() + "|");
                }
            } else if (acao.equals("fun2")) {
                abObj = jConsultaWeb.getListaProdData(request.getParameter("data_in"), request.getParameter("gmp"));
                for (bConsulta b : abObj) {
                    out.println("<option value='" + b.getCod_prod() + "'>" + b.getCod_prod() + " " +b.getStr_prod() + "</option>");
                }
                out.println("<option value='' selected=true>Todos</option>");
            }else if (acao.equals("fun3")) {
                abObj = jConsultaWeb.getListaProdData3(request.getParameter("data_in"),request.getParameter("data_fim"), request.getParameter("gmp"));
                for (bConsulta b : abObj) {
                    out.println("<option value='" + b.getCod_prod() + "'>" + b.getCod_prod() + " " +b.getStr_prod() + "</option>");
                }
                out.println("<option value='' selected=true>Todos</option>");
            } else if (acao.equals("def")) {
                abObj = jConsultaWeb.getListaProdDataDef(request.getParameter("data_in"));
                for (bConsulta b : abObj) {
                    out.println(b.getCod_prod() + "|" + b.getCod_prod() + " " + b.getStr_prod() + "|");
                }
            } else if (acao.equals("def2")) {
                abObj = jConsultaWeb.getListaProdDataDef(request.getParameter("data_in"));
                for (bConsulta b : abObj) {
                    out.println("<option value='" + b.getCod_prod() + "'>" + b.getCod_prod() + " " + b.getStr_prod() + "</option>");
                }
                out.println("<option value='' selected=true>Todos</option>");
            } else if (acao.equals("assistec")) {
                abObj = jConsultaWeb.getListaProdAssistec(request.getParameter("data_in"));
                for (bConsulta b : abObj) {
                    out.println(b.getCod_prod() + "|" + b.getCod_prod() + " " + b.getStr_prod() + "|");
                }
            } else if (acao.equals("gmp")) {
                abObj = jConsultaWeb.getListaGMP(request.getParameter("data_in"));
                for (bConsulta b : abObj) {
                    out.println(b.getCod_prod() + "| GMP- " + b.getStr_prod() + "|");
                }
            } else if (acao.equals("gmp2")) {
                String aux = "";
                abObj = jConsultaWeb.getListaGMP(request.getParameter("data_in"));
                for (bConsulta b : abObj) {
                    aux = b.getCod_prod().equals("110") ? "selected=true" : "";
                    out.println("<option value='" + b.getCod_prod() + "'" + aux + ">GMP- " + b.getStr_prod() + "</option>");
                }
            }else if (acao.equals("gmp3")) {
                String aux = "";
                abObj = jConsultaWeb.getListaGMP3(request.getParameter("data_in"),request.getParameter("data_fim"));
                for (bConsulta b : abObj) {
                    aux = b.getCod_prod().equals("110") ? "selected=true" : "";
                    out.println("<option value='" + b.getCod_prod() + "'" + aux + ">GMP- " + b.getStr_prod() + "</option>");
                }
            }
        } catch (SQLException ex) {
            System.out.println("Erro: " + ex);
        } catch (ClassNotFoundException ex) {
            System.out.println("Erro: " + ex);
        } finally {
            out.close();
        }
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
