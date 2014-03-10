/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.servlet;

import ja_jdbc_plpgsql.jdbc.jAssistec2;
import ja_jdbc_plpgsql.jdbc.jConsultaWeb;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 *
 * @author psantos
 */
public class serialArquivo extends HttpServlet {

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
        try {

            /*List<FileItem> items = (List<FileItem>) upload.parseRequest(request);
            
            for (FileItem item : items) {
            if (item.isFormField()) {
            //se for um campo normal de form
            response.getWriter().println("Form field");
            response.getWriter().println("Name:" + item.getFieldName());
            response.getWriter().println("Value:" + item.getString());
            } else {
            //caso seja um campo do tipo file
            response.getWriter().println("NOT Form field");
            response.getWriter().println("Name:" + item.getFieldName());
            response.getWriter().println("FileName:" + item.getName());
            response.getWriter().println("Size:" + item.getSize());
            response.getWriter().println("ContentType:" + item.getContentType());
            }
            }
             */
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

        String acao = request.getParameter("acao");
        
        try {
            if (acao.equals("sa")) {
                String sa = request.getParameter("sa_str");
                ArrayList lista2 = new ArrayList();
                lista2 = jAssistec2.getATSA(sa);
                request.setAttribute("lista", lista2);
                request.getRequestDispatcher("SerialResumo.jsp").forward(request, response);
                processRequest(request, response);
            } else {
                boolean isMultipart = ServletFileUpload.isMultipartContent(request);
                if (isMultipart) {

                    FileItemFactory factory = new DiskFileItemFactory();
                    ServletFileUpload upload = new ServletFileUpload(factory);

                    List items = null;
                    items = upload.parseRequest(request);
                    Iterator iter = items.iterator();
                    while (iter.hasNext()) {
                        FileItem item = (FileItem) iter.next();
                        if (item.isFormField()) {
                        } else {
                            //byte[] arquivo = item.get();
                            //for (byte b : arquivo ) {
                            //System.out.println(item.getString());
                            //   }

                            ArrayList lista1 = new ArrayList();
                            //           ArrayList lista2 = new ArrayList();

                            String[] str = item.getString().split("\n");
                            for (String a : str) {
                                // System.out.print(a);
                                //a.replaceAll("\t"," ").replaceAll("\r\n", " ").replaceAll("\n", " ").trim();  
                                a = a.replaceAll("\r", " ").replaceAll("\r\n", " ").replaceAll("\n", " ").trim();
                                lista1.add("\n------------------------------------------------------------------------------------------------------------------------------------------------------");
                                lista1.add(a);

                                if (acao.equals("assistec")) {
                                    lista1.addAll(jConsultaWeb.getSerialResumoAssis(a));
                                } else {

                                    lista1.addAll(jConsultaWeb.getSerialResumo(a));
                                }
                                //lista2.addAll(lista1);
                            }
                            request.setAttribute("lista", lista1);
                            request.getRequestDispatcher("SerialResumo.jsp").forward(request, response);
                        }
                    }
                    processRequest(request, response);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(serialArquivo.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(serialArquivo.class.getName()).log(Level.SEVERE, null, ex);
        } catch (FileUploadException ex) {
            Logger.getLogger(serialArquivo.class.getName()).log(Level.SEVERE, null, ex);
        }
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
