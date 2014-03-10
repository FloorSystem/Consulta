/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.logica;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author psantos
 */
public class PrimeiraLogica implements Logica{

    @Override
    public void executa(HttpServletRequest req, HttpServletResponse res) throws Exception {
        System.out.println("Executando a logica e redirecionando...");
        RequestDispatcher rd = req.getRequestDispatcher("/primeira-logica.jsp");
        rd.forward(req, res);
    }
    
}
