package ja_jdbc_plpgsql.jdbc;

import ja_jdbc_plpgsql.bean.bAssistecConsulta;
import ja_jdbc_plpgsql.connection.DBConnectionManager;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author psantos
 */
public class jAssistec2 {

    private static DBConnectionManager conMgr;
    static CallableStatement call;

    static {
        conMgr = DBConnectionManager.getInstance();
    }

    public static ArrayList getATSA(String sa) throws SQLException {
        ArrayList arr = new ArrayList();
        ResultSet rs;
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        String sql = "SELECT "
                + "  tb_assis_tec.datah, "
                + "  tb_assis_tec.obs, "
                + "  tb_assis_tec.cod_prod, "
                + "  tb_assis_tec.serial, "
                + "  tb_assis_tec.op_num, "
                + "  tb_tp_defeito.str_defeito, "
                + "  tb_sintoma.str_sintoma, "
                + "  tb_assistec_rep.pos_comp, "
                + "  tb_assistec_rep.str_sa, "
                + "  tb_assistec_rep.cod_comp, "
                + "  tb_operador.str_nome "
                + " FROM "
                + "  public.tb_assis_tec, "
                + "  public.tb_assistec_rep, "
                + "  public.tb_sintoma, "
                + "  public.tb_operador, "
                + "  public.tb_tp_defeito "
                + " WHERE "
                + "  tb_assistec_rep.cod_assistec = tb_assis_tec.cod_assistec AND"
                + "  tb_assistec_rep.cod_tp_defeito = tb_tp_defeito.cod_tp_defeito AND"
                + "  tb_sintoma.cod_sintoma = tb_assistec_rep.cod_sintoma AND"
                + "  tb_operador.cod_cr = tb_assis_tec.cod_cr AND"
                + "  tb_assistec_rep.str_sa LIKE '%" + sa + "%';";

        try {
            PreparedStatement pr = conPol.prepareStatement(sql);


            rs = pr.executeQuery();

            while (rs.next()) {

                arr.add(
                        rs.getString("cod_prod") + "; "
                        + rs.getString("serial") + "; "
                        + rs.getString("str_sintoma") + "; "
                        + rs.getString("pos_comp") + "; "
                        + rs.getString("cod_comp") + "; "
                        + rs.getTimestamp("datah") + "; "
                        + rs.getString("str_nome") + "; "
                        + rs.getString("obs") + "; "
                        + rs.getString("str_defeito") + "; "
                        + rs.getString("str_sa") + "; "
                        + rs.getInt("op_num"));

            }
//            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }

        return arr;
    }

    public static ArrayList<bAssistecConsulta> getSintomas(
            //    String arg_prod,
            //    String cod_comp,
            String arg_serial //    String arg_dt1,
            //  String arg_dt2
            ) throws SQLException, ClassNotFoundException {

        ResultSet rs;
        ArrayList<bAssistecConsulta> sts = new ArrayList<bAssistecConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }

        String sql = "	SELECT "
                + "	  tb_assis_tec.*, "
                + "	  tb_tp_defeito.str_defeito, "
                + "	  tb_sintoma.str_sintoma, "
                + "	  tb_assistec_rep.*, "
                + "	  tb_operador.str_nome"
                + "	FROM "
                + "	  tb_assis_tec, "
                + "	  tb_assistec_rep, "
                + "	  tb_operador, "
                + "	  tb_tp_defeito, "
                + "	  tb_sintoma"
                + "	WHERE "
                + "	  tb_assis_tec.cod_assistec = tb_assistec_rep.cod_assistec AND"
                + "	  tb_assistec_rep.cod_tp_defeito = tb_tp_defeito.cod_tp_defeito AND"
                + "	  tb_operador.cod_cr = tb_assis_tec.cod_cr AND"
                + "	  tb_sintoma.cod_sintoma = tb_assistec_rep.cod_sintoma AND"
                //    + "       cod_prod like ? AND "
                //    + "       upper(cod_comp) like ? AND "
                + "       upper(serial) like ? ;";//AND "
        //    + "       datah BETWEEN TO_timestamp('" + arg_dt1 + "','DD/MM/YYYY HH24:MI:SS') AND TO_timestamp('" + arg_dt2 + "','DD/MM/YYYY HH24:MI:SS');";


        try {
            call = conPol.prepareCall(sql);
            //  call.setString(1, arg_prod + "%");
            // call.setString(2, cod_comp.toUpperCase() + "%");
            call.setString(1, arg_serial.toUpperCase() + "%");
            rs = call.executeQuery();

            while (rs.next()) {
                bAssistecConsulta bObj = new bAssistecConsulta();
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setCod_deposito(rs.getInt("cod_deposito"));
                bObj.setOp_num(rs.getInt("op_num"));
                bObj.setCod_tp_defeito(rs.getInt("cod_tp_defeito"));
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
                bObj.setStr_sa(rs.getString("str_sa"));
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
