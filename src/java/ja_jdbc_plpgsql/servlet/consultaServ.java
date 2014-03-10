package ja_jdbc_plpgsql.servlet;

import ja_jdbc_plpgsql.bean.TPM.bQtd_regs;
import ja_jdbc_plpgsql.bean.bAssistecReg;
import ja_jdbc_plpgsql.bean.bConsulta;
import ja_jdbc_plpgsql.bean.bConsultaCompo;
import ja_jdbc_plpgsql.bean.bConsultaDef;
import ja_jdbc_plpgsql.bean.bDefeito;
import ja_jdbc_plpgsql.bean.bRegistro;
import ja_jdbc_plpgsql.bean.bResumo;
import ja_jdbc_plpgsql.jdbc.TPM.jQtdProduz;
import ja_jdbc_plpgsql.jdbc.jAssistec;
import ja_jdbc_plpgsql.jdbc.jConsultaWeb;
import ja_jdbc_plpgsql.jdbc.jDefeito;
import ja_jdbc_plpgsql.jdbc.jRegistro;
import ja_jdbc_plpgsql.jdbc.jResumo;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author psantos
 */
public class consultaServ extends HttpServlet {

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
        /*
        String parametro = request.getParameter("logica");
        String nomeDaClasse = "br.com.caelum.mvc.logica." + parametro;
        try{
        Class classe = Class.forName(nomeDaClasse);
        Logica logica = (Logica) classe.newInstance(); 
        Object objeto = classe.newInstance();
        logica.executa(request, response);
        }
         */

//System.out.println("Entrou.");
        String acao = request.getParameter("acao");
        try {

            if (acao.equals("resumo")) {
                ArrayList<bResumo> abObj = new ArrayList<bResumo>();
                abObj = jResumo.getConsultaDef(request.getParameter("dia").toString());
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/consultaResumoDia.jsp");
                rd.forward(request, response);
            } else if (acao.equals("resumoSemana")) {
                ArrayList<bResumo> abObj = new ArrayList<bResumo>();
                abObj = jResumo.getConsultaDef();
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/consultaResumoDia.jsp");
                rd.forward(request, response);
            } else if (acao.equals("fun")) {
                ArrayList<bConsulta> abObj = new ArrayList<bConsulta>();
                abObj = jConsultaWeb.getPesquisa2(request.getParameter("imput_prod1"), request.getParameter("data_in1"), Integer.valueOf(request.getParameter("imput_gmp1")));
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/consultaFuncional.jsp");
                rd.forward(request, response);
            }else if (acao.equals("fun3")) {
                ArrayList<bConsulta> abObj = new ArrayList<bConsulta>();
                abObj = jConsultaWeb.getPesquisa3(request.getParameter("imput_prod1"), request.getParameter("data_in1"), request.getParameter("dt2"), Integer.valueOf(request.getParameter("imput_gmp1")));
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/consultaFuncional.jsp");
                rd.forward(request, response);
            } else if (acao.equals("def")) {
                ArrayList<bConsultaDef> abObj = new ArrayList<bConsultaDef>();
                abObj = jDefeito.getConsultaDef(request.getParameter("imput_prod"), request.getParameter("data_in"));
                request.setAttribute("lista", abObj);
                //RequestDispatcher rd = request.getRequestDispatcher("/consultaDefeitos_Include.jsp");
                RequestDispatcher rd = request.getRequestDispatcher("/consultaDefeitos.jsp");
                //rd.forward(request, response);
                rd.include(request, response);
            } else if (acao.equals("defMap")) {
                ArrayList<bConsultaDef> abObj = new ArrayList<bConsultaDef>();
                abObj = jDefeito.getConsultaDefMAP(request.getParameter("imput_prod"), request.getParameter("data_in"));
                String lista2 = new jDefeito().getConsulDefMap(request.getParameter("data_in"));
                request.setAttribute("lista", abObj);
                request.setAttribute("lista2", lista2);
                RequestDispatcher rd = request.getRequestDispatcher("/consultaDefMap.jsp");
                rd.forward(request, response);
            } else if (acao.equals("listaReg")) {
                ArrayList<bRegistro> abObj = new ArrayList<bRegistro>();
                bRegistro bRegistro = new bRegistro();
                bRegistro.setCod_prod(request.getParameter("imput_prod1"));
                bRegistro.setCod_gmp(Integer.valueOf(request.getParameter("imput_gmp1")));
                abObj = jRegistro.Pesquisa(bRegistro, request.getParameter("data_in1").toString(), "");
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/ListaDadosFun.jsp");
                rd.forward(request, response);
            }else if (acao.equals("listaReg3")) {
                ArrayList<bRegistro> abObj = new ArrayList<bRegistro>();
                bRegistro bRegistro = new bRegistro();
                bRegistro.setCod_prod(request.getParameter("imput_prod1"));
                bRegistro.setCod_gmp(Integer.valueOf(request.getParameter("imput_gmp1")));
                abObj = jRegistro.Pesquisa(bRegistro, request.getParameter("data_in1").toString(), request.getParameter("dt2").toString());
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/ListaDadosFun.jsp");
                rd.forward(request, response);
            } else if (acao.equals("componentes")) {
                ArrayList<bConsultaCompo> abObj = new ArrayList<bConsultaCompo>();
                abObj = jConsultaWeb.getPesquisaCompo(request.getParameter("imput_prod"), request.getParameter("data_in").toString());
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/ListaDadosCompo.jsp");
                rd.forward(request, response);
            } else if (acao.equals("listaDef")) {
                ArrayList<bDefeito> abObj = new ArrayList<bDefeito>();
                abObj = jDefeito.getDefReg(request.getParameter("imput_prod"), request.getParameter("data_in").toString());
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/ListaDadosDef.jsp");
                rd.forward(request, response);
            } else if (acao.equals("listaDefTipo")) {
                ArrayList<bDefeito> abObj = new ArrayList<bDefeito>();
                String tp_def = request.getParameter("tp_def").toString();
                if (tp_def != null || !tp_def.equals("")) {
                    abObj = jDefeito.getDefReg(
                            request.getParameter("imput_prod"),
                            request.getParameter("data_in").toString(),
                            Integer.valueOf(tp_def));
                } else {
                    abObj = jDefeito.getDefReg(request.getParameter("imput_prod"), request.getParameter("data_in").toString());
                }
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/ListaDadosDef.jsp");
                rd.forward(request, response);
            } else if (acao.equals("listaAssistec")) {
                ArrayList<bAssistecReg> abObj = new ArrayList<bAssistecReg>();
                String tp_def = request.getParameter("tp_def").toString();
                if (tp_def == null || tp_def.trim().equals("")) {
                    abObj = jAssistec.getDefReg(request.getParameter("imput_prod").toString(), request.getParameter("data_in").toString());
                } else {
                    abObj = jAssistec.getDefReg(
                            request.getParameter("imput_prod"),
                            request.getParameter("data_in").toString(),
                            Integer.valueOf(tp_def));

                }
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/ListDadosAssistc.jsp");
                rd.forward(request, response);

            } else if (acao.equals("assistec")) {
                ArrayList<bConsultaDef> abObj = new ArrayList<bConsultaDef>();
                abObj = jAssistec.getConsultaAsistec(request.getParameter("imput_prod"), request.getParameter("data_in"));
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/consultaDefeitosAssostec.jsp");
                rd.include(request, response);
            } else if (acao.equals("AsisMap")) {
                ArrayList<bConsultaDef> abObj = new ArrayList<bConsultaDef>();
                abObj = jAssistec.getConsultaDefMAP(request.getParameter("data_in"));
                String lista2 = new jAssistec().getConsulDefMap(request.getParameter("data_in"));
                request.setAttribute("lista", abObj);
                request.setAttribute("lista2", lista2);
                RequestDispatcher rd = request.getRequestDispatcher("/consultaDefMap.jsp");
                rd.forward(request, response);
            } else if (acao.equals("compAssistec")) {
                ArrayList<bConsultaCompo> abObj = new ArrayList<bConsultaCompo>();
                abObj = jConsultaWeb.getPesquisaCompoAt(request.getParameter("imput_prod"), request.getParameter("data_in").toString());
                request.setAttribute("lista", abObj);
                RequestDispatcher rd = request.getRequestDispatcher("/ListaDadosCompo.jsp");
                rd.forward(request, response);
            } else if (acao.equals("TPM")) {

                String str1 = request.getParameter("data");
                Integer int2 = Integer.valueOf(request.getParameter("codlin").toString());

                ArrayList<bQtd_regs> grafi1 = jQtdProduz.getEficienciaRelat(str1, int2);
                request.setAttribute("lista", grafi1);

                ArrayList<bQtd_regs> lista1 = jQtdProduz.getSetpOP(str1, int2);
                request.setAttribute("lista1", lista1);

                //  ArrayList<bQtd_regs> lista2 = jQtdProduz.getEficMap(str1, int2);
                //  request.setAttribute("lista2", lista2);

                ArrayList<bQtd_regs> lista3 = jQtdProduz.getEficienciaMediaMes(str1, int2);
                request.setAttribute("lista3", lista3);


                RequestDispatcher rd = request.getRequestDispatcher("/TPMlista.jsp");
                rd.forward(request, response);
            } else if (acao.equals("ops")) {
                ArrayList lista = jConsultaWeb.getTotaisOp();
                request.setAttribute("lista", lista);
                RequestDispatcher rd = request.getRequestDispatcher("/OpLista.jsp");
                rd.forward(request, response);
            } else if (acao.equals("opsConsulta")) {
                ArrayList lista = jConsultaWeb.getTotaisOpMes(request.getParameter("data_in1"), Integer.valueOf(request.getParameter("imput_gmp1")), request.getParameter("imput_prod1"));
                request.setAttribute("lista", lista);
                RequestDispatcher rd = request.getRequestDispatcher("/OpLista.jsp");
                rd.forward(request, response);
            } else if (acao.equals("opsConsultaOp")) {
                ArrayList lista = jConsultaWeb.getOpOp(request.getParameter("txt_op"));
                request.setAttribute("lista", lista);
                ArrayList lista1 = jConsultaWeb.getSerialFaltaOp(request.getParameter("txt_op").trim());
                request.setAttribute("lista1", lista1);
                RequestDispatcher rd = request.getRequestDispatcher("/OpLista.jsp");
                rd.forward(request, response);
            } else if (acao.equals("opsConsultaSerial")) {
                ArrayList lista = jConsultaWeb.getOpSerial(request.getParameter("txt_serial"));
                request.setAttribute("lista", lista);
                RequestDispatcher rd = request.getRequestDispatcher("/OpLista.jsp");
                rd.forward(request, response);
            } else if (acao.equals("MediaHoras")) {
                ArrayList lista = jConsultaWeb.getMediaHoras2(request.getParameter("data_in1"), request.getParameter("dt2"), Integer.valueOf(request.getParameter("imput_gmp1")), request.getParameter("imput_prod1"));
                request.setAttribute("lista", lista);
                RequestDispatcher rd = request.getRequestDispatcher("/ListaMediaHora.jsp");
                rd.forward(request, response);
            } else if (acao.equals("consultaSerial")) {
                ArrayList lista = jConsultaWeb.getSerialResumo(request.getParameter("txt_serial"));
                request.setAttribute("lista", lista);

                RequestDispatcher rd = request.getRequestDispatcher("/SerialResumo.jsp");
                rd.forward(request, response);
            } else if (acao.equals("registrar")) {


                int reg = jRegistro.Salvarweb(Integer.valueOf(request.getParameter("user")),
                        Integer.valueOf(request.getParameter("status")),
                        request.getParameter("serial"),
                        request.getParameter("gmp"));


                request.setAttribute("reg", reg);

                RequestDispatcher rd = request.getRequestDispatcher("/registro/registro.jsp");
                //RequestDispatcher rd = request.getRequestDispatcher("/");
                rd.forward(request, response);
            }


        } catch (SQLException ex) {
            //ver mais exceções:
            //http://uaihebert.com/?p=15
            request.setAttribute("erro", ex.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/ERRO606.jsp");
            rd.forward(request, response);

            System.out.println("Erro: " + ex);
        } catch (ClassNotFoundException ex) {
            request.setAttribute("erro", ex.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/ERRO606.jsp");
            rd.forward(request, response);
            System.out.println("Erro: " + ex);
        } catch (ParseException ex) {
            request.setAttribute("erro", ex.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/ERRO606.jsp");
            rd.forward(request, response);
            System.out.println("Erro: " + ex);
        } catch (NumberFormatException ex) {
            request.setAttribute("erro", ex.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/ERRO606.jsp");
            rd.forward(request, response);
            System.out.println("Erro: " + ex);
        } finally {
            //  out.close();
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
