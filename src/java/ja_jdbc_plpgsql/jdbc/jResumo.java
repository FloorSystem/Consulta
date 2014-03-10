package ja_jdbc_plpgsql.jdbc;

import ja_jdbc_plpgsql.bean.bResumo;
import ja_jdbc_plpgsql.connection.DBConnectionManager;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 *
 * @author psantos
 */
public class jResumo {

    private static DBConnectionManager conMgr;
    static CallableStatement call;

    static {
        conMgr = DBConnectionManager.getInstance();
    }

    public static ArrayList<bResumo> getConsultaDef(String arg_data) throws SQLException, ClassNotFoundException {
        ResultSet rs;
        ArrayList<bResumo> sts = new ArrayList<bResumo>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_resumo_dia2(to_date(?,'DD/MM/YYYY'))}");
            call.setString(1, arg_data);
            rs = call.executeQuery();

            while (rs.next()) {
                bResumo bObj = new bResumo();
                bObj.setF1(rs.getString("cod_prod"));
                bObj.setF2(rs.getInt("ok"));
                bObj.setF3(rs.getInt("nok"));
                bObj.setF4(rs.getInt("defeitos"));
                bObj.setF5(rs.getString("str_prod"));
                sts.add(bObj);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bResumo> getConsultaDef() throws SQLException, ClassNotFoundException {
        ResultSet rs;
        ArrayList<bResumo> sts = new ArrayList<bResumo>();
        Connection conPol = conMgr.getConnection("PD");
        Statement Statement = conPol.createStatement();
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            rs = Statement.executeQuery(" select * from sp_resumo_dia2semana() ");
            while (rs.next()) {
                bResumo bObj = new bResumo();
                bObj.setF1(rs.getString("cod_prod"));
                bObj.setF2(rs.getInt("ok"));
                bObj.setF3(rs.getInt("nok"));
                bObj.setF4(rs.getInt("defeitos"));
                bObj.setF5(rs.getString("str_prod"));
                sts.add(bObj);
            }
            Statement.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
}
