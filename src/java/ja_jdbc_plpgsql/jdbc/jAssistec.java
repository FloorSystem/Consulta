package ja_jdbc_plpgsql.jdbc;

import ja_jdbc_plpgsql.bean.bAssisTec;
import ja_jdbc_plpgsql.bean.bAssistecConsulta;
import ja_jdbc_plpgsql.bean.bAssistecReg;
import ja_jdbc_plpgsql.bean.bConsultaDef;
import ja_jdbc_plpgsql.connection.DBConnectionManager;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;

/**
 *
 * @author psantos
 */
public class jAssistec {

    private static DBConnectionManager conMgr;
    static CallableStatement call;

    static {
        conMgr = DBConnectionManager.getInstance();
    }

    public static int SalvarAssistec(bAssisTec bObj) throws ClassNotFoundException, SQLException {
        int ret;
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{ ? = call sp_assistec_insert(?,int2(?),?,?,?,?,?)}");
            call.registerOutParameter(1, Types.INTEGER);
            call.setInt(2, bObj.getCod_cr());
            call.setInt(3, bObj.getCod_deposito());
            call.setString(4, bObj.getStr_relatorio());
            call.setString(5, bObj.getObs());
            call.setString(6, bObj.getCod_prod());
            call.setString(7, bObj.getCod_prod2());
            call.setString(8, bObj.getSerial());
            call.execute();

            ret = call.getInt(1);
            if (ret == 0) {
                throw new SQLException("Não foi possível Salvar. Reveja os parâmetros.");
            }

            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static int SalvarAssistecReg(Integer arg_cod, bAssistecReg bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {

            call = conPol.prepareCall(" INSERT INTO tb_assistec_rep( "
                    + " cod_assistec, cod_tp_defeito, cod_sintoma, cod_comp, pos_comp, datareg, str_sa, tipo_montagem,str_compo) "
                    + " VALUES (?, ?, ?, ?, ?, DEFAULT, ?, ?, ?);");

            call.setInt(1, arg_cod);
            call.setInt(2, bObj.getCod_tp_defeito());
            call.setInt(3, bObj.getCod_sintoma());
            call.setString(4, bObj.getCod_comp());
            call.setInt(5, bObj.getPos_comp());
            call.setString(6, bObj.getStr_sa());
            call.setString(7, String.valueOf(bObj.getTipo_montagem()));
            call.setString(8, String.valueOf(bObj.getStr_compo()));
            ret = call.executeUpdate();
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static ArrayList<bAssistecConsulta> getSintomas(
            String arg_prod,
            String cod_comp,
            String arg_serial,
            String arg_dt1,
            String arg_dt2) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        ArrayList<bAssistecConsulta> sts = new ArrayList<bAssistecConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        String sql = "	SELECT "
                + "	  tb_assis_tec.cod_prod, "
                + "	  tb_assis_tec.cod_deposito, "
                + "	  tb_assis_tec.serial, "
                + "	  tb_tp_defeito.str_defeito, "
                + "	  tb_sintoma.str_sintoma, "
                + "	  tb_assistec_rep.tipo_montagem, "
                + "	  tb_assistec_rep.cod_comp, "
                + "	  tb_assistec_rep.pos_comp, "
                + "	  tb_assistec_rep.datareg, "
                + "	  tb_assistec_rep.str_compo, "
                + "	  tb_assis_tec.obs, "
                + "	  tb_operador.str_nome"
                + "	FROM "
                + "	  public.tb_assis_tec, "
                + "	  public.tb_assistec_rep, "
                + "	  public.tb_operador, "
                + "	  public.tb_tp_defeito, "
                + "	  public.tb_sintoma"
                + "	WHERE "
                + "	  tb_assis_tec.cod_assistec = tb_assistec_rep.cod_assistec AND"
                + "	  tb_assistec_rep.cod_tp_defeito = tb_tp_defeito.cod_tp_defeito AND"
                + "	  tb_operador.cod_cr = tb_assis_tec.cod_cr AND"
                + "	  tb_sintoma.cod_sintoma = tb_assistec_rep.cod_sintoma AND"
                + "       cod_prod like ? AND "
                + "       upper(cod_comp) like ? AND "
                + "       upper(serial) like ? AND "
                + "       datah BETWEEN TO_timestamp('" + arg_dt1 + "','DD/MM/YYYY HH24:MI:SS') AND TO_timestamp('" + arg_dt2 + "','DD/MM/YYYY HH24:MI:SS');";


        try {
            call = conPol.prepareCall(sql);
            call.setString(1, arg_prod + "%");
            call.setString(2, cod_comp.toUpperCase() + "%");
            call.setString(3, arg_serial.toUpperCase() + "%");
            rs = call.executeQuery();

            while (rs.next()) {
                bAssistecConsulta bObj = new bAssistecConsulta();
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setCod_deposito(rs.getInt("cod_deposito"));
                bObj.setSerial(rs.getString("serial"));
                bObj.setStr_tp_defeito(rs.getString("str_defeito"));
                bObj.setStr_sintoma(rs.getString("str_sintoma"));
                bObj.setTipo_montagem(rs.getString("tipo_montagem").charAt(0));
                bObj.setCod_comp(rs.getString("cod_comp"));
                bObj.setPos_comp(rs.getInt("pos_comp"));
                bObj.setDatahora(rs.getTimestamp("datareg"));
                bObj.setObs(rs.getString("obs"));
                bObj.setStr_cr_operador(rs.getString("str_nome"));
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

    //web
    public String getDataReg() throws SQLException, ClassNotFoundException {
        String sts = new String();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();

            String strQl = "SELECT MIN(datareg) AS dt_min, "
                    + "MAX(datareg) as dt_max "
                    + "FROM tb_assistec_rep;";

            ResultSet rs = stmt.executeQuery(strQl);

            Calendar calMin = Calendar.getInstance();
            Calendar calMax = Calendar.getInstance();

            while (rs.next()) {

                calMin.setTimeInMillis(rs.getTimestamp("dt_min").getTime());
                calMax.setTimeInMillis(rs.getTimestamp("dt_max").getTime());

                while (calMax.compareTo(calMin) == 1) {
                    sts = sts + "<option>" + (calMax.get(Calendar.MONTH) + 1) + "/" + calMax.get(Calendar.YEAR) + "</option>";
                    calMax.add(Calendar.MONTH, -1);
                }
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bConsultaDef> getConsultaAsistec(String arg_prod, String arg_data) throws SQLException, ClassNotFoundException {
        ResultSet rs;
        ArrayList<bConsultaDef> sts = new ArrayList<bConsultaDef>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_consulta_assistecgraf(?,?)}");
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

    public static ArrayList<bAssistecReg> getDefReg(String arg_cod_prod, String dt1) throws SQLException, ClassNotFoundException {
        ResultSet rs;
        ArrayList<bAssistecReg> sts = new ArrayList<bAssistecReg>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("SELECT  "
                    + "  tb_assis_tec.*,  "
                    + "  tb_tp_defeito.str_defeito,  "
                    + "  tb_sintoma.str_sintoma,  "
                    + "  tb_operador.str_nome,  "
                    + "  tb_assistec_rep.* "
                    + "FROM  "
                    + "  tb_tp_defeito,  "
                    + "  tb_assis_tec,  "
                    + "  tb_assistec_rep,  "
                    + "  tb_sintoma,  "
                    + "  tb_operador "
                    + "WHERE  "
                    + "  tb_assis_tec.cod_assistec = tb_assistec_rep.cod_assistec AND "
                    + "  tb_assistec_rep.cod_tp_defeito = tb_tp_defeito.cod_tp_defeito AND "
                    + "  tb_sintoma.cod_sintoma = tb_assistec_rep.cod_sintoma AND "
                    + "  tb_operador.cod_cr = tb_assis_tec.cod_cr AND"
                    + "  date_trunc('month',  tb_assistec_rep.datareg) =  TO_timestamp(?,'MM/YYYY') AND "
                    + "  tb_assis_tec.cod_prod like ? || '%';");
            //+ " AND tb_assistec_rep.cod_tp_defeito = ?;");

            call.setString(1, dt1);
            call.setString(2, arg_cod_prod);
            //  call.setInt(3, arg_cod_tp_defeito);
            rs = call.executeQuery();

            while (rs.next()) {
                bAssistecReg bObj = new bAssistecReg();
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setSerial(rs.getString("serial"));
                bObj.setStr_tp_defeito(rs.getString("str_defeito"));
                bObj.setStr_sintoma(rs.getString("str_sintoma"));
                bObj.setTipo_montagem(rs.getString("tipo_montagem").charAt(0));
                bObj.setCod_comp(rs.getString("cod_comp"));
                bObj.setPos_comp(rs.getInt("pos_comp"));
                bObj.setDatahora(rs.getTimestamp("datareg"));
                bObj.setStr_nome(rs.getString("str_nome"));
                bObj.setObs(rs.getString("obs").replaceAll("\n", " "));
                bObj.setCod_deposito(rs.getInt("cod_deposito"));
                bObj.setStr_relatorio(rs.getString("str_relatorio"));
                bObj.setCod_prod2("cod_prod2");
                bObj.setStr_sa(rs.getString("str_sa"));
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

    public static ArrayList<bAssistecReg> getDefReg(String arg_cod_prod, String dt1, int arg_cod_tp_defeito) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        ArrayList<bAssistecReg> sts = new ArrayList<bAssistecReg>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("SELECT  "
                    + "  tb_assis_tec.*,  "
                    + "  tb_tp_defeito.str_defeito,  "
                    + "  tb_sintoma.str_sintoma,  "
                    + "  tb_operador.str_nome,  "
                    + "  tb_assistec_rep.* "
                    + "FROM  "
                    + "  tb_tp_defeito,  "
                    + "  tb_assis_tec,  "
                    + "  tb_assistec_rep,  "
                    + "  tb_sintoma,  "
                    + "  tb_operador "
                    + "WHERE  "
                    + "  tb_assis_tec.cod_assistec = tb_assistec_rep.cod_assistec AND "
                    + "  tb_assistec_rep.cod_tp_defeito = tb_tp_defeito.cod_tp_defeito AND "
                    + "  tb_sintoma.cod_sintoma = tb_assistec_rep.cod_sintoma AND "
                    + "  tb_operador.cod_cr = tb_assis_tec.cod_cr AND"
                    + "  date_trunc('month',  tb_assistec_rep.datareg) =  TO_timestamp(?,'MM/YYYY') AND "
                    + "  tb_assis_tec.cod_prod like ? || '%' "
                    + " AND tb_assistec_rep.cod_tp_defeito = ?;");


            call.setString(1, dt1);
            call.setString(2, arg_cod_prod);
            call.setInt(3, arg_cod_tp_defeito);
            rs = call.executeQuery();

            while (rs.next()) {
                bAssistecReg bObj = new bAssistecReg();
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setSerial(rs.getString("serial"));
                bObj.setStr_tp_defeito(rs.getString("str_defeito"));
                bObj.setStr_sintoma(rs.getString("str_sintoma"));
                bObj.setTipo_montagem(rs.getString("tipo_montagem").charAt(0));
                bObj.setCod_comp(rs.getString("cod_comp"));
                bObj.setPos_comp(rs.getInt("pos_comp"));
                bObj.setDatahora(rs.getTimestamp("datareg"));
                bObj.setStr_nome(rs.getString("str_nome"));
                bObj.setObs(rs.getString("obs").replaceAll("\n", " "));
                bObj.setCod_deposito(rs.getInt("cod_deposito"));
                bObj.setStr_relatorio(rs.getString("str_relatorio"));
                bObj.setCod_prod2("cod_prod2");
                bObj.setStr_sa(rs.getString("str_sa"));
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

    public static ArrayList<bConsultaDef> getConsultaDefMAP(String arg_data) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        ArrayList<bConsultaDef> sts = new ArrayList<bConsultaDef>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_consulta_asistecmap(?)}");
            //  call.setString(1, arg_prod);
            call.setString(1, arg_data);
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
            call = conPol.prepareCall(" SELECT  distinct tb_tp_defeito.str_defeito"
                    + " FROM   tb_assistec_rep,   tb_tp_defeito WHERE "
                    + " tb_tp_defeito.cod_tp_defeito = tb_assistec_rep.cod_tp_defeito AND"
                    + " date_trunc('month',  datareg) =  TO_timestamp(?,'MM/YYYY')"
                    + " order by tb_tp_defeito.str_defeito;");
            call.setString(1, arg_dt1);
            // call.setString(2, arg_cod_prod);
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
}
