/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.logica;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author psantos
 */
public interface Logica {
    void executa(HttpServletRequest req, HttpServletResponse res) throws Exception;
}
