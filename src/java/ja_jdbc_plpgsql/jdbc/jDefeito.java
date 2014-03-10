package ja_jdbc_plpgsql.jdbc;

import ja_jdbc_plpgsql.bean.bConsultaDef;
import ja_jdbc_plpgsql.bean.bDefeito;
import ja_jdbc_plpgsql.connection.DBConnectionManager;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

/**
 *
 * @author psantos
 */
public class jDefeito {

    private static DBConnectionManager conMgr;
    static CallableStatement call;

    static {
        conMgr = DBConnectionManager.getInstance();
    }

    public static int Salvar(bDefeito bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{ ? = call sp_defeito_insert(?,?,?,?,?,?,?,?,?)}");
            call.registerOutParameter(1, Types.INTEGER);
            call.setString(2, bObj.getCod_prod());
            call.setString(3, bObj.getSerial());
            call.setInt(4, bObj.getCod_tp_defeito());
            call.setInt(5, bObj.getCod_sintoma());
            call.setString(6, String.valueOf(bObj.getTipo_montagem()));
            call.setString(7, bObj.getCod_comp());
            call.setInt(8, bObj.getPos_comp());
            call.setInt(9, bObj.getCod_cr());
            call.setString(10, bObj.getStr_obs());
            call.execute();
            ret = call.getInt(1);
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static ArrayList<bDefeito> getSintomas(String arg_prod, Integer arg_sintoma) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        ArrayList<bDefeito> sts = new ArrayList<bDefeito>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("SELECT * FROM tb_defeito WHERE cod_prod = ? and cod_sintoma = ?;");
            call.setString(1, arg_prod);
            call.setInt(2, arg_sintoma);
            rs = call.executeQuery();

            while (rs.next()) {
                bDefeito bObj = new bDefeito();
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setSerial(rs.getString("serial"));
                bObj.setCod_tp_defeito(rs.getInt("cod_tp_defeito"));
                bObj.setCod_sintoma(rs.getInt("cod_sintoma"));
                bObj.setTipo_montagem(rs.getString("tipo_montagem").charAt(0));
                bObj.setCod_comp(rs.getString("cod_comp"));
                bObj.setStr_obs(rs.getString("str_obs").replaceAll("\n", " "));
                bObj.setPos_comp(rs.getInt("pos_comp"));
                bObj.setDatahora(rs.getTimestamp("datahora"));
                bObj.setCod_cr(rs.getInt("cod_cr"));
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

    public static ArrayList<bConsultaDef> getConsultaDef(String arg_prod, String arg_data) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        ArrayList<bConsultaDef> sts = new ArrayList<bConsultaDef>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_consulta_defeitos(?,?)}");
            call.setString(1, arg_prod);
            call.setString(2, arg_data);
            rs = call.executeQuery();

            while (rs.next()) {
                bConsultaDef bObj = new bConsultaDef();
                bObj.setCont(rs.getInt("f1"));
                bObj.setPercent(rs.getFloat("f2"));
                bObj.setStr_def(rs.getString("f3"));
                bObj.setTotal(rs.getInt("f4"));
                bObj.setCod_def(rs.getInt("f5"));
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

    public static ArrayList<bConsultaDef> getConsultaDefMAP(String arg_prod, String arg_data) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        ArrayList<bConsultaDef> sts = new ArrayList<bConsultaDef>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_consulta_defeitosMAP(?,?)}");
            call.setString(1, arg_prod);
            call.setString(2, arg_data);
            rs = call.executeQuery();

            while (rs.next()) {
                bConsultaDef bObj = new bConsultaDef();
                bObj.setCont(rs.getInt("f4"));
                bObj.setPercent(rs.getFloat("f3"));
                bObj.setStr_def(rs.getString("f2").replace(" ", "_"));
                bObj.setStr_prod(rs.getString("f1").replace(" ", "_"));
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

    public String getConsulDefMap(String arg_dt1) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        String sts = "";
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("SELECT  distinct tb_tp_defeito.str_defeito"
                    + " FROM   public.tb_defeito,   public.tb_tp_defeito WHERE "
                    + "  tb_tp_defeito.cod_tp_defeito = tb_defeito.cod_tp_defeito AND"
                    + "  date_trunc('month',  datahora) =  TO_timestamp(?,'MM/YYYY')"
                    + " order by tb_tp_defeito.str_defeito");
            call.setString(1, arg_dt1);
            rs = call.executeQuery();
            while (rs.next()) {
                sts = sts + "[\"" + rs.getString(1).replace(" ", "_") + "\",\"Defeitos\",0,0], \n";
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bDefeito> getDefReg(String arg_cod_prod, String dt1) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        ArrayList<bDefeito> sts = new ArrayList<bDefeito>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("SELECT  "
                    + "  tb_defeito.cod_prod,  "
                    + "  tb_defeito.serial,  "
                    + "  tb_tp_defeito.str_defeito,  "
                    + "  tb_sintoma.str_sintoma,  "
                    + "  tb_defeito.tipo_montagem,  "
                    + "  tb_defeito.cod_comp,  "
                    + "  tb_defeito.pos_comp,  "
                    + "  tb_defeito.datahora,  "
                    + "  tb_operador.str_nome,  "
                    + "  tb_defeito.str_obs, "
                    + "  tb_defeito.str_compo "
                    + "FROM  "
                    + "  public.tb_tp_defeito,  "
                    + "  public.tb_defeito,  "
                    + "  public.tb_sintoma,  "
                    + "  public.tb_operador "
                    + "WHERE  "
                    + "  tb_defeito.cod_tp_defeito = tb_tp_defeito.cod_tp_defeito AND "
                    + "  tb_sintoma.cod_sintoma = tb_defeito.cod_sintoma AND "
                    + "  tb_operador.cod_cr = tb_defeito.cod_cr AND"
                    + "  date_trunc('month',  tb_defeito.datahora) =  TO_timestamp(?,'MM/YYYY') AND "
                    + "  tb_defeito.cod_prod like ? || '%' "
                    + " ORDER BY tb_defeito.datahora;");
            call.setString(1, dt1);
            call.setString(2, arg_cod_prod);
            rs = call.executeQuery();
            while (rs.next()) {
                bDefeito bObj = new bDefeito();
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setSerial(rs.getString("serial"));
                bObj.setStr_tp_defeito(rs.getString("str_defeito"));
                bObj.setStr_sintoma(rs.getString("str_sintoma"));
                bObj.setTipo_montagem(rs.getString("tipo_montagem").charAt(0));
                bObj.setCod_comp(rs.getString("cod_comp"));
                bObj.setPos_comp(rs.getInt("pos_comp"));
                bObj.setDatahora(rs.getTimestamp("datahora"));
                bObj.setStr_nome(rs.getString("str_nome"));
                bObj.setStr_obs(rs.getString("str_obs").replaceAll("\n", " "));
                bObj.setStr_compo(rs.getString("str_compo"));
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

    public static ArrayList<bDefeito> getDefReg(String arg_cod_prod, String dt1, int arg_cod_tp_defeito) throws SQLException, ClassNotFoundException {
        ResultSet rs;
        ArrayList<bDefeito> sts = new ArrayList<bDefeito>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("SELECT  "
                    + "  tb_defeito.cod_prod,  "
                    + "  tb_defeito.serial,  "
                    + "  tb_tp_defeito.str_defeito,  "
                    + "  tb_sintoma.str_sintoma,  "
                    + "  tb_defeito.tipo_montagem,  "
                    + "  tb_defeito.cod_comp,  "
                    + "  tb_defeito.pos_comp,  "
                    + "  tb_defeito.datahora,  "
                    + "  tb_operador.str_nome,  "
                    + "  tb_defeito.str_obs, "
                    + "  tb_defeito.str_compo "
                    + "FROM  "
                    + "  public.tb_tp_defeito,  "
                    + "  public.tb_defeito,  "
                    + "  public.tb_sintoma,  "
                    + "  public.tb_operador "
                    + "WHERE  "
                    + "  tb_defeito.cod_tp_defeito = tb_tp_defeito.cod_tp_defeito AND "
                    + "  tb_sintoma.cod_sintoma = tb_defeito.cod_sintoma AND "
                    + "  tb_operador.cod_cr = tb_defeito.cod_cr AND"
                    + "  date_trunc('month',  tb_defeito.datahora) =  TO_timestamp(?,'MM/YYYY') AND "
                    + "  tb_defeito.cod_prod like ? || '%'  AND "
                    + "  tb_defeito.cod_tp_defeito = ?"
                    + " ORDER BY tb_defeito.datahora;");

            call.setString(1, dt1);
            call.setString(2, arg_cod_prod);
            call.setInt(3, arg_cod_tp_defeito);
            rs = call.executeQuery();

            while (rs.next()) {
                bDefeito bObj = new bDefeito();
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setSerial(rs.getString("serial"));
                bObj.setStr_tp_defeito(rs.getString("str_defeito"));
                bObj.setStr_sintoma(rs.getString("str_sintoma"));
                bObj.setTipo_montagem(rs.getString("tipo_montagem").charAt(0));
                bObj.setCod_comp(rs.getString("cod_comp"));
                bObj.setPos_comp(rs.getInt("pos_comp"));
                bObj.setDatahora(rs.getTimestamp("datahora"));
                bObj.setStr_nome(rs.getString("str_nome"));
                bObj.setStr_obs(rs.getString("str_obs").replaceAll("\n", " "));
                bObj.setStr_compo(rs.getString("str_compo"));
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
}
